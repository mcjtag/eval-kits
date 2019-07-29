/**
 * @file syncron.h
 * @brief Syncronizer
 * @author matyunin.d
 * @date 23.01.2018
 * @copyright MIT License
 */

#ifndef SYNCRON_H
#define SYNCRON_H

#include "xil_types.h"
#include "xstatus.h"

typedef struct {
	u32 baseaddr;
} syncron_dev_t;

enum SYNCRON_SOURCE {
	SYNCRON_SOURCE_INTERNAL,
	SYNCRON_SOURCE_EXTERNAL
};

enum SYNCRON_SYNC {
	SYNCRON_SYNC_CLOCK,
	SYNCRON_SYNC_CAPTURE,
	SYNCRON_SYNC_LINK,
	SYNCRON_SYNC_CAPTURE_RAW
};

XStatus syncron_init(syncron_dev_t *dev, u32 baseaddr);
void syncron_set_source(syncron_dev_t *dev, int source);
void syncron_sync(syncron_dev_t *dev, int sync);
XStatus syncron_selftest(void *baseaddr_p);

#endif // SYNCRON_H
