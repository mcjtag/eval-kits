#ifndef __HAL_LVDS_DAC_ADC_H_
#define __HAL_LVDS_DAC_ADC_H_

#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"


typedef struct {
	uint8_t lvds_bus_width;				// Defines LVDS data bus width
										// Can be TODO
										
	uint8_t data_compl;					// Data conversion mode (two's complement ?)
										// Can be 0 or 1
										// If 0: TODO
										// If 1: TODO
										
	uint8_t ddr_permutation;			// Sets permutation of odd and even bits
										// If 0: TODO
										// If 1: TODO
										
	uint8_t data_width;					// Sets count of usefull diff. pairs on LVDS bus. Unused are forced to 0
										// Applicable to 8-bit LVDS bus only
										// Can be 16, 14, 12 or 10
										// If 16: data = {LxDATAP/N[7:0]}
										// If 14: data = {LxDATAP/N[7:1], 1'b0}
										// If 12: data = {LxDATAP/N[7:2], 2'b0}
										// If 10: data = {LxDATAP/N[7:3], 3'b0}
										
	uint8_t clk_port_num;				// Sets number of link port, which provides clock
										// Can be 0 or 1
										// If 0: clock is provided by LINK0 RX
										// If 1: clock is provided by LINK1 RX
										// Both LINK ports can use each other's clock
										
	uint8_t select_up_down_converter;	// Defines data sink
										// Can be 0 or 1
										// If 0: standard LINK port operation is performed. Data is put into internal LINK port buffers.
										// 	Regular DMA trasfer can be used to get samples.
										// If 1: Data is sent to UP/DOWN conveter module
} HAL_LVDS_ADC_config_t;







typedef struct {
	uint8_t lvds_bus_width;				// Defines LVDS data bus width
										// Can be 1, 4, 8 or 16
										
	uint8_t data_compl;					// Data conversion mode. 
										// Can be 0 or 1
										// If 0: samples are transmitted "as is".
										// If 1: Posiitve samples: sign bit is inversed.
										// 		 Negative smaples: all bits are inversed
										
	uint8_t use_external_clock;			// Clock selection
										// Can be 0 or 1
										// If 0: internal LINK clock is used. This clock is provided by link PLL.
										// If 1: exetrnal clock is used. Clock is provided by LINKx receiver (LxCLKIP and LxCLKIN), where 
										// LINKx is either LINK0 or LINK1. In this case, configuration of link PLL is unnecessary
										
	uint8_t invert_external_clock;		// External clock inversion.
										// Can be 0 or 1
										// If 0: external clock is used unchanged
										// If 1: external clock is inverted before using in transmitter
										
	uint8_t select_up_down_converter;	// Defines data source.
										// Can be 0 or 1
										// If 0: standard LINK port operation is performed. Data is taken from internal LINK port buffers.
										// 	Regular DMA trasfer can be used to feed DAC.
										// If 1: Data is provided by UP/DOWN conveter module
} HAL_LVDS_DAC_config_t;

// Note: LINK TX always works in SDR mode when LTxCTL[13] is set (external DAC mode)


#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus

	// Configuration of ADC mode for LVDS
	// port_number: 0 or 1
	int32_t HAL_LVDS_ADC_Setup(uint8_t port_number, HAL_LVDS_ADC_config_t *cfg);


	// Configuration of DAC mode for LVDS
	// port_number: 0 or 1
	int32_t HAL_LVDS_DAC_Setup(uint8_t port_number, HAL_LVDS_DAC_config_t *cfg);

#ifdef __cplusplus
}
#endif // __cplusplus







#endif //__HAL_LVDS_DAC_ADC_H_
