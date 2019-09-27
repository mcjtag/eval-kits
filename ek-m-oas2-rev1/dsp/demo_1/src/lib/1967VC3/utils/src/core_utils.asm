
#include <defts201.h>
#include "def1967VC3.h"


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


//-------------------------------------------------------//
//	Enable SDRAM address alias at 0x10000000
//	Not thread-safe
//	
//	Arguments:
//		none
// 	Outputs:
//		none
// Scratch:	
//		j4
//-------------------------------------------------------//
.global __enable_sdram_alias;
.align_code 4;
__enable_sdram_alias:
	j4 = SYSCON;;
	j4 = j4 or (1<<SYSCON_SDRAM_ALIAS_P);;
	SYSCON = j4;;
	cjmp(abs);	nop; nop; nop;;
__enable_sdram_alias.end:




/********************************************************************************
* 						BYTE AND SHORT WORD ACCESS								*
*																				*
*																				*
*																				*
********************************************************************************/


//-------------------------------------------------------//
//	Writes u8 (unsigned or signed 8-bit) to address
//	
//	Arguments:
//		j4 - byte address (allows access to 0x00000000 - 0x3FFFFFFF)
//		j5 - value, used bits are [7:0]
//
// 	Outputs:
//		none
// Scratch:	
//		none
//-------------------------------------------------------//
.global __write_u8;
.align_code 4;
__write_u8:
	.var = {0xA1C52400};   // B[j4 + 0x00] = j5;
	cjmp(abs);	nop; nop; nop;;
__write_u8.end:


//-------------------------------------------------------//
//	Writes u16 (unsigned or signed 8-bit) to address
//	
//	Arguments:
//		j4 - byte address (allows access to 0x00000000 - 0x3FFFFFFF)
//		j5 - value, used bits are [15:0]
//
// 	Outputs:
//		none
// Scratch:	
//		none
//-------------------------------------------------------//
.global __write_u16;
.align_code 4;
__write_u16:
	.var = {0xA1C56400};   // S[j4 + 0x00] = j5;
	cjmp(abs);	nop; nop; nop;;
__write_u16.end:


//-------------------------------------------------------//
//	Read u8 (unsigned 8-bit) from address
//	
//	Arguments:
//		j4 - byte address (allows access to 0x00000000 - 0x3FFFFFFF)
//
// 	Outputs:
//		j8, used bits are [7:0]
// Scratch:	
//		none
//-------------------------------------------------------//
.global __read_u8;
.align_code 4;
__read_u8:
	.var = {0xA0C82400};   // j8 = UB[j4 + 0x00];
	cjmp(abs);	nop; nop; nop;;
__read_u8.end:


//-------------------------------------------------------//
//	Read s8 (signed 8-bit) from address
//	
//	Arguments:
//		j4 - byte address (allows access to 0x00000000 - 0x3FFFFFFF)
//
// 	Outputs:
//		j8, used bits are [31:0], sign-extended y bit [7]
// Scratch:	
//		none
//-------------------------------------------------------//
.global __read_s8;
.align_code 4;
__read_s8:
	.var = {0xA0C82401};   // j8 = B[j4 + 0x00];
	cjmp(abs);	nop; nop; nop;;
__read_s8.end:


//-------------------------------------------------------//
//	Read u8 (unsigned 8-bit) from address
//	
//	Arguments:
//		j4 - byte address (allows access to 0x00000000 - 0x3FFFFFFF)
//
// 	Outputs:
//		j8, used bits are [7:0]
// Scratch:	
//		none
//-------------------------------------------------------//
.global __read_u16;
.align_code 4;
__read_u16:
	.var = {0xA0C86400};   // j8 = US[j4 + 0x00];
	cjmp(abs);	nop; nop; nop;;
__read_u16.end:


//-------------------------------------------------------//
//	Read s16 (signed 16-bit) from address
//	
//	Arguments:
//		j4 - byte address (allows access to 0x00000000 - 0x3FFFFFFF)
//
// 	Outputs:
//		j8, used bits are [31:0], sign-extended by bit [15]
// Scratch:	
//		none
//-------------------------------------------------------//
.global __read_s16;
.align_code 4;
__read_s16:
	.var = {0xA0C86401};   // j8 = S[j4 + 0x00];
	cjmp(abs);	nop; nop; nop;;
__read_s16.end:



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
* 									CACHE										*
*																				*
* 	1 page for static mempory is 128K words										*
* 	1 page for sdram is 512K words												*
********************************************************************************/






//-------------------------------------------------------//
//	Reads single arbitrary UREG
//	
//	Arguments:
//		j4 - register address {6 bits for group, 5 bits for reg}
// 	Outputs:
//		j8 - register value
// Scratch:	
//		xr3:0, xstat
//-------------------------------------------------------//
.align_code 4;
	nop;;	nop;;	nop;;	nop;;
	nop;;	nop;;	nop;;	nop;;
__read_sysreg_op:
	nop;;				// This instruction will be replaced
	nop;;
	nop;;
	cjmp(abs);;
	
	//j8 = xr1;;			// 88010C10
	//j8 = yr1;;			// 88410C10
	//j8 = CACMD0;;		// 8BC00C10
	//j8 = CCAIR0;;		// 0BC10C10
	//j8 = CASTAT0;;		// 8BC20C10
	
.global __read_sysreg;
.align_code 4;
__read_sysreg:
	j4 = j4 and 0x7FF;;
	xr2 = 0x88000C10;;		// opcode for j8 = xr0;;
	// Set group[4:0], reg[4:0]
	xr0 = j4;;
	xr1 = (16 << 8) | 10;;
	xr2 += fdep r0 by r1;;
	// Set group[5]
	xr0 = lshift r0 by -10;;
	xr1 = (7 << 8) | 1;;
	xr2 += fdep r0 by r1;;
	// Save and execute constructed instruction
	[j31 + __read_sysreg_op] = xr2;;
	xr3 = [j31 + __read_sysreg_op];;
	nop;;
	nop;;
	nop;;
	jump __read_sysreg_op(np);;
__read_sysreg.end:



//-------------------------------------------------------//
//	Writes single arbitrary UREG
//	
//	Arguments:
//		j4 - register address {6 bits for group, 5 bits for reg}
//		j5 - value
// 	Outputs:
//		none
// Scratch:	
//		xr3:0, xstat
//-------------------------------------------------------//
.align_code 4;
	nop;;	nop;;	nop;;	nop;;
	nop;;	nop;;	nop;;	nop;;
__write_sysreg_op:
	nop;;				// This instruction will be replaced
	nop;;
	nop;;
	cjmp(abs);;
	
	//xr0 = j5;;	// 0x89850000
	//xr1 = j5;;	// 0x89850002
	//yr0 = j5;;	// 0x89850200
	//yr1 = j5;;	// 0x09850202
	
.global __write_sysreg;
.align_code 4;
__write_sysreg:
	j4 = j4 and 0x7FF;;
	xr2 = 0x89850000;;		// opcode for xr0 = j5;;
	// Set reg[4:0]
	xr0 = j4;;
	xr1 = (1 << 8) | 5;;
	xr2 += fdep r0 by r1;;
	// Set group[5:0]
	xr0 = lshift r0 by -5;;
	xr1 = (8 << 8) | 6;;
	xr2 += fdep r0 by r1;;
	// Save and execute constructed instruction
	[j31 + __write_sysreg_op] = xr2;;
	xr3 = [j31 + __write_sysreg_op];;
	nop;;
	nop;;
	nop;;
	jump __write_sysreg_op(np);;
__write_sysreg.end:





//--------- MS0 ----------//

.global __setup_dcache_ms0;
.align_code 4;
__setup_dcache_ms0:
	MS0_C_CFG = j4;;
	cjmp(abs);;
__setup_dcache_ms0.end:

.global __setup_icache_ms0;
.align_code 4;
__setup_icache_ms0:
	MS0_CI_CFG = j4;;
	cjmp(abs);;
__setup_icache_ms0.end:

.global __setup_write_strategy_ms0;
.align_code 4;
__setup_write_strategy_ms0:
	MS0_WT_CFG = j4;;
	cjmp(abs);;
__setup_write_strategy_ms0.end:


//--------- MS1 ----------//

.global __setup_dcache_ms1;
.align_code 4;
__setup_dcache_ms1:
	MS1_C_CFG = j4;;
	cjmp(abs);;
__setup_dcache_ms1.end:


.global __setup_icache_ms1;
.align_code 4;
__setup_icache_ms1:
	MS1_CI_CFG = j4;;
	cjmp(abs);;
__setup_icache_ms1.end:


.global __setup_write_strategy_ms1;
.align_code 4;
__setup_write_strategy_ms1:
	MS1_WT_CFG = j4;;
	cjmp(abs);;
__setup_write_strategy_ms1.end:


//-------- SDRAM ---------//

.global __setup_dcache_sdram;
.align_code 4;
__setup_dcache_sdram:
	SDR_C_CFG = j4;;
	cjmp(abs);;
__setup_dcache_sdram.end:


.global __setup_icache_sdram;
.align_code 4;
__setup_icache_sdram:
	SDR_CI_CFG = j4;;
	cjmp(abs);;
__setup_icache_sdram.end:


.global __setup_write_strategy_sdram;
.align_code 4;
__setup_write_strategy_sdram:
	SDR_WT_CFG = j4;;
	cjmp(abs);;
__setup_write_strategy_sdram.end:


//------- Common --------//

.global __dcache_cmd;
.align_code 4;
__dcache_cmd:
	j2 = CWT_CR;;
	j2 = j2 and not (1 << CWT_DC_ON_P) | (1 << CWT_EN_2DQW_P);;
	j3 = j4 and (1 << CWT_DC_ON_P) | (1 << CWT_EN_2DQW_P);;
	j2 = j2 or j3;;
	cjmp(abs);	CWT_CR = j2;;
__dcache_cmd.end:


.global __icache_cmd;
.align_code 4;
__icache_cmd:
	j2 = CWT_CR;;
	j2 = j2 and not (1 << CWT_IC_ON_P) | (1 << CWT_EN_2IQW_P);;
	j3 = j4 and (1 << CWT_IC_ON_P) | (1 << CWT_EN_2IQW_P);;
	j2 = j2 or j3;;
	cjmp(abs);	CWT_CR = j2;;
__icache_cmd.end:


.global __disable_cache_and_protection;
.align_code 4;
__disable_cache_and_protection:
	j2 = 0x00;;
	CWT_CR = j2;;		// disable all
	SDR_C_CFG = j2;;	// reset cache control registers
	SDR_WT_CFG = j2;;		
	SDR_CI_CFG = j2;;		
	MS0_C_CFG = j2;;		
	MS0_CI_CFG = j2;;
	MS0_WT_CFG = j2;;
	MS1_C_CFG = j2;;
	MS1_CI_CFG = j2;;
	MS1_WT_CFG = j2;;
	cjmp(abs);;
__disable_cache_and_protection.end:



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




