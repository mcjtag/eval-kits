#include <defts201.h>
#include "com_utils_asm.h"

//-------------------------------------------------------//
//	32-bit simple incremental block memory test
//	
//	Parameters:
//	j4 - address of a test parameters structure (see headers)
//	j5 - address of a test result structure 
//	Outputs: none
//-------------------------------------------------------//
.section/charany/doubleany program;
.global incremental_block_test_32_write;  
.align_code 4;
incremental_block_test_32_write:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x01;;
  [j13 + 1] = j2;;		// 32-bit test mode
  
  //xr0 = 0x00000000;;	// start value	
  xr0 = [j4 + 2];;
  xr4 = 0x00000001;;	// increment
  j2 = [j12 + 1];;		// count parameter
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
ibt32_write_loop:
  [j0 += 0x01] = xr0;;
  if nlc0e, jump ibt32_write_loop; 	xr0 = r0 + r4;;
  
  // return
  cjmp = k30;;
  cjmp(abs)(np);;
incremental_block_test_32_write.end:  
  
  
.section/charany/doubleany program;
.global incremental_block_test_32_check;  
.align_code 4;
incremental_block_test_32_check:
  k30 = cjmp;;
  nop;;   
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x01;;
  [j13 + 1] = j2;;		// 32-bit test mode
  
  
  //xr0 = 0x00000000;;	// start value	
  xr0 = [j4 + 2];;
  xr4 = 0x00000001;;	// increment
  j2 = [j12 + 1];;		// count parameter
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  xSF0 += xor xSF0;;
ibt32_read_loop:
  xr8 = [j0 + 0x00];;
  xcomp(r0,r8);; 
  xSF0 += or nxaeq;;
  // .... more comps
  if xSF0, jump ibt32_got_error(np);;
  xr0 = r0 + r4;
  j0 = j0 + 0x01;;
  if nlc0e, jump ibt32_read_loop; nop; nop;;
  jump incremental_block_test_32_done(np);;
  
ibt32_got_error:
  j2 = 0x01;;
  [j13 + 0x00] = j2;;	// Error flag
  [j13 + 0x02] = j0;;	// Address
  [j13 + 0x03] = xr0;;	// correct value
  [j13 + 0x07] = xr8;;	// actual value
  
incremental_block_test_32_done:	
	
  cjmp = k30;;
  cjmp(abs); nop; nop;;
incremental_block_test_32_check.end:




//-------------------------------------------------------//
//	64-bit simple incremental block memory test
//	
//	Parameters:
//	j4 - address of a test parameters structure (see headers)
//	j5 - address of a test result structure 
//	Outputs: none
//-------------------------------------------------------//
.section/charany/doubleany program;
.global incremental_block_test_64_write;  
.align_code 4;
incremental_block_test_64_write:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x02;;
  [j13 + 1] = j2;;		// 64-bit test mode
  
  
  //xr0 = 0x00000000;;	// start value	
  xr0 = [j4 + 2];;
  //xr1 = 0x00000001;;
  xr1 = [j4 + 3];;
  xr4 = 0x00000002;;	// increment
  xr5 = 0x00000002;;
  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
ibt64_write_loop:
  L[j0 += 0x02] = xr1:0;;
  if nlc0e, jump ibt64_write_loop; 	xr1:0 = r1:0 + r5:4;;

  cjmp = k30;;
  cjmp(abs)(np);;
incremental_block_test_64_write.end:
  
  
  
  
  
.section/charany/doubleany program;
.global incremental_block_test_64_check;  
.align_code 4;
incremental_block_test_64_check:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x02;;
  [j13 + 1] = j2;;		// 64-bit test mode  
  
  
  //xr0 = 0x00000000;;	// start value	
  xr0 = [j4 + 2];;
  //xr1 = 0x00000001;;
  xr1 = [j4 + 3];;
  xr4 = 0x00000002;;	// increment
  xr5 = 0x00000002;;
  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  xSF0 += xor xSF0;;
ibt64_read_loop:
  xr9:8 = L[j0 + 0x00];;
  xlcomp(r1:0,r9:8);; 
  xSF0 += or nxaeq;;
  // .... more comps
  if xSF0, jump ibt64_got_error(np);;
  xr1:0 = r1:0 + r5:4;
  j0 = j0 + 0x02;;
  if nlc0e, jump ibt64_read_loop; nop; nop;;
  jump incremental_block_test_64_done(np);;
  
ibt64_got_error:
  j2 = 0x01;;
  [j13 + 0x00] = j2;;	// Error flag
  [j13 + 0x02] = j0;;	// Address
  [j13 + 0x03] = xr0;;	// correct value
  [j13 + 0x04] = xr1;;
  [j13 + 0x07] = xr8;;	// actual value
  [j13 + 0x08] = xr9;;
  
  
incremental_block_test_64_done:	
	
  cjmp = k30;;
  cjmp(abs); nop; nop;;
incremental_block_test_64_check.end:











//-------------------------------------------------------//
//	128-bit simple incremental block memory test
//	
//	Parameters:
//	j4 - address of a test parameters structure (see headers)
//	j5 - address of a test result structure 
//	Outputs: none
//-------------------------------------------------------//
.section/charany/doubleany program;
.global incremental_block_test_128_write;  
.align_code 4;
incremental_block_test_128_write:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x04;;
  [j13 + 1] = j2;;		// 128-bit test mode
  
  
  //xr0 = 0x00000000;;	// start value	
  //xr1 = 0x00000001;;
  //xr2 = 0x00000002;;
  //xr3 = 0x00000003;;
  xr0 = [j4 + 2];;
  xr1 = [j4 + 3];;
  xr2 = [j4 + 4];;
  xr3 = [j4 + 5];;
  
  xr4 = 0x00000004;;	// increment
  xr5 = 0x00000004;;
  xr6 = 0x00000004;;
  xr7 = 0x00000004;;
  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
ibt128_write_loop:
  Q[j0 += 0x04] = xr3:0;				xr1:0 = r1:0 + r5:4;;
  if nlc0e, jump ibt128_write_loop; 	xr3:2 = r3:2 + r7:6;;

  cjmp = k30;;
  cjmp(abs)(np);;
incremental_block_test_128_write.end:  
  
  
  
  
  
.section/charany/doubleany program;
.global incremental_block_test_128_check;  
.align_code 4;
incremental_block_test_128_check:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x04;;
  [j13 + 1] = j2;;		// 128-bit test mode
  
  //xr0 = 0x00000000;;	// start value	
  //xr1 = 0x00000001;;
  //xr2 = 0x00000002;;
  //xr3 = 0x00000003;;
  xr0 = [j4 + 2];;
  xr1 = [j4 + 3];;
  xr2 = [j4 + 4];;
  xr3 = [j4 + 5];;
  
  xr4 = 0x00000004;;	// increment
  xr5 = 0x00000004;;
  xr6 = 0x00000004;;
  xr7 = 0x00000004;;
  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  xSF0 += xor xSF0;;
ibt128_read_loop:
  xr11:8 = Q[j0 + 0x00];;
  xlcomp(r1:0,r9:8);; 
  xSF0 += or nxaeq;	xlcomp(r3:2,r11:10);;
  xSF0 += or nxaeq;;
  // .... more comps
  if xSF0, jump ibt128_got_error(np);;
  xr1:0 = r1:0 + r5:4;;
  xr3:2 = r3:2 + r7:6;
  j0 = j0 + 0x04;;
  if nlc0e, jump ibt128_read_loop; nop; nop;;
  jump incremental_block_test_128_done(np);;
  
ibt128_got_error:
  j2 = 0x01;;
  [j13 + 0x00] = j2;;	// Error flag
  [j13 + 0x02] = j0;;	// Address
  [j13 + 0x03] = xr0;;	// correct value
  [j13 + 0x04] = xr1;;
  [j13 + 0x05] = xr2;;
  [j13 + 0x06] = xr3;;
  [j13 + 0x07] = xr8;;	// actual value
  [j13 + 0x08] = xr9;;
  [j13 + 0x09] = xr10;;
  [j13 + 0x0A] = xr11;;
  
incremental_block_test_128_done:	
	
  cjmp = k30;;
  cjmp(abs); nop; nop;;
incremental_block_test_128_check.end:








//-------------------------------------------------------//
//	32-bit simple incremental slow write/read memory test
//	
//	Parameters:
//	j4 - address of a test parameters structure (see headers)
//	j5 - address of a test result structure 
//	Outputs: none
//-------------------------------------------------------//
.section/charany/doubleany program;
.global incremental_slow_wr_test_32;  
.align_code 4;
incremental_slow_wr_test_32:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x01;;
  [j13 + 1] = j2;;		// 32-bit test mode
  
  
  //xr0 = 0x00000000;;	// start value	
  xr0 = [j4 + 2];;
  xr4 = 0x00000001;;	// increment
  j2 = [j12 + 1];;		// count parameter
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  xSF0 += xor xSF0;;
iswrt32_test_loop:
  // Write
  [j0 + 0x00] = xr0;;
  call wait; lc1 = 0x40;;
  // Read
  xr8 = [j0 + 0x00];;
  xcomp(r0,r8);; 
  xSF0 += or nxaeq;;
  // .... more comps
  if xSF0, jump iswrt32_got_error(np);;
  xr0 = r0 + r4;
  j0 = j0 + 0x01;;
  if nlc0e, jump iswrt32_test_loop;;
  jump incremental_slow_wr_test_32_done(np);;
  
  
iswrt32_got_error:
  j2 = 0x01;;
  [j13 + 0x00] = j2;;	// Error flag
  [j13 + 0x02] = j0;;	// Address
  [j13 + 0x03] = xr0;;	// correct value
  [j13 + 0x07] = xr8;;	// actual value
  
  
incremental_slow_wr_test_32_done:	
	
  cjmp = k30;;
  cjmp(abs); nop; nop;;
incremental_slow_wr_test_32.end:





//-------------------------------------------------------//
//	64-bit simple incremental slow write/read memory test
//	
//	Parameters:
//	j4 - address of a test parameters structure (see headers)
//	j5 - address of a test result structure 
//	Outputs: none
//-------------------------------------------------------//
.section/charany/doubleany program;
.global incremental_slow_wr_test_64;  
.align_code 4;
incremental_slow_wr_test_64:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x02;;
  [j13 + 1] = j2;;		// 64-bit test mode
  
  
  
  //xr0 = 0x00000000;;	// start value	
  //xr1 = 0x00000001;;
  xr0 = [j4 + 2];;
  xr1 = [j4 + 3];;
  xr4 = 0x00000002;;	// increment
  xr5 = 0x00000002;;	// increment
  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  xSF0 += xor xSF0;;
iswrt64_test_loop:
  // Write
  L[j0 + 0x00] = xr1:0;;
  call wait; lc1 = 0x40;;
  // Read
  xr9:8 = L[j0 + 0x00];;
  xlcomp(r1:0,r9:8);; 
  xSF0 += or nxaeq;;
  // .... more comps
  if xSF0, jump iswrt64_got_error(np);;
  xr1:0 = r1:0 + r5:4;
  j0 = j0 + 0x02;;
  if nlc0e, jump iswrt64_test_loop;;
  jump incremental_slow_wr_test_64_done(np);;
  
  
iswrt64_got_error:
  j2 = 0x01;;
  [j13 + 0x00] = j2;;	// Error flag
  [j13 + 0x02] = j0;;	// Address
  [j13 + 0x03] = xr0;;	// correct value
  [j13 + 0x04] = xr1;;	// correct value
  [j13 + 0x07] = xr8;;	// actual value
  [j13 + 0x08] = xr9;;	// actual value
  
  
incremental_slow_wr_test_64_done:	
	
  cjmp = k30;;
  cjmp(abs); nop; nop;;
incremental_slow_wr_test_64.end:



//-------------------------------------------------------//
//	128-bit simple incremental slow write/read memory test
//	
//	Parameters:
//	j4 - address of a test parameters structure (see headers)
//	j5 - address of a test result structure 
//	Outputs: none
//-------------------------------------------------------//
.section/charany/doubleany program;
.global incremental_slow_wr_test_128;  
.align_code 4;
incremental_slow_wr_test_128:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x04;;
  [j13 + 1] = j2;;		// 128-bit test mode
  
  
  //xr0 = 0x00000000;;	// start value	
  //xr1 = 0x00000001;;
  //xr2 = 0x00000002;;
  //xr3 = 0x00000003;;
  xr0 = [j4 + 2];;
  xr1 = [j4 + 3];;
  xr2 = [j4 + 4];;
  xr3 = [j4 + 5];;
  xr4 = 0x00000002;;	// increment
  xr5 = 0x00000002;;	
  xr6 = 0x00000002;;
  xr7 = 0x00000002;;
  
  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  xSF0 += xor xSF0;;
iswrt128_test_loop:
  // Write
  Q[j0 + 0x00] = xr3:0;;
  call wait; lc1 = 0x40;;
  // Read
  xr11:8 = Q[j0 + 0x00];;
  xlcomp(r1:0,r9:8);; 
  xSF0 += or nxaeq;	xlcomp(r3:2,r11:10);;
  xSF0 += or nxaeq;;
  if xSF0, jump iswrt128_got_error(np);;
  xr1:0 = r1:0 + r5:4;;
  xr3:2 = r3:2 + r7:6;
  j0 = j0 + 0x04;;
  if nlc0e, jump iswrt128_test_loop;;
  jump incremental_slow_wr_test_128_done(np);;
  
  
iswrt128_got_error:
  j2 = 0x01;;
  [j13 + 0x00] = j2;;	// Error flag
  [j13 + 0x02] = j0;;	// Address
  [j13 + 0x03] = xr0;;	// correct value
  [j13 + 0x04] = xr1;;	
  [j13 + 0x05] = xr2;;	
  [j13 + 0x06] = xr3;;	
  [j13 + 0x07] = xr8;;	// actual value
  [j13 + 0x08] = xr9;;	
  [j13 + 0x09] = xr10;;	
  [j13 + 0x0A] = xr11;;	
  
  
  
incremental_slow_wr_test_128_done:	
	
  cjmp = k30;;
  cjmp(abs); nop; nop;;
incremental_slow_wr_test_128.end:









//-------------------------------------------------------//
//	128-bit inverting write/read memory test
//	
//	Parameters:
//	j4 - address of a test parameters structure (see headers)
//	j5 - address of a test result structure 
//	Outputs: none
//-------------------------------------------------------//
.section/charany/doubleany program;
.global mem_test_inverting_bits_128_write;  
.align_code 4;
mem_test_inverting_bits_128_write:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x04;;
  [j13 + 1] = j2;;		// 128-bit test mode
  
  xr0 = [j12 + 2];;		// start value
  xr1 = [j12 + 3];;
  xr2 = [j12 + 4];;
  xr3 = [j12 + 5];;
  
  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  
mt_inv_bits_128_write_loop:
  Q[j0 += 0x04] = xr3:0;						xlr1:0 = not r1:0;;
  if nlc0e, jump mt_inv_bits_128_write_loop;	xlr3:2 = not r3:2;;
  
  cjmp = k30;;
  cjmp(abs)(np);;
mem_test_inverting_bits_128_write.end:
  
  
  
  
.section/charany/doubleany program;
.global mem_test_inverting_bits_128_check;  
.align_code 4;
mem_test_inverting_bits_128_check:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x04;;
  [j13 + 1] = j2;;		// 128-bit test mode
  
  r0 = [j12 + 2];;		// start value
  r1 = [j12 + 3];;
  r2 = [j12 + 4];;
  r3 = [j12 + 5];;

  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  xSF0 += xor xSF0;;	
  
mt_inv_bits_128_read_loop:
  xr11:8 = Q[j0 + 0x00];	ylr1:0 = not r1:0;;
  xlcomp(r1:0,r9:8);;		ylr3:2 = not r3:2;;
  xSF0 += or nxaeq;			xlcomp(r3:2,r11:10);;
  xSF0 += or nxaeq;;
  // .... more comps
  if xSF0, jump mt_inv_bits_128_got_error(np);	else, j0 = j0 + 0x04;;
  if nlc0e, jump mt_inv_bits_128_read_loop;		xr3:0 = yr3:0;;
  jump mt_inv_bits_128bit_done(np);;
  
mt_inv_bits_128_got_error:
  j2 = 0x01;;
  [j13 + 0x00] = j2;;	// Error flag
  [j13 + 0x02] = j0;;	// Address
  [j13 + 0x03] = xr0;;	// correct value
  [j13 + 0x04] = xr1;;	
  [j13 + 0x05] = xr2;;	
  [j13 + 0x06] = xr3;;	
  [j13 + 0x07] = xr8;;	// actual value
  [j13 + 0x08] = xr9;;	
  [j13 + 0x09] = xr10;;	
  [j13 + 0x0A] = xr11;;	
  
mt_inv_bits_128bit_done:
	
  cjmp = k30;;
  cjmp(abs); nop; nop;;
mem_test_inverting_bits_128_check.end:









//-------------------------------------------------------//
//	128-bit rotating bits write/read memory test
//	
//	Parameters:
//	j4 - address of a test parameters structure (see headers)
//	j5 - address of a test result structure 
//	Outputs: none
//-------------------------------------------------------//
.section/charany/doubleany program;
.global mem_test_rotating_bits_128_write;  
.align_code 4;
mem_test_rotating_bits_128_write:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x04;;
  [j13 + 1] = j2;;		// 128-bit test mode
  
  xr0 = [j12 + 2];;		// start value
  xr1 = [j12 + 3];;
  xr2 = [j12 + 4];;
  xr3 = [j12 + 5];;
  
  xr12 = 3;;			// rotate control for low long word
  xr13 = -3;;			// rotate control for high long word
  
  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  
mt_rotate_bits_128_write_loop:
  Q[j0 += 0x04] = xr3:0;						xr1:0 = ROT r1:0 by r12;;
  if nlc0e, jump mt_rotate_bits_128_write_loop;	xr3:2 = ROT r3:2 by r13;;
  
  cjmp = k30;;
  cjmp(abs)(np);;
mem_test_rotating_bits_128_write.end:
  
  
  
  
.section/charany/doubleany program;
.global mem_test_rotating_bits_128_check;  
.align_code 4;
mem_test_rotating_bits_128_check:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x04;;
  [j13 + 1] = j2;;		// 128-bit test mode
  
  r0 = [j12 + 2];;		// start value
  r1 = [j12 + 3];;
  r2 = [j12 + 4];;
  r3 = [j12 + 5];;
  
  yr12 = 3;;			// rotate control for low long word
  yr13 = -3;;			// rotate control for high long word

  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  xSF0 += xor xSF0;;	
  
mt_rotate_bits_128_read_loop:
  xr11:8 = Q[j0 + 0x00];	yr1:0 = ROT r1:0 by r12;;
  xlcomp(r1:0,r9:8);;		yr3:2 = ROT r3:2 by r13;;
  xSF0 += or nxaeq;			xlcomp(r3:2,r11:10);;
  xSF0 += or nxaeq;;
  // .... more comps
  if xSF0, jump mt_rotate_bits_128_got_error(np);	else, j0 = j0 + 0x04;;
  if nlc0e, jump mt_rotate_bits_128_read_loop;		xr3:0 = yr3:0;;
  jump mt_rotate_bits_128bit_done(np);;
  
mt_rotate_bits_128_got_error:
  j2 = 0x01;;
  [j13 + 0x00] = j2;;	// Error flag
  [j13 + 0x02] = j0;;	// Address
  [j13 + 0x03] = xr0;;	// correct value
  [j13 + 0x04] = xr1;;	
  [j13 + 0x05] = xr2;;	
  [j13 + 0x06] = xr3;;	
  [j13 + 0x07] = xr8;;	// actual value
  [j13 + 0x08] = xr9;;	
  [j13 + 0x09] = xr10;;	
  [j13 + 0x0A] = xr11;;	
  
mt_rotate_bits_128bit_done:
	
  cjmp = k30;;
  cjmp(abs); nop; nop;;
mem_test_rotating_bits_128_check.end:






//-------------------------------------------------------//
//	128-bit pseudo-random write/read memory test
//	
//	Parameters:
//	j4 - address of a test parameters structure (see headers)
//	j5 - address of a test result structure 
//	Outputs: none
//-------------------------------------------------------//
.section/charany/doubleany program;
.global mem_test_pseudorandom_128_write;  
.align_code 4;
mem_test_pseudorandom_128_write:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x04;;
  [j13 + 1] = j2;;		// 128-bit test mode
  
  j8 = [j12 + 2];;		// start seed value
  j9 = [j12 + 3];;
  j10 = [j12 + 4];;
  j11 = [j12 + 5];;
  
  r3:0 = j11:8;;
  j5 = 32;;				// LFSR cycle count
  
  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  
mt_prand_128_write_loop:
  Q[j0 += 0x04] = xr3:0;;	
  call _LFSR32_cycle_fast;	j4 = yr0;;
  yr0 = j8;;	call _LFSR32_cycle_fast;	j4 = yr1;	nop;;
  yr1 = j8;;	call _LFSR32_cycle_fast;	j4 = yr2;	nop;;
  yr2 = j8;;	call _LFSR32_cycle_fast;	j4 = yr3;	nop;;
  yr3 = j8;;
  if nlc0e, jump mt_prand_128_write_loop;	xr3:0 = yr3:0;;
  
  cjmp = k30;;
  cjmp(abs)(np);;
mem_test_pseudorandom_128_write.end:
  
  
  
  
.section/charany/doubleany program;
.global mem_test_pseudorandom_128_check;  
.align_code 4;
mem_test_pseudorandom_128_check:
  k30 = cjmp;;
  nop;; 
  
  // Save params
  j12 = j4;;	
  j13 = j5;;
  
  // Prepare result
  j2 = 0x00;;
  [j13 + 0] = j2;;		// no errors apriory
  j2 = 0x04;;
  [j13 + 1] = j2;;		// 128-bit test mode
  
  j8 = [j12 + 2];;		// start seed value
  j9 = [j12 + 3];;
  j10 = [j12 + 4];;
  j11 = [j12 + 5];;
  
  r3:0 = j11:8;;
  j5 = 32;;				// LFSR cycle count

  j2 = [j12 + 1];;		// count parameter
  j2 = LSHIFTR j2;;
  j2 = LSHIFTR j2;;
  lc0 = j2;;  
  j0 = [j12 + 0];;		// address
  xSF0 += xor xSF0;;	
  
mt_prand_128_read_loop:
  xr11:8 = Q[j0 + 0x00];;	
  xlcomp(r1:0,r9:8);;		
  xSF0 += or nxaeq;			xlcomp(r3:2,r11:10);;
  xSF0 += or nxaeq;;
  // .... more comps
  if xSF0, jump mt_prand_128_got_error(np);	else, j0 = j0 + 0x04;;
  call _LFSR32_cycle_fast;	j4 = yr0;;
  yr0 = j8;;	call _LFSR32_cycle_fast;	j4 = yr1;	nop;;
  yr1 = j8;;	call _LFSR32_cycle_fast;	j4 = yr2;	nop;;
  yr2 = j8;;	call _LFSR32_cycle_fast;	j4 = yr3;	nop;;
  yr3 = j8;;
  if nlc0e, jump mt_prand_128_read_loop;	xr3:0 = yr3:0;	nop;;
  jump mt_prand_128bit_done(np);;
  
mt_prand_128_got_error:
  j2 = 0x01;;
  [j13 + 0x00] = j2;;	// Error flag
  [j13 + 0x02] = j0;;	// Address
  [j13 + 0x03] = xr0;;	// correct value
  [j13 + 0x04] = xr1;;	
  [j13 + 0x05] = xr2;;	
  [j13 + 0x06] = xr3;;	
  [j13 + 0x07] = xr8;;	// actual value
  [j13 + 0x08] = xr9;;	
  [j13 + 0x09] = xr10;;	
  [j13 + 0x0A] = xr11;;	
  
mt_prand_128bit_done:
	
  cjmp = k30;;
  cjmp(abs); nop; nop;;
mem_test_pseudorandom_128_check.end:























  
wait:
  nop;;
  nop;;
  nop;;
  if nlc1e, jump wait; nop; nop; nop;;
  cjmp (abs)(np);;



  
#if 0
  
  
  
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

	
	.section/charany/doubleany program;
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
	.section/charany/doubleany program;
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

	
	.section/charany/doubleany program;
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
  
  
  
  
  
#endif  
  
  

