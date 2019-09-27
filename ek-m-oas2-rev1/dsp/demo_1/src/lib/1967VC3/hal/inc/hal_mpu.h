#ifndef __HAL_MPU_H__
#define __HAL_MPU_H__

#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"



enum HalMpuRegions {
	HalMpuRegionMS0,
	HalMpuRegionMS1,
	HalMpuRegionSDRAM
};

enum HalMpuCacheStrategies {
	HalMpuCacheWriteBack,
	HalMpuCacheWriteThrough,	
};

enum HalMpuMissBehavior {
	HalMpuLoadOneQWordOnMiss,
	HalMpuLoadTwoQWordOnMiss
};


#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus
	void HAL_MPU_DeInit(void);
	void HAL_MPU_SetupDataCacheStrategy(uint8_t memoryRegion, uint32_t pages, uint8_t strategy);
	void HAL_MPU_SetCacheableDataPages(uint8_t memoryRegion, uint32_t pages);
	void HAL_MPU_SetCacheableInstructionPages(uint8_t memoryRegion, uint32_t pages);
	void HAL_MPU_SetDataCacheMissBehavior(uint8_t value);
	void HAL_MPU_SetInstructionCacheMissBehavior(uint8_t value);
	void HAL_MPU_EnableDataCache(void);
	void HAL_MPU_EnableInstructionCache(void);
	void HAL_MPU_DisableDataCache(void);
	void HAL_MPU_DisableInstructionCache(void);
#ifdef __cplusplus
}
#endif // __cplusplus

#endif //__HAL_MPU_H__
