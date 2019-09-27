#ifndef	__CPU_DEFINED__

#ifdef		__CPU_1967VC2__
#define		__CPU_DEFINED__

#include	"compilers.h"
#include	<defts201.h>
#include	<sysreg.h>

#ifdef __CMCPPTSH__
#include	<stdint.h>
#else
#include	<builtins.h>
#include	"stdint.h"
#endif // __CMCPPTSH__

#include	"def1967VC2.h"



#endif		//__CPU_1967VC2__

#ifdef		__CPU_1967VC3__
#define		__CPU_DEFINED__

#include	"compilers.h"
#include	<defts201.h>
#include	<sysreg.h>

#ifdef __CMCPPTSH__
#include	<stdint.h>
#else
#include	<builtins.h>
#include	"stdint.h"
#endif // __CMCPPTSH__

#include	"def1967VC3.h"

#ifdef __INCLUDE_HAL__
#include	"hal.h"
#endif	//__INCLUDE_HAL__

#endif	//__CPU_1967VC3__

#ifndef	__CPU_DEFINED__
#error	CPU is undefined
#endif	//__CPU_DEFINED__


#endif	//__CPU_DEFINED__


