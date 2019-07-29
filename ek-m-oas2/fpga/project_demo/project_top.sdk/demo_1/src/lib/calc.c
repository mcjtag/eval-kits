/**
 * @file calc.c
 * @brief Calculations
 * @author matyunin.d
 * @date 24.07.2019
 */

#include <math.h>

/**
 * @brief Calculate average value of sequence
 * @param data Pointer to data
 * @param len Length of data array
 * @return average
 */
float calc_mean(float *data, unsigned int len)
{
	float mean = 0.0;

	for (int i = 0; i < len; i++)
		mean += data[i];
	mean /= (float)len;

	return mean;
}

/**
 * @brief Calculate standard deviation
 * @param data Pointer to data
 * @param len Length of data array
 * @return standard deviation
 */
float calc_std(float *data, unsigned int len)
{
	float tmp = 0.0;
	float mean = 0.0;
	float rms = 0.0;

	mean = calc_mean(data, len);

	for (int i = 0; i < len; i++) {
		tmp = fabsf(data[i]-mean);
		rms += tmp*tmp;
	}
	rms /= ((float)len - 1.0);
	rms = sqrtf(rms);

	return rms;
}

/**
 * @brief Calculate covariance of two sequences
 * @param data0 Pointer to data #0
 * @param data1 Pointer to data #1
 * @param len Length of data array
 * @return covariance
 */
float calc_cov(float *data0, float *data1, unsigned int len)
{
	float mean0 = calc_mean(data0, len);
	float mean1 = calc_mean(data1, len);
	float cov = 0.0;

	for (int i = 0; i < len; i++)
		cov += (data0[i]-mean0)*(data1[i]-mean1);
	cov /= ((float)len - 1.0);

	return cov;
}

/**
 * @brief Calculate Pearson correlation coefficient
 * @param data0 Pointer to data #0
 * @param data1 Pointer to data #1
 * @param len Length of data array
 * @return pcc
 */
float calc_pcc(float *data0, float *data1, unsigned int len)
{
	float std0 = calc_std(data0, len);
	float std1 = calc_std(data1, len);
	float cov = calc_cov(data0, data1, len);
	float pcc;

	pcc = cov / (std0 * std1);

	return pcc;
}
