/**
 * @file init.c
 * @brief
 * @author matyunin.d
 * @date 09.06.2017
 */

#include "system/cpu_defs.h"
#include "system/init.h"
#include "config.h"

/**
 * @brief Initialization
 * @return void
 */
void init_all(void)
{
	init_sys();
	init_pll();
	init_sdram();
	init_pll_link();
}

/*
 * @brief System initialization
 * @return void
 */
void init_sys(void)
{
	uint32_t temp32u;

	// Initial setup
	__builtin_sysreg_write(__INTCTL, 0);
	__builtin_sysreg_write(__IMASKH, 0);
	__builtin_sysreg_write(__IMASKL, 0);
	__builtin_sysreg_write(__SQCTLST, SQCTL_NMOD);
	__ASM(rds;);

	// Enable multiple writes to SYSCON/SDRCON
	*(unsigned int*)CMU_CFG1_LOC = (1<<3);  // SYS_WE

	// Configure syscon register
	temp32u = SYSCON_MS0_IDLE |
  			  SYSCON_MS0_WT3 |
  			  SYSCON_MS0_PIPE1 |
  			  SYSCON_MS0_SLOW |
  			  SYSCON_MS1_IDLE |
  			  SYSCON_MS1_WT0 |
  			  SYSCON_MS1_PIPE2 |
  			  //SYSCON_MS1_SLOW	|
  			  //SYSCON_MSH_IDLE |
  			  //SYSCON_MSH_WT0 |
  			  //SYSCON_MSH_PIPE2 |
  			  //SYSCON_MSH_SLOW	|
  			  //SYSCON_MEM_WID64 |
  			  //SYSCON_MP_WID64	|
  			  //SYSCON_HOST_WID64 |
  			  SYSCON_SDRAM_ALIAS |
  			  0x00;;

	__builtin_sysreg_write(__SYSCON, temp32u);
	__builtin_sysreg_write(__FLAGREGST, 0xFF);

	// Enable BTB
	__ASM(btben;);
	__ASM(nop;);

  	// Clocks setup
  	// Make sure used blocks are fed by peripheral clock
 	LX_CMU->clkDis.field.I2S0 = 0;
  	LX_CMU->clkDis.field.SPI = 0;
	LX_CMU->clkDis.field.UART0 = 0;
	LX_CMU->clkDis.field.LCD = 0;
	LX_CMU->clkDis.field.VCAM = 0;
	LX_CMU->clkDis.field.ADDA0 = 0;
	LX_CMU->clkDis.field.ADDA1 = 0;
	LX_CMU->clkDis.field.ADDA2 = 0;
	LX_CMU->clkDis.field.ADDA3 = 0;

	// GPIO setup (general)
 	// Atlernate functions for PORTC
  	// External bus signals
	LX_PortC->alt.reg = (1<<18) | (1<<19) | (1<<20) | (1<<21) | (1<<22) |
						(1<<8)  | (1<<9)  | (1<<10) | (1<<11) | (1<<12) |
						(1<<13) | (1<<14) | (1<<15) | (1<<16) | (1<<17);

	// Alternate function for DATA and ADDR bus
	//	LX_PortX->px_alt = 	PX_ALT_PDB0 | PX_ALT_PDB1 | PX_ALT_PDB2 | PX_ALT_PDB3 |
	//						PX_ALT_PAB0 | PX_ALT_PAB1 | PX_ALT_PAB2 |
	//	 	 				//PX_ALT_PDB23F0 |								// DATA[31:16] = NAND
	//						0;												// DATA[31:16] = bus

	// Alternate function for DATA and ADDR bus
	temp32u = PX_ALT_PDB0 | PX_ALT_PDB1 | PX_ALT_PDB2 | PX_ALT_PDB3 |
			  PX_ALT_PAB0 | PX_ALT_PAB1 | PX_ALT_PAB2 |
		 	  //PX_ALT_PDB23F0 | // DATA[31:16] = NAND
							0;												// DATA[31:16] = bus
	//LX_PortX->px_alt = temp32u;
	* (uint32_t *)PX_ALT_LOC = temp32u;

	// Enable global interrupts
	__builtin_sysreg_write(__SQCTLST, SQCTL_GIE);
}

/**
 * @brief PLL initialization
 * @return void
 */
void init_pll(void)
{
	// Core PLL setup
	HAL_PLL_SetupCorePll(CONFIG_PLL_XTI_FREQ_KHZ, CONFIG_PLL_CORE_FREQ_KHZ);
	HAL_PLL_SelectCoreClockSource(ClockSourcePll);

	// Bus PLL setup
	HAL_PLL_SetupBusPll(CONFIG_PLL_XTI_FREQ_KHZ, CONFIG_PLL_BUS_FREQ_KHZ);
	HAL_PLL_SelectBusClockSource(ClockSourcePll);
}

/**
 * @brief SDRAM initialization
 * @return void
 */
void init_sdram(void)
{
	uint32_t temp32u;

	__builtin_sysreg_write(__SDRCON, 0);

  	// Initializing SDRAM
	temp32u = SDRCON_ENBL |
			  SDRCON_CLAT3 |		// only CAS latency 2 or 3 are supported by mt48lc4m32b2 model
			  SDRCON_PG256	|
			  //SDRCON_PG512 |
			  //SDRCON_PG1K |
			  SDRCON_REF1100 |
			  SDRCON_PC2RAS2 |		// tRAS, precharge to active time, 20 ns
			  SDRCON_RAS2PC5 |		// tRP,  active to precharge time, 42 ns min
			  SDRCON_INIT |
			  0x00;
	__builtin_sysreg_write(__SDRCON, temp32u);

	#ifndef	__SIM__
	while((__builtin_sysreg_read(__SYSTAT) & (1<<13)) == 0);
	#endif	//__SIM__
}

/**
 * @brief LINK PLL initialization
 * @return void
 */
void init_pll_link(void)
{
	HAL_PLL_Config_t pll_conf;
	HAL_PLL_ConfigCalc(&pll_conf, CONFIG_PLL_XTI_FREQ_KHZ, CONFIG_PLL_LINK_FREQ_KHZ, 1);
	LX_CMU->linkPll.reg = pll_conf.value;
}

