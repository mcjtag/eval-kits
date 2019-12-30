`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 12.12.2019 09:43:49
// Design Name: 
// Module Name: blk_fifo
// Project Name: usb_bridge
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

module blk_fifo #(
	parameter CLOCK_MODE = "ASYNC",
	parameter FIFO_PACKET = 0,
	parameter FIFO_DEPTH = 1024,
	parameter DATA_WIDTH = 8,
	parameter PROG_FULL_THRESHOLD = 64
)
(
	input wire s_aclk,
	input wire s_aresetn,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	input wire [7:0]s_axis_tdata,
	input wire s_axis_tlast,
	input wire m_aclk,
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	output wire [7:0]m_axis_tdata,
	output wire m_axis_tlast,
	output wire axis_prog_full
);

localparam CLOCKING_MODE = (CLOCK_MODE == "ASYNC") ? "independent_clock" : "common_clock";
localparam PACKET_FIFO = (FIFO_PACKET == 0) ? "false" : "true";
localparam USE_ADV_FEATURES = (PROG_FULL_THRESHOLD != 0)? "1002" : "1000";

xpm_fifo_axis #(
	.CDC_SYNC_STAGES(2),
	.CLOCKING_MODE(CLOCKING_MODE),
	.ECC_MODE("no_ecc"),
	.FIFO_DEPTH(FIFO_DEPTH),
	.FIFO_MEMORY_TYPE("auto"),
	.PACKET_FIFO(PACKET_FIFO),
	.PROG_EMPTY_THRESH(10),
	.PROG_FULL_THRESH(PROG_FULL_THRESHOLD),
	.RD_DATA_COUNT_WIDTH(1),
	.RELATED_CLOCKS(0),
	.TDATA_WIDTH(DATA_WIDTH),
	.TDEST_WIDTH(1),
	.TID_WIDTH(1),
	.TUSER_WIDTH(1),
	.USE_ADV_FEATURES(USE_ADV_FEATURES),
	.WR_DATA_COUNT_WIDTH(1)
) xpm_fifo_axis_inst (
	.almost_empty_axis(),
	.almost_full_axis(),
	.dbiterr_axis(),
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tdest(),
	.m_axis_tid(),
	.m_axis_tkeep(),
	.m_axis_tlast(m_axis_tlast),
	.m_axis_tstrb(),
	.m_axis_tuser(),
	.m_axis_tvalid(m_axis_tvalid),
	.prog_empty_axis(),
	.prog_full_axis(axis_prog_full),
	.rd_data_count_axis(),
	.s_axis_tready(s_axis_tready),
	.sbiterr_axis(),
	.wr_data_count_axis(),
	.injectdbiterr_axis(),
	.injectsbiterr_axis(),
	.m_aclk(m_aclk),
	.m_axis_tready(m_axis_tready),
	.s_aclk(s_aclk),
	.s_aresetn(s_aresetn),
	.s_axis_tdata(s_axis_tdata),
	.s_axis_tdest(),
	.s_axis_tid(),
	.s_axis_tkeep(),
	.s_axis_tlast(s_axis_tlast),
	.s_axis_tstrb(),
	.s_axis_tuser(),
	.s_axis_tvalid(s_axis_tvalid)
);

endmodule
