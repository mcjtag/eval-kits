`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 12.04.2019 15:22:32
// Design Name: 
// Module Name: frame_fifo
// Project Name: eth_switch
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

module frame_fifo #(
	parameter PACKET_MODE = 0,
	parameter PACKET_MAXNUM = 32, // MAX
	parameter DATA_WIDTH = 8
)
(
	input wire aclk,
	input wire aresetn,
	input wire [DATA_WIDTH-1:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	input wire s_axis_tlast,
	output wire [DATA_WIDTH-1:0]m_axis_tdata,
	output wire [15:0]m_axis_tuser,
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	output wire m_axis_tlast
);

localparam FIFO_SIZE = "18Kb";

wire [DATA_WIDTH:0]fifo_di;
wire [DATA_WIDTH:0]fifo_do;
wire fifo_empty;
wire fifo_wren;
wire fifo_full;
wire fifo_rden;

reg [5:0]nrp;
wire ready;
wire valid;
wire pkt_in_last;
wire pkt_out_last;

assign fifo_di = {s_axis_tlast, s_axis_tdata};
assign m_axis_tdata = fifo_do[DATA_WIDTH-1:0];
assign m_axis_tlast = fifo_do[DATA_WIDTH];
assign s_axis_tready = ~fifo_full & ready;
assign m_axis_tvalid = ~fifo_empty & valid;
assign fifo_wren = s_axis_tvalid & s_axis_tready;
assign fifo_rden = m_axis_tvalid & m_axis_tready;

generate if (PACKET_MODE) begin
	assign pkt_in_last = (s_axis_tvalid == 1'b1) && (s_axis_tready == 1'b1) && (s_axis_tlast == 1'b1);
	assign pkt_out_last = (m_axis_tvalid == 1'b1) && (m_axis_tready == 1'b1) && (m_axis_tlast == 1'b1);
	assign ready = (nrp < PACKET_MAXNUM) ? 1'b1 : 1'b0;
	assign valid = (nrp > 0) ? 1'b1 : 1'b0;
end else begin
	assign pkt_in_last = 1'b0;
	assign pkt_out_last = 1'b0;
	assign ready = 1'b1;
	assign valid = 1'b1;
end endgenerate

generate if (PACKET_MODE) begin
	always @(posedge aclk) begin
		if (aresetn == 1'b0) begin
			nrp <= 0;
		end else begin
			case ({pkt_in_last,pkt_out_last})
			2'b01: begin
				if (nrp > 0) begin
					nrp <= nrp - 1;
				end
			end
			2'b10: begin
				if (nrp < PACKET_MAXNUM) begin
					nrp <= nrp + 1;
				end
			end
			default: begin
				nrp <= nrp;
			end
			endcase
		end
	end
end endgenerate

/* Length */
generate if (PACKET_MODE) begin
	
	localparam IND_WIDTH = $clog2(PACKET_MAXNUM);
	
	reg [15:0]length[PACKET_MAXNUM-1:0];
	reg [IND_WIDTH-1:0]r_ind;
	reg [IND_WIDTH-1:0]w_ind;
	assign m_axis_tuser = length[r_ind];
	integer i;

	always @(posedge aclk) begin
		if (aresetn == 1'b0) begin
			for (i = 0; i < 32; i = i + 1) begin
				length[i] <= 0;
			end
			r_ind <= 0;
			w_ind <= 0;
		end else begin
			if (pkt_in_last) begin
				if (w_ind == PACKET_MAXNUM - 1) begin
					w_ind <= 0;
				end else begin
					w_ind <= w_ind + 1;
				end
			end
			if (pkt_out_last) begin
				if (r_ind == PACKET_MAXNUM - 1) begin
					r_ind <= 0;
				end else begin
					r_ind <= r_ind + 1;
				end
				length[r_ind] <= 0;
			end
			if (fifo_wren == 1'b1) begin
				length[w_ind] <= length[w_ind] + 1;
			end
		end
	end
	

end else begin	
	assign m_axis_tuser = 0;
end endgenerate

FIFO_DUALCLOCK_MACRO #(
	.DEVICE("7SERIES"),
	.FIFO_SIZE(FIFO_SIZE),
	.DATA_WIDTH(DATA_WIDTH+1),
	.FIRST_WORD_FALL_THROUGH("TRUE"),
	.ALMOST_EMPTY_OFFSET(9'h080),
	.ALMOST_FULL_OFFSET(9'h080)
) FIFO_DUALCLOCK_MACRO_inst (
	.RST(~aresetn),
	.WRCLK(aclk),
	.WREN(fifo_wren),
	.DI(fifo_di),
	.FULL(fifo_full),
	.ALMOSTFULL(),
	.WRCOUNT(),
	.WRERR(),
	.RDCLK(aclk),
	.RDEN(fifo_rden),
	.DO(fifo_do),
	.EMPTY(fifo_empty),
	.ALMOSTEMPTY(),
	.RDCOUNT(),
	.RDERR()
);     

endmodule
