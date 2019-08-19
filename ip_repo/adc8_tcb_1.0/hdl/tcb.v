`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 13.08.2019 10:13:59
// Design Name: 
// Module Name: tcb
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
 
module tcb #(
	parameter FIFO_DEPTH = 2**15
)
(
	input wire aclk,
	input wire aresetn,
	input wire [15:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire [15:0]m_axis_tdata,
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	output wire m_axis_tlast,
	input wire [15:0]tcb_length,
	input wire tcb_start
);

localparam STATE_IDLE = 0;
localparam STATE_ACTIVE = 1;

reg [1:0]state;
reg [15:0]length;

reg in_valid;
wire in_ready;
reg in_last;

always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		state <= STATE_IDLE;
		in_valid <= 1'b0;
		in_last <= 1'b0;
	end else begin
		case (state)
			STATE_IDLE: begin
				if ((tcb_start == 1'b1) && (tcb_length != 0)) begin
					in_valid <= 1'b0;
					length <= tcb_length;
					state <= STATE_ACTIVE;
				end
			end
			STATE_ACTIVE: begin
				case (length)
				0: begin
					in_valid <= 1'b0;
					in_last <= 1'b0;
					state <= STATE_IDLE;
				end
				1: begin
					if (s_axis_tvalid == 1'b1) begin
						in_valid <= 1'b1;
						in_last <= 1'b1;
						length <= length - 1;
					end
				end
				default: begin
					if (s_axis_tvalid == 1'b1) begin
						in_valid <= 1'b1;
						length <= length - 1;
					end
				end
				endcase
			end
		endcase
	end
end

tcb_fifo #(
	.DATA_WIDTH(16),
	.DATA_DEPTH(FIFO_DEPTH)
) fifo (
	.aclk(aclk),
	.aresetn(aresetn),
	.s_axis_tdata(s_axis_tdata),
	.s_axis_tvalid(in_valid & s_axis_tvalid),
	.s_axis_tready(in_ready),
	.s_axis_tlast(in_last),
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tvalid(m_axis_tvalid),
	.m_axis_tready(m_axis_tready),
	.m_axis_tlast(m_axis_tlast)
);

endmodule

module tcb_fifo #(
	parameter DATA_WIDTH = 16,
	parameter DATA_DEPTH = 2**15
)
(
	input wire aclk,
	input wire aresetn,
	input wire [DATA_WIDTH-1:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	input wire s_axis_tlast,
	output wire [DATA_WIDTH-1:0]m_axis_tdata,
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	output wire m_axis_tlast
);

xpm_fifo_axis #(
	.CDC_SYNC_STAGES(2),
	.CLOCKING_MODE("common_clock"),
	.ECC_MODE("no_ecc"),
	.FIFO_DEPTH(DATA_DEPTH),
	.FIFO_MEMORY_TYPE("auto"),
	.PACKET_FIFO("true"),
	.PROG_EMPTY_THRESH(10),
	.PROG_FULL_THRESH(10),
	.RD_DATA_COUNT_WIDTH(1),
	.RELATED_CLOCKS(0),
	.TDATA_WIDTH(DATA_WIDTH),
	.TDEST_WIDTH(1),
	.TID_WIDTH(1),
	.TUSER_WIDTH(1),
	.USE_ADV_FEATURES("0000"),
	.WR_DATA_COUNT_WIDTH(1)
)
xpm_fifo_axis_inst (
	.almost_empty_axis(),
	.almost_full_axis(),
	.dbiterr_axis(),
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tdest(),
	.m_axis_tid(),
	.m_axis_tkeep(),
	.m_axis_tlast(m_axis_tlast),
	.m_axis_tstrb(),
	.m_axis_tuser(),
	.m_axis_tvalid(m_axis_tvalid),
	.prog_empty_axis(),
	.prog_full_axis(),
	.rd_data_count_axis(),
	.s_axis_tready(s_axis_tready),
	.sbiterr_axis(),
	.wr_data_count_axis(),
	.injectdbiterr_axis(),
	.injectsbiterr_axis(),
	.m_aclk(aclk),
	.m_axis_tready(m_axis_tready),
	.s_aclk(aclk),
	.s_aresetn(aresetn),
	.s_axis_tdata(s_axis_tdata),
	.s_axis_tdest(),
	.s_axis_tid(),
	.s_axis_tkeep(),
	.s_axis_tlast(s_axis_tlast),
	.s_axis_tstrb(),
	.s_axis_tuser(),
	.s_axis_tvalid(s_axis_tvalid)
);

endmodule
