`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 13.08.2019 14:39:15
// Design Name: 
// Module Name: cdc
// Project Name: adc8_tcb
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
 
module cdc_data #
(
	parameter DATA_WIDTH = 8
)
(
	input wire src_clk,
	input wire [DATA_WIDTH-1:0]src_data,
	input wire dst_clk,
	output wire [DATA_WIDTH-1:0]dst_data
);

wire src_rcv;

xpm_cdc_handshake #(
    .DEST_EXT_HSK(0),
    .DEST_SYNC_FF(4),
    .SIM_ASSERT_CHK(0),
    .SRC_SYNC_FF(4),
    .WIDTH(DATA_WIDTH)
) xpm_cdc_handshake_inst (
    .src_clk(src_clk),
    .src_in(src_data),
    .src_send(~src_rcv),
    .src_rcv(src_rcv),
    .dest_clk(dst_clk),
    .dest_req(),
    .dest_ack(1'b0),
    .dest_out(dst_data)
); 
    
endmodule

module cdc_pulse #(
	parameter ACTIVE_LOW = 0,
	parameter ZERO_DELAY = "FALSE"
)
(
	input wire src_clk,
	input wire src_pulse,
	input wire dst_clk,
	output wire dst_pulse
);

wire fall;
wire rise;

edge_detect #(
	.ZERO_DELAY("FALSE")
) ed_inst (
	.CLK(src_clk),
	.SIG(src_pulse),
	.FALL(fall),
	.RISE(rise)
);

xpm_cdc_pulse #(
	.DEST_SYNC_FF(4),
	.INIT_SYNC_FF(0),
	.REG_OUTPUT(1),
	.RST_USED(0),
	.SIM_ASSERT_CHK(0)
) xpm_cdc_pulse_inst (
	.dest_pulse(dst_pulse),
	.dest_clk(dst_clk),
	.dest_rst(1'b0),
	.src_clk(src_clk),
	.src_pulse((ACTIVE_LOW) ? fall : rise),
	.src_rst(1'b0)
);

endmodule

module edge_detect #
(
	parameter ZERO_DELAY = "FALSE"
)
(
	input wire CLK,
	input wire SIG,
	output wire FALL,
	output wire RISE
);

reg [1:0]sig_ff;
reg fall_out;
reg rise_out;

assign FALL = fall_out;
assign RISE = rise_out;

always @(posedge CLK) begin
	sig_ff[0] <= SIG;
	sig_ff[1] <= sig_ff[0];
end

generate
	if (ZERO_DELAY == "FALSE") begin
		always @(posedge CLK) begin
			if (sig_ff[0] & ~sig_ff[1]) begin
				rise_out <= 1'b1;
			end else begin
				rise_out <= 1'b0;
			end
			if (~sig_ff[0] & sig_ff[1]) begin
				fall_out <= 1'b1;
			end else begin
				fall_out <= 1'b0;
			end
		end
	end else begin
		always @(SIG, sig_ff[0]) begin
			rise_out <= SIG & ~sig_ff[0];
			fall_out <= ~SIG & sig_ff[0];
		end
	end
endgenerate

endmodule
