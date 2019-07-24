#ifndef __MDR1636X_BUS_H_
#define __MDR1636X_BUS_H_

#include "stdint.h"
#include "flash_dev.h"

#ifdef __cplusplus
extern "C"
{
#endif // __cplusplus

uint32_t MDR1636_init(flash_drv_config_t *drv_config, void *hw_config);
uint32_t MDR1636_reset(void);
uint32_t MDR1636_get_status(uint32_t *status);
uint32_t MDR1636_wait_device(void);
uint32_t MDR1636_read_info(uint32_t param, uint32_t *data);

uint32_t MDR1636_get_chip_protection(uint32_t *value);
uint32_t MDR1636_get_sector_protection(uint32_t sa, uint32_t *value);
uint32_t MDR1636_set_chip_protection(uint32_t new_value);
uint32_t MDR1636_set_sector_protection(uint32_t sa, uint32_t new_value);

uint32_t MDR1636_start_erase_chip(void);
uint32_t MDR1636_start_erase_sector(uint32_t sa);
uint32_t MDR1636_erase_chip(void);
uint32_t MDR1636_erase_sector(uint32_t sa);

uint32_t MDR1636_write_data(uint32_t address, uint32_t *data, uint32_t count);
uint32_t MDR1636_read_data(uint32_t address, uint32_t *data, uint32_t count);

#ifdef __cplusplus
}
#endif // __cplusplus


#endif //__MDR1636X_BUS_H_	
