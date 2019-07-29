`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 24.01.2018 09:37:06
// Design Name: 
// Module Name: dsp_ioctl_v1_0
// Project Name: dsp_ioctl
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

module dsp_ioctl_v1_0 # (
	parameter integer C_S_AXI_DATA_WIDTH = 32,
	parameter integer C_S_AXI_ADDR_WIDTH = 7,
	parameter IRQ_WIDTH = 10,
	parameter DSP_COUNT = 2
)
(
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
// DSP IO
	output wire [DSP_COUNT-1:0]dsp_resetn,
	output wire dsp_resetn_all,
	output wire [DSP_COUNT-1:0]dsp_irq0,
	output wire [DSP_COUNT-1:0]dsp_irq1,
	output wire [DSP_COUNT-1:0]dsp_dmar0,
	output wire [DSP_COUNT-1:0]dsp_dmar1,
	output wire [DSP_COUNT-1:0]dsp_ddca,
	output wire [DSP_COUNT-1:0]dsp_ddcb,
// Sync
	input wire [3:0]sync // {DDCB, DDCA, DMAR1, DMAR0}
);

wire ctrl_rsta;
wire [7:0]ctrl_rst;
wire [7:0]ctrl_irq0;
wire [7:0]ctrl_irq1;

wire [DSP_COUNT-1:0]irq0_e;
wire [DSP_COUNT-1:0]irq1_e;

reg [DSP_COUNT-1:0]irq0_b;
reg [DSP_COUNT-1:0]irq1_b;

genvar i;

assign dsp_irq0 = irq0_b;
assign dsp_irq1 = irq1_b;
assign dsp_dmar0 = {DSP_COUNT{~sync[0]}};
assign dsp_dmar1 = {DSP_COUNT{~sync[1]}};
assign dsp_ddca = {DSP_COUNT{sync[2]}};
assign dsp_ddcb = {DSP_COUNT{sync[3]}};

always @(posedge s_axi_aclk) begin
	irq0_b <= ~irq0_e;
	irq1_b <= ~irq1_e;
end

// Instantiation of Axi Bus Interface S_AXI
dsp_ioctl_v1_0_S_AXI # ( 
	.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
) dsp_ioctl_v1_0_S_AXI_inst (
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
	.ctrl_rsta(ctrl_rsta),
	.ctrl_rst(ctrl_rst),
	.ctrl_irq0(ctrl_irq0),
	.ctrl_irq1(ctrl_irq1)
);

dsp_reset dsp_reset_inst (
	.reset_all(ctrl_rsta),
	.reset(ctrl_rst),
	.resetn_all_tri(dsp_resetn_all),
	.resetn_tri(dsp_resetn)
);

generate for (i = 0; i < DSP_COUNT; i = i + 1) begin : IRQ_EXPAND
	pulse_expand # (
		.PULSE_WIDTH(IRQ_WIDTH)
	) pulse_expand_irq0 (
		.C(s_axi_aclk),
		.I(ctrl_irq0[i]),
		.O(irq0_e[i])
	);
	
	pulse_expand # (
		.PULSE_WIDTH(IRQ_WIDTH)
	) pulse_expand_irq1 (
		.C(s_axi_aclk),
		.I(ctrl_irq1[i]),
		.O(irq1_e[i])
	);
end endgenerate

endmodule
