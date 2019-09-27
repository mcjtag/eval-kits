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
struct timer_dev tmr0 = {
		.dev_id = XPAR_TMRCTR_0_DEVICE_ID,
		.vec_id = XPAR_INTC_0_TMRCTR_0_VEC_ID,
		.intc = &intc };
struct iic_dev exp_iic = {
		.dev_id = XPAR_AXI_IIC_GPIO_DEVICE_ID,
		.vec_id = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_AXI_IIC_GPIO_IIC2INTC_IRPT_INTR,
		.intc = &intc };
struct iic_dev tmp_iic = {
		.dev_id = XPAR_DSP_HIER_AXI_IIC_TEMP_DEVICE_ID,
		.vec_id = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_DSP_HIER_AXI_IIC_TEMP_IIC2INTC_IRPT_INTR,
		.intc = &intc };
struct spi_dev vadc_spi = {
		.dev_id = XPAR_DSP_HIER_AXI_QUAD_SPI_VADC_DEVICE_ID,
		.vec_id = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_DSP_HIER_AXI_QUAD_SPI_VADC_IP2INTC_IRPT_INTR,
		.intc = &intc };
struct spi_dev tft_spi = {
		.dev_id = XPAR_TFT_HIER_AXI_QUAD_SPI_DEVICE_ID,
		.vec_id = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_TFT_HIER_AXI_QUAD_SPI_IP2INTC_IRPT_INTR,
		.intc = &intc };
struct spi_opts tft_spi_opts = {
		.cpol = 1,
		.cpha = 1 };
struct gpio_dev tft_gpio = {
		.dev_id = XPAR_TFT_HIER_AXI_GPIO_DEVICE_ID };
struct gpio_dev dsp_reset_gpio = {
		.dev_id = XPAR_DSP_HIER_AXI_GPIO_RESET_DEVICE_ID };
struct gpio_dev led_gpio = {
		.dev_id = XPAR_AXI_GPIO_LED_DEVICE_ID };
struct gpio_dev dsp_core_freq_gpio = {
		.dev_id = XPAR_DSP_HIER_AXI_GPIO_CORE_FREQ_DEVICE_ID };
struct gpio_dev dsp_bus_freq_gpio = {
		.dev_id = XPAR_DSP_HIER_AXI_GPIO_BUS_FREQ_DEVICE_ID };
struct spi_dev aud_spi = {
		.dev_id = XPAR_AUDIO_HIER_AXI_QUAD_SPI_AUDIO_DEVICE_ID,
		.vec_id = XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_AUDIO_HIER_AXI_QUAD_SPI_AUDIO_IP2INTC_IRPT_INTR,
		.intc = &intc
};

/**
 * @brief HAL initialization
 * @return void
 */
int hal_init(void)
{
	intc_init(&intc);
	timer_init(&tmr0);
	iic_init(&exp_iic);
	iic_init(&tmp_iic);
	spi_init(&vadc_spi);
	spi_init(&tft_spi);
	spi_set_opts(&tft_spi, &tft_spi_opts);
	gpio_init(&tft_gpio);
	gpio_init(&dsp_reset_gpio);
	gpio_init(&led_gpio);
	gpio_init(&dsp_core_freq_gpio);
	gpio_init(&dsp_bus_freq_gpio);
	gpio_dir(&led_gpio, 0, 0);
	spi_init(&aud_spi);

	intc_start(&intc);

	return XST_SUCCESS;
}
