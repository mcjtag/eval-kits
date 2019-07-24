/**
 * @file adi_mdr1636x.h
 * @brief Performs specific flash operations 
 * @author matyunin.d
 * @date 18.07.2019
 */

#include <sysreg.h>
#include <defTS201.h>
#include "adi_mdr1636x.h"
#include "mdr1636x_bus.h"
#include "util.h"
#include "Errors.h"

#ifdef __CPU_1967VN028__
static char *pTitle		= "MVM Flash programmer";
#endif

#ifdef __CPU_1967VN044__
static char *pTitle		= "OAS Flash programmer";
#endif

#ifdef	__MEM_DEFINED__

#ifdef __MEM_MDR1636RR2__
static char *pDesc		= "Milandr. MDR1636RR2";
#endif

#ifdef __MEM_MDR1636RR4__
static char *pDesc		= "Milandr. MDR1636RR4";
#endif

#else

static char *pDesc		= "";

#endif

static char *pCompany	= "Milandr";

static flash_drv_config_t driver_config = {
	.sector_size = AFP_SECTOR_SIZE,
	.sector_count = AFP_SECTOR_NUM,
	.page_size = 0
};

/* Open a device */
static u32 adi_pdd_Open(
	ADI_DEV_MANAGER_HANDLE	ManagerHandle,		// device manager handle
	u32 					DeviceNumber,		// device number
	ADI_DEV_DEVICE_HANDLE 	DeviceHandle,		// device handle
	ADI_DEV_PDD_HANDLE 		*pPDDHandle,		// pointer to PDD handle location
	ADI_DEV_DIRECTION 		Direction,			// data direction
	void					*pEnterCriticalArg,	// enter critical region parameter
	ADI_DMA_MANAGER_HANDLE	DMAHandle,			// handle to the DMA manager
	ADI_DCB_HANDLE			DCBHandle,			// callback handle
	ADI_DCB_CALLBACK_FN		DMCallback			// device manager callback function
);

/* Close a device */
static u32 adi_pdd_Close(
	ADI_DEV_PDD_HANDLE PDDHandle
);

/* Read from a device */
static u32 adi_pdd_Read(
	ADI_DEV_PDD_HANDLE 	PDDHandle,
	ADI_DEV_BUFFER_TYPE BufferType,
	ADI_DEV_BUFFER		*pBuffer
);

/* Write to a device */
static u32 adi_pdd_Write(
	ADI_DEV_PDD_HANDLE 	PDDHandle,
	ADI_DEV_BUFFER_TYPE BufferType,
	ADI_DEV_BUFFER		*pBuffer
);

/* Control the device */
static u32 adi_pdd_Control(
	ADI_DEV_PDD_HANDLE 	PDDHandle,
 	u32					Command,
 	void				*pArg
);

static ERROR_CODE ResetFlash(void);
static ERROR_CODE EraseFlash(void);
static ERROR_CODE EraseBlock(int nBlock, unsigned long ulAddr);
static ERROR_CODE GetCodes(int *pnManCode, int *pnDevCode, unsigned long ulAddr);
static ERROR_CODE GetSectorNumber(unsigned long ulAddr, int *pnSector);
static ERROR_CODE GetSectorStartEnd(unsigned long *ulStartOff, unsigned long *ulEndOff, int nSector);

ADI_DEV_PDD_ENTRY_POINT ADIMDR1636XEntryPoint =
{
	adi_pdd_Open,
	adi_pdd_Close,
	adi_pdd_Read,
	adi_pdd_Write,
	adi_pdd_Control
};

/**
 * @brief Opens the MDR1636x flash device for use
 * @param ManagerHandle Device manager handle
 * @param DeviceNumber Device number
 * @param DeviceHandle Device handle
 * @param PDDHandle This is the handle used to identify the device
 * @param Direction Data direction
 * @param pEnterCriticalArg Enter critical region parameter
 * @param DMAHandle Handle to the DMA manager
 * @param DCBHandle Callback handle
 * @param DMCallback Device manager callback function
 * @return Result
*/
static u32 adi_pdd_Open(
	ADI_DEV_MANAGER_HANDLE	ManagerHandle,
	u32 					DeviceNumber,
	ADI_DEV_DEVICE_HANDLE 	DeviceHandle,
	ADI_DEV_PDD_HANDLE 		*pPDDHandle,
	ADI_DEV_DIRECTION 		Direction,
	void					*pEnterCriticalArg,
	ADI_DMA_MANAGER_HANDLE	DMAHandle,
	ADI_DCB_HANDLE			DCBHandle,
	ADI_DCB_CALLBACK_FN		DMCallback)
{
	MDR1636_init(&driver_config, 0);
	MDR1636_reset();
	
	return (NO_ERR);
}


/**
 * @brief Closes the MDR1636x flash device.
 * @param PDDHandle This is the handle used to identify the device
 * @return Result
 */
static u32 adi_pdd_Close(
	ADI_DEV_PDD_HANDLE PDDHandle)
{
	return (NO_ERR);
}

/**
 * @brief Provides buffers to the MDR1636x flash device for reception of inbound data.
 * @param PDDHandle This is the handle used to identify the device
 * @param BufferType This argument identifies the type of buffer: one-dimentional, two-dimensional or circular
 * param pBuffer The is the address of the buffer or first buffer in a chain of buffers
 * @return Result
 */
static u32 adi_pdd_Read(
	ADI_DEV_PDD_HANDLE 	PDDHandle,
	ADI_DEV_BUFFER_TYPE BufferType,
	ADI_DEV_BUFFER		*pBuffer)
{

	ADI_DEV_1D_BUFFER *pBuff1D;
	unsigned long *pulAbsoluteAddr;
	u32 Result = NO_ERR;

	pBuff1D = (ADI_DEV_1D_BUFFER*)pBuffer;
	pulAbsoluteAddr = (unsigned long *)pBuff1D->pAdditionalInfo;
	
	if (MDR1636_read_data(*(uint32_t *)pulAbsoluteAddr, (uint32_t *)pBuff1D->Data, 1) != OpSuccess)
		Result = NOT_READ_ERROR;

	return Result;
}

/**
 * @brief Provides buffers to the MDR1636x flash device for transmission of outbound data.
 * @param PDDHandle This is the handle used to identify the device
 * @param BufferType This argument identifies the type of buffer: one-dimentional, two-dimensional or circular
 * @param pBuffer The is the address of the buffer or first buffer in a chain of buffers
 * @return Result
 */
static u32 adi_pdd_Write(
	ADI_DEV_PDD_HANDLE 	PDDHandle,
 	ADI_DEV_BUFFER_TYPE BufferType,
	ADI_DEV_BUFFER		*pBuffer)
{
	ADI_DEV_1D_BUFFER *pBuff1D;
	short *psValue;
	unsigned long *pulAbsoluteAddr;
	u32 Result = NO_ERR;
	
	pBuff1D = (ADI_DEV_1D_BUFFER*)pBuffer;
	psValue = (short *)pBuff1D->Data;
	pulAbsoluteAddr = (unsigned long *)pBuff1D->pAdditionalInfo;

	if (MDR1636_write_data(*(uint32_t *)pulAbsoluteAddr, (uint32_t *)psValue, 1) != OpSuccess)
		Result = PROCESS_COMMAND_ERR;

	return Result;
}

/**
 * @brief This function sets or detects a configuration parameter for the MDR1636x flash device.
 * @param PDDHandle This is the handle used to identify the device
 * @param Command This is the command identifier
 * @param pArg The is the address of command-specific parameter
 * @return Result
 */
u32 adi_pdd_Control(
	ADI_DEV_PDD_HANDLE 	PDDHandle,
	u32					Command,
	void				*pArg)
{

	ERROR_CODE ErrorCode = NO_ERR;
	COMMAND_STRUCT *pCmdStruct = (COMMAND_STRUCT *)pArg;

	switch (Command)
	{
		case CNTRL_ERASE_ALL:
			ErrorCode = EraseFlash();
			break;
		case CNTRL_ERASE_SECT:
			ErrorCode = EraseBlock( pCmdStruct->SEraseSect.nSectorNum, pCmdStruct->SEraseSect.ulFlashStartAddr );
			break;
		case CNTRL_GET_CODES:
			ErrorCode = GetCodes((int *)pCmdStruct->SGetCodes.pManCode, (int *)pCmdStruct->SGetCodes.pDevCode, (unsigned long)pCmdStruct->SGetCodes.ulFlashStartAddr);
			break;
		case CNTRL_GET_DESC:
			pCmdStruct->SGetDesc.pTitle = pTitle;
			pCmdStruct->SGetDesc.pDesc  = pDesc;
			pCmdStruct->SGetDesc.pFlashCompany  = pCompany;
			break;
		case CNTRL_GET_SECTNUM:
			ErrorCode = GetSectorNumber(pCmdStruct->SGetSectNum.ulOffset, (int *)pCmdStruct->SGetSectNum.pSectorNum);
			break;
		case CNTRL_GET_SECSTARTEND:
			ErrorCode = GetSectorStartEnd(pCmdStruct->SSectStartEnd.pStartOffset, pCmdStruct->SSectStartEnd.pEndOffset, pCmdStruct->SSectStartEnd.nSectorNum);
			break;
		case CNTRL_GETNUM_SECTORS:
			pCmdStruct->SGetNumSectors.pnNumSectors[0] = AFP_SECTOR_NUM;
			break;
		case CNTRL_RESET:
			ErrorCode = ResetFlash();
			break;
		default:
			ErrorCode = UNKNOWN_COMMAND;
			break;
	}

	return(ErrorCode);
}

/**
 * @brief Sends a "reset" command to the flash.
 * @return
 *	ERROR_CODE 	- 	value if any error occurs
 *	NO_ERR     	- 	otherwise
 */
static ERROR_CODE ResetFlash(void)
{
	if (MDR1636_reset() != OpSuccess)
		return PROCESS_COMMAND_ERR;
	
	return NO_ERR;
}

/**
 * @brief Sends an "erase all" command to the flash.
 * @return
 *	ERROR_CODE - value if any error occurs
 *	NO_ERR     - otherwise
 */
static ERROR_CODE EraseFlash(void)
{
	if (MDR1636_erase_chip() != OpSuccess)
		return PROCESS_COMMAND_ERR;
	
	return NO_ERR;
}

/**
 * @brief Sends an "erase block" command to the flash.
 * @param nBlock Block to erase
 * @param ulStartAddr Flash start address
 * @return
 *	ERROR_CODE - value if any error occurs
 *	NO_ERR     - otherwise
 */
static ERROR_CODE EraseBlock(int nBlock, unsigned long ulAddr)
{
	if (MDR1636_erase_sector(ulAddr) != OpSuccess)
		return PROCESS_COMMAND_ERR;
		
	return NO_ERR;
}

/**
 * @brief Sends an "auto select" command to the flash which will allow us to get the manufacturer and device codes.
 * @param pnManCode Pointer to manufacture code
 * @param pnDevCode Pointer to device code
 * @param ulStartAddr Flash start address
 * @return
 *	ERROR_CODE - value if any error occurs
 *	NO_ERR     - otherwise
 */
static ERROR_CODE GetCodes(int *pnManCode, int *pnDevCode, unsigned long ulAddr)
{
	MDR1636_read_info(0, (uint32_t *)pnManCode);
	MDR1636_read_info(1, (uint32_t *)pnDevCode);

	ResetFlash();

	return NO_ERR;
}

/**
 * @brief Gets a sector number based on the offset.
 * @param ulAddr Absolute address
 * @param pnSector Pointer to sector number
 * @return 
 *	ERROR_CODE - value if any error occurs
 *	NO_ERR     - otherwise
 */
static ERROR_CODE GetSectorNumber(unsigned long ulAddr, int *pnSector)
{
	*pnSector = ulAddr % AFP_SECTOR_SIZE;
	
	return NO_ERR;
}

/**
 * @brief Gets a sector start and end address based on the sector number.
 * @param ulStartOff Pointer to the start offset
 * @param ulEndOff Pointer to the end offset
 * @param nSector Sector number
 * @return 
 *	ERROR_CODE - value if any error occurs
 *	NO_ERR     - otherwise
 */
static ERROR_CODE GetSectorStartEnd(unsigned long *ulStartOff, unsigned long *ulEndOff, int nSector)
{
	if(nSector < AFP_SECTOR_NUM){
		*ulStartOff = AFP_SECTOR_SIZE * nSector;
		*ulEndOff = *ulStartOff + (AFP_SECTOR_SIZE - 1);
	} else {
		return INVALID_SECTOR;
	}

	return NO_ERR;
}

