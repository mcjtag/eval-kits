
#include <defts201.h>
#include "def1967VC2.h"


.section/charany/doubleany program;


//-------------------------------------------------------//
//	Wait for specified number of core clocks
//	
//	Arguments:
//		j4 - timeout (core cycles)
//
// 	Outputs:
//		none
// Scratch:	
//		xr3:0, xstat
//-------------------------------------------------------//
.global __wait_cycles;
.align_code 4;
__wait_cycles:
	xr0 = CCNT0;			xr2 = j4;;
	xr1 = CCNT1;			xr3 = 0;;
	xlr3:2 = r1:0 + r3:2;;
__wait_cycles_loop:
	xr0 = CCNT0;;
	xr1 = CCNT1;;
	xlr1:0 = r1:0 - r3:2;;
	if xale, jump __wait_cycles_loop;;
	cjmp(abs)(np);;
__wait_cycles.end:



/********************************************************************************
* 								INTERRUPTS										*
*																				*
*																				*
*																				*
********************************************************************************/



//-------------------------------------------------------//
//	Sets bits in IMASKL register
//	
//	Arguments:
//		j4 - bit mask to set
//
// 	Outputs:
//		none
// Scratch:	
//		xr0
//-------------------------------------------------------//
.global __set_imaskl;
.align_code 4;
__set_imaskl:
	xr0 = j4;;
	.var = {0x88003A14};  // IMASKLST = xr0
	cjmp(abs);	nop; nop; nop;;
__set_imaskl.end:



//-------------------------------------------------------//
//	Sets bits in IMASKH register
//	
//	Arguments:
//		j4 - bit mask to set
//
// 	Outputs:
//		none
// Scratch:	
//		xr0
//-------------------------------------------------------//
.global __set_imaskh;
.align_code 4;
__set_imaskh:
	xr0 = j4;;
	.var = {0x88003A16};  // IMASKHST = xr0
	cjmp(abs);	nop; nop; nop;;
__set_imaskh.end:



//-------------------------------------------------------//
//	Clears bits in IMASKL register
//	
//	Arguments:
//		j4 - bit mask to clear
//
// 	Outputs:
//		none
// Scratch:	
//		xr0
//-------------------------------------------------------//
.global __clear_imaskl;
.align_code 4;
__clear_imaskl:
	xr0 = j4;;
	.var = {0x88003A18};   // IMASKLCL = xr0
	cjmp(abs);	nop; nop; nop;;
__clear_imaskl.end:



//-------------------------------------------------------//
//	Clears bits in IMASKH register
//	
//	Arguments:
//		j4 - bit mask to clear
//
// 	Outputs:
//		none
// Scratch:	
//		xr0
//-------------------------------------------------------//
.global __clear_imaskh;
.align_code 4;
__clear_imaskh:
	xr0 = j4;;
	.var = {0x88003A1a};  // IMASKHCL = xr0
	cjmp(abs);	nop; nop; nop;;
__clear_imaskh.end:



//-------------------------------------------------------//
//	Enables interrupts (global) using SQCTL alias
//	
//	Arguments:
//		none
// 	Outputs:
//		none
// Scratch:	
//		none
//-------------------------------------------------------//
.global __enable_interrupts;
.align_code 4;
__enable_interrupts:
	sqctlst = SQCTL_GIE;;
	cjmp(abs);	nop; nop; nop;;
__enable_interrupts.end:



//-------------------------------------------------------//
//	Disables interrupts (global) using SQCTL alias
//	
//	Arguments:
//		none
// 	Outputs:
//		none
// Scratch:	
//		none
//-------------------------------------------------------//
.global __disable_interrupts;
.align_code 4;
__disable_interrupts:
	sqctlcl = ~SQCTL_GIE;;
	cjmp(abs);	nop; nop; nop;;
__disable_interrupts.end:




/********************************************************************************
*                                   UTILS                                       *
*                                                                               *
*                                                                               *
*                                                                               *
********************************************************************************/

//-------------------------------------------------------//
//  Bit-reverse
//
//  Arguments:
//      j4 - value
//
//  Outputs:
//      j8 - result
// Scratch:
//      none
//-------------------------------------------------------//
.global __bit_reverse;
.align_code 4;
__bit_reverse:
    //j8 = j4 + j31(BR)(NF);;
    .var = {0xCCC8443E};	// j8 = bitrev j4(nf);
    cjmp(abs);  nop; nop; nop;;
__bit_reverse.end:




