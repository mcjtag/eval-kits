/**
 * @file timer.h
 * @brief Timer HAL
 * @author matyunin.d
 * @date 17.06.2019
 */

#ifndef TIMER_H_
#define TIMER_H_

#include "xtmrctr.h"
#include "intc.h"

struct timer_dev{
	XTmrCtr timer;
	u16 dev_id;
	u8 vec_id;
	volatile int expired;
	struct intc_dev *intc;
};

int timer_init(struct timer_dev *dev);
int timer_delay(struct timer_dev *dev, u32 delay_ms);
void timer_pwm(struct timer_dev *dev, u32 period, u32 high);

#endif /* TIMER_H_ */
