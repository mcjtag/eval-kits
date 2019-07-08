`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 08.04.2019 11:13:38
// Design Name: 
// Module Name: link_tx
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

module link_tx #(
	parameter DATA_WIDTH = 4,
	parameter BCMP_USE = 0
)
(
	// LINK IO Port
	output wire lxclkoutp,
	output wire lxclkoutn,
	output wire [DATA_WIDTH-1:0]lxdatop,
	output wire [DATA_WIDTH-1:0]lxdaton,
	output wire lxacki,
	input wire lxbcmpo,
	// LINK Reference clocks and resets
	input wire lxclk_rst,
	input wire lxclk_ref,
	input wire lxclk_ref_90,
	input wire lxclk_rst_div4,
	input wire lxclk_ref_div4,
	// AXI4-Stream Slave
	input wire aclk,
	input wire aresetn,
	input wire [31:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	input wire s_axis_tlast	
);

wire [DATA_WIDTH*2-1:0]if_odata;
wire [1:0]if_oclk;
wire if_ack;
wire if_bcmp;

link_tx_if #(
	.DATA_WIDTH(DATA_WIDTH),
    .BCMP_USE(BCMP_USE)
) link_tx_if_inst (
	.lxclkoutp(lxclkoutp),
	.lxclkoutn(lxclkoutn),
	.lxdatop(lxdatop),
	.lxdaton(lxdaton),
	.lxacki(lxacki),
	.lxbcmpo(lxbcmpo),

	.rst(lxclk_rst),
	.clk(lxclk_ref),
	.clk90(lxclk_ref_90),
	.odata(if_odata),
	.oclk(if_oclk),
	.ack(if_ack),
	.bcmp(if_bcmp)
);

link_tx_ctrl #(
	.DATA_WIDTH(DATA_WIDTH)
) link_tx_ctrl_inst (
	.rst(~aresetn),
	.clk(aclk),
	.lxclk_ref(lxclk_ref),
	.lxclk_ref_90(lxclk_ref_90),
	.lxclk_rst(lxclk_rst),
	.lxclk_ref_div4(lxclk_ref_div4),
	.lxclk_rst_div4(lxclk_rst_div4),
	.dout(if_odata),
	.clkout(if_oclk),
	.ack(if_ack),
	.bcmp(if_bcmp),
	.din(s_axis_tdata),
	.din_valid(s_axis_tvalid),
	.ready(s_axis_tready),
	.last(s_axis_tlast)
);

endmodule
