/**
 * @file nb3n502.h
 * @brief NB3N502 Controller
 * @author matyunin.d
 * @date 03.04.2019
 * @copyright MIT License
 */

#ifndef NB3N502_H_
#define NB3N502_H_

#include "xil_types.h"
#include "xstatus.h"

typedef struct {
	u32 baseaddr;
} nb3n502_dev_t;

enum NB3N502_MULT {
	NB3N502_MULT_2X,
	NB3N502_MULT_5X,
	NB3N502_MULT_3X,
	NB3N502_MULT_3_33X,
	NB3N502_MULT_4X,
	NB3N502_MULT_2_5X
};

XStatus nb3n502_init(nb3n502_dev_t *dev, u32 baseaddr);
XStatus nb3n502_multiplier(nb3n502_dev_t *dev, int mul);
XStatus nb3n502_selftest(void *baseaddr_p);

#endif /* NB3N502_H_ */
