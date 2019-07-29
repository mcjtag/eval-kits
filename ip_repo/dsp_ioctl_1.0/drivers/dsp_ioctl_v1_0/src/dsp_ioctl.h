/**
 * @file dsp_ioctl.h
 * @brief DSP IO Control
 * @author matyunin.d
 * @date 23.01.2018
 * @copyright MIT License
 */

#ifndef DSP_IOCTL_H
#define DSP_IOCTL_H

#include "xil_types.h"
#include "xstatus.h"

enum DSP_IOCTL_DEV {
	DSP_IOCTL_DEV_ALL,
	DSP_IOCTL_DEV_0,
	DSP_IOCTL_DEV_1,
	DSP_IOCTL_DEV_2,
	DSP_IOCTL_DEV_3,
	DSP_IOCTL_DEV_4,
	DSP_IOCTL_DEV_5,
	DSP_IOCTL_DEV_6,
	DSP_IOCTL_DEV_7
};

enum DSP_IOCTL_RESET {
	DSP_IOCTL_RESET_ON,
	DSP_IOCTL_RESET_OFF
};

enum DSP_IOCTL_IRQ {
	DSP_IOCTL_IRQ_0 = 1,
	DSP_IOCTL_IRQ_1
};

typedef struct {
	u32 baseaddr;
} dsp_ioctl_dev_t;

XStatus dsp_ioctl_init(dsp_ioctl_dev_t *dev, u32 baseaddr);
void dsp_ioctl_reset(dsp_ioctl_dev_t *dev, int ndev, int state);
void dsp_ioctl_irq(dsp_ioctl_dev_t *dev, int ndev, int irq);
XStatus dsp_ioctl_selftest(void *baseaddr_p);

#endif // DSP_IOCTL_H
