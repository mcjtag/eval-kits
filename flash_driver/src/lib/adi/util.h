/*******************************************************************************/
/*                                                                             */
/*   (C) Copyright 2004 - Analog Devices, Inc.  All rights reserved.           */
/*                                                                             */
/*    FILE:     u t i l . h ( )        					                       */
/*                                                                             */
/*    CHANGES:  1.00.0  - initial release    								   */
/*																			   */
/*    PURPOSE:  This header file defines the devices commands				   */
/*                                                                             */
/*******************************************************************************/

#ifndef __UTIL_H__
#define __UTIL_H__

#include <adi_flash.h>	//flash driver includes

//---- c o n s t a n t   d e f i n i t i o n s -----//

// enum for adi_pdd_control
typedef enum
{
	CNTRL_GET_CODES,		// 1
	CNTRL_RESET,			// 2	
	CNTRL_ERASE_ALL,		// 3
	CNTRL_ERASE_SECT,		// 4
	CNTRL_GET_SECTNUM,		// 5
	CNTRL_GET_SECSTARTEND,	// 6
	CNTRL_GET_DESC,			// 7
	CNTRL_GETNUM_SECTORS	// 8
}enCntrlCmds;


 #endif	// __ADI_UTIL_H__

