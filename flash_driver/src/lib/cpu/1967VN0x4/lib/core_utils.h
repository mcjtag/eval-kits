#ifndef __CORE_UTILS_H_
#define __CORE_UTILS_H_

#include "stdint.h"


// Alias for C-style
#define wait_cycles(x)	__wait_cycles(x)

// Bit field manipulation
#define FEXT_POS(x)	(x << 8)
#define FEXT_LEN(x)	(x)

#ifdef __CMCPPTSH__
#ifdef __cplusplus
extern "C" {
#endif // __cplusplus
#else
extern "asm" {
#endif // __CMCPPTSH__
	void __write_u8(uint32_t address, uint32_t value);
	void __write_u16(uint32_t address, uint32_t value);
	uint32_t __read_u8(uint32_t address);
	uint32_t __read_s8(uint32_t address);
	uint32_t __read_u16(uint32_t address);
	uint32_t __read_s16(uint32_t address);
	
	void __wait_cycles(uint32_t number);		// Waits for specified number of core clocks
	void __enable_sdram_alias(void);			// Enable SDRAM address alias at 0x10000000

	void __set_imaskl(unsigned int value);		// value is ORed with IMASKL
	void __set_imaskh(unsigned int value);		// value is ORed with IMASKH
	void __clear_imaskl(unsigned int value);	// value is AND NOTed with IMASKL
	void __clear_imaskh(unsigned int value);	// value is AND NOTed with IMASKH

	void __enable_interrupts(void);				// Enable interrupts (SQCTL manipulation)
	void __disable_interrupts(void);			// Disable interrupts (SQCTL manipulation)
	
	uint32_t __read_sysreg(uint32_t address);
	void __write_sysreg(uint32_t address, uint32_t value);

	uint32_t __bit_reverse(uint32_t value);

#ifdef __CMCPPTSH__
#ifdef __cplusplus
}
#endif // __cplusplus
#else
}
#endif // __CMCPPTSH__

#endif //__CORE_UTILS_H_
