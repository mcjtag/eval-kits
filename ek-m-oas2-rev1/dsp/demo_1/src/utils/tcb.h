/**
 * @file tcb.h
 * @brief
 * @author matyunin.d
 * @date 28.07.2017
 */

#ifndef TCB_H_
#define TCB_H_

#define TCB_DI(tcb, val)				*((uint32_t *)&tcb + 0) = (uint32_t)val
#define TCB_DX(tcb, mod, count)			*((uint32_t *)&tcb + 1) = (count << 16) | mod
#define TCB_DY(tcb, val)				*((uint32_t *)&tcb + 2) = val
#define TCB_DP(tcb, flag, dest, c_tcb)	*((uint32_t *)&tcb + 3) = flag | dest | (c_tcb >> 2)

#define TCB_WRITE(tcb, ind, val)		*((uint32_t *)&tcb + ind) = val
#define TCB_READ(tcb, ind)				*((uint32_t *)&tcb + ind)

#define DCS		0
#define DCD		1

#endif /* TCB_H_ */
