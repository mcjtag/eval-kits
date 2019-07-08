/**
 * @file nb3n502_selftest.c
 * @brief Selftest
 * @author matyunin.d
 * @date 01.04.2019
 * @copyright MIT License
 */

#include "nb3n502.h"
#include "xparameters.h"
#include "stdio.h"
#include "xil_io.h"

/**
 * @brief Selftest
 * @param baseaddr_p Base address
 * @return XST_SUCCESS
 */
XStatus nb3n502_selftest(void *baseaddr_p)
{
	(void)baseaddr_p;

	return XST_SUCCESS;
}
