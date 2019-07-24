/*******************************************************************************/
/*                                                                             */
/*   (C) Copyright 2004 - Analog Devices, Inc.  All rights reserved.           */
/*                                                                             */
/*    FILE:     a d i _ f l a s h . h ( )     					               */
/*                                                                             */
/*    CHANGES:  1.00.0  - initial release    								   */
/*																			   */
/*    PURPOSE:  This header file defines the devices commands				   */
/*                                                                             */
/*******************************************************************************/

#ifndef __ADI_FLASH_H__
#define __ADI_FLASH_H__

//---- c o n s t a n t   d e f i n i t i o n s -----//

// 0x01: Get-Codes data type
typedef struct Get_Codes_Struct
{
	unsigned long	*pManCode;
	unsigned long	*pDevCode;
	unsigned long 	ulFlashStartAddr;

}GET_CODES_STRUCT;

// 0x02: Reset data type
typedef struct Reset_Struct
{
 	unsigned long 	ulFlashStartAddr;

}RESET_STRUCT;

// 0x03: Erase-All data type
typedef struct Erase_All_Struct
{
 	unsigned long 	ulFlashStartAddr;

}ERASE_ALL_STRUCT;

// 0x04: Erase-Sector data type
typedef struct Erase_Sector_Struct
{
 	int 			nSectorNum;
 	unsigned long 	ulFlashStartAddr;

}ERASE_SECTOR_STRUCT;


// 0x05: Get-Sector-Number data type
typedef struct Get_SectNum_Struct
{
	unsigned long	ulOffset;
	unsigned long	*pSectorNum;

}GET_SECTNUM_STRUCT;

// 0x06: Get-Sector-Start-End data type
typedef struct Get_SectStartEnd_Struct
{
	int 	nSectorNum;
	unsigned long	*pStartOffset;
	unsigned long	*pEndOffset;

}GET_SECTSTARTEND_STRUCT;

// 0x07: Get-Description data type
typedef struct Get_Desc_Struct
{
	char	*pTitle;
	char	*pDesc;
	char 	*pFlashCompany;

}GET_DESC_STRUCT;

// 0x08: Get-Num Sectors data type
typedef struct Get_NumSectors_Struct
{
	int		*pnNumSectors;

}GET_NUM_SECTORS_STRUCT;

//Union describing all the data types
typedef union
{
	ERASE_ALL_STRUCT		SEraseAll;
	ERASE_SECTOR_STRUCT		SEraseSect;
	GET_CODES_STRUCT		SGetCodes;
	GET_DESC_STRUCT			SGetDesc;
	GET_SECTNUM_STRUCT		SGetSectNum;
	GET_SECTSTARTEND_STRUCT SSectStartEnd;
	RESET_STRUCT			SReset;
	GET_NUM_SECTORS_STRUCT	SGetNumSectors;
}COMMAND_STRUCT;


#endif	// __ADI_ADI_FLASH_H__

