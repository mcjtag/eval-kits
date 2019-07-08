`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 10.04.2019 16:12:56
// Design Name: 
// Module Name: link_rst
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

module link_rst (
	input wire rst,
	input wire lxclk_ref,
	input wire lxclk_ref_div4,
	output wire lxclk_rst,
	output wire lxclk_rst_div4
);

xpm_cdc_async_rst #(
	.DEST_SYNC_FF(4),
	.RST_ACTIVE_HIGH(1)
) lxclk_rst_inst (
	.src_arst(rst),
	.dest_clk(lxclk_ref),
	.dest_arst(lxclk_rst)
);

xpm_cdc_async_rst #(
	.DEST_SYNC_FF(4),
	.RST_ACTIVE_HIGH(1)
) lxclk_rst_div4_inst (
	.src_arst(rst),
	.dest_clk(lxclk_ref_div4),
	.dest_arst(lxclk_rst_div4)
);

endmodule
