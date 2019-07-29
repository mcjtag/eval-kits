/**
 * @file osclib.c
 * @brief Oscilloscope library
 * @author matyunin.d
 * @date 22.07.2019
 */

#include "osclib.h"
#include "../hal/hal.h"
#include <math.h>

#define BUFLEN	512

static float ch_data[4][BUFLEN];
static u8 chan_active;
static u32 chan_color[4] = {COLOR_LIME, COLOR_YELLOW, COLOR_BLUE, COLOR_RED};
static struct osc_info meas_info;
static const int chan_ro[6][2] = {{0,1},{0,2},{0,3},{1,2},{1,3},{2,3}};

static void draw_wnd_main(void);
static void draw_grid(void);
static void draw_legend();
static void draw_signal(int chan);
static void draw_info(void);

/**
 * @brief Set signal data to view
 * @chan Channel number (0-3)
 * @data Pointer to signal data
 * @return void
 */
void osclib_set_data(int chan, float *data)
{
	for (int i = 0; i < BUFLEN; i++)
		ch_data[chan][i] = data[i];
}

/**
 * @brief Set measurement info to view
 * @param info Pointer to info structure
 * @return void
 */
void osclib_set_info(struct osc_info *info)
{
	meas_info = *info;
}

/**
 * @brief Set active channels to view
 * @param chan_msk Mask of active channels
 * @return void
 */
void osclib_set_active(u8 chan_msk)
{
	chan_active = chan_msk;
}

/**
 * @brief Update window (refresh)
 * @return void
 */
void osclib_update(void)
{
	tft_clear(&tft);
	draw_wnd_main();
	draw_grid();
	for (int i = 0; i < 4; i++)
		if (chan_active & (1 << i)) {
			draw_signal(i);
		}
	draw_legend();
	draw_info();
	tft_resync(&tft);
}

/**
 * @brief Draw a main window
 * @return void
 */
static void draw_wnd_main(void)
{
	tft_draw_rect(&tft, 1, 1, tft.width-2, tft.height-2, COLOR_WHITE, 0, LINE_SOLID, 0);
	tft_draw_rect(&tft, 3, 3, tft.width-6, tft.height-6, COLOR_WHITE, tft.bgcolor, LINE_SOLID, 1);
	tft_set_pos(&tft, tft.width/2 - 90, 0);
	tft_set_color(&tft, COLOR_CYAN, tft.bgcolor);
	tft_printf(&tft, "   Oscilloscope   ");
}

/**
 * @brief Draw a legend
 * @return void
 */
static void draw_legend()
{
	tft_draw_rect(&tft, 20, 20, 10, 10, COLOR_WHITE, (chan_active & 1) ? chan_color[0] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 35, 10, 10, COLOR_WHITE, (chan_active & 2) ? chan_color[1] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 50, 10, 10, COLOR_WHITE, (chan_active & 4) ? chan_color[2] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 65, 10, 10, COLOR_WHITE, (chan_active & 8) ? chan_color[3] : tft.bgcolor, LINE_SOLID, 1);

	tft_set_pos(&tft, 35, 20);
	tft_printf(&tft, "#1");
	tft_set_pos(&tft, 35, 35);
	tft_printf(&tft, "#2");
	tft_set_pos(&tft, 35, 50);
	tft_printf(&tft, "#3");
	tft_set_pos(&tft, 35, 65);
	tft_printf(&tft, "#4");
}

/**
 * @brief Draw a grid
 * @return void
 */
static void draw_grid(void)
{
	const int x_step = 5;
	const int x_step2 = 25;
	const u32 x = 15;
	const u32 y = 15;

	for (int i = 0; i < (tft.width-x*2)/x_step; i++) {
		tft_draw_line(&tft, x+x_step*i, y, x+x_step*i, tft.height-y, COLOR_GRAY, LINE_LONGDOT);
	}
	for (int i = 0; i < (tft.width-x*2)/x_step2; i++) {
		tft_draw_line(&tft, x+x_step2*i, y+3, x+x_step2*i, tft.height-y-4, COLOR_GRAY, LINE_DOTDASH);
	}
	tft_draw_line(&tft, x, tft.height/2+2, tft.width-x-1, tft.height/2+2, COLOR_SILVER, LINE_SOLID);
	tft_draw_rect(&tft, x, y, tft.width-x*2, tft.height-y*2, COLOR_WHITE, 0, LINE_SOLID, 0);
}

/**
 * @brief Draw a signal data
 * @param chan Channel number (0-3)
 * @return void
 */
static void draw_signal(int chan)
{
	const u32 ox = 15;
	const u32 oy = 15;
	const u32 xmin = ox+1;
	const u32 xmax = tft.width-ox-2;
	const u32 ymin = oy+1;
	const u32 ymax = tft.height-oy-2;
	const u32 yrng = (ymax-ymin)/2;
	const u32 yoff = tft.height/2;

	int c = 0;
	u32 y0, y1;

	for (int i = xmin; i < xmax; i++) {
		y0 = (u32)((float)yrng*(-ch_data[chan][c++])+yoff);
		y1 = (u32)((float)yrng*(-ch_data[chan][c])+yoff);

		if (y0 < ymin)
			y0 = ymin;
		if (y0 > ymax)
			y0 = ymax;
		if (y1 < ymin)
			y1 = ymin;
		if (y1 > ymax)
			y1 = ymax;

		tft_draw_rect(&tft, i, y0, 1, y1-y0, chan_color[chan], chan_color[chan], LINE_SOLID, 1);
	}
}

/**
 * @brief Draw measurements
 * @return void
 */
static void draw_info(void)
{
	const int x_off = 140;
	const int y_off = 12;
	int y = 25;

	for (int i = 0; i < 4; i++) {
		if (chan_active & (1 << i)) {
			tft_set_pos(&tft, tft.width-x_off, y);
			tft_printf(&tft, "RMS #%d = %.2f", i+1, meas_info.rms[i]);
			y += y_off;
		}
	}
	for (int i = 0; i < 4; i++) {
		if (chan_active & (1 << i)) {
			tft_set_pos(&tft, tft.width-x_off, y);
			tft_printf(&tft, "SNR #%d = %.2f", i+1, meas_info.snr[i]);
			y += y_off;
		}
	}
	/* Not today
	for (int i = 0; i < 4; i++) {
		if (chan_active & (1 << i)) {
			tft_set_pos(&tft, tft.width-x_off, y);
			tft_printf(&tft, "Ffu #%d = %.2f", i, meas_info.freq[i]);
			y += y_off;
		}
	}
	*/
	for (int i = 0; i < 6; i++) {
		if (chan_active & (1 << chan_ro[i][0]) && chan_active & (1 << chan_ro[i][1])) {
			tft_set_pos(&tft, tft.width-x_off, y);
			y += y_off;
			tft_printf(&tft, "Ro #%d%d = %.2f", chan_ro[i][0]+1, chan_ro[i][1]+1, meas_info.ro[i]);
		}
	}
}
