/**
 * @file ADC8.c
 * @brief ADC8 Controller
 * @author matyunin.d
 * @date 06.08.2019
 * @copyright MIT License
 */

#include "adc8.h"
#include "mil_spi.h"
#include "xil_io.h"

/* Register Address */
#define REG_CR_OFFSET 		((u32)0x00)
#define REG_SR_OFFSET		((u32)0x04)
#define REG_DCR_OFFSET 		((u32)0x08)
#define REG_DSR_OFFSET 		((u32)0x0C)
#define REG_ACR_OFFSET 		((u32)0x10)
#define REG_ASR_OFFSET 		((u32)0x14)
#define REG_SMCR_OFFSET 	((u32)0x18)

/* Register Map */
#define REG_CR_RST_MSK		((u32)0x00000001)
#define REG_CR_ESYNC_MSK	((u32)0x00000002)
#define REG_CR_VALID_MSK	((u32)0x00000004)

#define REG_DCR_RST_MSK		((u32)0x00000001)
#define REG_DCR_PD_MSK		((u32)0x00000002)
#define REG_DCR_SYNC_MSK	((u32)0x00000004)
#define REG_DCR_REFS_MSK	((u32)0x00000008)

#define REG_ACR_OEN_MSK		((u32)0x000000FF)
#define REG_ACR_CAL_MSK		((u32)0x0000FF00)
#define REG_ACR_AMD_MSK		((u32)0x00FF0000)
#define REG_ACR_IRS_MSK		((u32)0x01000000)
#define REG_ACR_OEN_POS		((u32)0)
#define REG_ACR_CAL_POS		((u32)8)
#define REG_ACR_AMD_POS		((u32)16)

#define REG_DSR_LD			((u32)0x00000001)
#define REG_ASR_OVF			((u32)0x000000FF)

#define REG_SMCR_MOD_MSK	((u32)0x0000000F)

/* Register Operations */
#define WRITE_REG(base_addr, offset, data) 		Xil_Out32((base_addr) + (offset), (u32)(data))
#define READ_REG(base_addr, offset)				Xil_In32((base_addr) + (offset))

enum SW_MODE {
	SW_MODE_CTRL = 0,
	SW_MODE_ADC_SPI_0 = 1,
	SW_MODE_ADC_SPI_1 = 2,
	SW_MODE_ADC_SPI_2 = 3,
	SW_MODE_ADC_SPI_3 = 4,
	SW_MODE_ADC_SPI_4 = 5,
	SW_MODE_ADC_SPI_5 = 6,
	SW_MODE_ADC_SPI_6 = 7,
	SW_MODE_ADC_SPI_7 = 8,
	SW_MODE_DST_SPI = 9
};

static void ioctl(u32 baseaddr, u32 regaddr, u32 bit_mask, int aff);
static void set_smode(adc8_dev_t *dev, int mode);
static int get_smode(adc8_dev_t *dev);
static void spi_write_reg(u32 baseaddr, u8 addr, u8 data);
static u8 spi_read_reg(u32 baseaddr, u8 addr);

/** 
 * @brief ADC8 initialization
 * @param dev Pointer to device structure
 * @param baseaddr Base address of the device
 * @return XST_SUCCESS | XST_FAILURE
 */
int adc8_init(adc8_dev_t *dev, u32 baseaddr)
{
	struct mil_spi spi;

	if (!dev || !baseaddr)
		return XST_FAILURE;

	dev->baseaddr = baseaddr;
	WRITE_REG(dev->baseaddr, REG_CR_OFFSET, 0);
	WRITE_REG(dev->baseaddr, REG_DCR_OFFSET, 3);
	WRITE_REG(dev->baseaddr, REG_ACR_OFFSET, 0);
	WRITE_REG(dev->baseaddr, REG_SMCR_OFFSET, 0);
	spi.baseaddr = dev->baseaddr;
	mil_spi_init(&spi);

	return XST_SUCCESS;
}

/**
 * @brief Reset controller
 * @param dev Pointer to device structure
 * @param state Reset state (active HIGH)
 * @return void
 */
void adc8_reset(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_CR_OFFSET, REG_CR_RST_MSK, state);
}

/**
 * @brief Check calibration (input receivers)
 * @param dev Pointer to device structure
 * @return 0 - success, otherwise - error
 *
 */
int adc8_calib_done(adc8_dev_t *dev)
{
	return (int)READ_REG(dev->baseaddr, REG_SR_OFFSET);
}

/**
 * @brief Set valid state of output AXI-Stream ports 
 * @param dev Pointer to device structure
 * @param state State (1 - valid)
 * @return void
 */
void adc8_out_valid(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_CR_OFFSET, REG_CR_VALID_MSK, state);
}

/**
 * @brief Set external sync
 * @param dev Pointer to device structure
 * @param state State (1 - use external, 0 - use internal)
 * @return void
 */
void adc8_dst_esync(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_CR_OFFSET, REG_CR_ESYNC_MSK, state);
}

/**
 * @brief Reset ADC8 clock buffer
 * @param dev Pointer to device structure
 * @param state Reset state (active HIGH)
 * @return void
 */
void adc8_dst_reset(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_DCR_OFFSET, REG_DCR_RST_MSK, state);
}

/** 
 * @brief Set ADC8 clock buffer powerdown mode
 * @param dev Pointer to device
 * @param state Powerdown state (active HIGH)
 * @return void
 */
void adc8_dst_powerdown(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_DCR_OFFSET, REG_DCR_PD_MSK, state);
}

/**
 * @brief Set internal sync signal
 * @param dev Pointer to device structure
 * @param state SYNC State (active HIGH)
 * @return void
 */
void adc8_dst_sync(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_DCR_OFFSET, REG_DCR_SYNC_MSK, state);
}

/**
 * @brief Select ADC8 clock buffer reference
 * @param dev Pointer to device structure
 * @param state State of reference
 * @return void
 */
void adc8_dst_refsel(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_DCR_OFFSET, REG_DCR_REFS_MSK, state);
}

/**
 * @brief Get ADC8 clock buffer lock detect state
 * @param dev Pointer to device structure
 * @return lockdetect
 */
int adc8_dst_ld(adc8_dev_t *dev)
{
	return (int)READ_REG(dev->baseaddr, REG_DSR_OFFSET);
}

/**
 * @brief Configure ADC8 clock buffer
 * @param dev Pointer to device device structure
 * @param cfg Pointer to configuration array (36 bytes)
 * @return XST_SUCCESS | XST_FAILURE
 */
int adc8_dst_config(adc8_dev_t *dev, u8 *cfg)
{
	u8 addr;
	u8 data;
	int sw_tmp;
	int err = 0;

	sw_tmp = get_smode(dev);
	set_smode(dev, SW_MODE_DST_SPI);
	addr = 35;
	for (int i = 0; i < 36; i++) {
		spi_write_reg(dev->baseaddr, addr, cfg[addr]);
		addr--;
	}

	addr = 35;
	for (int i = 0; i < 36; i++) {
		data = spi_read_reg(dev->baseaddr, addr);
		if (data != cfg[addr])
			err++;
		addr--;
	}
	set_smode(dev, sw_tmp);
	if (err)
		return XST_FAILURE;

	return XST_SUCCESS;
}

/** 
 * @brief Set ADC8 ADC output enable
 * @param dev Pointer to device structure
 * @param state Output state (active HIGH)
 * @return void
 */
void adc8_adc_out_enable(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_ACR_OFFSET, REG_ACR_OEN_MSK, state);
}

/**
 * @brief Start ADC8 ADC calibration
 * @param dev Pointer to device structure
 * @return void
 */
void adc8_adc_calibrate(adc8_dev_t *dev)
{
	ioctl(dev->baseaddr, REG_ACR_OFFSET, REG_ACR_CAL_MSK, 0);
	for (int i = 0; i < 1000; i++);
	ioctl(dev->baseaddr, REG_ACR_OFFSET, REG_ACR_CAL_MSK, 1);
	for (int i = 0; i < 1000; i++);
	ioctl(dev->baseaddr, REG_ACR_OFFSET, REG_ACR_CAL_MSK, 0);
}

/**
 * @brief Set ADC8 ADC bias mode
 * @param dev Pointer to device structure
 * @param state Bias mode state
 * @return void
 */
void adc8_adc_bias(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_ACR_OFFSET, REG_ACR_AMD_MSK, state);
}

/**
 * @brief Get ADC8 ADC overflow state`
 * @param dev Pointer to device structure
 * @return Overflow mask
 */
u8 adc8_adc_overflow(adc8_dev_t *dev)
{
	return (u8)READ_REG(dev->baseaddr, REG_ASR_OFFSET);
}

/**
 * @brief Reset ADC receivers
 * @param dev Pointer to device
 * @param state Reset state (active HIGH)
 * @return void
 */
void adc8_adc_if_reset(adc8_dev_t *dev, int state)
{
	ioctl(dev->baseaddr, REG_ACR_OFFSET, REG_ACR_IRS_MSK, state);
}

/** 
 * @brief Configure ADC8 ADC
 * @param dev Pointer to device structure
 * @param cfg Pointer to configuration structure
 * @return XST_SUCCESS | XST_FAILURE
 */
int adc8_adc_config(adc8_dev_t *dev, const struct adc_config *cfg)
{
	int sw_tmp;
	int err = 0;
	u8 data;

	sw_tmp =  get_smode(dev);
	for (int i = 0; i < 8; i++) {
		set_smode(dev, SW_MODE_ADC_SPI_0 + i);
		spi_write_reg(dev->baseaddr, 0x2A, cfg->out_mode);
	}
	for (int i = 0; i < 8; i++) {
		set_smode(dev, SW_MODE_ADC_SPI_0 + i);
		data = spi_read_reg(dev->baseaddr, 0x2A);
		if (data != cfg->out_mode)
			err++;
	}
	set_smode(dev, sw_tmp);
	if (err)
		return XST_FAILURE;

	return XST_SUCCESS;
}

/**
 * @brief SPI write register
 * @param baseaddr Base address
 * @param addr Register address
 * @param data Register data
 * @return void
 */
static void spi_write_reg(u32 baseaddr, u8 addr, u8 data)
{
	struct mil_spi spi = {baseaddr, 0};

	mil_spi_cs_enable(&spi);
	mil_spi_read_write(&spi, ((((u16)(0x00 | (addr & 0x7F))) << 8) | data));
	mil_spi_cs_disable(&spi);
}

/**
 * @brief SPI read register
 * @param baseaddr Base address
 * @param addr Register address
 * @return Register data
 */
static u8 spi_read_reg(u32 baseaddr, u8 addr)
{
	struct mil_spi spi = {baseaddr, 0};
	u8 data;

	mil_spi_cs_enable(&spi);
	data = mil_spi_read_write(&spi, ((((u16)(0x80 | (addr & 0x7F))) << 8) | 0x00));
	mil_spi_cs_disable(&spi);

	return data;
}

/**
 * @brief IO Control
 * @param baseaddr Base address
 * @param regaddr Register address
 * @param bit_mask Bit mask
 * @param aff Affiliated flag
 * @return void
 */
static void ioctl(u32 baseaddr, u32 regaddr, u32 bit_mask, int aff)
{
	u32 tmp;
	tmp = READ_REG(baseaddr, regaddr);
	tmp = (aff) ? tmp | bit_mask : tmp & ~bit_mask;
	WRITE_REG(baseaddr, regaddr, tmp);
}

/**
 * @brief Set SPI switch mode
 * @param dev Pointer to device structure
 * @param mode Switch mode
 * @return void
 */
static void set_smode(adc8_dev_t *dev, int mode)
{
	WRITE_REG(dev->baseaddr, REG_SMCR_OFFSET, REG_SMCR_MOD_MSK & mode);
}

/**
 * @brief Get SPI switch mode
 * @param dev Pointer to device structure
 * @return mode
 */
static int get_smode(adc8_dev_t *dev)
{
	return (int)READ_REG(dev->baseaddr, REG_SMCR_OFFSET);
}
