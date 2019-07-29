/**
 * @file
 * @brief Memory test
 * @author matyunin.d
 * @date 11.07.2019
 */
 
#include "memtest.h"
#include "mem_test.h"
#include <defts201.h>
#include <sysreg.h>
#include <builtins.h>
#include <stdio.h>
#include "mem_test.h"
#include "core_utils.h"

int memtest(void)
{
	MemTestArgs	testArgs;
	MemTestResult testResult;
	int i;
	int err = 0;
	
	testArgs.StartAddress = 0x40000000;
	testArgs.Count = 0x00400000;
	
	/* Counter test */
	printf("\n******** Counter test 1 ********\n");
	
	testArgs.InitialData[0] = 0xA1A2A300;
	testArgs.InitialData[1] = 0xB4B5B601;
	testArgs.InitialData[2] = 0xC7C8C902;
	testArgs.InitialData[3] = 0xDADBDC03;
	
	incremental_block_test_64_write(&testArgs, &testResult);
	incremental_block_test_64_check(&testArgs, &testResult);
	
	if (testResult.ErrorFlag) {
		printf("Error at 0x%08X\nexp  0x%08X 0x%08X\nread 0x%08X 0x%08X\n", 
			testResult.FisrtErrorAddress, 
			testResult.CorrectData[0], 
			testResult.CorrectData[1],
			testResult.ActualData[0],
			testResult.ActualData[1]);
		err++;
	}
	else {
		printf("OK\n");
	}
		
	/* Counter test */
	printf("\n******** Counter test 2 ********\n");
	
	testArgs.InitialData[0] = 0xA1A2A300;
	testArgs.InitialData[1] = 0xB4B5B601;
	testArgs.InitialData[2] = 0xC7C8C902;
	testArgs.InitialData[3] = 0xDADBDC03;
	
	incremental_block_test_128_write(&testArgs, &testResult);
	incremental_block_test_128_check(&testArgs, &testResult);
	
	if (testResult.ErrorFlag) {
		printf("Error at 0x%08X\nexp  0x%08X 0x%08X 0x%08X 0x%08X\nread 0x%08X 0x%08X 0x%08X 0x%08X\n",
			testResult.FisrtErrorAddress, 
			testResult.CorrectData[0], 
			testResult.CorrectData[1], 
			testResult.CorrectData[2], 
			testResult.CorrectData[3],
			testResult.ActualData[0], 
			testResult.ActualData[1], 
			testResult.ActualData[2], 
			testResult.ActualData[3] );
		err++;
	} else {
		printf("OK\n");
	}
	
	/* Stress test 1 */
	printf("******** Stress test 1 ********\n");
	
	testArgs.InitialData[0] = 0xAAAAAAAA;
	testArgs.InitialData[1] = 0xFFFFFFFF;
	testArgs.InitialData[2] = 0x00000000;
	testArgs.InitialData[3] = 0x55555555;
	
	mem_test_inverting_bits_128_write(&testArgs, &testResult);
	mem_test_inverting_bits_128_check(&testArgs, &testResult);
	
	if (testResult.ErrorFlag) {
		printf("Error at 0x%08X\nexp  0x%08X 0x%08X 0x%08X 0x%08X\nread 0x%08X 0x%08X 0x%08X 0x%08X\n",
			testResult.FisrtErrorAddress, 
			testResult.CorrectData[0], 
			testResult.CorrectData[1], 
			testResult.CorrectData[2], 
			testResult.CorrectData[3],
			testResult.ActualData[0], 
			testResult.ActualData[1], 
			testResult.ActualData[2], 
			testResult.ActualData[3]);
		err++;
	} else {
		printf("OK\n");
	}
	
	/* Stress test 2 */
	printf("******** Stress test 2 ********\n");
	
	testArgs.InitialData[0] = 0x00000000;
	testArgs.InitialData[1] = 0xFFFFFFFF;
	testArgs.InitialData[2] = 0xFFFFFFFF;
	testArgs.InitialData[3] = 0x00000000;
	
	mem_test_inverting_bits_128_write(&testArgs, &testResult);
	mem_test_inverting_bits_128_check(&testArgs, &testResult);
	
	if (testResult.ErrorFlag) {
		printf("Error at 0x%08X\nexp  0x%08X 0x%08X 0x%08X 0x%08X\nread 0x%08X 0x%08X 0x%08X 0x%08X\n",
			testResult.FisrtErrorAddress, 
			testResult.CorrectData[0], 
			testResult.CorrectData[1], 
			testResult.CorrectData[2], 
			testResult.CorrectData[3],
			testResult.ActualData[0], 
			testResult.ActualData[1], 
			testResult.ActualData[2], 
			testResult.ActualData[3]);
		err++;
	} else {
		printf("OK\n");
	}
	return err;
}

