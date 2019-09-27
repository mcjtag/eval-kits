#ifndef __COM_UTILS_H_
#define __COM_UTILS_H_

#ifndef __CMCPPTSH__
#include <builtins.h>
#endif // __CMCPPTSH__

#ifdef __cplusplus
#ifdef __CMCPPTSH__
extern "C" {
#else
extern "asm" {
#endif // __CMCPPTSH__
#endif // __cplusplus
	

	int _compx_mem32(int *addr1, int *addr2, int count);
	int _compx_mem64(int *addr1, int *addr2, int count);
	int compx_single_word(int a, int b);
	int compx_long_word_mem(long long *a, long long *b);
	int compx_quad_word_mem(__builtin_quad *a, __builtin_quad *b);

	void copy_mem_core_quad(int *src, int *dst, int count);
	void copy_mem_core_single(int *src, int *dst, int count);

	int _LFSR32_fast(int seed);
	int _LFSR32_cycle_fast(int seed, int count);

#ifdef __cplusplus
}
#endif // __cplusplus



#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

	void fill_mem32(uint32_t *ptr, uint32_t pattern, uint32_t word_count);
	void fill_mem64(uint32_t *ptr, uint32_t pattern, uint32_t word_count);
	void fill_mem128(uint32_t *ptr, uint32_t pattern, uint32_t word_count);


#ifdef __cplusplus
}
#endif // __cplusplus





#endif
