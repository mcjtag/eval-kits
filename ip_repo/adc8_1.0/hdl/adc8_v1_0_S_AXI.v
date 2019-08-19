`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 05.08.2019 11:52:04
// Design Name: 
// Module Name: adc8_v1_0_S_AXI
// Project Name: adc8
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

module adc8_v1_0_S_AXI #(
	parameter integer C_S_AXI_DATA_WIDTH = 32,
	parameter integer C_S_AXI_ADDR_WIDTH = 7
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
	// ctrl
	output wire ctrl_rst,
	output wire ctrl_esync,
	output wire ctrl_out_valid,
	input wire ctrl_calib_done,
	// spi
	output wire spi_rst,
	output wire spi_en,
	output wire [7:0]spi_dev,
    output wire [31:0]spi_data_in,
    output wire spi_data_wr,
    input wire [31:0]spi_data_out,
    output wire spi_data_rd,
    input wire [7:0]spi_status,
    // dst ctrl
	output wire dst_rst,
	output wire dst_pd,
	output wire dst_sync,
	output wire dst_refsel,
	// dst status
	input wire dst_ld,
	// switch
	output wire [3:0]sw_mode,
	// adc ctrl
	output wire adc_if_rst,
	output wire [7:0]adc_oen,
	output wire [7:0]adc_cal,
	output wire [7:0]adc_amode,
	// adc status
	input wire [7:0]adc_ovf
);

localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
localparam integer OPT_MEM_ADDR_BITS = 4;

localparam REG_CR = 5'h00;
localparam REG_SR = 5'h01;
localparam REG_DCR = 5'h02;
localparam REG_DSR = 5'h03;
localparam REG_ACR = 5'h04;
localparam REG_ASR = 5'h05;
localparam REG_SMCR = 5'h06;
localparam REG_SPICR = 5'h10;
localparam REG_SPISR = 5'h11;
localparam REG_SPIDR = 5'h12; 

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

wire reg_rden;
wire reg_wren;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_data_out;
integer	byte_index;
reg	aw_en;

reg [C_S_AXI_DATA_WIDTH-1:0]reg_cr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_sr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_dcr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_dsr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_acr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_asr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_smcr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_spicr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_spisr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_spidr;

reg [7:0]spi_dev_de;
reg spi_data_wr_r;
reg spi_data_rd_r;

assign S_AXI_AWREADY = axi_awready;
assign S_AXI_WREADY = axi_wready;
assign S_AXI_BRESP = axi_bresp;
assign S_AXI_BVALID = axi_bvalid;
assign S_AXI_ARREADY = axi_arready;
assign S_AXI_RDATA = axi_rdata;
assign S_AXI_RRESP = axi_rresp;
assign S_AXI_RVALID = axi_rvalid;

assign reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
assign reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

assign ctrl_rst = reg_cr[0];
assign ctrl_esync = reg_cr[1];
assign ctrl_out_valid = reg_cr[2];

assign dst_rst = reg_dcr[0];
assign dst_pd = reg_dcr[1];
assign dst_sync = reg_dcr[2];
assign dst_refsel = reg_dcr[3];

assign spi_rst = reg_spicr[0];
assign spi_en = reg_spicr[1];
assign spi_dev = spi_dev_de;

assign spi_data_in = reg_spidr;
assign spi_data_wr = spi_data_wr_r;
assign spi_data_rd = spi_data_rd_r;

assign adc_oen = reg_acr[7:0];
assign adc_cal = reg_acr[15:8];
assign adc_amode = reg_acr[23:16];
assign adc_if_rst = reg_acr[24];

assign sw_mode = reg_smcr[3:0];

always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
    	reg_sr <= 0;
        reg_dsr <= 0;
        reg_asr <= 0;
        reg_spisr <= 0;
    end else begin
		reg_sr <= {{31{1'b0}}, ctrl_calib_done};
        reg_dsr <= {{31{1'b0}}, dst_ld};
        reg_asr <= {{24{1'b0}}, adc_ovf};
        reg_spisr <= {{3{8'h00}}, spi_status};
    end 
end

always @(*) begin
    if (spi_en == 1'b1) begin
        case (reg_spicr[10:8])
            3'b000: spi_dev_de <= 8'h01;
            3'b001: spi_dev_de <= 8'h02;
            3'b010: spi_dev_de <= 8'h04;
            3'b011: spi_dev_de <= 8'h08;
            3'b100: spi_dev_de <= 8'h10;
            3'b101: spi_dev_de <= 8'h20;
            3'b110: spi_dev_de <= 8'h40;
            3'b111: spi_dev_de <= 8'h80;
        endcase
    end else begin 
        spi_dev_de <= 8'h00;
    end
end

/* SPI Write Data */
always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
	      spi_data_wr_r <= 0;
	end else begin
		if (spi_data_wr == 1'b0) begin
			if (reg_wren) begin
				case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
					REG_SPIDR: spi_data_wr_r <= 1'b1;
				endcase
			end
        end else begin
			spi_data_wr_r <= 1'b0;
        end
	end
end

/* SPI Read Data */
always @(*) begin
	if (reg_rden) begin
		case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
		REG_SPIDR: spi_data_rd_r <= 1'b1;
		default: spi_data_rd_r <= 1'b0;
		endcase
	end
end

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		axi_awready <= 1'b0;
		aw_en <= 1'b1;
		axi_awaddr <= 0;
		axi_wready <= 1'b0;
	end else begin
		if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
			axi_awready <= 1'b1;
			aw_en <= 1'b0;
		end else if (S_AXI_BREADY && axi_bvalid) begin
			aw_en <= 1'b1;
			axi_awready <= 1'b0;
		end else begin
			axi_awready <= 1'b0;
		end
		
		if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
			axi_awaddr <= S_AXI_AWADDR;
		end
		
		if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en) begin
			axi_wready <= 1'b1;
		end else begin
			axi_wready <= 1'b0;
		end
	end 
end      

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		reg_cr <= 0;
		reg_dcr <= 0;
		reg_acr <= 0;
		reg_smcr <= 0;
		reg_spicr <= 0;
		reg_spidr <= 0;
	end else begin
		if (reg_wren) begin
			case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
			REG_CR:
				for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
					if (S_AXI_WSTRB[byte_index] == 1) begin
						reg_cr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
					end  
			REG_DCR:
				for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
					if (S_AXI_WSTRB[byte_index] == 1) begin
						reg_dcr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
					end
			REG_ACR:
				for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
					if (S_AXI_WSTRB[byte_index] == 1) begin
						reg_acr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
					end
			REG_SMCR:
				for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
					if (S_AXI_WSTRB[byte_index] == 1) begin
						reg_smcr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
					end
			REG_SPICR:
				for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
					if (S_AXI_WSTRB[byte_index] == 1) begin
						reg_spicr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
					end
			REG_SPIDR:
				for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
					if (S_AXI_WSTRB[byte_index] == 1) begin
						reg_spidr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
					end  
			default : begin
				reg_cr <= reg_cr;
				reg_dcr <= reg_dcr;
				reg_acr <= reg_acr;
				reg_smcr <= reg_smcr;
				reg_spicr <= reg_spicr;
				reg_spidr <= reg_spidr;
			end
			endcase
		end
	end
end    

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		axi_bvalid <= 0;
	      axi_bresp <= 2'b0;
	end else begin
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
		axi_arready <= 1'b0;
		axi_araddr <= 32'b0;
		axi_rvalid <= 0;
		axi_rresp <= 0;
	end else begin
		if (~axi_arready && S_AXI_ARVALID) begin
			axi_arready <= 1'b1;
			axi_araddr  <= S_AXI_ARADDR;
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

always @(*) begin
	case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
		REG_CR: reg_data_out <= reg_cr;
		REG_SR: reg_data_out <= reg_sr;
		REG_DCR: reg_data_out <= reg_dcr;
		REG_DSR: reg_data_out <= reg_dsr;
		REG_ACR: reg_data_out <= reg_acr;
		REG_ASR: reg_data_out <= reg_asr;
		REG_SMCR: reg_data_out <= reg_smcr;
		REG_SPICR: reg_data_out <= reg_spicr;
		REG_SPISR: reg_data_out <= reg_spisr;
		REG_SPIDR: reg_data_out <= spi_data_out;
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
