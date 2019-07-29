/**********************************************************************************************************************
  Copyright (c) 2015 Milandr Corporation. All rights reserved.

  History:
   08-May-2015 Andrei Abramchuk - Created.
   24-June-2015 Borozdin Alexey - updated
**********************************************************************************************************************/
/************************************************ INCLUDES ***********************************************************/
#include "cpu.h"
#include "hal_pll.h"
#include "core_utils.h"

/************************************************ DEFINITIONS ********************************************************/
#define FREQ_KHZ_RANGE1         (10000)
#define FREQ_KHZ_RANGE2         (16000)
#define FREQ_KHZ_RANGE3         (25000)
#define FREQ_KHZ_RANGE4         (40000)
#define FREQ_KHZ_RANGE5         (65000)
#define FREQ_KHZ_RANGE6         (100000)

#define PLL_FREQ_KHZ_MIN        (400000)
#define PLL_FREQ_KHZ_MAX        (800000)

#define RESULT_ERROR            (-1)

/************************************************ CONSTANTS **********************************************************/
/************************************************ VARIABLES **********************************************************/
/************************************************ STATIC FUNCTIONS PROTOTYPES ****************************************/
static void HAL_PLL_pause(unsigned int clk)
{
    unsigned long long int stop = __read_ccnt();
    stop += clk;

    while ((((unsigned long long int)(__read_ccnt())) - stop) & ((unsigned long long int)1<<63));
}

/************************************************ IMPLEMENTATION *****************************************************/
int HAL_PLL_ConfigCalc(HAL_PLL_Config_t* pll_cfg, unsigned int ref_freq, unsigned int pll_freq, unsigned int ext_range)
{
    unsigned int divr = 1;
    unsigned int divf;
    unsigned int divq = 0;
    unsigned int range;
    unsigned int ivco   = 0;
    unsigned int bypass = 0;

    float tmp;

    if (!ext_range)
    if (((float)ref_freq / (float)pll_freq > (float)4.0) || ((float)pll_freq / (float)ref_freq > (float)4.0))
        return RESULT_ERROR;

    if ((ref_freq < FREQ_KHZ_RANGE1) || (ref_freq / 16 > FREQ_KHZ_RANGE6))
        return RESULT_ERROR;

    if ((pll_freq > PLL_FREQ_KHZ_MAX) || (pll_freq * 32 < PLL_FREQ_KHZ_MIN))
        return RESULT_ERROR;

    while (pll_freq < PLL_FREQ_KHZ_MIN)
    {
        pll_freq *= 2;
        divq += 1;
    }

    while ((ref_freq / divr >= FREQ_KHZ_RANGE1) && (divr < 16))
    {
        divr += 1;
    }

    divr -= 1;
    tmp = (float)ref_freq / (float)divr;
    divr -= 1;

    if      (tmp < (float)FREQ_KHZ_RANGE2) range = 1;
    else if (tmp < (float)FREQ_KHZ_RANGE3) range = 2;
    else if (tmp < (float)FREQ_KHZ_RANGE4) range = 3;
    else if (tmp < (float)FREQ_KHZ_RANGE5) range = 4;
    else                                   range = 5;

    tmp = (float)pll_freq / tmp + (float)0.5;
    divf = (unsigned int)tmp - 2;

    tmp = (float)ref_freq * (float)(divf + 2) / (float)(divr + 1) / (float)(1 << divq) + (float)0.5;

    pll_cfg->divr = divr;
    pll_cfg->divf = divf;
    pll_cfg->divq = divq;
    pll_cfg->range = range;
    pll_cfg->ivco = ivco;
    pll_cfg->bypass = bypass;

    pll_cfg->ref_freq_khz = ref_freq;
    pll_cfg->pll_freq_khz = (unsigned int)tmp;

    return (int)tmp;
}


void HAL_PLL_SetupCorePll(unsigned int ref_freq, unsigned int pll_freq)
{
	HAL_PLL_Config_t	pll_conf;
	HAL_PLL_ConfigCalc(&pll_conf, ref_freq, pll_freq, 1);
	LX_CMU->cpuPll.reg = pll_conf.value;
}

void HAL_PLL_SetupBusPll(unsigned int ref_freq, unsigned int pll_freq)
{
	HAL_PLL_Config_t	pll_conf;
	HAL_PLL_ConfigCalc(&pll_conf, ref_freq, pll_freq, 1);
	LX_CMU->busPll.reg = pll_conf.value;
}

void HAL_PLL_SelectCoreClockSource(unsigned int src)
{
	if (src == ClockSourcePll)
		LX_CMU->clockCfg.field.cpll_sel = 1;
	else
		LX_CMU->clockCfg.field.cpll_sel = 0;
	//HAL_PLL_pause(100);			// TODO - check CM_LYNX CCNT read order
	wait_cycles(100);
}

void HAL_PLL_SelectBusClockSource(unsigned int src)
{
	if (src == ClockSourcePll)
		LX_CMU->clockCfg.field.bpll_sel = 1;
	else
		LX_CMU->clockCfg.field.bpll_sel = 0;
	//HAL_PLL_pause(100);
	wait_cycles(100);
}


