/**
 * @file config.h
 * @brief
 * @author matyunin.d
 * @date 25.07.2017
 */

#ifndef CONFIG_H_
#define CONFIG_H_

#include "system/cpu_defs.h"

// Assert
#define CONFIG_ASSERT_USE	1

// PLL
#define CONFIG_PLL_XTI_FREQ_KHZ		48000	// External frequency
#define CONFIG_PLL_CORE_FREQ_KHZ	180000	// Core clock frequency
#define	CONFIG_PLL_BUS_FREQ_KHZ		80000	// External bus frequency
#define CONFIG_PLL_LINK_FREQ_KHZ	400000	// LINK bus clock frequency (250MHz)

// UART
#define CONFIG_UART_DEV			LX_UART0
#define CONFIG_UART_BAUD		115200
#define CONFIG_UART_PARITY		UART_PARITY_NONE
#define CONFIG_UART_STOPS		UART_TWO_STOP_BIT
#define CONFIG_UART_BITS		UART_DATA_LENGTH_8BIT
#define CONFIG_UART_RXBUF		8192
#define CONFIG_UART_TXBUF		8192

// Enumerator
#define CONFIG_ENUM_DEV			LX_PortB

// Timer
#define CONFIG_TIMER_DEV		1
#define CONFIG_TIMER_FREQ_HZ	2000

// LINK
#define CONFIG_LINK_DEV			0
#define CONFIG_LINK_DMA			4
#define CONFIG_LINK_PORT		LX_PortC
#define CONFIG_LINK_PIN_ACKI	25
#define CONFIG_LINK_PIN_BCMPO	26
#define CONFIG_LINK_PATTERN		1024
#define CONFIG_LINK_LENGTH		2048

// DMAR
#define CONFIG_DMAR_PORT		LX_PortB
#define CONFIG_DMAR_PIN_CHAN0	4
#define CONFIG_DMAR_PIN_CHAN1	5

// ADC
#define CONFIG_ADC_CHAN			2
#define CONFIG_ADC_BUFLEN		32768
#define CONFIG_ADC_SAMPLES		784
#define CONFIG_ADC_FS			125000000.0
#define CONFIG_ADC_FH			25000000.0
#define CONFIG_ADC_DF			26
#define CONFIG_ADC_OFFSET		8

#endif /* CONFIG_H_ */
