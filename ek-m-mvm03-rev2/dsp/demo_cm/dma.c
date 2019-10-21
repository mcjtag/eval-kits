/**
 * @file dma.c
 * @brief DMA controller
 * @author matyunin.d
 * @date 02.07.2019
 */
 
#include "dma.h"

#define base_DMACFGL  0x80000078
#define base_DMACFGH  0x80000079

/**
 * @brief Stop DMA transaction
 * @param chan DMA channel
 * @return void
 */
void dma_stop(int chan)
{
	__builtin_quad zero_tcb = __builtin_compose_128(0,0);
	if (chan > 3) {
		dma_start(chan, &zero_tcb);
	}	
}

/**
 * @brief Start DMA transaction
 * @param chan DMA channel
 * @param tcb Pointer to TCB
 * @return void
 */
void dma_start(int chan, __builtin_quad *tcb)
{
	switch (chan) {
		case 4:
			__builtin_sysreg_write4(__DC4, *tcb);
			break;
		case 5:
			__builtin_sysreg_write4(__DC5, *tcb);
			break;
		case 6:
			__builtin_sysreg_write4(__DC6, *tcb);
			break;
			case 7:
			__builtin_sysreg_write4(__DC7, *tcb);
			break;
		case 8:
			__builtin_sysreg_write4(__DC8, *tcb);
			break;
		case 9:
			__builtin_sysreg_write4(__DC9, *tcb);
			break;
		case 10:
			__builtin_sysreg_write4(__DC10, *tcb);
			break;
		case 11:
			__builtin_sysreg_write4(__DC11, *tcb);
			break;
		case 12:
			__builtin_sysreg_write4(__DC12, *tcb);
			break;
		case 13:
			__builtin_sysreg_write4(__DC13, *tcb);
			break;
	}
}

/**
 * @brief Get DMA status
 * @param chan DMA channel
 * @return status
 */
int dma_get_status(int chan)
{
	long long int status = __builtin_sysreg_read2(__DSTAT);
	
	switch(chan) {
		case 0:
			return 	(int)((status >> 0) & 0x07);
		case 1:
			return 	(int)((status >> 3) & 0x07);
		case 2:
			return 	(int)((status >> 6) & 0x07);
		case 3:
			return 	(int)((status >> 9) & 0x07);
		case 4:
			return 	(int)((status >> 12) & 0x07);
		case 5:
			return 	(int)((status >> 15) & 0x07);
		case 6:
			return 	(int)((status >> 18) & 0x07);
		case 7:
			return 	(int)((status >> 21) & 0x07);
		case 8:
			return 	(int)((status >> 32) & 0x07);
		case 9:
			return 	(int)((status >> 35) & 0x07);
		case 10:
			return 	(int)((status >> 38) & 0x07);
		case 11:
			return 	(int)((status >> 41) & 0x07);
		case 12:
			return 	(int)((status >> 50) & 0x07);
		case 13:
			return 	(int)((status >> 53) & 0x07);
		default:
			return 0x05;	// illegal
	}	 
}

/**
 * @brief Clear DMA status
 * @param chan DMA channel
 * @return status
 */
int dma_clear_status(int chan)
{	
	int status = dma_get_status(chan);
	__builtin_sysreg_read2(__DSTATC);
	return status;
}

/**
 * @brief Clear interrupt
 * @param chan DMA channel
 * @return void
 */
void dma_clear_irq(int chan)
{
	unsigned int bit_to_affect;
	switch (chan)
	{
		case 0:
			bit_to_affect = 14;
			break;
		case 1: 
			bit_to_affect = 15;
			break;
		case 2: 
			bit_to_affect = 16;
			break;
		case 3: 
			bit_to_affect = 17;
			break;
		case 4:
			bit_to_affect = 22;
			break;
		case 5:
			bit_to_affect = 23;
			break;
		case 6:
			bit_to_affect = 24;
			break;
		case 7:
			bit_to_affect = 25;
			break;
		case 8:
			bit_to_affect = 29;
			break;
		case 9:
			bit_to_affect = 30;
			break;
		case 10:
			bit_to_affect = 31;
			break;
		case 11:
			bit_to_affect = 0;
			break;
		case 12:
			bit_to_affect = 5;
			break;
		case 13:		
			bit_to_affect = 6;
			break;
		default:
			return;
	}
	
	bit_to_affect = (1 << bit_to_affect);
	
	if (chan < 11)
		__builtin_sysreg_write(__ILATCLL, ~bit_to_affect);
	else
		__builtin_sysreg_write(__ILATCLH, ~bit_to_affect);
}

/**
 * @brief Wait DMA transaction
 * @param chan DMA channel
 * @return status
 */
int dma_wait(int chan)
{
	int status;

	while ((status = dma_get_status(chan)) == DSTAT_ACT);
	
	switch (status) {
		case DSTAT_IDLE: 
			return 2;
		case DSTAT_DONE:
			return 0;
		default: 
			return 1;
	}
}     

/**
 * @brief Set DMA interrupt handler
 * @param chan DMA channel
 * @param irq_handler Pointer to interrupt handler
 * @return void
 */
void dma_set_irq_vector(int chan, void *irq_handler)
{
	unsigned int irq_addr = (unsigned int)irq_handler;
	
	switch (chan) {
		case 0:
			__builtin_sysreg_write(__IVDMA0, irq_addr);
			break;
		case 1: 
			__builtin_sysreg_write(__IVDMA1, irq_addr);
			break;
		case 2: 
			__builtin_sysreg_write(__IVDMA2, irq_addr);
			break;
		case 3: 
			__builtin_sysreg_write(__IVDMA3, irq_addr);
			break;
		case 4:
			__builtin_sysreg_write(__IVDMA4, irq_addr);
			break;
		case 5:
			__builtin_sysreg_write(__IVDMA5, irq_addr);
			break;
		case 6:
			__builtin_sysreg_write(__IVDMA6, irq_addr);
			break;
		case 7:
			__builtin_sysreg_write(__IVDMA7, irq_addr);
			break;
		case 8:
			__builtin_sysreg_write(__IVDMA8, irq_addr);
			break;
		case 9:
			__builtin_sysreg_write(__IVDMA9, irq_addr);
			break;
		case 10:
			__builtin_sysreg_write(__IVDMA10, irq_addr);
			break;
		case 11:
			__builtin_sysreg_write(__IVDMA11, irq_addr);
			break;
		case 12:
			__builtin_sysreg_write(__IVDMA12, irq_addr);
			break;
		case 13:		
			__builtin_sysreg_write(__IVDMA13, irq_addr);
			break;
	}
}

/**
 * @brief Set DMA interrupt mask
 * @param chan DMA channel
 * @param mask Interrupt mask
 * @return void
 */
void dma_set_irq_mask(int chan, int mask)
{
	unsigned int bit_to_affect;
	unsigned int imask;

	switch (chan) {
		case 0:
			bit_to_affect = 14;
			break;
		case 1: 
			bit_to_affect = 15;
			break;
		case 2: 
			bit_to_affect = 16;
			break;
		case 3: 
			bit_to_affect = 17;
			break;
		case 4:
			bit_to_affect = 22;
			break;
		case 5:
			bit_to_affect = 23;
			break;
		case 6:
			bit_to_affect = 24;
			break;
		case 7:
			bit_to_affect = 25;
			break;
		case 8:
			bit_to_affect = 29;
			break;
		case 9:
			bit_to_affect = 30;
			break;
		case 10:
			bit_to_affect = 31;
			break;
		case 11:
			bit_to_affect = 0;
			break;
		case 12:
			bit_to_affect = 5;
			break;
		case 13:		
			bit_to_affect = 6;
			break;
		default:
			return;
	}
	
	bit_to_affect = (1 << bit_to_affect);
	
	if (chan < 11) {
		if (mask) {
			imask = __builtin_sysreg_read(__IMASKL);
			imask |= bit_to_affect;
			__builtin_sysreg_write(__IMASKL, imask);
		} else {
			imask = __builtin_sysreg_read(__IMASKL);
			imask &= ~bit_to_affect;
			__builtin_sysreg_write(__IMASKL, imask);
		}
	} else {
		if (mask) {
			imask = __builtin_sysreg_read(__IMASKH);
			imask |= bit_to_affect;
			__builtin_sysreg_write(__IMASKH, imask);
		} else {
			imask = __builtin_sysreg_read(__IMASKH);
			imask &= ~bit_to_affect;
			__builtin_sysreg_write(__IMASKH, imask);
		}
	}
}

/**
 * @brief Set DMA Tx request
 * @param chan DMA channel
 * @return void
 */
int dma_set_tx_request(int chan)
{
	unsigned int *cfg_reg = (unsigned int *)base_DMACFGL;
	unsigned int tmp;
	
	if (chan > 7)
		return -1;
	
	chan *= 4;
	tmp = *cfg_reg; 
	tmp &= (~(0xF << chan));
	*cfg_reg = tmp;
	
	return 0;
}

/**
 * @brief Set DMA Rx request
 * @param chan DMA channel
 * @return void
 */
int dma_set_rx_request(int chan)
{
	unsigned int *cfg_reg = (unsigned int *)base_DMACFGH;
	unsigned int tmp;
	
	if ((chan < 8) || (chan > 13)) 
		return -1;
	
	chan = chan - 8;
	chan *= 4;
	
	tmp = *cfg_reg; 
	tmp &= (~(0xF << chan));
	*cfg_reg = tmp;
	
	return 0;
}

/**
 * @brief Read DMA TCB
 * @param chan DMA channel
 * @param tcb Pointer to TCB
 * @return void
 */
void dma_read_tcb(int chan, __builtin_quad *tcb)
{
	switch (chan) {
		case 4:
			*tcb = __builtin_sysreg_read4(__DC4);
			break;
		case 5:	
			*tcb = __builtin_sysreg_read4(__DC5);
			break;
		case 6:	
			*tcb = __builtin_sysreg_read4(__DC6);
			break;
		case 7:	
			*tcb = __builtin_sysreg_read4(__DC7);
			break;
		case 8:	
			*tcb = __builtin_sysreg_read4(__DC8);
			break;
		case 9:	
			*tcb = __builtin_sysreg_read4(__DC9);
			break;
		case 10:
			*tcb = __builtin_sysreg_read4(__DC10);
			break;
		case 11:
			*tcb = __builtin_sysreg_read4(__DC11);
			break;
		case 12:
			*tcb = __builtin_sysreg_read4(__DC12);
			break;
		case 13:
			*tcb = __builtin_sysreg_read4(__DC13);
			break;
	}
}       
