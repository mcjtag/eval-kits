`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 26.03.2019 17:33:08
// Design Name: 
// Module Name: ad9520_v1_0_S_AXI
// Project Name: ad9520
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

/*
+--------+------+--------+------+------------+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+-----+-----+-----+-----+----+----+-------+-----+
|  REG   | ADDR | OFFSET | TYPE |    RESET   | 31 | 30 | 29 | 28 | 27 | 26 | 25 | 24 | 23 | 22 | 21 | 20 | 19 | 18 | 17 | 16 | 15 | 14 | 13 | 12 | 11 | 10 | 09 | 08 |  07 |  06 |  05 |  04 | 03 | 02 |   01  |  00 |
+--------+------+--------+------+------------+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+-----+-----+-----+-----+----+----+-------+-----+
|   CR   | 0x00 |  0x00  |  RW  | 0x00000000 |                                                                         RESERVED                                                                        | ESYNC | RST |
+--------+------+--------+------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+-------+-----+
|  IOCR  | 0x01 |  0x04  |  RW  | 0x00000000 |               SYNC[7:0]               |              EEPROM[7:0]              |                PD[7:0]                |                   RESET[7:0]                  |
+--------+------+--------+------+------------+---------------------------------------+---------------------------------------+---------------------------------------+-----------------------------------------------+
|  IOSR  | 0x02 |  0x08  |  RO  | 0x00000000 |                RESERVED               |              STATUS[7:0]              |                LD[7:0]                |                  REFMON[7:0]                  |
+--------+------+--------+------+------------+---------------------------------------+---------------------------------------+---------------------------------------+-----------------------------------------------+
| SPI_CR | 0x10 |  0x40  |  RW  | 0x00000000 |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |   DEV[2:0]   |     |     |     |     |    |    |   EN  | RST |
+--------+------+--------+------+------------+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+--------------+-----+-----+-----+-----+----+----+-------+-----+
| SPI_SR | 0x11 |  0x44  |  RO  | 0x00000000 |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    | FTF | FTE | FRF | FRE |        0        | TXA |
+--------+------+--------+------+------------+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+-----+-----+-----+-----+-----------------+-----+
| SPI_DR | 0x12 |  0x48  |  RW  | 0x00000000 |                                                                               DATA[31:0]                                                                              |
+--------+------+--------+------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
*/

module ad9520_v1_0_S_AXI #(
	parameter integer C_S_AXI_DATA_WIDTH = 32,
	parameter integer C_S_AXI_ADDR_WIDTH = 8
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
	// spi
	output wire spi_rst,
	output wire spi_en,
	output wire [7:0]spi_dev,
    output wire [31:0]spi_data_in,
    output wire spi_data_wr,
    input wire [31:0]spi_data_out,
    output wire spi_data_rd,
    input wire [7:0]spi_status,
    // control
    output wire ctrl_rst,
    output wire ctrl_esync,
	// io control
	output wire [7:0]ioc_reset,
	output wire [7:0]ioc_pd,
	output wire [7:0]ioc_sync,
	output wire [7:0]ioc_eeprom,
	// status
	input wire [7:0]stat_refmon,
	input wire [7:0]stat_ld,
	input wire [7:0]stat_status
);

reg [C_S_AXI_ADDR_WIDTH-1:0]axi_awaddr;
reg	axi_awready;
reg	axi_wready;
reg [1:0]axi_bresp;
reg axi_bvalid;
reg [C_S_AXI_ADDR_WIDTH-1:0]axi_araddr;
reg	axi_arready;
reg [C_S_AXI_DATA_WIDTH-1:0]axi_rdata;
reg [1:0]axi_rresp;
reg axi_rvalid;

localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
localparam integer OPT_MEM_ADDR_BITS = 5;

localparam REG_ADDR_CR = 6'h00;
localparam REG_ADDR_IOCR = 6'h01;
localparam REG_ADDR_IOSR = 6'h02;
localparam REG_ADDR_SPICR = 6'h10;
localparam REG_ADDR_SPISR = 6'h11;
localparam REG_ADDR_SPIDR = 6'h12;

reg [C_S_AXI_DATA_WIDTH-1:0]reg_cr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_iocr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_iosr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_spicr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_spisr;
reg [C_S_AXI_DATA_WIDTH-1:0]reg_spidr;

wire reg_rden;
wire reg_wren;

reg [C_S_AXI_DATA_WIDTH-1:0]reg_data_out;
integer byte_index;

reg [7:0]spi_dev_de;
reg spi_data_wr_r;
reg spi_data_rd_r;

assign S_AXI_AWREADY = axi_awready;
assign S_AXI_WREADY	= axi_wready;
assign S_AXI_BRESP = axi_bresp;
assign S_AXI_BVALID	= axi_bvalid;
assign S_AXI_ARREADY = axi_arready;
assign S_AXI_RDATA = axi_rdata;
assign S_AXI_RRESP = axi_rresp;
assign S_AXI_RVALID	= axi_rvalid;

assign reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
assign reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

assign ctrl_rst = reg_cr[0];
assign ctrl_esync = reg_cr[1];

assign ioc_reset = reg_iocr[7:0];
assign ioc_pd = reg_iocr[15:8];
assign ioc_eeprom = reg_iocr[23:16];
assign ioc_sync = reg_iocr[31:24];

assign spi_rst = reg_spicr[0];
assign spi_en = reg_spicr[1];
assign spi_dev = spi_dev_de;

assign spi_data_in = reg_spidr;
assign spi_data_wr = spi_data_wr_r;
assign spi_data_rd = spi_data_rd_r;

always @(posedge S_AXI_ACLK) begin
    if (S_AXI_ARESETN == 1'b0) begin
        reg_iosr <= 0;
        reg_spisr <= 0;
    end else begin
        reg_iosr <= {8'h00,stat_status,stat_ld,stat_refmon};
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

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		axi_awready <= 1'b0;
		axi_awaddr <= 0;
		axi_wready <= 1'b0;
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
	end 
end    

// WRITE Registers
always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
	      reg_cr <= 0;
	      reg_iocr <= 0;
	      reg_spicr <= 0;
	      reg_spidr <= 0;
	end else begin
		if (reg_wren) begin
			case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
				REG_ADDR_CR:
					for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
						if (S_AXI_WSTRB[byte_index] == 1) begin
							reg_cr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
						end
				REG_ADDR_IOCR:
					for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
						if (S_AXI_WSTRB[byte_index] == 1) begin
							reg_iocr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
						end
				REG_ADDR_SPICR:
					for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
						if (S_AXI_WSTRB[byte_index] == 1) begin
							reg_spicr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
						end
				REG_ADDR_SPIDR:
					for (byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1)
						if (S_AXI_WSTRB[byte_index] == 1) begin
							reg_spidr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
						end
				default : begin
					reg_cr <= reg_cr;
					reg_iocr <= reg_iocr;
					reg_spicr <= reg_spicr;
					reg_spidr <= reg_spidr;
				end
			endcase
		end
	end
end    

// SPI Write Data
always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
	      spi_data_wr_r <= 0;
	end else begin
		if (spi_data_wr == 1'b0) begin
			if (reg_wren) begin
				case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
					REG_ADDR_SPIDR: spi_data_wr_r <= 1'b1;
				endcase
			end
        end else begin
			spi_data_wr_r <= 1'b0;
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
			axi_araddr <= S_AXI_ARADDR;
		end else begin
			axi_arready <= 1'b0;
		end
		
		if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
			axi_rvalid <= 1'b1;
			axi_rresp <= 2'b0;
		end else begin 
			if (axi_rvalid && S_AXI_RREADY) begin
				axi_rvalid <= 1'b0;
			end
		end
	end 
end

// Read registers
always @(*)	begin
	case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
		REG_ADDR_CR: reg_data_out <= reg_cr;
		REG_ADDR_IOCR: reg_data_out <= reg_iocr;
		REG_ADDR_IOSR: reg_data_out <= reg_iosr;
		REG_ADDR_SPICR: reg_data_out <= reg_spicr;
		REG_ADDR_SPISR: reg_data_out <= reg_spisr;
		REG_ADDR_SPIDR: reg_data_out <= spi_data_out;
		default : reg_data_out <= 0;
	endcase
end

// SPI Read Data
always @(*) begin
	if (reg_rden) begin
		case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
		REG_ADDR_SPIDR: spi_data_rd_r <= 1'b1;
		default: spi_data_rd_r <= 1'b0;
		endcase
	end
end

always @(posedge S_AXI_ACLK) begin
	if (S_AXI_ARESETN == 1'b0) begin
		axi_rdata  <= 0;
	end else begin    
		if (reg_rden) begin
			axi_rdata <= reg_data_out;
		end   
	end
end    

endmodule
