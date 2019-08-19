`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 05.08.2019 11:51:01
// Design Name: 
// Module Name: adc8_v1_0
// Project Name: adc8
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
 
module adc8_v1_0 #(
	parameter integer C_S_AXI_DATA_WIDTH = 32,
	parameter integer C_S_AXI_ADDR_WIDTH = 7,
	parameter DELAY_GROUP_0 = "ADC_IF_GROUP0",
	parameter DELAY_GROUP_1 = "ADC_IF_GROUP1",
	parameter DELAY_GROUP_2 = "ADC_IF_GROUP2",
	parameter DELAY_GROUP_3 = "ADC_IF_GROUP3",
	parameter DELAY_GROUP_4 = "ADC_IF_GROUP4",
	parameter DELAY_GROUP_5 = "ADC_IF_GROUP5",
	parameter DELAY_GROUP_6 = "ADC_IF_GROUP6",
	parameter DELAY_GROUP_7 = "ADC_IF_GROUP7",
	parameter DELAY_CTRL_ENABLE_0 = 0,
	parameter DELAY_CTRL_ENABLE_1 = 0,
	parameter DELAY_CTRL_ENABLE_2 = 0,
	parameter DELAY_CTRL_ENABLE_3 = 0,
	parameter DELAY_CTRL_ENABLE_4 = 0,
	parameter DELAY_CTRL_ENABLE_5 = 0,
	parameter DELAY_CTRL_ENABLE_6 = 0,
	parameter DELAY_CTRL_ENABLE_7 = 0
)
(
	/* Ports of Axi Slave Bus Interface S_AXI */
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
	/* ADC SPI & Mode */
	output wire [7:0]adc_spi_cs,
	output wire [7:0]adc_spi_sclk,
	output wire [7:0]adc_spi_mosi,
	input wire [7:0]adc_spi_miso,
	output wire [7:0]adc_amode,
	/* DST SPI & Control */
	output wire dst_spi_cs,
	output wire dst_spi_sclk,
	output wire dst_spi_mosi,
	input wire dst_spi_miso,
	output wire dst_refsel,
	input wire dst_ld,
	output wire dst_sync,
	output wire dst_rst,
	output wire dst_pd,
	/* Ext SYNC */
	input wire esync,
	/* Input ADC Data */
	input wire adc0_clk_p,
	input wire adc0_clk_n,
	input wire [6:0]adc0_dq_p,
	input wire [6:0]adc0_dq_n,
	input wire adc1_clk_p,
	input wire adc1_clk_n,
	input wire [6:0]adc1_dq_p,
	input wire [6:0]adc1_dq_n,
	input wire adc2_clk_p,
	input wire adc2_clk_n,
	input wire [6:0]adc2_dq_p,
	input wire [6:0]adc2_dq_n,
	input wire adc3_clk_p,
	input wire adc3_clk_n,
	input wire [6:0]adc3_dq_p,
	input wire [6:0]adc3_dq_n,
	input wire adc4_clk_p,
	input wire adc4_clk_n,
	input wire [6:0]adc4_dq_p,
	input wire [6:0]adc4_dq_n,
	input wire adc5_clk_p,
	input wire adc5_clk_n,
	input wire [6:0]adc5_dq_p,
	input wire [6:0]adc5_dq_n,
	input wire adc6_clk_p,
	input wire adc6_clk_n,
	input wire [6:0]adc6_dq_p,
	input wire [6:0]adc6_dq_n,
	input wire adc7_clk_p,
	input wire adc7_clk_n,
	input wire [6:0]adc7_dq_p,
	input wire [6:0]adc7_dq_n,
	/* Output data */
	input wire aclk,
	input wire aresetn,
	input wire ref_clk,
	output wire [15:0]m0_axis_tdata,
	output wire m0_axis_tvalid,
	output wire [15:0]m1_axis_tdata,
	output wire m1_axis_tvalid,
	output wire [15:0]m2_axis_tdata,
	output wire m2_axis_tvalid,
	output wire [15:0]m3_axis_tdata,
	output wire m3_axis_tvalid,
	output wire [15:0]m4_axis_tdata,
	output wire m4_axis_tvalid,
	output wire [15:0]m5_axis_tdata,
	output wire m5_axis_tvalid,
	output wire [15:0]m6_axis_tdata,
	output wire m6_axis_tvalid,
	output wire [15:0]m7_axis_tdata,
	output wire m7_axis_tvalid
);

wire spi_dev_num;
wire [15:0]spi_data_in;
wire spi_data_wr;
wire [15:0]spi_data_out;
wire spi_data_rd;
wire [7:0]spi_status;

wire spi_sck;
wire spi_sdo;
wire spi_sdi;
wire spi_ncs;

wire [3:0]sw_mode;
wire [7:0]sw_ctrl_oen;
wire [7:0]sw_ctrl_cal;
wire [7:0]sw_ctrl_ovf;

wire ctrl_rst;
wire ctrl_esync;

wire spi_rst;
wire spi_en;

wire dst_ioc_rst;
wire dst_ioc_pd;
wire dst_ioc_sync;
wire dst_ioc_refsel;
wire dst_ios_ld;

wire [7:0]adc_ioc_amode;
wire adc_if_rst;

wire [15:0]dq_data[7:0];
wire [7:0]dq_data_valid;

wire [7:0]calib_data[7:0];
wire ctrl_out_valid;
wire out_valid_en;
wire calib_done;

assign dst_rst = ~dst_ioc_rst;
assign dst_pd = ~dst_ioc_pd;
assign dst_refsel = dst_ioc_refsel;
assign dst_ios_ld = dst_ld;
assign adc_amode = adc_ioc_amode;
assign calib_done = calib_data[0] ^ calib_data[1] ^ calib_data[2] ^ calib_data[3] ^ calib_data[4] ^ calib_data[5] ^ calib_data[6] ^ calib_data[7];

/* Control */
adc8_v1_0_S_AXI # ( 
	.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
) adc8_v1_0_S_AXI_inst (
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
	.ctrl_rst(ctrl_rst),
	.ctrl_esync(ctrl_esync),
	.ctrl_out_valid(ctrl_out_valid),
	.ctrl_calib_done(calib_done),
	.spi_rst(spi_rst),
	.spi_en(spi_en),
	.spi_dev(spi_dev_num),
	.spi_data_in(spi_data_in),
	.spi_data_wr(spi_data_wr),
	.spi_data_out(spi_data_out),
    .spi_data_rd(spi_data_rd),
	.spi_status(spi_status),
	.dst_rst(dst_ioc_rst),
	.dst_pd(dst_ioc_pd),
	.dst_sync(dst_ioc_sync),
	.dst_refsel(dst_ioc_refsel),
	.dst_ld(dst_ios_ld),
	.sw_mode(sw_mode),
	.adc_if_rst(adc_if_rst),
	.adc_oen(sw_ctrl_oen),
	.adc_cal(sw_ctrl_cal),
	.adc_amode(adc_ioc_amode),
	.adc_ovf(sw_ctrl_ovf)
);

mil_spi # (
	.DEV_COUNT(1),
	.PRESCALER(1000),
	.DATA_WIDTH(16),
	.FIFO_DEPTH(4)
) mil_spi_inst (
	.clk(s_axi_aclk),
	.rst(~s_axi_aresetn | spi_rst),
	.dev_num(spi_dev_num),
	.data_in(spi_data_in),
	.data_wr(spi_data_wr),
	.data_out(spi_data_out),
	.data_rd(spi_data_rd),
	.status(spi_status),
	.sclk(spi_sck),
	.sdo(spi_sdo),
	.sdi(spi_sdi),
	.cs(spi_ncs)
);

spi_switch spi_switch_inst (
	.clk(s_axi_aclk),
	.rst(~s_axi_aresetn | ctrl_rst),
	.spi_sck(spi_sck),
	.spi_sdo(spi_sdo),
	.spi_sdi(spi_sdi),
	.spi_ncs(spi_ncs),
	.adc_spi_sck(adc_spi_sclk),
	.adc_spi_sdo(adc_spi_mosi),
	.adc_spi_sdi(adc_spi_miso),
	.adc_spi_ncs(adc_spi_cs),
	.dst_spi_sck(dst_spi_sclk),
	.dst_spi_sdo(dst_spi_mosi),
	.dst_spi_sdi(dst_spi_miso),
	.dst_spi_ncs(dst_spi_cs),
	.mode(sw_mode),
	.ctrl_oen(sw_ctrl_oen),
	.ctrl_cal(sw_ctrl_cal),
	.ctrl_ovf(sw_ctrl_ovf)
);

resync resync_inst(
	.clk(s_axi_aclk),
	.rst(~s_axi_aresetn | ctrl_rst),
	.sync_in(dst_ioc_sync),
	.esync_en(ctrl_esync),
	.sync_clk(aclk),
	.esync(esync),
	.sync_out(dst_sync)
);

/* Data */
adc_if #(
	.DELAY_GROUP(DELAY_GROUP_0),
	.DELAY_CTRL_ENABLE(DELAY_CTRL_ENABLE_0)
) adc_if_inst_0 (
	.clk(aclk),
	.rst(~aresetn | adc_if_rst | esync),
	.ref_clk(ref_clk),
	.del_rdy(),
	.adc_clk_p(adc0_clk_p),
	.adc_clk_n(adc0_clk_n),
	.adc_dq_p(adc0_dq_p),
	.adc_dq_n(adc0_dq_n),
	.data(dq_data[0]),
	.data_valid(dq_data_valid[0]),
	.calib_data(calib_data[0])
);

adc_if #(
	.DELAY_GROUP(DELAY_GROUP_1),
	.DELAY_CTRL_ENABLE(DELAY_CTRL_ENABLE_1)
) adc_if_inst_1 (
	.clk(aclk),
	.rst(~aresetn | adc_if_rst | esync),
	.ref_clk(ref_clk),
	.del_rdy(),
	.adc_clk_p(adc1_clk_p),
	.adc_clk_n(adc1_clk_n),
	.adc_dq_p(adc1_dq_p),
	.adc_dq_n(adc1_dq_n),
	.data(dq_data[1]),
	.data_valid(dq_data_valid[1]),
	.calib_data(calib_data[1])
);

adc_if #(
	.DELAY_GROUP(DELAY_GROUP_2),
	.DELAY_CTRL_ENABLE(DELAY_CTRL_ENABLE_2)
) adc_if_inst_2 (
	.clk(aclk),
	.rst(~aresetn | adc_if_rst | esync),
	.ref_clk(ref_clk),
	.del_rdy(),
	.adc_clk_p(adc2_clk_p),
	.adc_clk_n(adc2_clk_n),
	.adc_dq_p(adc2_dq_p),
	.adc_dq_n(adc2_dq_n),
	.data(dq_data[2]),
	.data_valid(dq_data_valid[2]),
	.calib_data(calib_data[2])
);

adc_if #(
	.DELAY_GROUP(DELAY_GROUP_3),
	.DELAY_CTRL_ENABLE(DELAY_CTRL_ENABLE_3)
) adc_if_inst_3 (
	.clk(aclk),
	.rst(~aresetn | adc_if_rst | esync),
	.ref_clk(ref_clk),
	.del_rdy(),
	.adc_clk_p(adc3_clk_p),
	.adc_clk_n(adc3_clk_n),
	.adc_dq_p(adc3_dq_p),
	.adc_dq_n(adc3_dq_n),
	.data(dq_data[3]),
	.data_valid(dq_data_valid[3]),
	.calib_data(calib_data[3])
);

adc_if #(
	.DELAY_GROUP(DELAY_GROUP_4),
	.DELAY_CTRL_ENABLE(DELAY_CTRL_ENABLE_4)
) adc_if_inst_4 (
	.clk(aclk),
	.rst(~aresetn | adc_if_rst | esync),
	.ref_clk(ref_clk),
	.del_rdy(),
	.adc_clk_p(adc4_clk_p),
	.adc_clk_n(adc4_clk_n),
	.adc_dq_p(adc4_dq_p),
	.adc_dq_n(adc4_dq_n),
	.data(dq_data[4]),
	.data_valid(dq_data_valid[4]),
	.calib_data(calib_data[4])
);

adc_if #(
	.DELAY_GROUP(DELAY_GROUP_5),
	.DELAY_CTRL_ENABLE(DELAY_CTRL_ENABLE_5)
) adc_if_inst_5 (
	.clk(aclk),
	.rst(~aresetn | adc_if_rst | esync),
	.ref_clk(ref_clk),
	.del_rdy(),
	.adc_clk_p(adc5_clk_p),
	.adc_clk_n(adc5_clk_n),
	.adc_dq_p(adc5_dq_p),
	.adc_dq_n(adc5_dq_n),
	.data(dq_data[5]),
	.data_valid(dq_data_valid[5]),
	.calib_data(calib_data[5])
);

adc_if #(
	.DELAY_GROUP(DELAY_GROUP_6),
	.DELAY_CTRL_ENABLE(DELAY_CTRL_ENABLE_6)
) adc_if_inst_6 (
	.clk(aclk),
	.rst(~aresetn | adc_if_rst | esync),
	.ref_clk(ref_clk),
	.del_rdy(),
	.adc_clk_p(adc6_clk_p),
	.adc_clk_n(adc6_clk_n),
	.adc_dq_p(adc6_dq_p),
	.adc_dq_n(adc6_dq_n),
	.data(dq_data[6]),
	.data_valid(dq_data_valid[6]),
	.calib_data(calib_data[6])
);

adc_if #(
	.DELAY_GROUP(DELAY_GROUP_7),
	.DELAY_CTRL_ENABLE(DELAY_CTRL_ENABLE_7)
) adc_if_inst_7 (
	.clk(aclk),
	.rst(~aresetn | adc_if_rst | esync),
	.ref_clk(ref_clk),
	.del_rdy(),
	.adc_clk_p(adc7_clk_p),
	.adc_clk_n(adc7_clk_n),
	.adc_dq_p(adc7_dq_p),
	.adc_dq_n(adc7_dq_n),
	.data(dq_data[7]),
	.data_valid(dq_data_valid[7]),
	.calib_data(calib_data[7])
);

xpm_cdc_single #(
	.DEST_SYNC_FF(4),
	.INIT_SYNC_FF(0),
	.SIM_ASSERT_CHK(0),
	.SRC_INPUT_REG(1)
) cdc_out_valid (
	.dest_out(out_valid_en),
	.dest_clk(aclk),
	.src_clk(s_axi_aclk),
	.src_in(ctrl_out_valid)
);

dq_sync dq_sync_inst (
	.aclk(aclk),
	.aresetn(aresetn & ~adc_if_rst & ~esync),
	.valid_en(out_valid_en),
	.dq0_in(dq_data[0]),
	.dq0_in_valid(dq_data_valid[0]),
	.dq1_in(dq_data[1]),
	.dq1_in_valid(dq_data_valid[1]),
	.dq2_in(dq_data[2]),
	.dq2_in_valid(dq_data_valid[2]),
	.dq3_in(dq_data[3]),
	.dq3_in_valid(dq_data_valid[3]),
	.dq4_in(dq_data[4]),
	.dq4_in_valid(dq_data_valid[4]),
	.dq5_in(dq_data[5]),
	.dq5_in_valid(dq_data_valid[5]),
	.dq6_in(dq_data[6]),
	.dq6_in_valid(dq_data_valid[6]),
	.dq7_in(dq_data[7]),
	.dq7_in_valid(dq_data_valid[7]),
	.dq0_out(m0_axis_tdata),
	.dq0_out_valid(m0_axis_tvalid),
	.dq1_out(m1_axis_tdata),
	.dq1_out_valid(m1_axis_tvalid),
	.dq2_out(m2_axis_tdata),
	.dq2_out_valid(m2_axis_tvalid),
	.dq3_out(m3_axis_tdata),
	.dq3_out_valid(m3_axis_tvalid),
	.dq4_out(m4_axis_tdata),
	.dq4_out_valid(m4_axis_tvalid),
	.dq5_out(m5_axis_tdata),
	.dq5_out_valid(m5_axis_tvalid),
	.dq6_out(m6_axis_tdata),
	.dq6_out_valid(m6_axis_tvalid),
	.dq7_out(m7_axis_tdata),
	.dq7_out_valid(m7_axis_tvalid)
);

endmodule
