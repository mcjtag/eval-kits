/**
 * @file gpio.h
 * @brief GPIO HAL
 * @author matyunin.d
 * @date 14.06.2019
 */

#ifndef GPIO_H_
#define GPIO_H_

#include "xgpio.h"

struct gpio_dev {
	XGpio gpio;
	u16 dev_id;
};

int gpio_init(struct gpio_dev *dev);
int gpio_dir(struct gpio_dev *dev, int grp, int dir);
int gpio_write(struct gpio_dev *dev, int grp, u32 msk);
int gpio_read(struct gpio_dev *dev, int grp, u32 *msk);
int gpio_set(struct gpio_dev *dev, int grp, u32 msk);
int gpio_clr(struct gpio_dev *dev, int grp, u32 msk);

#endif /* GPIO_H_ */
