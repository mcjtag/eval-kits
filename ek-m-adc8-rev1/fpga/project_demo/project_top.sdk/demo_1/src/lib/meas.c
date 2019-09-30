/**
 * @file meas.c
 * @brief Common measurements
 * @author matyunin.d
 * @date 31.07.2019
 */

#include "meas.h"
#include <math.h>
#include <float.h>
#include <complex.h>
#include <stdlib.h>
#include "fft.h"

static float kaiser_win[FFT_LENGTH];
static float xt[FFT_LENGTH];
static float kaiser_win_mag[FFT_LENGTH];

static void extreme2(float *x, int N, int ind, int dir, int type, int exn, float *val, int *vind);
static void wind_kaiser(float *w, int N, float b);
static float besseli0(float x);

/**
 *  @brief Meas initialization
 *  @return void
 */
void meas_init(void)
{
	wind_kaiser(kaiser_win, FFT_LENGTH, 38);
	fft_mag(kaiser_win, kaiser_win_mag, FFT_LENGTH);
}

/**
 * @brief Calculates a minimum value of an array
 * @param x Pointer to array
 * @param N Number of elements
 * @param i Pointer to return an index of minimum value
 * @return value
 */
float meas_min(const float *x, int N, int *i)
{
	float min = FLT_MAX;
	int mi = 0;

	for (int j = 0; j < N; j++)
		if (x[j] < min) {
			min = x[j];
			mi = j;
		}

	if (i)
		*i = mi;

	return min;
}

/**
 * @brief Calculates a maximum value of an array
 * @param x Pointer to an array
 * @param N Number of elements
 * @param i Pointer to return an index of maximum value
 * @return value
 */
float meas_max(const float *x, int N, int *i)
{
	float max = FLT_MIN;
	int mi = 0;

	for (int j = 0; j < N; j++)
		if (x[j] > max) {
			max = x[j];
			mi = j;
		}

	if (i)
		*i = mi;

	return max;
}

/**
 * @brief Calculates an average value of an array
 * @param x Pointer to an array
 * @param N Number of elements
 * @return value
 */
float meas_mean(const float *x, int N)
{
	float mean = 0.0;

	for (int i = 0; i < N; i++)
		mean += x[i];
	mean /= N;

	return mean;
}

/**
 * @brief Calculates a standard deviation value of an array
 * @param x Pointer to an array
 * @param N Number of elements
 * @return value
 */
float meas_std(const float *x, int N)
{
	float tmp = 0.0;
	float mean = 0.0;
	float std = 0.0;

	mean = meas_mean(x, N);

	for (int i = 0; i < N; i++) {
		tmp = fabsf(x[i]-mean);
		std += tmp*tmp;
	}
	std /= ((float)N - 1.0);
	std = sqrtf(std);

	return std;
}

/**
 * @brief Calculates a covariance of two arrays
 * @param x0 Pointer to first array
 * @param x1 Pointer to second array
 * @param N Number of elements
 * @return value
 */
float meas_cov(const float *x0, const float *x1, int N)
{
	float m0 = meas_mean(x0, N);
	float m1 = meas_mean(x1, N);
	float cov = 0.0;

	for (int i = 0; i < N; i++)
		cov += (x0[i]-m0)*(x1[i]-m1);
	cov /= ((float)N - 1.0);

	return cov;
}

/**
 * @brief Calculates the Pearson correlation coefficient (PCC)
 * @param x0 Pointer to first array
 * @param x1 Pointer to second array
 * @param N Number of elements
 * @return value
 */
float meas_pcc(const float *x0, const float *x1, int N)
{
	float s0 = meas_std(x0, N);
	float s1 = meas_std(x1, N);
	float cov = meas_cov(x0, x1, N);

	return (cov / (s0 * s1));
}

/**
 * @brief Converts time-domain sequence to a frequency-domain sequence in dBV
 * @param x Pointer to an input array
 * @param x Pointer to an output array
 * @param N Number of elements
 * @return void
 */
void meas_dbv(const float *x, float *y, int N)
{
	const float *w = kaiser_win;
	const float *W = kaiser_win_mag;
	float wmax;
	float xmean;

//	wind_kaiser(w, N, beta);
	xmean = meas_mean(x, N);
	for (int i = 0; i < N; i++)
		xt[i] = (x[i] - xmean) * w[i];
//	fft_mag(w, w, N);
	wmax = meas_max(W, N/2, NULL);
	fft_mag(xt, xt, N);
	for (int i = 0; i < N; i++)
		y[i] = -20.0*log10f(wmax/(xt[i]*M_SQRT2));
}

/**
 * @brief Calculate the SNR of time-domain sequence
 * @param x Pointer to an sequence
 * @param N Number of elements
 * @param fs Sample frequency
 * @param en Number of excluded harmonics (>=2)
 * @param fn Pointer to a fundamental frequency to be returned
 * @return SNR
 */
float meas_snr(const float *x, int N, float fs, int en, float *fn)
{
	const int exn = 1;
	float *w = kaiser_win;
	float snr;
	float xmean;
	float x_pow, n_pow;
	int xmi;
	int dc_i, fnl_i, fnr_i, hn_i;
	int z;

//	wind_kaiser(w, N, 38);
	xmean = meas_mean(x, N);
	for (int i = 0; i < N; i++)
		xt[i] = (x[i] - xmean) * w[i];
	fft_mag(xt, xt, N);
	N /= 2;
	meas_max(xt, N, &xmi);
	extreme2(xt, N, 0, 1, -1, exn, NULL, &dc_i);
	for (int i = 0; i < dc_i; i++)
		xt[i] = 0.0;
	extreme2(xt, N, xmi, -1, -1, exn, NULL, &fnl_i);
	extreme2(xt, N, xmi, 1, -1, exn, NULL, &fnr_i);
	x_pow = 0.0;
	for (int i = fnl_i; i < fnr_i; i++) {
		x_pow += xt[i] * xt[i];
		xt[i] = 0.0;
	}
	x_pow = sqrtf(x_pow);

	for (int i = 2; i <= en; i++) {
		z = 0;
		hn_i = xmi*i;
		while (hn_i > (N-1)) {
			hn_i = hn_i - N + 1;
			z = z + 1;
		}
		if (z % 2)
			hn_i = N - 1 - hn_i;
		if (hn_i < 0)
			hn_i = 0;
		extreme2(xt, N, hn_i, -1, -1, exn, NULL, &fnl_i);
		extreme2(xt, N, hn_i, 1, -1, exn, NULL, &fnr_i);
		for (int i = fnl_i; i < fnr_i; i++)
			xt[i] = 0.0;
	}
	n_pow = 0.0;
	for (int i = 0; i < N; i++)
		n_pow += xt[i] * xt[i];
	n_pow = sqrtf(n_pow);
	snr = 20*log10f(x_pow/n_pow);
	if (fn)
		*fn = fs*xmi/(2*N);

	return snr;
}

/**
 * @brief Search an local maxima or minima value and its index
 * @param x Pointer to an array
 * @param N Number of elements
 * @param ind Start index
 * @param dir Direction (-1 - left, 1 - right)
 * @param type Type (-1 - minima, 1 - maxima)
 * @param exn Number of local
 * @param val Value
 * @param vind Index
 */
static void extreme2(float *x, int N, int ind, int dir, int type, int exn, float *val, int *vind)
{
	int end_index = (dir == 1) ? (N-1) : 0;
	float loc[3] = {x[ind], x[ind], x[ind]};
	int ln = 0;
	int i = ind;
	int j = ind;

	while (i != end_index) {
		loc[0] = loc[1];
		loc[1] = loc[2];
		loc[2] = x[i];
		if (type == -1) {
			if ((loc[0] > loc[1]) && (loc[1] < loc[2])) {
				ln = ln + 1;
				if (ln >= exn) {
					j = i - dir;
					j = (j < 0) ? 0 : j;
					break;
				}
			}
		} else {
			if ((loc[0] < loc[1]) && (loc[1] > loc[2])) {
				ln = ln + 1;
				if (ln >= exn) {
					j = i - dir;
					j = (j > (N - 1)) ? N - 1 : j;
					break;
				}
			}
		}
		i += dir;
	}
	if (val)
		*val = x[j];
	if (vind)
		*vind = j;
}

/**
 * @brief Generate Kaiser window
 * @param w Pointer to a window
 * @param N Number of elements
 * @param b Coefficient
 * @return void
 */
static void wind_kaiser(float *w, int N, float b)
{
	if (N == 1)
		w[0] = 1;
	else
		for (int i = 0; i < N; i++)
			w[i] = besseli0(2.0*b/(N-1)*sqrtf(i*((N-1)-i)))/besseli0(b);
}

/**
 * @brief Calculates Bessel`s Modified Function I0 of input value
 * @param x Input value
 * @return result
 */
static float besseli0(float x)
{
	float a, y, i;

	a = fabsf(x);
	if (a < 3.75) {
		y = x/3.75;
		y = y*y;
		i = 0.0045813*(y+0.411292)*(y+1.91727)*(y*y+0.852152*y+31.5905)*(y*y+4.69408*y+8.76235);
	} else {
		y = 3.75/a;
		i = expf(a)/sqrtf(a);
		i *= 0.00392377*(y*y-4.52206*y+5.5647)*(y*y-2.42271*y+3.96918)*(y*y+0.400887*y+2.55045)*(y*y+2.34477*y+1.80488);
	}
	return i;
}
