`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 19.01.2018 12:14:03
// Design Name: 
// Module Name: hmc1031_v1_0_S_AXI
// Project Name: hmc1031
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

module hmc1031_v1_0_S_AXI # (
	parameter integer C_S_AXI_DATA_WIDTH	= 32,
	parameter integer C_S_AXI_ADDR_WIDTH	= 4
)
(
	input wire S_AXI_ACLK,
	input wire S_AXI_ARESETN,
	input wire [C_S_AXI_ADDR_WIDTH-1:0]S_AXI_AWADDR,
	input wire [2:0]S_AXI_AWPROT,
	input wire S_AXI_AWVALID,
	output wire S_AXI_AWREADY,
	input wire [C_S_AXI_DATA_WIDTH-1:0]S_AXI_WDATA,   
	input wire [(C_S_AXI_DATA_WIDTH/8)-1:0]S_AXI_WSTRB,
	input wire S_AXI_WVALID,
	output wire S_AXI_WREADY,
	output wire [1:0]S_AXI_BRESP,
	output wire S_AXI_BVALID,
	input wire S_AXI_BREADY,
	input wire [C_S_AXI_ADDR_WIDTH-1:0]S_AXI_ARADDR,
	input wire [2:0]S_AXI_ARPROT,
	input wire S_AXI_ARVALID,
	output wire S_AXI_ARREADY,
	output wire [C_S_AXI_DATA_WIDTH-1:0]S_AXI_RDATA,
	output wire [1:0]S_AXI_RRESP,
	output wire S_AXI_RVALID,
	input wire S_AXI_RREADY,
	output wire [1:0]ctrl_den,
	input wire stat_lkdop
);

reg [C_S_AXI_ADDR_WIDTH-1:0]axi_awaddr;
reg axi_awready;
reg axi_wready;
reg [1:0]axi_bresp;
reg axi_bvalid;
reg [C_S_AXI_ADDR_WIDTH-1:0]axi_araddr;
reg axi_arready;
reg [C_S_AXI_DATA_WIDTH-1:0]axi_rdata;
reg [1:0]axi_rresp;
reg axi_rvalid;

localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
localparam integer OPT_MEM_ADDR_BITS = 1;

localparam ADDR_REG_CR = 2'h0;
localparam ADDR_REG_SR = 2'h1;

reg [C_S_AXI_DATA_WIDTH-1:0]reg_cr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_sr;

wire reg_rden;
wire reg_wren;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_data_out;
integer byte_index;

assign reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
assign reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

assign S_AXI_AWREADY = axi_awready;
assign S_AXI_WREADY	= axi_wready;
assign S_AXI_BRESP = axi_bresp;
assign S_AXI_BVALID	= axi_bvalid;
assign S_AXI_ARREADY = axi_arready;
assign S_AXI_RDATA = axi_rdata;
assign S_AXI_RRESP = axi_rresp;
assign S_AXI_RVALID = axi_rvalid;

assign ctrl_den = reg_cr[1:0];

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		axi_awready <= 1'b0;
		axi_awaddr <= 0;
		axi_wready <= 1'b0;
		axi_bvalid <= 0;
		axi_bresp <= 2'b0;
	end else begin
		if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID) begin
			axi_awready <= 1'b1;
		end else begin
			axi_awready <= 1'b0;
		end
		
		if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID) begin
			axi_awaddr <= S_AXI_AWADDR;
		end
		
		if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID) begin
			axi_wready <= 1'b1;
		end else begin
			axi_wready <= 1'b0;
		end
		
		if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
			axi_bvalid <= 1'b1;
			axi_bresp <= 2'b0;
		end else begin
			if (S_AXI_BREADY && axi_bvalid) begin
				axi_bvalid <= 1'b0; 
			end  
		end
	end 
end       

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		reg_cr <= 0;
	end else begin
		if (reg_wren) begin
			case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
			ADDR_REG_CR: 
				for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
					if (S_AXI_WSTRB[byte_index] == 1) begin
						reg_cr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
					end  
			default: begin
					reg_cr <= reg_cr;
				end
			endcase
		end
	end
end    

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		axi_arready <= 1'b0;
		axi_araddr <= 32'b0;
		axi_rvalid <= 0;
		axi_rresp <= 0;
	end else begin
		if (~axi_arready && S_AXI_ARVALID) begin
			axi_arready <= 1'b1;
			axi_araddr <= S_AXI_ARADDR;
		end else begin
			axi_arready <= 1'b0;
		end
		
		if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
			axi_rvalid <= 1'b1;
			axi_rresp <= 2'b0;
		end else if (axi_rvalid && S_AXI_RREADY) begin
			axi_rvalid <= 1'b0;
		end 
	end 
end

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		reg_sr <= 0;
	end else begin
		reg_sr <= {{31{1'b0}}, stat_lkdop};
	end
end

always @(*) begin
	case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
		ADDR_REG_CR: reg_data_out <= reg_cr;
		ADDR_REG_SR: reg_data_out <= reg_sr;
		default : reg_data_out <= 0;
	endcase
end

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		axi_rdata <= 0;
	end else begin    
		if (reg_rden) begin
			axi_rdata <= reg_data_out;
		end
	end
end    

endmodule
