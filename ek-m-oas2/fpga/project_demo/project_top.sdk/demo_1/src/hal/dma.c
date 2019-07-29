/**
 * @file dma.c
 * @brief DMA HAL
 * @author matyunin.d
 * @date 19.07.2019
 */

#include "dma.h"

#define RESET_TIMEOUT	10000

static void mm2s_irq_handler(struct dma_dev *dev);
static void s2mm_irq_handler(struct dma_dev *dev);

/**
 * @brief DMA initialization
 * @param dev Pointer to device structure
 * @return XST_SUCCESS | XST_FAILURE
 */
int dma_init(struct dma_dev *dev)
{
	int status;
	XAxiDma_Config *config_ptr = NULL;

	if (!dev)
		return XST_FAILURE;

	config_ptr = XAxiDma_LookupConfig(dev->dev_id);
	if (!config_ptr)
		return XST_FAILURE;
	status = XAxiDma_CfgInitialize(&dev->dma, config_ptr);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	XAxiDma_Reset(&dev->dma);
	while (!XAxiDma_ResetIsDone(&dev->dma));

	status = XAxiDma_Selftest(&dev->dma);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	if (dev->intc) {

		if (dev->vec_id_mm2s != -1) {
			status = XIntc_Connect(&dev->intc->intc, dev->vec_id_mm2s, (XInterruptHandler)mm2s_irq_handler, dev);
			if (status != XST_SUCCESS)
				return XST_FAILURE;
			XAxiDma_IntrEnable(&dev->dma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
			XIntc_Enable(&dev->intc->intc, dev->vec_id_mm2s);
		}

		if (dev->vec_id_s2mm != -1) {
			status = XIntc_Connect(&dev->intc->intc, dev->vec_id_s2mm, (XInterruptHandler)s2mm_irq_handler, dev);
			if (status != XST_SUCCESS)
				return XST_FAILURE;
			XAxiDma_IntrEnable(&dev->dma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
			XIntc_Enable(&dev->intc->intc, dev->vec_id_s2mm);
		}

	}

	return XST_SUCCESS;
}

/**
 * @brief Start DMA transmit transaction
 * @param dev Pointer to device structure
 * @param buf Pointer to data array to transmit
 * @param len Length of array in bytes
 * @return XST_SUCCESS | XST_FAILURE
 */
int dma_transmit(struct dma_dev *dev, const u32 *buf, u16 len)
{
	int status;
	u16 timeout;

	if (!dev)
		return XST_FAILURE;
	if (!len)
		return XST_SUCCESS;
	if (dev->vec_id_mm2s == -1)
		return XST_FAILURE;

	dev->mm2s_done = 0;
	dev->error = 0;
	status = XAxiDma_SimpleTransfer(&dev->dma, (UINTPTR)buf, len, XAXIDMA_DMA_TO_DEVICE);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	timeout = dev->timeout;
	while (timeout--) {
		if (dev->mm2s_done || dev->error) {
			if (dev->error) {
				dma_reset(dev);
				return XST_FAILURE;
			}
			return XST_SUCCESS;
		}
		timer_delay(dev->tmr, 1);
	}

	return XST_FAILURE;
}

/**
 * @brief Start DMA receive transaction
 * @param dev Pointer to device structure
 * @param buf Pointer to data array to receive
 * @param len Length of array in bytes
 * @return XST_SUCCESS | XST_FAILURE
 */
int dma_receive(struct dma_dev *dev, uint32_t *buf, uint16_t len)
{
	int status;
	u16 timeout;

	if (!dev)
		return XST_FAILURE;
	if (!len)
		return XST_SUCCESS;
	if (dev->vec_id_s2mm == -1)
		return XST_FAILURE;

	dev->s2mm_done = 0;
	dev->error = 0;
	status = XAxiDma_SimpleTransfer(&dev->dma, (UINTPTR)buf, len, XAXIDMA_DEVICE_TO_DMA);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	timeout = dev->timeout;
	while (timeout--) {
		if (dev->s2mm_done || dev->error) {
			if (dev->error) {
				dma_reset(dev);
				return XST_FAILURE;
			}
			return XST_SUCCESS;
		}
		timer_delay(dev->tmr, 1);
	}

	return XST_FAILURE;
}

/**
 * @brief Reset DMA
 * @param dev Pointer to device structure
 * @return void
 */
int dma_reset(struct dma_dev *dev)
{
	int timeout = RESET_TIMEOUT;
	int status;

	XAxiDma_Reset(&dev->dma);
	while (timeout--) {
		if (XAxiDma_ResetIsDone(&dev->dma))
			break;
	}

	status = XAxiDma_Selftest(&dev->dma);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	if (dev->intc) {
		if (dev->vec_id_mm2s != -1)
			XAxiDma_IntrEnable(&dev->dma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
		if (dev->vec_id_s2mm != -1)
			XAxiDma_IntrEnable(&dev->dma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	}

	return XST_SUCCESS;
}

/**
 * @brief DMA MM2S transaction handler
 * @param dev Pointer to device structure
 * @return void
 */
static void mm2s_irq_handler(struct dma_dev *dev)
{
	u32 irq_status;
	int timeout;

	irq_status = XAxiDma_IntrGetIrq(&dev->dma, XAXIDMA_DMA_TO_DEVICE);
	XAxiDma_IntrAckIrq(&dev->dma, irq_status, XAXIDMA_DMA_TO_DEVICE);

	if (!(irq_status & XAXIDMA_IRQ_ALL_MASK)) {
		return;
	}

	if ((irq_status & XAXIDMA_IRQ_ERROR_MASK)) {
		XAxiDma_Reset(&dev->dma);
		timeout = RESET_TIMEOUT;

		while (timeout--) {
			if (XAxiDma_ResetIsDone(&dev->dma))
				break;
		}
		return;
	}

	if ((irq_status & XAXIDMA_IRQ_IOC_MASK)) {
		dev->mm2s_done = 1;
	}
}

/**
 * @brief DMA S2MM transaction handler
 * @param dev Pointer to device structure
 * @return void
 */
static void s2mm_irq_handler(struct dma_dev *dev)
{
	u32 irq_status;

	irq_status = XAxiDma_IntrGetIrq(&dev->dma, XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrAckIrq(&dev->dma, irq_status, XAXIDMA_DEVICE_TO_DMA);

	if (!(irq_status & XAXIDMA_IRQ_ALL_MASK)) {
		return;
	}

	if ((irq_status & XAXIDMA_IRQ_ERROR_MASK)) {
		dev->error = 1;
		return;
	}

	if ((irq_status & XAXIDMA_IRQ_IOC_MASK)) {
		dev->s2mm_done = 1;
	}
}
