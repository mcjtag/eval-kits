/*******************************************************************************/
/*                                                                             */
/*   (C) Copyright 2004 - Analog Devices, Inc.  All rights reserved.           */
/*                                                                             */
/*    FILE:     e r r o r s . h ( )        					                   */
/*                                                                             */
/*    CHANGES:  1.00.0  - initial release    								   */
/*																			   */
/*    PURPOSE:  This header file defines the possible errors				   */
/*                                                                             */
/*******************************************************************************/

#ifndef __ERRORS_H__
#define __ERRORS_H__

#if defined(ADI_FLASH_DRIVER_RELEASE_BUILD)
#warning "Flash Driver may not work in the Release build"
#endif

// enum of possible errors
typedef enum
{
	NO_ERR,					// No Error
	POLL_TIMEOUT,			// Polling toggle bit failed
	VERIFY_WRITE,			// Verifying write to flash failed
	INVALID_SECTOR,			// Invalid Sector
	INVALID_BLOCK,			// Invalid Block
	UNKNOWN_COMMAND,		// Unknown Command
	PROCESS_COMMAND_ERR,	// Processing command
	NOT_READ_ERROR,			// Could not read memory from target
	DRV_NOTAT_BREAK,		// The drive was not at AFP_BreakReady
	BUFFER_IS_NULL,			// Could not allocate storage for the buffer
	NUM_ERROR_CODES,
}ERROR_CODE;

#endif // __ERRORS_H__
