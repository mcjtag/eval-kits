/**
 * @file main.c
 * @brief Main
 * @author matyunin.d
 * @date 31.07.2019
 */

#include <stdio.h>
#include "platform.h"
#include "hal/hal.h"
#include "logo.h"

#include "hmc1031.h"
#include "hmc1033.h"
#include "xparameters.h"
#include "adc8.h"
#include "adc8_tcb.h"
#include "syncron.h"

#include "lib/meas.h"
#include "gui/gui.h"

#define DST_CHAN	((0 << 6) | (1 << 5) | (3 << 3) | 1)

#define CHAN_NUM	8
#define CHAN_SIZE	(8192)
#define CHAN_BUF	8192

#define SPEC_SIZE	512
#define DECIM		(CHAN_SIZE / (446*2))

enum GUI_MODE {
	GUI_MODE_TABLE,
	GUI_MODE_OSCIL,
	GUI_MODE_SPECT
};

static hmc1031_dev_t hmc1;
static hmc1033_dev_t hmc3;
static struct hmc1033_config cfg;
static adc8_dev_t adc8;
static syncron_dev_t syncron_dev;
static adc8_tcb_dev_t adc_tcb;

static float adc_data[CHAN_NUM][CHAN_BUF] __attribute__((section(".eram")));
static float adc_data_l[CHAN_BUF];
static float adc_data_s[CHAN_NUM][SPEC_SIZE];

static u8 dst_cfg[] = {
		DST_CHAN, DST_CHAN, 0,
		DST_CHAN, DST_CHAN, 0,
		DST_CHAN, DST_CHAN, 0,
		DST_CHAN, DST_CHAN, 0,
		0, 0, 3,
		0, 3, 0,
		3, 0, 3,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 1, 0,
		2, 3, 3
};

static struct adc_config adc_cfg = { .out_mode = 0x32 };

static struct gtable gtbl = {
	.cell = {
		{
			{"", 0}, {"Vmax", COLOR_CYAN}, {"Vrms", COLOR_CYAN}, {"SNR", COLOR_CYAN}, {"FREQ", COLOR_CYAN},
			{"PCC0", COLOR_CYAN}, {"PCC1", COLOR_CYAN}, {"PCC2", COLOR_CYAN}, {"PCC3", COLOR_CYAN},
			{"PCC4", COLOR_CYAN}, {"PCC5", COLOR_CYAN}, {"PCC6", COLOR_CYAN}, {"PCC7", COLOR_CYAN}
		},
		{
			{"#0", COLOR_CYAN}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
		},
		{
			{"#1", COLOR_CYAN}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
		},
		{
			{"#2", COLOR_CYAN}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
		},
		{
			{"#3", COLOR_CYAN}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
		},
		{
			{"#4", COLOR_CYAN}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
		},
		{
			{"#5", COLOR_CYAN}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
		},
		{
			{"#6", COLOR_CYAN}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
		},
		{
			{"#7", COLOR_CYAN}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
		}
	}
};

struct gosc_data godat;
struct gspe_data gsdat;

static u8 chan_active;
static float snr[CHAN_NUM];
static float max[CHAN_NUM];
static float rms[CHAN_NUM];
static float fre[CHAN_NUM];
static float pcc[CHAN_NUM][CHAN_NUM];

int gui_mode = -1;

void update_table(void);
void btn_handler(u32 msk);

/**
 * @brief main function
 * @return 0
 */
int main()
{
	int calib_cnt = 0;

	init_platform();

	hal_init();

	/* Show Logo */
	tft_draw_bitmap(&tft, 70, 88, logo);
	tft_resync(&tft);
	timer_delay(&sys_tmr, 3000);
	tft_clear(&tft);
	tft_resync(&tft);

	tft_resync_swap(&tft);
	tft_set_color(&tft, COLOR_LIME, COLOR_BLACK);
	tft_printf(&tft, "Setup clock...        ");

	/* Setup clock */
	/* Configure HMC1031 */
	hmc1031_init(&hmc1, XPAR_CLOCK_HIER_HMC1031_0_S_AXI_BASEADDR);
	hmc1031_divider(&hmc1, HMC1031_DIVIDER_PD);
	hmc1031_divider(&hmc1, HMC1031_DIVIDER_DIV5);

	/* Configure HMC1033 */
	hmc1033_init(&hmc3, XPAR_CLOCK_HIER_HMC1033_0_S_AXI_BASEADDR);
	hmc1033_calculate(25000000.0, 125000000.0, &cfg);
	hmc1033_apply(&hmc3, &cfg);

	timer_delay(&sys_tmr, 1000);
	tft_printf(&tft, "done\n\n");

	/* Configure syncron for ESYNC source */
	syncron_init(&syncron_dev, XPAR_ADC_HIER_SYNCRON_0_S_AXI_BASEADDR);
	syncron_set_source(&syncron_dev, SYNCRON_SOURCE_INTERNAL);

	tft_printf(&tft, "Setup ADC8:DIST...    ");
	/* Setup ADC8 */
	timer_delay(&sys_tmr, 500);
	adc8_init(&adc8, XPAR_ADC_HIER_ADC8_0_S_AXI_BASEADDR);
	adc8_adc_if_reset(&adc8, 1);
	adc8_dst_esync(&adc8, 1);			/* Use external sync */
	adc8_dst_reset(&adc8, 1);			/* Reset ADC8 clock buffer */
	timer_delay(&sys_tmr, 100);
	adc8_dst_reset(&adc8, 0);
	timer_delay(&sys_tmr, 100);
	adc8_dst_powerdown(&adc8, 0);
	adc8_dst_refsel(&adc8, 1);			/* Select reference */
	adc8_dst_config(&adc8, dst_cfg);	/* Configure clock buffer */
	timer_delay(&sys_tmr, 300);
	tft_printf(&tft, "done\n\n");
	tft_printf(&tft, "Setup ADC8:ADC...     ");
	adc8_adc_bias(&adc8, 0);			/* Set adc bias */
	adc8_adc_config(&adc8, &adc_cfg);	/* Configure ADC */
	timer_delay(&sys_tmr, 300);
	tft_printf(&tft, "done\n\n");
	tft_printf(&tft, "Calibrate ADC8:ADC... ");
	adc8_adc_calibrate(&adc8);			/* Start calibration */
	timer_delay(&sys_tmr, 300);
	tft_printf(&tft, "done\n\n");
	tft_printf(&tft, "Calibrate IO...       ");
	timer_delay(&sys_tmr, 1);
	adc8_adc_if_reset(&adc8, 0);
	adc8_adc_if_reset(&adc8, 1);
	timer_delay(&sys_tmr, 1);
	adc8_adc_if_reset(&adc8, 0);
	timer_delay(&sys_tmr, 100);
	for (;;) {							/* ADC receivers calibration */
		syncron_sync(&syncron_dev, SYNCRON_SYNC_CAPTURE);
		timer_delay(&sys_tmr, 5);
		calib_cnt++;
		if (!adc8_calib_done(&adc8))
			break;
	}
	adc8_out_valid(&adc8, 1);			/* ADC8 is ready */
	tft_printf(&tft, "done\n\n");

	/* GUI selection */
	tft_printf(&tft, "\n\nChoose viewer: (default 'A')\n");
	tft_printf(&tft, "A: Table\n");
	tft_printf(&tft, "B: Oscilloscope\n");
	tft_printf(&tft, "C: Spectrum Analyzer\n");
	for (int i = 0; i < 5; i++) {
		tft_set_pos(&tft, 0, 200);
		tft_printf(&tft, "... %d\r", 5-i);
		timer_delay(&sys_tmr, 1000);
		if (gui_mode != -1)
			break;
		if (i == 4)
			gui_mode = GUI_MODE_TABLE;
	}

	tft_printf(&tft, "\n\n\nStarting...");
	timer_delay(&sys_tmr, 1000);
	tft_resync_swap(&tft);

	/* TCB configuration */
	adc8_tcb_init(&adc_tcb, XPAR_ADC_HIER_ADC8_TCB_0_S_AXI_BASEADDR);
	adc8_tcb_set_length(&adc_tcb, CHAN_SIZE);
	adc8_tcb_set_norm(&adc_tcb, 1.0/32768.0); 	/* Divider 2**15 */
	adc8_tcb_set_offt(&adc_tcb, -1.0);			/* Offset -1.0 */
	adc8_tcb_set_format(&adc_tcb, ADC8_TCB_FORMAT_FLOAT); /* Output float single */

	meas_init();
	for (int i = 0; i < 8; i++)
		godat.data[i] = adc_data[i];
	for (int i = 0; i < 8; i++)
		gsdat.data[i] = adc_data_s[i];

	u32 chan_msk;

	for (;;) {
		/* Get active channels */
		gpio_read(&usr_gpio, 1, &chan_msk);
		chan_active = (~chan_msk & 0xFF);

		/* Start TCB transaction */
		adc8_tcb_start(&adc_tcb);
		/* Start DMA transactions*/
		for (int i = 0; i < CHAN_NUM; i++) {
			aic_disable_all(&adc_aic);
			aic_enable(&adc_aic, i, 0);
			dma_receive(&adc_dma, (u32 *)adc_data[i], CHAN_SIZE*sizeof(u32));
		}

		/* Meas and show */
		switch (gui_mode) {
		case GUI_MODE_TABLE:
			for (int i = 0; i < CHAN_NUM; i++) {
				if (chan_active & (1 << i)) {
					memcpy(adc_data_l, adc_data[i], CHAN_SIZE*sizeof(float));
					snr[i] = meas_snr(adc_data_l, CHAN_SIZE, 125.0, 6, &fre[i]);
					max[i] = meas_max(adc_data_l, CHAN_SIZE, NULL);
					rms[i] = meas_std(adc_data_l, CHAN_SIZE);
					for (int j = 0; j < CHAN_NUM; j++)
						if (i != j)
							pcc[i][j] = meas_pcc(adc_data[i], adc_data[j], CHAN_SIZE);
				}
			}
			update_table();
			gui_table(&gtbl);
			timer_delay(&sys_tmr, 100);
			break;
		case GUI_MODE_OSCIL:
			godat.active = chan_active;
			gui_oscil(&godat);
			timer_delay(&sys_tmr, 100);
			break;
		case GUI_MODE_SPECT:
			gsdat.active = chan_active;
			for (int i = 0; i < CHAN_NUM; i++) {
				if (gsdat.active & (1 << i)) {
					memcpy(adc_data_l, adc_data[i], CHAN_SIZE*sizeof(float));
					meas_dbv(adc_data_l, adc_data_l, CHAN_SIZE);
					int c = 0;
					for (int j = 0; j < CHAN_SIZE/2; j++)
						if (j % DECIM == 0)
							adc_data_s[i][c++] = adc_data_l[j] / 120.0;
				}
			}
			gui_spect(&gsdat);
			timer_delay(&sys_tmr, 100);
			break;
		}
	}

	cleanup_platform();
	return 0;
}

/**
 * @brief Update GUI table
 * @return void
 */
void update_table(void)
{
	for (int i = 0; i < CHAN_NUM; i++) {
		if (chan_active & (1 << i)) {
			sprintf(gtbl.cell[i+1][1].txt, "%.1f", max[i]);
			gtbl.cell[i+1][1].color = COLOR_LIME;

			sprintf(gtbl.cell[i+1][2].txt, "%.1f", rms[i]);
			gtbl.cell[i+1][2].color = COLOR_LIME;

			sprintf(gtbl.cell[i+1][3].txt, "%.1f", (snr[i] < 0.0 ) ? 0.0 : snr[i]);
			if (snr[i] < 60)
				gtbl.cell[i+1][3].color = COLOR_RED;
			else if (snr[i] < 65)
				gtbl.cell[i+1][3].color = COLOR_YELLOW;
			else
				gtbl.cell[i+1][3].color = COLOR_LIME;

			sprintf(gtbl.cell[i+1][4].txt, "%.1f", fre[i]);
			gtbl.cell[i+1][4].color = COLOR_LIME;

			for (int j = 0; j < CHAN_NUM; j++) {
				if (i == j) {
					sprintf(gtbl.cell[i+1][5+j].txt, " -");
					gtbl.cell[i+1][5+j].color = COLOR_SILVER;
				} else {
					if (chan_active & (1 << j)) {
						sprintf(gtbl.cell[i+1][5+j].txt, "%0.1f", pcc[i][j]);
						if (pcc[i][j] > 0.9)
							gtbl.cell[i+1][5+j].color = COLOR_LIME;
						else if (pcc[i][j] > 0.8)
							gtbl.cell[i+1][5+j].color = COLOR_YELLOW;
						else
							gtbl.cell[i+1][5+j].color = COLOR_RED;
					} else {
						sprintf(gtbl.cell[i+1][5+j].txt, " -");
						gtbl.cell[i+1][5+j].color = COLOR_RED;
					}
				}
			}
		} else {
			sprintf(gtbl.cell[i+1][1].txt, " -");
			gtbl.cell[i+1][1].color = COLOR_RED;
			sprintf(gtbl.cell[i+1][2].txt, " -");
			gtbl.cell[i+1][2].color = COLOR_RED;
			sprintf(gtbl.cell[i+1][3].txt, " -");
			gtbl.cell[i+1][3].color = COLOR_RED;
			sprintf(gtbl.cell[i+1][4].txt, " -");
			gtbl.cell[i+1][4].color = COLOR_RED;

			for (int j = 0; j < CHAN_NUM; j++) {
				if (i == j) {
					sprintf(gtbl.cell[i+1][5+j].txt, " -");
					gtbl.cell[i+1][5+j].color = COLOR_SILVER;
				} else {
					sprintf(gtbl.cell[i+1][5+j].txt, " -");
					gtbl.cell[i+1][5+j].color = COLOR_RED;
				}
			}
		}
	}
}

/**
 * @brief Mode buttons handler (see hal.c)
 * @return void
 */
void btn_handler(u32 msk)
{
	switch (msk) {
	case 0x7F:
		gui_mode = GUI_MODE_TABLE;
		break;
	case 0xDF:
		gui_mode = GUI_MODE_OSCIL;
		break;
	case 0xFD:
		gui_mode = GUI_MODE_SPECT;
		break;
	}
}
