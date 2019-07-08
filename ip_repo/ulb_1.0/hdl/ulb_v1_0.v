`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr 
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 27.06.2019 14:41:17
// Design Name: 
// Module Name: ulb_v1_0
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

module ulb_v1_0 #(
	parameter [47:0]LOCAL_MAC = 48'hFF_FF_FF_FF_FF_FE,
	parameter [31:0]GATEWAY_IP = 32'hC0_A8_00_01,
	parameter [31:0]SUBNET_MASK = 32'hFF_FF_FF_00,
	parameter [31:0]SOURCE_IP = 32'hC0_A8_00_0A,
	parameter [15:0]SOURCE_PORT = 1234,
	parameter [31:0]DEST_IP = 32'hC0_A8_00_0B,
	parameter [15:0]DEST_PORT = 1234,
	parameter CONFIG_ENABLE = 1
)
(
	/* UDP Clock & Reset */
	input wire axis_udp_aclk,
	input wire axis_udp_aresetn,
	/* UDP AXI4-Stream Config */
	output wire [143:0]m_axis_udp_config_tdata,
	output wire m_axis_udp_config_tvalid,
	/* UDP AXI4-Stream Rx Payload */
	output wire [7:0]m_axis_udp_tdata,
	output wire m_axis_udp_tvalid,
	input wire m_axis_udp_tready,
	output wire m_axis_udp_tlast,
	/* UDP AXI4-Stream Rx Header */
	output wire [79:0]m_axis_udp_hdr_tdata,
	output wire m_axis_udp_hdr_tvalid,
	input wire m_axis_udp_hdr_tready,
	/* UDP AXI4-Stream Tx Payload */
	input wire [7:0]s_axis_udp_tdata,
	input wire s_axis_udp_tvalid,
	output wire s_axis_udp_tready,
	input wire s_axis_udp_tlast,
	/* UDP AXI4-Stream Tx Header */
	input wire [111:0]s_axis_udp_hdr_tdata,
	input wire s_axis_udp_hdr_tvalid,
	output wire s_axis_udp_hdr_tready,
	/* Link Clock & Reset */
	input wire axis_link_aclk,
	input wire axis_link_aresetn,
	/* Link AXI4-Stream Rx */
	input wire [31:0]s_axis_link_tdata,
	input wire s_axis_link_tvalid,
	output wire s_axis_link_tready,
	input wire s_axis_link_tlast,
	/* Link AXI4-Stream Tx */
	output wire [31:0]m_axis_link_tdata,
	output wire m_axis_link_tvalid,
	input wire m_axis_link_tready,
	output wire m_axis_link_tlast
);

localparam FRAG_THRE = 1424;

wire [31:0]s_udp_ip_source_ip;
wire [31:0]s_udp_ip_dest_ip;
wire [15:0]s_udp_source_port;
wire [15:0]s_udp_dest_port;
wire [15:0]s_udp_length;

wire [31:0]m_udp_ip_dest_ip;
wire [15:0]m_udp_source_port;
wire [15:0]m_udp_dest_port;
wire [15:0]m_udp_length;

//assign m_axis_config_tdata = 0;
//assign m_axis_config_tvalid = 1'b0;

//assign m_axis_udp_tdata = s_axis_udp_tdata;
//assign m_axis_udp_tvalid = s_axis_udp_tvalid;
//assign m_axis_udp_tlast = s_axis_udp_tlast;
//assign s_axis_udp_tready = m_axis_udp_tready;

//assign m_axis_udp_hdr_tvalid = s_axis_udp_hdr_tvalid;
//assign s_axis_udp_hdr_tready = m_axis_udp_hdr_tready;

//assign {s_udp_length,s_udp_dest_port,s_udp_ip_dest_ip,s_udp_source_port,s_udp_ip_source_ip} = s_axis_udp_hdr_tdata;

//assign m_udp_source_port = s_udp_dest_port;
//assign m_udp_ip_dest_ip = s_udp_ip_source_ip;
//assign m_udp_dest_port = s_udp_source_port;
//assign m_udp_length = s_udp_length;

//assign m_axis_udp_hdr_tdata[15:0] = m_udp_source_port;
//assign m_axis_udp_hdr_tdata[47:16] = m_udp_ip_dest_ip;
//assign m_axis_udp_hdr_tdata[63:48] = m_udp_dest_port;
//assign m_axis_udp_hdr_tdata[79:64] = m_udp_length;

localparam STATE_STARTUP = 0;
localparam STATE_IDLE = 1;
localparam STATE_HEADER = 2;
localparam STATE_PAYLOAD = 3;

localparam MUX_NONE = 2'b00;
localparam MUX_M0 = 2'b01;
localparam MUX_M1 = 2'b10;

reg [1:0]u_state;
reg [1:0]l_state;

wire [15:0]m_ff_axis_tuser;
reg config_done;
reg [143:0]config_data;
reg config_tvalid;

reg [1:0]mux_select;

reg [15:0]frag_len;
wire frag_last;

wire [7:0]s_axis_link_w_tdata;
wire s_axis_link_w_tvalid;
wire s_axis_link_w_tready;
wire s_axis_link_w_tlast;

wire [7:0]m_axis_link_w_tdata;
wire m_axis_link_w_tvalid;
wire m_axis_link_w_tready;
wire m_axis_link_w_tlast;

assign m_axis_udp_config_tdata = config_data;
assign m_axis_udp_config_tvalid = config_tvalid;

assign {s_udp_length,s_udp_dest_port,s_udp_ip_dest_ip,s_udp_source_port,s_udp_ip_source_ip} = s_axis_udp_hdr_tdata;
assign s_axis_udp_hdr_tready = (u_state == STATE_HEADER) ? 1'b1 : 1'b0;
assign frag_last = (frag_len == (FRAG_THRE - 1)) ? 1'b1 : 1'b0;

assign m_axis_udp_hdr_tdata[15:0] = SOURCE_PORT;
assign m_axis_udp_hdr_tdata[47:16] = DEST_IP;
assign m_axis_udp_hdr_tdata[63:48] = DEST_PORT;
assign m_axis_udp_hdr_tdata[79:64] = m_ff_axis_tuser;

assign m_axis_udp_hdr_tvalid = (l_state == STATE_HEADER) ? 1'b1 : 1'b0;

/* Configuration FSM */
always @(posedge axis_udp_aclk) begin
	if (axis_udp_aresetn == 1'b0) begin
		config_done <= 1'b0;
		config_data <= 0;
		config_tvalid <= 1'b0;
	end else begin
		if (config_done == 1'b0) begin
			if (CONFIG_ENABLE) begin
				config_data <= {SUBNET_MASK, GATEWAY_IP, SOURCE_IP, LOCAL_MAC};
				config_tvalid <= 1'b1;
			end else begin
				config_done <= 1'b1;
			end
		end else begin
			config_data <= 0;
			config_tvalid <= 1'b0;
		end
	end
end

/* 'UDP >> Link' FSM */
always @(posedge axis_udp_aclk) begin
	if (axis_udp_aresetn == 1'b0) begin
		u_state <= STATE_STARTUP;
		mux_select <= MUX_NONE;
	end else begin
		case (u_state)
		STATE_STARTUP: begin
			if (config_done == 1'b1) begin
				u_state <= STATE_IDLE;
			end
		end
		STATE_IDLE: begin
			u_state <= STATE_HEADER;
		end
		STATE_HEADER: begin
			if (s_axis_udp_hdr_tvalid == 1'b1) begin
				if ((s_udp_ip_dest_ip == SOURCE_IP) && (s_udp_dest_port == SOURCE_PORT)) begin
					mux_select <= MUX_M1;
				end else begin
					mux_select <= MUX_M0;
				end
				u_state <= STATE_PAYLOAD;
			end
		end
		STATE_PAYLOAD: begin
			if ((s_axis_udp_tvalid == 1'b1) && (s_axis_udp_tready == 1'b1) && (s_axis_udp_tlast == 1'b1)) begin
				u_state <= STATE_HEADER;
				mux_select <= MUX_NONE;
			end
		end
		endcase
	end
end

/* Link Receive Fragmentation */
always @(posedge axis_udp_aclk) begin
	if (axis_udp_aresetn == 1'b0) begin
		frag_len <= 0;
	end else begin
		if ((s_axis_link_w_tvalid == 1'b1) && (s_axis_link_w_tready == 1'b1)) begin
			if (s_axis_link_w_tlast == 1'b1) begin
				frag_len <= 0;
			end else begin
				if (frag_len == (FRAG_THRE - 1)) begin
					frag_len <= 0;
				end else begin
					frag_len <= frag_len + 1;
				end
			end
		end
	end
end

/* 'Link >> UDP' FSM */
always @(posedge axis_udp_aclk) begin
	if (axis_udp_aresetn == 1'b0) begin
		l_state <= STATE_STARTUP;
	end else begin
		case (l_state)
		STATE_STARTUP: begin
			if (config_done == 1'b1) begin
				l_state <= STATE_IDLE;
			end
		end
		STATE_IDLE: begin
			if (m_axis_udp_tvalid == 1'b1) begin
				l_state <= STATE_HEADER;
			end
		end
		STATE_HEADER: begin
			if (m_axis_udp_hdr_tready == 1'b1) begin
				l_state <= STATE_PAYLOAD;
			end
		end
		STATE_PAYLOAD: begin
			if ((m_axis_udp_tvalid == 1'b1) && ((m_axis_udp_tready == 1'b1) && ((m_axis_udp_tlast == 1'b1)))) begin
				l_state <= STATE_IDLE;
			end
		end
		endcase
	end
end

/* Link Rx */
width_converter #(
	.BIG_ENDIAN(0),
	.WIDTH_IN(32),
	.WIDTH_OUT(8)
) width_converter_32_to_8 (
	.s_axis_aclk(axis_link_aclk),
	.s_axis_aresetn(axis_link_aresetn),
	.s_axis_tdata(s_axis_link_tdata),
	.s_axis_tvalid(s_axis_link_tvalid),
	.s_axis_tready(s_axis_link_tready),
	.s_axis_tlast(s_axis_link_tlast),
	.m_axis_aclk(axis_udp_aclk),
	.m_axis_tdata(s_axis_link_w_tdata),
	.m_axis_tvalid(s_axis_link_w_tvalid),
	.m_axis_tready(s_axis_link_w_tready),
	.m_axis_tlast(s_axis_link_w_tlast)
);

/* Link Rx FIFO */
frame_fifo #(
	.PACKET_MODE(1),
	.PACKET_MAXNUM(32),
	.DATA_WIDTH(8)
) frame_fifo_inst (
	.aclk(axis_udp_aclk),
	.aresetn(axis_udp_aresetn),
	.s_axis_tdata(s_axis_link_w_tdata),
	.s_axis_tvalid(s_axis_link_w_tvalid),
	.s_axis_tready(s_axis_link_w_tready),
	.s_axis_tlast(s_axis_link_w_tlast | frag_last),
	.m_axis_tdata(m_axis_udp_tdata),
	.m_axis_tuser(m_ff_axis_tuser),
	.m_axis_tvalid(m_axis_udp_tvalid),
	.m_axis_tready(m_axis_udp_tready),
	.m_axis_tlast(m_axis_udp_tlast)
);

/* UDP Rx Stream Switch */
axis_demux2 #(
	.DATA_WIDTH(8)
) axis_demux2_inst (
	.aresetn(axis_udp_aresetn),
	.s_axis_tdata(s_axis_udp_tdata),
	.s_axis_tvalid(s_axis_udp_tvalid),
	.s_axis_tready(s_axis_udp_tready),
	.s_axis_tlast(s_axis_udp_tlast),
	.m0_axis_tdata(),
	.m0_axis_tvalid(),
	.m0_axis_tready(1'b1),
	.m0_axis_tlast(),
	.m1_axis_tdata(m_axis_link_w_tdata),
	.m1_axis_tvalid(m_axis_link_w_tvalid),
	.m1_axis_tready(m_axis_link_w_tready),
	.m1_axis_tlast(m_axis_link_w_tlast),
	.select(mux_select)
);

/* Link Tx */
width_converter #(
	.BIG_ENDIAN(0),
	.WIDTH_IN(8),
	.WIDTH_OUT(32)
) width_converter_8_to_32 (
	.s_axis_aclk(axis_udp_aclk),
	.s_axis_aresetn(axis_udp_aresetn),
	.s_axis_tdata(m_axis_link_w_tdata),
	.s_axis_tvalid(m_axis_link_w_tvalid),
	.s_axis_tready(m_axis_link_w_tready),
	.s_axis_tlast(m_axis_link_w_tlast),
	.m_axis_aclk(axis_link_aclk),
	.m_axis_tdata(m_axis_link_tdata),
	.m_axis_tvalid(m_axis_link_tvalid),
	.m_axis_tready(m_axis_link_tready),
	.m_axis_tlast(m_axis_link_tlast)
);

endmodule
