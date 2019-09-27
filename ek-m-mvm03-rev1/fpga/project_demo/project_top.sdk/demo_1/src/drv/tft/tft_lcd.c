/**
 * @file tft_lcd.c
 * @brief TFT LCD Driver
 * @author matyunin.d
 * @date 14.06.2019
 */

#include "tft_lcd.h"
#include <string.h>

#define LCD_CMD			0
#define LCD_DATA		1

#define MIN(a, b)	(((a) < (b)) ? (a) : (b))

extern const uint8_t ch_font_1206[95][12];
extern const uint8_t ch_font_1608[95][16];

extern void tft_bkl_set(void);
extern void tft_bkl_clr(void);
extern void tft_lcd_cs_set(void);
extern void tft_lcd_cs_clr(void);
extern void tft_dc_set(void);
extern void tft_dc_clr(void);
extern void tft_write(uint8_t *data, uint16_t count);
extern void tft_delay_ms(uint16_t value);

/**
 * @brief Write byte to LCD
 * @param byte
 * @param cmd
 * @return void
 */
static void lcd_write_byte(uint8_t byte, uint8_t cmd)
{
	uint8_t data = byte;
    if (cmd) {
        tft_dc_set();
    } else {
    	tft_dc_clr();
    }

    tft_lcd_cs_clr();
	tft_write(&data, 1);
	tft_lcd_cs_set();
}

/**
 * @brief Write word (2 bytes) to LCD
 * @param word
 * @return void
 */
static void lcd_write_word(uint16_t word)
{
	uint8_t data[2] = {word >> 8, word & 0xFF};
	tft_dc_set();
	tft_lcd_cs_clr();
	tft_write(data, 2);
	tft_lcd_cs_set();
}

/**
 * @brief Write value to LCD register
 * @param reg
 * @param value
 * @return void
 */
static void lcd_write_register(uint8_t reg, uint8_t value)
{
	lcd_write_byte(reg, LCD_CMD);
	lcd_write_byte(value, LCD_DATA);
}

/**
 * @brief Set the specified position of cursor on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @return void
 */
void lcd_set_cursor(uint16_t xpos, uint16_t ypos)
{
	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

    lcd_write_register(0x02, xpos >> 8);
	lcd_write_register(0x03, xpos & 0xFF); //Column Start
	lcd_write_register(0x06, ypos >> 8);
	lcd_write_register(0x07, ypos & 0xFF); //Row Start
}

/**
 * @brief Clear the lcd with the specified color
 * @param color Color of the screen
 * @return void
 */
void lcd_clear_screen(uint16_t color)
{
	uint8_t tmp[LCD_WIDTH*2];

	for (int i = 0; i < LCD_WIDTH*2; i+=2) {
		tmp[i] = color >> 8;
		tmp[i+1] = color & 0xFF;
	}

	for (int i = 0; i < LCD_HEIGHT; i++)
	{
		lcd_set_cursor(0, i);
		lcd_write_byte(0x22, LCD_CMD);

		tft_dc_set();
		tft_lcd_cs_clr();
		tft_write(tmp, LCD_WIDTH*2);
		tft_lcd_cs_set();
	}
}

/**
 * @brief Draw a point on the lcd with the specified color.
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param color Color of the point
 * @return void
 */
void lcd_draw_point(uint16_t xpos, uint16_t ypos, uint16_t color)
{
	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

	lcd_set_cursor(xpos, ypos);
	lcd_write_byte(0x22, LCD_CMD);
    lcd_write_word(color);
}

/**
 * @brief Display a char at the specified position on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param chr A char is display
 * @param size Specify the size of the char
 * @param color Specify the color of the char
 * @return void
 */
void lcd_display_char(uint16_t xpos, uint16_t ypos, uint8_t chr, uint8_t size, uint16_t color)
{
	uint8_t i, j, tmp;
	uint16_t ypos0 = ypos, color_val = 0;

	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

    for (i = 0; i < size; i ++) {
		if (FONT_1206 == size) {
			tmp = ch_font_1206[chr - 0x20][i];
		} else if (FONT_1608 == size) {
			tmp = ch_font_1608[chr - 0x20][i];
		}

        for (j = 0; j < 8; j ++) {
    		if (tmp & 0x80) {
				color_val = color;
				lcd_draw_point(xpos, ypos, color_val);
    		}
			tmp <<= 1;
			ypos++;
			if ((ypos - ypos0) == size) {
				ypos = ypos0;
				xpos++;
				break;
			}
		}
    }
}


/**
 * @brief Calculate power of n
 * @param m
 * @param n
 * @return M^N
 */
static uint32_t _pow(uint8_t m, uint8_t n)
{
	uint32_t result = 1;

	while (n--)
		result *= m;

	return result;
}

/**
 * @brief Display a number at the specified position on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param num A number is display
 * @param len Length ot the number
 * @param size Specify the size of the number
 * @param color Specify the color of the number
 * @return void
 */
void lcd_display_num(uint16_t xpos, uint16_t ypos, uint32_t num, uint8_t len, uint8_t size, uint16_t color)
{
	uint8_t i;
	uint8_t tmp, show = 0;

	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

	for(i = 0; i < len; i ++) {
		tmp = (num / _pow(10, len - i - 1)) % 10;
		if (show == 0 && i < (len - 1)) {
			if(tmp == 0) {
				lcd_display_char(xpos + (size / 2) * i, ypos, ' ', size, color);
				continue;
			} else {
				show = 1;
			}
		}
	 	lcd_display_char(xpos + (size / 2) * i, ypos, tmp + '0', size, color);
	}
}

/**
 * @brief Display a string at the specified position on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param str A pointer to string
 * @param size The size of the string
 * @param color Specify the color of the string
 * @return void
 */
void lcd_display_string(uint16_t xpos, uint16_t ypos, const uint8_t *str, uint8_t size, uint16_t color)
{

	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

	while (*str != '\0') {
		if (xpos > (LCD_WIDTH - size / 2)) {
			xpos = 0;
			ypos += size;
			if (ypos > (LCD_HEIGHT - size)) {
				ypos = xpos = 0;
				lcd_clear_screen(0x00);
			}
		}

		lcd_display_char(xpos, ypos, (uint8_t)*str, size, color);
		xpos += size / 2;
		str++;
    }
}

/**
 * @brief Draw a line at the specified position on LCD
 * @param xpos0 Specify x0 position
 * @param ypos0 Specify y0 position
 * @param xpos1 Specify x1 position
 * @param ypos1 Specify y1 position
 * @param color Specify the color of the line
 * @return void
 */
void lcd_draw_line(uint16_t xpos0, uint16_t ypos0, uint16_t xpos1, uint16_t ypos1, uint16_t color)
{
	int x = xpos1 - xpos0;
    int y = ypos1 - ypos0;
    int dx = abs(x), sx = xpos0 < xpos1 ? 1 : -1;
    int dy = -abs(y), sy = ypos0 < ypos1 ? 1 : -1;
    int err = dx + dy, e2;

	if (xpos0 >= LCD_WIDTH || ypos0 >= LCD_HEIGHT || xpos1 >= LCD_WIDTH || ypos1 >= LCD_HEIGHT)
		return;

    for (;;){
        lcd_draw_point(xpos0, ypos0 , color);
        e2 = 2 * err;
        if (e2 >= dy) {
            if (xpos0 == xpos1)
            	break;
            err += dy;
            xpos0 += sx;
        }
        if (e2 <= dx) {
            if (ypos0 == ypos1)
            	break;
            err += dx;
            ypos0 += sy;
        }
    }
}

/**
 * @brief Draw a circle at the specified position on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param radius Specify the radius of the circle
 * @param color Specify the color of the circle
 * @return void
 */
void lcd_draw_circle(uint16_t xpos, uint16_t ypos, uint16_t radius, uint16_t color)
{
	int x = -radius, y = 0, err = 2 - 2 * radius, e2;

	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

    do {
        lcd_draw_point(xpos - x, ypos + y, color);
        lcd_draw_point(xpos + x, ypos + y, color);
        lcd_draw_point(xpos + x, ypos - y, color);
        lcd_draw_point(xpos - x, ypos - y, color);
        e2 = err;
        if (e2 <= y) {
            err += ++ y * 2 + 1;
            if(-x == y && e2 <= x)
            	e2 = 0;
        }
        if(e2 > x)
        	err += ++ x * 2 + 1;
    } while(x <= 0);
}


/**
 * @brief Fill a rectangle out at the specified position on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param width Specify the width of the rectangle
 * @param height Specify the height of the rectangle
 * @param color Specify the color of rectangle
 * @return void
 */
void lcd_fill_rect(uint16_t xpos, uint16_t ypos, uint16_t width, uint16_t height, uint16_t color)
{
	uint16_t i, j;

	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

	for(i = 0; i < height; i ++){
		for(j = 0; j < width; j ++){
			lcd_draw_point(xpos + j, ypos + i, color);
		}
	}
}

/**
 * @brief Draw a vertical line at the specified position on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param height Specify the height of the vertical line
 * @param color Specify the color of the vertical line
 * @return void
 */
void lcd_draw_v_line(uint16_t xpos, uint16_t ypos, uint16_t height, uint16_t color)
{
	uint16_t i, y1 = MIN(ypos + height, LCD_HEIGHT - 1);

	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

    for (i = ypos; i < y1; i ++) {
        lcd_draw_point(xpos, i, color);
    }
}

/**
 * @brief Draw a horizonal line at the specified position on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param width Specify the width of the horizonal line
 * @param color Specify the color of the horizonal line
 * @return void
 */
void lcd_draw_h_line(uint16_t xpos, uint16_t ypos, uint16_t width, uint16_t color)
{
	uint16_t i, x1 = MIN(xpos + width, LCD_WIDTH - 1);

	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

    for (i = xpos; i < x1; i ++)
        lcd_draw_point(i, ypos, color);
}

/**
 * @brief Draw a rectangle at the specified position on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param width Specify the width of the rectangle
 * @param height Specify the height of the rectangle
 * @param color Specify the color of rectangle
 * @return void
 */
void lcd_draw_rect(uint16_t xpos, uint16_t ypos, uint16_t width, uint16_t height, uint16_t color)
{
	if (xpos >= LCD_WIDTH || ypos >= LCD_HEIGHT)
		return;

	lcd_draw_h_line(xpos, ypos, width, color);
	lcd_draw_h_line(xpos, ypos + height, width, color);
	lcd_draw_v_line(xpos, ypos, height, color);
	lcd_draw_v_line(xpos + width, ypos, height + 1, color);
}


/**
 * @brief Initialize the LCD
 * @return void
 */
void lcd_init(void)
{
	tft_dc_clr();
    tft_lcd_cs_clr();
    tft_dc_set();
    tft_lcd_cs_set();
    tft_bkl_clr();

	//Driving ability Setting
	lcd_write_register(0xEA,0x00); //PTBA[15:8]
	lcd_write_register(0xEB,0x20); //PTBA[7:0]
	lcd_write_register(0xEC,0x0C); //STBA[15:8]
	lcd_write_register(0xED,0xC4); //STBA[7:0]
	lcd_write_register(0xE8,0x38); //OPON[7:0]
	lcd_write_register(0xE9,0x10); //OPON1[7:0]
	lcd_write_register(0xF1,0x01); //OTPS1B
	lcd_write_register(0xF2,0x10); //GEN
	//Gamma 2.2 Setting
	lcd_write_register(0x40,0x01); //
	lcd_write_register(0x41,0x00); //
	lcd_write_register(0x42,0x00); //
	lcd_write_register(0x43,0x10); //
	lcd_write_register(0x44,0x0E); //
	lcd_write_register(0x45,0x24); //
	lcd_write_register(0x46,0x04); //
	lcd_write_register(0x47,0x50); //
	lcd_write_register(0x48,0x02); //
	lcd_write_register(0x49,0x13); //
	lcd_write_register(0x4A,0x19); //
	lcd_write_register(0x4B,0x19); //
	lcd_write_register(0x4C,0x16); //
	lcd_write_register(0x50,0x1B); //
	lcd_write_register(0x51,0x31); //
	lcd_write_register(0x52,0x2F); //
	lcd_write_register(0x53,0x3F); //
	lcd_write_register(0x54,0x3F); //
	lcd_write_register(0x55,0x3E); //
	lcd_write_register(0x56,0x2F); //
	lcd_write_register(0x57,0x7B); //
	lcd_write_register(0x58,0x09); //
	lcd_write_register(0x59,0x06); //
	lcd_write_register(0x5A,0x06); //
	lcd_write_register(0x5B,0x0C); //
	lcd_write_register(0x5C,0x1D); //
	lcd_write_register(0x5D,0xCC); //
	//Power Voltage Setting
	lcd_write_register(0x1B,0x1B); //VRH=4.65V
	lcd_write_register(0x1A,0x01); //BT (VGH~15V,VGL~-10V,DDVDH~5V)
	lcd_write_register(0x24,0x2F); //VMH(VCOM High voltage ~3.2V)
	lcd_write_register(0x25,0x57); //VML(VCOM Low voltage -1.2V)
	//****VCOM offset**///
	lcd_write_register(0x23,0x88); //for Flicker adjust //can reload from OTP
	//Power on Setting
	lcd_write_register(0x18,0x34); //I/P_RADJ,N/P_RADJ, Normal mode 60Hz
	lcd_write_register(0x19,0x01); //OSC_EN='1', start Osc
	lcd_write_register(0x01,0x00); //DP_STB='0', out deep sleep
	lcd_write_register(0x1F,0x88);// GAS=1, VOMG=00, PON=0, DK=1, XDK=0, DVDH_TRI=0, STB=0
	tft_delay_ms(5);
	lcd_write_register(0x1F,0x80);// GAS=1, VOMG=00, PON=0, DK=0, XDK=0, DVDH_TRI=0, STB=0
	tft_delay_ms(5);
	lcd_write_register(0x1F,0x90);// GAS=1, VOMG=00, PON=1, DK=0, XDK=0, DVDH_TRI=0, STB=0
	tft_delay_ms(5);
	lcd_write_register(0x1F,0xD0);// GAS=1, VOMG=10, PON=1, DK=0, XDK=0, DDVDH_TRI=0, STB=0
	tft_delay_ms(5);
	//262k/65k color selection
	lcd_write_register(0x17,0x05); //default 0x06 262k color // 0x05 65k color
	//SET PANEL
	lcd_write_register(0x36,0x00); //SS_P, GS_P,REV_P,BGR_P
	//Display ON Setting
	lcd_write_register(0x28,0x38); //GON=1, DTE=1, D=1000
	tft_delay_ms(40);
	lcd_write_register(0x28,0x3F); //GON=1, DTE=1, D=1100
	lcd_write_register(0x16,0x18);
	//Set GRAM Area
	lcd_write_register(0x02,0x00);
	lcd_write_register(0x03,0x00); //Column Start
	lcd_write_register(0x04,0x00);
	lcd_write_register(0x05,0xEF); //Column End
	lcd_write_register(0x06,0x00);
	lcd_write_register(0x07,0x00); //Row Start
	lcd_write_register(0x08,0x01);
	lcd_write_register(0x09,0x3F); //Row End

    lcd_clear_screen(BLACK);
	tft_bkl_set();
}

/**
 * @brief Turn the backlight on
 * @return void
 */
void lcd_on(void)
{
	tft_bkl_set();
}

/**
 * @brief Turn the backlight off
 * @return void
 */
void lcd_off(void)
{
	tft_bkl_clr();
}

/**
 * @brief Draw a bitmap picture at the specified position on LCD
 * @param xpos Specify x position
 * @param ypos Specify y position
 * @param bitmap A pointer to bitmap array
 * @return void
 */
void lcd_draw_bitmap(uint16_t xpos, uint16_t ypos, uint8_t *bitmap)
{
	uint32_t index = 0, width = 0, height = 0;
	uint32_t bmpaddress, bit_pixel = 0;
    uint16_t color = 0;
    uint32_t offset = 0;
    uint16_t k;

    bmpaddress = (uint32_t)bitmap;

    /* Get bitmap data address offset */
    index = *(uint16_t *) (bmpaddress + 10);
    index |= (*(uint16_t *) (bmpaddress + 12)) << 16;

    /* Read bitmap width */
    width = *(uint16_t *) (bmpaddress + 18);
    width |= (*(uint16_t *) (bmpaddress + 20)) << 16;

    /* Read bitmap height */
    height = *(uint16_t *) (bmpaddress + 22);
    height |= (*(uint16_t *) (bmpaddress + 24)) << 16;

    /* Read bit/pixel */
    bit_pixel = *(uint16_t *) (bmpaddress + 28);

    if (bit_pixel != 24)
    	return;

    offset = ((((width * bit_pixel) + 31 ) >> 5) << 2) >> 1;

    uint8_t *ibuf = (uint8_t *)malloc(width*3);

    if (!ibuf)
    	return;

    for (int i = 0; i < height; i ++) {
    	memcpy(ibuf, &bitmap[index], offset);
    	index += offset;
    	memcpy(ibuf + offset, &bitmap[index], offset);
    	index += offset;

        lcd_set_cursor(xpos, ypos + i);
        lcd_write_byte(0x22, LCD_CMD);
        for (int j = 0; j < width; j ++) {
            k = j * 3;
            color = (uint16_t)(((ibuf[k + 2] >> 3) << 11 ) | ((ibuf[k + 1] >> 2) << 5) | (ibuf[k] >> 3));
            lcd_write_word(color);
        }
    }

    free(ibuf);
}
