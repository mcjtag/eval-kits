/********************************************************************

	Note: only MSSD0 can be configured to be cacheable or not.
	MSSD1-MSSD3 are always write-back cacheable.

********************************************************************/

#include "cpu.h"
#include "hal_mpu.h"
#include "core_utils.h"


void HAL_MPU_DeInit(void)
{
	__write_sysreg(ADDR2GROUPREG(MPU_CR_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(MS0_C_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(MS0_WT_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(MS0_CI_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(MS1_C_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(MS1_WT_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(MS1_CI_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(SDR_C_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(SDR_WT_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(SDR_CI_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(PU0_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(PU1_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(PU2_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(PU3_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(PU4_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(PU5_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(PU6_LOC), 0);
	__write_sysreg(ADDR2GROUPREG(PU7_LOC), 0);
}


void HAL_MPU_SetupDataCacheStrategy(uint8_t memoryRegion, uint32_t pages, uint8_t strategy)
{
	uint32_t temp32u;
	switch(memoryRegion)
	{
		case HalMpuRegionMS0:
			temp32u = __read_sysreg(ADDR2GROUPREG(MS0_WT_LOC));
			if (strategy == HalMpuCacheWriteBack)
				temp32u &= ~pages;
			else
				temp32u |= pages;
			__write_sysreg(ADDR2GROUPREG(MS0_WT_LOC), temp32u);
			break;	
		case HalMpuRegionMS1:
			temp32u = __read_sysreg(ADDR2GROUPREG(MS1_WT_LOC));
			if (strategy == HalMpuCacheWriteBack)
				temp32u &= ~pages;
			else
				temp32u |= pages;
			__write_sysreg(ADDR2GROUPREG(MS1_WT_LOC), temp32u);
			break;	
		case HalMpuRegionSDRAM:
			temp32u = __read_sysreg(ADDR2GROUPREG(SDR_WT_LOC));
			if (strategy == HalMpuCacheWriteBack)
				temp32u &= ~pages;
			else
				temp32u |= pages;
			__write_sysreg(ADDR2GROUPREG(SDR_WT_LOC), temp32u);
			break;	
	}
}


void HAL_MPU_SetCacheableDataPages(uint8_t memoryRegion, uint32_t pages)
{
	switch(memoryRegion)
	{
		case HalMpuRegionMS0:
			__write_sysreg(ADDR2GROUPREG(MS0_C_LOC), pages);
			break;	
		case HalMpuRegionMS1:
			__write_sysreg(ADDR2GROUPREG(MS1_C_LOC), pages);
			break;	
		case HalMpuRegionSDRAM:
			__write_sysreg(ADDR2GROUPREG(SDR_C_LOC), pages);
			break;	
	}
}


void HAL_MPU_SetCacheableInstructionPages(uint8_t memoryRegion, uint32_t pages)
{
	switch(memoryRegion)
	{
		case HalMpuRegionMS0:
			__write_sysreg(ADDR2GROUPREG(MS0_CI_LOC), pages);
			break;	
		case HalMpuRegionMS1:
			__write_sysreg(ADDR2GROUPREG(MS1_CI_LOC), pages);
			break;	
		case HalMpuRegionSDRAM:
			__write_sysreg(ADDR2GROUPREG(SDR_CI_LOC), pages);
			break;	
	}
}


void HAL_MPU_SetDataCacheMissBehavior(uint8_t value)
{
	uint32_t temp32u = __read_sysreg(ADDR2GROUPREG(MPU_CR_LOC));
	if (value == HalMpuLoadOneQWordOnMiss)
		temp32u &= ~(1 << CWT_EN_2DQW_P);
	else
		temp32u |= (1 << CWT_EN_2DQW_P);
	__write_sysreg(ADDR2GROUPREG(MPU_CR_LOC), temp32u);
}


void HAL_MPU_SetInstructionCacheMissBehavior(uint8_t value)
{
	uint32_t temp32u = __read_sysreg(ADDR2GROUPREG(MPU_CR_LOC));
	if (value == HalMpuLoadOneQWordOnMiss)
		temp32u &= ~(1 << CWT_EN_2IQW_P);
	else
		temp32u |= (1 << CWT_EN_2IQW_P);
	__write_sysreg(ADDR2GROUPREG(MPU_CR_LOC), temp32u);
}


void HAL_MPU_EnableDataCache(void)
{
	uint32_t temp32u = __read_sysreg(ADDR2GROUPREG(MPU_CR_LOC));
	temp32u |= (1 << CWT_DC_ON_P);
	__write_sysreg(ADDR2GROUPREG(MPU_CR_LOC), temp32u);
}


void HAL_MPU_EnableInstructionCache(void)
{
	uint32_t temp32u = __read_sysreg(ADDR2GROUPREG(MPU_CR_LOC));
	temp32u |= (1 << CWT_IC_ON_P);
	__write_sysreg(ADDR2GROUPREG(MPU_CR_LOC), temp32u);
}


void HAL_MPU_DisableDataCache(void)
{
	uint32_t temp32u = __read_sysreg(ADDR2GROUPREG(MPU_CR_LOC));
	temp32u &= ~(1 << CWT_DC_ON_P);
	__write_sysreg(ADDR2GROUPREG(MPU_CR_LOC), temp32u);
}


void HAL_MPU_DisableInstructionCache(void)
{
	uint32_t temp32u = __read_sysreg(ADDR2GROUPREG(MPU_CR_LOC));
	temp32u &= ~(1 << CWT_IC_ON_P);
	__write_sysreg(ADDR2GROUPREG(MPU_CR_LOC), temp32u);
}


