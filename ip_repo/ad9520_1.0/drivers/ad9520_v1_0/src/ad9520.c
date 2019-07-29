/**
 * @file ad9520.c
 * @brief AD9520 Controller
 * @author matyunin.d
 * @date 26.03.2019
 * @copyright MIT License
 */

#include "ad9520.h"
#include "ad9520_spi.h"
#include "xil_io.h"

#define DEVICE_MAX			8
#define DEVICE_MSK			0xFF

/* Register Address */
#define REG_CR_OFFSET 		((u32)0x00)
#define REG_IOCR_OFFSET 	((u32)0x04)
#define REG_IOSR_OFFSET		((u32)0x08)

/* Register Map */
#define REG_CR_RST_MSK		((u32)0x00000001)
#define REG_CR_ESYNC_MSK	((u32)0x00000002)
#define REG_IOCR_RESET_MSK	((u32)0x000000FF)
#define REG_IOCR_PD_MSK		((u32)0x0000FF00)
#define REG_IOCR_EEPROM_MSK	((u32)0x00FF0000)
#define REG_IOCR_SYNC_MSK	((u32)0xFF000000)
#define REG_IOCR_RESET_POS	((u32)0)
#define REG_IOCR_PD_POS		((u32)8)
#define REG_IOCR_EEPROM_POS	((u32)16)
#define REG_IOCR_SYNC_POS	((u32)24)
#define REG_IOSR_REFMON_MSK	((u32)0x000000FF)
#define REG_IOSR_LD_MSK		((u32)0x0000FF00)
#define REG_IOSR_STATUS_MSK	((u32)0x00FF0000)
#define REG_IOSR_REFMON_POS	((u32)0)
#define REG_IOSR_LD_POS		((u32)8)
#define	REG_IOSR_STATUS_POS	((u32)16)

/* Register Operations */
#define write_reg(base_addr, offset, data) 	Xil_Out32((base_addr) + (offset), (u32)(data))
#define read_reg(base_addr, offset)			Xil_In32((base_addr) + (offset))

enum AD9520_IO_SIG {
	AD9520_IO_RESET,
	AD9520_IO_POWERDOWN,
	AD9520_IO_EEPROM,
	AD9520_IO_SYNC,
	AD9520_IO_REFMON,
	AD9520_IO_LD,
	AD9520_IO_STATUS
};

enum AD9520_IO_OP {
	AD9520_IO_READ,
	AD9520_IO_WRITE
};

static u8 get_spidev(int devmsk);
static int ioctl(ad9520_dev_t *dev, int io_sig, int io_op, int state, int dev_msk);

/**
 * @brief AD9520 Device Init
 * @param dev Pointer to device
 * @param baseaddr Base device address
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_init(ad9520_dev_t *dev, u32 baseaddr)
{
	struct ad9520_spi spi;

	if (!dev || !baseaddr)
		return XST_FAILURE;

	dev->baseaddr = baseaddr;
	write_reg(dev->baseaddr, REG_CR_OFFSET, 4);

	ad9520_ioc_reset(dev, AD9520_DEV_ALL, AD9520_ENABLE);
	ad9520_ioc_powerdown(dev, AD9520_DEV_ALL, AD9520_ENABLE);
	spi.baseaddr = dev->baseaddr;
	ad9520_spi_init(&spi);

	return XST_SUCCESS;
}

/**
 * @brief AD9520 Check ID
 * @param dev Pointer to device
 * @param dev_num Device number (AD9520_DEV)
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_checkid(ad9520_dev_t *dev, int dev_num)
{
	struct ad9520_spi spi;
	u8 id = 0;

	if (!dev)
		return XST_FAILURE;

	spi.baseaddr = dev->baseaddr;
	spi.dev_num = get_spidev(dev_num);
	ad9520_spi_write(&spi, AD9520_REG_SERIAL_PORT_CONFIG, AD9520_SDO_ACTIVE_SDO_SDIO | AD9520_LSB_FIRST_ADDR_INC_MSB_DEC);
	id = ad9520_spi_read(&spi, AD9520_REG_PART_ID);

	if (id == AD9520_4)
		return XST_SUCCESS;

	return XST_FAILURE;
}

/**
 * @brief AD9520 RESET signal control
 * @param dev Pointer to device
 * @param dev_mask Device mask (AD9520_DEV)
 * @param state New state (AD9520_STATE)
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_ioc_reset(ad9520_dev_t *dev, int dev_mask, int state)
{
	if (dev && dev->baseaddr) {
		ioctl(dev, AD9520_IO_RESET, AD9520_IO_WRITE, state, dev_mask & DEVICE_MSK);
		return XST_SUCCESS;
	} else {
		return XST_FAILURE;
	}
}

/**
 * @brief AD9520 PD signal control
 * @param dev Pointer to device
 * @param dev_mask Device mask (AD9520_DEV)
 * @param state New state (AD9520_STATE)
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_ioc_powerdown(ad9520_dev_t *dev, int dev_mask, int state)
{
	if (dev && dev->baseaddr) {
		ioctl(dev, AD9520_IO_POWERDOWN, AD9520_IO_WRITE, state, dev_mask & DEVICE_MSK);
		return XST_SUCCESS;
	} else {
		return XST_FAILURE;
	}
}

/**
 * @brief AD9520 EEPROM signal control
 * @param dev Pointer to device
 * @param dev_mask Device mask (AD9520_DEV)
 * @param state New state (AD9520_STATE)
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_ioc_eeprom(ad9520_dev_t *dev, int dev_mask, int state)
{
	if (dev && dev->baseaddr) {
		ioctl(dev, AD9520_IO_EEPROM, AD9520_IO_WRITE, state, dev_mask & DEVICE_MSK);
		return XST_SUCCESS;
	} else {
		return XST_FAILURE;
	}
}

/**
 * @brief AD9520 SYNC signal control
 * @param dev Pointer to device
 * @param dev_mask Device mask (AD9520_DEV)
 * @param state New state (AD9520_STATE)
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_ioc_sync(ad9520_dev_t *dev, int dev_mask, int state)
{
	if (dev && dev->baseaddr) {
		ioctl(dev, AD9520_IO_SYNC, AD9520_IO_WRITE, state, dev_mask & DEVICE_MSK);
		return XST_SUCCESS;
	} else {
		return XST_FAILURE;
	}
}

/**
 * @brief AD9520 External SYNC source control
 * @param dev Pointer to device
 * @param state New state (AD9520_STATE)
 * @return XST_SUCCESS
 */
XStatus ad9520_ext_sync(ad9520_dev_t *dev, int state)
{
	u32 tmp;

	tmp = read_reg(dev->baseaddr, REG_CR_OFFSET);
	if (state == AD9520_ENABLE) {
		tmp |= REG_CR_ESYNC_MSK;
	} else if (state == AD9520_DISABLE) {
		tmp &= ~REG_CR_ESYNC_MSK;
	}
	write_reg(dev->baseaddr, REG_CR_OFFSET, tmp);
	
	return XST_SUCCESS; 
}

/**
 * @brief AD9520 Acquire REFMON signal value
 * @param dev Pointer to device
 * @param value Pointer to value
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_ios_refmon(ad9520_dev_t *dev, int *value)
{
	if (dev && dev->baseaddr && value) {
		*value = ioctl(dev, AD9520_IO_REFMON, AD9520_IO_READ, -1, 0);
		return XST_SUCCESS;
	} else {
		return XST_FAILURE;
	}
}

/**
 * @brief AD9520 Acquire LD signal value
 * @param dev Pointer to device
 * @param value Pointer to value
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_ios_ld(ad9520_dev_t *dev, int *value)
{
	if (dev && dev->baseaddr && value) {
		*value = ioctl(dev, AD9520_IO_LD, AD9520_IO_READ, -1, 0);
		return XST_SUCCESS;
	} else {
		return XST_FAILURE;
	}
}

/**
 * @brief AD9520 Acquire STATUS signal value
 * @param dev Pointer to device
 * @param value Pointer to value
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_ios_status(ad9520_dev_t *dev, int *value)
{
	if (dev && dev->baseaddr && value) {
		*value = ioctl(dev, AD9520_IO_STATUS, AD9520_IO_READ, -1, 0);
		return XST_SUCCESS;
	} else {
		return XST_FAILURE;
	}
}

/**
 * @brief Write configuration to AD9520 device
 * @param dev Pointer to device
 * @param dev_num Device number
 * @param cfg Pointer to configuration
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus ad9520_write_config(ad9520_dev_t *dev, int dev_num, const struct ad9520_config *cfg)
{
	struct ad9520_spi spi;

	if (!dev || !cfg)
		return XST_FAILURE;

	spi.baseaddr = dev->baseaddr;
	spi.dev_num = get_spidev(dev_num);
	for (; cfg->addr != -1; cfg++) {
		ad9520_spi_write(&spi, (u16)(cfg->addr & 0xFFFF), cfg->value);
	}
	
	return XST_SUCCESS;
}

/**
 * @brief AD9520 IO Control
 * @param dev Pointer to device
 * @param io_sig IO signal (AD9520_IO_SIG)
 * @param io_op IO operation (AD9520_IO_OP)
 * @param state New state (AD9520_STATE)
 * @param dev_msk Device mask (AD9520_DEV)
 * @return IO state value (read) | 0 (write)
 */
static int ioctl(ad9520_dev_t *dev, int io_sig, int io_op, int state, int dev_msk)
{
	u32 reg, pos, msk, tmp;

	switch (io_sig) {
	case AD9520_IO_RESET:
		reg = REG_IOCR_OFFSET;
		pos = REG_IOCR_RESET_POS;
		msk = REG_IOCR_RESET_MSK;
		break;
	case AD9520_IO_POWERDOWN:
		reg = REG_IOCR_OFFSET;
		pos = REG_IOCR_PD_POS;
		msk = REG_IOCR_PD_MSK;
		break;
	case AD9520_IO_EEPROM:
		reg = REG_IOCR_OFFSET;
		pos = REG_IOCR_EEPROM_POS;
		msk = REG_IOCR_EEPROM_MSK;
		break;
	case AD9520_IO_SYNC:
		reg = REG_IOCR_OFFSET;
		pos = REG_IOCR_SYNC_POS;
		msk = REG_IOCR_SYNC_MSK;
		break;
	case AD9520_IO_REFMON:
		reg = REG_IOSR_OFFSET;
		pos = REG_IOSR_REFMON_POS;
		msk = REG_IOSR_REFMON_MSK;
		break;
	case AD9520_IO_LD:
		reg = REG_IOSR_OFFSET;
		pos = REG_IOSR_LD_POS;
		msk = REG_IOSR_LD_MSK;
		break;
	case AD9520_IO_STATUS:
		reg = REG_IOSR_OFFSET;
		pos = REG_IOSR_STATUS_POS;
		msk = REG_IOSR_STATUS_MSK;
		break;
	default:
		reg = 0;
		pos = 0;
		msk = 0;
	}

	if (io_op == AD9520_IO_READ) {
		return (((read_reg(dev->baseaddr, reg)) & msk) >> pos);
	} else if (io_op == AD9520_IO_WRITE) {
		tmp = read_reg(dev->baseaddr, reg);

		if (state == AD9520_ENABLE) {
			tmp |= ((dev_msk << pos) & msk);
		} else if (state == AD9520_DISABLE) {
			tmp &= ~((dev_msk << pos) & msk);
		}
		write_reg(dev->baseaddr, reg, tmp);
	}

	return 0;
}

/**
 * @brief Get SPI device number from AD9520_DEV
 * @param dev_num Device number (AD9520_DEV)
 * @return SPI device number
 */
static u8 get_spidev(int dev_num)
{
	switch (dev_num) {
	case AD9520_DEV_0: return 0;
	case AD9520_DEV_1: return 1;
	case AD9520_DEV_2: return 2;
	case AD9520_DEV_3: return 3;
	case AD9520_DEV_4: return 4;
	case AD9520_DEV_5: return 5;
	case AD9520_DEV_6: return 6;
	case AD9520_DEV_7: return 7;
	default: return 0;
	}
}
