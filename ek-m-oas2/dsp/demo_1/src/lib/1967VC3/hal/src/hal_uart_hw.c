
#include "cpu.h"
#include "hal_uart_hw.h"

// Function blocks until a char is received
uint8_t HAL_UART_GetChar(LX_Uart_Typedef *uart)
{
	uint8_t rx_data;
	while(uart->flag.field.rxfe);
	rx_data = (uint8_t)uart->dr;
	return rx_data;
}


uint8_t HAL_UART_RxIsEmpty(LX_Uart_Typedef *uart)
{
	return (uart->flag.field.rxfe);
}


void HAL_UART_SendData(LX_Uart_Typedef *uart, uint8_t *buffer, uint32_t length)
{
	while(length--)
	{
		// Make sure there is free space data in TX FIFO
		while(uart->flag.field.txff);
		uart->dr = *buffer++;
	}	
}


void HAL_UART_SendString(LX_Uart_Typedef *uart, uint8_t *buffer)
{
	while(*buffer != 0)
	{
		// Make sure there is free space data in TX FIFO
		while(uart->flag.field.txff);
		uart->dr = *buffer++;
	}	
}


void HAL_UART_Enable(LX_Uart_Typedef *uart, uint32_t config, uint32_t baudrate, uint32_t xref)
{
	uint32_t temp32u;
	
	// Disable UART interface
	uart->cr.reg = 0;
	
	 // Setup UART configuration
	temp32u = 	(1<<UCR_UARTEN_P) 		| 	// UART enable
			 	(0 << UCR_UHBRE_P)		|	// bit = 1/16 clk
			 	(0 << UCR_PRTEN_P)		|	// no parity
			 	(0 << UCR_EVENPRT_P)	|
			 	(0 << UCR_XSTOP_P)		|	// 1 stop bit
			 	(0 << UCR_UFIFOEN_P)	|	// disable both TX and RX FIFOs
			 	(0 << UCR_WRDLEN_P)		|	// 8 bit words
				0;
	temp32u |= config;
	uart->cr.reg = temp32u;
	
	// Setup UART baudrate
	// UBRATE = XTI_FREQ / (baudrate * k) - 1, k = 16 or 4 depending on UHBRE bit
	baudrate *= (uart->cr.field.uhbre == 0) ? 16 : 4;
	uart->brate.reg = (xref * 1000) / baudrate - 1;
	
	// Setup GPIO for UART
	LX_PortA->alt.set = (uart == LX_UART0) ? ((PF_ALT << 0) | (PF_ALT << 1)) : ((PF_ALT << 2) | (PF_ALT << 3));
}



void HAL_UART_Disable(LX_Uart_Typedef *uart)
{
	// Disable UART interface
	uart->cr.reg = 0;
}



