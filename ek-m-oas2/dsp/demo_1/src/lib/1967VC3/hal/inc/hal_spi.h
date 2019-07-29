/*****************************************************************************
 * hal_spi_h
 *****************************************************************************/
#ifndef __HAL_SPI_H_
#define __HAL_SPI_H_ 
 
#include "def1967VC3.h"
#include "stdint.h"
#include "hal_typedef.h"


#define HAL_SPI_LSB_FIRST	1
#define HAL_SPI_MSB_FIRST	0

// SPH : SPO
#define HAL_SPI_CLK_MODE0	((0<<1) | (0<<0))
#define HAL_SPI_CLK_MODE1	((1<<1) | (0<<0))
#define HAL_SPI_CLK_MODE2	((0<<1) | (1<<0))
#define HAL_SPI_CLK_MODE3	((1<<1) | (1<<0))



typedef struct {
	uint8_t cs_num;
	uint8_t word_length;
	uint8_t clk_mode;
	uint8_t bit_order;
	uint8_t cs_active_level;
	uint32_t bit_freq_khz;
	uint32_t core_freq_khz;
} HAL_SPI_InitStruct_t;


typedef struct {
	uint32_t spcr0;
	uint32_t spcr1;
} HAL_SPI_Context_t;

#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus

	int32_t HAL_SPI_InitContext(HAL_SPI_InitStruct_t *cfg, HAL_SPI_Context_t *ctx);
	void HAL_SPI_InitGPIO(HAL_SPI_InitStruct_t *cfg);
	void HAL_SPI_EnableContext(HAL_SPI_Context_t *ctx);
	uint32_t HAL_SPI_send_receive_data(uint32_t data_tx);
	void HAL_SPI_send_data(uint32_t *data_tx, uint32_t count);
	void HAL_SPI_receive_data(uint32_t *data_rx, uint32_t count);
	void HAL_SPI_clear_rx_fifo(void);
	uint32_t HAL_SPI_tx_done();
	void HAL_SPI_enable_cs_hold(void);
	void HAL_SPI_release_cs(void);


#ifdef __cplusplus
}
#endif // __cplusplus


#endif //__HAL_SPI_H_
