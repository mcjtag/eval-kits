/**
 * @file hmc1033_spi.c
 * @brief HMC1033 SPI Controller
 * @author matyunin.d
 * @date 29.07.2019
 * @copyright MIT License
 */

#include "hmc1033_spi.h"
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
 * @brief HMC1033 SPI initialization
 * @param spi Pointer to HMC1033 SPI structure
 * @return void
 */
void hmc1033_spi_init(struct hmc1033_spi *spi)
{
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, REG_SPI_CR_RST_MSK);
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, 0);
}

/**
 * @brief HMC1033 SPI CS enable
 * @param spi Pointer to HMC1033 SPI structure
 * @return void
 */
void hmc1033_spi_cs_enable(struct hmc1033_spi *spi)
{
	u32 tmp;

	tmp = read_reg(spi->baseaddr, REG_SPI_CR_OFFSET);
	tmp |= (((spi->dev_num << REG_SPI_CR_DEV_POS) & REG_SPI_CR_DEV_MSK) | REG_SPI_CR_EN_MSK);
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, tmp);
}

/**
 * @brief HMC1033 SPI CS disable
 * @param spi Pointer to HMC1033 SPI structure
 * @return void
 */
void hmc1033_spi_cs_disable(struct hmc1033_spi *spi)
{
	u32 tmp;

	tmp = read_reg(spi->baseaddr, REG_SPI_CR_OFFSET);
	tmp &= ~(((spi->dev_num << REG_SPI_CR_DEV_POS) & REG_SPI_CR_DEV_MSK) | REG_SPI_CR_EN_MSK);
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, tmp);
}

/**
 * @brief HMC1033 SPI read/write operation
 * @param spi Pointer to HMC1033 SPI structure
 * @param data Data to write
 * @return read data
 */
u32 hmc1033_spi_read_write(struct hmc1033_spi *spi, u32 data)
{
	u32 status;

	write_reg(spi->baseaddr, REG_SPI_DR_OFFSET, data);
	for (;;) {
		status = read_reg(spi->baseaddr, REG_SPI_SR_OFFSET);
		if ((status & REG_SPI_SR_FTE_MSK) && !(status & REG_SPI_SR_TXA_MSK))
			break;
	}
	return read_reg(spi->baseaddr, REG_SPI_DR_OFFSET);
}
