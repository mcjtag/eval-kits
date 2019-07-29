/**
 * @file hal.h
 * @brief HAL
 * @author matyunin.d
 * @date 18.06.2019
 */

#ifndef HAL_H_
#define HAL_H_

#include "xparameters.h"
#include "gpio.h"
#include "intc.h"
#include "timer.h"
#include "tft.h"
#include "dma.h"

extern struct intc_dev intc;
extern struct timer_dev sys_tmr;
extern struct timer_dev pwm_tmr;
extern struct tft_dev tft;
extern struct gpio_dev link_gpio;
extern struct dma_dev link_dma;
extern struct gpio_dev sw_gpio;

int hal_init(void);

#endif /* HAL_H_ */
