/**
 * @file adc.c
 * @brief
 * @author matyunin.d
 * @date 22.02.2018
 */

#include "adc.h"
#include "ada.h"
#include "5101HB015.h"
#include "5101HB015_SPI_1967VC3.h"
#include "system/cpu_defs.h"
#include "periph/dmar.h"
#include "utils/tcb.h"
#include "config.h"
#include <stdio.h>
#include <string.h>

// LRCTL RAW
#define LR0CTL_0_RAW	(0)
#define LR0CTL_1_RAW	((2<<4)|(0<<11)|(1<<12)|(1<<14)|(1<<15)|(0<<16))
#define LR0CTL_2_RAW	(1 | LR0CTL_1_RAW)
#define LR1CTL_0_RAW	(0)
#define LR1CTL_1_RAW	((2<<4)|(0<<11)|(1<<12)|(1<<14)|(1<<15)|(1<<16))
#define LR1CTL_2_RAW	(1 | LR1CTL_1_RAW)

// LRCTL DDC
#define LR0CTL_0_DDC	(0)
#define LR0CTL_1_DDC	((2<<4)|(1<<11)|(1<<12)|(1<<14)|(1<<15)|(0<<16))
#define LR0CTL_2_DDC	(1 | LR0CTL_1_DDC)
#define LR1CTL_0_DDC	(0)
#define LR1CTL_1_DDC	((2<<4)|(1<<11)|(1<<12)|(1<<14)|(1<<15)|(1<<16))
#define LR1CTL_2_DDC	(1 | LR1CTL_1_DDC)

#define LRCTL_ADDR		(0x800000E0)

enum ADC_MODE {
	ADC_MODE_NONE,
	ADC_MODE_RAW,
	ADC_MODE_DDC
};

static const uint32_t lr_addr[CONFIG_ADC_CHAN] = {0x800000E0, 0x800000E1};
static const uint32_t tcb_addr_raw[CONFIG_ADC_CHAN] = {0x80000040, 0x80000044};
static const uint32_t tcb_addr_ddc[CONFIG_ADC_CHAN] = {0x80000048, 0x8000004C};
static const int dma_chan_raw[CONFIG_ADC_CHAN] = {8, 9};
static const int dma_chan_ddc[CONFIG_ADC_CHAN] = {10, 11};
static uint32_t lr_ini[CONFIG_ADC_CHAN][3] = {{0, 0, 0},{0, 0, 0}};
static int adc_mode[CONFIG_ADC_CHAN] = {0,0};
static int adc_dmar[CONFIG_ADC_CHAN] = {0,0};
static const int adc_offset_raw = 512;
static const int adc_offset_ddc = 16;

#pragma align(4)
section ("data10a") 
static uint32_t adc0_data[CONFIG_ADC_BUFLEN];
#pragma align(4)
section ("data10a") 
static uint32_t adc1_data[CONFIG_ADC_BUFLEN];
#pragma align(4)
static __builtin_quad tcb_link[CONFIG_ADC_CHAN][2];
#pragma align(4)
static __builtin_quad tcb_adc[CONFIG_ADC_CHAN];
#pragma align(4)
static __builtin_quad tcb_dma_start[CONFIG_ADC_CHAN][2];

static struct dmar_chain dmar0_chain;

static int adc_rdy[CONFIG_ADC_CHAN] = {0, 0};
static int irq_active[CONFIG_ADC_CHAN] = {0, 0};
static void dma_init(int dma_chan, unsigned int handler, RxDmaRequest request);
static void dmar0_init(void);
static void irq0_handler(void);
static void irq1_handler(void);
static void irq_handler(int chan);
static int to_int(uint32_t val);

/**
 * @brief ADC initialization
 * @return void
 */
void adc_init(void)
{
	ADC5101HB015_config_t adc_cfg;
	ADC5101HB015_hw_config_t adc_spi_cfg[2];

	// Channel #0
	adc_spi_cfg[0].port = LX_PortC;
	adc_spi_cfg[0].cs_bit = (1 << 2);			// FLAG[2]
	adc_spi_cfg[0].clk_bit = (1 << 0);			// FLAG[0]
	adc_spi_cfg[0].mosi_bit = (1 << 3);			// FLAG[3]
	adc_spi_cfg[0].miso_bit = (1 << 3);
	adc_spi_cfg[0].power_down_bit = (1 << 24);	// L0ACKO
	adc_spi_cfg[0].core_freq_khz = CONFIG_PLL_CORE_FREQ_KHZ;
	// Channel #1
	adc_spi_cfg[1].port = LX_PortC;
	adc_spi_cfg[1].cs_bit = (1 << 2);			// FLAG[2]
	adc_spi_cfg[1].clk_bit = (1 << 1);			// FLAG[1]
	adc_spi_cfg[1].mosi_bit = (1 << 3);			// FLAG[3]
	adc_spi_cfg[1].miso_bit = (1 << 3);
	adc_spi_cfg[1].power_down_bit = (1 << 28);	// L1ACKO
	adc_spi_cfg[1].core_freq_khz = CONFIG_PLL_CORE_FREQ_KHZ;

	adc_cfg.reference_level = ADC5101HB015_REF_1P0;
	adc_cfg.output_format = ADC5101HB015_OUTPUT_LVDS;
	adc_cfg.lvdsen_pin_state = ADC5101HB015_LVDSEN_PIN_HIGH;
	adc_cfg.lvds_current_mode = ADC5101HB015_LVDS_CURRENT_NORMAL;
	adc_cfg.oen_pin_override = ADC5101HB015_OEN_OVERRIDE;
	adc_cfg.common_mode_sel = ADC5101HB015_COMMON_MODE_0P75;

	ADC5101HB015_init(1, 1, &adc_spi_cfg[0]);
	ADC5101HB015_config(&adc_cfg);
	ADC5101HB015_init(1, 1, &adc_spi_cfg[1]);
	ADC5101HB015_config(&adc_cfg);
}

/**
 * @brief ADC configuration
 * @param cfg Pointer to configuration structure
 * @return void
 */
void adc_conf(const struct adc_config *cfg)
{
	uint32_t flag;
	uint32_t ada_cfg;
	uint32_t ada_x;
	uint32_t fstep;
	uint32_t flen;
	uint64_t ada_rcnt_step;
	uint32_t adc_data = (cfg->chan == ADC_0) ? (uint32_t)adc0_data : (uint32_t)adc1_data;
	uint32_t irq = (cfg->chan == ADC_0) ? (uint32_t)irq0_handler : (uint32_t)irq1_handler;

	if (!cfg)
		return;

	if (!cfg->samples) {
		adc_mode[cfg->chan] = ADC_MODE_NONE;
	} else {
		if (!cfg->df)
			adc_mode[cfg->chan] = ADC_MODE_RAW;
		else
			adc_mode[cfg->chan] = ADC_MODE_DDC;
	}
	adc_dmar[cfg->chan] = cfg->dmar;

	if (cfg->chan == ADC_0)
		__builtin_sysreg_write(__LRCTL0, 0);
	else
		__builtin_sysreg_write(__LRCTL1, 0);

	memset((void *)adc_data, 0, CONFIG_ADC_BUFLEN);

	switch (adc_mode[cfg->chan]) {
	case ADC_MODE_NONE:
		lr_ini[cfg->chan][0] = 0;
		lr_ini[cfg->chan][1] = 0;
		lr_ini[cfg->chan][2] = 0;
		tcb_adc[cfg->chan] = __builtin_compose_128(0, 0);
		break;
	case ADC_MODE_RAW:
		lr_ini[cfg->chan][0] = (cfg->chan == ADC_0) ? LR0CTL_0_RAW : LR1CTL_0_RAW;
		lr_ini[cfg->chan][1] = (cfg->chan == ADC_0) ? LR0CTL_1_RAW : LR1CTL_1_RAW;
		lr_ini[cfg->chan][2] = (cfg->chan == ADC_0) ? LR0CTL_2_RAW : LR1CTL_2_RAW;
		dma_init(dma_chan_raw[cfg->chan], irq, RxDmaReq_Default);
		flag = TCB_INTMEM | TCB_QUAD | TCB_HPRIORITY | TCB_INT;
		TCB_DI(tcb_adc[cfg->chan], adc_data);
		TCB_DX(tcb_adc[cfg->chan], 4, cfg->samples / 2 + adc_offset_raw);
		TCB_DY(tcb_adc[cfg->chan], 0);
		TCB_DP(tcb_adc[cfg->chan], flag, 0, 0);
		break;
	case ADC_MODE_DDC:
		lr_ini[cfg->chan][0] = (cfg->chan == ADC_0) ? LR0CTL_0_DDC : LR1CTL_0_DDC;
		lr_ini[cfg->chan][1] = (cfg->chan == ADC_0) ? LR0CTL_1_DDC : LR1CTL_1_DDC;
		lr_ini[cfg->chan][2] = (cfg->chan == ADC_0) ? LR0CTL_2_DDC : LR1CTL_2_DDC;
		dma_init(dma_chan_ddc[cfg->chan], irq, (cfg->chan == ADC_0) ? RxDmaReq_Ada0 : RxDmaReq_Ada2);
		flag = TCB_INTMEM | TCB_QUAD | TCB_HPRIORITY | TCB_INT;
		TCB_DI(tcb_adc[cfg->chan], adc_data);
		TCB_DX(tcb_adc[cfg->chan], 4, cfg->samples + adc_offset_ddc);
		TCB_DY(tcb_adc[cfg->chan], 0);
		TCB_DP(tcb_adc[cfg->chan], flag, 0, 0);
		fstep = cfg->fhet ? HAL_DDC_GetFreqTableStep(CONFIG_ADC_FS, cfg->fhet) : 0;
		switch (cfg->flen) {
		case 3:
			flen = ADACR_FLEN3;
			break;
		case 5:
			flen = ADACR_FLEN5;
			break;
		case 7:
			flen = ADACR_FLEN7;
			break;
		default:
			flen = ADACR_FLEN5;
		}

		ada_cfg = ADACR_EN | ADACR_LINK;
		ada_cfg |= (cfg->chan == ADC_0) ? ADACR_LINK0 : ADACR_LINK1;
		ada_cfg |= flen;
		ada_cfg |= (cfg->shift << ADACR_SHFR_P);
		ada_cfg |= ((cfg->df / 2 - 1) << ADACR_KDELAY_P);
		ada_cfg |= ADACR_FREQHOP;
		ada_x = ADAXCR_L1 | ADAXCR_SYNC | ADAXCR_RESET | ADAXCR_DMA;
		ada_x |= ADAXCR_CLRA_SC | ADAXCR_CLRA_ADD | ADAXCR_CLRA_SUB;
		ada_rcnt_step = (cfg->samples + adc_offset_ddc) / 4;
		ada_rcnt_step = (ada_rcnt_step << 32) | fstep;
		if (cfg->chan == ADC_0) {
			REG_WRITE32(ADA0CR_LOC, 0);
			REG_WRITE64(ADA0RCNT_LOC, ada_rcnt_step);
			REG_WRITE32(ADA0XCR_LOC, ada_x);
			REG_WRITE32(ADA0CR_LOC, ada_cfg);
		} else {
			REG_WRITE32(ADA2CR_LOC, 0);
			REG_WRITE64(ADA2RCNT_LOC, ada_rcnt_step);
			REG_WRITE32(ADA2XCR_LOC, ada_x);
			REG_WRITE32(ADA2CR_LOC, ada_cfg);
		}
		break;
	}

	if (adc_dmar[cfg->chan]) {
		dmar0_init();
	} else {
		if (cfg->chan == ADC_0) {
			__builtin_sysreg_write(__LRCTL0, lr_ini[cfg->chan][0]);
			__builtin_sysreg_write(__LRCTL0, lr_ini[cfg->chan][1]);
			__builtin_sysreg_write(__LRCTL0, lr_ini[cfg->chan][2]);
		} else {
			__builtin_sysreg_write(__LRCTL1, lr_ini[cfg->chan][0]);
			__builtin_sysreg_write(__LRCTL1, lr_ini[cfg->chan][1]);
			__builtin_sysreg_write(__LRCTL1, lr_ini[cfg->chan][2]);
		}
	}
}

/**
 * @brief Get ADC ready state
 * @param chan ADC channel (0, 1)
 * @return 1 - ready, 0 - busy
 */
int adc_ready(int chan)
{
	return adc_rdy[chan];
}

/**
 * @brief Get ADCs ready
 * @return 1 - ready, 0 - busy
 */
int adc_ready_all(void)
{
	return adc_rdy[ADC_0] && adc_rdy[ADC_1];
}

void adc_ready_clear(void)
{
	adc_rdy[ADC_0] = 0;
	adc_rdy[ADC_1] = 0;
}

/**
 * @brief Read ADC data
 * @param chan Channel number
 * @param data Pointer to data array
 * @param len Length of array
 * @return void
 */
void adc_read(int chan, float *data, uint16_t len)
{
	uint32_t *adc_data[] = {adc0_data, adc1_data};
	int i;
	int offset = 0;

	switch (adc_mode[chan]) {
	case ADC_MODE_RAW:
		offset = adc_offset_raw;
		break;
	case ADC_MODE_DDC:
		offset = adc_offset_ddc;
		break;
	default:
		offset = 0;
	}

	if (adc_mode[chan] == ADC_MODE_RAW) {
		for (i = 0; i < len; i++)
			data[i] = ((float)to_int((adc_data[chan][offset + i / 2] >> (i & 1 ? 16 : 0)) & 0x0000FFFF)) / 32768.0;
	} else if (adc_mode[chan] == ADC_MODE_DDC) {
		for (i = 0; i < len; i++)
			data[i] = ((float)to_int(adc_data[chan][offset + i])) / 32768.0;
	}
	adc_rdy[chan] = 0;
}

/**
 * @brief Manual start ADC capture (if not DMAR is used)
 * @param chan Channel number
 * @return void
 */
void adc_start(int chan)
{
	switch (adc_mode[chan]) {
	case ADC_MODE_RAW:
		HAL_DMA_WriteDC(dma_chan_raw[chan], &tcb_adc[chan]);
		break;
	case ADC_MODE_DDC:
		HAL_DMA_WriteDC(dma_chan_ddc[chan], &tcb_adc[chan]);
		break;
	}
}

/**
 * @bried DMA initialization
 * @param dma_chan DMA channel
 * @param handler Interrupt handler address
 * @param request DMA request source
 * @return void
 */
static void dma_init(int dma_chan, unsigned int handler, RxDmaRequest request)
{
	HAL_DMA_Stop(dma_chan);
	HAL_DMA_GetChannelStatusClear(dma_chan);
	HAL_DMA_ClearInterruptRequest(dma_chan);
	HAL_DMA_SetInterruptVector(dma_chan, handler);
	HAL_DMA_SetInterruptMask(dma_chan, 1);
	HAL_DMA_SetRxRequestSource(dma_chan, request);
}

/**
 * @brief DMAR channel #0 initialization
 * @return void
 */
static void dmar0_init(void)
{
	uint32_t flag;
	// LINK Reset
	flag = TCB_INTMEM | TCB_NORMAL | TCB_HPRIORITY | TCB_CHAIN;
	TCB_DI(tcb_link[ADC_0][DCS], lr_ini[ADC_0]);
	TCB_DX(tcb_link[ADC_0][DCS], 1, 3);
	TCB_DY(tcb_link[ADC_0][DCS], 0);
	TCB_DP(tcb_link[ADC_0][DCS], flag, 0, (uint32_t)&tcb_link[ADC_1][DCS]);
	flag = TCB_EXTMEM | TCB_NORMAL | TCB_HPRIORITY | TCB_CHAIN;
	TCB_DI(tcb_link[ADC_0][DCD], lr_addr[ADC_0]);
	TCB_DX(tcb_link[ADC_0][DCD], 0, 3);
	TCB_DY(tcb_link[ADC_0][DCD], 0);
	TCB_DP(tcb_link[ADC_0][DCD], flag, 0, (uint32_t)&tcb_link[ADC_1][DCD]);
	flag = TCB_INTMEM | TCB_NORMAL | TCB_HPRIORITY | TCB_CHAIN;
	TCB_DI(tcb_link[ADC_1][DCS], lr_ini[ADC_1]);
	TCB_DX(tcb_link[ADC_1][DCS], 1, 3);
	TCB_DY(tcb_link[ADC_1][DCS], 0);
	TCB_DP(tcb_link[ADC_1][DCS], flag, 0, (uint32_t)&tcb_dma_start[ADC_0][DCS]);
	flag = TCB_EXTMEM | TCB_NORMAL | TCB_HPRIORITY | TCB_CHAIN;
	TCB_DI(tcb_link[ADC_1][DCD], lr_addr[ADC_1]);
	TCB_DX(tcb_link[ADC_1][DCD], 0, 3);
	TCB_DY(tcb_link[ADC_1][DCD], 0);
	TCB_DP(tcb_link[ADC_1][DCD], flag, 0, (uint32_t)&tcb_dma_start[ADC_0][DCD]);

	// ADC0 Start
	flag = TCB_INTMEM | TCB_QUAD | TCB_HPRIORITY | TCB_CHAIN;
	TCB_DI(tcb_dma_start[ADC_0][DCS], &tcb_adc[ADC_0]);
	TCB_DX(tcb_dma_start[ADC_0][DCS], 0, 4);
	TCB_DY(tcb_dma_start[ADC_0][DCS], 0);
	TCB_DP(tcb_dma_start[ADC_0][DCS], flag, 0, (uint32_t)&tcb_dma_start[ADC_1][DCS]);
	flag = TCB_EXTMEM | TCB_QUAD | TCB_HPRIORITY | TCB_CHAIN;
	TCB_DI(tcb_dma_start[ADC_0][DCD], (adc_mode[ADC_0] == ADC_MODE_DDC) ? tcb_addr_ddc[ADC_0] : tcb_addr_raw[ADC_0]);
	TCB_DX(tcb_dma_start[ADC_0][DCD], 0, 4);
	TCB_DY(tcb_dma_start[ADC_0][DCD], 0);
	TCB_DP(tcb_dma_start[ADC_0][DCD], flag, 0, (uint32_t)&tcb_dma_start[ADC_1][DCD]);

	// ADC1 Start
	flag = TCB_INTMEM | TCB_QUAD | TCB_HPRIORITY;
	TCB_DI(tcb_dma_start[ADC_1][DCS], &tcb_adc[ADC_1]);
	TCB_DX(tcb_dma_start[ADC_1][DCS], 0, 4);
	TCB_DY(tcb_dma_start[ADC_1][DCS], 0);
	TCB_DP(tcb_dma_start[ADC_1][DCS], flag, 0, 0);
	flag = TCB_EXTMEM | TCB_QUAD | TCB_HPRIORITY;
	TCB_DI(tcb_dma_start[ADC_1][DCD], (adc_mode[ADC_1] == ADC_MODE_DDC) ? tcb_addr_ddc[ADC_1] : tcb_addr_raw[ADC_1]);
	TCB_DX(tcb_dma_start[ADC_1][DCD], 0, 4);
	TCB_DY(tcb_dma_start[ADC_1][DCD], 0);
	TCB_DP(tcb_dma_start[ADC_1][DCD], flag, 0, 0);

	dmar0_chain.dcs = &tcb_link[ADC_0][DCS];
	dmar0_chain.dcd = &tcb_link[ADC_0][DCD];
	dmar_start(DMAR_0, NULL, &dmar0_chain);
}

/**
 * @brief ADC channel #0 interrupt
 * @return void
 */
#pragma interrupt
static void irq0_handler(void)
{
	irq_active[ADC_0] = 1;
	irq_handler(ADC_0);
}

/**
 * @brief ADC channel #1 interrupt
 * @return void
 */
#pragma interrupt
static void irq1_handler(void)
{
	irq_active[ADC_1] = 1;
	irq_handler(ADC_1);
}

static void irq_handler(int chan)
{
	adc_rdy[chan] = 1;

	if (adc_mode[ADC_0] == ADC_MODE_NONE)
		irq_active[ADC_0] = 1;
	if (adc_mode[ADC_1] == ADC_MODE_NONE)
		irq_active[ADC_1] = 1;

	if (irq_active[ADC_0] && irq_active[ADC_1]) {
		irq_active[ADC_0] = 0;
		irq_active[ADC_1] = 0;
		if (adc_dmar[ADC_0] || adc_dmar[ADC_1])
			dmar_restart(DMAR_0);
	}
}

static int to_int(uint32_t val)
{
	if (val & 0x8000)
		val |= 0xFFFF0000;

	return (int)val;
} 
