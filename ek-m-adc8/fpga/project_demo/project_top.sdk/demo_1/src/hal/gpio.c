/**
 * @file gpio.c
 * @brief GPIO HAL
 * @author matyunin.d
 * @date 14.06.2019
 */

#include "gpio.h"

static void gpio_handler(struct gpio_dev *dev);

/**
 * @brief GPIO device initialization
 * @param dev Pointer to device structure
 * @return 0 - success, 1 - failure
 */
int gpio_init(struct gpio_dev *dev)
{
	int status;

	if (!dev)
		return XST_FAILURE;

	status = XGpio_Initialize(&dev->gpio, dev->dev_id);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	if (dev->intc) {
		XIntc_Connect(&dev->intc->intc, dev->vec_id,  (Xil_ExceptionHandler)gpio_handler, dev);
		XIntc_Enable(&dev->intc->intc, dev->vec_id);

		XGpio_InterruptEnable(&dev->gpio, 1);
		XGpio_InterruptGlobalEnable(&dev->gpio);
	}

	return XST_SUCCESS;
}

/**
 * @brief Set GPIO direction
 * @param dev Pointer to device structure
 * @param grp Group number (0 or 1)
 * @param dir Direction (0 - output, 1 - input)
 * @return 0
 */
int gpio_dir(struct gpio_dev *dev, int grp, int dir)
{
	XGpio_SetDataDirection(&dev->gpio, grp + 1, dir);
	return XST_SUCCESS;
}

/**
 * @brief Write GPIO value
 * @param dev Pointer to device structure
 * @param grp Group number (0 or 1)
 * @param msk Data mask
 * @return 0
 */
int gpio_write(struct gpio_dev *dev, int grp, u32 msk)
{
	XGpio_DiscreteWrite(&dev->gpio, grp + 1, msk);
	return XST_SUCCESS;
}

/**
 * @brief Read GPIO value
 * @param dev Pointer to device structure
 * @param grp Group number (0 or 1)
 * @param msk Pointer to data mask
 * @return 0
 */
int gpio_read(struct gpio_dev *dev, int grp, u32 *msk)
{
	*msk = XGpio_DiscreteRead(&dev->gpio, grp + 1);
	return XST_SUCCESS;
}

/**
 * @brief Set GPIO to HIGH state
 * @param dev Pointer to device structure
 * @param grp Group number (0 or 1)
 * @param msk Pin mask
 * @return 0
 */
int gpio_set(struct gpio_dev *dev, int grp, u32 msk)
{
	XGpio_DiscreteSet(&dev->gpio, grp + 1, msk);
	return XST_SUCCESS;
}

/**
 * @brief Set GPIO to LOW state
 * @param dev Pointer to device structure
 * @param grp Group number (0 or 1)
 * @param msk Pin mask
 * @return 0
 */
int gpio_clr(struct gpio_dev *dev, int grp, u32 msk)
{
	XGpio_DiscreteClear(&dev->gpio, grp + 1, msk);
	return XST_SUCCESS;
}

/**
 * @brief GPIO interrupt handler
 * @param Pointer to device structure
 * @return void
 */
static void gpio_handler(struct gpio_dev *dev)
{
	u32 msk;
	msk = XGpio_DiscreteRead(&dev->gpio, 1);
	if (dev->cb)
		dev->cb(msk);
	XGpio_InterruptClear(&dev->gpio, 1);
}

