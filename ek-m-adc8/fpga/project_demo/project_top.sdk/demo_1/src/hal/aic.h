/**
 * @file aic.h
 * @brief Axis Switch HAL
 * @author matyunin.d
 * @date 14.08.2019
 */

#ifndef AIC_H_
#define AIC_H_

#include "xaxis_switch.h"

struct aic_dev {
	XAxis_Switch aic;
	u16 dev_id;
};

int aic_init(struct aic_dev *dev);
void aic_disable_all(struct aic_dev *dev);
int aic_disable(struct aic_dev *dev, u8 mi);
int aic_enable(struct aic_dev *dev, u8 si, u8 mi);

#endif /* AIC_H_ */
