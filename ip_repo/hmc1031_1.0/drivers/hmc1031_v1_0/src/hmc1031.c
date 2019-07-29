/**
 * @file hmc1031.c
 * @brief HMC1031 driver
 * @author matyunin.d
 * @date 19.01.2018
 * @copyright MIT License
 */

#include "hmc1031.h"
#include "xil_io.h"

#define REG_CR_OFFSET 	0
#define REG_SR_OFFSET 	4

#define REG_CR_D		3
#define REG_SR_LD		1

#define write_reg(baseaddr, offset, data)	Xil_Out32((baseaddr) + (offset), (u32)(data))
#define read_reg(baseaddr, offset)			Xil_In32((baseaddr) + (offset))

/**
 * @brief HMC1031 initialization
 * @param dev Pointer to HMC1031 device
 * @param baseaddr Base address of device
 * @return XST_SUCCESS, XST_FAILURE 
 */
XStatus hmc1031_init(hmc1031_dev_t *dev, u32 baseaddr)
{
	if (!dev)
		return XST_FAILURE;

	dev->baseaddr = baseaddr;
	write_reg(dev->baseaddr, REG_CR_OFFSET, 0);

	return XST_SUCCESS;
}

/**
 * @brief Set HMC1031 divider
 * @param dev Pointer to HMC1031 device
 * @param div Divider (HMC1031_DIVIDER)
 * @return XST_SUCCESS, XST_FAILURE
 */
XStatus hmc1031_divider(hmc1031_dev_t *dev, int div)
{
	if (!dev)
		return XST_FAILURE;

	write_reg(dev->baseaddr, REG_CR_OFFSET, (u32)div & 0x3);

	return XST_SUCCESS;
}

/**
 * @brief Get PLL lock state
 * @param dev Pointer to HMC1031 device
 * @return 1 - locked, 0 - not locked
 */
int hmc1031_locked(hmc1031_dev_t *dev)
{
	u32 tmp;

	if (!dev)
		return -1;

	tmp = read_reg(dev->baseaddr, REG_SR_OFFSET);

	return (tmp & REG_SR_LD) ? 1 : 0;
}
