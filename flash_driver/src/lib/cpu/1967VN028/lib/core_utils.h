#ifndef __CORE_UTILS_H_
#define __CORE_UTILS_H_

#include "stdint.h"


// Bit field manipulation
#define FEXT_POS(x)	(x << 8)
#define FEXT_LEN(x)	(x)

// Alias for C-style
#define wait_cycles(x)	__wait_cycles(x)

#ifdef __CMCPPTSH__
#ifdef __cplusplus
extern "C" {
#endif // __cplusplus
#else
extern "asm" {
#endif // __CMCPPTSH__
	void __wait_cycles(uint32_t number);		// Waits for specified number of core clocks
	
	void __set_imaskl(unsigned int value);		// value is ORed with IMASKL
	void __set_imaskh(unsigned int value);		// value is ORed with IMASKH
	void __clear_imaskl(unsigned int value);	// value is AND NOTed with IMASKL
	void __clear_imaskh(unsigned int value);	// value is AND NOTed with IMASKH

	void __enable_interrupts(void);				// Enable interrupts (SQCTL manipulation)
	void __disable_interrupts(void);			// Disable interrupts (SQCTL manipulation)
	
	unsigned int __get_id(void);
#ifdef __CMCPPTSH__
#ifdef __cplusplus
}
#endif // __cplusplus
#else
}
#endif // __CMCPPTSH__

#endif //__CORE_UTILS_H_
