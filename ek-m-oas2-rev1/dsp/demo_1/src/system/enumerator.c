/**
 * @file enumerator.c
 * @brief
 * @author matyunin.d
 * @date 01.11.2017
 */

#include "enumerator.h"
#include "cpu_defs.h"
#include "../config.h"

#define ENUM	CONFIG_ENUM_DEV
#define BIT0	(uint32_t)(1 << 9)

/**
 * @brief Get local offset
 * @return offset
 */
unsigned char get_local_offset(void)
{
	uint32_t bitmask = BIT0;
	uint32_t offset = 0;

	ENUM->alt.clr = bitmask;
	ENUM->ddr.clr = bitmask;

	offset |= (ENUM->pin & BIT0) ? 0x01 : 0x00;

	return offset;
}

/**
 * @brief Get local device number
 * @return number
 */
unsigned char get_local_number(void)
{
	return get_local_offset();
}
