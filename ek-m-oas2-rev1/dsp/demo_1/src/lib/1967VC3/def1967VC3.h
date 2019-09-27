#ifndef __DEF1967VC3_H_
#define __DEF1967VC3_H_


#define SOC_FREQ_KHZ		(CORE_FREQ_KHZ / 2)


#define base_UART0    0x80000100
#define base_UART1    0x80000120
#define base_SPI      0x80000140
#define base_LCD      0x80000160
#define base_VBUF     0x80000180
#define base_VIDEO    0x800001a0
#define base_CMU      0x800001c0
#define base_RTC      0x800001e0
#define base_I2S0     0x80000200
#define base_I2S1     0x80000220
#define base_NAND     0x80000240
#define base_ADA0     0x80000280
#define base_ADA1     0x80000260
#define base_ADA2     0x800002A0
#define base_ADA3     0x800002C0

#define base_GPA      0x80001000
#define base_GPB      0x80001040
#define base_GPC      0x80001080
#define base_ARINC_R0 0x80002000
#define base_ARINC_T0 0x80003000
#define base_ARINC_MR0 0x80002400
#define base_ARINC_MT0 0x80003400

#define base_ARINC_LAB0 0x800027e0

#define base_DC        0x80005000

#define base_MIL_TR0_DT  0x80006000
#define base_MIL_TR0_R   0x80006400
#define base_MIL_TR0_DR  0x80006800
#define base_MIL_TR1_DT  0x80007000
#define base_MIL_TR1_R   0x80007400
#define base_MIL_TR1_DR  0x80007800

#define base_BROM     0x80008000

#define base_GPX      0x80000090
#define base_EBIU     0x80000080

#define base_DMACFGL  0x80000078
#define base_DMACFGH  0x80000079




// Extra SYSCON bits
// SDRAM alias bit. If set, enables SDRAM mirroring from 0x10000000 address
#define SYSCON_SDRAM_ALIAS_P	27

#define SYSCON_SDRAM_ALIAS		(1 << SYSCON_SDRAM_ALIAS_P)


// Conversion from UREG address to {group[5:0], reg[4:0]}
#define ADDR2GROUPREG(x) ( ((x & 0x10000) >> 6) | (x & 0x3FF) )
#define GROUPREG(group, reg) ( ((group & 0x3F) << 5) | (reg & 0x1F) )

// MPU register map
#define MS0_C_LOC		(0x1E03C0)
#define MS0_WT_LOC		(0x1E03C1)
#define MS0_CI_LOC		(0x1E03C2)
#define MS1_C_LOC		(0x1E03C8)
#define MS1_WT_LOC		(0x1E03C9)
#define MS1_CI_LOC		(0x1E03CA)
#define SDR_C_LOC		(0x1E03D0)
#define SDR_WT_LOC		(0x1E03D1)
#define SDR_CI_LOC		(0x1E03D2)
#define PU0_LOC			(0x1E03E0)
#define PU1_LOC			(0x1E03E1)
#define PU2_LOC			(0x1E03E2)
#define PU3_LOC			(0x1E03E3)
#define PU4_LOC			(0x1E03E4)
#define PU5_LOC			(0x1E03E5)
#define PU6_LOC			(0x1E03E6)
#define PU7_LOC			(0x1E03E7)
#define STS_PROT_LOC	(0x1E03E8)
#define MPU_CR_LOC		(0x1E03FC)
#define IDC_CMD_LOC		(0x1E03FD)

// Obsolete
#define MS0_C_CFG   	CACMD0
#define MS0_WT_CFG  	CCAIR0
#define MS0_CI_CFG   	CASTAT0

#define MS1_C_CFG   	CACMD2
#define MS1_WT_CFG  	CCAIR2
#define MS1_CI_CFG   	CASTAT2

#define SDR_C_CFG  		CACMD4
#define SDR_WT_CFG  	CCAIR4
#define SDR_CI_CFG   	CASTAT4

#define CWT_CR   		CACMDB
#define IDC_CR   		CCAIRB

#define PU_M0   		CACMD8
#define PU_M1   		CCAIR8



// Cache:
//
// xxx_C_CFG	<- controls data cache. If bit is 1, data cache for the memory page will be enabled.
// xxx_WT_CFG	<- controls write through option. If bit is 0, write operations will put data into the cache only.
//					If bit is 1, data will get in cache and memory both.
// xxx_WT_CI	<- controls instruction cache, If bit is 1, instruction cache for the memory page will be enabled.
//
// Every bit in these registers defines chaching strategy for a single page. Page size is following:
//	MS0/MS1: 128K words
//	SDRAM:	 512K words	
//

// CWT_CR is the global cache control register:
#define CWT_DC_ON_P		0		// If set, data cache is enabled
#define CWT_IC_ON_P		1		// If set, instruction cache is enabled
#define CWT_EN_2DQW_P	2		// If set, 2 quadwords will be loaded for data cache miss
#define CWT_EN_2IQW_P	3		// If set, 2 quadwords will be loaded for instruction cache miss

#define CWT_DC_ON		(1 << CWT_DC_ON_P)
#define CWT_IC_ON		(1 << CWT_IC_ON_P)
#define CWT_EN_2DQW		(1 << CWT_EN_2DQW_P)
#define CWT_EN_2IQW		(1 << CWT_EN_2IQW_P)


#define CACHE_ALL_PAGES				0xFFFFFFFF
#define CACHE_NONE					0x00

#define WRITE_THROUGH_ALL_PAGES		0xFFFFFFFF
#define WRITE_THROUGH_NONE			0x00

#define DCACHE_LOAD_1QW_ON_MISS		( CWT_DC_ON )
#define DCACHE_LOAD_2QW_ON_MISS		( CWT_DC_ON | CWT_EN_2DQW )
#define DCACHE_OFF					0x00

#define ICACHE_LOAD_1QW_ON_MISS		( CWT_IC_ON )
#define ICACHE_LOAD_2QW_ON_MISS		( CWT_IC_ON | CWT_EN_2IQW )
#define ICACHE_OFF					0x00
  

#define U8 \
    trap 16 
#define S8 \
    trap 17
#define PI8 \
    trap 20    
#define U16 \
    trap 18 
#define S16 \
    trap 19
#define PI8U \
    trap 21        
#define PI16 \
    trap 22    
#define PI16U \
    trap 23

#define to_U8 \
    trap 24     
#define to_U8R \
    trap 25    
#define to_U16 \
    trap 24     
#define to_U16R \
    trap 25             
#define to_Sign \
    trap 26
#define ZifNeg \
    trap 26				
#define bias \
    trap 26				
#define IF_EQ \
    trap 28    
#define IF_GE \
    trap 29    
#define IF_GT \
    trap 30

#define exe_RMW \
    trap 31


//-------------------------------------------------------//
// Interrupt
// This section expands ts201 definitions
#define INTCTL_BASE			0x80000300

// Mask bits
#define INT_GPIO_P			(1)
#define INT_UART0_P			(4)
#define INT_UART1_P			(5)
#define INT_NANDF_P			(10)
#define INT_MIL0_P			(11)
#define INT_MIL1_P			(12)
#define INT_DCOR_P			(13)
#define INT_ARINCRX_P		(18)
#define INT_ARINCTX_P		(20)
#define INT_ADDA0_P			(1)
#define INT_ADDA1_P			(2)
#define INT_ADDA2_P			(3)
#define INT_ADDA3_P			(4)
#define INT_LCD_P			(7)
#define INT_SPI_P			(13)
#define INT_SSI0_P			(14)
#define INT_SSI1_P			(15)
#define INT_VCAM_P			(17)
#define INT_H264_P			(19)
#define INT_ALARM_P			(22)
#define INT_TIC_P			(23)
#define INT_WDOG_P			(24)

// Low
#define INT_GPIO			(1<<INT_GPIO_P)		//Level
#define INT_UART0			(1<<INT_UART0_P)	//Level
#define INT_UART1			(1<<INT_UART1_P)	//Level
#define INT_NANDF			(1<<INT_NANDF_P)	//Level
#define INT_MIL0			(1<<INT_MIL0_P)		//E
#define INT_MIL1			(1<<INT_MIL1_P)		//E
#define INT_DCOR			(1<<INT_DCOR_P)		//Level - docs are wrong
#define INT_ARINCRX			(1<<INT_ARINCRX_P)	//Level
#define INT_ARINCTX			(1<<INT_ARINCTX_P)	//Level
// High
#define INT_ADDA0			(1<<INT_ADDA0_P)	//E
#define INT_ADDA1			(1<<INT_ADDA1_P)	//E
#define INT_ADDA2			(1<<INT_ADDA2_P)	//E
#define INT_ADDA3			(1<<INT_ADDA3_P)	//E
#define INT_LCD				(1<<INT_LCD_P)		//Level
#define INT_SPI				(1<<INT_SPI_P)		//Level
#define INT_SSI0			(1<<INT_SSI0_P)		//Level
#define INT_SSI1			(1<<INT_SSI1_P)		//Level
#define INT_VCAM			(1<<INT_VCAM_P)		//Level
#define INT_H264			(1<<INT_H264_P)		//Level
#define INT_ALARM			(1<<INT_ALARM_P)	//E
#define INT_TIC				(1<<INT_TIC_P)		//E
#define INT_WDOG			(1<<INT_WDOG_P)		//E



// Interrupt controller register map
#define IVT_BASE			(INTCTL_BASE + 0x00)

#define IV_KERNEL_LOC		(IVT_BASE + 0x00)
#define IV_GPIO_LOC			(IVT_BASE + 0x01)
#define IV_TIMER0LP_LOC		(IVT_BASE + 0x02)
#define IV_TIMER1LP_LOC		(IVT_BASE + 0x03)
#define IV_UART0_LOC		(IVT_BASE + 0x04)
#define IV_UART1_LOC		(IVT_BASE + 0x05)
#define IV_LINK0_LOC		(IVT_BASE + 0x06)
#define IV_LINK1_LOC		(IVT_BASE + 0x07)
#define IV_LINK2_LOC		(IVT_BASE + 0x08)	// for compability
#define IV_LINK3_LOC		(IVT_BASE + 0x09)	// for compability
#define IV_NANDF_LOC		(IVT_BASE + 0x0A)
#define IV_MIL0_LOC			(IVT_BASE + 0x0B)	// Manchester 0
#define IV_MIL1_LOC			(IVT_BASE + 0x0C)	// Manchecter 1
#define IV_DCOR_LOC			(IVT_BASE + 0x0D)	// Digital correlator
#define IV_DMA0_LOC			(IVT_BASE + 0x0E)
#define IV_DMA1_LOC			(IVT_BASE + 0x0F)
#define IV_DMA2_LOC			(IVT_BASE + 0x10)
#define IV_DMA3_LOC			(IVT_BASE + 0x11)
#define IV_ARINCRX_LOC		(IVT_BASE + 0x12)
//#define IV_xxx_LOC		(IVT_BASE + 0x13)	// reserved
#define IV_ARINCTX_LOC		(IVT_BASE + 0x14)
//#define IV_xxx_LOC		(IVT_BASE + 0x15)	// reserved
#define IV_DMA4_LOC		(IVT_BASE + 0x16)
#define IV_DMA5_LOC		(IVT_BASE + 0x17)
#define IV_DMA6_LOC		(IVT_BASE + 0x18)
#define IV_DMA7_LOC		(IVT_BASE + 0x19)
//#define IV_xxx_LOC		(IVT_BASE + 0x1A)	// reserved
//#define IV_xxx_LOC		(IVT_BASE + 0x1B)	// reserved
//#define IV_xxx_LOC		(IVT_BASE + 0x1C)	// reserved
#define IV_DMA8_LOC		(IVT_BASE + 0x1D)
#define IV_DMA9_LOC		(IVT_BASE + 0x1E)
#define IV_DMA10_LOC	(IVT_BASE + 0x1F)
// 
#define IV_DMA11_LOC	(IVT_BASE + 0x20)
#define IV_ADDA0_LOC	(IVT_BASE + 0x21)
#define IV_ADDA1_LOC	(IVT_BASE + 0x22)
#define IV_ADDA2_LOC	(IVT_BASE + 0x23)
#define IV_ADDA3_LOC	(IVT_BASE + 0x24)
#define IV_DMA12_LOC	(IVT_BASE + 0x25)
#define IV_DMA13_LOC	(IVT_BASE + 0x26)
#define IV_LCD_LOC		(IVT_BASE + 0x27)
//#define IV_xxx_LOC		(IVT_BASE + 0x28)	// reserved
#define IV_IRQ0_LOC		(IVT_BASE + 0x29)
#define IV_IRQ1_LOC		(IVT_BASE + 0x2A)
#define IV_IRQ2_LOC		(IVT_BASE + 0x2B)
#define IV_IRQ3_LOC		(IVT_BASE + 0x2C)
#define IV_SPI_LOC		(IVT_BASE + 0x2D)
#define IV_SSI0_LOC		(IVT_BASE + 0x2E)
#define IV_SSI1_LOC		(IVT_BASE + 0x2F)
#define IV_VECTOR_LOC	(IVT_BASE + 0x30)
#define IV_VCAM_LOC		(IVT_BASE + 0x31)
#define IV_BUSLOCK_LOC	(IVT_BASE + 0x32)
#define IV_H264_LOC		(IVT_BASE + 0x33)
#define IV_TIMER0HP_LOC	(IVT_BASE + 0x34)
#define IV_TIMER1HP_LOC	(IVT_BASE + 0x35)
#define IV_ALARM_LOC	(IVT_BASE + 0x36)
#define IV_TIC_LOC		(IVT_BASE + 0x37)
#define IV_WDOG_LOC		(IVT_BASE + 0x38)
#define IV_HWERR_LOC	(IVT_BASE + 0x39)
//#define IV_xxx_LOC		(IVT_BASE + 0x3A)	// reserved
//#define IV_xxx_LOC		(IVT_BASE + 0x3B)
//#define IV_xxx_LOC		(IVT_BASE + 0x3C)
//#define IV_xxx_LOC		(IVT_BASE + 0x3D)
//#define IV_xxx_LOC		(IVT_BASE + 0x3E)
//#define IV_xxx_LOC		(IVT_BASE + 0x3F)



#define uart_PUC   2
#define uart_PUR   5
#define uart_DR    0
#define uart_SR    8


//-------------------------------------------------------//
// RTC
#define RTC_BASE			0x800001E0
#define RTC_CNT_offset		0x00
#define RTC_MR_offset		0x01
#define WDT_CNT_offset		0x02
#define RTC_TDIV_offset		0x03
#define RTC_CR_offset		0x04
#define RTC_SDIV_offset		0x05
#define TIC_VAL_offset		0x06
#define SEC_VAL_offset		0x07
#define RTC_BUSY_offset		0x08
#define RTC_CNT_LOC			(RTC_BASE + RTC_CNT_offset)
#define RTC_MR_LOC			(RTC_BASE + RTC_MR_offset)
#define WDT_CNT_LOC			(RTC_BASE + WDT_CNT_offset)
#define RTC_TDIV_LOC		(RTC_BASE + RTC_TDIV_offset)
#define RTC_CR_LOC			(RTC_BASE + RTC_CR_offset)
#define RTC_SDIV_LOC		(RTC_BASE + RTC_SDIV_offset)
#define TIC_VAL_LOC			(RTC_BASE + TIC_VAL_offset)
#define SEC_VAL_LOC			(RTC_BASE + SEC_VAL_offset)
#define RTC_BUSY_LOC		(RTC_BASE + RTC_BUSY_offset)

// RTC_CR register bits
#define RTC_CR_WDT_RESEN_P		2
#define RTC_CR_FREEZE_P			3
#define RTC_CR_WDT_SEL_P		4
#define RTC_CR_LOCK_P			7
#define RTC_CR_DIS_TICINTA_P	8
#define RTC_CR_DIS_DOGINTA_P	9
#define RTC_CR_DIS_MRINTA_P		10

#define RTC_CR_WDT_RESEN		(1<<RTC_CR_WDT_RESEN_P)
#define RTC_CR_FREEZE			(1<<RTC_CR_FREEZE_P)
#define RTC_CR_WDT_SEL			(0x7<<RTC_CR_WDT_SEL_P)
#define RTC_CR_LOCK				(1<<RTC_CR_LOCK_P)
#define RTC_CR_DIS_TICAINT		(1<<RTC_CR_DIS_TICINTA_P)
#define RTC_CR_DIS_DOGAINT		(1<<RTC_CR_DIS_DOGINTA_P)
#define RTC_CR_DIS_MRAINT		(1<<RTC_CR_DIS_MRINTA_P)





//-------------------------------------------------------//
// GPIO
// write 0x01 to LOAD location sets Portx = 0x01
// write 0x01 to SET location sets Portx[0]
// write 0x01 to CLEAR location clears Portx[0]

#define PiDR_LOAD_offset		0
#define PiDR_SET_offset			1
#define PiDR_CLEAR_offset		2
#define PiDR_INV_offset			3
#define PiDDR_LOAD_offset		4
#define PiDDR_SET_offset		5
#define PiDDR_CLEAR_offset		6
#define PiDDR_INV_offset		7
#define PiPEIE_LOAD_offset		8
#define PiPEIE_SET_offset		9
#define PiPEIE_CLEAR_offset		10
#define PiPEIE_INV_offset		11
#define PiNEIE_LOAD_offset		12
#define PiNEIE_SET_offset		13
#define PiNEIE_CLEAR_offset		14
#define PiNEIE_INV_offset		15
#define PiINVR_LOAD_offset		16
#define PiINVR_SET_offset		17
#define PiINVR_CLEAR_offset		18
#define PiINVR_INV_offset		19
#define PiIMR_LOAD_offset		20
#define PiIMR_SET_offset		21
#define PiIMR_CLEAR_offset		22
#define PiIMR_INV_offset		23
#define PiALT_LOAD_offset		24
#define PiALT_SET_offset		25
#define PiALT_CLEAR_offset		26
#define PiALT_INV_offset		27
#define PiPUR_LOAD_offset		28
#define PiPUR_SET_offset		29
#define PiPUR_CLEAR_offset		30
#define PiPUR_INV_offset		31
#define PiPXD_offset			32
#define PiINTREQ_offset			33
#define PiECLR_offset			35


// GPA
#define GPA_DR_LOAD_LOC			(base_GPA + PiDR_LOAD_offset)
#define GPA_DR_SET_LOC			(base_GPA + PiDR_SET_offset)
#define GPA_DR_CLEAR_LOC		(base_GPA + PiDR_CLEAR_offset)
#define GPA_DR_INV_LOC			(base_GPA + PiDR_INV_offset)
#define GPA_DDR_LOAD_LOC		(base_GPA + PiDDR_LOAD_offset)
#define GPA_DDR_SET_LOC			(base_GPA + PiDDR_SET_offset)
#define GPA_DDR_CLEAR_LOC		(base_GPA + PiDDR_CLEAR_offset)
#define GPA_DDR_INV_LOC			(base_GPA + PiDDR_INV_offset)
#define GPA_PEIE_LOAD_LOC		(base_GPA + PiPEIE_LOAD_offset)
#define GPA_PEIE_SET_LOC		(base_GPA + PiPEIE_SET_offset)
#define GPA_PEIE_CLEAR_LOC		(base_GPA + PiPEIE_CLEAR_offset)
#define GPA_PEIE_INV_LOC		(base_GPA + PiPEIE_INV_offset)
#define GPA_NEIE_LOAD_LOC		(base_GPA + PiNEIE_LOAD_offset)
#define GPA_NEIE_SET_LOC		(base_GPA + PiNEIE_SET_offset)
#define GPA_NEIE_CLEAR_LOC		(base_GPA + PiNEIE_CLEAR_offset)
#define GPA_NEIE_INV_LOC		(base_GPA + PiNEIE_INV_offset)
#define GPA_INVR_LOAD_LOC		(base_GPA + PiINVR_LOAD_offset)
#define GPA_INVR_SET_LOC		(base_GPA + PiINVR_SET_offset)
#define GPA_INVR_CLEAR_LOC		(base_GPA + PiINVR_CLEAR_offset)
#define GPA_INVR_INV_LOC		(base_GPA + PiINVR_INV_offset)
#define GPA_IMR_LOAD_LOC		(base_GPA + PiIMR_LOAD_offset)
#define GPA_IMR_SET_LOC			(base_GPA + PiIMR_SET_offset)
#define GPA_IMR_CLEAR_LOC		(base_GPA + PiIMR_CLEAR_offset)
#define GPA_IMR_INV_LOC			(base_GPA + PiIMR_INV_offset)
#define GPA_ALT_LOAD_LOC		(base_GPA + PiALT_LOAD_offset)
#define GPA_ALT_SET_LOC			(base_GPA + PiALT_SET_offset)
#define GPA_ALT_CLEAR_LOC		(base_GPA + PiALT_CLEAR_offset)
#define GPA_ALT_INV_LOC			(base_GPA + PiALT_INV_offset)
#define GPA_PUR_LOAD_LOC		(base_GPA + PiPUR_LOAD_offset)
#define GPA_PUR_SET_LOC			(base_GPA + PiPUR_SET_offset)
#define GPA_PUR_CLEAR_LOC		(base_GPA + PiPUR_CLEAR_offset)
#define GPA_PUR_INV_LOC			(base_GPA + PiPUR_INV_offset)
#define GPA_PXD_LOC				(base_GPA + PiPXD_offset)
#define GPA_INTREQ_LOC			(base_GPA + PiINTREQ_offset)
#define GPA_ECLR_LOC			(base_GPA + PiECLR_offset)
// Aliases
#define GPA_DR_LOC				GPA_DR_LOAD_LOC
#define GPA_DDR_LOC				GPA_DDR_LOAD_LOC
#define GPA_PEIE_LOC			GPA_PEIE_LOAD_LOC
#define GPA_NEIE_LOC			GPA_NEIE_LOAD_LOC
#define GPA_INVR_LOC			GPA_INVR_LOAD_LOC
#define GPA_IMR_LOC				GPA_IMR_LOAD_LOC
#define GPA_ALT_LOC				GPA_ALT_LOAD_LOC
#define GPA_PUR_LOC				GPA_PUR_LOAD_LOC


// GPB
#define GPB_DR_LOAD_LOC			(base_GPB + PiDR_LOAD_offset)
#define GPB_DR_SET_LOC			(base_GPB + PiDR_SET_offset)
#define GPB_DR_CLEAR_LOC		(base_GPB + PiDR_CLEAR_offset)
#define GPB_DR_INV_LOC			(base_GPB + PiDR_INV_offset)
#define GPB_DDR_LOAD_LOC		(base_GPB + PiDDR_LOAD_offset)
#define GPB_DDR_SET_LOC			(base_GPB + PiDDR_SET_offset)
#define GPB_DDR_CLEAR_LOC		(base_GPB + PiDDR_CLEAR_offset)
#define GPB_DDR_INV_LOC			(base_GPB + PiDDR_INV_offset)
#define GPB_PEIE_LOAD_LOC		(base_GPB + PiPEIE_LOAD_offset)
#define GPB_PEIE_SET_LOC		(base_GPB + PiPEIE_SET_offset)
#define GPB_PEIE_CLEAR_LOC		(base_GPB + PiPEIE_CLEAR_offset)
#define GPB_PEIE_INV_LOC		(base_GPB + PiPEIE_INV_offset)
#define GPB_NEIE_LOAD_LOC		(base_GPB + PiNEIE_LOAD_offset)
#define GPB_NEIE_SET_LOC		(base_GPB + PiNEIE_SET_offset)
#define GPB_NEIE_CLEAR_LOC		(base_GPB + PiNEIE_CLEAR_offset)
#define GPB_NEIE_INV_LOC		(base_GPB + PiNEIE_INV_offset)
#define GPB_INVR_LOAD_LOC		(base_GPB + PiINVR_LOAD_offset)
#define GPB_INVR_SET_LOC		(base_GPB + PiINVR_SET_offset)
#define GPB_INVR_CLEAR_LOC		(base_GPB + PiINVR_CLEAR_offset)
#define GPB_INVR_INV_LOC		(base_GPB + PiINVR_INV_offset)
#define GPB_IMR_LOAD_LOC		(base_GPB + PiIMR_LOAD_offset)
#define GPB_IMR_SET_LOC			(base_GPB + PiIMR_SET_offset)
#define GPB_IMR_CLEAR_LOC		(base_GPB + PiIMR_CLEAR_offset)
#define GPB_IMR_INV_LOC			(base_GPB + PiIMR_INV_offset)
#define GPB_ALT_LOAD_LOC		(base_GPB + PiALT_LOAD_offset)
#define GPB_ALT_SET_LOC			(base_GPB + PiALT_SET_offset)
#define GPB_ALT_CLEAR_LOC		(base_GPB + PiALT_CLEAR_offset)
#define GPB_ALT_INV_LOC			(base_GPB + PiALT_INV_offset)
#define GPB_PUR_LOAD_LOC		(base_GPB + PiPUR_LOAD_offset)
#define GPB_PUR_SET_LOC			(base_GPB + PiPUR_SET_offset)
#define GPB_PUR_CLEAR_LOC		(base_GPB + PiPUR_CLEAR_offset)
#define GPB_PUR_INV_LOC			(base_GPB + PiPUR_INV_offset)
#define GPB_PXD_LOC				(base_GPB + PiPXD_offset)
#define GPB_INTREQ_LOC			(base_GPB + PiINTREQ_offset)
#define GPB_ECLR_LOC			(base_GPB + PiECLR_offset)
// Aliases
#define GPB_DR_LOC				GPB_DR_LOAD_LOC
#define GPB_DDR_LOC				GPB_DDR_LOAD_LOC
#define GPB_PEIE_LOC			GPB_PEIE_LOAD_LOC
#define GPB_NEIE_LOC			GPB_NEIE_LOAD_LOC
#define GPB_INVR_LOC			GPB_INVR_LOAD_LOC
#define GPB_IMR_LOC				GPB_IMR_LOAD_LOC
#define GPB_ALT_LOC				GPB_ALT_LOAD_LOC
#define GPB_PUR_LOC				GPB_PUR_LOAD_LOC

// GPC
#define GPC_DR_LOAD_LOC			(base_GPC + PiDR_LOAD_offset)
#define GPC_DR_SET_LOC			(base_GPC + PiDR_SET_offset)
#define GPC_DR_CLEAR_LOC		(base_GPC + PiDR_CLEAR_offset)
#define GPC_DR_INV_LOC			(base_GPC + PiDR_INV_offset)
#define GPC_DDR_LOAD_LOC		(base_GPC + PiDDR_LOAD_offset)
#define GPC_DDR_SET_LOC			(base_GPC + PiDDR_SET_offset)
#define GPC_DDR_CLEAR_LOC		(base_GPC + PiDDR_CLEAR_offset)
#define GPC_DDR_INV_LOC			(base_GPC + PiDDR_INV_offset)
#define GPC_PEIE_LOAD_LOC		(base_GPC + PiPEIE_LOAD_offset)
#define GPC_PEIE_SET_LOC		(base_GPC + PiPEIE_SET_offset)
#define GPC_PEIE_CLEAR_LOC		(base_GPC + PiPEIE_CLEAR_offset)
#define GPC_PEIE_INV_LOC		(base_GPC + PiPEIE_INV_offset)
#define GPC_NEIE_LOAD_LOC		(base_GPC + PiNEIE_LOAD_offset)
#define GPC_NEIE_SET_LOC		(base_GPC + PiNEIE_SET_offset)
#define GPC_NEIE_CLEAR_LOC		(base_GPC + PiNEIE_CLEAR_offset)
#define GPC_NEIE_INV_LOC		(base_GPC + PiNEIE_INV_offset)
#define GPC_INVR_LOAD_LOC		(base_GPC + PiINVR_LOAD_offset)
#define GPC_INVR_SET_LOC		(base_GPC + PiINVR_SET_offset)
#define GPC_INVR_CLEAR_LOC		(base_GPC + PiINVR_CLEAR_offset)
#define GPC_INVR_INV_LOC		(base_GPC + PiINVR_INV_offset)
#define GPC_IMR_LOAD_LOC		(base_GPC + PiIMR_LOAD_offset)
#define GPC_IMR_SET_LOC			(base_GPC + PiIMR_SET_offset)
#define GPC_IMR_CLEAR_LOC		(base_GPC + PiIMR_CLEAR_offset)
#define GPC_IMR_INV_LOC			(base_GPC + PiIMR_INV_offset)
#define GPC_ALT_LOAD_LOC		(base_GPC + PiALT_LOAD_offset)
#define GPC_ALT_SET_LOC			(base_GPC + PiALT_SET_offset)
#define GPC_ALT_CLEAR_LOC		(base_GPC + PiALT_CLEAR_offset)
#define GPC_ALT_INV_LOC			(base_GPC + PiALT_INV_offset)
#define GPC_PUR_LOAD_LOC		(base_GPC + PiPUR_LOAD_offset)
#define GPC_PUR_SET_LOC			(base_GPC + PiPUR_SET_offset)
#define GPC_PUR_CLEAR_LOC		(base_GPC + PiPUR_CLEAR_offset)
#define GPC_PUR_INV_LOC			(base_GPC + PiPUR_INV_offset)
#define GPC_PXD_LOC				(base_GPC + PiPXD_offset)
#define GPC_INTREQ_LOC			(base_GPC + PiINTREQ_offset)
#define GPC_ECLR_LOC			(base_GPC + PiECLR_offset)
// Aliases
#define GPC_DR_LOC				GPC_DR_LOAD_LOC
#define GPC_DDR_LOC				GPC_DDR_LOAD_LOC
#define GPC_PEIE_LOC			GPC_PEIE_LOAD_LOC
#define GPC_NEIE_LOC			GPC_NEIE_LOAD_LOC
#define GPC_INVR_LOC			GPC_INVR_LOAD_LOC
#define GPC_IMR_LOC				GPC_IMR_LOAD_LOC
#define GPC_ALT_LOC				GPC_ALT_LOAD_LOC
#define GPC_PUR_LOC				GPC_PUR_LOAD_LOC

// GPIO port functions
#define PF_PORT	0
#define PF_ALT	1



// GPX (PxA and PxD) - FIXME
#define PXD_LOAD_offset			0
#define PXD_SET_offset			1
#define PXD_CLEAR_offset		2
#define PXD_DIR_offset			3
#define PXA_LOAD_offset			4
#define PXA_SET_offset			5
#define PXA_CLEAR_offset		6
#define PX_ALT_offset			8
#define PXD_PIN_offset			9

#define PXD_LOAD_LOC			(base_GPX + PXD_LOAD_offset)
#define PXD_DR_LOC				PXD_LOAD_LOC	// alias
#define PXD_SET_LOC				(base_GPX + PXD_SET_offset)
#define PXD_CLEAR_LOC			(base_GPX + PXD_CLEAR_offset)
#define PXD_DIR_LOC				(base_GPX + PXD_DIR_offset)

#define PXA_LOAD_LOC			(base_GPX + PXA_LOAD_offset)
#define PXA_DR_LOC				PXA_LOAD_LOC	// alias
#define PXA_SET_LOC				(base_GPX + PXA_SET_offset)
#define PXA_CLEAR_LOC			(base_GPX + PXA_CLEAR_offset)
// PXA only output


#define PX_ALT_LOC				(base_GPX + PX_ALT_offset)
#define PX_ALT_PDB0				(1<<0)
#define PX_ALT_PDB1				(1<<1)
#define PX_ALT_PDB2				(1<<2)
#define PX_ALT_PDB3				(1<<3)
#define PX_ALT_PAB0				(1<<4)
#define PX_ALT_PAB1				(1<<5)
#define PX_ALT_PAB2				(1<<6)
#define PX_ALT_PDB23F0			(1<<7)
#define PX_ALT_PDB23F1			(1<<8)

#define PA_BIT_MASK_SPI			(0x1FF)

//-------------------------------------------------------//
// SPI

#define SPCR0_LOC					(base_SPI + 0)
#define SPCR1_LOC					(base_SPI + 1)
#define SPDR_LOC					(base_SPI + 2)
#define SPSR_LOC					(base_SPI + 3)
#define SPRXCNT_LOC					(base_SPI + 4)

// SPCR0 bits
#define SPCR0_DSS_4BIT				0x3
#define SPCR0_DSS_5BIT				0x4
#define SPCR0_DSS_6BIT				0x5
#define SPCR0_DSS_7BIT				0x6
#define SPCR0_DSS_8BIT				0x7
#define SPCR0_DSS_9BIT				0x8
#define SPCR0_DSS_10BIT				0x9
#define SPCR0_DSS_11BIT				0xA
#define SPCR0_DSS_12BIT				0xB
#define SPCR0_DSS_13BIT				0xC
#define SPCR0_DSS_14BIT				0xD
#define SPCR0_DSS_15BIT				0xE
#define SPCR0_DSS_16BIT				0xF
#define SPCR0_SPO_CLK_HIGH			(0<<6)
#define SPCR0_SPO_CLK_LOW			(1<<6)
#define SPCR0_SPH_CLK_FALLING		(0<<7)
#define SPCR0_SPH_CLK_RISING		(1<<7)
#define SPCR0_TWI_MODE_OFF			(0<<8)
#define SPCR0_TWI_MODE_ON			(1<<8)
#define SPCR0_TWI_MODE_READ			(0<<9)
#define SPCR0_TWI_MODE_WRITE		(1<<9)
#define SPCR0_MSB_FIRST				(0<<10)
#define SPCR0_LSB_FIRST				(1<<10)
#define SPCR0_CSN_DEV0				((0<<14) | (0<<13) | (0<<12))
#define SPCR0_CSN_DEV1				((0<<14) | (0<<13) | (1<<12))
#define SPCR0_CSN_DEV2				((0<<14) | (1<<13) | (0<<12))
#define SPCR0_CSN_DEV3				((0<<14) | (1<<13) | (1<<12))
#define SPCR0_CSN_DEV4				((1<<14) | (0<<13) | (0<<12))
#define SPCR0_CSN_DEV5				((1<<14) | (0<<13) | (1<<12))
#define SPCR0_CSN_DEV6				((1<<14) | (1<<13) | (0<<12))
#define SPCR0_CSN_DEV7				((1<<14) | (1<<13) | (1<<12))
#define SPCR0_SCR_MASK				0x0FFF0000

// SPCR1 bit positions
#define SPCR1_RIM_P					(0)
#define SPCR1_TIM_P					(1)
#define SPCR1_LBM_P					(2)
#define SPCR1_SPE_P					(3)
#define SPCR1_MS_P					(4)
#define SPCR1_TUM_P					(5)
#define SPCR1_ROM_P					(6)
#define SPCR1_R_RQM_P				(8)
#define SPCR1_T_RQM_P				(9)
#define SPCR1_TXO_P					(10)
#define SPCR1_RXO_P					(11)
#define SPCR1_CIM_P					(12)
#define SPCR1_HOLDCS_P				(14)
#define SPCR1_ROTL_P				(15)
#define SPCR1_CS0_AL_P				(16)
#define SPCR1_CS1_AL_P				(17)
#define SPCR1_CS2_AL_P				(18)
#define SPCR1_CS3_AL_P				(19)
#define SPCR1_CS4_AL_P				(20)
#define SPCR1_CS5_AL_P				(21)

// SPSR bits
#define SPSR_TFE_P					(0)
#define SPSR_TNF_P					(1)
#define SPSR_RNE_P					(2)
#define SPSR_BSY_P					(3)
#define SPSR_TFS_P					(4)
#define SPSR_RFS_P					(5)
#define SPSR_ROR_P					(6)
#define SPSR_TUR_P					(7)
#define SPSR_RFF_P					(8)



//-------------------------------------------------------//
// NAND Flash

#define NAND_IO_CFG_LOC		(base_NAND + 0x0)
#define NAND_WCT_CFG_LOC	(base_NAND + 0x1)
#define NAND_CFG_LOC		(base_NAND + 0x2)
#define NAND_WR_CFG_LOC		(base_NAND + 0x3)
#define NAND_RD_CFG_LOC		(base_NAND + 0x4)
//#define NAND_IOSR_LOC		(base_NAND + 0x5)
#define NAND_CR_LOC			(base_NAND + 0x8)
#define NAND_SR_LOC			(base_NAND + 0x9)
#define NAND_AR_LOC			(base_NAND + 0xA)
#define NAND_CNTR_LOC		(base_NAND + 0xB)
#define NAND_DR_LOC			(base_NAND + 0xC)

// NAND_IO_CFG register
#define NAND_IO_CFG_CSCA_P			1
#define NAND_IO_CFG_CA_P			3
#define NAND_IO_CFG_BWD_P			8
#define NAND_IO_CFG_BRT_P			11
#define NAND_IO_CFG_BHT_P			15
#define NAND_IO_CFG_MDT_P			18
#define NAND_IO_CFG_VGA_P			21
#define NAND_IO_CFG_CSKPL_P			23

// NAND_WCT_CFG register
#define NAND_WCT_CFG_ENWT_P			0
#define NAND_WCT_CFG_CCSE_P			4
#define NAND_WCT_CFG_WTOC_P			21
#define NAND_WCT_CFG_TOE_P			31

// NAND_CFG
#define NAND_CFG_VOLCOL10_P			0
#define NAND_CFG_ROWBT_P			3
#define NAND_CFG_COMCLW_P			4
#define NAND_CFG_COMCLR_P			6
#define NAND_CFG_ADRCL_P			8
#define NAND_CFG_ADRSC_P			12
#define NAND_CFG_DATSC_P			13
#define NAND_CFG_VOLCOL2_P			14
#define NAND_CFG_COMSC_P			15
#define NAND_CFG_RESBF_P			16
#define NAND_CFG_RESAF_P			21
#define NAND_CFG_ADDRH_P			28

#define NAND_CFG_ADRCL_ONECYCLE		(0<<NAND_CFG_ADRCL_P)
#define NAND_CFG_ADRCL_COLUMN		(1<<NAND_CFG_ADRCL_P)
#define NAND_CFG_ADRCL_ROW			(2<<NAND_CFG_ADRCL_P)
#define NAND_CFG_ADRCL_ROW_COLUMN	(3<<NAND_CFG_ADRCL_P)

#define NAND_CFG_COMCLR1			(0 << NAND_CFG_COMCLR_P)
#define NAND_CFG_COMCLR2			(1 << NAND_CFG_COMCLR_P)
#define NAND_CFG_COMCLW1			(0 << NAND_CFG_COMCLW_P)
#define NAND_CFG_COMCLW2			(1 << NAND_CFG_COMCLW_P)
#define NAND_CFG_COMCLW3			(2 << NAND_CFG_COMCLW_P)

#define NAND_CFG_ADRSC				(1<<NAND_CFG_ADRSC_P)
#define NAND_CFG_DATSC				(1<<NAND_CFG_DATSC_P)
#define NAND_CFG_COMSC				(1<<NAND_CFG_COMSC_P)

// NAND_WR_CFG
#define NAND_WR_CFG_COMW1_P			0
#define NAND_WR_CFG_COMW2_P			8
#define NAND_WR_CFG_COMW3_P			16

// NAND_RD_CFG
#define NAND_RD_CFG_COMR1_P			0
#define NAND_RD_CFG_COMR2_P			8
#define NAND_RD_CFG_COMR3_P			16

// NAND_IOSR
//#define NAND_IOSR_TOEX0_P			0
//#define NAND_IOSR_TOEX1_P			1
//#define NAND_IOSR_TOEX2_P			2
//#define NAND_IOSR_TOEX3_P			3
//#define NAND_IOSR_MWE_P				4
//#define NAND_IOSR_RnBF_P			5
//#define NAND_IOSR_RnB_P				31

// NAND_CR
#define NAND_CR_EN_P				0
#define NAND_CR_RW_P				1
//#define NAND_CR_LOCK_P				2
#define NAND_CR_SQE_P				3
#define NAND_CR_RIM_P				4
#define NAND_CR_TIM_P				5
#define NAND_CR_CIM_P				6
#define NAND_CR_SZ_P				8
#define NAND_CR_DBSZ_P				11
#define NAND_CR_ERI_EN_P			12
#define NAND_CR_RnBI_EN_P			13

#define NAND_CR_WRITE				(1 << NAND_CR_RW_P)
#define NAND_CR_SIZE_WORD			((0<<9) | (0<<8))
#define NAND_CR_SIZE_SHORT			((1<<9) | (0<<8))
#define NAND_CR_SIZE_BYTE			((1<<9) | (1<<8))

// NAND_SR
#define NAND_SR_EMPTY_P				0
#define NAND_SR_FULL_P				1
#define NAND_SR_TFS_P				2
#define NAND_SR_RFS_P				3
#define NAND_SR_IRQ_P				4
#define NAND_IOSR_TOEX_P			8
#define NAND_IOSR_TOEX0_P			8
#define NAND_IOSR_TOEX1_P			9
#define NAND_IOSR_TOEX2_P			10
#define NAND_IOSR_TOEX3_P			11
#define NAND_IOSR_RnBF_P			13
#define NAND_IOSR_RFSI_P			16
#define NAND_IOSR_TFSI_P			17
#define NAND_IOSR_CNTZI_P			18
#define NAND_IOSR_TOI_P				19
#define NAND_IOSR_RnBFI_P			20
#define NAND_IOSR_RnB_P				31


#define NAND_SR_EMPTY				(1<<NAND_SR_EMPTY_P)
#define NAND_SR_FULL				(1<<NAND_SR_FULL_P)
#define NAND_SR_TFS					(1<<NAND_SR_TFS_P)
#define NAND_SR_RFS					(1<<NAND_SR_RFS_P)
#define NAND_SR_IRQ					(1<<NAND_SR_IRQ_P)
#define NAND_SR_RnBF				(1<<NAND_IOSR_RnBF_P)


// NAND_AR
// NAND_CNTR
// NAND_DR


//-------------------------------------------------------//
// UART

#define UART_DR_offset				0
#define UART_STAT_offset			1
#define UART_UCR_LOAD_offset		2
#define UART_UCR_SET_offset			3
#define UART_UCR_CLEAR_offset		4
#define UART_UBRATE_offset			5
#define UART_UFLAG_offset			6
#define UART_UINTM_offset			7
#define UART_UINT_offset			8

#define UART0_DR_LOC				(base_UART0 + UART_DR_offset)
#define UART0_STAT_LOC				(base_UART0 + UART_STAT_offset)
#define UART0_UCR_LOAD_LOC			(base_UART0 + UART_UCR_LOAD_offset)
#define UART0_UCR_SET_LOC			(base_UART0 + UART_UCR_SET_offset)
#define UART0_UCR_CLEAR_LOC			(base_UART0 + UART_UCR_CLEAR_offset)
#define UART0_UBRATE_LOC			(base_UART0 + UART_UBRATE_offset)
#define UART0_UFLAG_LOC				(base_UART0 + UART_UFLAG_offset)
#define UART0_INTM_LOC				(base_UART0 + UART_UINTM_offset)
#define UART0_INT_LOC				(base_UART0 + UART_UINT_offset)
// Aliases
#define UART0_UCR_LOC				UART0_UCR_LOAD_LOC


#define UCR_UARTEN_P				0
#define UCR_UTXDIS_P				1
#define UCR_URXDIS_P				2
#define UCR_DMAONERR_P				3
#define UCR_UTXFDIS_P				4
#define UCR_URXFDIS_P				5
#define UCR_UHBRE_P					6
#define UCR_BREAK_P					8
#define UCR_PRTEN_P					9
#define UCR_EVENPRT_P				10
#define UCR_XSTOP_P					11
#define UCR_UFIFOEN_P				12
#define UCR_WRDLEN_P				13
#define UCR_INV_P					15
#define UCR_TXINT_P					16
#define UCR_RXINT_P					17
#define UCR_RXERRINT_P				18
#define UCR_MSINT_P					19
#define UCR_UDINT_P					20
#define UCR_UTXEINT_P				21
#define UCR_URXTINT_P				22
#define UCR_LBM_P					31

#define UFLAG_UBUSY_P				3
#define UFLAG_URXFE_P				4
#define UFLAG_UTXFF_P				5

#define UINT_TXINT_P				0
#define UINT_RXINT_P				1
#define UINT_RXERRINT_P				2
#define UINT_MSINT_P				3
#define UINT_UDINT_P				4
#define UINT_UTXEINT_P				5
#define UINT_URXTINT_P				6

#define UART_RXSTAT_FRAME_P			0
#define UART_RXSTAT_PARITY_P		1
#define UART_RXSTAT_OVERRUN_P		2
#define UART_RXSTAT_ERROR_P			3




#define UART1_DR_LOC				(base_UART1 + UART_DR_offset)
#define UART1_STAT_LOC				(base_UART1 + UART_STAT_offset)
#define UART1_UCR_LOAD_LOC			(base_UART1 + UART_UCR_LOAD_offset)
#define UART1_UCR_SET_LOC			(base_UART1 + UART_UCR_SET_offset)
#define UART1_UCR_CLEAR_LOC			(base_UART1 + UART_UCR_CLEAR_offset)
#define UART1_UBRATE_LOC			(base_UART1 + UART_UBRATE_offset)
#define UART1_UFLAG_LOC				(base_UART1 + UART_UFLAG_offset)
#define UART1_INTM_LOC				(base_UART1 + UART_UINTM_offset)
#define UART1_INT_LOC				(base_UART1 + UART_UINT_offset)
// Aliases
#define UART1_UCR_LOC				UART1_UCR_LOAD_LOC


// Values
#define UART_PARITY_NONE			0
#define UART_PARITY_ODD				(1 << UCR_PRTEN_P)
#define UART_PARITY_EVEN			((1 << UCR_PRTEN_P) | (1 << UCR_EVENPRT_P))

#define UART_ONE_STOP_BIT			0
#define UART_TWO_STOP_BIT			(1 << UCR_XSTOP_P)

#define UART_BIT_LENGTH_16X			0
#define UART_BIT_LENGTH_4X			(1 << UCR_UHBRE_P)
#define UART_BIT_LENGTH_4X_DIRECT	(2 << UCR_UHBRE_P)

#define UART_DATA_LENGTH_8BIT		0
#define UART_DATA_LENGTH_7BIT		(1 << UCR_WRDLEN_P)
#define UART_DATA_LENGTH_6BIT		(2 << UCR_WRDLEN_P)
#define UART_DATA_LENGTH_5BIT		(3 << UCR_WRDLEN_P)

#define UART_NO_RX_TX_FIFO			0
#define UART_USE_RX_TX_FIFO			(1 << UCR_UFIFOEN_P)




//-------------------------------------------------------//
// LCD
//base_LCD

#define LCD_CTRL_LOC				(base_LCD + 0)
#define LCD_STATUS_LOC				(base_LCD + 1)
#define LCD_HTIM_LOC				(base_LCD + 2)
#define LCD_VTIM_LOC				(base_LCD + 3)
#define LCD_HVLEN_LOC				(base_LCD + 4)
#define LCD_HDxTIM_LOC				(base_LCD + 5)
#define LCD_VDxTIM_LOC				(base_LCD + 6)
#define LCD_VSIZE_LOC				(base_LCD + 7)
#define LCD_BACKGND_LOC				(base_LCD + 8)
#define LCD_PXDV_LOC				(base_LCD + 9)
#define LCD_HDTIM_LOC				(base_LCD + 10)
#define LCD_VDTIM_LOC				(base_LCD + 11)
#define LCD_PANEL_CFG_LOC			(base_LCD + 12)
#define LCD_PWM_CR_LOC				(base_LCD + 13)
#define LCD_SLP_PERIOD_LOC			(base_LCD + 14)
#define LCD_TIM_GP0_LOC				(base_LCD + 16)
#define LCD_TIM_GP1_LOC				(base_LCD + 17)
#define LCD_TIM_GP2_LOC				(base_LCD + 18)
#define LCD_TIM_GP3_LOC				(base_LCD + 19)

#define LCD_CTRL_VEN_P				0
#define LCD_CTRL_VIE_P				1
#define LCD_CTRL_HIE_P				2
#define LCD_CTRL_VBIE_P				3
#define LCD_CTRL_SLPIE_P			4
#define LCD_CTRL_VBL_P				7
#define LCD_CTRL_CD_P				9
#define LCD_CTRL_HLDM_P				12
#define LCD_CTRL_HLDV_P				13
#define LCD_CTRL_BL_P				15
#define LCD_CTRL_VBGR_P				17
#define LCD_CTRL_SLP_MODE_P			20
#define LCD_CTRL_SLP_PCLK_P			21
#define LCD_CTRL_SLP_PXEN_P			22
#define LCD_CTRL_SLP_HOLD_P			23
#define LCD_CTRL_SLP_CLRF_P			24


#define LCD_STAT_SINT_P				0
#define LCD_STAT_LUINT_P			1
#define LCD_STAT_STA_SLEEP_P		2
#define LCD_STAT_FIN_SLEEP_P		3
#define LCD_STAT_VINT_P				4
#define LCD_STAT_HINT_P				5
#define LCD_STAT_VBSINT_P			6

#define LCD_HTIM_HPS_P				0
#define LCD_HTIM_HPL_P				15
#define LCD_HTIM_HPW_P				16

#define LCD_VTIM_VPS_P				0
#define LCD_VTIM_VPL_P				15
#define LCD_VTIM_VPW_P				16

#define LCD_HVLEN_HT_P				0
#define LCD_HVLEN_VT_P				16

#define LCD_PXDV_DIV_P				0
#define LCD_PXDV_EN_P				8

#define LCD_HDTIM_HDPS_P			0
#define LCD_HDTIM_HDP_P				16

#define LCD_VDTIM_VDPS_P			0
#define LCD_VDTIM_VDP_P				16

#define LCD_PANEL_TYPE_P			0
#define LCD_PANEL_FPSHI_P			6
#define LCD_PANEL_DVI_MODE_P		9
#define LCD_PANEL_DVI_CLK_P			10

#define LCD_PWM_CLKEN_P				0
#define LCD_PWM_FRSH_P				3
#define LCD_PWM_DV_P				4
#define LCD_PWM_DUTY_P				8
#define LCD_PWM_RELOAD_P			16

#define LCD_GP0_ST_P				0
#define LCD_GP0_HPL_P				15
#define LCD_GP0_SP_P				16

#define LCD_GP1_ST_P				0
#define LCD_GP1_HPL_P				15
#define LCD_GP1_SP_P				16

#define LCD_GP2_ST_P				0
#define LCD_GP2_HPL_P				15
#define LCD_GP2_SP_P				16

#define LCD_GP3_ST_P				0
#define LCD_GP3_HPL_P				15
#define LCD_GP3_SP_P				16

#define LCD_GP4_ST_P				0
#define LCD_GP4_SP_P				16

#define LCD_GP5_WDTH_P				0
#define LCD_GP5_LINE_P				16


//-------------------------------------------------------//
// Video (camera)
#define VIDEO_DR_LOC				(base_VIDEO + 0)
#define VIDEO_SR_LOC				(base_VIDEO + 4)
#define VIDEO_CR_LOC				(base_VIDEO + 5)

#define VIDEO_CR_VCON_P				0
#define VIDEO_CR_VCIE_P				1
#define VIDEO_CR_VCON				(1<<VIDEO_CR_VCON_P)
#define VIDEO_CR_VCIE				(1<<VIDEO_CR_VCIE_P)

#define VIDEO_SR_EMPTY_P			0
#define VIDEO_SR_FULL_P				1
#define VIDEO_SR_OVERF_P			2
#define VIDEO_SR_UNDERF_P			3
#define VIDEO_SR_EMPTY				(1<<VIDEO_SR_EMPTY_P)
#define VIDEO_SR_FULL				(1<<VIDEO_SR_FULL_P)
#define VIDEO_SR_OVERF				(1<<VIDEO_SR_OVERF_P)
#define VIDEO_SR_UNDERF				(1<<VIDEO_SR_UNDERF_P)


//-------------------------------------------------------//
// I2S (AC97)
//base_I2S0
#define AC97_SICR0_offset			0
#define AC97_SINT_offset			1
#define AC97_SICR2_offset			2
#define AC97_SISR_offset			3
#define AC97_SIRSR_offset			4
#define AC97_SIIER_offset			5
#define AC97_SIIDR_offset			6
#define AC97_SIICR_offset			7
#define AC97_SIADR_offset			8
#define AC97_SIMDR_offset			9
#define AC97_ACCAR_offset			10
#define AC97_ACCDR_offset			11
#define AC97_ACSAR_offset			12
#define AC97_ACSDR_offset			13
#define AC97_ACGDR_offset			14
#define AC97_ACGSR_offset			15
#define AC97_I2S_TCR_offset			16
#define AC97_I2S_RCR_offset			17
#define AC97_SICR3_offset			28

#define AC97_SICR2_EREC_P			0
#define AC97_SICR2_ERPL_P			1
#define AC97_SICR2_EINC_P			2
#define AC97_SICR2_EOUT_P			3
#define AC97_SICR2_EGPIO_P			4
#define AC97_SICR2_WKUP_P			5
#define AC97_SICR2_DRSTO_P			6
#define AC97_SICR2_REQLP_P			7


#define AC97_SISR_ATNE_P			5
#define AC97_SISR_ATNF_P			6
#define AC97_SISR_ARNE_P			7
#define AC97_SISR_ATFS_P			8
#define AC97_SISR_ARFS_P			9


#define I2S_TCR_TEN_P				0
#define I2S_TCR_MODE_P				1
#define I2S_TCR_SONY_P				2
#define I2S_TCR_MS_P				3
#define I2S_TCR_DSS_P				4
#define I2S_TCR_PNIS_P				10
#define I2S_TCR_PNOS_P				11
#define I2S_TCR_SWHW_P				12
#define I2S_TCR_PACKH_P				13
#define I2S_TCR_LRSP_P				14

#define I2S_RCR_REN_P				0
#define I2S_RCR_MODE_P				1
#define I2S_RCR_SONY_P				2
#define I2S_RCR_MS_P				3
#define I2S_RCR_DSS_P				4
#define I2S_RCR_PNIS_P				10
#define I2S_RCR_PNOS_P				11
#define I2S_RCR_SWHW_P				12
#define I2S_RCR_LRSP_P				14




//-------------------------------------------------------//
// CMU

#define CMU_CFG1_LOC	(base_CMU + 0)	// CFG_APB
#define CMU_CFG2_LOC	(base_CMU + 1)	// CFG_cPLL
#define CMU_CFG3_LOC	(base_CMU + 2)	// CFG_xPLL
#define CMU_CFG4_LOC	(base_CMU + 3)	// CFG4
#define CMU_CFG5_LOC	(base_CMU + 4)	// CFG_lPLL
#define CMU_SYS_STS_LOC	(base_CMU + 5)
#define CMU_CLKDIS_LOC			(base_CMU + 0x8)
#define CMU_CLKDIS_SET_LOC		(base_CMU + 0x9)
#define CMU_CLKDIS_CLEAR_LOC	(base_CMU + 0xA)

// CPU clock configuration register - alias
#define CPU_CLK_CONFIG_LOC	CMU_CFG4_LOC

// CFG1 (CFG_APB) bits
#define CFG_APB_SYS_WE_P		(3)		// enable multiple writes to SYSCON/SDRCON
#define CFG_APB_ARINC_T0_EN_P	(4)
#define CFG_APB_ARINC_T1_EN_P	(5)
#define CFG_APB_ARINC_T2_EN_P	(6)
#define CFG_APB_ARINC_T3_EN_P	(7)
#define CFG_APB_MIL_DIS_P		(8)

#define CFG_APB_SYS_WE			(1<<CFG_APB_SYS_WE_P)

// SYS_STS register bit description
#define SYS_STS_BOOT0	(1<<0)
#define SYS_STS_BOOT1	(1<<1)
#define SYS_STS_BOOT2	(1<<2)
#define SYS_STS_RST		(1<<6)
#define SYS_STS_POR		(1<<7)
#define SYS_STS_BOOT_MASK	(SYS_STS_BOOT0 | SYS_STS_BOOT1 | SYS_STS_BOOT2)
#define BOOT_MODE_EXTIRQ_BUS16		0
#define BOOT_MODE_EXTIRQ_BUS32		1
#define BOOT_MODE_PARALLEL_FLASH	2
#define BOOT_MODE_SPI_FLASH			3
#define BOOT_MODE_NAND_FLASH		4
#define BOOT_MODE_LINK_1BIT			5
#define BOOT_MODE_LINK_4BIT			6
#define BOOT_MODE_LINK_8BIT			7

// PLL address aliases
#define PLL_CORE_CFG_LOC	CMU_CFG2_LOC
#define PLL_BUS_CFG_LOC		CMU_CFG3_LOC
#define PLL_LINK_CFG_LOC	CMU_CFG5_LOC

// PLL bit positions
#define PLL_DIVR_P			0
#define PLL_DIVF_P			4
#define PLL_DIVQ_P			11
#define PLL_RANGE_P			14
#define PLL_IVCO_P			17
#define PLL_BYPASS_P		20

#define PLL_DIVR_MASK		0x0000000F
#define PLL_DIVF_MASK		0x000007F0
#define PLL_DIVQ_MASK		0x00003800
#define PLL_RANGE_MASK		0x0001C000
#define PLL_IVCO_MASK		0x000E0000
#define PLL_BYPASS_MASK		0x00100000

// CPU clock configuration register bits
#define CPU_CPLL_SEL_P		0
#define CPU_BPLL_SEL_P		1
#define CPU_DIS_CCLK_P		2
#define CPU_DIS_BCLK_P		3
#define CPU_BCLK_SEL_P		4

#define CPU_CPLL_SEL			(1<<CPU_CPLL_SEL_P)
#define CPU_BPLL_SEL			(1<<CPU_BPLL_SEL_P)
#define CPU_DIS_CC				(1<<CPU_DIS_CCLK_P)
#define CPU_DIS_BC				(1<<CPU_DIS_BCLK_P)
#define CPU_BCLK_SEL_BPLL		(0<<CPU_BCLK_SEL_P)
#define CPU_BCLK_SEL_APBDIV1	(1<<CPU_BCLK_SEL_P)
#define CPU_BCLK_SEL_APBDIV2	(2<<CPU_BCLK_SEL_P)
#define CPU_BCLK_SEL_APBDIV4	(4<<CPU_BCLK_SEL_P)

// Clock disable register
#define CMU_CLKDIS_I2S0_P		(0)
#define CMU_CLKDIS_I2S1_P		(1)
#define CMU_CLKDIS_VIDEO_P		(2)
#define CMU_CLKDIS_SPI_P		(3)
#define CMU_CLKDIS_NAND_P		(4)
#define CMU_CLKDIS_ARINC_P		(5)
#define CMU_CLKDIS_MIL0_P		(6)
#define CMU_CLKDIS_MIL1_P		(7)
#define CMU_CLKDIS_ADDA0_P		(8)
#define CMU_CLKDIS_ADDA1_P		(9)
#define CMU_CLKDIS_ADDA2_P		(10)
#define CMU_CLKDIS_ADDA3_P		(11)
#define CMU_CLKDIS_GPS0_P		(12)
#define CMU_CLKDIS_GPS1_P		(13)
#define CMU_CLKDIS_LCD_P		(14)
#define CMU_CLKDIS_UART1_P		(15)
#define CMU_CLKDIS_UART2_P		(16)

#define CMU_CLKDIS_I2S0		(1 << CMU_CLKDIS_I2S0_P)
#define CMU_CLKDIS_I2S1		(1 << CMU_CLKDIS_I2S1_P)
#define CMU_CLKDIS_VIDEO	(1 << CMU_CLKDIS_VIDEO_P)
#define CMU_CLKDIS_SPI		(1 << CMU_CLKDIS_SPI_P)
#define CMU_CLKDIS_NAND		(1 << CMU_CLKDIS_NAND_P)
#define CMU_CLKDIS_ARINC	(1 << CMU_CLKDIS_ARINC_P)
#define CMU_CLKDIS_MIL0		(1 << CMU_CLKDIS_MIL0_P)
#define CMU_CLKDIS_MIL1		(1 << CMU_CLKDIS_MIL1_P)
#define CMU_CLKDIS_ADDA0	(1 << CMU_CLKDIS_ADDA0_P)
#define CMU_CLKDIS_ADDA1	(1 << CMU_CLKDIS_ADDA1_P)
#define CMU_CLKDIS_ADDA2	(1 << CMU_CLKDIS_ADDA2_P)
#define CMU_CLKDIS_ADDA3	(1 << CMU_CLKDIS_ADDA3_P)
#define CMU_CLKDIS_GPS0		(1 << CMU_CLKDIS_GPS0_P)
#define CMU_CLKDIS_GPS1		(1 << CMU_CLKDIS_GPS1_P)
#define CMU_CLKDIS_LCD		(1 << CMU_CLKDIS_LCD_P)
#define CMU_CLKDIS_UART1	(1 << CMU_CLKDIS_UART1_P)
#define CMU_CLKDIS_UART2	(1 << CMU_CLKDIS_UART2_P)


//-------------------------------------------------------//
// LINK

#define LTX_EN_P		0		// enable
#define LTX_VEN_P		1		// verification enable (CRC)
#define LTX_TOEN_P		2		// timeout check IRQ enable
#define LTX_BCMP_P		3		// block completition
#define LTX_DSIZE_P		4		// data size
#define LTX_DRATE_P		6		// data rate
#define LTX_CLKSRC_P	9		// clock source (0 - internal, 1 - external)
#define LTX_CLKINV_P	10		// inversion of clock
#define LTX_ACDC_P		11		// enable ADC / DAC mode 
#define LTX_ACKIGN_P	13		// ignore ACKI

#define LTX_EN			(1 << LTX_EN_P)
#define LTX_VEN			(1 << LTX_VEN_P)
#define LTX_TOEN		(1 << LTX_TOEN_P)
#define LTX_BCMP		(1 << LTX_BCMP_P)
#define LTX_DSIZE_1BIT	(0 << LTX_DSIZE_P)
#define LTX_DSIZE_4BIT	(1 << LTX_DSIZE_P)
#define LTX_DSIZE_8BIT	(2 << LTX_DSIZE_P)
#define LTX_DSIZE_16BIT	(3 << LTX_DSIZE_P)
#define LTX_EXTCLK		(1 << LTX_CLKSRC_P)
#define LTX_CLKINV		(1 << LTX_CLKINV_P)
#define LTX_ACDC		(1 << LTX_ACDC_P)
#define LTX_IGNORE_ACK	(1 << LTX_ACKIGN_P)


#define LRX_EN_P		0		// enable
#define LRX_VEN_P		1		// verification enable (CRC)
#define LRX_TOEN_P		2		// timeout check IRQ enable
#define LRX_BCMP_P		3		// block completition
#define LRX_DSIZE_P		4		// data size
#define LRX_OVRN_P		6		// overrun IRQ enable
#define LRX_GPSCLKEN_P	9		// Enable GPS clock generator
#define LRX_ACDC_P		11		// ADC / DAC mode
#define LRX_CLKSEL_P	16		// source for RX clock: 0 - link0, 1 - link1

#define LRX_EN			(1 << LRX_EN_P)
#define LRX_VEN			(1 << LRX_VEN_P)
#define LRX_TOEN		(1 << LRX_TOEN_P)
#define LRX_BCMP		(1 << LRX_BCMP_P)
#define LRX_DSIZE_1BIT	(0 << LRX_DSIZE_P)
#define LRX_DSIZE_4BIT	(1 << LRX_DSIZE_P)
#define LRX_DSIZE_8BIT	(2 << LRX_DSIZE_P)
#define LRX_DSIZE_16BIT	(3 << LRX_DSIZE_P)
#define LRX_OVRN		(1 << LRX_OVRN_P)
#define LRX_GPSCLKEN	(1 << LRX_GPSCLKEN_P)
#define LRX_ACDC		(1 << LRX_ACDC_P)
#define LRX_CLK_L0		(0 << LRX_CLKSEL_P)
#define LRX_CLK_L1		(1 << LRX_CLKSEL_P)

//-------------------------------------------------------//
// ADA

#define ADA0CR_LOC			(base_ADA0 + 0)
#define ADA0SR_LOC			(base_ADA0 + 1)
#define ADA0STEP_LOC		(base_ADA0 + 2)
#define ADA0DR_LOC			(base_ADA0 + 4)
#define ADA0CR_FREQHOP_LOC	(base_ADA0 + 8)

#define ADA1CR_LOC			(base_ADA1 + 0)
#define ADA1SR_LOC			(base_ADA1 + 1)
#define ADA1STEP_LOC		(base_ADA1 + 2)
#define ADA1DR_LOC			(base_ADA1 + 4)
#define ADA1CR_FREQHOP_LOC	(base_ADA1 + 8)

#define ADA2CR_LOC			(base_ADA2 + 0)
#define ADA2SR_LOC			(base_ADA2 + 1)
#define ADA2STEP_LOC		(base_ADA2 + 2)
#define ADA2DR_LOC			(base_ADA2 + 4)
#define ADA2CR_FREQHOP_LOC	(base_ADA2 + 8)

#define ADA3CR_LOC			(base_ADA3 + 0)
#define ADA3SR_LOC			(base_ADA3 + 1)
#define ADA3STEP_LOC		(base_ADA3 + 2)
#define ADA3DR_LOC			(base_ADA3 + 4)
#define ADA3CR_FREQHOP_LOC	(base_ADA3 + 8)

#define ADACR_EN_P		0
#define ADACR_LINK_P	1
#define ADACR_ROUND_P	2
#define ADACR_SAT_P		3
#define ADACR_ROUNDM_P	4
#define ADACR_TBD_P		5
#define ADACR_IQQI_P	6
#define ADACR_DAM_P		7
#define ADACR_KDELAY_P	8
#define ADACR_SHFR_P	17
#define ADACR_FLEN_P	28
#define ADACR_FREQHOP_P	30
#define ADACR_LINKUSE_P	31

#define ADACR_EN		(1 << ADACR_EN_P)
#define ADACR_LINK		(1 << ADACR_LINK_P)
#define ADACR_ROUND		(1 << ADACR_ROUND_P)
#define ADACR_SAT		(1 << ADACR_SAT_P)
#define ADACR_ROUNDM	(1 << ADACR_ROUNDM_P)
#define ADACR_TBD		(1 << ADACR_TBD_P)
#define ADACR_QI		(1 << ADACR_IQQI_P)
#define ADACR_DAM		(1 << ADACR_DAM_P)
#define ADACR_FLEN3		(0 << ADACR_FLEN_P)
#define ADACR_FLEN5		(1 << ADACR_FLEN_P)
#define ADACR_FLEN7		(2 << ADACR_FLEN_P)
#define ADACR_FREQHOP	(1 << ADACR_FREQHOP_P)
#define ADACR_LINK0		(0 << ADACR_LINKUSE_P)
#define ADACR_LINK1		(1 << ADACR_LINKUSE_P)


#define LCD_CTRL_LOC				(base_LCD + 0)
#define LCD_STATUS_LOC				(base_LCD + 1)
#define LCD_HTIM_LOC				(base_LCD + 2)
#define LCD_VTIM_LOC				(base_LCD + 3)
#define LCD_HVLEN_LOC				(base_LCD + 4)
#define LCD_VSIZE_LOC				(base_LCD + 7)
#define LCD_PXDV_LOC				(base_LCD + 9)
#define LCD_HDTIM_LOC				(base_LCD + 10)
#define LCD_VDTIM_LOC				(base_LCD + 11)
#define LCD_PANEL_CFG_LOC			(base_LCD + 12)
#define LCD_PWM_CR_LOC				(base_LCD + 13)
#define LCD_SLP_PERIOD_LOC			(base_LCD + 14)
#define LCD_TIM_GP0_LOC				(base_LCD + 16)
#define LCD_TIM_GP1_LOC				(base_LCD + 17)
#define LCD_TIM_GP2_LOC				(base_LCD + 18)
#define LCD_TIM_GP3_LOC				(base_LCD + 19)




#endif
