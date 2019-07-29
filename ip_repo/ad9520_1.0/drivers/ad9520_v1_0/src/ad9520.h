/**
 * @file ad9520.h
 * @brief AD9520 Controller
 * @author matyunin.d
 * @date 26.03.2019
 * @copyright MIT License
 */

#ifndef AD9520_H
#define AD9520_H

#include "ad9520_map.h"
#include "xil_types.h"
#include "xstatus.h"

typedef struct{
	u32 baseaddr;
} ad9520_dev_t;

struct ad9520_config {
	int addr;
	u8 value;
};

enum AD9520_DEV {
	AD9520_DEV_0 = 1,
	AD9520_DEV_1 = 2,
	AD9520_DEV_2 = 4,
	AD9520_DEV_3 = 8,
	AD9520_DEV_4 = 16,
	AD9520_DEV_5 = 32,
	AD9520_DEV_6 = 64,
	AD9520_DEV_7 = 128,
	AD9520_DEV_ALL = 255
};

enum AD9520_STATE {
	AD9520_ENABLE,
	AD9520_DISABLE
};

XStatus ad9520_init(ad9520_dev_t *dev, u32 baseaddr);
XStatus ad9520_checkid(ad9520_dev_t *dev, int dev_num);
XStatus ad9520_ioc_reset(ad9520_dev_t *dev, int dev_mask, int state);
XStatus ad9520_ioc_powerdown(ad9520_dev_t *dev, int dev_mask, int state);
XStatus ad9520_ioc_eeprom(ad9520_dev_t *dev, int dev_mask, int state);
XStatus ad9520_ioc_sync(ad9520_dev_t *dev, int dev_mask, int state);
XStatus ad9520_ext_sync(ad9520_dev_t *dev, int state);
XStatus ad9520_ios_refmon(ad9520_dev_t *dev, int *value);
XStatus ad9520_ios_ld(ad9520_dev_t *dev, int *value);
XStatus ad9520_ios_status(ad9520_dev_t *dev, int *value);
XStatus ad9520_write_config(ad9520_dev_t *dev, int dev_num, const struct ad9520_config *cfg);
XStatus ad9520_selftest(void *baseaddr_p);

#endif // AD9520_H
