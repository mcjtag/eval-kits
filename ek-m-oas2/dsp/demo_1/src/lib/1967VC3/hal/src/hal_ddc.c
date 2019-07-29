
#include "cpu.h"
#include "hal_ddc.h"


int HAL_DDC_Log2 (unsigned int val) 
{
    int ret = -1;
    while (val != 0) 
    {
        val >>= 1;
        ret++;
    }
    return ret;
}





// Bits shift amount S is computed as
// S =  B_IN - B_OUT + Kf * log_2(D), where
// Kf - filter length (3, 5 or 7),
// D - decimation ratio
// B_IN - input data width (from ADC)
// B_OUT - output data width (width of I or Q sample)


unsigned int HAL_DDC_GetShiftAmount(int b_in, int b_out, int decimation_k, int filter_length)
{
	int f_length;
	int log2_res;
	int result;
	switch (filter_length)
	{
		case ADACR_FLEN3:
			f_length = 3;	break;
		case ADACR_FLEN5:
			f_length = 5;	break;
		case ADACR_FLEN7:
			f_length = 7;	break;
		default: 
			f_length = 5;	// wrong argument
	}
	log2_res = HAL_DDC_Log2(decimation_k);
	
	result = b_in - b_out + f_length * log2_res;
	if (result < 0) result = 0;
	if (result > 0x7F) result = 0x7F;
	return result;
}


uint16_t HAL_DDC_GetFreqTableStep(float sample_freq, float heterodyne_freq)
{
	uint32_t step;
	float k = sample_freq / heterodyne_freq;
	step = 0x10000 / k;
	if (step > 0x10000)
		step = 0;
	return step;
}


