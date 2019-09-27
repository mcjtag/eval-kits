#ifndef __COMPILERS_H__
#define __COMPILERS_H__



#ifdef __CMCPPTSH__

#define __ASM(x)	__asm x
//#define __align(x)	data_alignment=x

#else

#define __ASM_1(x)	asm(#x)
#define __ASM(x)	__ASM_1(x;)
//#define __align(x)	align x

#endif // __CMCPPTSH__


#endif //__COMPILERS_H__
