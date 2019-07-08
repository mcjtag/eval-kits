`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 05.04.2019 15:57:21
// Design Name: 
// Module Name: link_port_v1_0
// Project Name: link_port
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

module link_port_v1_0 #(
    parameter LINK_RX_INST = 1,
    parameter LINK_TX_INST = 1,
	parameter DELAY_CTRL_INST = 0,
	parameter BCMP_RX_USE = 0,
	parameter BCMP_TX_USE = 0,
	parameter DELAY_GROUP  = "LINK_DELAYGROUP_DEFAULT"
)
(
	/* Common */
	// Link Reference clock
	input wire lxclk_ref,
	input wire lxclk_ref_div4,
	// AXI4-Stream
	input wire aclk,
	input wire aresetn,
	/* Receiver */
	// Link Port IO
	input wire lxclkinp,
	input wire lxclkinn,
	input wire [3:0]lxdatip,
	input wire [3:0]lxdatin,
	output wire lxacko,
	input wire lxbcmpi,
	// DELAY_CTRL Reference Clock
	input wire delay_clk,
	// AXI4-Stream Master
	output wire [31:0]m_axis_tdata,
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	output wire m_axis_tlast,
	/* Transmitter */
	// Link Port IO
	output wire lxclkoutp,
	output wire lxclkoutn,
	output wire [3:0]lxdatop,
	output wire [3:0]lxdaton,
	input wire lxacki,
	output wire lxbcmpo,
	// Link Reference clock (-90deg)
	input wire lxclk_ref_90,
	// AXI4-Stream Slave
	input wire [31:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	input wire s_axis_tlast
);

wire lxclk_rst;
wire lxclk_rst_div4;

/* Receiver */
generate if (LINK_RX_INST) begin : LINK_RX_GEN
    link_rx #(
        .DATA_WIDTH(4),
        .DELAY_CTRL_INST(DELAY_CTRL_INST),
        .BCMP_USE(BCMP_RX_USE),
        .DELAY_GROUP(DELAY_GROUP)
    ) link_rx_inst (
		.lxclkinp(lxclkinp),
		.lxclkinn(lxclkinn),
		.lxdatip(lxdatip),
		.lxdatin(lxdatin),
		.lxacko(lxacko),
		.lxbcmpi(lxbcmpi),
		.lxclk_rst(lxclk_rst),
		.lxclk_ref(lxclk_ref),
		.lxclk_rst_div4(lxclk_rst_div4),
		.lxclk_ref_div4(lxclk_ref_div4),
		.delay_clk(delay_clk),
		.aclk(aclk),
		.aresetn(aresetn),
		.m_axis_tdata(m_axis_tdata),
		.m_axis_tvalid(m_axis_tvalid),
		.m_axis_tready(m_axis_tready),
		.m_axis_tlast(m_axis_tlast)
    );
end endgenerate

/* Transmitter */
generate if (LINK_TX_INST) begin: LINK_TX_GEN
	link_tx #(
		.DATA_WIDTH(4),
		.BCMP_USE(BCMP_TX_USE)
	) link_tx_inst (
		.lxclkoutp(lxclkoutp),
		.lxclkoutn(lxclkoutn),
		.lxdatop(lxdatop),
		.lxdaton(lxdaton),
		.lxacki(lxacki),
		.lxbcmpo(lxbcmpo),
		.lxclk_rst(lxclk_rst),
		.lxclk_ref(lxclk_ref),
		.lxclk_ref_90(lxclk_ref_90),
		.lxclk_rst_div4(lxclk_rst_div4),
		.lxclk_ref_div4(lxclk_ref_div4),
		.aclk(aclk),
		.aresetn(aresetn),
		.s_axis_tdata(s_axis_tdata),
		.s_axis_tvalid(s_axis_tvalid),
		.s_axis_tready(s_axis_tready),
		.s_axis_tlast(s_axis_tlast)	
);
end endgenerate

/* Resets */
generate if (LINK_RX_INST || LINK_TX_INST) begin: LINK_RST_GEN
	link_rst link_rst_inst(
		.rst(~aresetn),
		.lxclk_ref(lxclk_ref),
		.lxclk_ref_div4(lxclk_ref_div4),
		.lxclk_rst(lxclk_rst),
		.lxclk_rst_div4(lxclk_rst_div4)
	);
end endgenerate

endmodule
