/**********************************************************************************************************************
  Copyright (c) 2015 Milandr Corporation. All rights reserved.

  History:
   26.06.2015 Alexey Borozdin - Created
**********************************************************************************************************************/
#ifndef __HAL_TYPEDEF_H_
#define __HAL_TYPEDEF_H_

/************************************************ INCLUDES ***********************************************************/
#include "def1967VC3.h"
#include "stdint.h"


#define __IO			volatile
typedef void (*isr_handler_t)(void);

//--------------------------------------------------------------------------//
//								CMU											//
//--------------------------------------------------------------------------//
typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t reserved0 		:2;
		__IO uint32_t link_bw   		:1;
		__IO uint32_t sys_we    		:1;
		__IO uint32_t arinc_t0_en    :1;
		__IO uint32_t arinc_t1_en    :1;
		__IO uint32_t arinc_t2_en    :1;
		__IO uint32_t arinc_t3_en    :1;
		__IO uint32_t mil_dis    	:1;
		__IO uint32_t reserved1    	:3;
		__IO uint32_t dma_hp_en    	:1;
        __IO uint32_t h_off         :1;
        __IO uint32_t spi1_en    	:1;
        __IO uint32_t spi2_en    	:1;
        __IO uint32_t i2c_alt    	:1;
        __IO uint32_t nand_alt    	:2;
        __IO uint32_t gtmr0_en    	:1;
        __IO uint32_t gtmr1_en    	:1;
        __IO uint32_t reserved2 		:11;
	} field;
} LX_CMU_PeriphCfg_Typedef;		// CFG1


typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t divr 			:4;
		__IO uint32_t divf   		:7;
		__IO uint32_t divq			:3;
		__IO uint32_t range			:3;
		__IO uint32_t reserved0		:3;
		__IO uint32_t bypass			:1;
		__IO uint32_t mux			:2;
		__IO uint32_t reserved1		:9;
	} field;
} LX_CMU_Pll_Typedef;		// CFG2, 3, 5


typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t cpll_sel		:1;
		__IO uint32_t bpll_sel		:1;
		__IO uint32_t dis_cc			:1;
		__IO uint32_t dis_bc			:1;
		__IO uint32_t bclk_sel		:2;
		__IO uint32_t reserved0		:1;
		__IO uint32_t lpll_sel		:1;
		__IO uint32_t reserved1		:24;
	} field;
} LX_CMU_ClockCfg_Typedef;		// CFG4


typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t boot			:3;
		__IO uint32_t reserved0		:1;
		__IO uint32_t l0_bcmp0		:1;
		__IO uint32_t l1_bcmp0		:1;
		__IO uint32_t rst			:1;
		__IO uint32_t por			:1;
		__IO uint32_t reserved1		:24;
	} field;
} LX_CMU_SysStatus_Typedef;		// SYS_STS


typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t I2S0			:1;
		__IO uint32_t I2S1			:1;
		__IO uint32_t VCAM			:1;
        __IO uint32_t SPI0			:1;
		__IO uint32_t NAND			:1;
		__IO uint32_t ARINC			:1;
		__IO uint32_t MIL0			:1;
		__IO uint32_t MIL1			:1;
		__IO uint32_t ADDA0			:1;
		__IO uint32_t ADDA1			:1;
		__IO uint32_t ADDA2			:1;
		__IO uint32_t ADDA3			:1;
		__IO uint32_t GPS0			:1;
		__IO uint32_t GPS1			:1;
		__IO uint32_t LCD			:1;
		__IO uint32_t UART0			:1;		// UART1
		__IO uint32_t UART1			:1;		// UART2
        __IO uint32_t SPI1			:1;
        __IO uint32_t SPI2			:1;
        __IO uint32_t reserved0		:13;
	} field;
} LX_CMU_ClkDis_Typedef;		// CFG8


typedef struct {
	LX_CMU_PeriphCfg_Typedef 	periphCfg;
	LX_CMU_Pll_Typedef			cpuPll;
	LX_CMU_Pll_Typedef			busPll;
	LX_CMU_ClockCfg_Typedef		clockCfg;
	LX_CMU_Pll_Typedef			linkPll;
	LX_CMU_SysStatus_Typedef	sysStatus;
	uint32_t reserved0[2];
	LX_CMU_ClkDis_Typedef		clkDis;
} LX_CMU_Typedef;


#define LX_CMU               ((LX_CMU_Typedef     *) base_CMU)




//--------------------------------------------------------------------------//
//								SPI											//
//--------------------------------------------------------------------------//
typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t dss			:4;
		__IO uint32_t reserved0		:2;
		__IO uint32_t spo			:1;
		__IO uint32_t sph			:1;
		__IO uint32_t twi_on		:1;
		__IO uint32_t twi_rw		:1;
		__IO uint32_t lmsf			:1;
		__IO uint32_t reserved1		:1;
		__IO uint32_t csn			:3;
		__IO uint32_t reserved2		:1;
		__IO uint32_t scr			:12;
		__IO uint32_t reserved3		:4;
	} field;
} LX_SPI_SPCR0_Typedef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t rim			:1;
		__IO uint32_t tim			:1;
		__IO uint32_t lbm			:1;
		__IO uint32_t spe			:1;
		__IO uint32_t ms			:1;
		__IO uint32_t tum			:1;
		__IO uint32_t rom			:1;
		__IO uint32_t reserved0		:1;
		__IO uint32_t r_rqm			:1;
		__IO uint32_t t_rqm			:1;
		__IO uint32_t txo			:1;
		__IO uint32_t rxo			:1;
		__IO uint32_t cim			:1;
		__IO uint32_t reserved1		:1;
		__IO uint32_t hold_cs		:1;
		__IO uint32_t rotl			:1;
		__IO uint32_t cs0al			:1;
		__IO uint32_t cs1al			:1;
		__IO uint32_t cs2al			:1;
		__IO uint32_t cs3al			:1;
		__IO uint32_t cs4al			:1;
		__IO uint32_t cs5al			:1;
		__IO uint32_t cs6al			:1;
		__IO uint32_t cs7al			:1;
		__IO uint32_t reserved2		:8;
	} field;
} LX_SPI_SPCR1_Typedef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t tfe			:1;
		__IO uint32_t tnf			:1;
		__IO uint32_t rne			:1;
		__IO uint32_t bsy			:1;
		__IO uint32_t tfs			:1;
		__IO uint32_t rfs			:1;
		__IO uint32_t ror			:1;
		__IO uint32_t tur			:1;
		__IO uint32_t rff			:1;
		__IO uint32_t reserved2		:23;
	} field;
} LX_SPI_SPSR_Typedef;

typedef struct {
	LX_SPI_SPCR0_Typedef spcr0;
	LX_SPI_SPCR1_Typedef spcr1;
	uint32_t spdr;
	LX_SPI_SPSR_Typedef spsr;
	uint32_t sprxcnt;
} LX_SPI_Typedef;

#define LX_SPI               ((LX_SPI_Typedef     *) base_SPI)      // VN034
#define LX_SPI0              ((LX_SPI_Typedef     *) base_SPI0)     // VN044
#define LX_SPI1              ((LX_SPI_Typedef     *) base_SPI1)     // VN044
#define LX_SPI2              ((LX_SPI_Typedef     *) base_SPI2)     // VN044



//--------------------------------------------------------------------------//
//								PORT (GPIO)									//
//--------------------------------------------------------------------------//

// write 0x01 to LOAD location sets Portx = 0x01
// write 0x01 to SET location sets Portx[0]
// write 0x01 to CLEAR location clears Portx[0]

typedef struct {
	__IO uint32_t reg;
	__IO uint32_t set;
	__IO uint32_t clr;
	__IO uint32_t inv;
} LX_Port_Regs_Typedef;

typedef struct {
	__IO uint32_t reg;
	__IO uint32_t set;
	__IO uint32_t clr;
	__IO uint32_t ddr;
} LX_PxD_Regs_Typedef;

typedef struct {
	__IO uint32_t reg;
	__IO uint32_t set;
	__IO uint32_t clr;
} LX_PxA_Regs_Typedef;



typedef struct {
	LX_Port_Regs_Typedef port;
	LX_Port_Regs_Typedef ddr;
	LX_Port_Regs_Typedef peie;
	LX_Port_Regs_Typedef neie;
	LX_Port_Regs_Typedef inv;
	LX_Port_Regs_Typedef imr;
	LX_Port_Regs_Typedef alt;
	LX_Port_Regs_Typedef pu;
	__IO uint32_t pin;
	__IO uint32_t intreq;
	__IO uint32_t reserved0;
	__IO uint32_t intreqclr;
} LX_Port_Typedef;

typedef struct {
	LX_PxD_Regs_Typedef pxd;
	LX_PxA_Regs_Typedef pxa;
	__IO uint32_t reserved0;
	__IO uint32_t px_alt;
	__IO uint32_t pxd_pin;
	__IO uint32_t pxd_pu;
} LX_PortX_Typedef;

#define LX_PortA               ((LX_Port_Typedef     *) base_GPA)
#define LX_PortB               ((LX_Port_Typedef     *) base_GPB)
#define LX_PortC               ((LX_Port_Typedef     *) base_GPC)
#define LX_PortX               ((LX_PortX_Typedef    *) base_GPX)


//--------------------------------------------------------------------------//
//								UART										//
//--------------------------------------------------------------------------//

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t frame_error	:1;
		__IO uint32_t parity_error	:1;
		__IO uint32_t overrun_error	:1;
		__IO uint32_t any_error		:1;
		__IO uint32_t reserved0		:28;
	} field;
} LX_UART_RXSTAT_Typedef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t uarten		:1;
		__IO uint32_t txdis			:1;
		__IO uint32_t rxdis			:1;
		__IO uint32_t dmaonerr		:1;
		__IO uint32_t txfdis		:1;
		__IO uint32_t rxfdis		:1;
		__IO uint32_t uhbre			:2;
		__IO uint32_t txbreak		:1;
		__IO uint32_t prten			:1;
		__IO uint32_t evenprt		:1;
		__IO uint32_t xstop			:1;
		__IO uint32_t fifoen		:1;
		__IO uint32_t wrdlen		:2;
		__IO uint32_t txdinv		:1;
		__IO uint32_t txinten		:1;
		__IO uint32_t rxinten		:1;
		__IO uint32_t rxerrinten	:1;
		__IO uint32_t msinten		:1;
		__IO uint32_t udinten		:1;
		__IO uint32_t utxeinten		:1;
		__IO uint32_t urxtinten		:1;
		__IO uint32_t reserved0		:8;
		__IO uint32_t lbm			:1;
	} field;
} LX_UART_CR_Typedef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t reserved0		:3;
		__IO uint32_t busy			:1;
		__IO uint32_t rxfe			:1;
		__IO uint32_t txff			:1;
		__IO uint32_t reserved1		:27;
	} field;
} LX_UART_FLAG_Typedef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t txint			:1;
		__IO uint32_t rxint			:1;
		__IO uint32_t rxerrint		:1;
		__IO uint32_t msint			:1;
		__IO uint32_t udint			:1;
		__IO uint32_t utxeint		:1;
		__IO uint32_t urxtint		:1;
		__IO uint32_t reserved0		:25;
	} field;
} LX_UART_INT_Typedef;

typedef struct {
	__IO uint32_t dr;
	LX_UART_RXSTAT_Typedef rxstat;
	LX_UART_CR_Typedef cr;
	LX_UART_CR_Typedef cr_set;
	LX_UART_CR_Typedef cr_clear;
	LX_UART_CR_Typedef brate;
	LX_UART_FLAG_Typedef flag;
	LX_UART_INT_Typedef uintm;
	LX_UART_INT_Typedef uint;
} LX_Uart_Typedef;

#define LX_UART0               ((LX_Uart_Typedef     *) base_UART0)
#define LX_UART1               ((LX_Uart_Typedef     *) base_UART1)


//--------------------------------------------------------------------------//
//								LCD											//
//--------------------------------------------------------------------------//


typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t en:1;			// master enable
		__IO uint32_t vie:1;		// frame complete irq enable
		__IO uint32_t hie:1;		// string complete irq enabe
		__IO uint32_t vbie:1;		// whole buff complete irq enable
		__IO uint32_t slpie:1;		// wakeup irq enable
		__IO uint32_t r1:2;			// reserved
		__IO uint32_t vbl:2;		// out pixel layout					//5-6-5 -> 8-8-8
		__IO uint32_t cd:2;			// input pixel layout
		__IO uint32_t r2:1;			// reserved
		__IO uint32_t hdlm:1;
		__IO uint32_t hldv:1;		// 
		__IO uint32_t r3:1;			// reserved
		__IO uint32_t bl:1;			// active ready
		__IO uint32_t r4:1;			// reserved
		__IO uint32_t vbgr:1;		// RGB(0) or GBR(1) mode
		__IO uint32_t r5:2;			// reserved
		__IO uint32_t slp_mode:1;	// sleep mode after buff complete
		__IO uint32_t slp_pclk:1;
		__IO uint32_t slp_pxen:1;	// 
		__IO uint32_t slp_hold:1;	// 
		__IO uint32_t slp_clrf:1;	// auto lear flags
		__IO uint32_t r6:3;			// reserved
		__IO uint32_t W2W_en:1;		// extra window enable
		__IO uint32_t PXP_en:1;		// pixelclock stop on empty FIFO
	} field;
} LX_LCD_CTRL_TypeDef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t r1:1;			// reserved
		__IO uint32_t luint:1;		// 
		__IO uint32_t sta_sleep:1;	// 
		__IO uint32_t fin_sleep:1;	// 
		__IO uint32_t hint:1;		// 
		__IO uint32_t vbsint:1;		// 
		__IO uint32_t r2:14;		// reserved
		__IO uint32_t sleep_exe:1;
		__IO uint32_t r3:11;		// reserved
	} field;
} LX_LCD_STAT_TypeDef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t ps:10;		// start position 	(+1)
		__IO uint32_t r1:5;			// reserved
		__IO uint32_t pl:1;			// active level		(0-high,1-low)
		__IO uint32_t pw:10;		// end position		(+1)
		__IO uint32_t r2:6;			// reserved
	} field;
} LX_LCD_HVTIM_TypeDef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t ps:10;		// active start position 	(+1)
		__IO uint32_t r1:6;			// reserved
		__IO uint32_t pe:10;		// active end position		(+1)
		__IO uint32_t r2:6;			// reserved
	} field;
} LX_LCD_HVDTIM_TypeDef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t ht:7;			// horizontal size
		__IO uint32_t r1:9;			// reserved
		__IO uint32_t vt:10;		// vertical size
		__IO uint32_t r2:6;			// reserved
	} field;
} LX_LCD_HVLEN_TypeDef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t size:20;		// sizeof video buffer 
		__IO uint32_t r1:12;		// reserved
	} field;
} LX_LCD_VSIZE_TypeDef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t div:8;		// division value
		__IO uint32_t en:1;			// division is on
		__IO uint32_t r1:23;		// reserved
	} field;
} LX_LCD_PXDV_TypeDef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t B:8;			// blue
		__IO uint32_t G:8;			// green
		__IO uint32_t R:8;			// red
		__IO uint32_t r1:8;			// reserved
	} field;
} LX_LCD_BACKGND_TypeDef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t r1:6;			// reserved
		__IO uint32_t fpshi:1;		// inverted pixelclk
		__IO uint32_t r2:2;			// reserved
		__IO uint32_t DVI_mode:1;	// always write 0
		__IO uint32_t DVI_clk:1;	// always write 0
		__IO uint32_t r3:21;		// reserved
	} field;
} LX_LCD_PAN_TypeDef;

typedef union {
	uint32_t reg;
	struct {
		__IO uint32_t en:1;			// clock enable
		__IO uint32_t r1:2;			// reserved
		__IO uint32_t frsh:1;		// pwm out always high
		__IO uint32_t dv:4;			// pwm division (+1)
		__IO uint32_t duty:8;		// high pulse width
		__IO uint32_t reload:8;		// 
		__IO uint32_t r3:8;			// reserved
	} field;
} LX_LCD_PWM_TypeDef;

typedef struct LX_LCD_TypeDef
{
	LX_LCD_CTRL_TypeDef		CTRL;
	LX_LCD_STAT_TypeDef		STATUS;
	LX_LCD_HVTIM_TypeDef	HTIM;
	LX_LCD_HVTIM_TypeDef	VTIM;
	LX_LCD_HVLEN_TypeDef	HVLEN;
	LX_LCD_HVDTIM_TypeDef	HDxTIM;
	LX_LCD_HVDTIM_TypeDef	VDxTIM;
	LX_LCD_VSIZE_TypeDef	VSIZE;
	LX_LCD_BACKGND_TypeDef	BACKGND;
	LX_LCD_PXDV_TypeDef		PXDV;
	LX_LCD_HVDTIM_TypeDef	HDTIM;
	LX_LCD_HVDTIM_TypeDef	VDTIM;
	LX_LCD_PAN_TypeDef		PANEL_CFG;
	LX_LCD_PWM_TypeDef		PWM_CR;
	uint32_t				SLP_PERIOD;
	uint32_t				reserved0;
	uint32_t				TIM_GP0;
	uint32_t				TIM_GP1;
	uint32_t				TIM_GP2;
	uint32_t				TIM_GP3;
} LX_LCD_TypeDef;

#define LX_LCD               ((LX_LCD_TypeDef     *) base_LCD)



//--------------------------------------------------------------------------//
//								Camera										//
//--------------------------------------------------------------------------//

typedef union 
{
	__IO uint32_t reg;
	struct {
		__IO uint32_t vcon		:1;
		__IO uint32_t vcie		:1;
		__IO uint32_t smode 	:1;
		__IO uint32_t reserved0	:29;
	} field;
} LX_VCAM_CR_TypeDef;


typedef union 
{
	__IO uint32_t reg;
	struct {
		__IO uint32_t empty		:1;
		__IO uint32_t full		:1;
		__IO uint32_t overflow 	:1;
		__IO uint32_t underflow :1;
		__IO uint32_t reserved0	:28;
	} field;
} LX_VCAM_SR_TypeDef;

typedef struct
{
	__builtin_quad dr;
	LX_VCAM_SR_TypeDef sr;
	LX_VCAM_CR_TypeDef cr;
} LX_VCAM_TypeDef;

#define LX_VCAM               ((LX_VCAM_TypeDef     *) base_VIDEO)



//--------------------------------------------------------------------------//
//								  I2S										//
//--------------------------------------------------------------------------//

typedef union 
{
	__IO uint32_t reg;
	struct {
		__IO uint32_t enb	:1;
		__IO uint32_t r1 	:1;
		__IO uint32_t moden  :1;
		__IO uint32_t amcch  :1;
		__IO uint32_t rst    :1;
		__IO uint32_t lpbk	:1;
		__IO uint32_t bckd  	:1;
		__IO uint32_t mono_da:1;
		__IO uint32_t bit8_da:1;
		__IO uint32_t mono_ad:1;
		__IO uint32_t bit8_ad:1;
        __IO uint32_t to_en:1;
        __IO uint32_t div_en:1;
        __IO uint32_t r2:19;//32
	} field;
} LX_I2S_SICR0_TypeDef;

typedef union 
{
	__IO uint32_t reg;
	struct {
		__IO  uint32_t erec :1;
		__IO  uint32_t erpl :1;
		__IO  uint32_t  einc :1;
		__IO  uint32_t eout :1;
		__IO  uint32_t egpio :1;
		__IO uint32_t wkup :1;
		__IO  uint32_t drsto :1;
		__IO  uint32_t reqlp :16;
		__IO  uint32_t r1:9; //32
	} field;
} LX_I2S_SICR2_TypeDef;


typedef union 
{
	__IO uint32_t reg;
	struct {
		__IO uint32_t comsel :1;
		__IO uint32_t c2id :2;
		__IO uint32_t  dma_en:1;
		__IO uint32_t  reld:1;
		__IO uint32_t  rx:1;
		__IO uint32_t r1: 26;//32
	} field;
} LX_I2S_SICR3_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {
        __IO	uint32_t dtd  : 1 ;
        __IO uint32_t rdd  : 1 ;
        __IO uint32_t gtd  : 1 ;
        __IO uint32_t r1  : 1 ;
        __IO uint32_t bsy  : 1 ;
        __IO uint32_t atne : 1 ;
        __IO uint32_t atnf : 1 ;
        __IO uint32_t arne : 1 ;
        __IO uint32_t atfs : 1 ;
        __IO uint32_t arfs : 1 ;
        __IO uint32_t atur : 1 ;
        __IO uint32_t aror : 1 ;
        __IO uint32_t mtnf : 1 ;
        __IO uint32_t mrne : 1 ;
        __IO uint32_t mtfs : 1 ;
        __IO uint32_t mrfs : 1 ;
        __IO uint32_t mtur : 1 ;
        __IO uint32_t mror : 1 ;
        __IO uint32_t rsto : 1 ;
        __IO uint32_t clpm : 1 ;
        __IO uint32_t crdypr : 1 ;
        __IO uint32_t crdysc : 1 ;
        __IO uint32_t resu : 1 ;
        __IO uint32_t gint : 1 ;
        __IO uint32_t rs3v : 1 ;
        __IO uint32_t rs4v : 1 ;
        __IO uint32_t rs5v : 1 ;
        __IO uint32_t rs12v : 1 ;
        __IO uint32_t dma_int : 1 ;
        __IO uint32_t r2  : 3 ;//32
    } field;
} LX_I2S_SISR_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {
        __IO	uint32_t dtd  : 1 ;
        __IO uint32_t rdd  : 1 ;
        __IO uint32_t gtd  : 1 ;
        __IO uint32_t r1  : 1 ;
        __IO uint32_t bsy  : 1 ;
        __IO uint32_t atne : 1 ;
        __IO uint32_t atnf : 1 ;
        __IO uint32_t arne : 1 ;
        __IO uint32_t atfs : 1 ;
        __IO uint32_t arfs : 1 ;
        __IO uint32_t atur : 1 ;
        __IO uint32_t aror : 1 ;
        __IO uint32_t mtnf : 1 ;
        __IO uint32_t mrne : 1 ;
        __IO uint32_t mtfs : 1 ;
        __IO uint32_t mrfs : 1 ;
        __IO uint32_t mtur : 1 ;
        __IO uint32_t mror : 1 ;
        __IO uint32_t rsto : 1 ;
        __IO uint32_t clpm : 1 ;
        __IO uint32_t crdypr : 1 ;
        __IO uint32_t crdysc : 1 ;
        __IO uint32_t resu : 1 ;
        __IO uint32_t gint : 1 ;
        __IO uint32_t rs3v : 1 ;
        __IO uint32_t rs4v : 1 ;
        __IO uint32_t rs5v : 1 ;
        __IO uint32_t rs12v : 1 ;
        __IO uint32_t dma_int : 1 ;
        __IO uint32_t r2  : 1 ;
    } field;
} LX_I2S_SIRSR_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {
        __IO uint32_t dtd  : 1 ;
        __IO uint32_t rdd  : 1 ;
        __IO uint32_t gtd  : 1 ;
        __IO uint32_t r1  : 5 ;
        __IO uint32_t atfs : 1 ;
        __IO uint32_t arfs : 1 ;
        __IO uint32_t atur : 1 ;
        __IO uint32_t aror : 1 ;
        __IO uint32_t r2  : 2 ;
        __IO uint32_t mtfs : 1 ;
        __IO uint32_t mrfs : 1 ;
        __IO uint32_t mtur : 1 ;
        __IO uint32_t mror : 1 ;
        __IO uint32_t rsto : 1 ;
        __IO uint32_t r3  : 3 ;
        __IO uint32_t resu : 1 ;
        __IO uint32_t gint : 1 ;
        __IO uint32_t r4  : 4 ;
        __IO uint32_t dma_int : 1 ;
        __IO uint32_t r5  : 2 ;//32

    } field;
} LX_I2S_SIIER_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {
        __IO uint32_t dtd  : 1 ;
        __IO uint32_t rdd  : 1 ;
        __IO uint32_t gtd  : 1 ;
        __IO uint32_t r1  : 5 ;
        __IO uint32_t atfs : 1 ;
        __IO uint32_t arfs : 1 ;
        __IO uint32_t atur : 1 ;
        __IO uint32_t aror : 1 ;
        __IO uint32_t r2  : 2 ;
        __IO uint32_t mtfs : 1 ;
        __IO uint32_t mrfs : 1 ;
        __IO uint32_t mtur : 1 ;
        __IO uint32_t mror : 1 ;
        __IO uint32_t rsto : 1 ;
        __IO uint32_t r3  : 3 ;
        __IO uint32_t resu : 1 ;
        __IO uint32_t gint : 1 ;
        __IO uint32_t r4  : 4 ;
        __IO uint32_t dma_int : 1 ;
        __IO uint32_t r5  : 2 ;//32

    } field;
} LX_I2S_SIIDR_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {
        __IO uint32_t dtd  : 1 ;
        __IO uint32_t rdd  : 1 ;
        __IO uint32_t gtd  : 1 ;
        __IO uint32_t r1  : 5 ;
        __IO uint32_t atfs : 1 ;
        __IO uint32_t arfs : 1 ;
        __IO uint32_t atur : 1 ;
        __IO uint32_t aror : 1 ;
        __IO uint32_t r2  : 2 ;
        __IO uint32_t mtfs : 1 ;
        __IO uint32_t mrfs : 1 ;
        __IO uint32_t mtur : 1 ;
        __IO uint32_t mror : 1 ;
        __IO uint32_t rsto : 1 ;
        __IO uint32_t r3  : 3 ;
        __IO uint32_t resu : 1 ;
        __IO uint32_t gint : 1 ;
        __IO uint32_t r4  : 4 ;
        __IO uint32_t dma_int : 1 ;
        __IO uint32_t r5  : 2 ;//32

    } field;
} LX_I2S_SIICR_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {
        __IO uint32_t r1:12;
        __IO uint32_t ix:7;
        __IO uint32_t rw:1;
        __IO uint32_t r2:12;//32

    } field;
} LX_I2S_ACCAR_TypeDef;


typedef union
{
    __IO uint32_t reg;
    struct {
        __IO uint32_t r1:4;
        __IO uint32_t cdr:16;
        __IO uint32_t r2:12;//32

    } field;
} LX_I2S_ACCDR_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {
        __IO uint32_t r1:12;
        __IO uint32_t sar:7;
        __IO uint32_t r2:13;//32

    } field;
} LX_I2S_ACSAR_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {
        __IO uint32_t r4:4;
        __IO uint32_t sdr:16;
        __IO uint32_t r2:12;

    } field;
} LX_I2S_ACSDR_TypeDef;


typedef union
{
    __IO uint32_t reg;
    struct {
        __IO uint32_t r4:4;
        __IO uint32_t gdat:16;
        __IO uint32_t r2:12;

    } field;
} LX_I2S_ACGDR_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {
        __IO uint32_t r4:4;
        __IO uint32_t sdr:16;
        __IO uint32_t r2:12;

    } field;
} LX_I2S_ACGSR_TypeDef;

typedef union
{
    __IO uint32_t reg;
    struct {

        __IO uint32_t ten  : 1 ;
        __IO uint32_t mode : 1 ;
        __IO uint32_t sony : 1 ;
        __IO uint32_t ms  : 1 ;
        __IO uint32_t dss  : 6 ;
        __IO uint32_t pnis : 1 ;
        __IO uint32_t pnos : 1 ;
        __IO uint32_t swhw : 1 ;
        __IO uint32_t packh : 1 ;
        __IO uint32_t lrsp : 1 ;
        __IO uint32_t r1:17;
    } field;
} LX_I2S_TCR_TypeDef;



typedef union
{
	//Документация и def1967VC3 не совпадают
    __IO uint32_t reg;
    struct {
	__IO	uint32_t	ren		:	1	;
	__IO	uint32_t	mode	:	1	;
	__IO	uint32_t	sony	:	1	;
	__IO	uint32_t	ms		:	1	;
	__IO	uint32_t	dss		:	6	;
	__IO	uint32_t	pnis	:	1	;
	__IO	uint32_t	pnos	:	1	;
	__IO	uint32_t	swhw	:	1	;
	__IO	uint32_t	r1		:	1	;
	__IO	uint32_t	lrsp	:	1	;
	__IO	uint32_t	r2		:	1	;
	__IO uint32_t r3:17;

    } field;
} LX_I2S_RCR_TypeDef;

typedef struct
{
        LX_I2S_SICR0_TypeDef sicr0 ;
       	uint32_t  r1 ;
        LX_I2S_SICR2_TypeDef sicr2 ;
        LX_I2S_SISR_TypeDef  sisr ;
        LX_I2S_SIRSR_TypeDef sirsr ;
        LX_I2S_SIIER_TypeDef siier ;
        LX_I2S_SIIDR_TypeDef siidr ;
        LX_I2S_SIICR_TypeDef siicr ;
        uint32_t siadr ;
        uint32_t simdr ;
        LX_I2S_ACCAR_TypeDef accar ;
        LX_I2S_ACCDR_TypeDef accdr ;
        LX_I2S_ACSAR_TypeDef acsar ;
        LX_I2S_ACSDR_TypeDef acsdr ;
        LX_I2S_ACGDR_TypeDef acgdr ;
        LX_I2S_ACGSR_TypeDef acgsr ;
        LX_I2S_TCR_TypeDef tcr ;
        LX_I2S_RCR_TypeDef rcr ;
	    uint32_t r2;
	    uint32_t r3;
	    uint32_t r4;
	    uint32_t r5;
	    uint32_t r6;
	    uint32_t r7;
	    uint32_t r8;
	    uint32_t r9;
	    uint32_t r10;
	    uint32_t r11;
	    uint32_t r12;
        LX_I2S_SICR3_TypeDef sicr3;
} LX_I2S_TypeDef;

#define LX_I2S0 ((LX_I2S_TypeDef*) base_I2S0)
#define LX_I2S1 ((LX_I2S_TypeDef*) base_I2S1)





#endif
