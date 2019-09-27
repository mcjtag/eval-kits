/**
 * @file intc.c
 * @brief INTC HAL
 * @author matyunin.d
 * @date 14.06.2019
 */

#include "intc.h"

/**
 * @brief INTC device initialization
 * @param dev Pointer to device structure
 * @return 0 - success, 1 - failure
 */
int intc_init(struct intc_dev *dev)
{
	int status;

	microblaze_disable_interrupts();

	status = XIntc_Initialize(&dev->intc, dev->dev_id);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/**
 * @brief Start INTC device
 * @param dev Pointer to device structure
 * @return 0 - success, 1 - failure
 */
int intc_start(struct intc_dev *dev)
{
	int status;

	status = XIntc_Start(&dev->intc, XIN_REAL_MODE);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XIntc_InterruptHandler, &dev->intc);
	Xil_ExceptionEnable();

	microblaze_enable_interrupts();

	return XST_SUCCESS;
}

