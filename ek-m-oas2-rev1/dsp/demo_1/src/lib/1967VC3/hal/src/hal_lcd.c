

#include "cpu.h"
#include "hal_lcd.h"
#include "hal_dma.h"


#define wa_delay()	__ASM(nop;; nop;; nop;; nop;)

void HAL_LCD_Enable(void)
{
	LX_LCD->CTRL.field.en = 1;
}


void HAL_LCD_Disable(void)
{
	LX_LCD->CTRL.field.en = 0;
}


void HAL_LCD_Setup_GPIO(void)
{
	// Enable GPIO
	LX_PortB->alt.set = 0x7FFFFFF0;
}


void HAL_LCD_Setup(hal_lcd_config_t *cfg)
{
	uint32_t temp32u;
	
	// Disable controller
	LX_LCD->CTRL.reg = 0;
	LX_LCD->PWM_CR.reg = 0;
	
	// Video buffer size in 32-bit words
	LX_LCD->VSIZE.field.size = cfg->h_size * cfg->v_size / ((cfg->rgb_mode >> 4) & 0x0F);
	
	// Pixel clock freq PX_CLK = SOC_CLK / (P_div + 1)
	temp32u = cfg->core_clock_khz / (2 * cfg->pixel_clock_khz);
	if (temp32u > 0)
		temp32u -= 1;
	LX_LCD->PXDV.field.div = temp32u;
	wa_delay();
	LX_LCD->PXDV.field.en = 1;
	
	// Number of pixels in one line and number of lines
	// Not all pixels in a line are visible and not all lines are visible as well
	LX_LCD->HVLEN.field.ht = ((cfg->hfront_blank + cfg->h_size + cfg->hback_blank) >> 3) - 1;
	wa_delay();
	LX_LCD->HVLEN.field.vt = (cfg->vfront_blank + cfg->v_size + cfg->vback_blank) - 1;
	
	// HSYNC (fpline) pulse timing
	LX_LCD->HTIM.field.ps = cfg->hsync_pos - 1;
	wa_delay();
	LX_LCD->HTIM.field.pl = ~cfg->hsync_active_level;		// Active level: 0 - high, 1 - low
	wa_delay();
	LX_LCD->HTIM.field.pw = cfg->hsync_pos + cfg->hsync_len - 1;
	
	// VSYNC (fpframe) pulse timing
	LX_LCD->VTIM.field.ps = cfg->vsync_pos - 1;
	wa_delay();
	LX_LCD->VTIM.field.pl = ~cfg->vsync_active_level;		// Active level: 0 - high, 1 - low
	wa_delay();
	LX_LCD->VTIM.field.pw = cfg->vsync_pos + cfg->vsync_len - 1;	

	// Data timing H
	LX_LCD->HDTIM.field.ps = cfg->hfront_blank - 1;
	wa_delay();
	LX_LCD->HDTIM.field.pe = cfg->hfront_blank + cfg->h_size - 1;
	
	// Data timing V
	LX_LCD->VDTIM.field.ps = cfg->vfront_blank - 1;
	wa_delay();
	LX_LCD->VDTIM.field.pe = cfg->vfront_blank + cfg->v_size - 1;
	
	if (cfg->window)
	{
		// Extra data timing H (visible area)
		LX_LCD->HDxTIM.field.ps = cfg->hfront_blank + cfg->window->h_offset - 1;
		wa_delay();
		LX_LCD->HDxTIM.field.pe = cfg->hfront_blank + cfg->window->h_offset + cfg->window->h_size - 1;
		
		// Extra data timing V (visible area)
		LX_LCD->VDxTIM.field.ps = cfg->vfront_blank + cfg->window->v_offset - 1;
		wa_delay();
		LX_LCD->VDxTIM.field.pe = cfg->vfront_blank + cfg->window->v_offset + cfg->window->v_size - 1;
		
		// Background (for window mode)
		LX_LCD->BACKGND.reg = cfg->window->backgnd_color;
	}
	
	// Panel type / clock inverse
	LX_LCD->PANEL_CFG.field.fpshi = cfg->pclk_inverse;
	
	// Backlight PWM
	LX_LCD->PWM_CR.field.reload = HAL_LCD_MAX_PWM_DUTY;
	wa_delay();
	LX_LCD->PWM_CR.field.duty = 0;
	wa_delay();
	LX_LCD->PWM_CR.field.dv = cfg->pwm_div; //div_value;
	wa_delay();
	LX_LCD->PWM_CR.field.en = 1;
	
	
	// Control							// BGR or RGB output data mode
	LX_LCD->CTRL.field.vbgr = cfg->swap_rgb_to_bgr;
	wa_delay();							// 0 - 8bit, 1 - 16bit, 2 - 24bit, 3 - 32bit per pixel
	LX_LCD->CTRL.field.cd = (cfg->rgb_mode >> 2) & 0x3;
	wa_delay();							// Bits encoding per pixel (see documentation)
	LX_LCD->CTRL.field.vbl = (cfg->rgb_mode >> 0) & 0x3;
	wa_delay();							// Active level of DRDY signal (0 - DRDY active high, 1 - DRDY active low)
	LX_LCD->CTRL.field.bl = ~cfg->dready_active_level;	
	wa_delay();							// If 1, HDxTIM and VDxTIM registers are used
	LX_LCD->CTRL.field.W2W_en = (cfg->window != 0);		
	wa_delay();							// If 1, stop pixel clock if no data in FIFO is present
	LX_LCD->CTRL.field.PXP_en = cfg->stop_pclk_when_no_data;		
	
}


void HAL_LCD_PWM_SetDuty(uint8_t value)
{
	// Avoid small glitches at duty == reload
	if (value >= HAL_LCD_MAX_PWM_DUTY)
		value = HAL_LCD_MAX_PWM_DUTY + 1;
	LX_LCD->PWM_CR.field.duty = value;
}



void HAL_LCD_StartDMA(uint32_t channel, __builtin_quad *tcb, void *vbuf, uint32_t x_size, uint32_t y_size, uint8_t rgb_mode, isr_handler_t dma_isr_handler)
{
	uint32_t *ptr = (uint32_t*) tcb;
	HAL_DMA_Stop(channel);
	
	switch ((rgb_mode >> 4) & 0x0F)
	{
		case 2:	x_size >>= 1;	break;	// 2 pixels per 32-bit word
		case 4:	x_size >>= 2;	break;	// 4 pixels per 32-bit word
		default:				break;
	}

	*(ptr + 0) = (uint32_t)vbuf;
	*(ptr + 1) = (x_size << 16) | 4;
	*(ptr + 2) = (y_size << 16) | 4;
	*(ptr + 3) = TCB_TWODIM | TCB_QUAD | TCB_CHAIN | ((uint32_t)tcb >> 2) | 
				HAL_DMA_GetTCBChannelDest(channel);
	*(ptr + 3) |= ((uint32_t)vbuf < 0x0C000000) ? TCB_INTMEM : TCB_EXTMEM;		// FIXME - 0x0C000000
	
	HAL_DMA_SetTxRequestSource(channel, TxDmaReq_Lcd);
	// Enable interrupt if required
	if (dma_isr_handler)
	{
		HAL_DMA_ClearInterruptRequest(channel);
		HAL_DMA_SetInterruptVector(channel, (uint32_t)dma_isr_handler);
		HAL_DMA_SetInterruptMask(channel, 1);
		*(ptr + 3) |= TCB_INT;
	}
	// Start DMA
	HAL_DMA_WriteDC(channel, tcb);
}


