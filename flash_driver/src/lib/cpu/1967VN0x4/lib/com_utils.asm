

#include <defts201.h>
#include "def1967VC3.h"



//-------------------------------------------------------//
//	Fills memory with specified pattern by core
//	Memory pointer may be unaligned	
//
//	Arguments:
//		j4 - address to start with
//		j5 - value to fill with
//		j6 - count (32-bit words)
// 	Outputs:
//		none
// Scratch:	
//		xr0, j4, lc0, jstat
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _fill_mem32;
_fill_mem32:
	comp (j6, 0);			xr0 = j5;;
	if jeq, cjmp(abs)(np);	lc0 = j6;;
_fill_mem32_loop:
	if nlc0e, jump _fill_mem32_loop;	[j4 += 0x01] = xr0;;
	cjmp(abs)(np);;
_fill_mem32.end:


//-------------------------------------------------------//
//	Fills memory with specified pattern by core
//	Memory pointer must be aligned by 2
//
//	Arguments:
//		j4 - address to start with
//		j5 - value to fill with
//		j6 - count (32-bit words)
// 	Outputs:
//		none
// Scratch:	
//		xr1:0, j4, lc0, jstat
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _fill_mem64;
_fill_mem64:
	comp (j6, 0);			xr0 = j5;;
	if jeq, cjmp(abs)(np);	xr1 = xr0;	j6 = lshiftr j6;;
	lc0 = j6;;
_fill_mem64_loop:
	if nlc0e, jump _fill_mem64_loop;	L[j4 += 0x02] = xr1:0;;
	cjmp(abs)(np);;
_fill_mem64.end:



//-------------------------------------------------------//
//	Fills memory with specified pattern by core
//	Memory pointer must be aligned by 4
//
//	Arguments:
//		j4 - address to start with
//		j5 - value to fill with
//		j6 - count (32-bit words)
// 	Outputs:
//		none
// Scratch:	
//		xr3:0, j4, lc0, jstat
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _fill_mem128;
_fill_mem128:
	comp (j6, 0);			xr0 = j5;;
	if jeq, cjmp(abs)(np);	xr1 = xr0;		j6 = lshiftr j6;;
	xr3:2 = xr1:0;			j6 = lshiftr j6;;
	lc0 = j6;;
_fill_mem128_loop:
	if nlc0e, jump _fill_mem128_loop;	Q[j4 += 0x04] = xr3:0;;
	cjmp(abs)(np);;
_fill_mem128.end:

















//-------------------------------------------------------//




//-------------------------------------------------------//
// PLL setup
//	
//	Arguments:
//	j4 = configuration structure pointer:
//		[j4 + 0] - DIVR
//		[j4 + 1] - DIVF
//		[j4 + 2] - DIVQ
//		[j4 + 3] - RANGE
//		[j4 + 4] - IVCO
//		[j4 + 5] - bypass
//	j5 = PLL configuration register address
// 	Outputs:
//	none
// Scratch:	
//		xr3:0, xr5:4
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _setup_pll;
_setup_pll:
	xr3:0 = Q[j4 + 0x00];			xr4 = 0x00;;
	xr5 = (PLL_DIVR_P << 8) | 4;;
	xr4 += fdep r0 by r5;			xr5 = (PLL_DIVF_P   << 8) | 7;;
	xr4 += fdep r1 by r5;			xr5 = (PLL_DIVQ_P   << 8) | 3;		xr1:0 = L[j4 + 0x04];;
	xr4 += fdep r2 by r5;			xr5 = (PLL_RANGE_P  << 8) | 3;;
	xr4 += fdep r3 by r5;			xr5 = (PLL_IVCO_P   << 8) | 3;;
	xr4 += fdep r0 by r5;			xr5 = (PLL_BYPASS_P << 8) | 1;;
	xr4 += fdep r1 by r5;;
  	cjmp(abs);						[j31 + j5] = xr4;;
_setup_pll.end:
  	

  	
//-------------------------------------------------------//
// Core clock selection
//	
//	Arguments:
//		j4:  0 - BCLK (not using PLL - not bypass!)
//			 1 - CPLL out
// 	Outputs:
//		none
// Scratch:	
//		xr3:0, jstat
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _select_core_clock;
_select_core_clock:
	xr1 = [k31 + CPU_CLK_CONFIG_LOC];	xr0 = 0x00;;
	comp(j4, 0);						xr2 = (CPU_CPLL_SEL_P << 8) | 1;;
	if njeq; do, xr0 = 0x01;			xr3 = xr1;;			
	xr1 += fdep r0 by r2;;
	xcomp(r1,r3);;
	if nxaeq; do, [j31 + CPU_CLK_CONFIG_LOC] = xr1;;
	cjmp(abs);;
_select_core_clock.end:	
	

//-------------------------------------------------------//
// Bus clock selection
//	
//	Arguments:
//		j4:  0 - BCLK (not using PLL - not bypass!)
//			 1 - BPLL out
// 	Outputs:
//		none
// Scratch:	
//		xr3:0, jstat
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _select_bus_clock;
_select_bus_clock:
	xr1 = [k31 + CPU_CLK_CONFIG_LOC];	xr0 = 0x00;;
	comp(j4, 0);						xr2 = (CPU_BPLL_SEL_P << 8) | 1;;
	if njeq; do, xr0 = 0x01;			xr3 = xr1;;			
	xr1 += fdep r0 by r2;;
	xcomp(r1,r3);;
	if nxaeq; do, [j31 + CPU_CLK_CONFIG_LOC] = xr1;;
	cjmp(abs);;
_select_bus_clock.end:	


	

//-------------------------------------------------------//
//	Memory 32-bit compare with correct XXXXXXXX handling
//	
//	Arguments:
//		j4 - address 1
//		j5 - address 2
//		j6 - count (of 32-bit words)
// 	Outputs:
//		j8 	<-	0 = equal
//			<-  !0 = different
// Scratch:	
//		j14, j13:12, lc0, xr0, xr2, xr7, xr6, xr5:4
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _compx_mem32;
.align_code 4;
_compx_mem32:	
	// Check for zero count
	j8 = 0x00;;
	comp(j6,0);				xr7 = j31;;
	if jeq, cjmp(abs)(np);	j31 = xr7;;
	j13:12 = j5:4;			xr4 = stat;;	
	xr0 = [j12 += 0x01];	lc0 = j6;;	
	xr2 = [j13 += 0x01];	xr5 = 0x01;;		
	if lc0e, jump _compx_mem32_last(np); 	xcomp(r2,r0);;
_compx_mem32_loop:
	if xaeq;  do, xr5 = dec r5(nf);			xr0 = [j12 += 0x01];;
	if nxaeq; do, xr5 = inc r5(nf);			xr2 = [j13 += 0x01];;
	xr6 = r5 and r5;;
	if nxaeq; do, j8 = j8 + 0x01(nf);		xr5 = 0x01;;
	if nlc0e, jump _compx_mem32_loop;		xcomp(r2,r0);;
_compx_mem32_last:
	if xaeq;  do, xr5 = dec r5(nf);;
	if nxaeq; do, xr5 = inc r5(nf);;
	xr6 = r5 and r5;;
	if nxaeq; do, j8 = j8 + 0x01(nf);;
	cjmp(abs)(np);			xstat = r4;		j31 = xr7;;
_compx_mem32.end:


// j6 = 32-bit word count
// Data being compared must be aligned by 64-bit
.section/charany/doubleany program;
.global _compx_mem64;
.align_code 4;
_compx_mem64:	
	// Check for zero count
	j8 = 0x00;				j14 = LSHIFTR j6(nf);;
	comp(j14,0);			xr7 = j31;;
	if jeq, cjmp(abs)(np);	j31 = xr7;;
	j13:12 = j5:4;			xr4 = stat;;	
	xr1:0 = L[j12 += 0x02];	lc0 = j14;;	
	xr3:2 = L[j13 += 0x02];	xr5 = 0x01;;		
	if lc0e, jump _compx_mem64_last(np); 	xlcomp(r3:2,r1:0);;
_compx_mem64_loop:
	if xaeq;  do, xr5 = dec r5(nf);			xr1:0 = L[j12 += 0x02];;
	if nxaeq; do, xr5 = inc r5(nf);			xr3:2 = L[j13 += 0x02];;
	xr6 = r5 and r5;;
	if nxaeq; do, j8 = j8 + 0x01(nf);		xr5 = 0x01;;
	if nlc0e, jump _compx_mem64_loop;		xlcomp(r3:2,r1:0);;
_compx_mem64_last:
	if xaeq;  do, xr5 = dec r5(nf);;
	if nxaeq; do, xr5 = inc r5(nf);;
	xr6 = r5 and r5;;
	if nxaeq; do, j8 = j8 + 0x01(nf);;
	cjmp(abs)(np);			xstat = r4;		j31 = xr7;;
_compx_mem64.end:







//-------------------------------------------------------//  
//	Single word compare with correct XXXXXXXX handling
//	
//	Arguments:
//		j4 - first word to compare
//		j5 - second word to compare
// 	Outputs:
//		j8 	<-	0 = equal
//			<-	1 = different
// Scratch:	
//		xr4,xr3:0,xstat
//
// Truth table:
//	j4  |  J5       |  j8
// 0xAA   0xAA	       0x00	<- equal 
// 0xAA   0xBB	       0x01 
// 0xBB   0xAA	       0x01	
// 0xBB   0xBB	       0x00	<- equal
// 0xXX	  any *    	   0x01
// 0xZZ   any    	   0x01
// any	  0xXX		   0x01
// any	  0xZZ		   0x01
//
// * any = 0xAA, 0xBB, 0xXX or 0xZZ
//-------------------------------------------------------//  
.section/charany/doubleany program;
.global compx_single_word;
.align_code 4;
compx_single_word:
	xr0 = j4;	xr4 = stat;;
	xr1 = j5;;	
	xr2 = 0x01;;
	xcomp(r0,r1);	j8 = 0x00;;
	if xaeq;  do, xr2 = dec r2;;
	if nxaeq; do, xr2 = inc r2;;
	xr3 = r2 and r2;;
	if nxaeq; do, j8 = 0x01;;
	cjmp(abs);	xstat = r4;;
compx_single_word.end:


// Same as for single word, but arguments are addresses.
// Scratch: xr5:4,xr3:0
.section/charany/doubleany program;
.global compx_long_word_mem;
.align_code 4;
compx_long_word_mem:
	xr1:0 = L[j4 + 0x00];	xr4 = stat;;
	xr3:2 = L[j5 + 0x00];	xr5 = 0x01;;
	xlcomp(r3:2,r1:0);		j8 = 0x00;;
	if xaeq;  do, xr5 = dec r5;;
	if nxaeq; do, xr5 = inc r5;;
	xr3 = r5 and r5;;
	if nxaeq; do, j8 = 0x01;;
	cjmp(abs);	xstat = r4;;
compx_long_word_mem.end:

// Same as for single word, but arguments are addresses.
// Scratch: xyr5:4,xyr3:0
.section/charany/doubleany program;
.global compx_quad_word_mem;
.align_code 4;
compx_quad_word_mem:
	xyr1:0 = Q[j4 + 0x00];	r4 = stat;;
	xyr3:2 = Q[j5 + 0x00];	r5 = 0x01;;
	lcomp(r3:2,r1:0);		j8 = 0x00;;
	if aeq;  do, r5 = dec r5;;
	if naeq; do, r5 = inc r5;;
	r3 = r5 and r5;;
	if nxaeq; do, j8 = 0x01;;
	if nyaeq; do, j8 = j8 or 0x02;;
	cjmp(abs);	xystat = r4;;
compx_quad_word_mem.end:






//-------------------------------------------------------//  
//	Single word compare with correct XXXXXXXX handling
//	Checks for not equality
//	
//	Arguments:
//		j4 - first word to compare
//		j5 - second word to compare
// 	Outputs:
//		j8 	<-	0 = different
//			<-	1 = equal or X/Z
// Scratch:	
//		xr4,xr3:0
//
// Truth table:
//	j4  |  J5       |  j8
// 0xAA   0xAA	       0x01	
// 0xAA   0xBB	       0x00 <- different
// 0xBB   0xAA	       0x00	<- different
// 0xBB   0xBB	       0x01	
// 0xXX	  any *    	   0x01
// 0xZZ   any    	   0x01
// any	  0xXX		   0x01
// any	  0xZZ		   0x01
//
// * any = 0xAA, 0xBB, 0xXX or 0xZZ
//-------------------------------------------------------//  
.section/charany/doubleany program;
.global compx_single_word_neq;
.align_code 4;
compx_single_word_neq:
	xr0 = j4;	xr4 = stat;;
	xr1 = j5;;
	xr2 = 0x00;;
	xr3 = r0 xor r1;	j8 = 0x00;;
	if xaeq;  do, xr2 = dec r2;;
	if nxaeq; do, xr2 = inc r2;;
	xr3 = r2 and r2;;
	if xaeq; do, j8 = 0x01;;	// At least one value is Z or X
	if xaeq, cjmp(abs);	xstat = r4;;
	// Compare as normal 
	xcomp(r0,r1);;
	if xaeq; do, j8 = 0x01;;
	cjmp(abs);	xstat = r4;;


compx_single_word_neq.end:








//-------------------------------------------------------//
//	Copies block of memory
//	Function operates on 32-bit words, not bytes!
//	Argument order is same as standard memcpy() C-function
//
//	Copied from AD's source memcpy_all.asm
//
//	Arguments:
//		j4 - destination address
//		j5 - source address
//		j6 - count (32-bit words)
// 	Outputs:
//		destination
// Scratch:	
//		
//-------------------------------------------------------//

.section/charany/doubleany program;
.global _memcpy32;
_memcpy32:

  j7 = j6 - 1;;                  // count - 1
  comp(j6, 0);                   // test count
    k4 = j4;;                    // copy dest to KALU
  if jeq, cjmp (abs);            // count == 0, so return
    j8 = j4;                     // set return value == dest
    j7 = lshiftr j7;;            // loop count = (count-1)/2
  xr1 = [j5 += 1];               // r1 = first word of source
    xr3 = j7;;                   // move loop count to X block
  if jeq, jump _memcpy32_tail (np); // loop count is 0, so skip loop
    j7 = j6 and 1;;              // test bit 0 of count

.align_code 4;                   // quad align jump target
_memcpy32_loop:
  [k4 += 1] = xr1;               // write r1 to dest
    xr2 = [j5 += 1];             // r2 = next word of source
    xr3 = dec r3 (su);           // decrement loop count
    nop;;                        // force jump target to quad alignment
  if nxaeq, jump _memcpy32_loop;    // loop if count not 0
    [k4 += 1] = xr2;             // write r2 to dest
    xr1 = [j5 += 1];;            // r1 = next word of source

.align_code 4;                   // quad align jump target
_memcpy32_tail:
  if jeq;                        // is count even?
    do, xr2 = [j5 += 1];         // yes, so r2 = next word of source
    [k4 += 1] = xr1;;            // write r1 to dest
  if jeq;                        // is count even?
    do, [k4 += 1] = xr2;;        // yes, so write r2 to dest
  cjmp (abs) ;;

_memcpy32.end:






.section/charany/doubleany program;
.global copy_mem_core_quad;
.align_code 4;
//--------------------------------------------//
// Copy memory by quad-word
// Parameters: 
// 	j4 - source address
// 	j5 - destination address
//	j6 - count (in 32-bit words) 
copy_mem_core_quad:
  j6 = rotr j6;;
  j6 = rotr j6;;
  lc0 = j6;;
copy_mem_core_loop:
  xr3:0 = Q[j4+=0x04];;
  if nlc0e, jump copy_mem_core_loop; Q[j5+=0x04] = xr3:0;;
  cjmp(abs)(np);;
.copy_mem_core_quad.end:
 
  
.section/charany/doubleany program;
.global copy_mem_core_single;
.align_code 4;
//--------------------------------------------//
// Copy memory by single-word
// Parameters: 
// 	j4 - source address
// 	j5 - destination address
//	j6 - count (in 32-bit words) 
copy_mem_core_single:
  lc0 = j6;;
copy_mem_core_single_loop:
  xr0 = [j4+=0x01];;
  if nlc0e, jump copy_mem_core_single_loop; [j5+=0x01] = xr0;;
  cjmp(abs)(np);;
.copy_mem_core_single.end:






.section/charany/doubleany program;
.global check_memory_by_quad;
.align_code 4;
//-------------------------------------------------------//
//	Compares two memory regions by quad-words
// Parameters:
// 	j4 - start address 1
// 	j5 - start address 2
//	j6 - count (in quad words) >= 1
// Outputs:
//	j8 - number of errors
// Scratch:
//	k4,k5,j6, x/yr3:0, x/ystat, jstat
// Additional comparison is made to detect Z or X cases
//-------------------------------------------------------//
check_memory_by_quad:
.align_code 4;
  // First quad word check
  j8 = 0x00;;
  xyr1:0 = Q[j4+=0x00];		k4 = j4;;	
  xyr3:2 = Q[j5+=0x00]; 	k5 = j5;;
  lcomp(r3:2,r1:0);			j6 = j6 - 1;;		k4 = k4 + 0x04 (nf);;
  if nxaeq; do, j8 = j8 + 0x00000001 (nf);		r0 = inc r0 (nf);;
  if nyaeq; do, j8 = j8 + 0x00000001 (nf);		lcomp(r3:2,r1:0);;	
  if jeq, jump check_memory_by_quad_done (np);	k5 = k5 + 0x04 (nf);; 	
  // Main loop
check_memory_by_quad_loop:
  if xaeq; do, j8 = j8 + 0x00010000 (nf);		xyr1:0 = Q[k4+=0x04];;
  if yaeq; do, j8 = j8 + 0x00010000 (nf);		xyr3:2 = Q[k5+=0x04];;
  lcomp(r3:2,r1:0);								j6 = j6 - 1;;
  if nxaeq; do, j8 = j8 + 0x00000001 (nf);	r0 = inc r0 (nf);;
  if nyaeq; do, j8 = j8 + 0x00000001 (nf);	lcomp(r3:2,r1:0);;
  if njeq, jump check_memory_by_quad_loop; nop; nop; nop;;
check_memory_by_quad_done:
  if xaeq; do, j8 = j8 + 0x00010000 (nf);;
  if yaeq; do, j8 = j8 + 0x00010000 (nf);;
  cjmp(np)(abs); nop; nop; nop;;
//-------------------------------------------------------//
.check_memory_by_quad.end:
  
  



//-----------------------------------//
//	Fills memory area with 
//		pseudorandom values
//	j4 - address,
//	j5 - count, 32-bit words
//	j6 - seed
//-----------------------------------//
.align_code 4;
.global fill_mem_with_random;
fill_mem_with_random:
	k4 = j4;;
	lc0 = j5;;
	j4 = j6;			k6 = cjmp;;
fill_mem_rand_loop:
	j5 = 11;;
	call _LFSR32_cycle_fast;;
	if nlc0e, jump fill_mem_rand_loop;	[k4 += 0x01] = j8;	nop; nop;;
	cjmp = k6;;
	cjmp(abs)(np);;
fill_mem_with_random.end:

	

  
  
/***********************************************************
	LFSR assembly generator	
	taps: 32 31 30 28 26 1; charact. polynomial: x^32 + x^31 + x^30 + x^28 + x^26 + x^1 + 1 
    S = ((( (S>>31)^(S>>30)^(S>>29)^(S>>27)^(S>>25)^S ) & 1 ) << 31 ) | (S>>1);
       
    Args:
    	j4 - seed
    Returns:
    	j4 = j8 = result
    	
    Scratch:	 xr3:0, xstat
***********************************************************/

	
	.section/charany program;
	.align_code 4;
	.global _LFSR32_fast;
	
_LFSR32_fast:
	// Input argument:  previous state, j4
	// Output: next state, j8 = j4
	xr0 = j4;	xr1 = ~((1<<31) | (1<<30) | (1<<29) | (1<<27) | (1<<26) | (1<<0));;
	xr2 = r0 and r1;	xr0 = LSHIFT r0 by -1;;
	xr3 = ones r2;		xr1 = 0x1F01;;
	xr0 += fdep r3 by r1;;
	j8 = xr0;;
	cjmp(abs); j4 = j8;;
	
	
_LFSR32_fast.end:
	
/***********************************************************/  
  



/***********************************************************
	LFSR cycle assembly generator	
	taps: 32 31 30 28 26 1; charact. polynomial: x^32 + x^31 + x^30 + x^28 + x^26 + x^1 + 1 
    S = ((( (S>>31)^(S>>30)^(S>>29)^(S>>27)^(S>>25)^S ) & 1 ) << 31 ) | (S>>1);
    
    Args:
    	j4 - seed
    	j5 - count
    Returns:
    	j4 = j8 = result
    	
    Scratch:	xr4, xr3:0, lc1, xstat
***********************************************************/
	.section/charany program;
	.align_code 4;
	.global _LFSR32_cycle_fast;
	
_LFSR32_cycle_fast:
	xr0 = j4;	xr1 = ~((1<<31) | (1<<30) | (1<<29) | (1<<27) | (1<<26) | (1<<0));;
	lc1 = j5;	xr4 = 0x1F01;;
	
_LSFR32_cycle_loop:	
	xr2 = r0 and r1;					xr0 = LSHIFT r0 by -1;;
	xr3 = ones r2;;		
	if nlc1e, jump _LSFR32_cycle_loop; 	xr0 += fdep r3 by r4;;
	
	j8 = xr0;;
	cjmp(abs); j4 = j8;;
_LFSR32_cycle_fast.end:
	
/***********************************************************/ 

  
  
  
/***********************************************************
	LFSR assembly generator	
	taps: 32 31 30 28 26 1; charact. polynomial: x^32 + x^31 + x^30 + x^28 + x^26 + x^1 + 1 
    S = ((( (S>>31)^(S>>30)^(S>>29)^(S>>27)^(S>>25)^S ) & 1 ) << 31 ) | (S>>1);
***********************************************************/

	
	.section/charany program;
	.align_code 4;
	.global _LFSR32;
	
_LFSR32:
	// Input argument:  previous state, j4
	// Output: next state, j8 = j4
	r0 = j4;;
	xr1 = LSHIFT r0 by -31; yr1 = LSHIFT r0 by -30; 	j8 = j4;;
	xr2 = LSHIFT r0 by -29; yr2 = LSHIFT r0 by -27;	yr3 = r0 xor r1;;
	xr2 = LSHIFT r0 by -25; xr3 = r1 xor r2;			yr3 = r3 xor r2;;
	xr3 = r3 xor r2; xr2 = yr3;		j8 = LSHIFTR j8;;
	xr3 = r3 xor r2; xr1 = 0x01;;
	xr3 = r3 and r1;;
	if nxaeq; do, j8 = j8 or 0x80000000;;
	cjmp(abs); j4 = j8;;
	
	
	
_LFSR32.end:
	
/***********************************************************/
  




  
  