/**
 * @file tft_hal.c
 * @brief TFT HAL
 * @author matyunin.d
 * @date 14.06.2019
 */

#include "../../hal/gpio.h"
#include "../../hal/spi.h"
#include "../../hal/timer.h"

extern struct spi_dev tft_spi;
extern struct gpio_dev tft_gpio;
extern struct timer_dev tmr0;

void tft_bkl_set(void)
{
	gpio_set(&tft_gpio, 0, 1);
}

void tft_bkl_clr(void)
{
	gpio_clr(&tft_gpio, 0, 1);
}

void tft_lcd_cs_set(void)
{
	spi_set_cs(&tft_spi, 0);
}

void tft_lcd_cs_clr(void)
{
	spi_set_cs(&tft_spi, 1);
}

void tft_dc_set(void)
{
	gpio_set(&tft_gpio, 0, 2);
}

void tft_dc_clr(void)
{
	gpio_clr(&tft_gpio, 0, 2);
}

void tft_write(u8 *data, u16 count)
{
	u8 *dat = data;
	spi_transfer(&tft_spi, dat, NULL, count);
}

void tft_delay_ms(u16 value)
{
	timer_delay(&tmr0, value);
}


