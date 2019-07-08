`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 26.04.2019 16:56:29
// Design Name: 
// Module Name: oddr
// Project Name: eth_mac
// Target Devices: 7-series
// Tool Versions: 2018.3
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//  Based on project 'https://github.com/alexforencich/verilog-ethernet'
// License: MIT
//  Copyright (c) 2016-2018 Alex Forencich
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

module oddr #(
	parameter DATA_WIDTH = 1
)
(
	input wire clk,
	input wire [DATA_WIDTH-1:0]d1,
	input wire [DATA_WIDTH-1:0]d2,
	output wire [DATA_WIDTH-1:0]q
);

genvar i;

generate for (i = 0; i < DATA_WIDTH; i = i + 1) begin : ODDR
	ODDR #(
		.DDR_CLK_EDGE("SAME_EDGE"),
		.SRTYPE("ASYNC")
	) oddr_inst (
		.Q(q[i]),
		.C(clk),
		.CE(1'b1),
		.D1(d1[i]),
		.D2(d2[i]),
		.R(1'b0),
		.S(1'b0)
	);
end endgenerate

endmodule
