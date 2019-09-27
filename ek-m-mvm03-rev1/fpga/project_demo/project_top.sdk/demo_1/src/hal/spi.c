/**
 * @file spi.c
 * @brief SPI HAL
 * @author matyunin.d
 * @date 14.06.2019
 */

#include "spi.h"

static void status_handler(struct spi_dev *dev, u32 event, unsigned int count);

/**
 * @brief SPI device initialization
 * @param dev Pointer to device structure
 * @return 0 - success, 1- failure
 */
int spi_init(struct spi_dev *dev)
{
	int status;
	XSpi_Config *config_ptr;

	if (!dev)
		return XST_FAILURE;

	config_ptr = XSpi_LookupConfig(dev->dev_id);
	if (config_ptr == NULL) {
		return XST_DEVICE_NOT_FOUND;
	}

	status = XSpi_CfgInitialize(&dev->spi, config_ptr, config_ptr->BaseAddress);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XSpi_Reset(&dev->spi);

	status = XSpi_SetOptions(&dev->spi, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	dev->errors = 0;

	if (dev->intc) {
		status = XIntc_Connect(&dev->intc->intc, dev->vec_id, (XInterruptHandler)XSpi_InterruptHandler, &dev->spi);
		if (status != XST_SUCCESS) {
			return XST_FAILURE;
		}

		XSpi_SetStatusHandler(&dev->spi, dev, (XSpi_StatusHandler)status_handler);
		XIntc_Enable(&dev->intc->intc, dev->vec_id);
	}

	XSpi_Start(&dev->spi);

	return XST_SUCCESS;
}

/**
 * @brief Set SPI device options
 * @param dev Pointer to device structure
 * @param opts Pointer to options' structure
 * @return 0 - success, 1- failure
 */
int spi_set_opts(struct spi_dev *dev, struct spi_opts *opts)
{
	u32 options = XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION;
	int status;

	if (opts->cpol)
		options |= XSP_CLK_ACTIVE_LOW_OPTION;
	if (opts->cpha)
		options |= XSP_CLK_PHASE_1_OPTION;

	status = XSpi_SetOptions(&dev->spi, options);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/**
 * @brief Set SPI CS signal to HIGH
 * @param dev Pointer to device structure
 * @param dev_msk Device mask (0 - no device active, 1, 2, 4, etc. - device active)
 * @return 0 - success, 1 - failure
 */
int spi_set_cs(struct spi_dev *dev, u32 dev_msk)
{
	int status;

	status = XSpi_SetSlaveSelect(&dev->spi, dev_msk);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/**
 * @brief  Initiate SPI transfer
 * @param dev Pointer to device structure
 * @param wr_buf Pointer to 'write' buffer
 * @param rd_buf Pointer to 'read' buffer
 * @param count Count of bytes
 * @return 0 - success, 1 - failure
 */
int spi_transfer(struct spi_dev *dev, u8 *wr_buf, u8 *rd_buf, u32 count)
{
	dev->active = 1;

	XSpi_Transfer(&dev->spi, wr_buf, rd_buf, count);
	while (dev->active);

	return XST_SUCCESS;
}

/**
 * @brief Status interrupt handler
 * @param dev Pointer to device structure
 * @param event Interrupt event
 * @param count Byte count
 * @return void
 */
static void status_handler(struct spi_dev *dev, u32 event, unsigned int count)
{
	dev->active = 0;

	if (event != XST_SPI_TRANSFER_DONE) {
		dev->errors++;
	}
}


