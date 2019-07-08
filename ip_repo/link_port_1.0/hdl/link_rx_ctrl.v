`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 15.02.2018 12:09:55
// Design Name: 
// Module Name: link_rx_ctrl
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

module link_rx_ctrl #(
	parameter DATA_WIDTH = 4
)
(
	// Clocks and resets
	input wire clk,
	input wire lxclk_ref,
	input wire lxclk_rst,
	input wire lxclk_ref_div4,
	input wire lxclk_rst_div4,
	// Fabric (lxclk_ref)
	input wire [DATA_WIDTH*2-1:0]din,
	input wire din_valid,
	output wire ack,
	input wire bcmp,
	input wire bcmp_valid,
	// Fabric (clk)	
	output wire [31:0]dout,
	output wire dout_valid,
	input wire ready,
	output wire last   
);

reg [1:0]dw_cnt;
reg [1:0]qw_cnt;
reg [7:0]dw_data[2:0];
wire [31:0]dword;
wire dw_ready;
wire qw_ready;
reg [4:0]bcmp_cnt;
wire bcmp_det;

wire fifo_wren;
wire fifo_afull;
wire [32:0]fifo_in;
wire fifo_rden;
wire fifo_empty;
wire [32:0]fifo_out;

wire [33:0]fifo_div4_data;
wire fifo_div4_empty;

assign ack = ~fifo_afull;
assign dout = fifo_out[31:0];
assign dout_valid = ~fifo_empty;
assign last = fifo_out[32];

assign dw_ready = dw_cnt[1] & dw_cnt[0];
assign qw_ready = qw_cnt[1] & qw_cnt[0];
assign dword = {din, dw_data[0], dw_data[1], dw_data[2]};
assign bcmp_det = (bcmp_cnt >= 8) ? 1'b1 : 1'b0;

assign fifo_wren = ~fifo_div4_empty;
assign fifo_in = {fifo_div4_data[32],fifo_div4_data[31:0]};
assign fifo_rden = ready & dout_valid;

always @(posedge lxclk_ref or posedge lxclk_rst) begin
	if (lxclk_rst == 1'b1) begin
		dw_cnt <= 0;
		qw_cnt <= 0;
	end else begin
		if (din_valid == 1'b1) begin
			dw_cnt <= dw_cnt + 1;
		end
		if (dw_ready == 1'b1) begin
			qw_cnt <= qw_cnt + 1;
		end
	end
end

always @(posedge lxclk_ref or posedge lxclk_rst) begin
	if (lxclk_rst == 1'b1) begin
		dw_data[0] <= 0;
		dw_data[1] <= 0;
		dw_data[2] <= 0;
	end else begin
		if (din_valid == 1'b1) begin
			dw_data[0] <= din;
			dw_data[1] <= dw_data[0];
			dw_data[2] <= dw_data[1];
		end
	end
end

// BCMP Detection
always @(posedge lxclk_ref or posedge lxclk_rst) begin
    if (lxclk_rst == 1'b1) begin
        bcmp_cnt <= 0;
    end else begin
        if ((qw_ready & dw_ready) == 1'b1) begin
            bcmp_cnt <= 0;
        end else begin
            if (bcmp_valid == 1'b1) begin
                bcmp_cnt <= bcmp_cnt + !bcmp;
            end
        end
    end
end

link_fifo #(
	.DATA_WIDTH(33)
) link_fifo_rx_div4 (
	.wr_rst(lxclk_rst),
	.wr_clk(lxclk_ref),
	.wr_en(dw_ready),
	.wr_data({bcmp_det & qw_ready,dword}),
	.wr_full(),
	.wr_afull(),
	.rd_clk(lxclk_ref_div4),
	.rd_en(1'b1),
    .rd_data(fifo_div4_data),
    .rd_empty(fifo_div4_empty),
	.rd_aempty()
);

FIFO_DUALCLOCK_MACRO #(
	.ALMOST_FULL_OFFSET(13'h0080),
	.DATA_WIDTH(33),
	.DEVICE("7SERIES"),
	.FIFO_SIZE("18Kb"),
	.FIRST_WORD_FALL_THROUGH("TRUE")
) link_fifo_rx (
	.WRCLK(lxclk_ref_div4),
	.WREN(fifo_wren),
	.ALMOSTFULL(fifo_afull),
	.FULL(),
	.DI(fifo_in),
	.WRCOUNT(),
	.WRERR(),
	.RDCLK(clk),
	.RDEN(fifo_rden),
	.ALMOSTEMPTY(),
	.EMPTY(fifo_empty),
	.DO(fifo_out),
	.RDCOUNT(),
	.RDERR(),
	.RST(lxclk_rst_div4)
);

endmodule
