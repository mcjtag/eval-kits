
#include "cpu.h"
#include "hal_dma.h"
#include "hal_uart_dma.h"
#include "com_utils.h"

// Possible UART TX DMA channels: 4-7
// Possible UART RX DMA channels: 8-11


#pragma interrupt
static void uart0_rx_dma_isr(void);
#pragma interrupt
static void uart1_rx_dma_isr(void);

#pragma interrupt
static void uart0_tx_dma_isr(void);
#pragma interrupt
static void uart1_tx_dma_isr(void);



udma_rx_context_t udma_rx_context0;
udma_rx_context_t udma_rx_context1;

udma_tx_context_t udma_tx_context0;
udma_tx_context_t udma_tx_context1;

//---------------------------------------------//
//---------------------------------------------//


static uint32_t HAL_UART_DmaGetRxCountReady(udma_rx_context_t *udma_c)
{
	int32_t temp;
	uint32_t count_wr;
	// Disable interrupt for specified channel
	HAL_DMA_SetInterruptMask(udma_c->channel, 0);
	// Get count of chars remaining from DMA TCB
	temp = HAL_DMA_GetDcCountX(udma_c->channel);
	// Convert to "done" count - this is for TCB too
	temp = udma_c->bsize - temp;
	count_wr = udma_c->count_wr + temp;
	temp = count_wr - udma_c->count_rd;
	// Enable interrupt for specified channel
	HAL_DMA_SetInterruptMask(udma_c->channel, 1);	
	return (temp > 0) ? (uint32_t)temp : 0;
}


static uint32_t HAL_UART_DmaReadRxBufferUnsafe(udma_rx_context_t *udma_c)
{
	uint32_t received_char = udma_c->buf[udma_c->tail_index++];
	if (udma_c->tail_index >= udma_c->bsize)
	{
		udma_c->tail_index = 0;
	}
	udma_c->count_rd++;
	return received_char;
}





void HAL_UART_DmaRegisterStreamCallback(LX_Uart_Typedef *uart, stream_parser_callback func)
{
	udma_rx_context_t *udma_c = (uart == LX_UART0) ? &udma_rx_context0 : &udma_rx_context1;
	udma_c->sp_callback = func;
}



int32_t HAL_UART_DmaReadRxStream(LX_Uart_Typedef *uart, uint32_t **dest, uint32_t *count)
{
	uint32_t c;
	int32_t cb_result;
	udma_rx_context_t *udma_c = (uart == LX_UART0) ? &udma_rx_context0 : &udma_rx_context1;
	uint32_t count_ready = HAL_UART_DmaGetRxCountReady(udma_c);
	while(count_ready--)
	{
		c = HAL_UART_DmaReadRxBufferUnsafe(udma_c);
		*(*dest)++ = c;
		(*count)--;
		if (udma_c->sp_callback)
		{
			// Call user function callback for stream protocol analyzing
			cb_result = udma_c->sp_callback(c);
			if (cb_result)	
				return cb_result;
		}
		if (*count == 0)
			return -1;
	}
	return 0;
}


int32_t HAL_UART_DmaReadRxStreamU8(LX_Uart_Typedef *uart, uint8_t **dest, uint32_t *count)
{
	uint32_t c;
	int32_t cb_result;
	udma_rx_context_t *udma_c = (uart == LX_UART0) ? &udma_rx_context0 : &udma_rx_context1;
	uint32_t count_ready = HAL_UART_DmaGetRxCountReady(udma_c);
	while(count_ready--)
	{
		c = HAL_UART_DmaReadRxBufferUnsafe(udma_c);
		*(*dest)++ = (uint8_t)c;
		(*count)--;
		if (udma_c->sp_callback)
		{
			// Call user function callback for stream protocol analyzing
			cb_result = udma_c->sp_callback(c);
			if (cb_result)	
				return cb_result;
		}
		if (*count == 0)
			return -1;
	}
	return 0;
}



void HAL_UART_DmaSetupRxDma(LX_Uart_Typedef *uart, uint32_t dma_ch_number, uint32_t *buffer, uint32_t length)
{
	uint32_t temp32u;
	uint32_t *ptr;
	udma_rx_context_t *udma_c;
	
	udma_c = (uart == LX_UART0) ? &udma_rx_context0 : &udma_rx_context1;
	udma_c->channel = dma_ch_number;
	udma_c->buf = buffer;
	udma_c->bsize = length;
	
	// Disable DMA channel
	HAL_DMA_Stop(udma_c->channel);
	HAL_DMA_ClearInterruptRequest(udma_c->channel);
	
	// Setup buffer pointers, etc
	udma_c->tail_index = 0;
	udma_c->count_rd = 0xFFFFFF00;	// arbitrary, but equal
	udma_c->count_wr = 0xFFFFFF00;
	udma_c->sp_callback = 0;
	
	// Select request source UART RX for DMA channel
	HAL_DMA_SetRxRequestSource(udma_c->channel, ((uart == LX_UART0) ? RxDmaReq_Uart0 : RxDmaReq_Uart1));
	
	// Setup channel TCB
	ptr = (uint32_t *)&udma_c->tcb;
	*(ptr + 0) = (uint32_t)udma_c->buf;
	*(ptr + 1) = (udma_c->bsize << 16) | 1;
	*(ptr + 2) = 0;
	*(ptr + 3) = TCB_INTMEM | TCB_NORMAL | TCB_INT; 
	//DMA_WriteDC(udma_c->channel, &udma_c->tcb);
	
	// Setup DMA interrupt 
	temp32u = (uint32_t)((uart == LX_UART0) ? &uart0_rx_dma_isr : &uart1_rx_dma_isr);
	HAL_DMA_SetInterruptVector(udma_c->channel, temp32u);	
	HAL_DMA_SetInterruptMask(udma_c->channel, 1);
	
	// Note! GIE bit of SQCTL register must be set to enable interrupts.
	// This bit is not affected here.
	
}



void HAL_UART_DmaStartRxDma(LX_Uart_Typedef *uart)
{
	udma_rx_context_t *udma_c = (uart == LX_UART0) ? &udma_rx_context0 : &udma_rx_context1;
	HAL_DMA_Stop(udma_c->channel);
	HAL_DMA_WriteDC(udma_c->channel, &udma_c->tcb);
	
	// Note! GIE bit of SQCTL register must be set to enable interrupts.
	// DMA interrupt mask should also be set. (It is normally set in the HAL_UART_DmaSetupRxDma())	
}


void HAL_UART_DmaStopRxDma(LX_Uart_Typedef *uart)
{
	udma_rx_context_t *udma_c  = (uart == LX_UART0) ? &udma_rx_context0 : &udma_rx_context1;
	HAL_DMA_Stop(udma_c->channel);
}




#pragma interrupt
static void uart0_rx_dma_isr(void)
{	
	// Increment write counter but prevent from running away if received data is not read
	if ((udma_rx_context0.count_wr + udma_rx_context0.bsize) - udma_rx_context0.count_rd < 2*udma_rx_context0.bsize)
		udma_rx_context0.count_wr += udma_rx_context0.bsize;
	// Restart DMA
	HAL_DMA_WriteDC(udma_rx_context0.channel, &udma_rx_context0.tcb);
}


#pragma interrupt
static void uart1_rx_dma_isr(void)
{	
	// Increment write counter but prevent from running away if received data is not read
	if ((udma_rx_context1.count_wr + udma_rx_context1.bsize) - udma_rx_context1.count_rd < 2*udma_rx_context1.bsize)
		udma_rx_context1.count_wr += udma_rx_context1.bsize;
	// Restart DMA
	HAL_DMA_WriteDC(udma_rx_context1.channel, &udma_rx_context1.tcb);
}






//---------------------------------------------//
//---------------------------------------------//


void HAL_UART_DmaSetupTxDma(LX_Uart_Typedef *uart, uint32_t dma_ch_number, uart_tx_dma_callback func, void * pHost )
{
	uint32_t temp32u;
	udma_tx_context_t *udma_c;
	
	udma_c  = (uart == LX_UART0) ? &udma_tx_context0 : &udma_tx_context1;
	udma_c->channel = dma_ch_number;
	udma_c->tx_callback = func;
	udma_c->pHost = pHost;
	
	// Disable DMA channel
	HAL_DMA_Stop(dma_ch_number);
	HAL_DMA_ClearInterruptRequest(dma_ch_number);
	
	// Select request source UART RX for DMA channel
	HAL_DMA_SetTxRequestSource(dma_ch_number, ((uart == LX_UART0) ? TxDmaReq_Uart0 : TxDmaReq_Uart1));
	
	// Setup DMA interrupt 
	temp32u = (uint32_t)((uart == LX_UART0) ? &uart0_tx_dma_isr : &uart1_tx_dma_isr);
	HAL_DMA_SetInterruptVector(udma_c->channel, temp32u);	
	HAL_DMA_SetInterruptMask(udma_c->channel, 1);
	
	// Note! GIE bit of SQCTL register must be set to enable interrupts.
	// This bit is not affected here.
}


int32_t HAL_UART_Dma_StartTxDma(LX_Uart_Typedef *uart, const uint32_t *data, uint32_t count)
{
	uint32_t *ptr;
	udma_tx_context_t *udma_c;
	udma_c  = (uart == LX_UART0) ? &udma_tx_context0 : &udma_tx_context1;
	
	if (HAL_DMA_GetChannelStatus(udma_c->channel) == DSTAT_ACT)
		return -1;
	
	// Setup channel TCB
	ptr = (uint32_t *)&udma_c->tcb;
	*(ptr + 0) = (uint32_t)data;
	*(ptr + 1) = (count << 16) | 1;
	*(ptr + 2) = 0;
	*(ptr + 3) = TCB_INTMEM | TCB_NORMAL | TCB_INT; 
	HAL_DMA_WriteDC(udma_c->channel, &udma_c->tcb);
	
	return 0;
}

/*
int32_t UART_StartTxDmaBuffered(LX_Uart_Typedef *uart, const char *data, uint32_t count)
{
	int32_t err_code;
	udma_tx_context_t *udma_c;
	udma_c  = (uart == LX_UART0) ? &udma_tx_context0 : &udma_tx_context1;
	uint32_t i;
	
	for (i=0; (i<count) && (i<UART_TX_BUFFER_SIZE); i++)
	{
		udma_c->data[i] = (uint32_t)data[i];
	}
	
	err_code = UART_StartTxDma(uart_number, udma_c->data, i);
	if (err_code < 0)
		return err_code;
	else
		return i;
}
*/


#pragma interrupt
static void uart0_tx_dma_isr(void)
{	
	if (udma_tx_context0.tx_callback)
	{
		udma_tx_context0.tx_callback( udma_tx_context0.pHost );	
	}
}


#pragma interrupt
static void uart1_tx_dma_isr(void)
{	
	if (udma_tx_context1.tx_callback)
	{
		udma_tx_context1.tx_callback( udma_tx_context0.pHost );	
	}
}





