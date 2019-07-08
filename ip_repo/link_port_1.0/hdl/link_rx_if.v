`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 14.02.2018 13:06:43
// Design Name: 
// Module Name: link_rx_if
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

module link_rx_if #(
	parameter DATA_WIDTH = 4,
    parameter DELAY_CTRL_INST = 0,
    parameter BCMP_USE = 0,
    parameter DELAY_GROUP = "LINK_DELAYGROUP_DEFAULT"
)
(
	// Link Port IO PADs
	input wire lxclkinp,
	input wire lxclkinn,
	input wire [DATA_WIDTH-1:0]lxdatip,
	input wire [DATA_WIDTH-1:0]lxdatin,
	output wire lxacko,
	input wire lxbcmpi,
	// DELAY_CTRL Signals
	input wire delay_clk,
	output wire delay_rdy,
	// Fabric
	input wire rst,
	output wire clk,
	output wire [DATA_WIDTH-1:0]data,
	input wire ack,
	output wire bcmp
);

wire lxclk_b;
wire lxclk_d;
wire lxclk;

wire [DATA_WIDTH-1:0]lxdat_b;
wire [DATA_WIDTH-1:0]lxdat_d;
wire [DATA_WIDTH-1:0]lxdat;

genvar i;

assign data = lxdat_d;
assign clk = lxclk;

/* Clock */
IBUFGDS #(
	.IBUF_LOW_PWR("FALSE")
) IBUFGDS_LXCLK (
	.I(lxclkinp),
	.IB(lxclkinn),
	.O(lxclk_b)
);

(* IODELAY_GROUP = DELAY_GROUP *)
IDELAYE2 # (
	.CINVCTRL_SEL("FALSE"),
	.DELAY_SRC("IDATAIN"),
	.HIGH_PERFORMANCE_MODE("TRUE"),
	.IDELAY_TYPE("FIXED"),
	.IDELAY_VALUE(0),
	.REFCLK_FREQUENCY(200.0),
	.PIPE_SEL("FALSE"),
	.SIGNAL_PATTERN("CLOCK")
) IDELAYE2_LXCLK (
	.DATAOUT(lxclk_d),
	.DATAIN(1'b0),
	.C(1'b0),
	.CE(),
	.INC(),
	.IDATAIN(lxclk_b),
	.LD(1'b0),
	.REGRST(),
	.LDPIPEEN(1'b0),
	.CNTVALUEIN(5'b00000),
	.CNTVALUEOUT(),
	.CINVCTRL(1'b0)
);

BUFR #(
	.BUFR_DIVIDE("BYPASS"),
	.SIM_DEVICE("7SERIES")
) BUFR_LXCLK (
	.I(lxclk_d),
	.O(lxclk),
	.CE(1'b1),
	.CLR(1'b0)
);

/* DATA */
generate for (i = 0; i < DATA_WIDTH; i = i + 1) begin: LXDATA
    IBUFDS #(
        .IBUF_LOW_PWR("FALSE")
    ) IBUFDS_LXDAT (
        .I(lxdatip[i]),
        .IB(lxdatin[i]),
		.O(lxdat_b[i])
	);
	
	(* IODELAY_GROUP = DELAY_GROUP *)
    IDELAYE2 # (
	   .CINVCTRL_SEL("FALSE"),
	   .DELAY_SRC("IDATAIN"),
	   .HIGH_PERFORMANCE_MODE("TRUE"),
	   .IDELAY_TYPE("FIXED"),
	   .IDELAY_VALUE(0),
	   .REFCLK_FREQUENCY(200.0),
	   .PIPE_SEL("FALSE"),
	   .SIGNAL_PATTERN("DATA")
    ) IDELAYE2_LXDAT (
	   .DATAOUT(lxdat_d[i]),
	   .DATAIN(1'b0),
	   .C(1'b0),
	   .CE(),
	   .INC(),
	   .IDATAIN(lxdat_b[i]),
	   .LD(1'b0),
	   .REGRST(),
	   .LDPIPEEN(1'b0),
	   .CNTVALUEIN(5'b00000),
	   .CNTVALUEOUT(),
	   .CINVCTRL(1'b0)
    );
end endgenerate

/* ACK */
OBUF #(
    .DRIVE(12),
    .IOSTANDARD("DEFAULT"),
    .SLEW("SLOW")
) OBUF_ACK (
    .O(lxacko),
    .I(ack & delay_rdy)
);

/* BCMP */
generate if (BCMP_USE)
    IBUF #(
        .IBUF_LOW_PWR("TRUE"),
        .IOSTANDARD("DEFAULT")
    ) IBUF_BCMP (
        .O(bcmp),
        .I(lxbcmpi)
    );
else
    assign bcmp = 1'b1;
endgenerate

/* IDELAYCTRL Instance */
generate if (DELAY_CTRL_INST == 1)
	(* IODELAY_GROUP = DELAY_GROUP *)
	IDELAYCTRL IDELAYCTRL_inst (
		.RDY(delay_rdy),
		.REFCLK(delay_clk),
		.RST(rst)
	);
else
	assign delay_rdy = 1'b1;
endgenerate

endmodule
