/**
 * @file dsp_ioctl_selftest.c
 * @brief DSP IO Control
 * @author matyunin.d
 * @date 23.01.2018
 * @copyright MIT License
 */

#include "dsp_ioctl.h"
#include "xparameters.h"
#include "stdio.h"
#include "xil_io.h"

/**
 * @brief Selftest
 * @param baseaddr_p Base address
 * @return XST_SUCCESS
 */
XStatus dsp_ioctl_selftest(void *baseaddr_p)
{
	(void)baseaddr_p;

	return XST_SUCCESS;
}
