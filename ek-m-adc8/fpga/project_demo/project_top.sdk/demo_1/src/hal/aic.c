/**
 * @file aic.c
 * @brief Axis Switch HAL
 * @author matyunin.d
 * @date 14.08.2019
 */

#include "aic.h"

/**
 * @brief AIC initialization
 * @param dev Pointer to device structure
 * @return XST_SUCCESS | XST_FAILURE
 */
int aic_init(struct aic_dev *dev)
{
	XAxis_Switch_Config *config_ptr = NULL;
	int status;

	if (!dev)
		return XST_FAILURE;

	config_ptr = XAxisScr_LookupConfig(dev->dev_id);
	if (!config_ptr)
		return XST_FAILURE;

	status = XAxisScr_CfgInitialize(&dev->aic, config_ptr, config_ptr->BaseAddress);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	XAxisScr_RegUpdateDisable(&dev->aic);
	XAxisScr_MiPortDisableAll(&dev->aic);
	XAxisScr_RegUpdateEnable(&dev->aic);

	return XST_SUCCESS;
}

/**
 * @brief Disable all outputs
 * @param dev Pointer to device structure
 * @return void
 */
void aic_disable_all(struct aic_dev *dev)
{
	XAxisScr_MiPortDisableAll(&dev->aic);
}

/**
 * @brief Disable link
 * @param dev Pointer to device structure
 * @param mi Master interface index
 * @return XST_SUCCESS | XST_FAILURE
 */
int aic_disable(struct aic_dev *dev, u8 mi)
{
	int status;

	XAxisScr_MiPortDisable(&dev->aic, mi);
	status = XAxisScr_IsMiPortDisabled(&dev->aic, mi);
	if (status != TRUE)
		return XST_FAILURE;
	return XST_SUCCESS;
}

/**
 * @brief Enable link
 * @param dev Pointer to device structure
 * @param si Slave interface index
 * @param mi Master interface index
 * @return XST_SUCCESS | XST_FAILURE
 */
int aic_enable(struct aic_dev *dev, u8 si, u8 mi)
{
	int status;

	XAxisScr_MiPortEnable(&dev->aic, mi, si);
	XAxisScr_RegUpdateEnable(&dev->aic);
	status = XAxisScr_IsMiPortEnabled(&dev->aic, mi, si);
	if (status != TRUE)
		return XST_FAILURE;
	return XST_SUCCESS;
}
