#ifndef __FLASH_DEV_H_
#define __FLASH_DEV_H_

#include "stdint.h"

enum FlashStatusCodes {
	FS_Ready,
	FS_Busy,
	FS_Error
};

enum FlashProtectionCodes {
	FP_Unprotected,
	FP_Protected,
	FP_ProtectedPart
};

enum OperationResults {
	OpSuccess,
	OpFrwError,
	OpDevError,
	OpProtError,
};


typedef struct {
	uint32_t sector_count;
	uint32_t sector_size;
	uint32_t page_size;
} flash_drv_config_t;






#endif //__FLASH_DEV_H_	
