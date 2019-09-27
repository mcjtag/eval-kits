/**
 * @file dma.h
 * @brief DMA controller
 * @author matyunin.d
 * @date 02.07.2019
 */
 
#ifndef DMA_H
#define DMA_H

#include <stdint.h>
#include <defts201.h>
#include <sysreg.h>

#define SET_TCB_DI(tcb, val)					*((uint32_t *)&tcb + 0) = (uint32_t)val
#define SET_TCB_DX(tcb, mod, count)				*((uint32_t *)&tcb + 1) = (count << 16) | mod
#define SET_TCB_DY(tcb, val)					*((uint32_t *)&tcb + 2) = val
#define SET_TCB_DP(tcb, flag, dest, c_tcb)		*((uint32_t *)&tcb + 3) = flag | dest | (c_tcb >> 2)

#define GET_TCB_DI(tcb)							*((uint32_t *)&tcb + 0)
#define GET_TCB_DX(tcb)							*((uint32_t *)&tcb + 1)
#define GET_TCB_DY(tcb)							*((uint32_t *)&tcb + 2)
#define GET_TCB_DP(tcb)							*((uint32_t *)&tcb + 3)


void dma_stop(int chan);
void dma_start(int chan, __builtin_quad *tcb);
int dma_get_status(int chan);
int dma_clear_status(int chan);
int dma_wait(int chan);
void dma_clear_irq(int chan);
void dma_set_irq_vector(int chan, void *irq_handler);
void dma_set_irq_mask(int chan, int mask);
int dma_set_tx_request(int chan);
int dma_set_rx_request(int chan);
void dma_read_tcb(int chan, __builtin_quad *tcb);

#endif
