/**
 * @file hmc1033.h
 * @brief HMC1033 Controller
 * @author matyunin.d
 * @date 29.07.2019
 * @copyright MIT License
 */

#ifndef HMC1033_H
#define HMC1033_H

#include "xil_types.h"
#include "xstatus.h"

typedef struct{
	u32 baseaddr;
	void *hwdev;
} hmc1033_dev_t;

struct hmc1033_config {
	int nout;
	int rdiv;
	int nint;
	int nfrac;
	int icp;
};

int hmc1033_init(hmc1033_dev_t *dev, u32 baseaddr);
void hmc1033_calculate(double xtal, double out_freq, struct hmc1033_config *cfg);
void hmc1033_apply(hmc1033_dev_t *dev, const struct hmc1033_config *cfg);
int hmc1033_selftest(void * baseaddr_p);

#endif // HMC1033_H
