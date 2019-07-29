`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 23.01.2018 17:02:01
// Design Name: 
// Module Name: capture_sync
// Project Name: syncron
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

module capture_sync # (
	parameter CSYNC_DELAY = 10,
	parameter DSYNC_DDC_DELAY = 10,
	parameter DSYNC_LNK_DELAY = 10,
	parameter CSYNC_WIDTH = 10,
	parameter DSYNC_DDC_WIDTH = 10,
	parameter DSYNC_LNK_WIDTH = 10
)
(
	input wire clk,
	input wire init,
	output wire csync,
	output wire [1:0]dsync
);

wire csync_d;
wire [1:0]dsync_d;

pulse_delay # (
	.PULSE_DELAY(CSYNC_DELAY)
) pulse_delay_c (
	.C(clk),
	.I(init),
	.O(csync_d)
);

pulse_delay # (
	.PULSE_DELAY(DSYNC_DDC_DELAY)
) pulse_delay_d0 (
	.C(clk),
	.I(init),
	.O(dsync_d[0])
);

pulse_delay # (
	.PULSE_DELAY(DSYNC_LNK_DELAY)
) pulse_delay_d1 (
	.C(clk),
	.I(init),
	.O(dsync_d[1])
);

pulse_expand # (
	.PULSE_WIDTH(CSYNC_WIDTH)
) pulse_expand_c (
	.C(clk),
	.I(csync_d),
	.O(csync)
);

pulse_expand # (
	.PULSE_WIDTH(DSYNC_DDC_WIDTH)
) pulse_expand_d0 (
	.C(clk),
	.I(dsync_d[0]),
	.O(dsync[0])
);

pulse_expand # (
	.PULSE_WIDTH(DSYNC_LNK_WIDTH)
) pulse_expand_d1 (
	.C(clk),
	.I(dsync_d[1]),
	.O(dsync[1])
);

endmodule
