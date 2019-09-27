#ifndef	__HAL_LCD__
#define	__HAL_LCD__

#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"


/*

   prev. line |   don't care                     VALID           don't care     | next line
Pixel data    |xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxVVVVVVVVVVVVVVVVVxxxxxxxxxxxxxxxxxx|xxx
DRDY          |______________________________*****************__________________|
HSYNC         |_____________*************_______________________________________|

              |             |           |    |                |                 |
         start of line      |           |    |                |                 |
              |             |           |    |                |                 |
              |<--hsp_pos-->|<-hsp_len->|    |                |                 |
              |<------- hfront_blank ------->|<--- h_size --->|<- hback_blank ->|
*/

#define windowBackgroundFromRgb(red, green, blue) ( ((red & 0xFF)<<16) | ((green & 0xFF) << 8) | ((blue & 0xFF) << 0) )


// Color modes
//                R            G            B	
// RGB888:    data[23:16]   data[15:8]   data[7:0]
// RGB565:    data[15:11]   data[10:5]   data[4:0]
// RGB444_AR: data[13:10]   data[8:5]    data[3:0]
// RGB444_AL: data[14:11]   data[9:6]    data[4:1]
// RGB233:    data[7:6]     data[5:3]    data[2:0]

//                   [buffer size div]  [3:2] = CD   [1:0] = VBL
#define	HAL_LCD_RGB888 		((1 << 4) | (0x3 << 2) | (0x0 << 0))
#define	HAL_LCD_RGB565 		((2 << 4) | (0x1 << 2) | (0x0 << 0))
#define	HAL_LCD_RGB444_AR 	((2 << 4) | (0x1 << 2) | (0x2 << 0))
#define	HAL_LCD_RGB444_AL	((2 << 4) | (0x1 << 2) | (0x3 << 0))
#define	HAL_LCD_RGB233		((4 << 4) | (0x0 << 2) | (0x0 << 0))


#define HAL_LCD_MAX_PWM_DUTY	100


typedef struct {
	uint16_t h_size;		// window size
	uint16_t v_size;
	int16_t h_offset;		// offset relative to area defined by h_size and v_size in main config structure
	int16_t v_offset;
	uint32_t backgnd_color;
} hal_lcd_window_config_t;


typedef struct {
	
	
	uint8_t rgb_mode;					// color_mode
	uint32_t core_clock_khz;
	uint32_t pixel_clock_khz;
	uint32_t pwm_div;					// PWM frequency = Fcore / (2 * HAL_LCD_MAX_PWM_DUTY * 2^pwm_div)
	uint32_t vsync_active_level :1;
	uint32_t hsync_active_level :1;
	uint32_t dready_active_level :1;
	uint32_t pclk_inverse :1;
	uint32_t stop_pclk_when_no_data :1;
	uint32_t swap_rgb_to_bgr :1;
	
	
	uint16_t hsync_pos;			// units are pixel clock periods
	uint16_t hsync_len;
	uint16_t h_size;
	uint16_t hfront_blank;
	uint16_t hback_blank;
	
	uint16_t vsync_pos;			// units are lines
	uint16_t vsync_len;
	uint16_t v_size;
	uint16_t vfront_blank;
	uint16_t vback_blank;
	
	hal_lcd_window_config_t *window;	// set to 0 if window mode is not used
} hal_lcd_config_t;


#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus

	void HAL_LCD_Enable(void);
	void HAL_LCD_Disable(void);

	void HAL_LCD_Setup_GPIO(void);
	void HAL_LCD_Setup(hal_lcd_config_t *cfg);
	void HAL_LCD_PWM_SetDuty(uint8_t value);
	void HAL_LCD_StartDMA(uint32_t channel, __builtin_quad *tcb, void *vbuf, uint32_t x_size, uint32_t y_size, uint8_t rgb_mode, isr_handler_t dma_isr_handler);

#ifdef __cplusplus
}
#endif // __cplusplus



#endif	//__HAL_LCD__


