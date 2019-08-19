`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 13.08.2019 12:43:25
// Design Name: 
// Module Name: converter
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

module converter (
	input wire aclk,
	input wire bypass,
	input wire [31:0]s_axis_norm_tdata,
	input wire [31:0]s_axis_offt_tdata,
	input wire [15:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	input wire s_axis_tlast,
	output wire [31:0]m_axis_tdata,
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	output wire m_axis_tlast
);

wire data_valid;
wire data_ready;
wire [31:0]data_data;
wire data_last;

wire mula_valid;
wire mula_ready;
wire [31:0]mula_data;
wire mula_last;

wire s_axis_tready_tmp;

assign m_axis_tdata = (bypass) ? {{16{1'b0}},s_axis_tdata} : mula_data;
assign m_axis_tvalid = (bypass) ? s_axis_tvalid : mula_valid;
assign m_axis_tlast = (bypass) ? s_axis_tlast : mula_last;
assign mula_ready = (bypass) ? 1'b0: m_axis_tready;
assign s_axis_tready = (bypass) ? m_axis_tready : s_axis_tready_tmp;

fp_fix2float fix2float_data (
	.aclk(aclk),
	.s_axis_a_tvalid(s_axis_tvalid),
	.s_axis_a_tready(s_axis_tready_tmp),
	.s_axis_a_tdata({{16{1'b0}}, s_axis_tdata}),
	.s_axis_a_tlast(s_axis_tlast),
	.m_axis_result_tvalid(data_valid),
	.m_axis_result_tready(data_ready),
	.m_axis_result_tdata(data_data),
	.m_axis_result_tlast(data_last)
);

fp_mula your_instance_name (
	.aclk(aclk),
	.s_axis_a_tvalid(data_valid),
	.s_axis_a_tready(data_ready),
	.s_axis_a_tdata(data_data),
	.s_axis_a_tlast(data_last),
	.s_axis_b_tvalid(1'b1),
	.s_axis_b_tready(),
	.s_axis_b_tdata(s_axis_norm_tdata),
	.s_axis_b_tlast(1'b0),
	.s_axis_c_tvalid(1'b1),
	.s_axis_c_tready(),
	.s_axis_c_tdata(s_axis_offt_tdata),
	.s_axis_c_tlast(1'b0),
	.m_axis_result_tvalid(mula_valid),
	.m_axis_result_tready(mula_ready),
	.m_axis_result_tdata(mula_data),
	.m_axis_result_tlast(mula_last)
);

endmodule
