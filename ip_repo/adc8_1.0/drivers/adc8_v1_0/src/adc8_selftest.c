/**
 * @file adc8_selftest.c
 * @brief Selftest
 * @author matyunin.d
 * @date 06.08.2019
 * @copyright MIT License
 */

#include "adc8.h"
#include "xparameters.h"
#include "stdio.h"
#include "xil_io.h"

/**
 * @brief Selftest
 * @param baseaddr_p Base address
 * @return XST_SUCCESS
 */
int adc8_selftest(void *baseaddr_p)
{
	(void)baseaddr_p;

	return XST_SUCCESS;
}
