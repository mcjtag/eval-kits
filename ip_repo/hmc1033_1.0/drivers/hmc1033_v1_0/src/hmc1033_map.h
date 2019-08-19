/**
 * @file hmc1033_map.h
 * @brief HMC1033 Register Map
 * @author matyunin.d
 * @date 29.07.2019
 * @copyright MIT License
 */

#ifndef HMC1033_MAP_H
#define HMC1033_MAP_H

#include <stdint.h>

/* PLL register map
 *	enum PLL_REG {
 * 		PLL_REG_ID = 0x00,
 *		PLL_REG_REFDIV = 0x02,
 *		PLL_REG_FREQ_INT = 0x03,
 *		PLL_REG_FREQ_FRAC = 0x04,
 *		PLL_REG_VCO_SPI = 0x05,
 *		PLL_REG_SD_CFG = 0x06,
 *		PLL_REG_LD = 0x07,
 *		PLL_REG_ANA_EN = 0x08,
 *		PLL_REG_CP = 0x09,
 *		PLL_REG_VCO_AUTOCAL = 0x0A,
 *		PLL_REG_PD = 0x0B,
 *		PLL_REG_EFREQ_MODE = 0x0C,
 *		PLL_REG_GPO = 0x0F,
 *		PLL_REG_VCO_TUNE = 0x10,
 *		PLL_REG_SAR = 0x11,
 *		PLL_REG_GPO2 = 0x12,
 *		PLL_REG_BIST = 0x13
 *	};
 */

/* VCO subsystem register map
 *	enum VCO_REG {
 *		VCO_REG_TUNING = 0x00,
 *		VCO_REG_ENABLE = 0x01,
 *		VCO_REG_BIAS = 0x02,
 *		VCO_REG_CONFIG = 0x03,
 *		VCO_REG_CAL_BIAS = 0x04,
 *		VCO_REG_CF_CAL = 0x05,
 *		VCO_REG_MSB_CAL = 0x07
 *	};
 */

struct pll_reg_map {
	struct {
		uint32_t chip_id:24;
		uint32_t :8;
	} id; /* 00h */
	struct {
		uint32_t :1;
		uint32_t rst:1;
		uint32_t :30;
	} rst; /* 01h */
	struct {
		uint32_t rdiv:14;
		uint32_t :18;
	} refdiv; /* 02h */
	struct {
		uint32_t intg:19;
		uint32_t :13;
	} freq_int; /* 03 */
	struct {
		uint32_t frac:24;
		uint32_t :8;
	} freq_frac; /* 04h */
	struct {
		uint32_t id:3;
		uint32_t addr:4;
		uint32_t data:9;
		uint32_t :16;
	} vco_spi; /* 05h */
	struct {
		uint32_t seed:2;
		uint32_t :5;
		uint32_t frac_bypass:1;
		uint32_t :3;
		uint32_t sd_enable:1;
		uint32_t :20;
	} sd_cfg; /* 06h */
	struct {
		uint32_t lkd_wincnt_max:3;
		uint32_t en_int_ld:1;
		uint32_t :2;
		uint32_t ld_win_type:1;
		uint32_t ld_dig_win_dur:3;
		uint32_t :22;
	} ld; /* 07h */
	struct {
		uint32_t :5;
		uint32_t gpo_pad_en:1;
		uint32_t :3;
		uint32_t pre_clock_en:1;
		uint32_t vco_bpb_en:1;
		uint32_t :6;
		uint32_t high_freq_ref:1;
		uint32_t :14;
	} ana_en; /* 08h */
	struct {
		uint32_t cp_dn_gain:7;
		uint32_t cp_up_gain:7;
		uint32_t offset_mag:7;
		uint32_t offset_up_en:1;
		uint32_t offset_dn_en:1;
		uint32_t :9;
	} cp; /* 09h */
	struct {
		uint32_t vtune_res:3;
		uint32_t :7;
		uint32_t force_curve:1;
		uint32_t bypass_vco_tuning:1;
		uint32_t no_vspi_trigger:1;
		uint32_t fsm_vspi_clk_sel:2;
		uint32_t :17;
	} vco_autocal_cfg; /* 0Ah */
	struct {
		uint32_t pd_del_sel:3;
		uint32_t :2;
		uint32_t pd_up_en:1;
		uint32_t pd_dn_en:1;
		uint32_t csp_mode:2;
		uint32_t force_cp_up:1;
		uint32_t force_cp_dn:1;
		uint32_t :21;
	} pd; /* 0Bh */
	struct {
		uint32_t chan_num:14;
		uint32_t :18;
	} efreq_mode; /* 0Ch */
	struct {
		uint32_t :32;
		uint32_t :32;
	}; /* 0Dh & 0Eh */
	struct {
		uint32_t gpo_sel:5;
		uint32_t gpo_test:1;
		uint32_t prev_atomux:1;
		uint32_t ldo_driver:1;
		uint32_t dis_pfet:1;
		uint32_t dis_nfet:1;
		uint32_t :22;
	} gpo; /* 0Fh */
	struct {
		uint32_t vco_switch:8;
		uint32_t autocal_busy:1;
		uint32_t :23;
	} vco_tune; /* 10h */
	struct {
		uint32_t err_mag_counts:19;
		uint32_t err_sign:1;
		uint32_t :12;
	} sar; /* 11h */
	struct {
		uint32_t gpo:1;
		uint32_t ld:1;
		uint32_t :30;
	} gpo2; /* 12h */
	struct {
		uint32_t :32;
	} bist; /* 13h */
};

struct vco_reg_map {
	struct {
		uint32_t cal:1;
		uint32_t caps:8;
		uint32_t :23;
	} tuning; /* 00h */
	struct {
		uint32_t master_en_vcosub:1;
		uint32_t vco_en:1;
		uint32_t pll_buf_en:1;
		uint32_t io_master_en:1;
		uint32_t spare:1;
		uint32_t out_stage_en:1;
		uint32_t :26;
	} enables; /* 01h */
	struct {
		uint32_t rf_div_ratio:6;
		uint32_t :26;
	} biases; /* 02h */
	struct {
		uint32_t power_perf_prior:2;
		uint32_t pf_p_out_en:1;
		uint32_t pf_n_out_en:1;
		uint32_t int_term_en:1;
		uint32_t inc_int_out_res:1;
		uint32_t :1;
		uint32_t mute_mode:2;
		uint32_t :23;
	} config; /* 03h */
	struct {
		uint32_t :32;
	} calbias; /* 04h */
	struct {
		uint32_t :32;
	} cf_cal; /* 05h */
	struct {
		uint32_t :32;
	} msb_cal_0; /* 06h */
	struct {
		uint32_t out_gain_cntr:4;
		uint32_t :28;
	} msb_cal_1; /* 07h */
};

#endif // HMC1033_MAP_H
