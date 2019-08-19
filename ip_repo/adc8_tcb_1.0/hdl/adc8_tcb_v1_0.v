`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 13.08.2019 11:30:35
// Design Name: 
// Module Name: adc8_tcb_v1_0
// Project Name: adc8_tcb
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
	
module adc8_tcb_v1_0 # (
	parameter integer C_S_AXI_DATA_WIDTH = 32,
	parameter integer C_S_AXI_ADDR_WIDTH = 6,
	parameter FIFO_DEPTH = 2**15
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
	/* AXIS Clock and Resetn */
	input wire aclk,
	input wire aresetn,
	/* S_AXIS Interface */
	input wire [15:0]s0_axis_tdata,
	input wire s0_axis_tvalid,
	input wire [15:0]s1_axis_tdata,
	input wire s1_axis_tvalid,
	input wire [15:0]s2_axis_tdata,
	input wire s2_axis_tvalid,
	input wire [15:0]s3_axis_tdata,
	input wire s3_axis_tvalid,
	input wire [15:0]s4_axis_tdata,
	input wire s4_axis_tvalid,
	input wire [15:0]s5_axis_tdata,
	input wire s5_axis_tvalid,
	input wire [15:0]s6_axis_tdata,
	input wire s6_axis_tvalid,
	input wire [15:0]s7_axis_tdata,
	input wire s7_axis_tvalid,
	/* M_AXIS Interface */
	output wire [31:0]m0_axis_tdata,
	output wire m0_axis_tvalid,
	input wire m0_axis_tready,
	output wire m0_axis_tlast,
	output wire [31:0]m1_axis_tdata,
	output wire m1_axis_tvalid,
	input wire m1_axis_tready,
	output wire m1_axis_tlast,
	output wire [31:0]m2_axis_tdata,
	output wire m2_axis_tvalid,
	input wire m2_axis_tready,
	output wire m2_axis_tlast,
	output wire [31:0]m3_axis_tdata,
	output wire m3_axis_tvalid,
	input wire m3_axis_tready,
	output wire m3_axis_tlast,
	output wire [31:0]m4_axis_tdata,
	output wire m4_axis_tvalid,
	input wire m4_axis_tready,
	output wire m4_axis_tlast,
	output wire [31:0]m5_axis_tdata,
	output wire m5_axis_tvalid,
	input wire m5_axis_tready,
	output wire m5_axis_tlast,
	output wire [31:0]m6_axis_tdata,
	output wire m6_axis_tvalid,
	input wire m6_axis_tready,
	output wire m6_axis_tlast,
	output wire [31:0]m7_axis_tdata,
	output wire m7_axis_tvalid,
	input wire m7_axis_tready,
	output wire m7_axis_tlast
);

wire [15:0]s_axis_tdata[7:0];
wire [7:0]s_axis_tvalid;

wire [31:0]m_axis_tdata[7:0];
wire [7:0]m_axis_tvalid;
wire [7:0]m_axis_tready;
wire [7:0]m_axis_tlast;

wire format_bypass;

wire [15:0]ctrl_tcb_length;
wire [31:0]ctrl_tcb_norm;
wire [31:0]ctrl_tcb_offt;
wire ctrl_tcb_start;
wire ctrl_tcb_format;

wire [31:0]norm_data;
wire [31:0]offt_data;
wire [15:0]tcb_length;
wire tcb_start;

wire [15:0]tcb_data[7:0];
wire [7:0]tcb_valid;
wire [7:0]tcb_ready;
wire [7:0]tcb_last;

genvar i;

assign s_axis_tdata[0] = s0_axis_tdata;
assign s_axis_tdata[1] = s1_axis_tdata;
assign s_axis_tdata[2] = s2_axis_tdata;
assign s_axis_tdata[3] = s3_axis_tdata;
assign s_axis_tdata[4] = s4_axis_tdata;
assign s_axis_tdata[5] = s5_axis_tdata;
assign s_axis_tdata[6] = s6_axis_tdata;
assign s_axis_tdata[7] = s7_axis_tdata;

assign s_axis_tvalid[0] = s0_axis_tvalid;
assign s_axis_tvalid[1] = s1_axis_tvalid;
assign s_axis_tvalid[2] = s2_axis_tvalid;
assign s_axis_tvalid[3] = s3_axis_tvalid;
assign s_axis_tvalid[4] = s4_axis_tvalid;
assign s_axis_tvalid[5] = s5_axis_tvalid;
assign s_axis_tvalid[6] = s6_axis_tvalid;
assign s_axis_tvalid[7] = s7_axis_tvalid;

assign m0_axis_tdata = m_axis_tdata[0];
assign m0_axis_tvalid = m_axis_tvalid[0];
assign m0_axis_tlast = m_axis_tlast[0];
assign m1_axis_tdata = m_axis_tdata[1];
assign m1_axis_tvalid = m_axis_tvalid[1];
assign m1_axis_tlast = m_axis_tlast[1];
assign m2_axis_tdata = m_axis_tdata[2];
assign m2_axis_tvalid = m_axis_tvalid[2];
assign m2_axis_tlast = m_axis_tlast[2];
assign m3_axis_tdata = m_axis_tdata[3];
assign m3_axis_tvalid = m_axis_tvalid[3];
assign m3_axis_tlast = m_axis_tlast[3];
assign m4_axis_tdata = m_axis_tdata[4];
assign m4_axis_tvalid = m_axis_tvalid[4];
assign m4_axis_tlast = m_axis_tlast[4];
assign m5_axis_tdata = m_axis_tdata[5];
assign m5_axis_tvalid = m_axis_tvalid[5];
assign m5_axis_tlast = m_axis_tlast[5];
assign m6_axis_tdata = m_axis_tdata[6];
assign m6_axis_tvalid = m_axis_tvalid[6];
assign m6_axis_tlast = m_axis_tlast[6];
assign m7_axis_tdata = m_axis_tdata[7];
assign m7_axis_tvalid = m_axis_tvalid[7];
assign m7_axis_tlast = m_axis_tlast[7];

assign m_axis_tready[0] = m0_axis_tready;
assign m_axis_tready[1] = m1_axis_tready;
assign m_axis_tready[2] = m2_axis_tready;
assign m_axis_tready[3] = m3_axis_tready;
assign m_axis_tready[4] = m4_axis_tready;
assign m_axis_tready[5] = m5_axis_tready;
assign m_axis_tready[6] = m6_axis_tready;
assign m_axis_tready[7] = m7_axis_tready;

adc8_tcb_v1_0_S_AXI # ( 
	.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
) adc8_tcb_v1_0_S_AXI_inst (
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
	.tcb_length(ctrl_tcb_length),
	.tcb_norm(ctrl_tcb_norm),
	.tcb_offt(ctrl_tcb_offt),
	.tcb_start(ctrl_tcb_start),
	.tcb_format(ctrl_tcb_format)
);

cdc_data #(
	.DATA_WIDTH(16)
) cdc_length (
	.src_clk(s_axi_aclk),
	.src_data(ctrl_tcb_length),
	.dst_clk(aclk),
	.dst_data(tcb_length)
);

cdc_data #(
	.DATA_WIDTH(32)
) cdc_norm (
	.src_clk(s_axi_aclk),
	.src_data(ctrl_tcb_norm),
	.dst_clk(aclk),
	.dst_data(norm_data)
);

cdc_data #(
	.DATA_WIDTH(32)
) cdc_offt (
	.src_clk(s_axi_aclk),
	.src_data(ctrl_tcb_offt),
	.dst_clk(aclk),
	.dst_data(offt_data)
);

cdc_data #(
	.DATA_WIDTH(1)
) cdc_format (
	.src_clk(s_axi_aclk),
	.src_data(ctrl_tcb_format),
	.dst_clk(aclk),
	.dst_data(format_bypass)
);

cdc_pulse #(
	.ACTIVE_LOW(0),
	.ZERO_DELAY("FALSE")
) cdc_start (
	.src_clk(s_axi_aclk),
	.src_pulse(ctrl_tcb_start),
	.dst_clk(aclk),
	.dst_pulse(tcb_start)
);

generate for (i = 0; i < 8; i = i + 1) begin : TCB
	tcb #(
		.FIFO_DEPTH(FIFO_DEPTH)
	) tcb_inst (
		.aclk(aclk),
		.aresetn(aresetn),
		.s_axis_tdata(s_axis_tdata[i]),
		.s_axis_tvalid(s_axis_tvalid[i]),
		.m_axis_tdata(tcb_data[i]),
		.m_axis_tvalid(tcb_valid[i]),
		.m_axis_tready(tcb_ready[i]),
		.m_axis_tlast(tcb_last[i]),
		.tcb_length(tcb_length),
		.tcb_start(tcb_start)
	);
	converter conv_inst (
		.aclk(aclk),
		.bypass(format_bypass),
		.s_axis_norm_tdata(norm_data),
		.s_axis_offt_tdata(offt_data),
		.s_axis_tdata(tcb_data[i]),
		.s_axis_tvalid(tcb_valid[i]),
		.s_axis_tready(tcb_ready[i]),
		.s_axis_tlast(tcb_last[i]),
		.m_axis_tdata(m_axis_tdata[i]),
		.m_axis_tvalid(m_axis_tvalid[i]),
		.m_axis_tready(m_axis_tready[i]),
		.m_axis_tlast(m_axis_tlast[i])
	);
end endgenerate


endmodule
