/**
 * @file adc.h
 * @brief
 * @author matyunin.d
 * @date 22.02.2018
 */

#ifndef ADC_H_
#define ADC_H_

#include <stdint.h>

enum ADC_CHANNEL {
	ADC_0,
	ADC_1
};

struct adc_config {
	int chan;
	int dmar;
	uint32_t samples;
	float fhet;
	uint32_t flen;
	uint32_t shift;
	uint32_t df;
};

void adc_init(void);
void adc_conf(const struct adc_config *cfg);
int adc_ready(int chan);
int adc_ready_all(void);
void adc_ready_clear(void);
void adc_read(int chan, float *data, uint16_t len);
void adc_start(int chan);

#endif /* ADC_H_ */
