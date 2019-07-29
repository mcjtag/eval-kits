

#include "signal_metric.h"
#include "window_bh.h"
#include <window.h>
#include <math.h>
#include <filter.h>
#include <float.h>
#include <stats.h>

#define SQR(x)	((x) * (x))
#ifndef _PI
    #define _PI 3.14159265358979323846
#endif

#define DC_BINS			4
#define FUNDM_BINS		5
#define SPUR_BINS		6

static const float coeff_bh_2term[] = {
	5.383553946707251e-1,
	4.616446053292749e-1	
};

static const float coeff_bh_3term[] = {
	4.243800934609435e-1,
	4.973406350967378e-1,
	7.827927144231873e-2
};

static const float coeff_bh_4term[] = {
	3.635819267707608e-1,
	4.891774371450171e-1,
	1.365995139786921e-1,
	1.064112210553003e-2
};

static const float coeff_bh_5term[] = {
	3.232153788877343e-1,
	4.714921439576260e-1,
	1.755341299601972e-1,
	2.849699010614994e-2,
	1.261357088292677e-3
};

static const float coeff_bh_6term[] = {
	2.935578950102797e-1,
	4.519357723474506e-1,
	2.014164714263962e-1,
	4.792610922105837e-2,
	5.026196426859393e-3,
	1.375555679558877e-4
};

static const float coeff_bh_7term[] = {
	2.712203605850388e-1,
	4.334446123274422e-1,
	2.180041228929303e-1,
	6.578534329560609e-2,
	1.076186730534183e-2,
	7.700127105808265e-4,
	1.368088305992921e-5
};

static const float coeff_bh_8term[] = {
	2.533176817029088e-1,
	4.163269305810218e-1,
	2.288396213719708e-1,
	8.157508425925879e-2,
	1.773592450349622e-2,
	2.096702749032688e-3,
	1.067741302205525e-4,
	1.280702090361482e-6
};

static const float coeff_bh_9term[] = {
	2.384331152777942e-1,
	4.005545348643820e-1,
	2.358242530472107e-1,
	9.5279188583831126-2,
	2.537395516617152e-2,
	4.152432907505835e-3,
	3.685604163298180e-4,
	1.384355593917030e-5,
	1.161808358932861e-7
};

static const float coeff_bh_10term[] = {
	2.257345387130214e-1,
	3.860122949150963e-1,
	2.401294214106057e-1,
	1.070542338664613e-1,
	3.325916184016952e-2,
	6.873374952321475e-3,
	8.751673238035159e-4,
	6.008598932721187e-5,
	1.710716472110202e-6,
	1.027272130265191e-8
};

static const float coeff_bh_11term[] = {
	2.151527506679809e-1,
	3.731348357785249e-1,
	2.424243358446660e-1,
	1.166907592689211e-1,
	4.077422105878731e-2,
	1.000904500852923e-2,
	1.639806917362033e-3,
	1.651660820997142e-4,
	8.884663168541479e-6,
	1.938617116029048e-7,
	8.482485599330470e-10
};


static const float *coeff_bh[] = {
	coeff_bh_2term,
	coeff_bh_3term,
	coeff_bh_4term,
	coeff_bh_5term,
	coeff_bh_6term,
	coeff_bh_7term,
	coeff_bh_8term,
	coeff_bh_9term,
	coeff_bh_10term,
	coeff_bh_11term,
};



//-----------------------------------------------------------------//
// Generate Blackman-Harris window
//
//	kWnd: 2 to 11
//
//	https://habr.com/ru/post/427361/
//-----------------------------------------------------------------//
void GenerateBlackmanHarris(float *pOut, int npt, int kWnd)
{
	const float *coeff;
	float tmp, coeff_sign;
	int i, k;
	if ((kWnd < 2) || (kWnd > 11))
		while(1);
	coeff = coeff_bh[kWnd-2];
	for (i=0; i<npt; i++)
	{
		tmp = 0;
		for (k=0; k<kWnd; k++)
		{
			coeff_sign = (k & 0x01) ? -1 : 1;
			tmp += coeff_sign * coeff[k] * cos((2 * _PI * k * i) / (npt - 1));
		}
		*pOut++ = tmp;
	}
}



//-----------------------------------------------------------------//
// Calculate signal-to-noise metrics
//
//  data, temp1 and temp2 must have size of npt and be npt-aligned in memory.
//	npt must be a power of 2 and greater or equal to 64
//	For best performance, temp1 and temp2 should be located in separate memrory blocks
//	temp1 and temp2 must have size of npt
// 
//-----------------------------------------------------------------//
SNR_Result_t CalcSnrMetric(float *data, float *temp1, float *temp2, unsigned int npt)
{
	complex_float *twiddles;	
	complex_float *fft_result;
	float *fft_spec;
	int i, k;
	struct {
		unsigned int iF;	
		unsigned int iS;
		unsigned int iH[5];
		float Pf;
		float Ps;
		float Ph;
		float Pn;
		float Pnh;
		float SNR;
		float SNDR;
		float SFDR;
	} metric;
	struct {
		float iF_MaxVal;
		float iS_MaxVal;
		float P_Summ;
	} aux;
	SNR_Result_t returnVal;
	
	// Generate window
	//gen_blackman(temp1,1,npt);
	//GenerateBlackmanHarris(temp1, npt, 4);
	
	// Apply window
	for (i=0; i<npt; i++)
		data[i] *= wnd_bh4[i];
	
	twiddles = (complex_float *)temp1;
	fft_result = (complex_float *)temp2;
	fft_spec = temp2;
	
	// Generate twiddles (npt/2 complex_float points for fftf function)
	twidfftf(twiddles, npt);
	
	// Do real-input fft (npt/2 complex_float points are generated)
	rfftf(data, fft_result, twiddles, 1, npt);
	
	// Normalize power (npt/2 float points are generated)
	rfftf_mag (fft_result, fft_spec, npt);
	
	// Get number of bin (iF) containing fundamental frequency
	metric.iF = 0;
	aux.iF_MaxVal = -FLT_MAX;
	for (i=DC_BINS+1; i<npt/2; i++)
	{
		if (fft_spec[i] > aux.iF_MaxVal)
		{
			aux.iF_MaxVal = fft_spec[i];
			metric.iF = i;
		}
	}
	
	// Get number of greatest spur (iS) excluding DC and fundamental
	metric.iS = 0;
	aux.iS_MaxVal = -FLT_MAX;
	for (i=DC_BINS+1; i<npt/2; i++)
	{
		if (((metric.iF - FUNDM_BINS) <= i) && (i <= (metric.iF + FUNDM_BINS)))
			continue;
			
		if (fft_spec[i] > aux.iS_MaxVal)
		{
			aux.iS_MaxVal = fft_spec[i];
			metric.iS = i;
		}
	}
	
	// Get number of harmonics falling into first nyquist zone
	for (k=2; k<=6; k++)
	{
		i = k-2;
		metric.iH[i] = (k * metric.iF) % npt;
		if (metric.iH[i] > npt/2)
			metric.iH[i] = npt - metric.iH[i];
	}
	
	// Get power of fundamental
	aux.P_Summ = 0;
	for (i = metric.iF - FUNDM_BINS; i <= metric.iF + FUNDM_BINS; i++)
	{
		if (i >= npt/2)
			continue;
		aux.P_Summ += SQR(fft_spec[i]);
	}
	metric.Pf = sqrt(aux.P_Summ);
	
	// Get power of spur
	aux.P_Summ = 0;
	for (i = metric.iS - SPUR_BINS; i <= metric.iS + SPUR_BINS; i++)
	{
		if ((i >= npt/2) || (((metric.iF - FUNDM_BINS) <= i) && (i <= (metric.iF + FUNDM_BINS))))
			continue;
		aux.P_Summ += SQR(fft_spec[i]);
	}
	metric.Ps = sqrt(aux.P_Summ);
	
	// Get power of harmonics
	aux.P_Summ = 0;
	for (k=2; k<=6; k++)
	{
		for (i = metric.iH[k-2] - SPUR_BINS; i<= metric.iH[k-2] + SPUR_BINS; i++)
		{
			if ((i >= npt/2) || (((metric.iF - FUNDM_BINS) <= i) && (i <= (metric.iF + FUNDM_BINS))))
				continue;
			aux.P_Summ += SQR(fft_spec[i]);
		}
	}
	metric.Ph = sqrt(aux.P_Summ);
	
	// Get power of noise (with harmonics)
	aux.P_Summ = 0;
	for (i = DC_BINS+1; i < npt/2; i++)
	{
		if ((i >= npt/2) || ((((metric.iF - FUNDM_BINS) <= i)) && (i <= (metric.iF + FUNDM_BINS))))
			continue;
		aux.P_Summ += SQR(fft_spec[i]);
	}
	metric.Pn = sqrt(aux.P_Summ);
	
	// Get power of noise without harmonics
	metric.Pnh = sqrt(SQR(metric.Pn) - SQR(metric.Ph));
	
	// Get signal-to-noise ratios
	metric.SNR = 20 * log10(metric.Pf / metric.Pnh) + 1;
	metric.SNDR = 20 * log10(metric.Pf / metric.Pn) + 1;
	metric.SFDR = 20 * log10(metric.Pf / metric.Ps);
	
	returnVal.snr = metric.SNR;
	returnVal.sndr = metric.SNDR;
	returnVal.sfdr = metric.SFDR;
	return returnVal;
}


//-----------------------------------------------------------------//
// Gather linearity metrics bar
//
//  data must have size of npt (npt = number of input pouints), signed
//	bar must have size of 2^n (n = number of bits of ADC output)
//  bar must be zeroed before collecting data
// 
//-----------------------------------------------------------------//
void SaveDataForLnr(int *data, unsigned int *bar, unsigned int npt, unsigned int n)
{
	int tmp;
	int i, k;
	int sz = 1 << n;		// sz = 2^n
	int hsz = 1 << (n-1);
	for (i=0; i<npt; i++)
	{
		tmp = data[i];
		tmp += hsz;
		tmp &= (sz - 1);
		bar[tmp]++;
	}
}


//-----------------------------------------------------------------//
// Calculate linearity metrics
//
//  data must have size of npt (npt = number of input pouints), signed
//	bar and temp2 must have size of 2^n (n = number of bits of ADC output)
// 
//-----------------------------------------------------------------//
LNR_Result_t CalcLnrMetric(int *data, unsigned int *bar, unsigned int *temp2, unsigned int npt, unsigned int n)
{
//	unsigned int *bar = temp1;		///
	float *t = (float *)temp2;
	int tmp;
	int i, k;
	int sz = 1 << n;		// sz = 2^n
	int hsz = 1 << (n-1);
	float tmpf, tmpf2;
	const float DCin = 1;
	const float ACin = 1;
	const float refp = 1;								// [V]
	const float refn = 0;								//
	//const float T = 0.5f * ((refp - refn) / sz);		// [V]
	float T;
	LNR_Result_t returnVal;
	
	// Get bar chart
/*
	for (i=0; i<sz; i++)			///
		bar[i] = 0;	
	for (i=0; i<npt; i++)
	{
		tmp = data[i];
		tmp += hsz;
		tmp &= (sz - 1);
		bar[tmp]++;
	}								///
*/	
	// Get transformation characteristic T
	tmpf2 = _PI / npt;
	for (k=1; k<sz; k++)
	{
		tmp = 0;
		for(i=0; i<=k-1; i++)
			tmp += bar[i];
		tmpf = (float)tmp;
		tmpf = cos(tmpf2 * tmpf);	// PI / npt;
		tmpf = DCin - ACin * tmpf;
		t[k] = tmpf;
	}
	
	// Get Q and G
	float Q = (refp - refn) / sz;
	float summ1 = 0;
	float summ2 = 0;
	float summ3 = 0;
	for(k=1; k<sz; k++)
	{
		summ1 += t[k];
		summ2 += t[k] * t[k];
		summ3 += t[k] * k;
	}
	float G = Q*(sz-1)*(summ3 - hsz * summ1);
	G /= (sz-1) * summ2 - SQR(summ1);
	
	T = t[1];
	float Vo = T + Q * (hsz - 1) - G * summ1 / (sz - 1);
	
	float INL, DNL, INL_abs_max, DNL_abs_max, INL_max, DNL_max, INL_min, DNL_min;
	INL_abs_max = 0;		// Prevent compiler from complaining
	DNL_abs_max = 0;
	INL_max = 0;
	DNL_max = 0;
	INL_min = 0;
	DNL_min = 0;
	
	for (i = 1; i < sz; i++)
	{
		INL = (G * t[i] + Vo - (Q*(i-1) + T)) / Q;		// [LSB]
		if ((i == 1) || (fabs(INL) > INL_abs_max))
			INL_abs_max = fabs(INL);
			
		if ((i == 1) || (INL > INL_max))
			INL_max = INL;
			
		if ((i == 1) || (INL < INL_min))
			INL_min = INL;
		
		if (i >= sz-1)
			continue;
		
		DNL = (G * (t[i+1] - t[i]) - Q) / Q;				// [LSB]
		if ((i == 1) || (fabs(DNL) > DNL_abs_max))
			DNL_abs_max = fabs(DNL);
			
		if ((i == 1) || (DNL > DNL_max))
			DNL_max = DNL;
			
		if ((i == 1) || (DNL < DNL_min))
			DNL_min = DNL;
	}
	returnVal.El = INL_abs_max;
	returnVal.Eld = DNL_abs_max;
	returnVal.El_max = INL_max;
	returnVal.Eld_max = DNL_max;
	returnVal.El_min = INL_min;
	returnVal.Eld_min = DNL_min;
	return returnVal;
}




//-----------------------------------------------------------------//
// Calculate offset metrics
//
//  data must have size of 2 ^ p (number of input pouints), signed
//	n - number of bits of ADC output
// 
//-----------------------------------------------------------------//
Offset_Result_t CalcOffsetMetric(int *data, unsigned int p, unsigned int n)
{
	int i, k, npt;
	double summ = 0;
	float Eio;
	int hsz = 1 << (n-1);
	Offset_Result_t returnVal;
	
	npt = 1 << p;
	for(i=0; i<npt; i++)
	{
		summ += data[i] + 8192;		// Make unsigned, zero must at half scale
	}
	float pwr2 = powf(2, p + n);
	Eio = (summ / pwr2  - 0.5) * 100;
	
	returnVal.Eio = Eio;
	return returnVal;
}



//-----------------------------------------------------------------//
// Calculate min, max and rms metrics
//
//  data may have arbitrary size, floating-point
//	npt - size of input data
// 
//-----------------------------------------------------------------//
MinMax_Result_t CalcMinMaxMetric(float *data, unsigned int npt)
{
	MinMax_Result_t returnVal;
	int i;
	returnVal.min = FLT_MAX;
	returnVal.max = FLT_MIN;
	for (i=0; i<npt; i++)
	{
		if (data[i] < returnVal.min)
			returnVal.min = data[i];
		else if (data[i] > returnVal.max)
			returnVal.max = data[i];
	}
	returnVal.rms = rmsf(data, npt);
	return returnVal;
}




//-----------------------------------------------------------------//
// Check integrity of data lines from ADC to DSP
//
//  data must have size of npt (number of input pouints), signed or unsigned
//	n - number of bits of ADC output, up to 16
//
//	Output bit is set for ~equal 0/1 distribution of corresponding bit
// 
//-----------------------------------------------------------------//
unsigned int bitBar[16];

unsigned int CheckDataIntegrity(unsigned int *data, unsigned int npt, unsigned int n)
{
	//unsigned int bitBar[n];
	unsigned int i, k;
	unsigned int bit;
	float thrs, lowThrs, highThrs;;
	unsigned int resultMask;
	
	for(i=0; i<n; i++)
		bitBar[i] = 0;
		
	for (k=0; k<npt; k++)
	{
		for (i=0; i<n; i++)
		{
			bit = (1 << i);
			bitBar[i] = (data[k] & bit) ? bitBar[i] + 1 : bitBar[i];
		}
	}
	
	thrs = (npt * 0.05);
	lowThrs = npt / 2 - thrs;
	highThrs = npt / 2 + thrs;
	resultMask = 0;
	
	for (i=0; i<n; i++)
	{
		bit = (1 << i);
		if ((bitBar[i] >= lowThrs) && (bitBar[i] <= highThrs))
		 	resultMask |= bit;
	}
	
	return resultMask;
}



