/********************************************************************

	signal_metric.h
	
	DSP functions for ADC testing

********************************************************************/


#ifndef __SIGNAL_METRIC_H_
#define __SIGNAL_METRIC_H_



typedef struct {
	float snr;		// Signal to noise ratio (without harmonics)
	float sndr;		// Signal to noise ratio (including harmonics), same as SINAD
	float sfdr;		// Spurious-free dynamic range
} SNR_Result_t;


typedef struct {
	float El;
	float Eld;
	float El_max;
	float Eld_max;
	float El_min;
	float Eld_min;
} LNR_Result_t;

typedef struct {
	float Eio;
} Offset_Result_t;

typedef struct {
	float min;
	float max;
	float rms;
} MinMax_Result_t;



SNR_Result_t CalcSnrMetric(float *data, float *temp1, float *temp2, unsigned int n);
void SaveDataForLnr(int *data, unsigned int *bar, unsigned int npt, unsigned int n);
LNR_Result_t CalcLnrMetric(int *data, unsigned int *temp1, unsigned int *temp2, unsigned int npt, unsigned int n);
Offset_Result_t CalcOffsetMetric(int *data, unsigned int npt, unsigned int n);
MinMax_Result_t CalcMinMaxMetric(float *data, unsigned int npt);
unsigned int CheckDataIntegrity(unsigned int *data, unsigned int npt, unsigned int n);


#endif //__SIGNAL_METRIC_H_	

