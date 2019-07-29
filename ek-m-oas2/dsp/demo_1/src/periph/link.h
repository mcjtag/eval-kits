/**
 * @file link.h
 * @brief
 * @author matyunin.d
 * @date 28.07.2017
 */

#ifndef LINK_H_
#define LINK_H_

#include <stdint.h>

#define LINK_PATTERN0		0x0F0F0F0F
#define LINK_PATTERN1		0xF0F0F0F0
#define LINK_PATTERN2		0xA5A5A5A5
#define LINK_PATTERN3		0x5A5A5A5A

typedef void (*link_callback)(void *callback_ref);

void link_init(void);
void link_send(uint32_t *buf, uint16_t len);
void link_send_callback(uint32_t *buf, uint16_t len, link_callback cb, void *cb_ref);
void link_send_pattern(uint32_t length, uint32_t pattern);

#endif /* LINK_H_ */
