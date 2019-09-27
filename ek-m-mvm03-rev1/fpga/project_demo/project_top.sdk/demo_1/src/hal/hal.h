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
#include "iic.h"
#include "spi.h"
#include "intc.h"
#include "timer.h"

extern struct intc_dev intc;
extern struct timer_dev tmr0;
extern struct iic_dev exp_iic;
extern struct iic_dev tmp_iic;
extern struct spi_dev vadc_spi;
extern struct spi_dev tft_spi;
extern struct gpio_dev tft_gpio;
extern struct gpio_dev dsp_reset_gpio;
extern struct gpio_dev dsp_pll_divr_gpio;
extern struct gpio_dev led_gpio;
extern struct gpio_dev dsp_core_freq_gpio;
extern struct gpio_dev dsp_bus_freq_gpio;
extern struct spi_dev aud_spi;

int hal_init(void);

#endif /* HAL_H_ */
