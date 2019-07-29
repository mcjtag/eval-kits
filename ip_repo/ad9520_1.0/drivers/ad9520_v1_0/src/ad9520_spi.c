/**
 * @file ad9520_spi.c
 * @brief AD9520 SPI Controller
 * @author matyunin.d
 * @date 28.03.2019
 * @copyright MIT License
 */

#include "ad9520_spi.h"
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

enum RW {
	RW_READ = 1,
	RW_WRITE = 0
};

enum BYTE_TRANSFER_COUNT {
	BTC_ONE = 0,			// 1 Byte to Transfer
	BTC_TWO = 1,			// 2 Bytes to Transfer
	BTC_THREE = 2,			// 3 Bytes to Transfer
	BTC_STREAM = 3			// Streaming Mode
};

union iword {
	struct {
		uint16_t addr:13;
		uint16_t btc:2;
		uint16_t rw:1;
	};
	uint8_t iword[2];
};

static void spi_cs_enable(const struct ad9520_spi *spi);
static void spi_cs_disable(const struct ad9520_spi *spi);
static uint8_t spi_read_write(const struct ad9520_spi *spi, uint8_t data);

/**
 * @brief AD9520 SPI initialization
 * @param spi Pointer to AD9520 SPI
 * @return void
 */
void ad9520_spi_init(const struct ad9520_spi *spi)
{
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, REG_SPI_CR_RST_MSK);
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, 0);
}

/**
 * @brief AD9520 SPI write transfer
 * @param spi Pointer to AD9520 SPI
 * @param regaddr AD9520 register address
 * @param value register value to write
 * @return void
 */
void ad9520_spi_write(const struct ad9520_spi *spi, uint16_t regaddr, uint8_t value)
{
	union iword iw;
	uint8_t wdata[3];

	if (!spi)
		return;

	iw.addr = regaddr;
	iw.btc = BTC_ONE;
	iw.rw = RW_WRITE;

	wdata[0] = iw.iword[1];
	wdata[1] = iw.iword[0];
	wdata[2] = value;

	spi_cs_enable(spi);
	for (int i = 0; i < 3; i++)
		spi_read_write(spi, wdata[i]);
	spi_cs_disable(spi);
}

/**
 * @brief AD9520 SPI read transfer
 * @param spi Pointer to AD9520 SPI
 * @param regaddr AD9520 register address
 * @return read value
 */
uint8_t ad9520_spi_read(const struct ad9520_spi *spi, uint16_t regaddr)
{
	union iword iw;
	uint8_t wdata[3];
	uint8_t rdata[3];

	iw.addr = regaddr;
	iw.btc = BTC_ONE;
	iw.rw = RW_READ;

	wdata[0] = iw.iword[1];
	wdata[1] = iw.iword[0];
	wdata[2] = 0;

	spi_cs_enable(spi);
	for (int i = 0; i < 3; i++)
		rdata[i] = spi_read_write(spi, wdata[i]);
	spi_cs_disable(spi);

	return rdata[2];
}

/**
 * @brief AD9520 SPI CS enable
 * @param spi Pointer to AD9520 SPI
 * @return void
 */
static void spi_cs_enable(const struct ad9520_spi *spi)
{
	u32 tmp;

	tmp = read_reg(spi->baseaddr, REG_SPI_CR_OFFSET);
	tmp |= (((spi->dev_num << REG_SPI_CR_DEV_POS) & REG_SPI_CR_DEV_MSK) | REG_SPI_CR_EN_MSK);
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, tmp);
}

/**
 * @brief AD9520 SPI CS disable
 * @param spi Pointer to AD9520 SPI
 * @return void
 */
static void spi_cs_disable(const struct ad9520_spi *spi)
{
	u32 tmp;

	tmp = read_reg(spi->baseaddr, REG_SPI_CR_OFFSET);
	tmp &= ~(((spi->dev_num << REG_SPI_CR_DEV_POS) & REG_SPI_CR_DEV_MSK) | REG_SPI_CR_EN_MSK);
	write_reg(spi->baseaddr, REG_SPI_CR_OFFSET, tmp);
}

/**
 * @brief AD9520 SPI read/write operation
 * @param spi Pointer to AD9520 SPI
 * @param data Data to write
 * @return read data
 */
static uint8_t spi_read_write(const struct ad9520_spi *spi, uint8_t data)
{
	u32 status;

	write_reg(spi->baseaddr, REG_SPI_DR_OFFSET, data);
	for (;;) {
		status = read_reg(spi->baseaddr, REG_SPI_SR_OFFSET);
		if ((status & REG_SPI_SR_FTE_MSK) && !(status & REG_SPI_SR_TXA_MSK))
			break;
	}
	return (uint8_t)read_reg(spi->baseaddr, REG_SPI_DR_OFFSET);;
}
