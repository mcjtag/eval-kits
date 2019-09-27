/**
 * @file dmar.c
 * @brief
 * @author matyunin
 * @date 28.07.2017
 */

#include "dmar.h"
#include <stddef.h>
#include <string.h>
#include "system/cpu_defs.h"
#include "utils/assert.h"
#include "utils/tcb.h"
#include "config.h"

struct dmar_chan {
	int chan;
	dmar_callback cb;
	void *param;
	__builtin_quad *dcs_chain;
	__builtin_quad *dcd_chain;
#pragma align(4)
	__builtin_quad dcs;
#pragma align(4)
	__builtin_quad dcd;
#pragma align(4)
	__builtin_quad foo;
};

struct dmar_chan dmar[2] = {
		{.chan = DMAR_0, .cb = NULL, .param = NULL},
		{.chan = DMAR_1, .cb = NULL, .param = NULL}
};

static void dmar_init_chan(struct dmar_chan *dmar);
static void dmar_irq_handler(struct dmar_chan *dmar);
static void dmar_chan0_irq_handler(void);
static void dmar_chan1_irq_handler(void);

/**
 * @brief DMAR initialization
 * @return void
 */
void dmar_init(void)
{
	CONFIG_DMAR_PORT->ddr.clr = (1 << CONFIG_DMAR_PIN_CHAN0) | (1 << CONFIG_DMAR_PIN_CHAN1);
}

/**
 * @brief Start DMAR
 * @param chan Channel number
 * @param cb Poinetr to DMAR callback
 * @param chain Pointer to DMAR chain 
 * @return void
 */
void dmar_start(int chan, struct dmar_callback *cb, struct dmar_chain *chain)
{
	if (!((chan == DMAR_0) || (chan == DMAR_1)))
		return;

	if (cb) {
		dmar[chan].cb = cb->cb;
		dmar[chan].param = cb->param;
	} else {
		dmar[chan].cb = NULL;
		dmar[chan].param = NULL;
	}
	if (chain) {
		dmar[chan].dcs_chain = chain->dcs;
		dmar[chan].dcd_chain = chain->dcd;
	} else {
		dmar[chan].dcs_chain = NULL;
		dmar[chan].dcd_chain = NULL;
	}
	dmar_init_chan(&dmar[chan]);

	HAL_DMA_WriteDCS(dmar[chan].chan, &dmar[chan].dcs);
	HAL_DMA_WriteDCD(dmar[chan].chan, &dmar[chan].dcd);
}

/**
 * @brief Stop DMAR
 * @param chan Channel number
 * @return void
 */
void dmar_stop(int chan)
{
	if (!((chan == DMAR_0) || (chan == DMAR_1)))
		return;

	HAL_DMA_Stop(chan);
}

/**
 * @brief Restart DMAR
 * @param chan Channel number
 * @return void
 */
void dmar_restart(int chan)
{
	HAL_DMA_Stop(chan);
	HAL_DMA_WriteDCS(dmar[chan].chan, &dmar[chan].dcs);
	HAL_DMA_WriteDCD(dmar[chan].chan, &dmar[chan].dcd);
}

/**
 * @brief DMAR chain initialization
 * @param dmar Pointer to DMAR chain structure
 * @return void
 */
static void dmar_init_chan(struct dmar_chan *dmar)
{
	uint32_t flag = TCB_INTMEM | TCB_QUAD | TCB_HPRIORITY | TCB_DMAR;
	uint32_t handler;
	int irq_en = 0;

	if (dmar->dcd_chain && dmar->dcs_chain)
		flag |= TCB_CHAIN;

	TCB_DI(dmar->dcs, &dmar->foo);
	TCB_DX(dmar->dcs, 0, 4);
	TCB_DY(dmar->dcs, 0);
	TCB_DP(dmar->dcs, flag, 0, (uint32_t)dmar->dcs_chain);

	if (dmar->cb) {
		irq_en = 1;
		if (!(flag & TCB_CHAIN))
			flag |= TCB_INT;
	}

	TCB_DI(dmar->dcd, &dmar->foo);
	TCB_DX(dmar->dcd, 0, 4);
	TCB_DY(dmar->dcd, 0);
	TCB_DP(dmar->dcd, flag, 0, (uint32_t)dmar->dcd_chain);

	HAL_DMA_Stop(dmar->chan);
	HAL_DMA_GetChannelStatusClear(dmar->chan);
	HAL_DMA_ClearInterruptRequest(dmar->chan);
	handler = (dmar->chan == DMAR_0) ? (uint32_t)dmar_chan0_irq_handler : (uint32_t)dmar_chan1_irq_handler;
	HAL_DMA_SetInterruptVector(dmar->chan, handler);
	HAL_DMA_SetInterruptMask(dmar->chan, irq_en);
}

/**
 * @brief DMAR interrupt handler
 * @param dmar Pointer to DMAR chain structure
 * @return void
 */
static void dmar_irq_handler(struct dmar_chan *dmar)
{
	dmar->cb(dmar->param);
}

#pragma interrupt
static void dmar_chan0_irq_handler(void)
{
	dmar_irq_handler(&dmar[0]);
}

#pragma interrupt
static void dmar_chan1_irq_handler(void)
{
	dmar_irq_handler(&dmar[1]);
}
