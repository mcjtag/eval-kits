/**
 * @file calc.h
 * @brief Calculations
 * @author matyunin.d
 * @date 24.07.2019
 */

#ifndef CALC_H_
#define CALC_H_

float calc_mean(float *data, unsigned int len);
float calc_std(float *data, unsigned int len);
float calc_cov(float *data0, float *data1, unsigned int len);
float calc_pcc(float *data0, float *data1, unsigned int len);

#endif /* CALC_H_ */
