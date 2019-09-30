/**
 * @file hal.h
 * @brief HAL
 * @author matyunin.d
 * @date 18.06.2019
 */

#ifndef HAL_H_
#define HAL_H_

#include "xparameters.h"
#include "intc.h"
#include "timer.h"
#include "tft.h"
#include "dma.h"
#include "aic.h"
#include "gpio.h"

extern struct intc_dev intc;
extern struct timer_dev sys_tmr;
extern struct timer_dev pwm_tmr;
extern struct tft_dev tft;
extern struct dma_dev adc_dma;
extern struct aic_dev adc_aic;
extern struct dma_dev fft_dma;
extern struct gpio_dev usr_gpio;

int hal_init(void);

#endif /* HAL_H_ */
