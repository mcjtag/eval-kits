/**
 * @file link.c
 * @brief LINK port controller
 * @author matyunin.d
 * @date 02.07.2019
 */
 
#include "link.h"
#include "dma.h"

static void tx_handler(void);
static void rx_handler(void);

/**
 * @brief LINK port initialization
 * @param link LINK number (0 to 3)
 * @param tx_cfg Tx configuration
 * @param rx_cfg Rx configuration
 * @return 0 - success, -1 - failure
 */
int link_init(int link, unsigned int tx_cfg, unsigned int rx_cfg)
{
	int tx_dma_chan = 4 + link;
	int rx_dma_chan = 8 + link;
	
	switch (link) {
		case 0:
			__builtin_sysreg_write(__LTCTL0, 0);
			__builtin_sysreg_write(__LTCTL0, tx_cfg);
			__builtin_sysreg_write(__LTCTL0, tx_cfg | 1);
			__builtin_sysreg_write(__LRCTL0, 0);
			__builtin_sysreg_write(__LRCTL0, rx_cfg);
			__builtin_sysreg_write(__LRCTL0, rx_cfg | 1);
			break;
		case 1:
			__builtin_sysreg_write(__LTCTL1, 0);
			__builtin_sysreg_write(__LTCTL1, tx_cfg);
			__builtin_sysreg_write(__LTCTL1, tx_cfg | 1);
			__builtin_sysreg_write(__LRCTL1, 0);
			__builtin_sysreg_write(__LRCTL1, rx_cfg);
			__builtin_sysreg_write(__LRCTL1, rx_cfg | 1);
			break;
		case 2:
			__builtin_sysreg_write(__LTCTL2, 0);
			__builtin_sysreg_write(__LTCTL2, tx_cfg);
			__builtin_sysreg_write(__LTCTL2, tx_cfg | 1);
			__builtin_sysreg_write(__LRCTL2, 0);
			__builtin_sysreg_write(__LRCTL2, rx_cfg);
			__builtin_sysreg_write(__LRCTL2, rx_cfg | 1);
			break;	
		case 3:
			__builtin_sysreg_write(__LTCTL3, 0);
			__builtin_sysreg_write(__LTCTL3, tx_cfg);
			__builtin_sysreg_write(__LTCTL3, tx_cfg | 1);
			__builtin_sysreg_write(__LRCTL3, 0);
			__builtin_sysreg_write(__LRCTL3, rx_cfg);
			__builtin_sysreg_write(__LRCTL3, rx_cfg | 1);
			break;
		default:
			return -1;	
	}
	
	dma_stop(tx_dma_chan);
	dma_clear_status(tx_dma_chan);
	dma_clear_irq(tx_dma_chan);
	dma_set_tx_request(tx_dma_chan);
	dma_set_irq_vector(tx_dma_chan, tx_handler);
	dma_set_irq_mask(tx_dma_chan, 1);
	
	dma_stop(rx_dma_chan);
	dma_clear_status(rx_dma_chan);
	dma_clear_irq(rx_dma_chan);
	dma_set_rx_request(rx_dma_chan);
	dma_set_irq_vector(rx_dma_chan, rx_handler);
	dma_set_irq_mask(rx_dma_chan, 1);
	
	return 0;
}

/**
 * @brief Send data
 * @param link LINK number
 * @param buf Pointer to data buffer
 * @param len Length of tx data (in words)
 * @return 0 - success, -1 - failure
 */
int link_send(int link, unsigned int *buf, unsigned int len)
{
	const unsigned int flag = TCB_INTMEM | TCB_QUAD | TCB_HPRIORITY | TCB_INT;
	int dma_chan = 4 + link;
	__builtin_quad dma_dc;
	
	if (link > 3)
		return -1;
		
	dma_wait(dma_chan);
	
	SET_TCB_DY(dma_dc, 0);
	SET_TCB_DP(dma_dc, flag, 0, 0); 
	SET_TCB_DI(dma_dc, buf);
	SET_TCB_DX(dma_dc, 4, len);
	   
	dma_start(dma_chan, &dma_dc);
	
	return 0;
}

/**
 * @brief Receive data
 * @param link LINK number
 * @param buf Pointer to data buffer
 * @param len Length of data
 * @return -1 - failure, >0 - actual length of received data
 */
int link_recv(int link, unsigned int *buf, unsigned int len)
{
	const unsigned int flag = TCB_INTMEM | TCB_QUAD | TCB_HPRIORITY | TCB_INT;
	int dma_chan = 8 + link;
	__builtin_quad dma_dc;
	
	if (link > 3)
		return -1;
	
	SET_TCB_DY(dma_dc, 0);
	SET_TCB_DP(dma_dc, flag, 0, 0);
	SET_TCB_DI(dma_dc, buf);
	SET_TCB_DX(dma_dc, 4, len);
	
	dma_start(dma_chan, &dma_dc);
	dma_wait(dma_chan);
	
	dma_read_tcb(dma_chan, &dma_dc);
	
	return (len - (GET_TCB_DX(dma_dc) >> 16));
}

/**
 * @brief Tx Done interrupt handler
 * @return void
 */
#pragma interrupt
static void tx_handler(void)
{
	asm("nop;;");
}

/**
 * @brief Rx Done interrupt handler
 * @return void
 */
#pragma interrupt
static void rx_handler(void)
{
	asm("nop;;");
}


