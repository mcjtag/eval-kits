/**
 * @file spi.h
 * @brief SPI HAL
 * @author matyunin.d
 * @date 14.06.2019
 */

#ifndef SPI_H_
#define SPI_H_

#include "xspi.h"
#include "intc.h"

struct spi_dev {
	XSpi spi;
	u16 dev_id;
	u8 vec_id;
	struct intc_dev *intc;
	volatile int active;
	volatile int errors;
};

struct spi_opts {
	int cpha;
	int cpol;
};

int spi_init(struct spi_dev *dev);
int spi_set_opts(struct spi_dev *dev, struct spi_opts *opts);
int spi_set_cs(struct spi_dev *dev, u32 dev_msk);
int spi_transfer(struct spi_dev *dev, u8 *wr_buf, u8 *rd_buf, u32 count);

#endif /* SPI_H_ */
