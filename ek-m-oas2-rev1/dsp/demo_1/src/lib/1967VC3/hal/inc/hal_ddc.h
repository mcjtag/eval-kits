#ifndef __HAL_DDC_H__
#define __HAL_DDC_H__

#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"


#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus

	int HAL_DDC_Log2 (unsigned int val);
	unsigned int HAL_DDC_GetShiftAmount(int b_in, int b_out, int decimation_k, int filter_length);
	uint16_t HAL_DDC_GetFreqTableStep(float sample_freq, float heterodyne_freq);



#ifdef __cplusplus
}
#endif // __cplusplus





#endif //__HAL_DDC_H__	
