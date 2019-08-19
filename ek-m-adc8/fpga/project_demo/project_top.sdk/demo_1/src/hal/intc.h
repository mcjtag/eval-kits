/**
 * @file intc.h
 * @brief INTC HAL
 * @author matyunin.d
 * @date 14.06.2019
 */

#ifndef INTC_H_
#define INTC_H_

#include "xintc.h"

struct intc_dev {
	XIntc intc;
	u16 dev_id;
};

int intc_init(struct intc_dev *dev);
int intc_start(struct intc_dev *dev);

#endif /* INTC_H_ */
