/**
 * @file dsp.h
 * @brief DSP driver
 * @author matyunin.d
 * @date 23.07.2019
 */

#ifndef DSP_H_
#define DSP_H_

struct dsp_meas {
	float rms[4];
	float snr[4];
	float freq[4];
	float ro[6];
};

int dsp_init(void);
void dsp_restart(void);
void dsp_reset(int dsp);
void dsp_reset_all(void);
int dsp_capture(void);
int dsp_get_signal(int chan, float *data, unsigned int len);
void dsp_get_meas(struct dsp_meas *meas);

#endif /* DSP_H_ */
