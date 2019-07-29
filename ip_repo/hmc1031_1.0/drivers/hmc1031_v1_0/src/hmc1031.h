/**
 * @file hmc1031.h
 * @brief HMC1031 driver
 * @author matyunin.d
 * @date 19.01.2018
 * @copyright MIT License
 */

#ifndef HMC1031_H
#define HMC1031_H

#include "xil_types.h"
#include "xstatus.h"

typedef struct {
	u32 baseaddr;
} hmc1031_dev_t;

enum HMC1031_DIVIDER {
	HMC1031_DIVIDER_PD = 0,
	HMC1031_DIVIDER_DIV1 = 1,
	HMC1031_DIVIDER_DIV5 = 2,
	HMC1031_DIVIDER_DIV10 = 3
};

XStatus hmc1031_init(hmc1031_dev_t *dev, u32 baseaddr);
XStatus hmc1031_divider(hmc1031_dev_t *dev, int div);
int hmc1031_locked(hmc1031_dev_t *dev);
XStatus hmc1031_selftest(void *baseaddr_p);

#endif // HMC1031_H
