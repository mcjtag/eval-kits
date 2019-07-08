/**
 * @file dsp.c
 * @brief DSP Driver
 * @author matyunin.d
 * @date 24.06.2019
 */

#include "dsp.h"
#include "nb3n502.h"
#include "../hal/hal.h"
#include <math.h>

#define GET_BIT(BYTE,INDEX) 		((BYTE >> INDEX) & 1)
#define SET_BIT(BYTE,INDEX,BIT)		BYTE = ((BYTE & ~(1<<INDEX)) | ((BIT & 1) << INDEX))

/* Bus frequency multipliers: 100, 80, 60, 40 (MHz) */
static const int mul_tbl[4] = {NB3N502_MULT_5X, NB3N502_MULT_4X, NB3N502_MULT_3X, NB3N502_MULT_2X};

/* Core frequency PLL settings: 450, 400, 300, 200 (MHz) */
static const u8 divf_tbl[4][4] = {{0x11,0x0F,0x17,0x0F}, {0x15, 0x13, 0x1D, 0x13}, {0x1D, 0x1A, 0x27, 0x1A}, {0x2C, 0x27, 0x3B, 0x27}};
static const u8 divq_tbl[4][4] = {{0x1, 0x1, 0x2, 0x2}, {0x1, 0x1, 0x2, 0x2}, {0x1, 0x1, 0x2, 0x2}, {0x1, 0x1, 0x2, 0x2}};
static const u8 range_tbl[4][4] = {{0x6, 0x6, 0x6, 0x6}, {0x5, 0x5, 0x5, 0x5}, {0x4, 0x4, 0x4, 0x4}, {0x4, 0x4, 0x4, 0x4}};

static nb3n502_dev_t cmul;

static void set_pll(u8 divf, u8 divq, u8 range);
static u8 tmp_read_reg(u8 addr, u8 paddr);
static u8 sw_core_freq(void);
static u8 sw_bus_freq(void);

/**
 * @brief DSP initialization
 * @return void
 */
void dsp_init(void)
{
	u8 sw_bf, sw_cf;

	dsp_reset(1);
	timer_delay(&tmr0, 200);
	nb3n502_init(&cmul, XPAR_NB3N502_0_S_AXI_BASEADDR);

	sw_bf = sw_bus_freq();
	sw_cf = sw_core_freq();

	/* Set bus frequency */
	nb3n502_multiplier(&cmul, mul_tbl[sw_bf]);

	/* Set DSP core frequency */
	set_pll(divf_tbl[sw_bf][sw_cf], divq_tbl[sw_bf][sw_cf], range_tbl[sw_bf][sw_cf]);
	timer_delay(&tmr0, 300);
	dsp_reset(0);
}

/**
 * @brief DSP reset
 * @param state Reset state: 1 - reset assert, 0 - reset deassert
 * @return void
 */
void dsp_reset(int state)
{
	if (state) { //
		gpio_write(&dsp_reset_gpio, 0, 0);
		gpio_dir(&dsp_reset_gpio, 0, 0);
	} else {
		gpio_dir(&dsp_reset_gpio, 0, 1);
	}
}

/**
 * @brief Get DSP temperature sensor value
 * @param dsp_id DSP ID number (enum DSP_ID)
 * @return Temperature in celsius
 */
float dsp_get_temp(int dsp_id)
{
	u8 addr = 0x4C;
	u8 data;
	u16 tmp;
	float temp;

	switch (dsp_id) {
	case DSP_ID0:
		addr = 0x4C;
		break;
	case DSP_ID1:
		addr = 0x4D;
		break;
	case DSP_ID2:
		addr = 0x4E;
		break;
	case DSP_ID3:
		addr = 0x4F;
		break;
	}

	data = tmp_read_reg(addr, 0x01);
	tmp = data;
	data = tmp_read_reg(addr, 0x11);
	tmp = (tmp << 4) | (data >> 4);
	tmp |= (tmp >> 12) ? 0xF000 : 0x0000;
	temp = (float)((int)tmp) * 0.0625;

	temp = temp*100.0;
	temp = (temp > (floor(temp)+0.5f)) ? ceil(temp) : floor(temp);
	temp = temp/100.0;

	return temp;
}

/**
 * @brief Get DSP voltage sensor value
 * @param dsp_volt Voltage source (enum DSP_VOLT)
 * @return Voltage in volts
 */
float dsp_get_volt(int dsp_volt)
{
	float volt = 0;
	u16 vdata = 0;
	u8 vadc = 0;

	switch (dsp_volt) {
	case DSP_VOLT_IN:
		vadc = 0;
		break;
	case DSP_VOLT_AN:
		vadc = 1;
		break;
	case DSP_VOLT_IO:
		vadc = 2;
		break;
	}

	spi_set_cs(&vadc_spi, 1 << vadc);
	spi_transfer(&vadc_spi, (u8 *)&vdata, (u8 *)&vdata, 2);
	spi_set_cs(&vadc_spi, 0);
	vdata >>= 2;

	volt = (float)vdata * 3.3 / 4096.0;
	volt = volt*100.0;
	volt = (volt > (floor(volt)+0.5f)) ? ceil(volt) : floor(volt);
	volt = volt/100.0;

	return volt;
}

/**
 * @brief Read temperature sensor register
 * @param addr IC address
 * @param paddr Address of register
 * @return Value of register
 */
static u8 tmp_read_reg(u8 addr, u8 paddr)
{
	u8 data = paddr;
	iic_write(&tmp_iic, addr, &data, 1);
	iic_read(&tmp_iic, addr, &data, 1);
	return data;
}

/**
 * @brief Set PLL settings
 * @param divf DIVF parameter
 * @param divq DIVQ parameter
 * @param range RANGE parameter
 * @return void
 */
static void set_pll(u8 divf, u8 divq, u8 range)
{
	u8 data[2] = {0,0};
	u8 divr = 0;

	SET_BIT(data[0], 0, GET_BIT(range,0));
	SET_BIT(data[0], 1, GET_BIT(range,1));
	SET_BIT(data[0], 2, 1);
	SET_BIT(data[0], 3, GET_BIT(divf,0));
	SET_BIT(data[0], 4, 1);
	SET_BIT(data[0], 5, 0);
	SET_BIT(data[0], 6, 1);
	SET_BIT(data[0], 7, GET_BIT(divf,4));

	SET_BIT(data[1], 0, GET_BIT(divf,5));
	SET_BIT(data[1], 1, GET_BIT(divf,6));
	SET_BIT(data[1], 2, GET_BIT(divf,7));
	SET_BIT(data[1], 3, GET_BIT(divq,0));
	SET_BIT(data[1], 4, 1);
	SET_BIT(data[1], 5, GET_BIT(divq,2));
	SET_BIT(data[1], 6, 0);
	SET_BIT(data[1], 7, 0);

	SET_BIT(divr, 0, GET_BIT(divq,1));
	SET_BIT(divr, 1, GET_BIT(range,2));
	SET_BIT(divr, 2, GET_BIT(divf,1));
	SET_BIT(divr, 3, GET_BIT(divf,2));
	SET_BIT(divr, 4, GET_BIT(divf,3));

	gpio_write(&dsp_pll_divr_gpio, 0, divr);
	iic_write(&exp_iic, 0x24, data, 2);
}

/**
 * @brief Get "Core Frequency" switch value
 * @return value
 */
static u8 sw_core_freq(void)
{
	u32 msk;
	gpio_read(&dsp_core_freq_gpio, 0, &msk);
	return (u8)(msk & 0x3);
}

/**
 * @brief Get "Bus Frequency" switch value
 * @return value
 */
static u8 sw_bus_freq(void)
{
	u32 msk;
	gpio_read(&dsp_bus_freq_gpio, 0, &msk);
	return (u8)(msk & 0x3);
}


