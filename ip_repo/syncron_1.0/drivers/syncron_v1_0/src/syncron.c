/**
 * @file syncron.c
 * @brief Syncronizer
 * @author matyunin.d
 * @date 23.01.2018
 * @copyright MIT License
 */

#include "syncron.h"
#include "xil_io.h"

#define REG_CR_OFFSET 		0
#define REG_SIR_OFFSET		4

#define REG_CR_MUX			(1 << 0)

#define REG_SIR_CLK			(1 << 0)
#define REG_SIR_CAP			(1 << 1)
#define REG_SIR_LNK			(1 << 2)
#define REG_SIR_RAW			(1 << 3)

#define write_reg(baseaddr, offset, data)		Xil_Out32((baseaddr) + (offset), (u32)(data))
#define read_reg(baseaddr, offset)				Xil_In32((baseaddr) + (offset))

/**
 * @brief Syncron initialization
 * @param dev Pointer to device
 * @param baseaddr Base address of device
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus syncron_init(syncron_dev_t *dev, u32 baseaddr)
{
	if (!dev || !baseaddr)
		return XST_FAILURE;

	dev->baseaddr = baseaddr;

	return XST_SUCCESS;
}

/**
 * @brief Syncronization source selection
 * @param dev Pointer to device
 * @param source Source (SYNCRON_SOURCE)
 * @return void
 */
void syncron_set_source(syncron_dev_t *dev, int source)
{
	u32 tmp;

	if (!dev)
		return;

	tmp = read_reg(dev->baseaddr, REG_CR_OFFSET);
	switch (source) {
	case SYNCRON_SOURCE_INTERNAL:
		tmp &= ~(REG_CR_MUX);
		break;
	case SYNCRON_SOURCE_EXTERNAL:
		tmp |= (REG_CR_MUX);
		break;
	default:
		return;
	}
	write_reg(dev->baseaddr, REG_CR_OFFSET, tmp);
}

/**
 * @brief Initiate syncronization
 * @param dev Pointer to device
 * @param sync Syncronization type (SYNCRON_SYNC)
 * @return void
 */
void syncron_sync(syncron_dev_t *dev, int sync)
{
	if (!dev)
		return;

	switch(sync) {
	case SYNCRON_SYNC_CLOCK:
		write_reg(dev->baseaddr, REG_SIR_OFFSET, REG_SIR_CLK);
		break;
	case SYNCRON_SYNC_CAPTURE:
		write_reg(dev->baseaddr, REG_SIR_OFFSET, REG_SIR_CAP);
		break;
	case SYNCRON_SYNC_LINK:
		write_reg(dev->baseaddr, REG_SIR_OFFSET, REG_SIR_LNK);
		break;
	case SYNCRON_SYNC_CAPTURE_RAW:
		write_reg(dev->baseaddr, REG_SIR_OFFSET, REG_SIR_RAW);
		break;
	default:
		return;
	}
}
