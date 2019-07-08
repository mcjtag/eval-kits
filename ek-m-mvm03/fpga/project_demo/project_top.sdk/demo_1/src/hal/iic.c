/**
 * @file iic.c
 * @brief IIC HAL
 * @author matyunin.d
 * @date 14.06.2019
 */

#include "iic.h"

static void send_handler(struct iic_dev *dev);
static void receive_handler(struct iic_dev *dev);
static void status_handler(struct iic_dev *dev, int event);

/**
 * @brief IIC device initialization
 * @param dev Pointer to device structure
 * @return 0 - success, 1 - failure
 */
int iic_init(struct iic_dev *dev)
{
	int status;
	XIic_Config *config_ptr;

	if (!dev)
		return XST_FAILURE;

	config_ptr = XIic_LookupConfig(dev->dev_id);
	if (config_ptr == NULL) {
		return XST_FAILURE;
	}

	status = XIic_CfgInitialize(&dev->iic, config_ptr, config_ptr->BaseAddress);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	status = XIic_SelfTest(&dev->iic);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XIic_Reset(&dev->iic);

	if (dev->intc) {
		status = XIntc_Connect(&dev->intc->intc, dev->vec_id, (XInterruptHandler)XIic_InterruptHandler, &dev->iic);
		if (status != XST_SUCCESS) {
			return XST_FAILURE;
		}

		XIic_SetSendHandler(&dev->iic, dev, (XIic_Handler)send_handler);
		XIic_SetRecvHandler(&dev->iic, dev, (XIic_Handler)receive_handler);
		XIic_SetStatusHandler(&dev->iic, dev, (XIic_StatusHandler)status_handler);
		XIntc_Enable(&dev->intc->intc, dev->vec_id);
	}

	return XST_SUCCESS;
}

/**
 * @brief Write data array to slave target
 * @param dev Pointer to device structure
 * @param addr Address of slave target
 * @param data Pointer to data array
 * @param len Length of array in bytes
 * @return 0 - success, 1 - failure
 */
int iic_write(struct iic_dev *dev, u8 addr, u8 *data, int len)
{
	int status;

	dev->tx_done = 1;
	dev->iic.Stats.TxErrors = 0;

	status = XIic_Start(&dev->iic);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XIic_SetAddress(&dev->iic, XII_ADDR_TO_SEND_TYPE, addr);

	status = XIic_MasterSend(&dev->iic, data, len);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	while ((dev->tx_done) || (XIic_IsIicBusy(&dev->iic) == TRUE)) {
		if (dev->iic.Stats.TxErrors != 0) {
			status = XIic_Start(&dev->iic);
			if (status != XST_SUCCESS) {
				return XST_FAILURE;
			}

			if (!XIic_IsIicBusy(&dev->iic)) {
				status = XIic_MasterSend(&dev->iic, data, len);
				if (status == XST_SUCCESS) {
					dev->iic.Stats.TxErrors = 0;
				}
			}
		}
	}

	status = XIic_Stop(&dev->iic);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/**
 * @brief Read data array from slave target
 * @param dev Pointer to device structure
 * @param addr Address of slave target
 * @param data Pointer to data array
 * @param len Length of array in bytes
 * @return 0 - success, 1 - failure
 */
int iic_read(struct iic_dev *dev, u8 addr, u8 *data, int len)
{
	int status;

	dev->rx_done = 1;

	status = XIic_Start(&dev->iic);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XIic_SetAddress(&dev->iic, XII_ADDR_TO_SEND_TYPE, addr);

	status = XIic_MasterRecv(&dev->iic, data, len);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	while ((dev->rx_done) || (XIic_IsIicBusy(&dev->iic) == TRUE));

	status = XIic_Stop(&dev->iic);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/**
 * @brief Send done interrupt handler
 * @param dev Pointer to device structure
 * @return void
 */
static void send_handler(struct iic_dev *dev)
{
	dev->tx_done = 0;
}

/**
 * @brief Receive done interrupt handler
 * @param dev Pointer to device structure
 * @return void
 */
static void receive_handler(struct iic_dev *dev)
{
	dev->rx_done = 0;
}

/**
 * @brief Status change interrupt handler
 * @param dev Pointer to device structure
 * @return void
 */
static void status_handler(struct iic_dev *dev, int event)
{
	/* nothing to do */
}



