

#include <defts201.h>




.section/charany/doubleany program;
.align 4;
//-------------------------------------------------------//
// DMA pause bits position decode table
// Value returned should be used ORed/AND NOTed with DCNT
//-------------------------------------------------------//
.var _DCNT_BITS_TABLE [] = 
{
	DCNT_DMA0,	// ch #0
	DCNT_DMA1,	// ch #1
	DCNT_DMA2,	// ch #2
	DCNT_DMA3,	// ch #3
	DCNT_DMA4,	// ch #4
	DCNT_DMA5,	// ch #5
	DCNT_DMA6,	// ch #6
	DCNT_DMA7,	// ch #7
	
	DCNT_DMA8,	// ch #8
	DCNT_DMA9,	// ch #9
	DCNT_DMA10,	// ch #10
	DCNT_DMA11,	// ch #11
	DCNT_DMA12,	// ch #12
	DCNT_DMA13	// ch #13
};  


//-------------------------------------------------------//
// DMA status decode table
// Value returned should be used with "fext" instruction
//-------------------------------------------------------//
.align 4;
.var _DSTAT_CODE_TABLE [] = 
{
	// LOW group
	DSTATL0,	// ch #0
	DSTATL1,	// ch #1
	DSTATL2,	// ch #2
	DSTATL3,	// ch #3
	DSTATL4,	// ch #4
	DSTATL5,	// ch #5
	DSTATL6,	// ch #6
	DSTATL7,	// ch #7
	// High group
	DSTATH8,	// ch #8
	DSTATH9,	// ch #9
	DSTATH10,	// ch #10
	DSTATH11,	// ch #11
	DSTATH12,	// ch #12
	DSTATH13	// ch #13
};	


.align 4;
.var _zero_qw [] = 
{
	
	0,	0,	0,	0
};	

	
	
//-------------------------------------------------------//
//	Reading of a DMA channel TCB by index
//  Used by DMA chain insertion routine
//-------------------------------------------------------//
.section/charany program;
.align_code 4;
_get_indexed_tcb:
	cjmp(abs);	j3:0 = DCS0;	nop; nop;;	// + 0
	cjmp(abs);	j3:0 = DCS1;	nop; nop;;	// + 4
	cjmp(abs);	j3:0 = DCS2;	nop; nop;;	// + 8
	cjmp(abs);	j3:0 = DCS3;	nop; nop;;
	cjmp(abs);	j3:0 = DC4;		nop; nop;;
	cjmp(abs);	j3:0 = DC5;		nop; nop;;
	cjmp(abs);	j3:0 = DC6;		nop; nop;;
	cjmp(abs);	j3:0 = DC7;		nop; nop;;
	cjmp(abs);	j3:0 = DC8;		nop; nop;;
	cjmp(abs);	j3:0 = DC9;		nop; nop;;
	cjmp(abs);	j3:0 = DC10;	nop; nop;;
	cjmp(abs);	j3:0 = DC11;	nop; nop;;
	cjmp(abs);	j3:0 = DC12;	nop; nop;;
	cjmp(abs);	j3:0 = DC13;	nop; nop;;	// + 52
	nop;		nop;			nop; nop;;
	nop;		nop;			nop; nop;;
	cjmp(abs);	j3:0 = DCD0;	nop; nop;;	// + 64 (0x40)
	cjmp(abs);	j3:0 = DCD1;	nop; nop;;	// + 68
	cjmp(abs);	j3:0 = DCD2;	nop; nop;;	// + 72
	cjmp(abs);	j3:0 = DCD3;	nop; nop;;	// + 76

//-------------------------------------------------------//
//	Writing of a DMA channel TCB by index
//  Used by DMA chain insertion routine
//-------------------------------------------------------//	
.section/charany program;
.align_code 4;
_set_indexed_tcb:
	cjmp(abs);	DCS0 = j3:0;	nop; nop;;	// + 0
	cjmp(abs);	DCS1 = j3:0;	nop; nop;;	// + 4
	cjmp(abs);	DCS2 = j3:0;	nop; nop;;	// + 8
	cjmp(abs);	DCS3 = j3:0;	nop; nop;;
	cjmp(abs);	DC4 = j3:0;		nop; nop;;
	cjmp(abs);	DC5 = j3:0;		nop; nop;;
	cjmp(abs);	DC6 = j3:0;		nop; nop;;
	cjmp(abs);	DC7 = j3:0;		nop; nop;;
	cjmp(abs);	DC8 = j3:0;		nop; nop;;
	cjmp(abs);	DC9 = j3:0;		nop; nop;;
	cjmp(abs);	DC10 = j3:0;	nop; nop;;
	cjmp(abs);	DC11 = j3:0;	nop; nop;;
	cjmp(abs);	DC12 = j3:0;	nop; nop;;
	cjmp(abs);	DC13 = j3:0;	nop; nop;;	// + 52
	nop;		nop;			nop; nop;;
	nop;		nop;			nop; nop;;
	cjmp(abs);	DCD0 = j3:0;	nop; nop;;	// + 64 (0x40)
	cjmp(abs);	DCD1 = j3:0;	nop; nop;;	// + 68
    cjmp(abs);	DCD2 = j3:0;	nop; nop;;
	cjmp(abs);	DCD3 = j3:0;	nop; nop;;
	



//-------------------------------------------------------//
//	Reading DMA channel status
//	
// Arguments:
//		j4 - channel number
// Outputs:
//		j8 	<-	value
// Scratch:	
//		xr3:0, jstat
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _DMA_GetChannelStatus;
.align_code 4;
_DMA_GetChannelStatus:
	comp(j4, 7)(U);	xr1:0 = DSTAT;;
	if njle; 		do, xr0 = xr1;  	xr2 = [j4 + _DSTAT_CODE_TABLE];;
	xr3 = fext r0 by r2 (nf);;
	cjmp (abs);		j8 = xr3;;
_DMA_GetChannelStatus.end:



//-------------------------------------------------------//
//	Reading DMA channel status with clear
//	
// Arguments:
//		j4 - channel number
// Outputs:
//		j8 	<-	value
// Scratch:	
//		xr3:0, jstat
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _DMA_GetChannelStatusClear;
.align_code 4;
_DMA_GetChannelStatusClear:
	comp(j4, 7)(U);	xr1:0 = DSTATC;;
	if njle; 		do, xr0 = xr1;  	xr2 = [j4 + _DSTAT_CODE_TABLE];;
	xr3 = fext r0 by r2 (nf);;
	cjmp (abs);		j8 = xr3;;
_DMA_GetChannelStatusClear.end:



//-------------------------------------------------------//
//	Check DMA channel status
//	
//	Arguments:
//		j4 - channel number
//		j5 - value to compare with
// 	Outputs:
//		j8 <- 0 if channel status is equal to j5
//			  1 if not equal
// Scratch:	
//		xr3:0, xr4, jstat
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _DMA_CheckChannelStatus;
.align_code 4;
_DMA_CheckChannelStatus:
	call _DMA_GetChannelStatus;	xr4 = cjmp;;
	comp(j8, j5);		 		j8 = 0x00;;
	if njeq; do, j8 = 0x01;		cjmp = xr4;;
	cjmp(abs)(np);	nop; nop; nop;;
_DMA_CheckChannelStatus.end:






//-------------------------------------------------------//
//	Wait for the channel to complete -
//			status is different from ACTIVE
//	
//	Arguments:
//		j4 - channel number
//		
// 	Outputs:
//		j8 <- channel status
// Scratch:	
//		xr3:0, xr4, jstat
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _DMA_WaitForChannel;
.align_code 4;
_DMA_WaitForChannel:
	xr4 = cjmp;;
_DMA_WaitForChannel_loop:
	call _DMA_GetChannelStatus;;
	comp(j8, DSTAT_ACT);;
	nop;;
	nop;;
	if jeq, jump _DMA_WaitForChannel_loop; else, cjmp = xr4;;
	cjmp(abs)(np);;
_DMA_WaitForChannel.end:



//-------------------------------------------------------//
//	Wait for the channel to complete with allowed timeout -
//			status is different from ACTIVE
//	
//	Arguments:
//		j4 - channel number
//		j5 - timeout (core cycles)
// 	Outputs:
//		j8 <- channel status
// Scratch:	
//		xr3:0, yr3:0,  xr4, jstat, 
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _DMA_WaitForChannelTimed;
.align_code 4;
_DMA_WaitForChannelTimed:
	yr0 = CCNT0;			yr2 = j5;;
	yr1 = CCNT1;			yr3 = 0;;
	ylr3:2 = r1:0 + r3:2;	xr4 = cjmp;;
_DMA_WaitForChannelTimed_loop:
	call _DMA_GetChannelStatus;;
	comp(j8, DSTAT_ACT);	cjmp = xr4;;
	yr0 = CCNT0;;
	yr1 = CCNT1;;
	if njeq, cjmp(abs)(np);;	// channel is done
	// Check timeout
	ylr1:0 = r1:0 - r3:2;;
	if yalt, jump _DMA_WaitForChannelTimed_loop;;
	cjmp(abs)(np);;				// timeout 
_DMA_WaitForChannelTimed.end:








//-------------------------------------------------------//
//	Write quadword from memory to DMA control regs
//	
//	Arguments:
//		j4 - channel number (4 to 13)
//		j5 - pointer to qw (must be 4-aligned!)
// 	Outputs:
//		none
// Scratch:	
//		xr3:0, jstat, j7:6
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _DMA_WriteDC;
.align_code 4;
_DMA_WriteDC:
	xr3:0 = Q[j5 + 0x00];;	
	comp(j4, 3)(U);;
	if jle, cjmp(abs)(np);	comp(j4, 13)(U);;
	if njle, cjmp(abs)(np);	j6 = rotl j4(nf);;	
	j6 = rotl j6;			j7 = cjmp;;
	j6 = j6 + _DMA_WriteDC_Tbl - (4*4)(cjmp)(nf);;
	cjmp(abs);				cjmp = j7;;
.align_code 4;
_DMA_WriteDC_Tbl:
	cjmp(abs);	DC4 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DC5 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DC6 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DC7 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DC8 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DC9 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DC10 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DC11 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DC12 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DC13 = xr3:0;	nop; 	nop;;
_DMA_WriteDC.end:



//-------------------------------------------------------//
//	Write quadword from memory to DMA control regs (DCS)
//	
//	Arguments:
//		j4 - channel number (0 to 3)
//		j5 - pointer to qw (must be 4-aligned!)
// 	Outputs:
//		none
// Scratch:	
//		xr3:0, jstat, j7:6
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _DMA_WriteDCS;
.align_code 4;
_DMA_WriteDCS:
	xr3:0 = Q[j5 + 0x00];;
	comp(j4, 3)(U);;
	if njle, cjmp(abs)(np);	j6 = rotl j4(nf);;	
	j6 = rotl j6;			j7 = cjmp;;
	j6 = j6 + _DMA_WriteDCS_Tbl(cjmp)(nf);;
	cjmp(abs);				cjmp = j7;;
.align_code 4;
_DMA_WriteDCS_Tbl:
	cjmp(abs);	DCS0 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DCS1 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DCS2 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DCS3 = xr3:0;	nop; 	nop;;
_DMA_WriteDCS.end:



//-------------------------------------------------------//
//	Write quadword from memory to DMA control regs (DCD)
//	
//	Arguments:
//		j4 - channel number (0 to 3)
//		j5 - pointer to qw (must be 4-aligned!)
// 	Outputs:
//		none
// Scratch:	
//		xr3:0, jstat, j7:6
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _DMA_WriteDCD;
.align_code 4;
_DMA_WriteDCD:
	xr3:0 = Q[j5 + 0x00];;
	comp(j4, 3)(U);;
	if njle, cjmp(abs)(np);	j6 = rotl j4(nf);;	
	j6 = rotl j6;			j7 = cjmp;;
	j31 = j6 + _DMA_WriteDCD_Tbl(cjmp)(nf);;
	cjmp(abs);				cjmp = j7;;
.align_code 4;
_DMA_WriteDCD_Tbl:
	cjmp(abs);	DCD0 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DCD1 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DCD2 = xr3:0;	nop; 	nop;;
	cjmp(abs);	DCD3 = xr3:0;	nop; 	nop;;
_DMA_WriteDCD.end:







//-------------------------------------------------------//
//	Stop DMA channel
//	
//	Arguments:
//		j4 - channel number
// 	Outputs:
//		none
// Scratch:	
//		xr3:0, jstat, j7:6, j8
//-------------------------------------------------------//
.section/charany/doubleany program;
.global _DMA_Stop;
.align_code 4;
_DMA_Stop:
	comp(j4, 3)(U);	j8 = cjmp;;
	if njle, jump _DMA_Stop_SingleDC(np);	j5 = _zero_qw;;
	call _DMA_WriteDCS; nop; nop; nop;;
	call _DMA_WriteDCD; nop; nop; nop;;
	cjmp = j8;;
	cjmp(abs);	nop; nop; nop;;
_DMA_Stop_SingleDC:
	call _DMA_WriteDC; nop; nop; nop;;
	cjmp = j8;;
	cjmp(abs);	nop; nop; nop;;
_DMA_Stop.end:




//-------------------------------------------------------//
//	Pause single DMA channel
// Not interrupt-safe!
//
//	Arguments:
//		j4 - selected DMA channel, 0 to 13
// Outputs:
//		j8: <- 0 if channel was not paused
//			<- 1 if channel was paused already
// Scratch:
//		xr1:0, yr1:0, xstat, ystat
//-------------------------------------------------------//
.section/charany program;
.global _DMA_PauseChannel;
.align_code 4;
_DMA_PauseChannel:
	r0 = DCNT;	r1 = [j4 + address(_DCNT_BITS_TABLE)];;
	xr0 = r0 or r1;		yr0 = r0 and r1;	j8 = 0x00;;
	if nyaeq; do, j8 = j8 + 0x01 (nf);	 	DCNT = xr0;;
	cjmp(abs); nop; nop; nop;;
_DMA_PauseChannel.end:



//-------------------------------------------------------//
//	Unpause single DMA channel
// Not interrupt-safe!
//
//	Arguments:
//		j4 - selected DMA channel, 0 to 13
//  Outputs:
//		j8: <- 0 if channel was paused
//		<- 1 if channel was not paused
//  Scratch:
//		xr1:0, yr1:0, xstat, ystat
//-------------------------------------------------------//
.section/charany program;
.global _DMA_UnpauseChannel;
.align_code 4;
_DMA_UnpauseChannel:
	r0 = DCNT;	r1 = [j4 + address(_DCNT_BITS_TABLE)];;
	xr0 = r0 and not r1;			yr0 = r0 and r1;	j8 = 0x00;;
	if yaeq; do, j8 = j8 + 0x01 (nf); 		DCNT = xr0;;
	cjmp(abs); nop; nop; nop;;
_DMA_UnpauseChannel.end:



//-------------------------------------------------------//
//	Pause multiple DMA channels
// Not interrupt-safe!
//
//	Arguments:
//		j4 - selected DMA channels, ORed DCNT_DMA0 to DCNT_DMA13 (see defts201.h)
// 	Outputs:
//		none
//  Scratch:
//		j5
//-------------------------------------------------------//	
.section/charany program;
.global _DMA_PauseMultipleChannels;
.align_code 4;
_DMA_PauseMultipleChannels:
	j5 = DCNT;;
	j5 = j5 or j4;;
	cjmp(abs); DCNT = j5; nop; nop;;
_DMA_PauseMultipleChannels.end:



//-------------------------------------------------------//
//	Unpause multiple DMA channels
// Not interrupt-safe!
//
//	Arguments:
//		j4 - selected DMA channels, ORed DCNT_DMA0 to DCNT_DMA13 (see defts201.h)
// 	Outputs:
//		none
// 	Scratch:
//		j5
//-------------------------------------------------------//	
.section/charany program;
.global _DMA_UnpauseMultipleChannels;
.align_code 4;
_DMA_UnpauseMultipleChannels:
	j5 = DCNT;;
	j5 = j5 and not j4;;
	cjmp(abs); DCNT = j5; nop; nop;;
_DMA_UnpauseMultipleChannels.end:





//-------------------------------------------------------//
// 	Optimized chain insertion routine
// Parameters:
//	j4 - Channel number, 0 to 13 (bits 3:0),
//		 bit 4 selects whether DCS (0) or DCD (1) will be updated
//  	 in case of channels 0-3 modifying
//	j5 - Address of the first TCB in the chain being inserted
//	j6 - Address of the last TCB in the chain being inserted
//	j7 - Chaining destination channel (for LINK TX 0-3 or RX 0-3)
//		 as defined in <defts201.h>
// Outputs: 
//	j8:	0 <- arguments correct, operation was performed
//		1 <- TY field of the modified channel TCB is equal to 0
//		2 <- arguments are not correct
// Algorithm:
//	1. Check TY field. If TY = 0, chain insertion may not be performed. Exit with error code 1.
//	2. Replace CHTG field of current TCB with input argument value,
//		CHPT field - with address of first TCB in the inserted chain
//		and enable chaining.
//	3. If current DMA channel TCB has chaining enabled, set CHTG and CHPT fileds of the
//		 last TCB in the inserted chain to those from current DMA channel TCB and 
//		 enable chaining. Disable chaining in this TCB otherwise.
//	4. Write back last TCB in the inserted chain and the modified TCB into DMA channel
// Scratch:
//	j3:2,j10,j9:8,k7:0, kstat, jstat
//-------------------------------------------------------//
.section/charany program;
.global _DMA_ChainInsert;
.align_code 4;
_DMA_ChainInsert:
	comp(j4,0x13)(U);						k4 = j4;;			
	if njle, cjmp(abs)(np); 				j8 = 0x02;			k4 = rotl k4;;
	j9 = cjmp;								k4 = rotl k4;;							
	j10 = j5;								k5 = k4 + address(_get_indexed_tcb);;		
	j10 = lshiftr j10;						cjmp = k5;;			
	cjmp_call(abs);							j10 = lshiftr j10;		k7:6 = j1:0;;
	//--------- Check TY field  ---------//
	j31 = j3 and 0xE0000000;				k5 = j6;;
	if jeq, jump _dcio_ret(np);				j8 = 0x01;			j10 = j10 or j7;;		
    //------- Modify current TCB --------//
	j8 = j3 and 0x00380000 | 0x0007FFFF | 0x00400000;			k3:0 = Q[k5+0x00];;		// load last TCB		
	j10 = j10 or 0x00400000;				k5 = j8;;									// enable chaining
	j3 = j3 and not 0x00380000 | 0x0007FFFF | 0x00400000;		j8 = k4;;
	j3 = j3 or j10;							k3 = k3 and not 0x00380000 | 0x0007FFFF | 0x00400000;;
	//--- Modify last TCB in the chain ---//
	j8 = j8 + address(_set_indexed_tcb);		k3 = k3 or k5;;
	// Save modified last chain TCB
	cjmp = j8;								Q[j6+0x00] = k3:0;;
	// Write modified TCB back into the DMA channel and return
	cjmp_call(abs); 						j8 = j8 xor j8; 	nop;;
_dcio_ret:
	cjmp = j9;;	
	cjmp(abs);								j1:0 = k7:6;		nop;		nop;; 
_DMA_ChainInsert.end:	




