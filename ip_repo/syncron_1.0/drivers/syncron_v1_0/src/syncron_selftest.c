/**
 * @file syncron_selftest.c
 * @brief Syncronizaer selftest
 * @author matyunin.d
 * @date 23.01.2018
 * @copyright MIT License
 */

#include "syncron.h"
#include "xparameters.h"
#include "stdio.h"
#include "xil_io.h"

/**
 * @brief Selftest
 * @param baseaddr_p Base address
 * @return XST_SUCCESS
 */
XStatus syncron_selftest(void *baseaddr_p)
{
	(void)baseaddr_p;

	return XST_SUCCESS;
}
