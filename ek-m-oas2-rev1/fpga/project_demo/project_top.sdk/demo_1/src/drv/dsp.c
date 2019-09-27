/**
 * @file dsp.c
 * @brief DSP driver
 * @author matyunin.d
 * @date 23.07.2019
 */

#include "dsp.h"
#include "dsp_ioctl.h"
#include "../hal/hal.h"
#include "../lib/calc.h"
#include "syncmaster.h"
#include <string.h>

static dsp_ioctl_dev_t dsp_ioctl_dev;

#define MAGIC				0xA57E00AC

#define DELAY_RESET_MS		100
#define DELAY_WAIT_MS		500
#define LINK_BUFLEN			8192
#define SIGLEN				1024

struct dsp_data {
	unsigned int magic;
	int chan;
	unsigned int len;
	float snr;
	float freq;
	float resv[3];
	float signal[SIGLEN];
};

static struct dsp_meas mdata;

static u32 link_data[LINK_BUFLEN] __attribute__((section(".eram")));
static struct dsp_data tdata;
static struct dsp_data ddata[4];

static const int chan_map[4] = {1, 0, 3, 2};

/**
 * @brief DSP subsystem initialization
 * @return XST_SUCCESS | XST_FAILURE
 */
int dsp_init(void)
{
	int status;

	status = dsp_ioctl_init(&dsp_ioctl_dev, XPAR_DSP_HIER_DSP_IOCTL_0_S_AXI_BASEADDR);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	gpio_clr(&link_gpio, 0, 1);
	dsp_ioctl_reset(&dsp_ioctl_dev, DSP_IOCTL_DEV_ALL, DSP_IOCTL_RESET_ON);
	dma_reset(&link_dma);

	sm_init();

	return XST_SUCCESS;
}

/*
 * @brief Restart DSP subsystem
 * @return void
 */
void dsp_restart(void)
{
	dsp_reset_all();
}

/**
 * @brief Reset DSP
 * @param dsp DSP number (0 or 1)
 * @return void
 */
void dsp_reset(int dsp)
{
	dsp_ioctl_reset(&dsp_ioctl_dev, dsp, DSP_IOCTL_RESET_ON);
	timer_delay(&sys_tmr, DELAY_RESET_MS);
	dsp_ioctl_reset(&dsp_ioctl_dev, dsp, DSP_IOCTL_RESET_OFF);
	timer_delay(&sys_tmr, DELAY_WAIT_MS);
}

/**
 * @brief Reset all DSP, link receivers and DMA
 * @return void
 */
void dsp_reset_all(void)
{
	gpio_clr(&link_gpio, 0, 1);
	dsp_ioctl_reset(&dsp_ioctl_dev, DSP_IOCTL_DEV_ALL, DSP_IOCTL_RESET_ON);
	timer_delay(&sys_tmr, DELAY_RESET_MS);
	dsp_ioctl_reset(&dsp_ioctl_dev, DSP_IOCTL_DEV_ALL, DSP_IOCTL_RESET_OFF);
	timer_delay(&sys_tmr, DELAY_WAIT_MS);
	dma_reset(&link_dma);
	gpio_set(&link_gpio, 0, 1);
}

/**
 * @brief Capture DSP ADC data
 * @return XST_SUCCESS | XST_FAILURE
 */
int dsp_capture(void)
{
	int status;
	int err = 0;
	int chan = 0;

	sm_sync();
	for (int i = 0; i < 4; i++) {
		status = dma_receive(&link_dma, (uint32_t *)link_data, LINK_BUFLEN);
		if (status != XST_SUCCESS) {
			err++;
			continue;
		}
		memcpy((void *)&tdata, (void *)link_data, sizeof(struct dsp_data));
		if (tdata.magic != MAGIC) {
			err++;
			continue;
		}
		if (tdata.chan > 3) {
			err++;
			continue;
		}
		chan = chan_map[tdata.chan];

		ddata[chan].snr = tdata.snr;
		ddata[chan].freq = tdata.freq;

		if (tdata.len > SIGLEN)
			ddata[chan].len = SIGLEN;
		else
			ddata[chan].len = tdata.len;

		for (int i = 0; i < SIGLEN; i++) {
			if (i < tdata.len)
				ddata[chan].signal[i] = tdata.signal[i];
			else
				ddata[chan].signal[i] = 0.0;
		}
	}

	if (err)
		return XST_FAILURE;

	for (int i = 0; i < 4; i++) {
		mdata.rms[i] = calc_std(ddata[i].signal, ddata[i].len);
		mdata.snr[i] = (ddata[i].snr < 0.0) ? 0.0 : ddata[i].snr;
		mdata.freq[i] = ddata[i].freq;
	}

	mdata.ro[0] = calc_pcc(ddata[0].signal, ddata[1].signal, ddata[0].len);
	mdata.ro[1] = calc_pcc(ddata[0].signal, ddata[2].signal, ddata[0].len);
	mdata.ro[2] = calc_pcc(ddata[0].signal, ddata[3].signal, ddata[0].len);
	mdata.ro[3] = calc_pcc(ddata[1].signal, ddata[2].signal, ddata[1].len);
	mdata.ro[4] = calc_pcc(ddata[1].signal, ddata[3].signal, ddata[1].len);
	mdata.ro[5] = calc_pcc(ddata[2].signal, ddata[3].signal, ddata[2].len);

	return XST_SUCCESS;
}

/**
 * @brief Get ADC data
 * @param chan Channel number (0-3)
 * @param data Pointer to data array
 * @param len Length of array
 * @return XST_SUCCESS | XST_FAILURE
 */
int dsp_get_signal(int chan, float *data, unsigned int len)
{
	if (chan > 3)
		return XST_FAILURE;

	for (int i = 0; i < len; i++)
			data[i] = ddata[chan].signal[i];

	return XST_SUCCESS;
}

/**
 * @brief Get measurements
 * @param meas Pointer to measure struct
 * @return void
 */
void dsp_get_meas(struct dsp_meas *meas)
{
	*meas = mdata;
}

