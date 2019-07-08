`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 29.04.2019 15:43:07
// Design Name: 
// Module Name: eth_udp_v1_0
// Project Name: eth_udp
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

module eth_udp_v1_0 #(
	parameter [47:0]LOCAL_MAC = 48'hFF_FF_FF_FF_FF_FE,
	parameter [31:0]LOCAL_IP = 32'hC0_A8_00_0A,
	parameter [31:0]GATEWAY_IP = 32'hC0_A8_00_01,
	parameter [31:0]SUBNET_MASK = 32'hFF_FF_FF_00
)
(
	/* AXI4-Stream Interface */
	input wire aclk,
	input wire aresetn,
	/* AXI4-Stream MAC */
	input wire [7:0]s_axis_mac_tdata,
	input wire s_axis_mac_tvalid,
	output wire s_axis_mac_tready,
	input wire s_axis_mac_tlast,
	output wire [7:0]m_axis_mac_tdata,
	output wire m_axis_mac_tvalid,
	input wire m_axis_mac_tready,
	output wire m_axis_mac_tlast,
	/* AXI4-Stream Config */
	input wire [143:0]s_axis_config_tdata,
	input wire s_axis_config_tvalid,
	/* AXI4-Stream Rx Payload */
	input wire [7:0]s_axis_udp_tdata,
	input wire s_axis_udp_tvalid,
	output wire s_axis_udp_tready,
	input wire s_axis_udp_tlast,
	/* AXI4-Stream Rx Header */
	input wire [79:0]s_axis_udp_hdr_tdata,
	input wire s_axis_udp_hdr_tvalid,
	output wire s_axis_udp_hdr_tready,
	/* AXI4-Stream Tx Payload */
	output wire [7:0]m_axis_udp_tdata,
	output wire m_axis_udp_tvalid,
	input wire m_axis_udp_tready,
	output wire m_axis_udp_tlast,
	/* AXI4-Stream Tx Header */
	output wire [111:0]m_axis_udp_hdr_tdata,
	output wire m_axis_udp_hdr_tvalid,
	input wire m_axis_udp_hdr_tready
);

localparam ARP_CACHE_ADDR_WIDTH = 9;
localparam ARP_REQUEST_RETRY_COUNT = 4;
localparam ARP_REQUEST_RETRY_INTERVAL = 125000000*2;
localparam ARP_REQUEST_TIMEOUT = 125000000*30;
localparam UDP_CHECKSUM_GEN_ENABLE = 1;
localparam UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH = 11;
localparam UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH = 3;

wire m_eth_hdr_valid;
wire m_eth_hdr_ready;
wire [47:0]m_eth_dest_mac;
wire [47:0]m_eth_src_mac;
wire [15:0]m_eth_type;
wire [7:0]m_eth_payload_axis_tdata;
wire m_eth_payload_axis_tvalid;
wire m_eth_payload_axis_tready;
wire m_eth_payload_axis_tlast;
wire m_eth_payload_axis_tuser;

wire s_eth_hdr_valid;
wire s_eth_hdr_ready;
wire [47:0]s_eth_dest_mac;
wire [47:0]s_eth_src_mac;
wire [15:0]s_eth_type;
wire [7:0]s_eth_payload_axis_tdata;
wire s_eth_payload_axis_tvalid;
wire s_eth_payload_axis_tready;
wire s_eth_payload_axis_tlast;
wire s_eth_payload_axis_tuser;

wire s_udp_hdr_valid;
wire s_udp_hdr_ready;
wire [5:0]s_udp_ip_dscp;
wire [1:0]s_udp_ip_ecn;
wire [7:0]s_udp_ip_ttl;
wire [31:0]s_udp_ip_source_ip;
wire [31:0]s_udp_ip_dest_ip;
wire [15:0]s_udp_source_port;
wire [15:0]s_udp_dest_port;
wire [15:0]s_udp_length;
wire [15:0]s_udp_checksum;

wire [7:0]s_udp_payload_axis_tdata;
wire s_udp_payload_axis_tvalid;
wire s_udp_payload_axis_tready;
wire s_udp_payload_axis_tlast;
wire s_udp_payload_axis_tuser;

wire m_udp_hdr_valid;
wire m_udp_hdr_ready;

wire [31:0]m_udp_ip_source_ip;
wire [31:0]m_udp_ip_dest_ip;
wire [15:0]m_udp_source_port;
wire [15:0]m_udp_dest_port;
wire [15:0]m_udp_length;

wire [7:0]m_udp_payload_axis_tdata;
wire m_udp_payload_axis_tvalid;
wire m_udp_payload_axis_tready;
wire m_udp_payload_axis_tlast;
wire m_udp_payload_axis_tuser;

reg [47:0]local_mac;
reg [31:0]local_ip;
reg [31:0]gateway_ip;
reg [31:0]subnet_mask;

assign s_udp_ip_dscp = 0;
assign s_udp_ip_ecn = 0;
assign s_udp_ip_ttl = 64;
assign s_udp_ip_source_ip = local_ip;
assign s_udp_checksum = 0;

assign s_udp_payload_axis_tdata = s_axis_udp_tdata;
assign s_udp_payload_axis_tvalid = s_axis_udp_tvalid;
assign s_axis_udp_tready = s_udp_payload_axis_tready;
assign s_udp_payload_axis_tlast = s_axis_udp_tlast;
assign s_udp_payload_axis_tuser = 0;

assign s_udp_hdr_valid = s_axis_udp_hdr_tvalid;
assign s_axis_udp_hdr_tready = s_udp_hdr_ready;
assign s_udp_source_port = s_axis_udp_hdr_tdata[15:0];
assign s_udp_ip_dest_ip = s_axis_udp_hdr_tdata[47:16];
assign s_udp_dest_port = s_axis_udp_hdr_tdata[63:48];
assign s_udp_length = s_axis_udp_hdr_tdata[79:64];

assign m_axis_udp_tdata = m_udp_payload_axis_tdata;
assign m_axis_udp_tvalid = m_udp_payload_axis_tvalid;
assign m_udp_payload_axis_tready = m_axis_udp_tready;
assign m_axis_udp_tlast = m_udp_payload_axis_tlast;

assign m_axis_udp_hdr_tdata = {m_udp_length,m_udp_dest_port,m_udp_ip_dest_ip,m_udp_source_port,m_udp_ip_source_ip};
assign m_axis_udp_hdr_tvalid = m_udp_hdr_valid;
assign m_udp_hdr_ready = m_axis_udp_hdr_tready;

/* Dynamic configuration */
always @(posedge aclk) begin
	if (aresetn == 1'b0) begin
		local_mac <= LOCAL_MAC;
		local_ip <= LOCAL_IP;
		gateway_ip <= GATEWAY_IP;
		subnet_mask <= SUBNET_MASK;
	end else begin
		if (s_axis_config_tvalid == 1'b1) begin
			local_mac <= s_axis_config_tdata[47:0];
			local_ip <= s_axis_config_tdata[79:48];
			gateway_ip <= s_axis_config_tdata[111:80];
			subnet_mask <= s_axis_config_tdata[143:112];
		end
	end
end

eth_axis_rx eth_axis_rx_inst (
	.clk(aclk),
	.rst(~aresetn),
	.s_axis_tdata(s_axis_mac_tdata),
	.s_axis_tvalid(s_axis_mac_tvalid),
	.s_axis_tready(s_axis_mac_tready),
	.s_axis_tlast(s_axis_mac_tlast),
	.s_axis_tuser(1'b0),
	.m_eth_hdr_valid(m_eth_hdr_valid),
    .m_eth_hdr_ready(m_eth_hdr_ready),
    .m_eth_dest_mac(m_eth_dest_mac),
    .m_eth_src_mac(m_eth_src_mac),
    .m_eth_type(m_eth_type),
    .m_eth_payload_axis_tdata(m_eth_payload_axis_tdata),
    .m_eth_payload_axis_tvalid(m_eth_payload_axis_tvalid),
    .m_eth_payload_axis_tready(m_eth_payload_axis_tready),
    .m_eth_payload_axis_tlast(m_eth_payload_axis_tlast),
    .m_eth_payload_axis_tuser(m_eth_payload_axis_tuser),
	.busy(),
	.error_header_early_termination()
);

eth_axis_tx eth_axis_tx_inst (
	.clk(aclk),
	.rst(~aresetn),
	.s_eth_hdr_valid(s_eth_hdr_valid),
    .s_eth_hdr_ready(s_eth_hdr_ready),
    .s_eth_dest_mac(s_eth_dest_mac),
    .s_eth_src_mac(s_eth_src_mac),
    .s_eth_type(s_eth_type),
    .s_eth_payload_axis_tdata(s_eth_payload_axis_tdata),
    .s_eth_payload_axis_tvalid(s_eth_payload_axis_tvalid),
    .s_eth_payload_axis_tready(s_eth_payload_axis_tready),
    .s_eth_payload_axis_tlast(s_eth_payload_axis_tlast),
    .s_eth_payload_axis_tuser(s_eth_payload_axis_tuser),
	.m_axis_tdata(m_axis_mac_tdata),
    .m_axis_tvalid(m_axis_mac_tvalid),
    .m_axis_tready(m_axis_mac_tready),
    .m_axis_tlast(m_axis_mac_tlast),
    .m_axis_tuser(),
	.busy()
);

udp_complete #(
	.ARP_CACHE_ADDR_WIDTH(ARP_CACHE_ADDR_WIDTH),
	.ARP_REQUEST_RETRY_COUNT(ARP_REQUEST_RETRY_COUNT),
	.ARP_REQUEST_RETRY_INTERVAL(ARP_REQUEST_RETRY_INTERVAL),
	.ARP_REQUEST_TIMEOUT(ARP_REQUEST_TIMEOUT),
	.UDP_CHECKSUM_GEN_ENABLE(UDP_CHECKSUM_GEN_ENABLE),
	.UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH(UDP_CHECKSUM_PAYLOAD_FIFO_ADDR_WIDTH),
	.UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH(UDP_CHECKSUM_HEADER_FIFO_ADDR_WIDTH)
) udp_complete_inst (
	.clk(aclk),
	.rst(~aresetn),
	.s_eth_hdr_valid(m_eth_hdr_valid),
	.s_eth_hdr_ready(m_eth_hdr_ready),
	.s_eth_dest_mac(m_eth_dest_mac),
	.s_eth_src_mac(m_eth_src_mac),
	.s_eth_type(m_eth_type),
	.s_eth_payload_axis_tdata(m_eth_payload_axis_tdata),
	.s_eth_payload_axis_tvalid(m_eth_payload_axis_tvalid),
	.s_eth_payload_axis_tready(m_eth_payload_axis_tready),
	.s_eth_payload_axis_tlast(m_eth_payload_axis_tlast),
	.s_eth_payload_axis_tuser(m_eth_payload_axis_tuser),
	.m_eth_hdr_valid(s_eth_hdr_valid),
	.m_eth_hdr_ready(s_eth_hdr_ready),
	.m_eth_dest_mac(s_eth_dest_mac),
	.m_eth_src_mac(s_eth_src_mac),
	.m_eth_type(s_eth_type),
	.m_eth_payload_axis_tdata(s_eth_payload_axis_tdata),
	.m_eth_payload_axis_tvalid(s_eth_payload_axis_tvalid),
	.m_eth_payload_axis_tready(s_eth_payload_axis_tready),
	.m_eth_payload_axis_tlast(s_eth_payload_axis_tlast),
	.m_eth_payload_axis_tuser(s_eth_payload_axis_tuser),
	.s_ip_hdr_valid(0),
	.s_ip_hdr_ready(),
	.s_ip_dscp(0),
	.s_ip_ecn(0),
	.s_ip_length(0),
	.s_ip_ttl(0),
	.s_ip_protocol(0),
	.s_ip_source_ip(0),
	.s_ip_dest_ip(0),
	.s_ip_payload_axis_tdata(0),
	.s_ip_payload_axis_tvalid(0),
	.s_ip_payload_axis_tready(),
	.s_ip_payload_axis_tlast(0),
    .s_ip_payload_axis_tuser(0),
	.m_ip_hdr_valid(),
	.m_ip_hdr_ready(1),
	.m_ip_eth_dest_mac(),
	.m_ip_eth_src_mac(),
	.m_ip_eth_type(),
	.m_ip_version(),
	.m_ip_ihl(),
	.m_ip_dscp(),
	.m_ip_ecn(),
	.m_ip_length(),
	.m_ip_identification(),
	.m_ip_flags(),
	.m_ip_fragment_offset(),
	.m_ip_ttl(),
	.m_ip_protocol(),
	.m_ip_header_checksum(),
	.m_ip_source_ip(),
	.m_ip_dest_ip(),
	.m_ip_payload_axis_tdata(),
	.m_ip_payload_axis_tvalid(),
	.m_ip_payload_axis_tready(1),
	.m_ip_payload_axis_tlast(),
    .m_ip_payload_axis_tuser(),
	.s_udp_hdr_valid(s_udp_hdr_valid),
	.s_udp_hdr_ready(s_udp_hdr_ready),
	.s_udp_ip_dscp(s_udp_ip_dscp),
	.s_udp_ip_ecn(s_udp_ip_ecn),
	.s_udp_ip_ttl(s_udp_ip_ttl),
	.s_udp_ip_source_ip(s_udp_ip_source_ip),
    .s_udp_ip_dest_ip(s_udp_ip_dest_ip),
    .s_udp_source_port(s_udp_source_port),
    .s_udp_dest_port(s_udp_dest_port),
    .s_udp_length(s_udp_length),
    .s_udp_checksum(s_udp_checksum),
    .s_udp_payload_axis_tdata(s_udp_payload_axis_tdata),
    .s_udp_payload_axis_tvalid(s_udp_payload_axis_tvalid),
    .s_udp_payload_axis_tready(s_udp_payload_axis_tready),
    .s_udp_payload_axis_tlast(s_udp_payload_axis_tlast),
    .s_udp_payload_axis_tuser(s_udp_payload_axis_tuser),
	.m_udp_hdr_valid(m_udp_hdr_valid),
	.m_udp_hdr_ready(m_udp_hdr_ready),
	.m_udp_eth_dest_mac(),
	.m_udp_eth_src_mac(),
	.m_udp_eth_type(),
	.m_udp_ip_version(),
	.m_udp_ip_ihl(),
	.m_udp_ip_dscp(),
	.m_udp_ip_ecn(),
	.m_udp_ip_length(),
	.m_udp_ip_identification(),
	.m_udp_ip_flags(),
	.m_udp_ip_fragment_offset(),
	.m_udp_ip_ttl(),
	.m_udp_ip_protocol(),
	.m_udp_ip_header_checksum(),
	.m_udp_ip_source_ip(m_udp_ip_source_ip),
	.m_udp_ip_dest_ip(m_udp_ip_dest_ip),
	.m_udp_source_port(m_udp_source_port),
	.m_udp_dest_port(m_udp_dest_port),
	.m_udp_length(m_udp_length),
	.m_udp_checksum(),
	.m_udp_payload_axis_tdata(m_udp_payload_axis_tdata),
	.m_udp_payload_axis_tvalid(m_udp_payload_axis_tvalid),
	.m_udp_payload_axis_tready(m_udp_payload_axis_tready),
	.m_udp_payload_axis_tlast(m_udp_payload_axis_tlast),
	.m_udp_payload_axis_tuser(m_udp_payload_axis_tuser),
	.ip_rx_busy(),
	.ip_tx_busy(),
	.udp_rx_busy(),
	.udp_tx_busy(),
	.ip_rx_error_header_early_termination(),
	.ip_rx_error_payload_early_termination(),
	.ip_rx_error_invalid_header(),
	.ip_rx_error_invalid_checksum(),
	.ip_tx_error_payload_early_termination(),
	.ip_tx_error_arp_failed(),
	.udp_rx_error_header_early_termination(),
	.udp_rx_error_payload_early_termination(),
	.udp_tx_error_payload_early_termination(),
	.local_mac(local_mac),
	.local_ip(local_ip),
	.gateway_ip(gateway_ip),
	.subnet_mask(subnet_mask),
	.clear_arp_cache(0)
);

endmodule
