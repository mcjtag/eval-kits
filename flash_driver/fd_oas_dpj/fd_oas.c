/**
 * @file main.c
 * @brief Flash Driver (OAS)
 * @author matyunin.d
 * @date 19.07.2019
 */
 
#include <stdlib.h>				// malloc includes
#include <signal.h>
#include <defts201.h>
#include <sysreg.h>
#include "adi_mdr1636x.h"		// flash-MDR1636x includes
#include "services.h"			// system services buffers
#include "util.h" 				// library struct includes
#include "Errors.h"				// error type includes
#include "cpu.h"

#define BUFFER_SIZE				0x600

typedef enum {
	NO_COMMAND,		// 0
	GET_CODES,		// 1
	RESET,			// 2
	WRITE,			// 3
	FILL,			// 4
	ERASE_ALL,		// 5
	ERASE_SECT,		// 6
	READ,			// 7
	GET_SECTNUM,	// 8
	GET_SECSTARTEND,// 9
} enProgCmds;

typedef struct _SECTORLOCATION
{
 	unsigned long ulStartOff;
	unsigned long ulEndOff;
} SECTORLOCATION;

char 			*AFP_Title ;						 // Flash Programmer
char 			*AFP_Description;					 // Flash Description: Milandr MDR1636x
char			*AFP_DeviceCompany;					 // Flash Company
char 			*AFP_DrvVersion		= "1.00.0";		 // Driver Version
char			*AFP_BuildDate		= __DATE__;		 // Driver Build Date
enProgCmds 		AFP_Command 		= NO_COMMAND;	 // command sent down from the GUI
int 			AFP_ManCode 		= -1;			 // 0x01 = Milandr
int 			AFP_DevCode 		= -1;			 // 0xC8 = MDR1636x
unsigned long 	AFP_Offset 			= 0x0;			 // offset into flash
int 			*AFP_Buffer;						 // buffer used to read and write flash
long 			AFP_Size 			= BUFFER_SIZE;	 // buffer size
long 			AFP_Count 			= -1;			 // count of locations to be read or written
long 			AFP_Stride 			= -1;			 // stride used when reading or writing
int 			AFP_NumSectors 		= AFP_SECTOR_NUM;// number of sectors in the flash device
int 			AFP_Sector 			= -1;			 // sector number
int 			AFP_Error 			= 0;			 // contains last error encountered
bool 			AFP_Verify 			= FALSE;		 // verify writes or not
unsigned long 	AFP_StartOff 		= 0x0;			 // sector start offset
unsigned long 	AFP_EndOff 			= 0x0;			 // sector end offset
int				AFP_FlashWidth		= 0x10;			 // width of the flash device
int 			*AFP_SectorInfo;
bool			AFP_ASCIIFormat		= 0x0;			 // flag used to tell us if the user has selected ASCII

static bool bExit = FALSE; 							 //exit flag
 
SECTORLOCATION SectorInfo[AFP_SECTOR_NUM];

static void init(void);
static ERROR_CODE AllocateAFPBuffer(void);
static ERROR_CODE GetSectorMap(void);
static ERROR_CODE GetFlashInfo(void);
static ERROR_CODE ProcessCommand(void);
static ERROR_CODE SetupForFlash(void);
static ERROR_CODE FillData(unsigned long ulStart, long lCount, long lStride, int *pnData);
static ERROR_CODE ReadData(unsigned long ulStart, long lCount, long lStride, int *pnData);
static ERROR_CODE WriteData(unsigned long ulStart, long lCount, long lStride, int *pnData);
static void FreeAFPBuffer(void);
static void ByteSwapBuffer( int *pnData, long lCount);

/**
 * @brief Main function
 * @return
 *	TRUE
 *	FALSE
 */
int main(void)
{
	AFP_Error = ADIMDR1636XEntryPoint.adi_pdd_Open(NULL, 0, NULL, NULL, ADI_DEV_DIRECTION_BIDIRECTIONAL, NULL, NULL, NULL, NULL);
	init();

	if ((AFP_Error = AllocateAFPBuffer()) != NO_ERR)
		return FALSE;

	if ((AFP_Error = GetSectorMap())!= NO_ERR)
		return FALSE;

	if ((AFP_Error = GetFlashInfo()) != NO_ERR)
		return FALSE;

	while (!bExit) {
		asm("AFP_BreakReady:");
 		if (FALSE) {
			asm("nop;nop;nop;nop;;");
			asm("jump AFP_BreakReady;;");
 		}

	   AFP_Error = ProcessCommand();
	}
	
	FreeAFPBuffer();
	AFP_Error = ADIMDR1636XEntryPoint.adi_pdd_Close(NULL);

	return TRUE;
}

/**
 * @brief System initialization
 * @return void
 */
static void init(void)
{
	uint32_t temp32u;

	/* Initial setup */
	__builtin_sysreg_write(__INTCTL, 0);
	__builtin_sysreg_write(__IMASKH, 0);
	__builtin_sysreg_write(__IMASKL, 0);
	__builtin_sysreg_write(__SQCTLST, SQCTL_NMOD);
	__ASM(rds;);

	/* Configure syscon register */
	temp32u = 	SYSCON_MS0_IDLE		|
  				SYSCON_MS0_WT3		|
  				SYSCON_MS0_PIPE1	|
  				SYSCON_MS0_SLOW		|
 				SYSCON_MS1_IDLE		|
  				SYSCON_MS1_WT0		|
  				SYSCON_MS1_PIPE2	|
  				SYSCON_MEM_WID64	|
  				SYSCON_MP_WID64		|
  				SYSCON_HOST_WID64	|
  				0x00;;
  	__builtin_sysreg_write(__SYSCON, temp32u);

  	/* Enable BTB */
	__ASM(btben;);
	__ASM(nop;);

	/* GPIO setup (general) */
	LX_PortA->ddr.reg 	= 0;
	LX_PortA->port.reg 	= 0;
	LX_PortA->alt.reg 	= 0;
	LX_PortA->pu.reg 	= 0;	// 0 - enable
	LX_PortB->ddr.reg 	= 0;
	LX_PortB->port.reg 	= 0;
	LX_PortB->alt.reg 	= 0;
	LX_PortB->pu.reg 	= 0;	// 0 - enable

	/* External bus signals */
	/* Control */
	LX_PortC->ddr.reg 	= 0;
	LX_PortC->port.reg 	= 0;
	LX_PortC->alt.reg = (1<<19) | (1<<20) | (1<<21) | (1<<22); 	// nMS0, nBMS, nRD, nWR
	LX_PortC->pu.reg 	= 0;	// 0 - enable

	// Address and data bus
	LX_PortX->px_alt = 	PX_ALT_PDB0 | PX_ALT_PDB1 | PX_ALT_PDB2 | PX_ALT_PDB3 |		// DATA: 32 bit
						PX_ALT_PAB0 | PX_ALT_PAB1 | PX_ALT_PAB2;
	LX_PortX->pxd_pu = 0;		// 0 - enable
}

/**
 * @brief Process each command sent by the GUI based on the value in the AFP_Command.
 * @return 
 *	ERROR_CODE - value if any error occurs during Opcode scan
 *	NO_ERR     - otherwise
 */
static ERROR_CODE ProcessCommand(void)
{
	ERROR_CODE ErrorCode = 	NO_ERR;
	COMMAND_STRUCT CmdStruct;

	switch (AFP_Command)
	{
		case ERASE_ALL:
			ErrorCode = (ERROR_CODE)ADIMDR1636XEntryPoint.adi_pdd_Control(NULL, CNTRL_ERASE_ALL, &CmdStruct);
			break;
		case ERASE_SECT:
			CmdStruct.SEraseSect.nSectorNum = AFP_Sector;
			ErrorCode = (ERROR_CODE)ADIMDR1636XEntryPoint.adi_pdd_Control(NULL, CNTRL_ERASE_SECT, &CmdStruct);
			break;
		case FILL:
			ErrorCode = FillData(AFP_Offset, AFP_Count, AFP_Stride, AFP_Buffer);
			break;
		case GET_CODES:
			CmdStruct.SGetCodes.pManCode = (unsigned long *)&AFP_ManCode;
			CmdStruct.SGetCodes.pDevCode = (unsigned long *)&AFP_DevCode;
			ErrorCode = (ERROR_CODE)ADIMDR1636XEntryPoint.adi_pdd_Control(NULL, CNTRL_GET_CODES, &CmdStruct);
			break;
		case GET_SECTNUM:
			CmdStruct.SGetSectNum.ulOffset = AFP_Offset;
			CmdStruct.SGetSectNum.pSectorNum = (unsigned long *)&AFP_Sector;
			ErrorCode = (ERROR_CODE)ADIMDR1636XEntryPoint.adi_pdd_Control(NULL, CNTRL_GET_SECTNUM, &CmdStruct);
			break;
		case GET_SECSTARTEND:
			CmdStruct.SSectStartEnd.nSectorNum = AFP_Sector;
			CmdStruct.SSectStartEnd.pStartOffset = &AFP_StartOff;
			CmdStruct.SSectStartEnd.pEndOffset = &AFP_EndOff;
			ErrorCode = (ERROR_CODE)ADIMDR1636XEntryPoint.adi_pdd_Control(NULL, CNTRL_GET_SECSTARTEND, &CmdStruct );
			break;
		case READ:
			ErrorCode = ReadData(AFP_Offset, AFP_Count, AFP_Stride, AFP_Buffer);
			break;
		case RESET:
			ErrorCode = (ERROR_CODE)ADIMDR1636XEntryPoint.adi_pdd_Control(NULL, CNTRL_RESET, &CmdStruct);
			break;
		case WRITE:
			ErrorCode = WriteData(AFP_Offset, AFP_Count, AFP_Stride, AFP_Buffer);
			break;
		case NO_COMMAND:
		default:
			ErrorCode = UNKNOWN_COMMAND;
			break;
	}
	AFP_Command = NO_COMMAND;

	return(ErrorCode);
}

/**
 * @brief Allocate memory for the AFP_Buffer
 * @return 
 *	ERROR_CODE - value if any error occurs
 *	NO_ERR     - otherwise
 */
static ERROR_CODE AllocateAFPBuffer(void)
{
	ERROR_CODE ErrorCode = NO_ERR;
	AFP_Buffer = (int *)malloc(BUFFER_SIZE);

	if (AFP_Buffer == NULL)	{
		ErrorCode = BUFFER_IS_NULL;
	}

	return(ErrorCode);
}

/**
 * @brief Free the AFP_Buffer
 * @return 
 *	ERROR_CODE - value if any error occurs
 *	NO_ERR     - otherwise
 */
void FreeAFPBuffer(void)
{
	if (AFP_Buffer)
		free(AFP_Buffer);
}

/**
 * @brief Get the start and end offset for each sector in the flash.
 * @return
 *	ERROR_CODE - value if any error occurs
 *	NO_ERR     - otherwise
 */
static ERROR_CODE GetSectorMap(void)
{
	ERROR_CODE ErrorCode = NO_ERR;
	GET_SECTSTARTEND_STRUCT	SSectStartEnd;
	int i;

	for(i=0; i<AFP_NumSectors; i++) {
		SSectStartEnd.nSectorNum = i;
		SSectStartEnd.pStartOffset = &SectorInfo[i].ulStartOff;
		SSectStartEnd.pEndOffset = &SectorInfo[i].ulEndOff;
		ErrorCode = (ERROR_CODE)ADIMDR1636XEntryPoint.adi_pdd_Control(NULL, CNTRL_GET_SECSTARTEND, (COMMAND_STRUCT *)&SSectStartEnd);
	}

	AFP_SectorInfo = (int*)&SectorInfo[0];

	return(ErrorCode);
}

/**
 * @brief Get the manufacturer code and device code
 * @return
 *	ERROR_CODE - value if any error occurs
 *	NO_ERR     - otherwise
 */
static ERROR_CODE GetFlashInfo(void)
{
	ERROR_CODE ErrorCode = NO_ERR;
	static GET_CODES_STRUCT  SGetCodes;
	COMMAND_STRUCT CmdStruct;

	//setup code so that flash programmer can just read memory instead of call GetCodes().
	CmdStruct.SGetCodes.pManCode = (unsigned long *)&AFP_ManCode;
	CmdStruct.SGetCodes.pDevCode = (unsigned long *)&AFP_DevCode;

	AFP_Error = ADIMDR1636XEntryPoint.adi_pdd_Control(NULL, CNTRL_GET_CODES, &CmdStruct);
	AFP_Error = ADIMDR1636XEntryPoint.adi_pdd_Control(NULL, CNTRL_GET_DESC, &CmdStruct);
	AFP_Title = CmdStruct.SGetDesc.pTitle;
	AFP_Description = CmdStruct.SGetDesc.pDesc;
	AFP_DeviceCompany = CmdStruct.SGetDesc.pFlashCompany;

	return(ErrorCode);
}

/**
 * @brief Fill flash device with a value.
 * @param ulStart Address in flash to start the writes at
 * @param lCount Number of elements to write, in this case bytes
 * @param lStride Number of locations to skip between writes
 * @param pnData Pointer to data buffer
 * @return 
 *	ERROR_CODE - value if any error occurs during fill
 *	NO_ERR     - otherwise
 */
static ERROR_CODE FillData(unsigned long ulStart, long lCount, long lStride, int *pnData)
{
	long i = 0;	
	unsigned long ulOffset = ulStart;
	ERROR_CODE ErrorCode = NO_ERR;
	int nCompare = 0;
	bool bVerifyError = FALSE;

	ADI_DEV_1D_BUFFER WriteBuff;
	ADI_DEV_1D_BUFFER ReadBuff;
	
	if(AFP_Verify == TRUE) {
		for (i = 0; (i < lCount) && ( ErrorCode == NO_ERR ); i++, ulOffset += lStride) {
			WriteBuff.Data = (void *)&pnData[0];
			WriteBuff.pAdditionalInfo = (void *)&ulOffset;
			ErrorCode = (ERROR_CODE) ADIMDR1636XEntryPoint.adi_pdd_Write(NULL, ADI_DEV_1D, (ADI_DEV_BUFFER *)&WriteBuff);

			ReadBuff.Data = (void *)&nCompare;
			ReadBuff.pAdditionalInfo = (void *)&ulOffset ;
			ErrorCode = (ERROR_CODE) ADIMDR1636XEntryPoint.adi_pdd_Read(NULL, ADI_DEV_1D, (ADI_DEV_BUFFER *)&ReadBuff);
		}
		
		if(bVerifyError == TRUE)
			return VERIFY_WRITE;
	} else {
		for (i = 0; (i < lCount) && (ErrorCode == NO_ERR); i++, ulOffset += lStride) {
			WriteBuff.Data = (void *)&pnData[0];
			WriteBuff.pAdditionalInfo = (void *)&ulStart;
			ErrorCode = (ERROR_CODE) ADIMDR1636XEntryPoint.adi_pdd_Write(NULL, ADI_DEV_1D, (ADI_DEV_BUFFER *)&WriteBuff);
		}
	}

	return ErrorCode;
}

/**
 * @brief Write a buffer to flash device.
 * @param ulStart Address in flash to start the writes at
 * @param lCount Number of elements to write, in this case bytes
 * @param lStride Number of locations to skip between writes
 * @param pnData Pointer to data buffer
 * @return
 *	ERROR_CODE - value if any error occurs during writing
 *	NO_ERR     - otherwise
 */
static ERROR_CODE WriteData(unsigned long ulStart, long lCount, long lStride, int *pnData)
{
	long i = 0;
	unsigned long ulOffset = ulStart;
	ERROR_CODE ErrorCode = NO_ERR;
	int nCompare = 0;
	bool bVerifyError = FALSE;

	ADI_DEV_1D_BUFFER WriteBuff;
	ADI_DEV_1D_BUFFER ReadBuff;

	if (AFP_ASCIIFormat == TRUE) {
		ByteSwapBuffer(pnData, lCount);
	}
	
	if (AFP_Verify == TRUE) {
		for (i = 0; (i < lCount) && (ErrorCode == NO_ERR); i++, ulOffset += lStride) {
			WriteBuff.Data = (void *)&pnData[i];
			WriteBuff.pAdditionalInfo = (void *)&ulOffset ;
			ErrorCode = (ERROR_CODE) ADIMDR1636XEntryPoint.adi_pdd_Write(NULL, ADI_DEV_1D, (ADI_DEV_BUFFER *)&WriteBuff);
			ReadBuff.Data = (void *)&nCompare;
			ReadBuff.pAdditionalInfo = (void *)&ulOffset ;
			ErrorCode = (ERROR_CODE) ADIMDR1636XEntryPoint.adi_pdd_Read(NULL, ADI_DEV_1D, (ADI_DEV_BUFFER *)&ReadBuff);
		}

		if(bVerifyError == TRUE)
			return VERIFY_WRITE;
	} else {
		for (i = 0; (i < lCount) && (ErrorCode == NO_ERR); i++, ulOffset += lStride) {
			WriteBuff.Data = (void *)&pnData[i];
			WriteBuff.pAdditionalInfo = (void *)&ulOffset ;
			ErrorCode = (ERROR_CODE) ADIMDR1636XEntryPoint.adi_pdd_Write(NULL, ADI_DEV_1D, (ADI_DEV_BUFFER *)&WriteBuff);	
		}
	}

	return ErrorCode;
}

/**
 * @brief Read a buffer from flash device.
 * @param ulStart Address in flash to start the reads at
 * @param lCount Number of elements to read, in this case bytes
 * @param lStride Number of locations to skip between reads
 * @param pnData Pointer to data buffer to fill
 * @return
 *	ERROR_CODE - value if any error occurs during reading
 *	NO_ERR     - otherwise
 */
static ERROR_CODE ReadData(unsigned long ulStart, long lCount, long lStride, int *pnData)
{
	long i = 0;	
	unsigned long ulOffset = ulStart;
	ERROR_CODE ErrorCode = NO_ERR;
	ADI_DEV_1D_BUFFER ReadBuff;

	for (i = 0; (i < lCount) && (i < BUFFER_SIZE); i++, ulOffset += lStride) {
		ReadBuff.Data = (void *)&pnData[i];
		ReadBuff.pAdditionalInfo = (void *)&ulOffset ;
		ErrorCode = (ERROR_CODE)ADIMDR1636XEntryPoint.adi_pdd_Read(NULL, ADI_DEV_1D, (ADI_DEV_BUFFER *)&ReadBuff);
	}

	if (AFP_ASCIIFormat == TRUE) {
		ByteSwapBuffer(pnData, lCount);
	}
	
	return ErrorCode;
}

/**
 * @brief Swaps buffer bytes
 * @param pnData Pointer to data
 * @param lCount Number of elements
 * @return void 
 */
void ByteSwapBuffer(int *pnData, long lCount)
{
	int *tempbuf = (int *)pnData;
	int temp;
	long lIndex = 0;
	
	for(lIndex = 0; lIndex < lCount; lIndex+=4) {
		temp = tempbuf[lIndex];
		tempbuf[lIndex] = tempbuf[lIndex+3];
		tempbuf[lIndex+3] = temp;
		temp = tempbuf[lIndex+1];
		tempbuf[lIndex+1] = tempbuf[lIndex+2];
		tempbuf[lIndex+2] = temp;
	}	
}
