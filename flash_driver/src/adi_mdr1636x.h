/**
 * @file adi_mdr1636x.h
 * @brief Performs specific flash operations 
 * @author matyunin.d
 * @date 18.07.2019
 */
 
#ifndef __ADI_MDR1636X_H__
#define __ADI_MDR1636X_H__

#include "services.h"
#include "mdr1636x.h"


#ifdef __MEM_MDR1636RR2__

#define __MEM_DEFINED__
#define	AFP_SECTOR_SIZE	MDR1636PP2_SECTOR_SIZE
#define AFP_SECTOR_NUM	MDR1636PP2_SECTOR_COUNT

#endif

#ifdef __MEM_MDR1636RR4__

#define __MEM_DEFINED__
#define	AFP_SECTOR_SIZE	MDR1636PP4_SECTOR_SIZE
#define AFP_SECTOR_NUM	MDR1636PP4_SECTOR_COUNT

#endif

#ifndef	__MEM_DEFINED__
#error	Memory is undefined
#endif	//__MEM_DEFINED__


extern ADI_DEV_PDD_ENTRY_POINT ADIMDR1636XEntryPoint;
extern ADI_DEV_DEVICE_HANDLE DevHandleMDR1636X;

#endif // __ADI_MDR1636X_H__
