/**
 * @file main.c
 * @brief Main file
 * @author matyunin.d
 * @date 18.01.2018
 */

#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "adc/adc.h"
#include "system/init.h"
#include "system/enumerator.h"
#include "periph/link.h"
#include "periph/dmar.h" 
#include "utils/memtest.h"
#include "utils/signal_metric.h"
#include "config.h"

#define MAGIC		0xA57E00AC
#define ADC_LEN 	32768
#define ADC_SEND	1024

#pragma align(4)
static uint32_t lnk_data[CONFIG_LINK_LENGTH]; 

//#pragma align(4)
#pragma section("data6a")
static float adc_data[ADC_LEN];

#pragma section("data8a")
uint32_t data32k_a[32768];

#pragma section("data8a")
uint32_t data32k_b[32768];

struct adc_config cfg;

static SNR_Result_t res;

static void init(void);

/**
 * @brief Main function
 * @return void
 */
void main(void)
{
	int err;
	int i;
	init();

	cfg.chan = ADC_0;
	cfg.dmar = 1;
	cfg.samples = ADC_LEN;
	cfg.fhet = 0;
	cfg.flen = 0;
	cfg.shift = 0;
	cfg.df = 0;
	adc_conf(&cfg);
	cfg.chan = ADC_1;
	adc_conf(&cfg);
	
	for (i = 0;i < CONFIG_LINK_LENGTH; i++)
		lnk_data[i] = 0;
	lnk_data[0] = MAGIC;
	
	while (1) {
		while (!adc_ready_all());
		adc_read(ADC_0, adc_data, ADC_LEN);
		memcpy(&lnk_data[8], adc_data, ADC_SEND);
		res = CalcSnrMetric(adc_data, (float *)data32k_a, (float *)data32k_b, ADC_LEN);
		lnk_data[1] = get_local_offset()*2+0;
		lnk_data[2] = ADC_SEND;
		memcpy(&lnk_data[3], &res.snr, 1);
		lnk_data[4] = 0;
		link_send(lnk_data, ADC_SEND+8);
				
		adc_read(ADC_1, adc_data, ADC_LEN);
		memcpy(&lnk_data[8], adc_data, ADC_SEND);
		res = CalcSnrMetric(adc_data, (float *)data32k_a, (float *)data32k_b, ADC_LEN);
		lnk_data[1] = get_local_offset()*2+1;
		lnk_data[2] = ADC_SEND;
		memcpy(&lnk_data[3], &res.snr, 1);
		lnk_data[4] = 0;
		link_send(lnk_data, ADC_SEND+8);
			
		adc_ready_clear();
	}
}

static void init(void)
{
	init_all();	
	dmar_init();
	link_init();
	adc_init();
}
