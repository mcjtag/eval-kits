`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 26.04.2019 16:59:13
// Design Name: 
// Module Name: iddr
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

module iddr # (
	parameter DATA_WIDTH = 1
)
(
	input wire clk,
	input wire [DATA_WIDTH-1:0]d,
	output wire [DATA_WIDTH-1:0]q1,
	output wire [DATA_WIDTH-1:0]q2
);

genvar i;

generate for (i = 0; i < DATA_WIDTH; i = i + 1) begin : IDDR
	IDDR #(
		.DDR_CLK_EDGE("SAME_EDGE_PIPELINED"),
		.SRTYPE("ASYNC")
	) iddr_inst (
		.Q1(q1[i]),
		.Q2(q2[i]),
		.C(clk),
		.CE(1'b1),
		.D(d[i]),
		.R(1'b0),
		.S(1'b0)
	);
end endgenerate

endmodule
