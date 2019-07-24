

#include "cpu.h"
#include "hal_dma.h"

#include "MDR1636x_bus.h"
#include "MDR1636x_bus_private.h"


static __builtin_quad qw_dcs_write, qw_dcd_write;
static __builtin_quad qw_dcs_read, qw_dcd_read;
static uint32_t wr_data32;
static uint32_t rd_data32;

static flash_drv_config_t *config;


//-----------------------------------------------------------------//
//	Write a byte to FLASH
//
//	Arguments:
//		address - byte address
//		data - data to write
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
static uint32_t MDR1636_write_byte(uint32_t address, uint32_t data)
{
	uint32_t op_result;
	wr_data32 = data;
	*(uint32_t*)&qw_dcd_write = address;
	HAL_DMA_WriteDCS(0, &qw_dcs_write);
	HAL_DMA_WriteDCD(0, &qw_dcd_write);
	if (HAL_DMA_WaitForChannel(0) == 0)
	{
		op_result = OpSuccess;
	}
	else
	{
		HAL_DMA_Stop(0);
		op_result = OpFrwError;
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Read a 32 - bit word from FLASH
//
//	Arguments:
//		address - byte address
//		*data - pointer to variable to store result
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
static uint32_t MDR1636_read_word(uint32_t address, uint32_t *data)
{
	uint32_t op_result;
	*(uint32_t*)&qw_dcs_read = address;
	HAL_DMA_WriteDCS(0, &qw_dcs_read);
	HAL_DMA_WriteDCD(0, &qw_dcd_read);
	if (HAL_DMA_WaitForChannel(0) == 0)
	{
		*data = rd_data32;
		op_result = OpSuccess;
	}
	else
	{
		op_result = OpFrwError;
	}
	return op_result;
}

//-----------------------------------------------------------------//
//	Initialize FLASH driver
//
//	Arguments:
//		none
//	Return:
//		OpSuccess
//-----------------------------------------------------------------//
uint32_t MDR1636_init(flash_drv_config_t *drv_config, void *hw_config)
{
	uint32_t *ptr;
	
	config = drv_config;
	
	ptr = (uint32_t *)&qw_dcs_read;
	*(ptr + 0) = 0;
	*(ptr + 1) = (1<<16) | 0;
	*(ptr + 2) = 0;
	*(ptr + 3) = TCB_EPROM | TCB_NORMAL;
	
	ptr = (uint32_t *)&qw_dcd_read;
	*(ptr + 0) = (uint32_t)&rd_data32;
	*(ptr + 1) = (1<<16) | 0;
	*(ptr + 2) = 0;
	*(ptr + 3) = TCB_INTMEM | TCB_NORMAL;
	
	ptr = (uint32_t *)&qw_dcs_write;
	*(ptr + 0) = (uint32_t)&wr_data32;
	*(ptr + 1) = (1<<16) | 0;
	*(ptr + 2) = 0;
	*(ptr + 3) = TCB_INTMEM | TCB_NORMAL;
	
	ptr = (uint32_t *)&qw_dcd_write;
	*(ptr + 0) = 0;
	*(ptr + 1) = (1<<16) | 0;
	*(ptr + 2) = 0;
	*(ptr + 3) = TCB_EPROM | TCB_NORMAL;
	
	HAL_DMA_Stop(0);
	HAL_DMA_GetChannelStatusClear(0);
	
	return OpSuccess;
}


//-----------------------------------------------------------------//
//	Reset FLASH device
//
//	Arguments:
//		none
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_reset(void)
{
	uint32_t op_result;
	op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_X00, MDR1636_BUS_CODE_F0);
	return op_result;
}


//-----------------------------------------------------------------//
//	Get FLASH device status
//
//	Arguments:
//		*status - pointer to a variable to store device status
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_get_status(uint32_t *status)
{
	uint32_t op_result = OpSuccess;
	uint32_t dev_status = FS_Error;
	uint32_t w0, w1;
	uint32_t exit = 0;
	
	while(!exit)
	{
		// Read four bytes
		op_result = MDR1636_read_word(0x00, &w0);
		if (op_result != OpSuccess)	break;
	
		op_result = MDR1636_read_word(0x01, &w1);
		if (op_result != OpSuccess)	break;
	
		// Check if bit 6 is toggling
		if (((w0 >> 8) ^ w1) & 0x40)
		{
			// Toggling - additional check is required
			// Check bit 5
			if (w1 & 0x20)
			{
				// Bit 5 is set
				// Check bit 6 once more
				op_result = MDR1636_read_word(0x00, &w0);
				if (op_result != OpSuccess)	break;

				op_result = MDR1636_read_word(0x01, &w1);
				if (op_result != OpSuccess)	break;
							
				if (((w0 >> 8) ^ w1) & 0x40)
				{
					// Toggling - error (timeout or write data error depending on last operation)
					dev_status = FS_Error;
					// Reset device
					op_result = MDR1636_reset();
				}
				else
				{
					// Not toggling - ready
					dev_status = FS_Ready;
				}
			}
			else
			{
				// Bit 5 is cleared - busy
				dev_status = FS_Busy;	
			}
		}
		else
		{
			// Not toggling - ready
			dev_status = FS_Ready;
		}
	
		exit = 1;
	}
	*status = dev_status;
	return op_result;
}


//-----------------------------------------------------------------//
//	Wait until FLASH device operation is completed (sync)
//
//	Arguments:
//		none
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_wait_device(void)
{
	uint32_t op_result;
	uint32_t dev_status;
	do {
		op_result = MDR1636_get_status(&dev_status);
	} while ((op_result == OpSuccess) && (dev_status == FS_Busy));
	if (op_result == OpSuccess)
	{
		if (dev_status != FS_Ready)
		{
			op_result = OpDevError;	
		}
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Read info
//
//	Arguments:
//		param - identifier (address) of the info
//		*data - pointer to a variable to store device-specific info byte
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_read_info(uint32_t param, uint32_t *data)
{
	uint32_t op_result = OpSuccess;
	uint32_t exit = 0;
	while(!exit)
	{
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_AA);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_2AA, MDR1636_BUS_CODE_55);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_90);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_read_word(param, data);
		if (op_result != OpSuccess)	break;
		*data &= 0x000000FF;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_X00, MDR1636_BUS_CODE_F0);
		exit = 1;
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Get sector protection status
//
//	Arguments:
//		sa - address wtihin required sector
//		*value - pointer to a variable to store result
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_get_sector_protection(uint32_t sa, uint32_t *value)
{
	uint32_t op_result;
	uint32_t temp32u;
	op_result = MDR1636_read_info((sa & 0xFFFF0000) | 0x2, &temp32u);
	if (op_result == OpSuccess)
	{
		if (temp32u == 0x00)
			*value = FP_Unprotected;
		else
			*value = FP_Protected;
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Get chip protection status
//
//	Arguments:
//		*value - pointer to a variable to store result
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_get_chip_protection(uint32_t *value)
{
	uint32_t temp32u;
	uint32_t i;
	uint32_t sa;
	uint32_t op_result;
	uint32_t protected_count = 0;
	
	for(i=0; i<config->sector_count; i++)
	{
		sa = config->sector_size * i;
		op_result = MDR1636_get_sector_protection(sa, &temp32u);
		if (op_result != OpSuccess)	
			break;
		if (temp32u != FP_Unprotected)
			protected_count++;
	}
	
	if (op_result == OpSuccess)
	{
		if (protected_count == 0)
			*value = FP_Unprotected;
		else if (protected_count == config->sector_count)
			*value = FP_Protected;
		else
			*value = FP_ProtectedPart;
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Set sector protection
//
//	Arguments:
//		sa - address wtihin required sector
//		new_value - new protection status
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_set_sector_protection(uint32_t sa, uint32_t new_value)
{
	uint32_t op_result;
	uint32_t temp32u;
	
	// Validate argument
	new_value = (new_value == FP_Unprotected) ? FP_Unprotected : FP_Protected;
	
	// Check current state
	op_result = MDR1636_get_sector_protection(sa, &temp32u);
	if (op_result == OpSuccess)
	{
		if (temp32u != new_value)
		{
			// Cannot set or remove protection
			op_result = OpFrwError;
		}
		else
		{
			// Match
			op_result = OpSuccess;	
		}
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Set chip protection
//
//	Arguments:
//		new_value - new protection status
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_SPI_set_chip_protection(uint32_t new_value)
{
	uint32_t op_result;
	uint32_t temp32u;
	
	// Validate argument
	new_value = (new_value == FP_Unprotected) ? FP_Unprotected : FP_Protected;
	
	// Check current state
	op_result = MDR1636_get_chip_protection(&temp32u);
	if (op_result == OpSuccess)
	{
		if (temp32u != new_value)
		{
			// Cannot set or remove protection
			op_result = OpFrwError;
		}
		else
		{
			// Match
			op_result = OpSuccess;	
		}
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Start FLASH erase operation (async)
//	Status should be checked to determine erase completition
//
//	Arguments:
//		none
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_start_erase_chip(void)
{
	uint32_t op_result = OpSuccess;
	uint32_t exit = 0;
	while(!exit)
	{
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_AA);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_2AA, MDR1636_BUS_CODE_55);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_80);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_AA);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_2AA, MDR1636_BUS_CODE_55);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_10);
		if (op_result != OpSuccess)	break;
		exit = 1;
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Start FLASH sector erase operation (async)
//	Status should be checked to determine erase completition
//
//	Arguments:
//		sa - address wtihin sector to erase
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_start_erase_sector(uint32_t sa)
{
	uint32_t op_result = OpSuccess;
	uint32_t exit = 0;
	while(!exit)
	{
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_AA);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_2AA, MDR1636_BUS_CODE_55);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_80);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_AA);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_2AA, MDR1636_BUS_CODE_55);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(sa, MDR1636_BUS_CODE_30);
		if (op_result != OpSuccess)	break;
		exit = 1;
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	FLASH erase operation (sync)
//	Function blocks until operation is completed
//
//	Arguments:
//		none
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_erase_chip(void)
{
	uint32_t op_result;
	op_result = MDR1636_start_erase_chip();
	if (op_result == OpSuccess)
	{
		op_result = MDR1636_wait_device();
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	FLASH sector erase operation (sync)
//	Function blocks until operation is completed
//
//	Arguments:
//		sa - address wtihin sector to erase
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_erase_sector(uint32_t sa)
{
	uint32_t op_result;
	op_result = MDR1636_start_erase_sector(sa);
	if (op_result == OpSuccess)
	{
		op_result = MDR1636_wait_device();
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Data write to FLASH
//	Function blocks until all data is written
//
//	Arguments:
//		address - address of a byte in FLASH to start with
//		*data - pointer to source data bytes (packed per 4 into 32-bit words)
//		count - number of bytes to write
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_write_data(uint32_t address, uint32_t *data, uint32_t count)
{
	uint32_t op_result = OpSuccess;
	uint32_t exit = 0;
	uint32_t temp32u;
	uint32_t i;
	while(!exit)
	{	
		// Unlock bypass 
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_AA);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_2AA, MDR1636_BUS_CODE_55);
		if (op_result != OpSuccess)	break;
		op_result = MDR1636_write_byte(MDR1636_BUS_ADDR_555, MDR1636_BUS_CODE_20);
		if (op_result != OpSuccess)	break;
		
		i = 0;
		while (count)
		{
			if (i == 0)
			{
				temp32u = *data++;
				i = 4;
			}
			
			// Unlock bypass program
			op_result = MDR1636_write_byte(address, MDR1636_BUS_CODE_A0);
			if (op_result != OpSuccess)	break;
			// Write data
			op_result = MDR1636_write_byte(address, temp32u);
			if (op_result != OpSuccess)	break;
			
			address++;
			count--;
			temp32u >>= 8;
			i--;
			
			op_result = MDR1636_wait_device();
			if (op_result != OpSuccess)	break;
		}
		exit = 1;
	}
	return op_result;
}


//-----------------------------------------------------------------//
//	Data read from FLASH
//	Function blocks until all data is read
//
//	Arguments:
//		address - address of a byte in FLASH to start with
//		*data - pointer to destination data bytes (will be packed per 4 into 32-bit words)
//		count - number of bytes to read
//	Return:
//		One of OperationResults{}
//-----------------------------------------------------------------//
uint32_t MDR1636_read_data(uint32_t address, uint32_t *data, uint32_t count)
{
	uint32_t op_result = OpSuccess;
	uint32_t exit = 0;
	uint32_t temp32u;
	uint32_t count_w;
	uint32_t mask;
	__builtin_quad qw_dcs;
	__builtin_quad qw_dcd;
	uint32_t *ptr;
	
	op_result = OpSuccess;		// VDSP compiler bug - op_result is not initialized above
								// VDSP v 5.0.10.0 Update 10.1
	
	while(!exit)
	{
		count_w = count & 0xFFFFFFFC;	// Count of full 32-bit words
		count_w >>= 2;
		count &= 0x00000003;			// Count of additional bytes
		if (count_w != 0)
		{
			ptr = (uint32_t *)&qw_dcs;
			*(ptr + 0) = address;
			*(ptr + 1) = (count_w<<16) | 4;
			*(ptr + 2) = 0;
			*(ptr + 3) = TCB_EPROM | TCB_NORMAL;
	
			ptr = (uint32_t *)&qw_dcd;
			*(ptr + 0) = (uint32_t)data;
			*(ptr + 1) = (count_w<<16) | 1;
			*(ptr + 2) = 0;
			*(ptr + 3) = (((uint32_t)data < 0x10000000) ? TCB_INTMEM : TCB_EXTMEM) | TCB_NORMAL;
			
			HAL_DMA_WriteDCS(0, &qw_dcs);
			HAL_DMA_WriteDCD(0, &qw_dcd);
			
			if (HAL_DMA_WaitForChannel(0) != 0)
			{
				HAL_DMA_Stop(0);
				op_result = OpFrwError;
				break;
			}
			data += count_w;
			address += count_w * 4;
		}
		
		if (count != 0)
		{
			op_result = MDR1636_read_word(address, &temp32u);
			if (op_result != OpSuccess)	break;
			
			count_w = *data;
			mask = 0x000000FF;
			while(count)
			{
				count_w &= ~mask;
				count_w |= temp32u & mask;
				mask <<= 8;
				count--;
			}
			*data = count_w;
		}
		
		exit = 1;
	}
	return op_result;
}






