#ifndef __HAL_DMA_H__
#define __HAL_DMA_H__

#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"

/*
	DMA channels 4-7 work with transmitter devices - LINK TX, UART TX
	DMA channels 8-11 work with receivers - LINK RX, UART RX
*/

// DMA request sources for channels 4-7
#define DMAREQL_DEFAULT		0
#define DMAREQL_UART0_TX	1
#define DMAREQL_UART1_TX	2
#define DMAREQL_SPI_TX		3
#define DMAREQL_LCD			4
#define DMAREQL_SSI0_TX		5
#define DMAREQL_SSI1_TX		6
#define DMAREQL_NANDF_WR	7
#define DMAREQH_ADA1_TX		8
#define DMAREQH_ADA0_TX		9
#define DMAREQH_ADA2_TX		10
#define DMAREQH_ADA3_TX		11


// DMA request sources for channels 8-11
#define DMAREQH_DEFAULT		0
#define DMAREQH_UART0_RX	1
#define DMAREQH_UART1_RX	2
#define DMAREQH_SPI_RX		3
#define DMAREQH_VCAM		4
#define DMAREQH_SSI0_RX		5
#define DMAREQH_SSI1_RX		6
#define DMAREQH_NANDF_RD	7
#define DMAREQH_ADA1_RX		8
#define DMAREQH_ADA0_RX		9
#define DMAREQH_ADA2_RX		10
#define DMAREQH_ADA3_RX		11


typedef enum _TxDmaRequest {
	TxDmaReq_Default = 0,
	TxDmaReq_Uart0,
	TxDmaReq_Uart1,
	TxDmaReq_Spi,
	TxDmaReq_Lcd,
	TxDmaReq_Ssi0,
	TxDmaReq_Ssi1,
	TxDmaReq_Nand,
	TxDmaReq_Ada1,	// intentionnaly swapped
	TxDmaReq_Ada0,
	TxDmaReq_Ada2,
	TxDmaReq_Ada3
} TxDmaRequest;

typedef enum _RxDmaRequest {
	RxDmaReq_Default = 0,
	RxDmaReq_Uart0,
	RxDmaReq_Uart1,
	RxDmaReq_Spi,
	RxDmaReq_Vcam,
	RxDmaReq_Ssi0,
	RxDmaReq_Ssi1,
	RxDmaReq_NandWr,
	RxDmaReq_Ada1,
	RxDmaReq_Ada0,
	RxDmaReq_Ada2,
	RxDmaReq_Ada3
} RxDmaRequest;	




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
	int HAL_DMA_SetRxRequestSource(int ch_number, RxDmaRequest new_source);
	int HAL_DMA_SetTxRequestSource(int ch_number, TxDmaRequest new_source);

	int HAL_DMA_GetChannelStatus(int channel);
	int HAL_DMA_GetChannelStatusClear(int channel);
	int HAL_DMA_WaitForChannel(int channel);	
	
	unsigned int HAL_DMA_GetDcCountX(int ch_number);
	
	void HAL_DMA_Stop(int ch_number);
	
	// Returns TCB_DMAxDEST field for a channel
	int HAL_DMA_GetTCBChannelDest(int channel);

/*	
namespace	HAL
{
namespace	DMA
{
inline	void WriteDC(int ch_number, void *qw_tcb)
{HAl_DMA_WriteDC(ch_number, qw_tcb);}
}
}
*/


#ifdef __cplusplus
}
#endif // __cplusplus






#endif	//__HAL_DMA_H__
