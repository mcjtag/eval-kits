`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 26.03.2019 10:25:08
// Design Name: 
// Module Name: ad_spi
// Project Name: ad9520
// Target Devices: 7-series
// Tool Versions: 2018.3
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// License: MIT
//  Copyright (c) 2019 Dmitry Matyunin
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
// 
//////////////////////////////////////////////////////////////////////////////////

module ad9520_v1_0 # (
	parameter integer C_S_AXI_DATA_WIDTH = 32,
	parameter integer C_S_AXI_ADDR_WIDTH = 8,
	parameter integer DEVICE_COUNT = 1,
	parameter integer SPI_CLOCK_PRESCALER = 1,
	parameter integer IS_AD_RESET_PRESENT = 1,
	parameter integer IS_AD_PD_PRESENT = 1,
	parameter integer IS_AD_SYNC_PRESENT = 1,
	parameter integer IS_AD_EEPROM_PRESENT = 1,
	parameter integer IS_AD_REFMON_PRESENT = 1,
	parameter integer IS_AD_LD_PRESENT = 1,
    parameter integer IS_AD_STATUS_PRESENT = 1
)
(
// Ports of Axi Slave Bus Interface S_AXI
	input wire s_axi_aclk,
	input wire s_axi_aresetn,
	input wire [C_S_AXI_ADDR_WIDTH-1:0]s_axi_awaddr,
	input wire [2:0]s_axi_awprot,
	input wire s_axi_awvalid,
	output wire s_axi_awready,
	input wire [C_S_AXI_DATA_WIDTH-1:0]s_axi_wdata,
	input wire [(C_S_AXI_DATA_WIDTH/8)-1:0]s_axi_wstrb,
	input wire s_axi_wvalid,
	output wire s_axi_wready,
	output wire [1:0]s_axi_bresp,
	output wire s_axi_bvalid,
	input wire s_axi_bready,
	input wire [C_S_AXI_ADDR_WIDTH-1:0]s_axi_araddr,
	input wire [2:0]s_axi_arprot,
	input wire s_axi_arvalid,
	output wire s_axi_arready,
	output wire [C_S_AXI_DATA_WIDTH-1:0]s_axi_rdata,
	output wire [1:0]s_axi_rresp,
	output wire s_axi_rvalid,
	input wire s_axi_rready,
// AD9520 IO
	output wire [DEVICE_COUNT-1:0]reset,
	output wire [DEVICE_COUNT-1:0]pd,
	output wire [DEVICE_COUNT-1:0]sync,
	output wire [DEVICE_COUNT-1:0]eeprom,
	input wire [DEVICE_COUNT-1:0]refmon,
	input wire [DEVICE_COUNT-1:0]ld,
	input wire [DEVICE_COUNT-1:0]status,
	output wire sclk,
	output wire sdo,
	input wire sdi,
	output wire [DEVICE_COUNT-1:0]cs, 
// Misc
    input wire sync_clk,
    input wire esync
);

wire spi_rst;
wire spi_en;
wire [7:0]spi_dev;
wire [31:0]spi_data_in;
wire spi_data_wr;

wire [31:0]spi_data_out;
wire spi_data_rd;
wire [7:0]spi_status;

wire ctrl_rst;
wire ctrl_esync;

wire [7:0]ioc_reset;
wire [7:0]ioc_pd;
wire [7:0]ioc_sync;
wire [7:0]ioc_eeprom;

wire [7:0]stat_refmon;
wire [7:0]stat_ld;
wire [7:0]stat_status;

generate if (IS_AD_REFMON_PRESENT)
    assign stat_refmon = refmon;
    else
    assign stat_refmon = 8'h00;
endgenerate

generate if (IS_AD_LD_PRESENT)
    assign stat_ld = ld;
    else
    assign stat_ld = 8'h00;
endgenerate

generate if (IS_AD_STATUS_PRESENT)
    assign stat_status = status;
    else
    assign stat_status = 8'h00;
endgenerate

assign reset = ~ioc_reset;
assign pd = ~ioc_pd;
assign eeprom = ioc_eeprom;

ad9520_v1_0_S_AXI # (
	.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
) ad9520_v1_0_S_AXI_inst (
	.S_AXI_ACLK(s_axi_aclk),
	.S_AXI_ARESETN(s_axi_aresetn),
	.S_AXI_AWADDR(s_axi_awaddr),
	.S_AXI_AWPROT(s_axi_awprot),
	.S_AXI_AWVALID(s_axi_awvalid),
	.S_AXI_AWREADY(s_axi_awready),
	.S_AXI_WDATA(s_axi_wdata),
	.S_AXI_WSTRB(s_axi_wstrb),
	.S_AXI_WVALID(s_axi_wvalid),
	.S_AXI_WREADY(s_axi_wready),
	.S_AXI_BRESP(s_axi_bresp),
	.S_AXI_BVALID(s_axi_bvalid),
	.S_AXI_BREADY(s_axi_bready),
	.S_AXI_ARADDR(s_axi_araddr),
	.S_AXI_ARPROT(s_axi_arprot),
	.S_AXI_ARVALID(s_axi_arvalid),
	.S_AXI_ARREADY(s_axi_arready),
	.S_AXI_RDATA(s_axi_rdata),
	.S_AXI_RRESP(s_axi_rresp),
	.S_AXI_RVALID(s_axi_rvalid),
	.S_AXI_RREADY(s_axi_rready),
	.spi_rst(spi_rst),
	.spi_en(spi_en),
	.spi_dev(spi_dev),
    .spi_data_in(spi_data_in),
    .spi_data_wr(spi_data_wr),
    .spi_data_out(spi_data_out),
    .spi_data_rd(spi_data_rd),
    .spi_status(spi_status),
    .ctrl_rst(ctrl_rst),
    .ctrl_esync(ctrl_esync),
	.ioc_reset(ioc_reset),
	.ioc_pd(ioc_pd),
	.ioc_sync(ioc_sync),
	.ioc_eeprom(ioc_eeprom),
	.stat_refmon(stat_refmon),
	.stat_ld(stat_ld),
	.stat_status(stat_status)
);

ad_spi # (
    .DEV_COUNT(DEVICE_COUNT),
    .PRESCALER(SPI_CLOCK_PRESCALER),
    .DATA_WIDTH(8),
    .FIFO_DEPTH(4)
) ad_spi_inst (
    .clk(s_axi_aclk),
    .rst(~s_axi_aresetn | spi_rst),
    .dev_num(spi_dev),
    .data_in(spi_data_in),
    .data_wr(spi_data_wr),
    .data_out(spi_data_out),
    .data_rd(spi_data_rd),
    .status(spi_status),
    .sclk(sclk),
    .sdo(sdo),
    .sdi(sdi),
    .cs(cs)
);

resync resync_inst (
    .clk(s_axi_aclk),
    .rst(~s_axi_aresetn),
    .sync_in(ioc_sync),
    .esync_en(ctrl_esync),
    .sync_clk(sync_clk),
    .esync(esync),
    .sync_out(sync)
);

endmodule
