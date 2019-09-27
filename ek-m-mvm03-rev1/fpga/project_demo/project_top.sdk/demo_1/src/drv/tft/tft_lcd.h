/**
 * @file tft_lcd.h
 * @brief TFT LCD Driver
 * @author matyunin.d
 * @date 14.06.2019
 */

#ifndef TFT_LCD_H_
#define TFT_LCD_H_

#include "tft_lcd.h"
#include <math.h>
#include <stdlib.h>
#include <stdint.h>

#define LCD_WIDTH    240
#define LCD_HEIGHT   320

#define FONT_1206    12
#define FONT_1608    16

#define WHITE		0xFFFF
#define BLACK		0x0000
#define BLUE		0x001F
#define BRED		0XF81F
#define GRED		0XFFE0
#define GBLUE		0X07FF
#define RED			0xF800
#define MAGENTA		0xF81F
#define GREEN		0x07E0
#define CYAN		0x7FFF
#define YELLOW		0xFFE0
#define BROWN		0XBC40
#define BRRED		0XFC07
#define GRAY		0X8430
#define MORANGE		0xEB63

void lcd_init(void);
void lcd_on(void);
void lcd_off(void);
void lcd_clear_screen(uint16_t color);
void lcd_draw_point(uint16_t xpos, uint16_t ypos, uint16_t color);
void lcd_display_char(uint16_t xpos, uint16_t ypos, uint8_t chr, uint8_t size, uint16_t color);
void lcd_display_num(uint16_t xpos, uint16_t ypos, uint32_t num, uint8_t len, uint8_t size, uint16_t color);
void lcd_display_string(uint16_t xpos, uint16_t ypos, const uint8_t *str, uint8_t size, uint16_t color);
void lcd_draw_line(uint16_t xpos0, uint16_t ypos0, uint16_t xpos1, uint16_t ypos1, uint16_t color);
void lcd_draw_circle(uint16_t xpos, uint16_t ypos, uint16_t radius, uint16_t color);
void lcd_fill_rect(uint16_t xpos, uint16_t ypos, uint16_t width, uint16_t height, uint16_t color);
void lcd_draw_v_line(uint16_t xpos, uint16_t ypos, uint16_t height, uint16_t color);
void lcd_draw_h_line(uint16_t xpos, uint16_t ypos, uint16_t width, uint16_t color);
void lcd_draw_rect(uint16_t xpos, uint16_t ypos, uint16_t width, uint16_t height, uint16_t color);
void lcd_draw_bitmap(uint16_t xpos, uint16_t ypos, uint8_t *bitmap);

#endif /* TFT_LCD_H_ */
