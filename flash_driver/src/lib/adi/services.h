/*******************************************************************************/
/*                                                                             */
/*   (C) Copyright 2004 - Analog Devices, Inc.  All rights reserved.           */
/*                                                                             */
/*    FILE:     s e r v i c e s . h ( )                                        */
/*                                                                             */
/*    CHANGES:  1.00.0  - initial release    								   */
/*																			   */
/*    PURPOSE:  This header file defines the public name(functions and types)  */
/*              exported to replicate the system services module 	           */
/*              Driver Model supports does not support yet Frio core           */
/*                                                                             */
/*******************************************************************************/

#ifndef __SERVICES_H__
#define __SERVICES_H__

#ifndef TRUE
#define TRUE (1)
#endif

#ifndef FALSE
#define FALSE (0)
#endif

//---- c o n s t a n t   d e f i n i t i o n s -----//

typedef unsigned long  u32;


// Datatypes for handles into the device manager and device drivers

typedef void *ADI_DEV_MANAGER_HANDLE;		// Handle to a device manager
typedef void *ADI_DEV_DEVICE_HANDLE;		// Handle to a device driver
typedef void *ADI_DEV_PDD_HANDLE;			// Handle to a physical device (used by device manager only)
typedef void *ADI_DMA_MANAGER_HANDLE;		// DMA manager handle


// prototype for Client callback function

typedef void (*ADI_DCB_CALLBACK_FN) (void*, u32, void*);


// Handle to queue server and macros to give sizes of both queue server and entry

typedef void *ADI_DCB_HANDLE;


// Dataflow enumerations

typedef enum {							// Data direction
	ADI_DEV_DIRECTION_UNDEFINED,		// undefined
	ADI_DEV_DIRECTION_INBOUND,			// inbound (read)
	ADI_DEV_DIRECTION_OUTBOUND,			// outbound (write)
	ADI_DEV_DIRECTION_BIDIRECTIONAL,	// both (read and write)
} ADI_DEV_DIRECTION;


// Enumerations and structures for buffers

#define ADI_DEV_RESERVED_SIZE	(18)	// size in bytes of reserved field in DEV_BUFFER

typedef enum {							// Buffer types
	ADI_DEV_BUFFER_UNDEFINED,			// undefined
	ADI_DEV_1D,							// 1 dimensional buffer
	ADI_DEV_2D,							// 2 dimensional buffer
	ADI_DEV_CIRC, 						// circular buffer
	ADI_DEV_SEQ_1D,						// sequential 1 dimensional buffer
} ADI_DEV_BUFFER_TYPE;

typedef struct adi_dev_1d_buffer {									// 1D ("normal") buffer
	char 		 				Reserved[ADI_DEV_RESERVED_SIZE];	// reserved for physical device driver use
	void 						*Data;								// pointer to data
	u32							ElementCount;						// data element count
	u32							ElementWidth;						// data element width (in bytes)
	void 						*CallbackParameter;					// callback flag/pArg value
	volatile u32 				ProcessedFlag;						// processed flag
	u32			 				ProcessedElementCount;				// # of bytes read in/out
	struct adi_dev_1d_buffer	*pNext;								// next buffer
	void 						*pAdditionalInfo;					// device specific pointer to additional info
} ADI_DEV_1D_BUFFER;

typedef union {							// union of buffer types
	ADI_DEV_1D_BUFFER		OneD;		// 1D buffer

} ADI_DEV_BUFFER;


/*********************************************************************

Physical driver entry point

*********************************************************************/


typedef struct {									// Entry point to the physical driver
	u32 (*adi_pdd_Open)(							// Open a device
		ADI_DEV_MANAGER_HANDLE	ManagerHandle,		// device manager handle
		u32						DevNumber,			// device number
		ADI_DEV_DEVICE_HANDLE 	DeviceHandle,		// DM handle
		ADI_DEV_PDD_HANDLE		*pPDDHandle,		// pointer to PDD handle location
		ADI_DEV_DIRECTION 		Direction,			// data direction
		void					*pCriticalRegionArg,// critical region parameter
		ADI_DMA_MANAGER_HANDLE	DMAHandle,			// handle to the DMA manager
		ADI_DCB_HANDLE			DCBHandle,			// callback handle
		ADI_DCB_CALLBACK_FN		DMCallback			// device manager callback function
	);
	u32 (*adi_pdd_Close)(							// Closes a device
		ADI_DEV_PDD_HANDLE 	PDDHandle				// PDD handle
	);
	u32 (*adi_pdd_Read)(							// Reads data or queues an inbound buffer to a device
		ADI_DEV_PDD_HANDLE	PDDHandle,				// PDD handle
		ADI_DEV_BUFFER_TYPE	BufferType,				// buffer type
		ADI_DEV_BUFFER 		*pBuffer				// pointer to buffer
	);
	u32 (*adi_pdd_Write)(							// Writes data or queues an outbound buffer to a device
		ADI_DEV_PDD_HANDLE	PDDHandle,				// PDD handle
		ADI_DEV_BUFFER_TYPE	BufferType,				// buffer type
		ADI_DEV_BUFFER		*pBuffer				// pointer to buffer
	);
	u32 (*adi_pdd_Control)(							// Sets or senses a device specific parameter
		ADI_DEV_PDD_HANDLE	PDDHandle,				// PDD handle
		u32					Command,				// command ID
		void				*Value					// command specific value
	);
	u32 (*adi_pdd_SequentialIO)(					// Sequentially reads/writes data to a device
		ADI_DEV_PDD_HANDLE	PDDHandle,				// PDD handle
		ADI_DEV_BUFFER_TYPE	BufferType,				// buffer type
		ADI_DEV_BUFFER 		*pBuffer				// pointer to buffer
	);
} ADI_DEV_PDD_ENTRY_POINT;


 #endif	// __ADI_SERVICES_H__

