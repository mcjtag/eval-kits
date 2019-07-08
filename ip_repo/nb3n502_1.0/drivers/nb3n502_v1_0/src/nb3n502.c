/**
 * @file nb3n502.c
 * @brief NB3N502 Controller
 * @author matyunin.d
 * @date 03.04.2019
 * @copyright MIT License
 */

#include "nb3n502.h"
#include "xil_io.h"

#define REG_CR_OFFSET 		0x0

#define REG_CR_MUL_MSK		((u32)0x00000007)

#define write_reg(base, offset, data) Xil_Out32((base) + (offset), (u32)(data))
#define read_reg(base, offset) Xil_In32((base) + (offset))

/**
 * @brief NB3N502 device initialization
 * @param dev Pointer to NB3N502 device
 * @param baseaddr Base address of the device
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus nb3n502_init(nb3n502_dev_t *dev, u32 baseaddr)
{
	if (!dev || !baseaddr)
		return XST_FAILURE;

	dev->baseaddr = baseaddr;
	write_reg(dev->baseaddr, REG_CR_OFFSET, 0);

	return XST_SUCCESS;
}

/**
 * @brief Set PLL multiplier
 * @param dev Pointer to NB3N502 device
 * @param mul Multiplier (NB3N502_MULT)
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus nb3n502_multiplier(nb3n502_dev_t *dev, int mul)
{
	if (!dev || !dev->baseaddr)
		return XST_FAILURE;

	write_reg(dev->baseaddr, REG_CR_OFFSET, mul & REG_CR_MUL_MSK);

	return XST_SUCCESS;
}
