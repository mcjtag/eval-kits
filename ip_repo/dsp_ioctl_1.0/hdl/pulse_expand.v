`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 28.07.2017 09:07:46
// Design Name: 
// Module Name: pulse_expand
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

module pulse_expand # (
	parameter PULSE_WIDTH = 0
)
(
	input wire C,
	input wire I,
	output wire O
);

(* KEEP = "TRUE" *) reg [PULSE_WIDTH:0]pulse;
reg pulse_out;

genvar i;

assign O = pulse_out;

always @(posedge C) begin
	if (pulse) begin
		pulse_out <= 1'b1;
	end else begin
		pulse_out <= 1'b0;
	end
end

always @(posedge C) begin
	pulse[0] <= I;
end

generate
	for (i = 1; i <= PULSE_WIDTH; i = i + 1) begin : PULSE_EXPANDING
		always @(posedge C) begin
			pulse[i] <= pulse[i - 1];
		end
	end
endgenerate

endmodule
