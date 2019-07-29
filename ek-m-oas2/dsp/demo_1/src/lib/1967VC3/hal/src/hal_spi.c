/*****************************************************************************
 * 
 *****************************************************************************/

#include "cpu.h"
#include "hal_spi.h"


//---------------------------------------------//
// Initialises SPI context 
//
// SPI module hardware is NOT affected!
//---------------------------------------------//
int32_t HAL_SPI_InitContext(HAL_SPI_InitStruct_t *cfg, HAL_SPI_Context_t *ctx)
{
	uint32_t temp32u;
	int32_t result = 0;

	while(1)
	{
		// SPCR0
		ctx->spcr0 = 0;
		if ((cfg->word_length < 4) || (cfg->word_length > 16))
		{
			result = -1;	break;	
		}
		ctx->spcr0 |= (cfg->word_length - 1);
		ctx->spcr0 |= ( (cfg->clk_mode & 0x3) << 6 );
		ctx->spcr0 |= ( (cfg->bit_order & 0x1) << 10 );
		ctx->spcr0 |= ( (cfg->cs_num & 0x7) << 12);
		temp32u = (cfg->core_freq_khz / 2) / cfg->bit_freq_khz - 1;
		if (temp32u > 0x3FF)
		{
			result = -2;	
			temp32u = 0x3FF;
		}
		ctx->spcr0 |= temp32u << 16;
		
		// SPCR1
		ctx->spcr1 = 0;
		ctx->spcr1 |= (cfg->cs_active_level & 0x01) << (16 + (cfg->cs_num & 0x7));
		ctx->spcr1 |= (1<<SPCR1_SPE_P);
		break;
	}
	return result;
}


//---------------------------------------------//
// Sets context and enables SPI
//
// SPI module is further operating with 
// configuration from context.
//---------------------------------------------//
void HAL_SPI_EnableContext(HAL_SPI_Context_t *ctx)
{
	// Disable SPI
	LX_SPI->spcr1.reg = 0;
	// Setup SPI control regs
	LX_SPI->spcr0.reg = ctx->spcr0;
	LX_SPI->spcr1.reg = ctx->spcr1;
}



//---------------------------------------------//
// Setups alternate GPIO functions for SPI
// TODO: move function to a HAL_GPIO module
//
//---------------------------------------------//
void HAL_SPI_InitGPIO(HAL_SPI_InitStruct_t *cfg)
{
	LX_PortA->alt.set = (1<<4) | (1<<5) | (1<<6) | (1 << (7 + (cfg->cs_num & 0x7)));
}



//---------------------------------------------//
// Shift out and in data
// #CS is driven active when the transfer begins and 
// released upon completition.
// Use SPI_enable_cs_hold() to drive #CS active continuously
//---------------------------------------------//
uint32_t HAL_SPI_send_receive_data(uint32_t data_tx)
{
	uint32_t data_rx;
	while ( (*(uint32_t*)SPSR_LOC & (1<<SPSR_TNF_P)) == 0 );
	*(uint32_t*)SPDR_LOC = (uint32_t)data_tx;
	while( (*(uint32_t*)SPSR_LOC & (1<<SPSR_RNE_P)) == 0 );
	while( (*(uint32_t*)SPSR_LOC & (1<<SPSR_BSY_P)) );
	data_rx = *(uint32_t*)SPDR_LOC;
	return data_rx;
}


//---------------------------------------------//
// Function sends count words holding TX FIFO full
// Function blocks until all data is put to FIFO
//---------------------------------------------//
void HAL_SPI_send_data(uint32_t *data_tx, uint32_t count)
{
    uint32_t data_rx;
    while(count)
    {
        while ( (*(uint32_t*)SPSR_LOC & (1<<SPSR_TNF_P)) == 0 );
        *(uint32_t*)SPDR_LOC = *data_tx++;
        count--;
    }
}

//---------------------------------------------//
// Read received data from SPI RX FIFO
// Function block until count words are read from RX FIFO and put into buffer
//---------------------------------------------//
void HAL_SPI_receive_data(uint32_t *data_rx, uint32_t count)
{
    while(count)
    {
        while( (*(uint32_t*)SPSR_LOC & (1<<SPSR_RNE_P)) == 0 );
        *data_rx++ = *(uint32_t*)SPDR_LOC;
        count--;
    }
}

//---------------------------------------------//
// Clear SPI RX FIFO
//
//---------------------------------------------//
void HAL_SPI_clear_rx_fifo(void)
{
    uint32_t temp32u;
    while( (*(uint32_t*)SPSR_LOC & (1<<SPSR_RNE_P)) )
    {
        while( (*(uint32_t*)SPSR_LOC & (1<<SPSR_RNE_P)) == 0 );
        temp32u = *(uint32_t*)SPDR_LOC;
    }
}



//---------------------------------------------//
// Check SPI TX status
// ddone = TX fifo empty and SPI not busy
//---------------------------------------------//
uint32_t HAL_SPI_tx_done()
{
    uint32_t done;
    done = ( ((*(uint32_t*)SPSR_LOC & (1<<SPSR_TFE_P)) != 0) && ((*(uint32_t*)SPSR_LOC & (1<<SPSR_BSY_P)) == 0) );
    return done;
}




//---------------------------------------------//
// Enable #CS hold after next data transfer
//---------------------------------------------//
void HAL_SPI_enable_cs_hold(void)
{
	//uint32_t temp32u = *(uint32_t *)SPCR1_LOC;
	//temp32u |= (1<<SPCR1_HOLDCS_P);
	//*(uint32_t *)SPCR1_LOC = temp32u;
	
	LX_SPI->spcr1.field.hold_cs = 1;
}


//---------------------------------------------//
// Release #CS
//---------------------------------------------//
void HAL_SPI_release_cs(void)
{
	//uint32_t temp32u = *(uint32_t *)SPCR1_LOC;
	//temp32u &= ~(1<<SPCR1_HOLDCS_P);
	//*(uint32_t *)SPCR1_LOC = temp32u;
	
	LX_SPI->spcr1.field.hold_cs = 0;
}


//=================================================================//
