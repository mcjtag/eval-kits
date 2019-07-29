#ifndef __HAL_UART_DMA_H__
#define __HAL_UART_DMA_H__

#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"




typedef int32_t (*stream_parser_callback)(uint8_t);
typedef void (*uart_tx_dma_callback)(void * pHost);

typedef struct {
	uint32_t *buf;
	uint32_t bsize;
	uint32_t tail_index;
	uint32_t count_rd;		// exact count
	uint32_t count_wr;		// received chars count, incremented in DMA ISR by buffer size
								// exact count may be computed using DMA TCB count registers
	uint32_t channel;
	//int32_t uart_number;
	stream_parser_callback sp_callback;
	__builtin_quad tcb;
} udma_rx_context_t;


typedef struct {
	uint32_t channel;
	uart_tx_dma_callback tx_callback;
	void * pHost;
	__builtin_quad tcb;
} udma_tx_context_t;



extern udma_rx_context_t udma_rx_context0;
extern udma_rx_context_t udma_rx_context1;

extern udma_tx_context_t udma_tx_context0;
extern udma_tx_context_t udma_tx_context1;

#ifdef __cplusplus
extern "C" {
#endif

	void HAL_UART_DmaRegisterStreamCallback(LX_Uart_Typedef *uart, stream_parser_callback func);
	int32_t HAL_UART_DmaReadRxStream(LX_Uart_Typedef *uart, uint32_t **dest, uint32_t *count);
	int32_t HAL_UART_DmaReadRxStreamU8(LX_Uart_Typedef *uart, uint8_t **dest, uint32_t *count);
	void HAL_UART_DmaSetupRxDma(LX_Uart_Typedef *uart, uint32_t dma_ch_number, uint32_t *buffer, uint32_t length);
	void HAL_UART_DmaStartRxDma(LX_Uart_Typedef *uart);
	void HAL_UART_DmaStopRxDma(LX_Uart_Typedef *uart);

	void HAL_UART_DmaSetupTxDma(LX_Uart_Typedef *uart, uint32_t dma_ch_number, uart_tx_dma_callback func, void * pHost );
	int32_t HAL_UART_Dma_StartTxDma(LX_Uart_Typedef *uart, const uint32_t *data, uint32_t count);


#ifdef __cplusplus
}
#endif


#endif	//__HAL_UART_DMA_H__



