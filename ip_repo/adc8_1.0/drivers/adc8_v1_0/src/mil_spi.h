/**
 * @file mil_spi.h
 * @brief Milandr SPI Controller
 * @author matyunin.d
 * @date 06.08.2019
 * @copyright MIT License
 */

#ifndef MIL_SPI_H_
#define MIL_SPI_H_

#include <stdint.h>
#include "xil_types.h"

struct mil_spi {
	u32 baseaddr;
	u8 dev_num;
};

void mil_spi_init(struct mil_spi *spi);
void mil_spi_cs_enable(struct mil_spi *spi);
void mil_spi_cs_disable(struct mil_spi *spi);
u16 mil_spi_read_write(struct mil_spi *spi, u16 data);

#endif /* MIL_SPI_H_ */
