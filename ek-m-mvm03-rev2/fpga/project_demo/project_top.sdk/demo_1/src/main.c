/**
 * @file main.c
 * @brief
 * @author matyunin.d
 * @date 14.06.2019
 */
#include <stdio.h>
#include "xparameters.h"
#include "xil_printf.h"
#include "platform.h"

#include "drv/tft/tft_lcd.h"
#include "hal/hal.h"
#include "drv/dsp.h"
#include "drv/led.h"
#include "usr/dsp_mon.h"

#include "logo.h"

void startup_logo(void);

/**
 * @brief Main function
 * @return 0
 */
int main(void)
{
	init_platform();
	hal_init();
	dsp_init();

	led_set(LED_GROUP_0, 0x00);
	led_set(LED_GROUP_1, 0x00);

	lcd_init();
	startup_logo();

	dsp_mon_start();

	return 0;
}

/**
 * @brief Show Milandr logo
 * @return void
 */
void startup_logo(void)
{
	lcd_off();
	lcd_draw_bitmap(70, 10, logo);
	lcd_on();
	timer_delay(&tmr0, 5000);
}
