`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 11.05.2018 11:43:43
// Design Name: 
// Module Name: syncron_v1_0
// Project Name: syncron
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

module syncron_v1_0 # (
	parameter integer C_S_AXI_DATA_WIDTH = 32,
	parameter integer C_S_AXI_ADDR_WIDTH = 5,
	
	parameter SYNC_CLK_WIDTH = 10,
	parameter SYNC_CAP_CDELAY = 0,
	parameter SYNC_CAP_CWIDTH = 300,
	parameter SYNC_CAP_DDC_DDELAY = 200,
	parameter SYNC_CAP_DDC_DWIDTH = 10,
	parameter SYNC_CAP_LNK_DDELAY = 10,
	parameter SYNC_CAP_LNK_DWIDTH = 10,
	parameter SYNC_LNK_CDELAY = 10,
	parameter SYNC_LNK_DDELAY = 10,
	parameter SYNC_LNK_CWIDTH = 10,
	parameter SYNC_LNK_DWIDTH = 10,
	parameter SYNC_RAW_DWIDTH = 10
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
//
	input wire syn_clk,
	input wire syn_clk_div,
	
	output wire gl_clk,
	output wire csync,
	output wire [3:0]dsync
);

wire ctrl_mux;
wire init_clk;
wire init_cap;
wire init_link;
wire init_raw;

wire ctrl_mux_s;
wire init_clk_s;
wire init_cap_s;
wire init_link_s;
wire init_raw_s;

wire clk_csync;
wire cap_csync;
wire [1:0]cap_dsync;
wire link_csync;
wire link_dsync;
wire raw_dsync;

wire clock_sync_init;
wire capture_sync_init;
wire link_sync_init;
wire raw_sync_init;

reg csync_b;
reg [3:0]dsync_b;

assign gl_clk = syn_clk_div;
assign csync = csync_b;
assign dsync = dsync_b;

assign clock_sync_init = init_clk_s;
assign capture_sync_init = ctrl_mux_s ? 1'b0 : init_cap_s;
assign link_sync_init = init_link_s;
assign raw_sync_init = init_raw_s;

always @(posedge syn_clk) begin
	csync_b <= clk_csync | cap_csync | link_csync;
	dsync_b <= {cap_dsync[0], cap_dsync[0], raw_dsync, link_dsync | cap_dsync[1]};
end

// Instantiation of Axi Bus Interface S_AXI
syncron_v1_0_S_AXI # ( 
	.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
) syncron_v1_0_S_AXI_inst (
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
	.ctrl_mux(ctrl_mux),
	.init_clk(init_clk),
	.init_cap(init_cap),
	.init_link(init_link),
	.init_raw(init_raw)
);

// clk
xpm_cdc_pulse #(
	.DEST_SYNC_FF(2),
	.RST_USED(0),
	.SIM_ASSERT_CHK(0)
) xpm_cdc_pulse_clk_inst (
	.src_clk(s_axi_aclk),
	.src_rst(),
	.src_pulse(init_clk),
	.dest_clk(syn_clk),
	.dest_rst(),
	.dest_pulse(init_clk_s)
);

// cap
xpm_cdc_pulse #(
	.DEST_SYNC_FF(2),
	.RST_USED(0),
	.SIM_ASSERT_CHK(0)
) xpm_cdc_pulse_cap_inst (
	.src_clk(s_axi_aclk),
	.src_rst(),
	.src_pulse(init_cap),
	.dest_clk(syn_clk),
	.dest_rst(),
	.dest_pulse(init_cap_s)
);

// link
xpm_cdc_pulse #(
	.DEST_SYNC_FF(2),
	.RST_USED(0),
	.SIM_ASSERT_CHK(0)
) xpm_cdc_pulse_lnk_inst (
	.src_clk(s_axi_aclk),
	.src_rst(),
	.src_pulse(init_link),
	.dest_clk(syn_clk),
	.dest_rst(),
	.dest_pulse(init_link_s)
);

// raw
xpm_cdc_pulse #(
	.DEST_SYNC_FF(2),
	.RST_USED(0),
	.SIM_ASSERT_CHK(0)
) xpm_cdc_pulse_raw_inst (
	.src_clk(s_axi_aclk),
	.src_rst(),
	.src_pulse(init_raw),
	.dest_clk(syn_clk),
	.dest_rst(),
	.dest_pulse(init_raw_s)
);

xpm_cdc_array_single #(
	.DEST_SYNC_FF(4),
	.SIM_ASSERT_CHK(0),
	.SRC_INPUT_REG(1),
	.WIDTH(1)
) xpm_cdc_array_single_inst (
	.src_clk(s_axi_aclk),
	.src_in(ctrl_mux),
	.dest_clk(syn_clk),
	.dest_out(ctrl_mux_s)
);

clock_sync # (
	.CSYNC_WIDTH(SYNC_CLK_WIDTH)
) clock_sync_inst (
	.clk(syn_clk),
	.init(clock_sync_init),
	.csync(clk_csync)
);

capture_sync # (
	.CSYNC_DELAY(SYNC_CAP_CDELAY),
	.DSYNC_DDC_DELAY(SYNC_CAP_DDC_DDELAY),
	.DSYNC_LNK_DELAY(SYNC_CAP_LNK_DDELAY),
	.CSYNC_WIDTH(SYNC_CAP_CWIDTH),
	.DSYNC_DDC_WIDTH(SYNC_CAP_DDC_DWIDTH),
	.DSYNC_LNK_WIDTH(SYNC_CAP_LNK_DWIDTH)
) capture_sync_inst (
	.clk(syn_clk),
	.init(capture_sync_init),
	.csync(cap_csync),
	.dsync(cap_dsync)
);

link_sync #(
	.CSYNC_DELAY(SYNC_LNK_CDELAY),
	.DSYNC_DELAY(SYNC_LNK_DDELAY),
	.CSYNC_WIDTH(SYNC_LNK_CWIDTH),
	.DSYNC_WIDTH(SYNC_LNK_DWIDTH)
) link_sync_inst (
	.clk(syn_clk),
	.init(link_sync_init),
	.csync(link_csync),
	.dsync(link_dsync)
);

raw_sync #(
	.DSYNC_WIDTH(SYNC_RAW_DWIDTH)
) raw_sync_inst (
	.clk(syn_clk),
	.init(raw_sync_init),
	.dsync(raw_dsync)
);

endmodule
