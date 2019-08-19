/**
 * @file hmc1033.c
 * @brief HMC1033 Controller
 * @author matyunin.d
 * @date 29.07.2019
 * @copyright MIT License
 */

#include "hmc1033.h"
#include "hmc1033_spi.h"
#include "hmc1033_map.h"
#include "xil_io.h"
#include <stdlib.h>
#include <string.h>
#include <math.h>

/* Register Address */
#define REG_CR_OFFSET 		((u32)0x00)

/* Register Map */
#define REG_CR_CEN_MSK		((u32)0x00000001)

/* Register Operations */
#define write_reg(base_addr, offset, data) 	Xil_Out32((base_addr) + (offset), (u32)(data))
#define read_reg(base_addr, offset)			Xil_In32((base_addr) + (offset))

#define CHIP_ID			((uint32_t)0xA7975)

#define WR_MSK			((u32)0x00000000)
#define RD_MSK			((u32)0x80000000)
#define ADDR_MSK		((u32)0x0000003F)
#define DATA_MSK		((u32)0x00FFFFFF)
#define ADDR_POS		25
#define DATA_POS		1

#define REGADDR(base, reg)		((((uint32_t)reg)-((uint32_t)base))/sizeof(uint32_t))

struct hmc1033_hw_dev {
	struct hmc1033_spi spi;
	struct pll_reg_map pll_regs;
	struct vco_reg_map vco_regs;
};

static const uint32_t pll_regs_default[] = {
	0xA7975, 0x2, 0x1, 0x2C, 0x0, 0x0, 0x2003CA, 0x14D, 0xC1BEFF, 0x10F264, 0x2006, 0xF8061, 0x0, 0x1,
	0xA3, 0x80013, 0x3, 0x1259 };

static const uint32_t vco_regs_default[] = {
	0x0, 0x1BF, 0x1, 0x1F, 0xC9, 0xAA, 0xFF, 0x91 };

static void chip_enable(hmc1033_dev_t *dev);
static void chip_disable(hmc1033_dev_t *dev);
static void set_defaults(struct hmc1033_hw_dev *hdev);
static void hw_write_reg(struct hmc1033_hw_dev *hdev, uint8_t addr, uint32_t data);
static uint32_t hw_read_reg(struct hmc1033_hw_dev *hdev, uint8_t addr);
static void pll_write_reg(struct hmc1033_hw_dev *hdev, void *reg);
static void pll_read_reg(struct hmc1033_hw_dev *hdev, void *reg);
static void vco_write_reg(struct hmc1033_hw_dev *hdev, void *reg);
static int check_id(struct hmc1033_hw_dev *hdev);

/**
 * @brief HMC1031 device initialization
 * @param dev Pointer to device structure
 * @param baseaddr Device base address
 * @return XST_SUCCESS | XST_FAILURE
 */
int hmc1033_init(hmc1033_dev_t *dev, u32 baseaddr)
{
	struct hmc1033_hw_dev *hdev;
	if (!dev || !baseaddr)
		return XST_FAILURE;

	dev->hwdev = NULL;
	dev->hwdev = (void *)malloc(sizeof(struct hmc1033_hw_dev));
	if (!dev->hwdev)
		return XST_FAILURE;

	hdev = (struct hmc1033_hw_dev *)dev->hwdev;
	hdev->spi.baseaddr = baseaddr;
	hdev->spi.dev_num = 0;
	hmc1033_spi_init(&hdev->spi);
	hmc1033_spi_cs_disable(&hdev->spi);
	if (check_id(hdev))
		return XST_FAILURE;

	set_defaults(hdev);

	return XST_SUCCESS;
}

/**
 * @brief Calculate clock configuration
 * @param xtal Input frequency
 * @param out_freq Output frequency
 * @param cfg Pointer to config structure
 * @return void
 */
void hmc1033_calculate(double xtal, double out_freq, struct hmc1033_config *cfg)
{
	const double fvco_max = 3000000000.0;
	const double fpfd_max = 70000000.0;
//	const double icp_step = 0.02;
	const int ndiv_int_min = 16;
//	const double ndiv_frac_min = 20.0; // see modf
//	const double frac_coef = 16777216.0;
	double ndiv, n;
//	double fvco;
//	int int_mode = 0;

	cfg->nout = (int)(2.0*floor(fvco_max/(2.0*out_freq)));
	//fvco = out_freq*cfg->nout;
	cfg->rdiv = (int)ceil(xtal/fpfd_max);
	n = out_freq/xtal;
//	if (n == ((double)((int)n)))
//		int_mode = 1;
loop_ndiv:
	ndiv = n*(double)cfg->rdiv*(double)cfg->nout;
//	if (int_mode) {
		if ((int)ndiv < ndiv_int_min) {
			cfg->rdiv++;
			goto loop_ndiv;
		}
		cfg->nint = (int)floor(ndiv);
		cfg->nfrac = 0;
//		cfg->icp = 1.1+()	TODO
//	} else {
//		if (ndiv < ndiv_frac_min) {
//			cfg->rdiv++;
//			goto loop_ndiv;
//		}
//		cfg->nint = (int)floor(ndiv);
//		cfg->nfrac = (int)ceil(frac_coef * (ndiv - (double)cfg->nint));
//	}
}

/**
 * @brief Apply new configuration
 * @param dev Pointer to device structure
 * @param cfg  Pointer to clock configuration structure
 * @return void
 */
void hmc1033_apply(hmc1033_dev_t *dev, const struct hmc1033_config *cfg)
{
	struct hmc1033_hw_dev *hdev = (struct hmc1033_hw_dev *)dev->hwdev;

	chip_disable(dev);

	hdev->pll_regs.refdiv.rdiv = cfg->rdiv;
	hdev->pll_regs.freq_int.intg = cfg->nint;
	hdev->pll_regs.freq_frac.frac = cfg->nfrac;
	hdev->vco_regs.biases.rf_div_ratio = cfg->nout;
	hdev->vco_regs.config.power_perf_prior = 3;
	hdev->vco_regs.config.pf_n_out_en = 1;
	hdev->vco_regs.config.pf_p_out_en = 1;
	hdev->vco_regs.config.mute_mode = 0;
	hdev->vco_regs.config.int_term_en = 0;
	hdev->vco_regs.msb_cal_1.out_gain_cntr = 1;
	hdev->pll_regs.sd_cfg.frac_bypass = (cfg->nfrac == 0.0) ? 1 : 0;
	hdev->pll_regs.sd_cfg.sd_enable = (cfg->nfrac == 0.0) ? 0 : 1;
//	hdev->pll_regs.ld.ld_win_type = 0;
	hdev->pll_regs.cp.cp_dn_gain = 100;
	hdev->pll_regs.cp.cp_up_gain = 100;
	hdev->pll_regs.cp.offset_mag = 0;
	hdev->pll_regs.cp.offset_up_en = 0;
	hdev->pll_regs.cp.offset_dn_en = 0;
	hdev->pll_regs.gpo.gpo_sel = 1;

	pll_write_reg(hdev, &hdev->pll_regs.rst);
	pll_write_reg(hdev, &hdev->pll_regs.refdiv);
	pll_write_reg(hdev, &hdev->pll_regs.sd_cfg);
	pll_write_reg(hdev, &hdev->pll_regs.ld);
	pll_write_reg(hdev, &hdev->pll_regs.ana_en);
	pll_write_reg(hdev, &hdev->pll_regs.cp);
	pll_write_reg(hdev, &hdev->pll_regs.vco_autocal_cfg);
	pll_write_reg(hdev, &hdev->pll_regs.pd);
	pll_write_reg(hdev, &hdev->pll_regs.gpo);
//	pll_write_reg(hdev, &hdev->pll_regs.vco_tune);
	pll_write_reg(hdev, &hdev->pll_regs.sar);
	pll_write_reg(hdev, &hdev->pll_regs.gpo2);
	vco_write_reg(hdev, &hdev->vco_regs.biases);
	vco_write_reg(hdev, &hdev->vco_regs.config);
	vco_write_reg(hdev, &hdev->vco_regs.msb_cal_1);
	vco_write_reg(hdev, &hdev->vco_regs.tuning);
	pll_write_reg(hdev, &hdev->pll_regs.freq_frac);
	pll_write_reg(hdev, &hdev->pll_regs.freq_int);

	chip_enable(dev);
}

/**
 * @brief Enable chip
 * @param dev Pointer to device structure
 * @return void
 */
static void chip_enable(hmc1033_dev_t *dev)
{
	u32 tmp;

	tmp = read_reg(dev->baseaddr, REG_CR_OFFSET);
	tmp |= REG_CR_CEN_MSK;
	write_reg(dev->baseaddr, REG_CR_OFFSET, tmp);
}

/**
 * @brief Disable chip
 * @param dev Pointer to device structure
 * @return void
 */
static void chip_disable(hmc1033_dev_t *dev)
{
	u32 tmp;

	tmp = read_reg(dev->baseaddr, REG_CR_OFFSET);
	tmp &= ~REG_CR_CEN_MSK;
	write_reg(dev->baseaddr, REG_CR_OFFSET, tmp);
}

/**
 * @brief HMC1033 default tuning
 * @param dev HMC1033 device
 * @return void
 */
static void set_defaults(struct hmc1033_hw_dev *hdev)
{
	memcpy(&hdev->pll_regs.id, &pll_regs_default[0], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.rst, &pll_regs_default[1], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.refdiv, &pll_regs_default[2], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.freq_int, &pll_regs_default[3], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.freq_frac, &pll_regs_default[4], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.vco_spi, &pll_regs_default[5], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.sd_cfg, &pll_regs_default[6], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.ld, &pll_regs_default[7], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.ana_en, &pll_regs_default[8], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.cp, &pll_regs_default[9], sizeof(uint32_t)); // TODO: fix VTUNE problem
	memcpy(&hdev->pll_regs.vco_autocal_cfg, &pll_regs_default[10], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.pd, &pll_regs_default[11], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.efreq_mode, &pll_regs_default[12], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.gpo, &pll_regs_default[13], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.vco_tune, &pll_regs_default[13], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.sar, &pll_regs_default[15], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.gpo2, &pll_regs_default[16], sizeof(uint32_t));
	memcpy(&hdev->pll_regs.bist, &pll_regs_default[17], sizeof(uint32_t));

	memcpy(&hdev->vco_regs.tuning, &vco_regs_default[0], sizeof(uint32_t)); //
	memcpy(&hdev->vco_regs.enables, &vco_regs_default[1], sizeof(uint32_t));
	memcpy(&hdev->vco_regs.biases, &vco_regs_default[2], sizeof(uint32_t)); //
	memcpy(&hdev->vco_regs.config, &vco_regs_default[3], sizeof(uint32_t)); //
	memcpy(&hdev->vco_regs.calbias, &vco_regs_default[4], sizeof(uint32_t));
	memcpy(&hdev->vco_regs.cf_cal, &vco_regs_default[5], sizeof(uint32_t));
	memcpy(&hdev->vco_regs.msb_cal_0, &vco_regs_default[6], sizeof(uint32_t));
	memcpy(&hdev->vco_regs.msb_cal_1, &vco_regs_default[7], sizeof(uint32_t)); //
}

/**
 * @brief Low-level write data TO register
 * @param hdev Pointer to HW device structure
 * @param addr Address
 * @param data Data
 * @return void
 */
static void hw_write_reg(struct hmc1033_hw_dev *hdev, uint8_t addr, uint32_t data)
{
	hmc1033_spi_cs_enable(&hdev->spi);
	hmc1033_spi_read_write(&hdev->spi, WR_MSK | ((addr & ADDR_MSK) << ADDR_POS) | ((data & DATA_MSK) << DATA_POS));
	hmc1033_spi_cs_disable(&hdev->spi);
}

/**
 * @brief Low-level read data FROM register
 * @param hdev Pointer to HW device structure
 * @param addr Address
 * @return register data
 */
static uint32_t hw_read_reg(struct hmc1033_hw_dev *hdev, uint8_t addr)
{
	uint32_t data;

	hmc1033_spi_cs_enable(&hdev->spi);
	data = hmc1033_spi_read_write(&hdev->spi, RD_MSK | ((addr & ADDR_MSK) << ADDR_POS) | ((0x00 & DATA_MSK) << DATA_POS));
	hmc1033_spi_cs_disable(&hdev->spi);
	data &= DATA_MSK; // ?
	return data;
}

/**
 * @brief Write PLL register
 * @param hdev Pointer to HW device structure
 * @param reg Pointer to PLL register (from pll_regs)
 * @return void
 */
static void pll_write_reg(struct hmc1033_hw_dev *hdev, void *reg)
{
	hw_write_reg(hdev, REGADDR(&hdev->pll_regs, reg), *((uint32_t *)reg));
}

/**
 * @brief Read PLL register
 * @param hdev Pointer to HW device structure
 * @param reg Pointer to PLL register (from pll_regs)
 * @return void
 */
static void pll_read_reg(struct hmc1033_hw_dev *hdev, void *reg)
{
	*((uint32_t *)reg) = hw_read_reg(hdev, REGADDR(&hdev->pll_regs, reg));
}

/**
 * @brief Write VCO register
 * @param hdev Pointer to HW device structure
 * @param reg Pointer to PLL register (from vco_regs)
 * @return void
 */
static void vco_write_reg(struct hmc1033_hw_dev *hdev, void *reg)
{
	hdev->pll_regs.vco_spi.id = 0;
	hdev->pll_regs.vco_spi.addr = REGADDR(&hdev->vco_regs, reg);
	hdev->pll_regs.vco_spi.data = *((uint32_t *)reg);
	pll_write_reg(hdev, &hdev->pll_regs.vco_spi);
}

/**
 * @brief Check chip ID
 * @param hdev Pointer to HW device structure
 * @return
 *	0 - success, good device
 *	1 - failure, bad device
 */
static int check_id(struct hmc1033_hw_dev *hdev)
{
	pll_read_reg(hdev, &hdev->pll_regs.id);
	if (hdev->pll_regs.id.chip_id == CHIP_ID)
		return XST_SUCCESS;
	return XST_FAILURE;
}
