/**
 * @file ADC8_TCB.c
 * @brief ADC8 TCB Controller
 * @author matyunin.d
 * @date 13.08.2019
 * @copyright MIT License
 */

#include "adc8_tcb.h"
#include "xil_io.h"
#include <string.h>

/* Register Address */
#define REG_CR_OFFSET 		((u32)0x00)
#define REG_LR_OFFSET		((u32)0x04)
#define REG_NR_OFFSET 		((u32)0x08)
#define REG_OR_OFFSET 		((u32)0x0C)

/* Register Map */
#define REG_CR_START_MSK	((u32)0x00000001)
#define REG_CR_FORMAT_MSK	((u32)0x00000002)

/* Register Operations */
#define WRITE_REG(base_addr, offset, data) 		Xil_Out32((base_addr) + (offset), (u32)(data))
#define READ_REG(base_addr, offset)				Xil_In32((base_addr) + (offset))

/**
 * @brief ADC8 TCB initialization 
 * @param dev Pointer to device structure
 * @param baseaddr Base address
 * @return XST_SUCCESS | XST_FAILURE
 */
int adc8_tcb_init(adc8_tcb_dev_t *dev, u32 baseaddr)
{
	if (!dev || !baseaddr)
		return XST_FAILURE;

	dev->baseaddr = baseaddr;
	WRITE_REG(dev->baseaddr, REG_CR_OFFSET, 2);
	WRITE_REG(dev->baseaddr, REG_LR_OFFSET, 0);
	WRITE_REG(dev->baseaddr, REG_NR_OFFSET, 0);

	return XST_SUCCESS;
}

/**
 * @brief Set block length
 * @param dev Pointer to device structure
 * @param length Length of the block (in samples)
 * @return void
 */
void adc8_tcb_set_length(adc8_tcb_dev_t *dev, u16 length)
{
	WRITE_REG(dev->baseaddr, REG_LR_OFFSET, (u32)length);
}

/**
 * @brief Set normalization factor A in 'Y=AX+B' (only when ADC8_TCB_FORMAT_FLOAT format active) 
 * @param dev Pointer to device structure
 * @param norm Normalization factor
 * @return void
 */
void adc8_tcb_set_norm(adc8_tcb_dev_t *dev, float norm)
{
	u32 unorm;
	memcpy(&unorm, &norm, sizeof(float));
	WRITE_REG(dev->baseaddr, REG_NR_OFFSET, unorm);
}

/**
 * @brief Set offset factor B in 'Y=AX+B' (only when ADC8_TCB_FORMAT_FLOAT format active) 
 * @param dev Pointer to device structure
 * @param offt Offset factor
 * @return void
 */
void adc8_tcb_set_offt(adc8_tcb_dev_t *dev, float offt)
{
	u32 uofft;
	memcpy(&uofft, &offt, sizeof(float));
	WRITE_REG(dev->baseaddr, REG_OR_OFFSET, uofft);
}

/**
 * @brief Set output format
 * @param dev Pointer to device structure
 * @param format Output format (ADC8_TCB_FORMAT)
 * @return void
 */
void adc8_tcb_set_format(adc8_tcb_dev_t *dev, int format)
{
	switch (format) {
		case ADC8_TCB_FORMAT_FLOAT:
			WRITE_REG(dev->baseaddr, REG_CR_OFFSET, 0);
			break;
		case ADC8_TCB_FORMAT_FIX:
			WRITE_REG(dev->baseaddr, REG_CR_OFFSET, REG_CR_FORMAT_MSK);
			break;
	}
}

/**
 * @brief Start transcation 
 * @param dev Pointer to device structure
 * @return void
 */
void adc8_tcb_start(adc8_tcb_dev_t *dev)
{
	u32 tmp = READ_REG(dev->baseaddr, REG_CR_OFFSET) | REG_CR_START_MSK;
	WRITE_REG(dev->baseaddr, REG_CR_OFFSET, tmp);
}