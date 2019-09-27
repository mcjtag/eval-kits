#ifndef __MEM_TEST_H__
#define __MEM_TEST_H__

typedef struct 
{
	int StartAddress;
	int Count;	
	int InitialData [4];
	int ExtraParams;
} MemTestArgs;


typedef struct 
{
	int ErrorFlag;
	int TestMode;
	int FisrtErrorAddress;
	int CorrectData [4];
	int ActualData [4];	
} MemTestResult;


// Assembly functions declarations
#ifdef __CMCPPTSH__
#ifdef __cplusplus
extern "C" {
#endif // __cplusplus
#else
extern "asm" {
#endif // __CMCPPTSH__
	void incremental_block_test_32_write(MemTestArgs* testArgs, MemTestResult* testResult);
	void incremental_block_test_32_check(MemTestArgs* testArgs, MemTestResult* testResult);
	
	void incremental_block_test_64_write(MemTestArgs* testArgs, MemTestResult* testResult);
	void incremental_block_test_64_check(MemTestArgs* testArgs, MemTestResult* testResult);
	
	void incremental_block_test_128_write(MemTestArgs* testArgs, MemTestResult* testResult);
	void incremental_block_test_128_check(MemTestArgs* testArgs, MemTestResult* testResult);
	
	void incremental_slow_wr_test_32(MemTestArgs* testArgs, MemTestResult* testResult);
	void incremental_slow_wr_test_64(MemTestArgs* testArgs, MemTestResult* testResult);
	void incremental_slow_wr_test_128(MemTestArgs* testArgs, MemTestResult* testResult);
	
	
	
	
	void mem_test_inverting_bits_128_write(MemTestArgs* testArgs, MemTestResult* testResult);
	void mem_test_inverting_bits_128_check(MemTestArgs* testArgs, MemTestResult* testResult);
	
	void mem_test_rotating_bits_128_write(MemTestArgs* testArgs, MemTestResult* testResult);
	void mem_test_rotating_bits_128_check(MemTestArgs* testArgs, MemTestResult* testResult);
	
	void mem_test_pseudorandom_128_write(MemTestArgs* testArgs, MemTestResult* testResult);
	void mem_test_pseudorandom_128_check(MemTestArgs* testArgs, MemTestResult* testResult);
	
	
#ifdef __CMCPPTSH__
#ifdef __cplusplus
}
#endif // __cplusplus
#else
}
#endif // __CMCPPTSH__


#endif	// __MEM_TEST_H__
