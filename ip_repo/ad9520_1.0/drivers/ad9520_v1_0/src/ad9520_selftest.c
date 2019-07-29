/**
 * @file ad9520_selftest.c
 * @brief Selftest
 * @author matyunin.d
 * @date 22.05.2017
 * @copyright MIT License
 */

#include "ad9520.h"
#include "xparameters.h"
#include "stdio.h"
#include "xil_io.h"

/**
 * @brief Selftest
 * @param baseaddr_p Base address
 * @return XST_SUCCESS
 */
XStatus ad9520_selftest(void *baseaddr_p)
{
	(void)baseaddr_p;

	return XST_SUCCESS;
}
