`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 04.04.2019 15:30:26
// Design Name: 
// Module Name: link_rx
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

module link_rx #(
    parameter DATA_WIDTH = 4,
    parameter DELAY_CTRL_INST = 0,
    parameter BCMP_USE = 0,
    parameter DELAY_GROUP = "LINK_DELAYGROUP_DEFAULT"
)
(
	// LINK Port IO
	input wire lxclkinp,
	input wire lxclkinn,
	input wire [DATA_WIDTH-1:0]lxdatip,
	input wire [DATA_WIDTH-1:0]lxdatin,
	output wire lxacko,
	input wire lxbcmpi,
	// LINK Reference clocks and resets
	input wire lxclk_rst,
	input wire lxclk_ref,
	input wire lxclk_rst_div4,
	input wire lxclk_ref_div4,
	// DELAY_CTRL Reference Clock
	input wire delay_clk,
	// AXI4-Stream Master
	input wire aclk,
	input wire aresetn,
	output wire [31:0]m_axis_tdata,
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	output wire m_axis_tlast
);

wire delay_rdy;

wire [DATA_WIDTH-1:0]if_data;
wire if_clk;
wire if_ack;
wire if_bcmp;

wire if_cdc_data_valid;
wire [DATA_WIDTH*2-1:0]if_cdc_data;
wire if_cdc_bcmp;
wire if_cdc_bcmp_valid;

link_rx_if #(
	.DATA_WIDTH(DATA_WIDTH),
    .DELAY_CTRL_INST(DELAY_CTRL_INST),
    .BCMP_USE(BCMP_USE),
    .DELAY_GROUP(DELAY_GROUP)
) link_rx_if_inst (
    .lxclkinp(lxclkinp),
	.lxclkinn(lxclkinn),
	.lxdatip(lxdatip),
	.lxdatin(lxdatin),
	.lxacko(lxacko),
	.lxbcmpi(lxbcmpi),
    .delay_clk(delay_clk),
	.delay_rdy(delay_rdy),
    .rst(lxclk_rst),
    .clk(if_clk),
	.data(if_data),
	.ack(if_ack),
	.bcmp(if_bcmp)
);

link_cdc #(
    .DATA_WIDTH(DATA_WIDTH),
    .DDR_ENABLE(1),
    .DATA_DEPTH(16)	// 16 bytes in qword
) link_rx_cdc_if_data (
    .src_rst(lxclk_rst),
    .src_clk(if_clk),
    .src_we(1'b1),
    .src_data(if_data),
    .src_recv(),
    .dst_rst(lxclk_rst),
    .dst_clk(lxclk_ref),
    .dst_re(1'b1),
    .dst_data(if_cdc_data),
    .dst_valid(if_cdc_data_valid),
    .dst_recv(1'b0)
);

link_cdc #(
    .DATA_WIDTH(1),
    .DDR_ENABLE(0),
    .DATA_DEPTH(16) // 16 bytes in qword
) link_rx_cdc_if_bcmp (
    .src_rst(lxclk_rst),
    .src_clk(if_clk),
    .src_we(1'b1),
    .src_data(if_bcmp),
    .src_recv(),
    .dst_rst(lxclk_rst),
    .dst_clk(lxclk_ref),
    .dst_re(1'b1),
    .dst_data(if_cdc_bcmp),
    .dst_valid(if_cdc_bcmp_valid),
    .dst_recv(1'b0)
);

link_rx_ctrl #(
    .DATA_WIDTH(DATA_WIDTH)
) link_rx_ctrl_inst (
	.clk(aclk),
	.lxclk_ref(lxclk_ref),
	.lxclk_rst(lxclk_rst),
	.lxclk_ref_div4(lxclk_ref_div4),
	.lxclk_rst_div4(lxclk_rst_div4),
    .din(if_cdc_data),
	.din_valid(if_cdc_data_valid),
	.ack(if_ack),
	.bcmp(if_cdc_bcmp),
	.bcmp_valid(if_cdc_bcmp_valid),
	.dout(m_axis_tdata),
	.dout_valid(m_axis_tvalid),
	.ready(m_axis_tready),
	.last(m_axis_tlast)   
);

endmodule
