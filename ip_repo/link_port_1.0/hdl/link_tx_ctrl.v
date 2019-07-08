`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 08.04.2019 12:06:21
// Design Name: 
// Module Name: link_tx_ctrl
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

module link_tx_ctrl #(
	parameter DATA_WIDTH = 4
)
(
	// Clocks and resets
	input wire rst,
	input wire clk,
	input wire lxclk_ref,
	input wire lxclk_ref_90,
	input wire lxclk_rst,
	input wire lxclk_ref_div4,
	input wire lxclk_rst_div4,
	// Fabric (lxclk_ref)
	output wire [DATA_WIDTH*2-1:0]dout,
	output wire [1:0]clkout,
	input wire ack,
	output wire bcmp,
	// Fabric (clk)	
	input wire [31:0]din,
	input wire din_valid,
	output wire ready,
	input wire last
);

reg [1:0]dw_cnt;
reg [31:0]dword[3:0];
reg [3:0]dw_valid;
reg dw_last;
reg dw_last_err;

wire fifo_div4_wren;
wire fifo_div4_full;
wire [32:0]fifo_div4_din;
wire fifo_div4_rden;
wire fifo_div4_empty;
wire [32:0]fifo_div4_dout;

wire [32:0]fifo_div1_din;
wire fifo_div1_wren;
wire fifo_div1_full;
wire fifo_div1_rden;
wire [32:0]fifo_div1_dout;
wire fifo_div1_aempty;
reg [3:0]b_cnt;
reg tx_valid;
reg [DATA_WIDTH*2-1:0]rdata_out;

assign ready = ~fifo_div4_full;
assign fifo_div4_wren = dw_valid[3] & ready;
assign fifo_div4_din = {dw_last,dword[3]};

assign fifo_div4_rden = ~fifo_div4_empty & ~fifo_div1_full;
assign fifo_div1_wren = ~fifo_div4_empty & ~fifo_div1_full;
assign fifo_div1_din = fifo_div4_dout;
assign fifo_div1_rden = (b_cnt[1:0] == 2'b11) ? 1'b1 : 1'b0;

assign dout = (tx_valid == 1'b1) ? rdata_out : 0;
assign clkout = (tx_valid == 1'b1) ? 2'b10 : 2'b00;
assign bcmp = (tx_valid == 1'b1) ? ~fifo_div1_dout[32] : 1'b1;

/* Last signal expanding */
always @(posedge clk) begin
	if (rst == 1'b1) begin
		dw_cnt <= 0;
		dword[0] <= 0;
		dword[1] <= 0;
		dword[2] <= 0;
		dword[3] <= 0;
		dw_valid <= 0;
		dw_last <= 0;
		dw_last_err <= 1'b0;
	end else begin
		if (ready == 1'b1) begin
			dword[0] <= din;
			dword[1] <= dword[0];
			dword[2] <= dword[1];
			dword[3] <= dword[2];
			dw_valid[0] <= din_valid;
			dw_valid[3:1] <= dw_valid[2:0];
			if (din_valid == 1'b1) begin
				dw_cnt <= dw_cnt + 1;
				if (dw_cnt == 2'b11) begin
					dw_last <= last;
				end else begin
					dw_last_err <= last;
				end
			end
		end
	end
end

/* Tx Control */
always @(posedge lxclk_ref or posedge lxclk_rst) begin
	if (lxclk_rst == 1'b1) begin
		b_cnt <= 0;
		tx_valid <= 0;
	end else begin
		if (tx_valid == 1'b1) begin
			b_cnt <= b_cnt + 1;
			if (b_cnt == 4'b1111) begin
				tx_valid <= 1'b0;
			end
		end	else begin
			if (ack == 1'b1) begin
				if (fifo_div1_aempty == 1'b0) begin
					tx_valid <= 1'b1;
				end
			end
		end
	end
end

always @(*) begin
	case (b_cnt[1:0])
		2'b00: rdata_out <= fifo_div1_dout[DATA_WIDTH*2*(1+0)-1:DATA_WIDTH*2*0];
		2'b01: rdata_out <= fifo_div1_dout[DATA_WIDTH*2*(1+1)-1:DATA_WIDTH*2*1];
		2'b10: rdata_out <= fifo_div1_dout[DATA_WIDTH*2*(1+2)-1:DATA_WIDTH*2*2];
		2'b11: rdata_out <= fifo_div1_dout[DATA_WIDTH*2*(1+3)-1:DATA_WIDTH*2*3];
	endcase
end

FIFO_DUALCLOCK_MACRO #(
	.ALMOST_FULL_OFFSET(9'h077),
	.DATA_WIDTH(33),
	.DEVICE("7SERIES"),
	.FIFO_SIZE("18Kb"),
	.FIRST_WORD_FALL_THROUGH("TRUE")
) link_fifo_tx_div4 (
	.WRCLK(clk),
	.WREN(fifo_div4_wren),
	.ALMOSTFULL(fifo_div4_full),
	.FULL(),
	.DI(fifo_div4_din),
	.WRCOUNT(),
	.WRERR(),
	.RDCLK(lxclk_ref_div4),
	.RDEN(fifo_div4_rden),
	.ALMOSTEMPTY(),
	.EMPTY(fifo_div4_empty),
	.DO(fifo_div4_dout),
	.RDCOUNT(),
	.RDERR(),
	.RST(lxclk_rst_div4)
);

link_fifo #(
	.DATA_WIDTH(33)
) link_fifo_tx_div1 (
	.wr_rst(lxclk_rst_div4),
	.wr_clk(lxclk_ref_div4),
	.wr_en(fifo_div1_wren),
	.wr_data(fifo_div1_din),
	.wr_full(fifo_div1_full),
	.wr_afull(),
	.rd_clk(lxclk_ref),
	.rd_en(fifo_div1_rden),
    .rd_data(fifo_div1_dout),
    .rd_empty(),
    .rd_aempty(fifo_div1_aempty)
);

endmodule
