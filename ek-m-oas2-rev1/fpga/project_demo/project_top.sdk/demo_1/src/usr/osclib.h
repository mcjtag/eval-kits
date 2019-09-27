/**
 * @file osclib.h
 * @brief Oscilloscope library
 * @author matyunin.d
 * @date 22.07.2019
 */

#ifndef OSCLIB_H_
#define OSCLIB_H_

#include "xil_types.h"

struct osc_info {
	float rms[4];
	float snr[4];
	float freq[4];
	float ro[6];
	float snr_rms[4];
};

void osclib_set_data(int chan, float *data);
void osclib_set_info(struct osc_info *info);
void osclib_set_active(u8 chan_msk);
void osclib_update(void);

#endif /* OSCLIB_H_ */
