/**
 * @file tft.h
 * @brief TFT HAL
 * @author matyunin.d
 * @date 17.07.2019
 */

#ifndef TFT_H_
#define TFT_H_

#include "timer.h"
#include "xtft.h"

enum TFT_COLOR {
	COLOR_BLACK		= 0x000000,
	COLOR_WHITE 	= 0xFFFFFF,
	COLOR_RED 		= 0xFF0000,
	COLOR_LIME		= 0x00FF00,
	COLOR_BLUE		= 0x0000FF,
	COLOR_YELLOW	= 0xFFFF00,
	COLOR_CYAN		= 0x00FFFF,
	COLOR_MAGENTA	= 0xFF00FF,
	COLOR_SILVER	= 0xC0C0C0,
	COLOR_GRAY		= 0x808080,
	COLOR_MAROON	= 0x800000,
	COLOR_OLIVE		= 0x808000,
	COLOR_GREEN		= 0x008000,
	COLOR_PURPLE	= 0x800080,
	COLOR_TEAL		= 0x008080,
	COLOR_NAVY		= 0x000080,
	COLOR_MORANGE	= 0xED6D1E
};

enum TFT_LINE {
	LINE_SOLID,
	LINE_DASHED,
	LINE_DOTTED,
	LINE_DOTDASH,
	LINE_LONGDASH,
	LINE_TWODASH,
	LINE_LONGDOT
};

struct tft_dev {
	XTft tft;
	u16 dev_id;
	u16 width;
	u16 height;
	u32 vram_high;
	u32 bgcolor;
	struct timer_dev *pwm;
	u32 vram_baseaddr;
	int frame;
};

int tft_init(struct tft_dev *dev);
void tft_resync(struct tft_dev *dev);
int tft_printf(struct tft_dev *dev, const char *format, ...);
void tft_set_pos(struct tft_dev *dev, u32 x, u32 y);
void tft_clear(struct tft_dev *dev);
void tft_set_color(struct tft_dev *dev, u32 fgcolor, u32 bgcolor);\
int tft_draw_line(struct tft_dev *dev, u32 x0, u32 y0, u32 x1, u32 y1, u32 color, u8 type);
int tft_draw_rect(struct tft_dev *dev, u32 x0, u32 y0, u32 x1, u32 y1, u32 bcolor, u32 fcolor, u8 type, int fill);
void tft_draw_bitmap(struct tft_dev *dev, u16 x, u16 y, const u8 *bitmap);
void tft_backlight(struct tft_dev *dev, float bright);

#endif /* TFT_H_ */
