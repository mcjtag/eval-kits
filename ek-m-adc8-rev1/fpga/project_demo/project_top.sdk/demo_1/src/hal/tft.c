/**
 * @file tft.c
 * @brief TFT HAL
 * @author matyunin.d
 * @date 17.07.2019
 */

#include "tft.h"
#include <stdlib.h>
#include <stdio.h>

#define VMEMORY		0x00200000

#define PWM_PERIOD	10000000
#define PWM_HIGH	9000000

static const u8 line_pattern[7][12] = {
	{1,1,1,1,1,1,1,1,1,1,1,1}, 	/* Solid */
	{1,1,1,1,1,1,0,0,0,0,0,0},	/* Dashed */
	{0,1,0,1,0,1,0,1,0,1,0,1},	/* Dotted */
	{1,0,0,0,1,1,1,1,1,0,0,0},	/* Dotdash */
	{1,1,1,1,1,1,1,1,1,0,0,0},	/* Longdash */
	{1,1,1,0,0,1,1,1,1,1,0,0},	/* Twodash */
	{0,0,0,1,0,0,0,1,0,0,0,1}	/* Longdot */
};

static void xtft_set_frame_baseaddr_next(XTft *xtft, UINTPTR baseaddr);

/**
 * @brief TFT initialization
 * @param dev Pointer to device structure
 * @return XST_SUCCESS | XST_FAILURE
 */
int tft_init(struct tft_dev *dev)
{
	int status;
	XTft_Config *config_ptr;

	if (!dev)
		return XST_FAILURE;

	config_ptr = XTft_LookupConfig(dev->dev_id);
	if (config_ptr == (XTft_Config *)NULL)
		return XST_FAILURE;

	status = XTft_CfgInitialize(&dev->tft, config_ptr, config_ptr->BaseAddress);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	XTft_DisableDisplay(&dev->tft);
	XTft_EnableDisplay(&dev->tft);

	tft_resync(dev);
	tft_clear(dev);
	tft_resync(dev);
	tft_clear(dev);

//	XTft_EnableDisplay(&dev->tft);
	tft_backlight(dev, 100);

	return XST_SUCCESS;
}

/**
 * @brief Refresh frame
 * @param dev Pointer to device structure
 * @return void
 */
void tft_resync(struct tft_dev *dev)
{
	u32 baseaddr = dev->vram_high - VMEMORY*(dev->frame+1) + 1;
	while (XTft_GetVsyncStatus(&dev->tft) != TRUE);
	XTft_SetFrameBaseAddr(&dev->tft, baseaddr);
	dev->frame ^= 1;
	baseaddr = dev->vram_high - VMEMORY*(dev->frame+1) + 1;
	xtft_set_frame_baseaddr_next(&dev->tft, baseaddr);
}

/**
 * @brief Swap video buffer without refresh
 * @param dev Pointer to device structure
 * @return void
 */
void tft_resync_swap(struct tft_dev *dev)
{
	u32 baseaddr;
	dev->frame ^= 1;
	baseaddr = dev->vram_high - VMEMORY*(dev->frame+1) + 1;
	xtft_set_frame_baseaddr_next(&dev->tft, baseaddr);
}

/**
 * @brief formatted output conversion
 * @param dev Pointer to device structure
 * @param format String format
 * @param ... Variable arguments
 * @return XST_SUCCESS | XST_FAILURE
 */
int tft_printf(struct tft_dev *dev, const char *format, ...)
{
	char *str;
	char *ch;
	va_list ap;

	str = malloc(256);
	if (!str)
		return XST_FAILURE;

	va_start(ap, format);
	vsnprintf(str, 256, format, ap);
	va_end(ap);
	ch = str;
	while (*ch != 0) {
		XTft_Write(&dev->tft, *ch);
		ch++;
	}
	free(str);

	return XST_SUCCESS;
}

/**
 * @brief Set character position
 * @param dev Pointer to device structure
 * @param x X axis position
 * @param y Y axis position
 * @return void
 */
void tft_set_pos(struct tft_dev *dev, u32 x, u32 y)
{
	XTft_SetPosChar(&dev->tft, x, y);
}

/**
 * @brief Clear screen
 * @param dev Pointer to device structure
 * @return void
 */
void tft_clear(struct tft_dev *dev)
{
	XTft_ClearScreen(&dev->tft);
}

/**
 * @brief Set screen colors
 * @param dev Pointer to device structure
 * @param fgcolor Foreground color (TFT_COLOR)
 * @param bgcolor Background color (TFT_COLOR)
 * @return void
 */
void tft_set_color(struct tft_dev *dev, u32 fgcolor, u32 bgcolor)
{
	XTft_SetColor(&dev->tft, fgcolor, bgcolor);
	dev->bgcolor = bgcolor;
}

/**
 * @brief Draw a line
 * @param dev Pointer to device structure
 * @param x0 X axis start position
 * @param y0 Y axis start position
 * @param x1 X axis end position
 * @param y1 Y axis end position
 * @param color Color of the line (TFT_COLOR)
 * @param type Type of the line (TFT_LINE)
 */
int tft_draw_line(struct tft_dev *dev, u32 x0, u32 y0, u32 x1, u32 y1, u32 color, u8 type)
{
	const float yint_delta = 10.5;
	float slope;
	float yintercept;
	float mx;
	u32 xmin;
	u32 ymin;
	u32 xmax;
	u32 ymax;
	u32 ix;
	u32 iy;

	u32 pat;

	if (x0 >= 0 && x0 <= (dev->width - 1) &&
		x1 >= 0 && x1 <= (dev->width - 1) &&
		y0 >= 0 && y0 <= (dev->height - 1) &&
		y1 >= 0 && y1 <= (dev->height - 1)) {

		if (x1-x0 != 0) {
			slope = (float)(y1 - y0) / (float)(x1 - x0) * 100000.0;
			yintercept = (float)y0 - (slope / 100000.0) * (float)x0;
		} else {
			slope = 0.0;
			yintercept = -1.0;
		}

		if (x1 < x0) {
			xmin = x1;
			xmax = x0;
		} else {
			xmin = x0;
			xmax = x1;
		}

		if (y1 < y0) {
			ymin = y1;
			ymax = y0;
		} else {
			ymin = y0;
			ymax = y1;
		}

		pat = 0;
		for (ix = xmin; ix <= xmax; ix++) {
			mx = slope * (float)ix / 100000.0;
			for (iy = ymin; iy <= ymax; iy++) {
				if ((((float)iy - mx) >= (yintercept - yint_delta)) && (((float)iy - mx) <= (yintercept + yint_delta))) {
					XTft_SetPixel(&dev->tft, ix, iy, (line_pattern[type][pat++]) ? color : dev->bgcolor);
					if (pat == 12)
						pat = 0;
				} else {
					if((slope == 0.0) && (yintercept == -1.0)) {
						XTft_SetPixel(&dev->tft, ix, iy, (line_pattern[type][pat++]) ? color : dev->bgcolor);
						if (pat == 12)
							pat = 0;
					}
				}
			}
		}
		return XST_SUCCESS;
	} else {
		return XST_FAILURE;
	}
}

/**
 * @brief Draw a rectangle
 * @param dev Pointer to device structure
 * @param x X axis start position
 * @param y Y axis start position
 * @param width Rectangle width
 * @param height Rectangle height
 * @param bcolor Border color (TFT_COLOR)
 * @param fcolor Fill color (TFT_COLOR)
 * @param type Type of the line (TFT_LINE)
 * @param fill Fill flag
 */
int tft_draw_rect(struct tft_dev *dev, u32 x, u32 y, u32 width, u32 height, u32 bcolor, u32 fcolor, u8 type, int fill)
{
	if (tft_draw_line(dev, x, y, x+width-1, y, bcolor, type) != XST_SUCCESS)
		return XST_FAILURE;
	if (tft_draw_line(dev, x+width-1, y, x+width-1, y+height-1, bcolor, type) != XST_SUCCESS)
		return XST_FAILURE;
	if (tft_draw_line(dev, x, y+height-1, x+width-1, y+height-1, bcolor, type) != XST_SUCCESS)
		return XST_FAILURE;
	if (tft_draw_line(dev, x, y, x, y+height-1, bcolor, type) != XST_SUCCESS)
		return XST_FAILURE;

	if (fill) {
		for (int ix = x+1; ix < x+width-1; ix++) {
			for (int iy = y+1; iy < y+height-1; iy++) {
				XTft_SetPixel(&dev->tft, ix, iy, fcolor);
			}
		}
	}

	return XST_SUCCESS;
}

/**
 * @brief Draw a bitmap
 * @param dev Pointer to device structure
 * @param x X axis offset
 * @param y Y axis offset
 * @param bitmap Pointer to bitmap array
 */
void tft_draw_bitmap(struct tft_dev *dev, u16 x, u16 y, const u8 *bitmap)
{
	uint32_t index = 0, width = 0, height = 0;
	uint32_t bmpaddress, bit_pixel = 0;
    uint32_t color = 0;
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

        for (int j = 0; j < width; j ++) {
            k = j * 3;
            color = (uint32_t)((ibuf[k + 2] << 16 ) | (ibuf[k + 1] << 8) | ibuf[k]);
            XTft_SetPixel(&dev->tft, x + j, height - i + y, (u32)color);
        }
    }

    free(ibuf);
}

/**
 * @brief Set next video memory base address without changing hardware pointer (non-glitch refresh)
 * @param xtft Pointer to XTft device
 * @param baseaddr Next base address
 * @return void
 */
static void xtft_set_frame_baseaddr_next(XTft *xtft, UINTPTR baseaddr)
{
	Xil_AssertVoid(xtft != NULL);
	Xil_AssertVoid(xtft->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertVoid((baseaddr & 0x1FFFFF) == 0x0);

	xtft->TftConfig.VideoMemBaseAddr =  baseaddr;
}

/**
 * @brief Set brightness of screen
 * @param dev Pointer to device structure
 * @param bright Brightness value (percents)
 * @return void
 */
void tft_backlight(struct tft_dev *dev, float bright)
{
	u32 high;

	if (bright > 100.0)
		bright = 100.0;
	if (bright < 0.0)
		bright = 0.0;

	high = (u32)((float)PWM_HIGH * bright / 100.0);
	timer_pwm(dev->pwm, PWM_PERIOD, high);
}
