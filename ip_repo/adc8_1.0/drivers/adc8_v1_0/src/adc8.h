/**
 * @file adc8.h
 * @brief ADC8 Controller
 * @author matyunin.d
 * @date 06.08.2019
 * @copyright MIT License
 */

#ifndef ADC8_H
#define ADC8_H

#include "xil_types.h"
#include "xstatus.h"

typedef struct{
	u32 baseaddr;
} adc8_dev_t;

struct adc_config {
	u8 out_mode;
};

int adc8_init(adc8_dev_t *dev, u32 baseaddr);
void adc8_reset(adc8_dev_t *dev, int state);
int adc8_calib_done(adc8_dev_t *dev);
void adc8_out_valid(adc8_dev_t *dev, int state);
void adc8_dst_esync(adc8_dev_t *dev, int state);
void adc8_dst_reset(adc8_dev_t *dev, int state);
void adc8_dst_powerdown(adc8_dev_t *dev, int state);
void adc8_dst_sync(adc8_dev_t *dev, int state);
void adc8_dst_refsel(adc8_dev_t *dev, int state);
int adc8_dst_ld(adc8_dev_t *dev);
int adc8_dst_config(adc8_dev_t *dev, u8 *cfg);

void adc8_adc_out_enable(adc8_dev_t *dev, int state);
void adc8_adc_calibrate(adc8_dev_t *dev);
void adc8_adc_bias(adc8_dev_t *dev, int state);
u8 adc8_adc_overflow(adc8_dev_t *dev);
void adc8_adc_if_reset(adc8_dev_t *dev, int state);
int adc8_adc_config(adc8_dev_t *dev, const struct adc_config *cfg);

int adc8_selftest(void *baseaddr_p);

#endif // ADC8_H