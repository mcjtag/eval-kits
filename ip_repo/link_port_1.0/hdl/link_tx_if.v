`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 08.04.2019 09:42:56
// Design Name: 
// Module Name: link_tx_if
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

module link_tx_if #(
	parameter DATA_WIDTH = 4,
    parameter BCMP_USE = 0
)
(
	// Link Port IO PADs
	output wire lxclkoutp,
	output wire lxclkoutn,
	output wire [DATA_WIDTH-1:0]lxdatop,
	output wire [DATA_WIDTH-1:0]lxdaton,
	input wire lxacki,
	output wire lxbcmpo,
	// Fabric
	input wire rst,
	input wire clk,
	input wire clk90,
	input wire [DATA_WIDTH*2-1:0]odata,
	input wire [1:0]oclk,
	output wire ack,
	input wire bcmp
);

wire [DATA_WIDTH-1:0]lxdat;
wire lxclk;
wire lxbcmp;
wire ack_b;
(* IOB = "TRUE" *) reg rack;

assign ack = rack;

genvar i;

/* DATA */
generate for (i = 0; i < DATA_WIDTH; i = i + 1) begin: DATA
	ODDR #(
		.DDR_CLK_EDGE("SAME_EDGE"),
		.INIT(1'b0),
		.SRTYPE("ASYNC")
	) ODDR_DATA (
		.Q(lxdat[i]),
		.C(clk),
		.CE(1'b1),
		.D1(odata[i]),
		.D2(odata[DATA_WIDTH+i]),
		.R(rst),
		.S(1'b0)
	);

	OBUFDS #(
		.IOSTANDARD("DEFAULT"),
		.SLEW("FAST")
	) OBUFDS_DATA (
		.O(lxdatop[i]),
		.OB(lxdaton[i]),
		.I(lxdat[i])
	);
end endgenerate

/* CLOCK */
ODDR #(
	.DDR_CLK_EDGE("SAME_EDGE"),
	.INIT(1'b0),
	.SRTYPE("ASYNC")
) ODDR_CLOCK (
	.Q(lxclk),
	.C(clk90),
	.CE(1'b1),
	.D1(oclk[0]),
	.D2(oclk[1]),
	.R(rst),
	.S(1'b0)
);

OBUFDS #(
	.IOSTANDARD("DEFAULT"),
	.SLEW("FAST")
) OBUFDS_CLOCK (
	.O(lxclkoutp),
	.OB(lxclkoutn),
	.I(lxclk)
);

/* BCMP */
generate if (BCMP_USE) begin
	ODDR #(
		.DDR_CLK_EDGE("SAME_EDGE"),
		.INIT(1'b0),
		.SRTYPE("ASYNC")
	) ODDR_BCMP (
		.Q(lxbcmp),
		.C(clk),
		.CE(1'b1),
		.D1(bcmp),
		.D2(bcmp),
		.R(rst),
		.S(1'b0)
	);

	OBUF #(
		.DRIVE(12),
		.IOSTANDARD("DEFAULT"),
		.SLEW("SLOW")
	) OBUF_BCMP (
		.O(lxbcmpo),
		.I(lxbcmp)
	);
end endgenerate

/* ACK */
IBUF #(
	.IBUF_LOW_PWR("FALSE"),
	.IOSTANDARD("DEFAULT")
) IBUF_ACK (
	.O(ack_b),
	.I(lxacki)
);

always @(posedge clk) begin
	rack <= ack_b;
end

endmodule
