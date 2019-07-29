#ifndef __HAL_UART_HW_H__
#define __HAL_UART_HW_H__

#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"


#define UART_PARITY_NONE	0
#define UART_PARITY_ODD		(1 << UCR_PRTEN_P)
#define UART_PARITY_EVEN	((1 << UCR_PRTEN_P) | (1 << UCR_EVENPRT_P))

#define UART_ONE_STOP_BIT	0
#define UART_TWO_STOP_BIT	(1 << UCR_XSTOP_P)

#define UART_BIT_LENGTH_16X			0
#define UART_BIT_LENGTH_4X			(1 << UCR_UHBRE_P)
#define UART_BIT_LENGTH_4X_DIRECT	(2 << UCR_UHBRE_P)

#define UART_DATA_LENGTH_8BIT		0
#define UART_DATA_LENGTH_7BIT		(1 << UCR_WRDLEN_P)
#define UART_DATA_LENGTH_6BIT		(2 << UCR_WRDLEN_P)
#define UART_DATA_LENGTH_5BIT		(3 << UCR_WRDLEN_P)

#define UART_NO_RX_TX_FIFO			0
#define UART_USE_RX_TX_FIFO			(1 << UCR_UFIFOEN_P)

enum {UART0, UART1};

#ifdef __cplusplus
extern "C" {
#endif

	uint8_t HAL_UART_GetChar(LX_Uart_Typedef *uart);
	uint8_t HAL_UART_RxIsEmpty(LX_Uart_Typedef *uart);
	void HAL_UART_SendData(LX_Uart_Typedef *uart, uint8_t *buffer, uint32_t length);
	void HAL_UART_SendString(LX_Uart_Typedef *uart, uint8_t *buffer);
	void HAL_UART_Enable(LX_Uart_Typedef *uart, uint32_t config, uint32_t baudrate, uint32_t xref);
	void HAL_UART_Disable(LX_Uart_Typedef *uart);

#ifdef __cplusplus
}
#endif


#endif	//__HAL_UART_HW_H__
