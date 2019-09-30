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
	.dev_id = XPAR_TFT_HIER_AXI_TIMER_PWM_DEVICE_ID,
	.vec_id = 0,
	.intc = NULL };
struct tft_dev tft = {
	.dev_id = XPAR_TFT_HIER_AXI_TFT_DEVICE_ID,
	.width = 480,
	.height = 272,
	.vram_high = XPAR_DDR3_HIER_MIG_7SERIES_0_HIGHADDR,
	.bgcolor = COLOR_BLACK,
	.pwm = &pwm_tmr
};
struct dma_dev adc_dma = {
	.dev_id = XPAR_ADC_HIER_AXI_DMA_0_DEVICE_ID,
	.vec_id_mm2s = -1,
	.vec_id_s2mm = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_ADC_HIER_AXI_DMA_0_S2MM_INTROUT_INTR,
	.mode = 0,
	.timeout = 1000,
	.tmr = &sys_tmr,
	.intc = &intc
};
struct aic_dev adc_aic = {
	.dev_id = XPAR_ADC_HIER_AXIS_INTERCONNECT_0_XBAR_DEVICE_ID
};
struct dma_dev fft_dma = {
	.dev_id = XPAR_FFT_HIER_AXI_DMA_0_DEVICE_ID,
	.vec_id_mm2s = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_FFT_HIER_AXI_DMA_0_MM2S_INTROUT_INTR,
	.vec_id_s2mm = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_FFT_HIER_AXI_DMA_0_S2MM_INTROUT_INTR,
	.mode = DMA_MODE_MM2S_NONBLOCK,
	.timeout = 1000,
	.tmr = &sys_tmr,
	.intc = &intc
};

extern void btn_handler(u32 msk);

struct gpio_dev usr_gpio = {
	.dev_id = XPAR_AXI_GPIO_USR_DEVICE_ID,
	.vec_id = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_AXI_GPIO_USR_IP2INTC_IRPT_INTR,
	.intc = &intc,
	.cb = btn_handler
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
	dma_init(&adc_dma);
	aic_init(&adc_aic);
	dma_init(&fft_dma);
	gpio_init(&usr_gpio);

	intc_start(&intc);

	timer_delay(&sys_tmr, 1000);
	tft_init(&tft);

	return XST_SUCCESS;
}
