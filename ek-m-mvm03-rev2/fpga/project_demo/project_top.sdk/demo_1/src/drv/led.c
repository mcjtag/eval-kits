/**
 * @file led.c
 * @brief LED Driver
 * @author matyunin.d
 * @date 24.06.2019
 */

#include "led.h"
#include "../hal/hal.h"

static u16 led_state[2];

/**
 * @brief Set LED state
 * @param group Group of LEDs (enum LED_GROUP)
 * @param leds LEDs state mask
 * @return void
 */
void led_set(int group, uint16_t leds)
{
	switch (group) {
	case LED_GROUP_0:
		{
			led_state[0] = leds;
			u8 data[2] = {(leds >> 0) & 0xFF, (leds >> 8) & 0xFF};
			iic_write(&exp_iic, 0x26, data, 2);
		}
		break;
	case LED_GROUP_1:
		led_state[1] = leds;
		gpio_write(&led_gpio, 0, (uint32_t)leds);

		break;
	}
}

/**
 * @brief Toggle LEDs
 * @param group Group of LEDs (enum LED_GROUP)
 * @return void
 */
void led_toggle(int group)
{
	switch (group) {
	case LED_GROUP_0:
		led_set(group, ~led_state[0]);
		break;
	case LED_GROUP_1:
		led_set(group, ~led_state[1]);
		break;
	}
}


