/**
 * @file ad9520_spi.h
 * @brief AD9520 SPI Controller
 * @author matyunin.d
 * @date 28.03.2019
 * @copyright MIT License
 */

#ifndef AD9520_SPI_H_
#define AD9520_SPI_H_

#include <stdint.h>
#include "xil_types.h"

struct ad9520_spi {
	u32 baseaddr;
	u8 dev_num;
};

void ad9520_spi_init(const struct ad9520_spi *spi);
void ad9520_spi_write(const struct ad9520_spi *spi, uint16_t regaddr, uint8_t value);
uint8_t ad9520_spi_read(const struct ad9520_spi *spi, uint16_t regaddr);

#endif /* AD9520_SPI_H_ */

















