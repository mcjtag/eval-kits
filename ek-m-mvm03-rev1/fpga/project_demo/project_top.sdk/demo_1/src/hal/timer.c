/**
 * @file timer.c
 * @brief Timer HAL
 * @author matyunin.d
 * @date 17.06.2019
 */

#include "timer.h"

static void timer_handler(struct timer_dev *dev, u8 timer_num);

/**
 * @brief Timer device initialization
 * @param dev Pointer to device structure
 * @return 0 - success, 1 - failure
 */
int timer_init(struct timer_dev *dev)
{
	int status;

	if (!dev)
		return XST_FAILURE;

	status = XTmrCtr_Initialize(&dev->timer, dev->dev_id);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	status = XTmrCtr_SelfTest(&dev->timer, 0);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	if (dev->intc) {
		status = XIntc_Connect(&dev->intc->intc, dev->vec_id, (XInterruptHandler)XTmrCtr_InterruptHandler, &dev->timer);
		if (status != XST_SUCCESS) {
			return XST_FAILURE;
		}

		XTmrCtr_SetHandler(&dev->timer, (XTmrCtr_Handler)timer_handler, dev);
		XIntc_Enable(&dev->intc->intc, dev->vec_id);
	}

	return XST_SUCCESS;
}

/**
 * @brief Time delay
 * @param dev Pointer to device structure
 * @param delay_ms Delay value in milliseconds
 * @return 0
 */
int timer_delay(struct timer_dev *dev, u32 delay_ms)
{
	dev->expired = 0;
	XTmrCtr_SetOptions(&dev->timer, 0, XTC_INT_MODE_OPTION | XTC_AUTO_RELOAD_OPTION | XTC_DOWN_COUNT_OPTION);
	XTmrCtr_SetResetValue(&dev->timer, 0, 100000);
	XTmrCtr_Start(&dev->timer, 0);
	while (dev->expired != delay_ms);
	XTmrCtr_Stop(&dev->timer, 0);
	return XST_SUCCESS;
}

/**
 * @brief Timer interrupt handler
 * @param dev Pointer to device structure
 * @param timer_num Timer number
 * @return void
 */
static void timer_handler(struct timer_dev *dev, u8 timer_num)
{
	if (XTmrCtr_IsExpired(&dev->timer, 0)) {
		dev->expired++;
	}
}


