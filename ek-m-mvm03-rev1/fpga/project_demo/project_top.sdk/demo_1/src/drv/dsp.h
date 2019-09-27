/**
 * @file dsp.h
 * @brief DSP Driver
 * @author matyunin.d
 * @date 24.06.2019
 */

#ifndef DSP_H_
#define DSP_H_

enum DSP_ID {
	DSP_ID0,
	DSP_ID1,
	DSP_ID2,
	DSP_ID3
};

enum DSP_VOLT {
	DSP_VOLT_IN,
	DSP_VOLT_AN,
	DSP_VOLT_IO
};

void dsp_init(void);
void dsp_reset(int state);
float dsp_get_temp(int dsp_id);
float dsp_get_volt(int dsp_volt);

#endif /* DSP_H_ */
