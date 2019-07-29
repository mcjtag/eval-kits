/**
 * @file assert.h
 * @brief
 * @author matyunin.d
 * @date 25.07.2017
 */

#ifndef ASSERT_H_
#define ASSERT_H_

#include "config.h"

#if CONFIG_ASSERT_USE == 1
#define ASSERT(x)	{ if((x) == 0) while(1); }
#else
#define ASSERT(x)
#endif


#endif /* ASSERT_H_ */
