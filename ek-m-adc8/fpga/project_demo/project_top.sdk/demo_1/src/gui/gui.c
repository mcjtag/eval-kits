/**
 * @file gui.c
 * @brief GUI driver
 * @author matyunin.d
 * @date 15.08.2019
 */

#include "gui.h"
#include "../hal/hal.h"

static u32 chan_color[8] = {COLOR_LIME, COLOR_YELLOW, COLOR_BLUE, COLOR_RED, COLOR_MAGENTA, COLOR_OLIVE, COLOR_PURPLE, COLOR_MORANGE};

/**
 * @brief Show table GUI
 * @param tbl Pointer to table structure
 * @return void
 */
void gui_table(struct gtable *tbl)
{
	const u32 x0 = 3;
	const u32 y0 = 3;
	const u32 xn = tft.width-6;
	const u32 yn = tft.height-6;
	const u32 rn = 9;
	const u32 cn = 13;
	const u32 xd = (xn-x0)/cn;
	const u32 yd = (yn-y0)/rn;
	u32 x, y;

	/* Clear and draw table */
	tft_clear(&tft);
	tft_draw_rect(&tft, 1, 1, tft.width-2, tft.height-2, COLOR_WHITE, 0, LINE_SOLID, 0);
	tft_draw_rect(&tft, x0, y0, xn, yn, COLOR_WHITE, tft.bgcolor, LINE_SOLID, 1);
	tft_set_pos(&tft, tft.width/2 - 90, 0);
	tft_set_color(&tft, COLOR_LIME, tft.bgcolor);

	y = y0 + yd;
	for (int i = 0; i < rn; i++, y += yd)
		tft_draw_line(&tft, x0 + 1, y, xn, y, COLOR_WHITE, LINE_SOLID);
	x = x0 + xd;
	for (int i = 0; i < cn; i++, x += xd)
		tft_draw_line(&tft, x, y0 + 1, x, yn, COLOR_WHITE, LINE_SOLID);

	/* Fill table with values */
	y = y0 + yd/2 - 3;
	for (int i = 0; i < rn; i++, y += yd) {
		x = x0 + 3;
		for (int j = 0; j < cn; j++, x += xd) {
			tft_set_pos(&tft, x, y);
			tft_set_color(&tft, tbl->cell[i][j].color, tft.bgcolor);
			tft_printf(&tft, "%s", tbl->cell[i][j].txt);
		}
	}

	/* Refresh */
	tft_resync(&tft);
}

/**
 * @brief Show oscilloscope GUI
 * @param dat Pointer to oscilloscope data structure
 * @return void
 */
void gui_oscil(struct gosc_data *dat)
{
	const int x_step = 5;
	const int x_step2 = 25;
	const u32 x = 15;
	const u32 y = 15;

	const u32 ox = 15;
	const u32 oy = 15;
	const u32 xmin = ox+1;
	const u32 xmax = tft.width-ox-2;
	const u32 ymin = oy+1;
	const u32 ymax = tft.height-oy-2;
	const u32 yrng = (ymax-ymin)/2;
	const u32 yoff = tft.height/2;
	int c;
	u32 y0, y1;

	/* Clear and draw main window */
	tft_clear(&tft);
	tft_draw_rect(&tft, 1, 1, tft.width-2, tft.height-2, COLOR_WHITE, 0, LINE_SOLID, 0);
	tft_draw_rect(&tft, 3, 3, tft.width-6, tft.height-6, COLOR_WHITE, tft.bgcolor, LINE_SOLID, 1);
	tft_set_pos(&tft, tft.width/2 - 90, 0);
	tft_set_color(&tft, COLOR_CYAN, tft.bgcolor);
	tft_printf(&tft, "   Oscilloscope   ");

	/* Draw grid */
	for (int i = 0; i < (tft.width-x*2)/x_step; i++) {
		tft_draw_line(&tft, x+x_step*i, y, x+x_step*i, tft.height-y, COLOR_GRAY, LINE_LONGDOT);
	}
	for (int i = 0; i < (tft.width-x*2)/x_step2; i++) {
		tft_draw_line(&tft, x+x_step2*i, y+3, x+x_step2*i, tft.height-y-4, COLOR_GRAY, LINE_DOTDASH);
	}
	tft_draw_line(&tft, x, tft.height/2+2, tft.width-x-1, tft.height/2+2, COLOR_SILVER, LINE_SOLID);
	tft_draw_rect(&tft, x, y, tft.width-x*2, tft.height-y*2, COLOR_WHITE, 0, LINE_SOLID, 0);

	/* Draw active signals */
	for (int i = 0; i < 8; i++)
		if (dat->active & (1 << i)) {
			c = 0;
			for (int j = xmin; j < xmax; j++) {
				y0 = (u32)((float)yrng*(-dat->data[i][c++])+yoff);
				y1 = (u32)((float)yrng*(-dat->data[i][c])+yoff);

				if (y0 < ymin)
					y0 = ymin;
				if (y0 > ymax)
					y0 = ymax;
				if (y1 < ymin)
					y1 = ymin;
				if (y1 > ymax)
					y1 = ymax;

				tft_draw_rect(&tft, j, y0, 1, y1-y0, chan_color[i], chan_color[i], LINE_SOLID, 1);
			}
		}

	/* Draw legend */
	tft_draw_rect(&tft, 20, 20, 10, 10, COLOR_WHITE, (dat->active & 0x01) ? chan_color[0] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 35, 10, 10, COLOR_WHITE, (dat->active & 0x02) ? chan_color[1] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 50, 10, 10, COLOR_WHITE, (dat->active & 0x04) ? chan_color[2] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 65, 10, 10, COLOR_WHITE, (dat->active & 0x08) ? chan_color[3] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 80, 10, 10, COLOR_WHITE, (dat->active & 0x10) ? chan_color[4] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 95, 10, 10, COLOR_WHITE, (dat->active & 0x20) ? chan_color[5] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 110, 10, 10, COLOR_WHITE, (dat->active & 0x40) ? chan_color[6] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 125, 10, 10, COLOR_WHITE, (dat->active & 0x80) ? chan_color[7] : tft.bgcolor, LINE_SOLID, 1);

	tft_set_pos(&tft, 35, 20);
	tft_printf(&tft, "#0");
	tft_set_pos(&tft, 35, 35);
	tft_printf(&tft, "#1");
	tft_set_pos(&tft, 35, 50);
	tft_printf(&tft, "#2");
	tft_set_pos(&tft, 35, 65);
	tft_printf(&tft, "#3");
	tft_set_pos(&tft, 35, 80);
	tft_printf(&tft, "#4");
	tft_set_pos(&tft, 35, 95);
	tft_printf(&tft, "#5");
	tft_set_pos(&tft, 35, 110);
	tft_printf(&tft, "#6");
	tft_set_pos(&tft, 35, 125);
	tft_printf(&tft, "#7");

	/* Refresh */
	tft_resync(&tft);
}

/**
 * @brief Show spectrum GUI
 * @param dat Pointer to spectrum data structure
 * @return void
 */
void gui_spect(struct gspe_data *dat)
{
	const int x_step = 5;
	const int x_step2 = 25;
	const u32 x = 15;
	const u32 y = 15;

	const u32 ox = 15;
	const u32 oy = 15;
	const u32 xmin = ox+1;
	const u32 xmax = tft.width-ox-2;
	const u32 ymin = oy+1;
	const u32 ymax = tft.height-oy-2;
	const u32 yrng = ymax-ymin;
	int c;
	u32 y0, y1;

	/* Clear and draw main window */
	tft_clear(&tft);
	tft_draw_rect(&tft, 1, 1, tft.width-2, tft.height-2, COLOR_WHITE, 0, LINE_SOLID, 0);
	tft_draw_rect(&tft, 3, 3, tft.width-6, tft.height-6, COLOR_WHITE, tft.bgcolor, LINE_SOLID, 1);
	tft_set_pos(&tft, tft.width/2 - 90, 0);
	tft_set_color(&tft, COLOR_CYAN, tft.bgcolor);
	tft_printf(&tft, "     Spectrum     ");

	/* Draw grid */
	for (int i = 0; i < (tft.width-x*2)/x_step; i++) {
		tft_draw_line(&tft, x+x_step*i, y, x+x_step*i, tft.height-y, COLOR_GRAY, LINE_LONGDOT);
	}
	for (int i = 0; i < (tft.width-x*2)/x_step2; i++) {
		tft_draw_line(&tft, x+x_step2*i, y+3, x+x_step2*i, tft.height-y-4, COLOR_GRAY, LINE_DOTDASH);
	}
	tft_draw_rect(&tft, x, y, tft.width-x*2, tft.height-y*2, COLOR_WHITE, 0, LINE_SOLID, 0);

	/* Draw active signals */
	for (int i = 0; i < 8; i++)
		if (dat->active & (1 << i)) {
			c = 0;
			for (int j = xmin; j < xmax; j++) {
				y0 = (u32)((float)yrng*(-dat->data[i][c++]));
				y1 = (u32)((float)yrng*(-dat->data[i][c]));
				if (y0 < ymin)
					y0 = ymin;
				if (y0 > ymax)
					y0 = ymax;
				if (y1 < ymin)
					y1 = ymin;
				if (y1 > ymax)
					y1 = ymax;

				tft_draw_rect(&tft, j, y0, 1, y1-y0, chan_color[i], chan_color[i], LINE_SOLID, 1);
			}
	}

	/* Draw legend */
	tft_draw_rect(&tft, 20, 20, 10, 10, COLOR_WHITE, (dat->active & 0x01) ? chan_color[0] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 35, 10, 10, COLOR_WHITE, (dat->active & 0x02) ? chan_color[1] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 50, 10, 10, COLOR_WHITE, (dat->active & 0x04) ? chan_color[2] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 65, 10, 10, COLOR_WHITE, (dat->active & 0x08) ? chan_color[3] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 80, 10, 10, COLOR_WHITE, (dat->active & 0x10) ? chan_color[4] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 95, 10, 10, COLOR_WHITE, (dat->active & 0x20) ? chan_color[5] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 110, 10, 10, COLOR_WHITE, (dat->active & 0x40) ? chan_color[6] : tft.bgcolor, LINE_SOLID, 1);
	tft_draw_rect(&tft, 20, 125, 10, 10, COLOR_WHITE, (dat->active & 0x80) ? chan_color[7] : tft.bgcolor, LINE_SOLID, 1);

	tft_set_pos(&tft, 35, 20);
	tft_printf(&tft, "#0");
	tft_set_pos(&tft, 35, 35);
	tft_printf(&tft, "#1");
	tft_set_pos(&tft, 35, 50);
	tft_printf(&tft, "#2");
	tft_set_pos(&tft, 35, 65);
	tft_printf(&tft, "#3");
	tft_set_pos(&tft, 35, 80);
	tft_printf(&tft, "#4");
	tft_set_pos(&tft, 35, 95);
	tft_printf(&tft, "#5");
	tft_set_pos(&tft, 35, 110);
	tft_printf(&tft, "#6");
	tft_set_pos(&tft, 35, 125);
	tft_printf(&tft, "#7");

	/* Refresh */
	tft_resync(&tft);
}
