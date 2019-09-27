/**
 * @file hal.c
 * @brief HAL
 * @author matyunin.d
 * @date 18.06.2019
 */

#include "hal.h"

/* HAL Device Map */

struct intc_dev intc = {
	.dev_id = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_DEVICE_ID };
struct timer_dev sys_tmr = {
	.dev_id = XPAR_MB_HIER_AXI_TIMER_0_DEVICE_ID,
	.vec_id = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_MB_HIER_AXI_TIMER_0_INTERRUPT_INTR,
	.intc = &intc };
struct timer_dev pwm_tmr = {
	.dev_id = XPAR_AXI_TIMER_0_DEVICE_ID,
	.vec_id = 0,
	.intc = NULL };
struct tft_dev tft = {
	.dev_id = XPAR_AXI_TFT_0_DEVICE_ID,
	.width = 480,
	.height = 272,
	.vram_high = XPAR_DDR3_HIER_MIG_7SERIES_0_HIGHADDR,
	.bgcolor = COLOR_BLACK,
	.pwm = &pwm_tmr
};
struct gpio_dev link_gpio = {
	.dev_id = XPAR_DSP_HIER_LINK_HIER_AXI_GPIO_0_DEVICE_ID
};
struct dma_dev link_dma = {
	.dev_id = XPAR_DSP_HIER_LINK_HIER_AXI_DMA_DEVICE_ID,
	.vec_id_mm2s = -1,
	.vec_id_s2mm = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_DSP_HIER_LINK_HIER_AXI_DMA_S2MM_INTROUT_INTR,
	.timeout = 1000,
	.tmr = &sys_tmr,
	.intc = &intc
};
struct gpio_dev sw_gpio = {
	.dev_id = XPAR_AXI_GPIO_SW_DEVICE_ID
};

/**
 * @brief HAL initialization
 * @return void
 */
int hal_init(void)
{
	intc_init(&intc);
	timer_init(&sys_tmr);
	timer_init(&pwm_tmr);
	tft_init(&tft);
	gpio_init(&link_gpio);
	dma_init(&link_dma);
	gpio_init(&sw_gpio);

	intc_start(&intc);

	return XST_SUCCESS;
}
