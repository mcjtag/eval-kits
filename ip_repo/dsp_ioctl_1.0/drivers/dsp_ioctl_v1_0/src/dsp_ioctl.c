/**
 * @file dsp_ioctl.c
 * @brief DSP IO Control
 * @author matyunin.d
 * @date 23.01.2018
 * @copyright MIT License
 */

#include "dsp_ioctl.h"
#include "xil_io.h"

#define NDEV	9

#define REG_CRX_OFFSET		0
#define REG_CR0_OFFSET		4
#define REG_CR1_OFFSET		8
#define REG_CR2_OFFSET		12
#define REG_CR3_OFFSET		16
#define REG_CR4_OFFSET		20
#define REG_CR5_OFFSET		24
#define REG_CR6_OFFSET		28
#define REG_CR7_OFFSET		32

#define REG_CR_RST			(1 << 0)
#define REG_CR_IRQ0			(1 << 1)
#define REG_CR_IRQ1			(1 << 2)

#define REG_CR_RST_OFFSET	(0)
#define REG_CR_IRQ_OFFSET	(1)

#define REG_CR_RST_MSK		(1)
#define REG_CR_IRQ_MSK		(3)

#define write_reg(baseaddr, offset, data)	Xil_Out32((baseaddr) + (offset), (u32)(data))
#define read_reg(baseaddr, offset)			Xil_In32((baseaddr) + (offset))

static const u32 reg_addr[NDEV] = {
	REG_CRX_OFFSET, REG_CR0_OFFSET, REG_CR1_OFFSET, REG_CR2_OFFSET, REG_CR3_OFFSET,
	REG_CR4_OFFSET, REG_CR5_OFFSET, REG_CR6_OFFSET, REG_CR7_OFFSET
};

/**
 * @brief CPU ioctl device initialization
 * @param dev Pointer to device
 * @param baseadd Base address of device
 * @return XST_SUCCESS | XST_FAILURE
 */
XStatus dsp_ioctl_init(dsp_ioctl_dev_t *dev, u32 baseaddr)
{
	if (!dev || !baseaddr)
		return XST_FAILURE;

	dev->baseaddr = baseaddr;

	return XST_SUCCESS;
}

/**
 * @brief Reset DSP
 * @param dev Pointer to device
 * @param ndev Device number
 * @param state Reset state (DSP_IOCTL_RESET)
 * @return void
 */
void dsp_ioctl_reset(dsp_ioctl_dev_t *dev, int ndev, int state)
{
	u32 tmp;

	if (!dev)
		return;

	if ((ndev < 0) || (ndev > (NDEV - 1)))
		return;

	tmp = read_reg(dev->baseaddr, reg_addr[ndev]);
	switch (state) {
	case DSP_IOCTL_RESET_ON:
		tmp |= REG_CR_RST;
		break;
	case DSP_IOCTL_RESET_OFF:
		tmp &= ~REG_CR_RST;
		break;
	default:
		return;
	}
	write_reg(dev->baseaddr, reg_addr[ndev], tmp);
}

/**
 * @brief Initiate DSP IRQ
 * @param dev Pointer to device
 * @param ndev Device number
 * @param irq IRQ number (DSP_IOCTL_IRQ)
 * @return void
 */
void dsp_ioctl_irq(dsp_ioctl_dev_t *dev, int ndev, int irq)
{
	u32 tmp;

	if (!dev)
		return;

	if ((ndev < 0) || (ndev > (NDEV - 1)))
		return;

	tmp = read_reg(dev->baseaddr, reg_addr[ndev]);
	tmp |= (irq & REG_CR_IRQ_MSK) << REG_CR_IRQ_OFFSET;
	write_reg(dev->baseaddr, reg_addr[ndev], tmp);
}
