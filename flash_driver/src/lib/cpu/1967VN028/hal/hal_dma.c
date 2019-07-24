
#include "cpu.h"
#include "hal_dma.h"
#include "core_utils.h"


// Extracts channel status bits
int HAL_DMA_DecodeStatus(long long dmaStatus, int channel)
{
	 switch(channel)
	{
		case 0:		return 	(int)((dmaStatus >> 0) & 0x07);
		case 1:		return 	(int)((dmaStatus >> 3) & 0x07);
		case 2:		return 	(int)((dmaStatus >> 6) & 0x07);
		case 3:		return 	(int)((dmaStatus >> 9) & 0x07);
		case 4:		return 	(int)((dmaStatus >> 12) & 0x07);
		case 5:		return 	(int)((dmaStatus >> 15) & 0x07);
		case 6:		return 	(int)((dmaStatus >> 18) & 0x07);
		case 7:		return 	(int)((dmaStatus >> 21) & 0x07);
		case 8:		return 	(int)((dmaStatus >> 32) & 0x07);
		case 9:		return 	(int)((dmaStatus >> 35) & 0x07);
		case 10:	return 	(int)((dmaStatus >> 38) & 0x07);
		case 11:	return 	(int)((dmaStatus >> 41) & 0x07);
		case 12:	return 	(int)((dmaStatus >> 50) & 0x07);
		case 13:	return 	(int)((dmaStatus >> 53) & 0x07);
		default:	return 0x05;	// illegal
	}	
}

//-------------------------------------------------------//
// Returns DMA channel status
//-------------------------------------------------------//
int HAL_DMA_GetChannelStatus(int channel)
{	
	long long int dmaStatus = __builtin_sysreg_read2(__DSTAT);
	return HAL_DMA_DecodeStatus(dmaStatus, channel);
}

//-------------------------------------------------------//
// Returns DMA channel status and clears dma errors
// by reading DSTATC register
//-------------------------------------------------------//
int HAL_DMA_GetChannelStatusClear(int channel)
{	
	long long int dmaStatus = __builtin_sysreg_read2(__DSTATC);
	return HAL_DMA_DecodeStatus(dmaStatus, channel);
}


//-------------------------------------------------------//
// Waits for DMA channel to complete
// Returns:
//	 0 if channel is done successfully,
//	 1 if there was an error
//	 2 if channel is disabled
//-------------------------------------------------------//
int HAL_DMA_WaitForChannel(int channel)
{
	int status;
	do
		status = HAL_DMA_GetChannelStatus(channel);
	while(status == DSTAT_ACT);
	
	switch(status)
	{
		case DSTAT_IDLE: 
			return 2;
		case DSTAT_DONE:
			return 0;
		default: 
			return 1;
	}
}


// Writes to DMA channel configuration registers.
// Use this function for channels with single DC (channels 4-13)
void HAL_DMA_WriteDC(int ch_number, void *qw_tcb)
{
	switch (ch_number)
	{
		case 4:	__builtin_sysreg_write4 (__DC4, *(__builtin_quad *)qw_tcb);	break;
		case 5:	__builtin_sysreg_write4 (__DC5, *(__builtin_quad *)qw_tcb);	break;
		case 6:	__builtin_sysreg_write4 (__DC6, *(__builtin_quad *)qw_tcb);	break;
		case 7:	__builtin_sysreg_write4 (__DC7, *(__builtin_quad *)qw_tcb);	break;
		case 8:	__builtin_sysreg_write4 (__DC8, *(__builtin_quad *)qw_tcb);	break;
		case 9:	__builtin_sysreg_write4 (__DC9, *(__builtin_quad *)qw_tcb);	break;
		case 10:	__builtin_sysreg_write4 (__DC10, *(__builtin_quad *)qw_tcb);	break;
		case 11:	__builtin_sysreg_write4 (__DC11, *(__builtin_quad *)qw_tcb);	break;
		case 12:	__builtin_sysreg_write4 (__DC12, *(__builtin_quad *)qw_tcb);	break;
		case 13:	__builtin_sysreg_write4 (__DC13, *(__builtin_quad *)qw_tcb);	break;
	}
}

// Writes to DMA channel SOURCE configuration registers.
// Use this function for channels 0-3
void HAL_DMA_WriteDCS(int ch_number, void *qw_tcb)
{
	switch (ch_number)
	{
		case 0:	__builtin_sysreg_write4 (__DCS0, *(__builtin_quad *)qw_tcb);	break;
		case 1:	__builtin_sysreg_write4 (__DCS1, *(__builtin_quad *)qw_tcb);	break;
		case 2:	__builtin_sysreg_write4 (__DCS2, *(__builtin_quad *)qw_tcb);	break;
		case 3:	__builtin_sysreg_write4 (__DCS3, *(__builtin_quad *)qw_tcb);	break;
	}
}

// Writes to DMA channel DESTINATION configuration registers.
// Use this function for channels 0-3
void HAL_DMA_WriteDCD(int ch_number, void *qw_tcb)
{
	switch (ch_number)
	{
		case 0:	__builtin_sysreg_write4 (__DCD0, *(__builtin_quad *)qw_tcb);	break;
		case 1:	__builtin_sysreg_write4 (__DCD1, *(__builtin_quad *)qw_tcb);	break;
		case 2:	__builtin_sysreg_write4 (__DCD2, *(__builtin_quad *)qw_tcb);	break;
		case 3:	__builtin_sysreg_write4 (__DCD3, *(__builtin_quad *)qw_tcb);	break;
	}
}


// Reads DMA channel configuration registers.
// Use this function for channels with single DC (channels 4-13)
void HAL_DMA_ReadDC(int ch_number, __builtin_quad *qw_tcb)
{
	switch (ch_number)
	{
		case 4:	*qw_tcb = __builtin_sysreg_read4 (__DC4);	break;
		case 5:	*qw_tcb = __builtin_sysreg_read4 (__DC5);	break;
		case 6:	*qw_tcb = __builtin_sysreg_read4 (__DC6);	break;
		case 7:	*qw_tcb = __builtin_sysreg_read4 (__DC7);	break;
		case 8:	*qw_tcb = __builtin_sysreg_read4 (__DC8);	break;
		case 9:	*qw_tcb = __builtin_sysreg_read4 (__DC9);	break;
		case 10:	*qw_tcb = __builtin_sysreg_read4 (__DC10);	break;
		case 11:	*qw_tcb = __builtin_sysreg_read4 (__DC11);	break;
		case 12:	*qw_tcb = __builtin_sysreg_read4 (__DC12);	break;
		case 13:	*qw_tcb = __builtin_sysreg_read4 (__DC13);	break;
	}
}

// Reads DMA channel SOURCE configuration registers.
// Use this function for channels 0-3
void HAL_DMA_ReadDCS(int ch_number, __builtin_quad *qw_tcb)
{
	switch (ch_number)
	{
		case 0:	*qw_tcb = __builtin_sysreg_read4 (__DCS0);	break;
		case 1:	*qw_tcb = __builtin_sysreg_read4 (__DCS1);	break;
		case 2:	*qw_tcb = __builtin_sysreg_read4 (__DCS2);	break;
		case 3:	*qw_tcb = __builtin_sysreg_read4 (__DCS3);	break;
	}
}

// Reads DMA channel DESTINATION configuration registers.
// Use this function for channels 0-3
void HAL_DMA_ReadDCD(int ch_number, __builtin_quad *qw_tcb)
{
	switch (ch_number)
	{
		case 0:	*qw_tcb = __builtin_sysreg_read4 (__DCD0);	break;
		case 1:	*qw_tcb = __builtin_sysreg_read4 (__DCD1);	break;
		case 2:	*qw_tcb = __builtin_sysreg_read4 (__DCD2);	break;
		case 3:	*qw_tcb = __builtin_sysreg_read4 (__DCD3);	break;
	}
}





// Sets interrupt vector for specified DMA channel
void HAL_DMA_SetInterruptVector(int ch_number, unsigned int isr_address)
{
	switch (ch_number)
	{
		case 0:
			__builtin_sysreg_write(__IVDMA0, isr_address);	break;
		case 1: 
			__builtin_sysreg_write(__IVDMA1, isr_address);	break;
		case 2: 
			__builtin_sysreg_write(__IVDMA2, isr_address);	break;
		case 3: 
			__builtin_sysreg_write(__IVDMA3, isr_address);	break;
		case 4:
			__builtin_sysreg_write(__IVDMA4, isr_address);	break;
		case 5:
			__builtin_sysreg_write(__IVDMA5, isr_address);	break;
		case 6:
			__builtin_sysreg_write(__IVDMA6, isr_address);	break;
		case 7:
			__builtin_sysreg_write(__IVDMA7, isr_address);	break;
		case 8:
			__builtin_sysreg_write(__IVDMA8, isr_address);	break;
		case 9:
			__builtin_sysreg_write(__IVDMA9, isr_address);	break;
		case 10:
			__builtin_sysreg_write(__IVDMA10, isr_address);	break;
		case 11:
			__builtin_sysreg_write(__IVDMA11, isr_address);	break;
		case 12:
			__builtin_sysreg_write(__IVDMA12, isr_address);	break;
		case 13:		
			__builtin_sysreg_write(__IVDMA13, isr_address);	break;
	}
}


// Sets interrupt mask for specified DMA channel
//	input:
//		new_value = 1	-> interrupt is enabled
//		new_value = 0	-> interrupt is disabled
void HAL_DMA_SetInterruptMask(int ch_number, int new_value)
{
	unsigned int bit_to_affect;
	switch (ch_number)
	{
		case 0:
			bit_to_affect = 14;	break;
		case 1: 
			bit_to_affect = 15;	break;
		case 2: 
			bit_to_affect = 16;	break;
		case 3: 
			bit_to_affect = 17;	break;
		case 4:
			bit_to_affect = 22;	break;
		case 5:
			bit_to_affect = 23;	break;
		case 6:
			bit_to_affect = 24;	break;
		case 7:
			bit_to_affect = 25;	break;
		case 8:
			bit_to_affect = 29;	break;
		case 9:
			bit_to_affect = 30;	break;
		case 10:
			bit_to_affect = 31;	break;
		case 11:
			bit_to_affect = 0;	break;
		case 12:
			bit_to_affect = 5;	break;
		case 13:		
			bit_to_affect = 6;	break;
		default:
			return;
	}
	
	bit_to_affect = (1<<bit_to_affect);
	
	if (ch_number < 11)
	{
		if (new_value)
			__set_imaskl(bit_to_affect);
		else
			__clear_imaskl(~bit_to_affect);
	}
	else
	{
		if (new_value)
			__set_imaskh(bit_to_affect);
		else
			__clear_imaskh(~bit_to_affect);
	}
}


void HAL_DMA_ClearInterruptRequest(int ch_number)
{
	unsigned int bit_to_affect;
	switch (ch_number)
	{
		case 0:
			bit_to_affect = 14;	break;
		case 1: 
			bit_to_affect = 15;	break;
		case 2: 
			bit_to_affect = 16;	break;
		case 3: 
			bit_to_affect = 17;	break;
		case 4:
			bit_to_affect = 22;	break;
		case 5:
			bit_to_affect = 23;	break;
		case 6:
			bit_to_affect = 24;	break;
		case 7:
			bit_to_affect = 25;	break;
		case 8:
			bit_to_affect = 29;	break;
		case 9:
			bit_to_affect = 30;	break;
		case 10:
			bit_to_affect = 31;	break;
		case 11:
			bit_to_affect = 0;	break;
		case 12:
			bit_to_affect = 5;	break;
		case 13:		
			bit_to_affect = 6;	break;
		default:
			return;
	}
	
	bit_to_affect = (1<<bit_to_affect);
	
	if (ch_number < 11)
	{
		__builtin_sysreg_write(__ILATCLL, ~bit_to_affect);
	}
	else
	{
		__builtin_sysreg_write(__ILATCLH, ~bit_to_affect);
	}
}



unsigned int HAL_DMA_GetDcCountX(int ch_number)
{
	__builtin_quad temp_tcb;
	unsigned int *ptr = (unsigned int*)&temp_tcb;
	unsigned int temp;
	switch (ch_number)
	{
		case 4:	temp_tcb = __builtin_sysreg_read4 (__DC4);	break;
		case 5:	temp_tcb = __builtin_sysreg_read4 (__DC5);	break;
		case 6:	temp_tcb = __builtin_sysreg_read4 (__DC6);	break;
		case 7:	temp_tcb = __builtin_sysreg_read4 (__DC7);	break;
		case 8:	temp_tcb = __builtin_sysreg_read4 (__DC8);	break;
		case 9:	temp_tcb = __builtin_sysreg_read4 (__DC9);	break;
		case 10:	temp_tcb = __builtin_sysreg_read4 (__DC10);	break;
		case 11:	temp_tcb = __builtin_sysreg_read4 (__DC11);	break;
		case 12:	temp_tcb = __builtin_sysreg_read4 (__DC12);	break;
		case 13:	temp_tcb = __builtin_sysreg_read4 (__DC13);	break;
	}
	
	temp = *(ptr+1);
	return (temp >> 16);
}



void HAL_DMA_Stop(int ch_number)
{
	__builtin_quad zero_tcb = __builtin_compose_128(0,0);
	if (ch_number > 3)
	{
		HAL_DMA_WriteDC(ch_number, &zero_tcb);
	}
	else
	{
		HAL_DMA_WriteDCS(ch_number, &zero_tcb);
		HAL_DMA_WriteDCD(ch_number, &zero_tcb);
	}
		
}


// Returns TCB_DMAxDEST field for a channel
int HAL_DMA_GetTCBChannelDest(int channel)
{
	 switch(channel)
	{
		case 4:		return 	TCB_DMA4DEST;
		case 5:		return 	TCB_DMA5DEST;
		case 6:		return 	TCB_DMA6DEST;
		case 7:		return 	TCB_DMA7DEST;
		case 8:		return 	TCB_DMA8DEST;
		case 9:		return 	TCB_DMA9DEST;
		case 10:	return 	TCB_DMA10DEST;
		case 11:	return 	TCB_DMA11DEST;
		default:	return 	0;
	}	
}

/*
int HAL_DMA_CopyMemory(void *src, void *dst, int count, int ch_number, int enable_interrupt)
{
	__builtin_quad tcb_src, tcb_dest;
	int *ptr;
	
	HAL_DMA_Stop(ch_number);
	
	ptr = (int *)&tcb_src;
	*(ptr + 0) = (int)src;
	*(ptr + 1) = count << 16 | 0x01;
	*(ptr + 2) = 0;
	*(ptr + 2) = 0;
	
	
}
*/




