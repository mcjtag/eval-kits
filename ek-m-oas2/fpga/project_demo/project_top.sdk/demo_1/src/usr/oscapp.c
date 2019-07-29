/**
 * @file oscapp.c
 * @brief Oscilloscope Application
 * @author matyunin.d
 * @date 24.07.2019
 */

#include "oscapp.h"

#include "../hal/hal.h"
#include "../drv/dsp.h"
#include "../drv/switch.h"
#include "../lib/calc.h"
#include "osclib.h"

#define NC	1

struct snr_buf {
	float snr[NC];
};

static struct dsp_meas dmeas;
static struct osc_info omeas;

static float signal[1024];
static struct snr_buf sb[4];

/**
 * @brief Run application
 * @return void
 */
void oscapp_run(void)
{
	int cycles = NC;

	dsp_init();
	dsp_restart();
	timer_delay(&sys_tmr, 100);

	osclib_update();

	while (1) {
		if (dsp_capture() == XST_SUCCESS) {
			cycles--;
			dsp_get_meas(&dmeas);
			for (int i = 0; i < 4; i++)
				sb[i].snr[cycles] = dmeas.snr[i];

			if (!cycles) {
				cycles = NC;
				for (int i = 0; i < 4; i++) {
					omeas.rms[i] = dmeas.rms[i];
					omeas.snr[i] = calc_mean(sb[i].snr, NC);
					omeas.snr_rms[i] = calc_std(sb[i].snr, NC);
				}
				for (int i = 0; i < 6; i++)
					omeas.ro[i] = dmeas.ro[i];
				for (int i = 0; i < 4; i++) {
					dsp_get_signal(i, signal, 1024);
					osclib_set_data(i, signal);
				}

				osclib_set_info(&omeas);
				osclib_set_active(sw_get_state());
				osclib_update();
				timer_delay(&sys_tmr, 100);
			}
		}
	}
}

