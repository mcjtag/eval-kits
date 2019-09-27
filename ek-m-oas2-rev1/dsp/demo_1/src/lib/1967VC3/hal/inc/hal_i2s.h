/*****************************************************************************
 * audio_I2S_test_1.c
 *****************************************************************************/
#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"

void HAL_I2S_Init(void);
void HAL_I2S_Init_RX(void);
void HAL_I2S_Init_TX(void);

void HAL_I2S_Setup_RX(uint32_t *buf, uint32_t bsize, __builtin_quad *tcb);
void HAL_I2S_Setup_TX(uint32_t *buf, uint32_t bsize, __builtin_quad *tcb);
