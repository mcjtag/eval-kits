/**
 * @file iic.h
 * @brief
 * @author matyunin.d
 * @date 14.06.2019
 */

#ifndef IIC_H_
#define IIC_H_

#include "xiic.h"
#include "intc.h"

struct iic_dev{
	XIic iic;
	u16 dev_id;
	u8 vec_id;
	volatile int tx_done;
	volatile int rx_done;
	struct intc_dev *intc;
};

int iic_init(struct iic_dev *dev);
int iic_write(struct iic_dev *dev, u8 addr, u8 *data, int len);
int iic_read(struct iic_dev *dev, u8 addr, u8 *data, int len);

#endif /* IIC_H_ */
