/**
 * @file mil_spi.c
 * @brief Milandr SPI Controller
 * @author matyunin.d
 * @date 06.08.2019
 * @copyright MIT License
 */

#include "mil_spi.h"
#include "xil_io.h"

/* Register Address */
#define REG_SPI_CR_OFFSET 		((u32)0x40)
#define REG_SPI_SR_OFFSET 		((u32)0x44)
#define REG_SPI_DR_OFFSET		((u32)0x48)

/* Register Map */
#define REG_SPI_CR_RST_MSK		((u32)0x00000001)
#define REG_SPI_CR_EN_MSK		((u32)0x00000002)
#define REG_SPI_CR_DEV_MSK		((u32)0x00000700)
#define REG_SPI_CR_RST_POS		((u32)0)
#define REG_SPI_CR_EN_POS		((u32)1)
#define REG_SPI_CR_DEV_POS		((u32)8)
#define REG_SPI_SR_TXA_MSK		((u32)0x01)
#define REG_SPI_SR_FRE_MSK		((u32)0x10)
#define REG_SPI_SR_FRF_MSK		((u32)0x20)
#define REG_SPI_SR_FTE_MSK		((u32)0x40)
#define REG_SPI_SR_FTF_MSK		((u32)0x80)

/* Register Operations */
#define write_reg(base_addr, offset, data) 	Xil_Out32((base_addr) + (offset), (u32)(data))
#define read_reg(base_addr, offset)			Xil_In32((base_addr) + (offset))

/**
 * @brief Milandr SPI initialization
 * @param spi Pointer to Milandr SPI structure
 * @return void
 */
void mil_spi_init(struct mil_spi *spi)
{
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, REG_SPI_CR_RST_MSK);
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, 0);
}

/**
 * @brief Milandr SPI CS enable
 * @param spi Pointer to Milandr SPI structure
 * @return void
 */
void mil_spi_cs_enable(struct mil_spi *spi)
{
	u32 tmp;

	tmp = read_reg(spi->baseaddr, REG_SPI_CR_OFFSET);
	tmp |= (((spi->dev_num << REG_SPI_CR_DEV_POS) & REG_SPI_CR_DEV_MSK) | REG_SPI_CR_EN_MSK);
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, tmp);
}

/**
 * @brief Milandr SPI CS disable
 * @param spi Pointer to Milandr SPI structure
 * @return void
 */
void mil_spi_cs_disable(struct mil_spi *spi)
{
	u32 tmp;

	tmp = read_reg(spi->baseaddr, REG_SPI_CR_OFFSET);
	tmp &= ~(((spi->dev_num << REG_SPI_CR_DEV_POS) & REG_SPI_CR_DEV_MSK) | REG_SPI_CR_EN_MSK);
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, tmp);
}

/**
 * @brief Milandr SPI read/write operation
 * @param spi Pointer to Milandr SPI structure
 * @param data Data to write
 * @return read data
 */
u16 mil_spi_read_write(struct mil_spi *spi, u16 data)
{
	u32 status;

	write_reg(spi->baseaddr, REG_SPI_DR_OFFSET, data);
	for (;;) {
		status = read_reg(spi->baseaddr, REG_SPI_SR_OFFSET);
		if ((status & REG_SPI_SR_FTE_MSK) && !(status & REG_SPI_SR_TXA_MSK))
			break;
	}
	return (u16)read_reg(spi->baseaddr, REG_SPI_DR_OFFSET);
}
