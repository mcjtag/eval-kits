/**
 * @file led.h
 * @brief LED Driver
 * @author matyunin.d
 * @date 24.06.2019
 */

#ifndef LED_H_
#define LED_H_

#include "stdint.h"

enum LED_GROUP {
	LED_GROUP_0, // Slow
	LED_GROUP_1  // Fast
};

void led_set(int group, uint16_t leds);
void led_toggle(int group);

#endif /* LED_H_ */
