/**
 * @file dft.c
 * @brief Discrete Fourier Transform
 * @author matyunin.d
 * @date 31.07.2019
 */

#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "fft.h"
#include "../hal/hal.h"

static float complex xt[FFT_LENGTH] __attribute__((section(".eram")));
static float complex Xt[FFT_LENGTH] __attribute__((section(".eram")));

static void fft_transform(const float complex *x, float complex *X, int N);

/**
 * @brief Fast Fourier Transform
 * @param x Pointer to input array
 * @param X Pointer to output array
 * @param N Number of elements
 * @return void
 */
void fft(const float *x, float complex *X, int N)
{
	for (int i = 0; i < N; i++)
		xt[i] = x[i] + I*0.0;
	fft_transform(xt, Xt, N);
	memcpy(X, Xt, sizeof(float complex)*N);
}

/**
 * @brief Fast Fourier Transform (complex)
 * @param x Pointer to input array
 * @param X Pointer to output array
 * @param N Number of elements
 * @return void
 */
void cfft(const float complex *x, float complex *X, int N)
{
	memcpy(xt, x, sizeof(float complex)*N);
	fft_transform(xt, Xt, N);
	memcpy(X, Xt, sizeof(float complex)*N);
}

/**
 * @brief Fast Fourier Transform (magnitude)
 * @param x Pointer to input array
 * @param X Pointer to output array
 * @param N Number of elements
 * @return void
 */
void fft_mag(const float *x, float *X, int N)
{
	fft(x, Xt, N);
	for (int i = 0; i < N; i++)
		X[i] = cabsf(Xt[i]);
}

/**
 * @brief Fast Fourier Transform (complex, magnitude)
 * @param x Pointer to input array
 * @param X Pointer to output array
 * @param N Number of elements
 * @return void
 */
void cfft_mag(const float complex *x, float *X, int N)
{
	cfft(x, Xt, N);
	for (int i = 0; i < N; i++)
		X[i] = cabsf(Xt[i]);
}

/**
 * @brief Fast Fourier Transform implementation
 * @param x Pointer to input array
 * @param X Pointer to output array
 * @param N Number of elements
 * @return void
 */
static void fft_transform(const float complex *x, float complex *X, int N)
{
	dma_transmit(&fft_dma, (u32 *)x, sizeof(float complex)*FFT_LENGTH);
	dma_receive(&fft_dma, (u32 *)X, sizeof(float complex)*FFT_LENGTH);
}
