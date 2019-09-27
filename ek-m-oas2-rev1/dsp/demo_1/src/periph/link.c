/**
 * @file link.c
 * @brief
 * @author matyunin.d
 * @date 28.07.2017
 */

#include <string.h>
#include <stddef.h>
#include "system/cpu_defs.h"
#include "periph/link.h"
#include "periph/dmar.h"
#include "utils/assert.h"
#include "utils/tcb.h"
#include "config.h"

#define LT0CTL_0	(0)
#define LT0CTL_1	(LTX_DSIZE_4BIT | LTX_BCMP)
#define LT0CTL_2	(LTX_EN | LT0CTL_1)

static const uint32_t lt0_ini[3] = {LT0CTL_0, LT0CTL_1, LT0CTL_2};

static __builtin_quad lt0_dma_dc;
static link_callback link_cb = NULL;
static void *callback_ref = NULL;

static uint32_t pattern_data[CONFIG_LINK_PATTERN];

static void link_hw_send(uint32_t *buf, uint16_t len);
static void link_dma_irq_handler(void);

/**
 *	@brief Link Tx initialization
 *	@return void
 */
void link_init(void)
{
	uint32_t flag = TCB_INTMEM | TCB_QUAD | TCB_HPRIORITY | TCB_INT;

	TCB_DY(lt0_dma_dc, 0);
	TCB_DP(lt0_dma_dc, flag, 0, 0);
	CONFIG_LINK_PORT->alt.set = (1 << CONFIG_LINK_PIN_BCMPO);
	__builtin_sysreg_write(__LTCTL0, lt0_ini[0]);
	__builtin_sysreg_write(__LTCTL0, lt0_ini[1]);
	__builtin_sysreg_write(__LTCTL0, lt0_ini[2]);
	HAL_DMA_Stop(CONFIG_LINK_DMA);
	HAL_DMA_GetChannelStatusClear(CONFIG_LINK_DMA);
	HAL_DMA_ClearInterruptRequest(CONFIG_LINK_DMA);
	HAL_DMA_SetInterruptVector(CONFIG_LINK_DMA, (uint32_t)link_dma_irq_handler);
	HAL_DMA_SetInterruptMask(CONFIG_LINK_DMA, 1);
	HAL_DMA_SetTxRequestSource(CONFIG_LINK_DMA, TxDmaReq_Default);
}



/**
 * @brief Send data to Link-port
 * @param buf Pointer to data array
 * @param len Length of data array
 * @return void
 */
void link_send(uint32_t *buf, uint16_t len)
{
	link_cb = NULL;
	callback_ref = NULL;
	link_hw_send(buf, len);
}

/**
 * @brief Send data to Link-port with callback
 * @param buf Pointer to data array
 * @param len Length of data array
 * @param cb Pointer to callback function
 * @param cb_ref Pointer to reference for callback
 * @return void
 */
void link_send_callback(uint32_t *buf, uint16_t len, link_callback cb, void *cb_ref)
{
	link_cb = cb;
	callback_ref = cb_ref;
	link_hw_send(buf, len);
}

/**
 * @brief Send pattern
 * @param pattern Pattern
 * @return void
 */
void link_send_pattern(uint32_t length, uint32_t pattern)
{
	int i;

	for (i = 0; i < length; i++)
		pattern_data[i] = pattern;
	link_send(pattern_data, length);
}

/**
 * @brief Link send HW functio n
 * @param buf Pointer to data array
 * @param len Length of data array
 * @return void
 */
static void link_hw_send(uint32_t *buf, uint16_t len)
{
	TCB_DI(lt0_dma_dc, buf);
	TCB_DX(lt0_dma_dc, 4, len);
	HAL_DMA_WriteDC(CONFIG_LINK_DMA, &lt0_dma_dc);
	HAL_DMA_WaitForChannel(CONFIG_LINK_DMA);
}

/**
 * @brief Link Tx done interrupt handler
 * @return void
 */
#pragma interrupt
static void link_dma_irq_handler(void)
{
	if (link_cb)
		link_cb(callback_ref);
}
