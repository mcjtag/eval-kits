/**
 * @file hmc1033_spi.h
 * @brief HMC1033 SPI Controller
 * @author matyunin.d
 * @date 29.07.2019
 * @copyright MIT License
 */

#ifndef HMC1033_SPI_H_
#define HMC1033_SPI_H_

#include <stdint.h>
#include "xil_types.h"

struct hmc1033_spi {
	u32 baseaddr;
	u8 dev_num;
};

void hmc1033_spi_init(struct hmc1033_spi *spi);
void hmc1033_spi_cs_enable(struct hmc1033_spi *spi);
void hmc1033_spi_cs_disable(struct hmc1033_spi *spi);
u32 hmc1033_spi_read_write(struct hmc1033_spi *spi, u32 data);

#endif /* HMC1033_SPI_H_ */
