/**
 * @file ada.h
 * @brief
 * @author matyunin.d
 * @date 03.07.2017
 */

#ifndef ADA_H_
#define ADA_H_

#include "def1967VC3.h"

#define REG_WRITE32(ADDR, VAL)	*(uint32_t *)(ADDR) = VAL
#define REG_READ32(ADDR)		*(uint32_t *)(ADDR)

#define REG_WRITE64(ADDR, VAL)	*(uint64_t *)(ADDR) = VAL
#define REG_READ64(ADDR)		*(uint64_t *)(ADDR)

#define ADA0RCNT_LOC			(base_ADA0 + 8)
#define ADA1RCNT_LOC			(base_ADA1 + 8)
#define ADA2RCNT_LOC			(base_ADA2 + 8)
#define ADA3RCNT_LOC			(base_ADA3 + 8)

#define ADA0XCR_LOC				(base_ADA0 + 9)
#define ADA1XCR_LOC				(base_ADA1 + 9)
#define ADA2XCR_LOC				(base_ADA2 + 9)
#define ADA3XCR_LOC				(base_ADA3 + 9)

#define ADAXCR_SYNC_SEL_P		0
#define ADAXCR_EN_COG_SYNC_P	1
#define ADAXCR_EN_SYNC_RES_P	2
#define ADAXCR_EN_COG_PACK_P	3
#define ADAXCR_EN_INT_ACK_P		4
#define ADAXCR_EN_INT_BCMP_P	5
#define ADAXCR_EN_INT_RFIN_P	6
#define ADAXCR_SC_CLR_ACK_P		8
#define ADAXCR_ADD_CLR_ACK_P	9
#define ADAXCR_SUB_CLR_ACK_P	10
#define ADAXCR_SC_CLR_BCMP_P	12
#define ADAXCR_ADD_CLR_BCMP_P	13
#define ADAXCR_SUB_CLR_BCMP_P	14
#define ADAXCR_EN_LOAD_BCMP_P	15

#define ADAXCR_L1				(1 << ADAXCR_SYNC_SEL_P)
#define ADAXCR_SYNC				(1 << ADAXCR_EN_COG_SYNC_P)
#define ADAXCR_RESET			(1 << ADAXCR_EN_SYNC_RES_P)
#define ADAXCR_DMA				(1 << ADAXCR_EN_COG_PACK_P)
#define ADAXCR_INT_ACK			(1 << ADAXCR_EN_INT_ACK_P)
#define ADAXCR_INT_BCMP			(1 << ADAXCR_EN_INT_BCMP_P)
#define ADAXCR_INT_RCNT			(1 << ADAXCR_EN_INT_RFIN_P)
#define ADAXCR_CLRA_SC			(1 << ADAXCR_SC_CLR_ACK_P)
#define ADAXCR_CLRA_ADD			(1 << ADAXCR_ADD_CLR_ACK_P)
#define ADAXCR_CLRA_SUB			(1 << ADAXCR_SUB_CLR_ACK_P)
#define ADAXCR_CLRB_SC			(1 << ADAXCR_SC_CLR_BCMP_P)
#define ADAXCR_CLRB_ADD			(1 << ADAXCR_ADD_CLR_BCMP_P)
#define ADAXCR_CLRB_SUB			(1 << ADAXCR_SUB_CLR_BCMP_P)
#define ADAXCR_LOAD_BCMP		(1 << ADAXCR_EN_LOAD_BCMP_P)

#endif /* ADA_H_ */
