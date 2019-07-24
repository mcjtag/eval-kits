#ifndef __HAL_DMA_H__
#define __HAL_DMA_H__

#include "def1967VC2.h"
#include "stdint.h"

/*
	DMA channels 4-7 work with transmitter devices - LINK TX, UART TX
	DMA channels 8-11 work with receivers - LINK RX, UART RX
*/



#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus
	void HAL_DMA_WriteDC(int ch_number, void *qw_tcb);
	void HAL_DMA_WriteDCS(int ch_number, void *qw_tcb);
	void HAL_DMA_WriteDCD(int ch_number, void *qw_tcb);
	void HAL_DMA_ReadDC(int ch_number, __builtin_quad *qw_tcb);
	void HAL_DMA_ReadDCS(int ch_number, __builtin_quad *qw_tcb);
	void HAL_DMA_ReadDCD(int ch_number, __builtin_quad *qw_tcb);
	void HAL_DMA_SetInterruptVector(int ch_number, unsigned int isr_address);
	void HAL_DMA_SetInterruptMask(int ch_number, int new_value);
	void HAL_DMA_ClearInterruptRequest(int ch_number);
	
	int HAL_DMA_GetChannelStatus(int channel);
	int HAL_DMA_GetChannelStatusClear(int channel);
	int HAL_DMA_WaitForChannel(int channel);	
	
	unsigned int HAL_DMA_GetDcCountX(int ch_number);
	
	void HAL_DMA_Stop(int ch_number);
	
	// Returns TCB_DMAxDEST field for a channel
	int HAL_DMA_GetTCBChannelDest(int channel);



#ifdef __cplusplus
}
#endif // __cplusplus






#endif
