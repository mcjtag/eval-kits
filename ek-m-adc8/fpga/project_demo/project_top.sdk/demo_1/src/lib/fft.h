/**
 * @file fft.h
 * @brief Discrete Fourier Transform
 * @author matyunin.d
 * @date 31.07.2019
 */

#ifndef DFT_H_
#define DFT_H_

#include <complex.h>

#define FFT_LENGTH		8192

void fft(const float *x, float complex *X, int N);
void cfft(const float complex *x, float complex *X, int N);
void fft_mag(const float *x, float *X, int N);
void cfft_mag(const float complex *x, float *X, int N);

#endif /* FFT_H_ */
