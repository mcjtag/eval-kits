`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 12.04.2019 16:19:40
// Design Name: 
// Module Name: axis_demux2
// Project Name: ulb
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

module axis_demux2 #(
	parameter DATA_WIDTH = 8
)
(
	input wire aresetn,
	input wire [DATA_WIDTH-1:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	input wire s_axis_tlast,
	
	output wire [DATA_WIDTH-1:0]m0_axis_tdata,
	output wire m0_axis_tvalid,
	input wire m0_axis_tready,
	output wire m0_axis_tlast,
	
	output wire [DATA_WIDTH-1:0]m1_axis_tdata,
	output wire m1_axis_tvalid,
	input wire m1_axis_tready,
	output wire m1_axis_tlast,
	
	input wire [1:0]select
);

reg tready;
reg [DATA_WIDTH-1:0]tdata[1:0];
reg [1:0]tvalid;
reg [1:0]tlast;

assign s_axis_tready = tready;
assign m0_axis_tdata = tdata[0];
assign m0_axis_tvalid = tvalid[0];
assign m0_axis_tlast = tlast[0];
assign m1_axis_tdata = tdata[1];
assign m1_axis_tvalid = tvalid[1];
assign m1_axis_tlast = tlast[1];

always @(*) begin
	if (aresetn == 1'b0) begin
		tready <= 1'b0;
		tdata[0] <= 0;
		tdata[1] <= 0;
		tvalid <= 2'b00;
		tlast <= 2'b00;
	end else begin
		case (select)
			2'b00: begin // none
				tready <= 1'b0;
				tvalid <= 2'b00;
			end
			2'b01: begin // m0
				tready <= m0_axis_tready;
				tdata[0] <= s_axis_tdata;
				tvalid <= {1'b0,s_axis_tvalid};
				tlast[0] <= s_axis_tlast;
			end
			2'b10: begin // m1
				tready <= m1_axis_tready;
				tdata[1] <= s_axis_tdata;
				tvalid <= {s_axis_tvalid,1'b0};
				tlast[1] <= s_axis_tlast;
			end
			2'b11: begin // m0 & m1 (broadcast)
				tready <= m0_axis_tready & m1_axis_tready;
				tdata[0] <= s_axis_tdata;
				tdata[1] <= s_axis_tdata;
				tvalid <= {s_axis_tvalid,s_axis_tvalid} & {tready,tready};
				tlast <= {2{s_axis_tlast}};
			end
		
		endcase
	end
end

endmodule
