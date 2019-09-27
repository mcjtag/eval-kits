/**********************************************************************************************************************
  Copyright (c) 2015 Milandr Corporation. All rights reserved.

  History:
   08-May-2015 Andrei Abramchuk - Created.
**********************************************************************************************************************/
#ifndef __HAL_PLL_H__
#define __HAL_PLL_H__

#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"

/************************************************ INCLUDES ***********************************************************/
/************************************************ DEFINITIONS ********************************************************/

enum HalClockSources {
	ClockSourceBypass,
	ClockSourcePll
};

/************************************************ TYPES **************************************************************/
/**//**
 * \brief Type of PLL configuration structure.
 */
typedef struct _HAL_PLL_Config_t
{
        unsigned int ref_freq_khz;
        unsigned int pll_freq_khz;
        union
        {
                unsigned int value;
                struct
                {
                        unsigned int divr   : 4;
                        unsigned int divf   : 7;
                        unsigned int divq   : 3;
                        unsigned int range  : 3;
                        unsigned int ivco   : 3;
                        unsigned int bypass : 1;
                        unsigned int        : 11;
                };
        };
} HAL_PLL_Config_t;

/************************************************ PROTOTYPES *********************************************************/
/******************************************************************************************************************//**
  \brief Calculate PLL configuration dividers and store actual frequencies values into pll_cfg structure.

  \param[out] pll_cfg      - result.
  \param[in]  ref_freq_khz - REF frequency (in kHz).
  \param[in]  pll_freq_khz - desired PLLOUT frequency (in kHz).
  \param[in]  ext_range    - 0 to limit calculated frequency to verified frequency range.

  \return                  -1 when error.
  \return                  actual PLLOUT frequency (in kHz).
**********************************************************************************************************************/
#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus

	// Obsolete
	int HAL_PLL_ConfigCalc(HAL_PLL_Config_t* pll_cfg, unsigned int ref_freq_khz, unsigned int pll_freq_khz, unsigned int ext_range);
	
	// Recommended
	void HAL_PLL_SetupCorePll(unsigned int ref_freq, unsigned int pll_freq);
	void HAL_PLL_SetupBusPll(unsigned int ref_freq, unsigned int pll_freq);
	void HAL_PLL_SelectCoreClockSource(unsigned int src);
	void HAL_PLL_SelectBusClockSource(unsigned int src);
	
#ifdef __cplusplus
}
#endif // __cplusplus

/*
namespace	HAL
{
namespace	PLL
{
inline	int ConfigCalc(HAL_PLL_Config_t* pll_cfg, unsigned int ref_freq_khz, unsigned int pll_freq_khz, unsigned int ext_range)
{return HAL_PLL_ConfigCalc(pll_cfg, ref_freq_khz, pll_freq_khz, ext_range);}
inline	void pause(unsigned int clk)
{HAL_PLL_pause(clk);}
}
}
*/

#endif /* __HAL_PLL_H__ */
