/**
 * @file dmar.h
 * @brief
 * @author matyunin
 * @date 28.07.2017
 */

#ifndef DMAR_H_
#define DMAR_H_

#include "system/cpu_defs.h"

typedef void (*dmar_callback)(void *callback_ref);

struct dmar_callback {
	dmar_callback cb;
	void *param;
};

struct dmar_chain {
	__builtin_quad *dcs;
	__builtin_quad *dcd;
};

enum DMAR_CHANNEL {
	DMAR_0,
	DMAR_1
};

enum DMAR_OPTION {
	DMAR_OPTION_AUTO = 1
};

void dmar_init(void);
void dmar_start(int chan, struct dmar_callback *cb, struct dmar_chain *chain);
void dmar_restart(int chan);
void dmar_stop(int chan);

#endif /* DMAR_H_ */
