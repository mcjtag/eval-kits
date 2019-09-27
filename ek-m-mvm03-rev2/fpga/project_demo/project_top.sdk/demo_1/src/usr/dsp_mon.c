/**
 * @file dsp_mon.c
 * @brief DSP Monitor App
 * @author matyunin.d
 * @date 24.06.2019
 */

#include "dsp_mon.h"
#include "../hal/hal.h"
#include "../drv/tft/tft_lcd.h"
#include "../drv/led.h"
#include "../drv/dsp.h"
#include <stdio.h>

static float temp[4];
static float temp_old[4];
static float volt[3];
static float volt_old[3];

static char str_old[32];
static char str[32];

static const uint8_t basic_str[9][32] = {
		"DSP Temperatures:",
		" Temp ID0:       oC",
		" Temp ID1:       oC",
		" Temp ID2:       oC",
		" Temp ID3:       oC",
		"DSP Voltages:",
		" VDDIN:      V",
		" VDD3V:      V",
		" VDDIO:      V"
};

static const uint16_t basic_pos[9][2] = {{10, 15}, {10, 35}, {10, 55}, {10, 75}, {10, 95}, {10, 125}, {10, 145}, {10, 165}, {10, 185}};
static const uint16_t basic_col[9] = {YELLOW, WHITE, WHITE, WHITE, WHITE, GREEN, WHITE, WHITE, WHITE};

static const uint16_t temp_pos[4][2] = {{95, 35}, {95, 55}, {95, 75}, {95, 95}};
static const uint16_t temp_col = CYAN;
static const uint16_t volt_pos[3][2] = {{70, 145}, {70, 165}, {70, 185}};
static const uint16_t volt_col = CYAN;

/**
 * @brief Start DSP Monitor
 * @return void
 */
void dsp_mon_start(void)
{
	lcd_off();
	lcd_clear_screen(BLACK);

	/* Draw Frame */
	lcd_draw_rect(0,0,LCD_WIDTH-1, LCD_HEIGHT-1, WHITE);
	lcd_draw_rect(1,1,LCD_WIDTH-1-2,LCD_HEIGHT-1-2, MORANGE);
	lcd_draw_rect(2,2,LCD_WIDTH-1-4,LCD_HEIGHT-1-4, MORANGE);
	lcd_draw_rect(3,3,LCD_WIDTH-1-6,LCD_HEIGHT-1-6, WHITE);

	/* Draw basic */
	for (int i = 0; i < 9; i++) {
		sprintf(str, "%s", basic_str[i]);
		lcd_display_string(basic_pos[i][0], basic_pos[i][1], (const uint8_t *)str, FONT_1608, basic_col[i]);
	}

	led_set(LED_GROUP_0, 0xAAAA);
	led_set(LED_GROUP_1, 0x05);

	for (;;) {
		led_toggle(LED_GROUP_0);
		led_toggle(LED_GROUP_1);

		/* Get temps */
		temp[0] = dsp_get_temp(DSP_ID0);
		temp[1] = dsp_get_temp(DSP_ID1);
		temp[2] = dsp_get_temp(DSP_ID2);
		temp[3] = dsp_get_temp(DSP_ID3);

		/* Get volts */
		volt[0] = dsp_get_volt(DSP_VOLT_IN);
		volt[1] = dsp_get_volt(DSP_VOLT_AN);
		volt[2] = dsp_get_volt(DSP_VOLT_IO);

		/* Refresh temperatures on LCD if necessary */
		for (int i = 0; i < 4; i++) {
			if (temp[i] != temp_old[i]) {
				sprintf(str_old, "%.2f", temp_old[i]);
				sprintf(str, "%.2f", temp[i]);
				lcd_display_string(temp_pos[i][0], temp_pos[i][1], (const uint8_t *)str_old, FONT_1608, BLACK);
				lcd_display_string(temp_pos[i][0], temp_pos[i][1], (const uint8_t *)str, FONT_1608, temp_col);
			}
			temp_old[i] = temp[i];
		}

		/* Refresh voltages on LCD if necessary */
		for (int i = 0; i < 3; i++) {
			if (volt[i] != volt_old[i]) {
				sprintf(str_old, "%.2f", volt_old[i]);
				sprintf(str, "%.2f", volt[i]);
				lcd_display_string(volt_pos[i][0], volt_pos[i][1], (const uint8_t *)str_old, FONT_1608, BLACK);
				lcd_display_string(volt_pos[i][0], volt_pos[i][1], (const uint8_t *)str, FONT_1608, volt_col);
			}
			volt_old[i] = volt[i];
		}

		lcd_on();
		timer_delay(&tmr0, 5000);
	}
}

