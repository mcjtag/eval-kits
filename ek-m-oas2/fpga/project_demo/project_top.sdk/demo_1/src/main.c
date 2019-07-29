/**
 * @file main.c
 * @brief Main
 * @author matyunin.d
 * @date 11.07.2019
 */

#include <stdio.h>
#include "platform.h"
#include "hal/hal.h"
#include "usr/oscapp.h"
#include "logo.h"

/**
 * @brief
 * @return 0
 */
int main()
{
	init_platform();
	hal_init();

	tft_draw_bitmap(&tft, 70, 88, logo);
	tft_resync(&tft);
	timer_delay(&sys_tmr, 3000);
	tft_clear(&tft);
	tft_resync(&tft);
	timer_delay(&sys_tmr, 100);

	oscapp_run();
	for (;;);

    cleanup_platform();
    return 0;
}
