/**
 * @file adc8_tcb.h
 * @brief ADC8 TCB Controller
 * @author matyunin.d
 * @date 13.08.2019
 * @copyright MIT License
 */

#ifndef ADC8_TCB_H
#define ADC8_TCB_H

#include "xil_types.h"
#include "xstatus.h"

typedef struct{
	u32 baseaddr;
} adc8_tcb_dev_t;

enum ADC8_TCB_FORMAT {
	ADC8_TCB_FORMAT_FLOAT,
	ADC8_TCB_FORMAT_FIX,
};

int adc8_tcb_init(adc8_tcb_dev_t *dev, u32 baseaddr);
void adc8_tcb_set_length(adc8_tcb_dev_t *dev, u16 length);
void adc8_tcb_set_norm(adc8_tcb_dev_t *dev, float norm);
void adc8_tcb_set_offt(adc8_tcb_dev_t *dev, float offt);
void adc8_tcb_set_format(adc8_tcb_dev_t *dev, int format);
void adc8_tcb_start(adc8_tcb_dev_t *dev);

int adc8_selftest(void *baseaddr_p);

#endif // ADC8_TCB_H