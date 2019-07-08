/*
 * audio_test.c
 *
 *  Created on: 28 θών. 2019 γ.
 *      Author: matyunin.d
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xil_cache.h"
#include "xparameters.h"
//#include "xaudioformatter.h"
#include "xi2srx.h"
#include "xi2stx.h"
#include "xil_printf.h"

#include "hal/hal.h"

#define I2S_RX_FS			8 /* kHz */
#define I2S_RX_MCLK			(256 * I2S_RX_FS)
#define I2S_RX_TIME_OUT 	500000

#define I2S_TX_FS			8 /* kHz */
#define I2S_TX_MCLK			(256 * I2S_TX_FS)
#define I2S_TX_TIME_OUT 	500000

#define AF_FS				8 /* kHz */
#define AF_MCLK				(256 * AF_FS)
#define AF_S2MM_TIMEOUT 	0x80000000

static XI2s_Rx I2sRxInstance;
//static XAudioFormatter AFInstance;
static XI2s_Tx I2sTxInstance;

static u32 I2sTxIntrReceived;
static u32 I2sRxIntrReceived;
static u32 S2MMAFIntrReceived;
static u32 MM2SAFIntrReceived;

static uint32_t audio_sample[] = {

};

static uint32_t dma_data[1024] __attribute__((section(".ext")));

//static XAudioFormatterHwParams af_hw_params;
//
//void *XS2MMAFCallback(XAudioFormatter *AFInstancePtr);
//void *XMM2SAFCallback(XAudioFormatter *AFInstancePtr);

void spi_wr(u8 addr, u16 dat)
{
	u16 data = (addr << 9) | (dat << 0);
	spi_set_cs(&aud_spi, 1);
	spi_transfer(&aud_spi, (u8 *)&data, (u8 *)&data, 2);
	spi_set_cs(&aud_spi, 0);
}

int audio_init(void)
{
	u32 status;
	XI2stx_Config *I2STxConfig;
	XI2srx_Config *I2SRxConfig;

	spi_wr(0x1F, 0x00);

	spi_wr(0, 0x11F);
	spi_wr(1, 0x11F);
	spi_wr(2, 0x1FF);
	spi_wr(3, 0x1FF);
	spi_wr(4, 0x034);
	spi_wr(5, 0x000);
	spi_wr(7, 0x02);
	spi_wr(6, 0x00);

	I2STxConfig = XI2s_Tx_LookupConfig(XPAR_AUDIO_HIER_I2S_TRANSMITTER_0_DEVICE_ID);
	if (I2STxConfig == NULL) {
		return XST_FAILURE;
	}
	status = XI2s_Tx_CfgInitialize(&I2sTxInstance, I2STxConfig, I2STxConfig->BaseAddress);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XI2s_Tx_SetSclkOutDiv(&I2sTxInstance, I2S_TX_MCLK, I2S_TX_FS);
	XI2s_Tx_SetChMux(&I2sTxInstance, 0, XI2S_TX_CHMUX_AXIS_01);
	XI2s_Tx_Enable(&I2sTxInstance, TRUE);

	I2SRxConfig = XI2s_Rx_LookupConfig(XPAR_AUDIO_HIER_I2S_RECEIVER_0_DEVICE_ID);
	if (I2SRxConfig == NULL)
		return XST_FAILURE;
	status = XI2s_Rx_CfgInitialize(&I2sRxInstance, I2SRxConfig, I2SRxConfig->BaseAddress);
	if (status != XST_SUCCESS)
		return XST_FAILURE;
	XI2s_Rx_SetSclkOutDiv(&I2sRxInstance, I2S_RX_MCLK, I2S_RX_FS);
	XI2s_Rx_SetChMux(&I2sRxInstance, 0x0, XI2S_RX_CHMUX_XI2S_01);
	XI2s_Rx_Enable(&I2sRxInstance, TRUE);


//	af_hw_params.buf_addr = (u32)dma_data;
//	af_hw_params.active_ch = 2;
//	af_hw_params.bits_per_sample = BIT_DEPTH_16;
//	af_hw_params.periods = 8;
//	af_hw_params.bytes_per_period = 64;
//
//	status = XAudioFormatter_Initialize(&AFInstance, XPAR_AUDIO_HIER_AUDIO_FORMATTER_0_DEVICE_ID);
//	if (status != XST_SUCCESS)
//		return XST_FAILURE;
//
//	if (AFInstance.s2mm_presence == 1) {
//		status = XIntc_Connect(&intc.intc, XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_AUDIO_HIER_AUDIO_FORMATTER_0_IRQ_S2MM_INTR, (XInterruptHandler)XAudioFormatterS2MMIntrHandler, &AFInstance);
//		if (status == XST_SUCCESS)
//			XIntc_Enable(&intc.intc, XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_AUDIO_HIER_AUDIO_FORMATTER_0_IRQ_S2MM_INTR);
//		else
//			return XST_FAILURE;
//
//		AFInstance.ChannelId = XAudioFormatter_S2MM;
//		XAudioFormatter_SetS2MMCallback(&AFInstance, XAudioFormatter_IOC_Handler, XS2MMAFCallback, (void *)&AFInstance);
//		XAudioFormatter_InterruptEnable(&AFInstance, XAUD_CTRL_IOC_IRQ_MASK);
//		XAudioFormatterSetS2MMTimeOut(&AFInstance, AF_S2MM_TIMEOUT);
//		XAudioFormatterSetHwParams(&AFInstance, &af_hw_params);
////		XAudioFormatterDMAStart(&AFInstance);
//	}
//
//	if (AFInstance.mm2s_presence == 1) {
//		status = XIntc_Connect(&intc.intc, XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_AUDIO_HIER_AUDIO_FORMATTER_0_IRQ_MM2S_INTR, (XInterruptHandler)XAudioFormatterMM2SIntrHandler, &AFInstance);
//		if (status == XST_SUCCESS)
//			XIntc_Enable(&intc.intc, XPAR_MB_HIER_MICROBLAZE_0_AXI_INTC_AUDIO_HIER_AUDIO_FORMATTER_0_IRQ_MM2S_INTR);
//		else
//			return XST_FAILURE;
//
//		AFInstance.ChannelId = XAudioFormatter_MM2S;
//		XAudioFormatter_SetMM2SCallback(&AFInstance, XAudioFormatter_IOC_Handler, XMM2SAFCallback, &AFInstance);
//		XAudioFormatter_InterruptEnable(&AFInstance, XAUD_CTRL_IOC_IRQ_MASK);
//		XAudioFormatterSetFsMultiplier(&AFInstance, AF_MCLK, AF_FS);
//		XAudioFormatterSetHwParams(&AFInstance, &af_hw_params);
////		XAudioFormatterDMAStart(&AFInstance);
//	}



	return XST_SUCCESS;
}

//void audio_test(void)
//{
//	while (1) {
//		S2MMAFIntrReceived = 0;
//		MM2SAFIntrReceived = 0;
//
//		AFInstance.ChannelId = XAudioFormatter_S2MM;
//		XAudioFormatterDMAStart(&AFInstance);
//		while (!S2MMAFIntrReceived);
//
//		AFInstance.ChannelId = XAudioFormatter_MM2S;
//		XAudioFormatterDMAStart(&AFInstance);
//		while(!MM2SAFIntrReceived);
//	}
//}
//
//void *XS2MMAFCallback(XAudioFormatter *AFInstancePtr)
//{
//	S2MMAFIntrReceived = 1;
//	AFInstancePtr->ChannelId = XAudioFormatter_S2MM;
//	XAudioFormatterDMAStop(&AFInstance);
//	return NULL;
//}
//
//void *XMM2SAFCallback(XAudioFormatter *AFInstancePtr)
//{
//	/* clear interrupt flag */
//	MM2SAFIntrReceived = 1;
//	AFInstancePtr->ChannelId = XAudioFormatter_MM2S;
//	XAudioFormatterDMAStop(&AFInstance);
//	return NULL;
//}
