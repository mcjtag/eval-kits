`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 23.01.2018 11:12:59
// Design Name: 
// Module Name: dsp_reset
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

module dsp_reset # (
	parameter CPU_NUM = 8
)
(
	input wire reset_all,
	input wire [CPU_NUM-1:0]reset,
	output wire resetn_all_tri,
	output wire [CPU_NUM-1:0]resetn_tri
);

genvar i;

OBUFT OBUFT_inst (
	.O(resetn_all_tri),
	.I(1'b0),
	.T(~reset_all)
);

generate for (i = 0; i < CPU_NUM; i = i + 1) begin : BUFT_OUTS
	OBUFT OBUFT_inst (
		.O(resetn_tri[i]),
		.I(1'b0),
		.T(~reset[i])
	);
end endgenerate

endmodule
