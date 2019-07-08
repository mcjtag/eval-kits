`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 09.04.2019 14:12:17
// Design Name: 
// Module Name: link_fifo
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

module link_fifo #(
	parameter DATA_WIDTH = 32
)
(
	input wire wr_rst,
	input wire wr_clk,
	input wire wr_en,
	input wire [DATA_WIDTH-1:0]wr_data,
	output wire wr_full,
	output wire wr_afull,

	input wire rd_clk,
	input wire rd_en,
    output wire [DATA_WIDTH-1:0]rd_data,
    output wire rd_empty,
    output wire rd_aempty
);

localparam DEPTH = 16;
localparam DC_WIDTH = 5;
localparam AEMPTY_THRE = 4;
localparam AFULL_THRE = 12;

wire [DC_WIDTH-1:0]wr_dc;
wire [DC_WIDTH-1:0]rd_dc;

assign wr_afull = (wr_dc < AFULL_THRE) ? 1'b0 : 1'b1;
assign rd_aempty = (rd_dc < AEMPTY_THRE) ? 1'b1 : 1'b0;

xpm_fifo_async #(
	.CDC_SYNC_STAGES(2),
	.DOUT_RESET_VALUE("0"),
	.ECC_MODE("no_ecc"),
	.FIFO_MEMORY_TYPE("distributed"),
	.FIFO_READ_LATENCY(0),
	.FIFO_WRITE_DEPTH(16),
	.FULL_RESET_VALUE(0),
	.PROG_EMPTY_THRESH(10),
	.PROG_FULL_THRESH(10),  
	.RD_DATA_COUNT_WIDTH(DC_WIDTH),
	.READ_DATA_WIDTH(DATA_WIDTH),
	.READ_MODE("fwft"),
	.RELATED_CLOCKS(1),
	.USE_ADV_FEATURES("0707"),
	.WAKEUP_TIME(0),
	.WRITE_DATA_WIDTH(DATA_WIDTH),
	.WR_DATA_COUNT_WIDTH(DC_WIDTH)
) xpm_fifo_async_inst (
	.almost_empty(),
	.almost_full(),
	.data_valid(),
	.dout(rd_data),
	.empty(rd_empty),
	.full(wr_full),
	.overflow(),
	.prog_empty(),
	.prog_full(),
	.rd_data_count(rd_dc),
	.rd_rst_busy(),
	.sbiterr(),
	.underflow(),
	.wr_ack(),
	.wr_data_count(wr_dc),
	.wr_rst_busy(),
	.din(wr_data),
	.injectdbiterr(),
	.injectsbiterr(),
	.rd_clk(rd_clk),
	.rd_en(rd_en & ~rd_empty),
	.rst(wr_rst),
	.sleep(0),
	.wr_clk(wr_clk),
	.wr_en(wr_en & ~wr_full)
);

endmodule
