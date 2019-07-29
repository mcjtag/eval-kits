/**
 * @file switch.c
 * @brief Switch driver
 * @author matyunin.d
 * @date 24.07.2019
 */

#include "switch.h"
#include "../hal/hal.h"

/**
 * @brief Get switch state
 * @return state
 */
unsigned char sw_get_state(void)
{
	u32 msk;
	gpio_read(&sw_gpio, 0, &msk);
	return (u8)(~msk & 0xF);
}

