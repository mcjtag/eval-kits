/**
 * @file meas.h
 * @brief Common measurements
 * @author matyunin.d
 * @date 31.07.2019
 */

#ifndef MEAS_H_
#define MEAS_H_

void meas_init(void);
float meas_min(const float *x, int N, int *i);
float meas_max(const float *x, int N, int *i);
float meas_mean(const float *x, int N);
float meas_std(const float *x, int N);
float meas_cov(const float *x0, const float *x1, int N);
float meas_pcc(const float *x0, const float *x1, int N);
void meas_dbv(const float *x, float *y, int N);
float meas_snr(const float *x, int N, float fs, int en, float *fn);

#endif /* MEAS_H_ */
