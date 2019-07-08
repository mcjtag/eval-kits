/**
 * @file link.h
 * @brief LINK port controller
 * @author matyunin.d
 * @date 02.07.2019
 */
 
#ifndef LINK_H
#define LINK_H

#include <stdint.h>
#include <defts201.h>
#include <sysreg.h>

int link_init(int link, unsigned int tx_cfg, unsigned int rx_cfg);
int link_send(int link, unsigned int *buf, unsigned int len);
int link_recv(int link, unsigned int *buf, unsigned int len);

#endif
