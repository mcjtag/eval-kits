/**
 * @file hmc1031_selftest.c
 * @brief HMC1031 selftest
 * @author matyunin.d
 * @date 19.01.2018
 * @copyright MIT License
 */

#include "hmc1031.h"
#include "xparameters.h"
#include "stdio.h"
#include "xil_io.h"

/**
 * @brief HMC1031 selftest
 * @param baseaddr_p Base pointer
 * @return XST_SUCCESS
 */
XStatus hmc1031_selftest(void *baseaddr_p)
{
	(void)baseaddr_p;

	return XST_SUCCESS;
}
