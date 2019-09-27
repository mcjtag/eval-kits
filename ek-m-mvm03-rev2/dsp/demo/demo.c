/**
 * @file demo.c
 * @brief DSP demonstration
 * @author matyunin.d
 * @date 02.07.2019
 */
 
#include <stdint.h>
#include <defts201.h>
#include <sysreg.h>
#include <cycle_count.h>
#include <stdio.h>
#include "dma.h"
#include "link.h"

#define bkpt()  asm("emutrap;;")
#define nop()   asm("nop;;")

/* Link Tx Init:      BCMP_EN    DSIZE4     SPD_DIV2 */      
#define LTX_CFG		((1 << 3) | (1 << 4) | (1 << 5))

/* Link Rx Init:      BCMP_EN    DSIZE4 */      
#define LRX_CFG		((1 << 3) | (1 << 4))

#define LINK_BUFSIZE	512

#define DELAY_THRE		3000

static uint32_t ltx_dat[LINK_BUFSIZE];
static uint32_t lrx_dat[LINK_BUFSIZE];

static void sys_init(void);
static unsigned int get_id(void);
static void timer_init(void);
static void timer_irq_handler(void);

static unsigned int flag;

/**
 * @brief Main function
 * @return void
 */
int main(void)
{
	int link, res, i;
	
	sys_init();
	
	/* Flag Init */
	switch (get_id()) {
		case 0:
			flag = 0x0E;
			break;
		case 1:
			flag = 0x0D;
			break;
		case 2:
			flag = 0x0B;
			break;
		case 3:
			flag = 0x07;
			break;
	}
	timer_init();
		
	/* Link Init */
	switch (get_id()) {
		case 0:
			link = 3;
			break;
		case 1:
			link = 3;
			break;
		case 2:
			link = 1;
		break;
		case 3:
			link = 0;
		break;		
	}
	link_init(link, LTX_CFG, LRX_CFG);
	
	while (1) {
		res = link_recv(link, lrx_dat, LINK_BUFSIZE);
		
		for (i = 0; i < res; i++)
			ltx_dat[i] = lrx_dat[i];
		
		link_send(link, ltx_dat, res);
	}
	
	return 0;
}

/**
 * @brief System initialization
 *  - Cluster Bus
 *  - SDRAM controller
 *  - Global interrupt
 *  - Flags' values
 * @return void
 */
void sys_init(void)
{
	unsigned int tmp;
	
	/* Init */
	__builtin_sysreg_write(__INTCTL, 0);
	__builtin_sysreg_write(__IMASKH, 0);
	__builtin_sysreg_write(__IMASKL, 0);
	__builtin_sysreg_write(__SQCTLST, SQCTL_NMOD);
	asm("rds;;");
	
	tmp = SYSCON_MS0_IDLE |
		  SYSCON_MS0_WT3 |
		  SYSCON_MS0_PIPE1 |
		  SYSCON_MS0_SLOW |
		  SYSCON_MS1_IDLE |
		  SYSCON_MS1_WT0 |
		  SYSCON_MS1_PIPE2 |
		  SYSCON_MEM_WID64 |
		  SYSCON_MP_WID64 |
		  SYSCON_HOST_WID64;
		  	
  	__builtin_sysreg_write(__SYSCON, tmp);
  	

	/* SDRAM */
	tmp = SDRCON_ENBL |
		  SDRCON_CLAT2 |
		  SDRCON_PG256 |
		  SDRCON_REF1100 |
		  SDRCON_PC2RAS2 |
		  SDRCON_RAS2PC5 |
		  SDRCON_INIT;

	if (get_id() == 0) {
		__builtin_sysreg_write(__BUSLK, 1);	
		while(__builtin_sysreg_read(__SYSTAT) & (1<<14) == 0);
	}
			
	__builtin_sysreg_write(__SDRCON, tmp);
	
	if (get_id() == 0) {
		while((__builtin_sysreg_read(__SYSTAT) & (1<<13)) == 0);
		__builtin_sysreg_write(__BUSLK, 0);	
	}

	__builtin_sysreg_write(__SQCTLST, SQCTL_GIE);
	__builtin_sysreg_write(__FLAGREG, 0x0F);
}

/**
 * @brief Get DSP ID
 * @return ID
 *
 */
static unsigned int get_id(void)
{
	return __builtin_sysreg_read(__SYSTAT) & 0x3;
}

/** 
 * @brief Timer initialization
 * @return void
 */
static void timer_init(void)
{
	unsigned int tmp;
	unsigned int imask;
	
	__builtin_sysreg_write(__TMRIN0H, 0);
	__builtin_sysreg_write(__TMRIN0L, 10000);
	__builtin_sysreg_write(__ILATCLL, ~INT_TIMER0L);
	__builtin_sysreg_write(__IVTIMER0LP, (unsigned int)timer_irq_handler);
	imask = __builtin_sysreg_read(__IMASKL);
	imask |= 4;
	__builtin_sysreg_write(__IMASKL, imask);
	
	tmp = __builtin_sysreg_read(__INTCTL);
	tmp |= INTCTL_TMR0RN;
	__builtin_sysreg_write(__INTCTL, tmp);
}

/**
 * @brief Timer interrupt handler
 * Flags toggling only
 * @return void
 */
#pragma interrupt
static void timer_irq_handler(void)
{
	static unsigned int delay = 0;
	
	if (delay == (DELAY_THRE - 1)) {
		delay = 0;
		__builtin_sysreg_write(__FLAGREG, flag);
		flag = ~flag & 0x0F;
	} else {
		delay++;
	}
}
