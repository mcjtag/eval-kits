/*****************************************************************************
* 
*****************************************************************************/


#include "cpu.h"
#include "hal_lvds_dac_adc.h"



int32_t HAL_LVDS_ADC_Setup(uint8_t port_number, HAL_LVDS_ADC_config_t *cfg)
{
	uint32_t temp32u;
	uint32_t bus_width;
	uint32_t sample_width;
	int32_t result = 0;
	
	// Make sure ports are disabled
	if (port_number == 0)
		__builtin_sysreg_write(__LRCTL0, 0);
	else 
		__builtin_sysreg_write(__LRCTL1, 0);
		
	while(1)
	{
		// Checking arguments
		if (port_number > 1)
		{
			result = -1;
			break;	
		}
		switch(cfg->lvds_bus_width)
		{
			case 1:	bus_width = LRX_DSIZE_1BIT;	break;	
			case 4:	bus_width = LRX_DSIZE_4BIT;	break;
			case 8:	bus_width = LRX_DSIZE_8BIT;	break;
			case 16:bus_width = LRX_DSIZE_16BIT;	break;
			default: result = -1;	break;
		}
		if (result != 0)	break;
		
		switch(cfg->data_width)
		{
			case 16: sample_width = 0;	break;	
			case 14: sample_width = 1;	break;
			case 12: sample_width = 2;	break;
			case 10: sample_width = 3;	break;
			default: result = -1;	break;
		}
		if (result != 0)	break;
		
		// 16-bit data bus is avaliable only for LINK0.
		// LINK1 RX will be turned on automatically in case of 16-bit data
		// CHECKME !!!
		if ((bus_width == LRX_DSIZE_16BIT) && (port_number != 0))
		{
			result = -1;
			break;
		}
		
		temp32u = 	//LRX_EN											|
					bus_width										|		
					sample_width << 12								|
					(cfg->data_compl & 0x01) << 14					|
					(cfg->ddr_permutation & 0x01) << 15				|
					(cfg->clk_port_num & 0x01) << 16				|
					(cfg->select_up_down_converter & 0x01) << 11;
					
		if (port_number == 0) {
			__builtin_sysreg_write(__LRCTL0, temp32u);
			temp32u |= LRX_EN;
			__builtin_sysreg_write(__LRCTL0, temp32u);
		} else {
			__builtin_sysreg_write(__LRCTL1, temp32u);
			temp32u |= LRX_EN;
			__builtin_sysreg_write(__LRCTL1, temp32u);
		}

		// Done!			
		break;
	}
	return result;	
}


int32_t HAL_LVDS_DAC_Setup(uint8_t port_number, HAL_LVDS_DAC_config_t *cfg)
{
	uint32_t temp32u;
	uint32_t bus_width;
	int32_t result = 0;
	
	// Make sure ports are disabled
	if (port_number == 0)
		__builtin_sysreg_write(__LTCTL0, 0);
	else 
		__builtin_sysreg_write(__LTCTL1, 0);
		
	while(1)
	{
		// Checking arguments
		if (port_number > 1)
		{
			result = -1;
			break;	
		}
		switch(cfg->lvds_bus_width)
		{
			case 1:	bus_width = LTX_DSIZE_1BIT;	break;	
			case 4:	bus_width = LTX_DSIZE_4BIT;	break;
			case 8:	bus_width = LTX_DSIZE_8BIT;	break;
			case 16:bus_width = LTX_DSIZE_16BIT;	break;
			default: result = -1;	break;
		}
		if (result != 0)	break;
		
		// 16-bit data bus is avaliable only for LINK0.
		// LINK1 TX will be turned on automatically in case of 16-bit data
		if ((bus_width == LTX_DSIZE_16BIT) && (port_number != 0))
		{
			result = -1;
			break;
		}
		
		temp32u = 	LTX_EN											|
					bus_width 										|		
					(cfg->use_external_clock & 0x1) << 9			|		// Use clock from LINK RX
					(cfg->invert_external_clock & 0x1) << 10		|		// Invert external clock before use
					(cfg->select_up_down_converter & 0x1) << 11		|		// Use Up/Down conveter as data source
					(cfg->data_compl & 0x1) << 12					|		// Data completition mode
					LTX_IGNORE_ACK;											// External DAC mode - ignore ACKI and use SDR data rate
					
		if (port_number == 0)
			__builtin_sysreg_write(__LTCTL0, temp32u);
		else 
			__builtin_sysreg_write(__LTCTL1, temp32u);
		
		// Done!			
		break;
	}
	return result;
}





