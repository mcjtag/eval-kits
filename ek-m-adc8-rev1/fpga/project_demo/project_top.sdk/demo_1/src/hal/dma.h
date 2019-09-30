/**
 * @file dma.h
 * @brief DMA HAL
 * @author matyunin.d
 * @date 19.07.2019
 */

#ifndef DMA_H_
#define DMA_H_

#include "xaxidma.h"
#include "intc.h"
#include "timer.h"

enum DMA_MODE {
	DMA_MODE_MM2S_NONBLOCK = 1,
	DMA_MODE_S2MM_NONBLOCK = 2
};

struct dma_dev {
	XAxiDma dma;
	u16 dev_id;
	int vec_id_mm2s;
	int vec_id_s2mm;
	u32 mode;
	u16 timeout;
	volatile int mm2s_done;
	volatile int s2mm_done;
	volatile int error;
	struct intc_dev *intc;
	struct timer_dev *tmr;
};

int dma_init(struct dma_dev *dev);
int dma_transmit(struct dma_dev *dev, const u32 *buf, u32 len);
int dma_receive(struct dma_dev *dev, uint32_t *buf, u32 len);
int dma_reset(struct dma_dev *dev);

#endif /* DMA_H_ */
