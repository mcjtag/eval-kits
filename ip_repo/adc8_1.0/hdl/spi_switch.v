`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 05.08.2019 14:25:59
// Design Name: 
// Module Name: spi_switch
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

module spi_switch (
	input wire clk,
	input wire rst,
	input wire spi_sck,
	input wire spi_sdo,
	output wire spi_sdi,
	input wire spi_ncs,
	output wire [7:0]adc_spi_sck,
	output wire [7:0]adc_spi_sdo,
	input wire [7:0]adc_spi_sdi,
	output wire [7:0]adc_spi_ncs,
	output wire dst_spi_sck,
	output wire dst_spi_sdo,
	input wire dst_spi_sdi,
	output wire dst_spi_ncs,
	input wire [3:0]mode,
	input wire [7:0]ctrl_oen,
	input wire [7:0]ctrl_cal,
	output wire [7:0]ctrl_ovf
);

(* IOB = "TRUE" *) reg [8:0]sck;
(* IOB = "TRUE" *) reg [8:0]sdo;
(* IOB = "TRUE" *) reg [8:0]ncs;
reg sdi;
reg [7:0]ovf;

assign spi_sdi = sdi;
assign adc_spi_sck = sck[7:0];
assign adc_spi_sdo = sdo[7:0];
assign adc_spi_ncs = ncs[7:0];
assign dst_spi_sck = sck[8];
assign dst_spi_sdo = sdo[8];
assign dst_spi_ncs = ncs[8];
assign ctrl_ovf = ovf;

always @(posedge clk) begin
	if (rst == 1'b1) begin
		sdi <= 1'b0;
		sck <= 0;
		sdo <= 0;
		ncs <= 0;
		ovf <= 0;
	end else begin
		case (mode)
		4'h0: begin // CTRL_MODE
			sdi <= 1'b0;
			sck <= {1'b0, ctrl_oen};
			sdo <= {1'b0, ctrl_cal};
			ncs <= {1'b1, 8'hFF};
			ovf <= adc_spi_sdi;
		end
		4'h1: begin // ADC_SPI_0
			sdi <= adc_spi_sdi[0];
			sck <= {8'b0000_0000, spi_sck};
			sdo <= {8'b0000_0000, spi_sdo};
			ncs <= {8'b1111_1111, spi_ncs};
			ovf <= 0;
		end
		4'h2: begin // ADC_SPI_1
			sdi <= adc_spi_sdi[1];
			sck <= {7'b0000_000, spi_sck, 1'b0};
			sdo <= {7'b0000_000, spi_sdo, 1'b0};
			ncs <= {7'b1111_111, spi_ncs, 1'b1};
			ovf <= 0;
		end
		4'h3: begin // ADC_SPI_2
			sdi <= adc_spi_sdi[2];
			sck <= {6'b0000_00, spi_sck, 2'b00};
			sdo <= {6'b0000_00, spi_sdo, 2'b00};
			ncs <= {6'b1111_11, spi_ncs, 2'b11};
			ovf <= 0;
		end
		4'h4: begin // ADC_SPI_3
			sdi <= adc_spi_sdi[3];
			sck <= {5'b0000_0, spi_sck, 3'b000};
			sdo <= {5'b0000_0, spi_sdo, 3'b000};
			ncs <= {5'b1111_1, spi_ncs, 3'b111};
			ovf <= 0;
		end
		4'h5: begin // ADC_SPI_4
			sdi <= adc_spi_sdi[4];
			sck <= {4'b0000, spi_sck, 4'b0000};
			sdo <= {4'b0000, spi_sdo, 4'b0000};
			ncs <= {4'b1111, spi_ncs, 4'b1111};
			ovf <= 0;
		end
		4'h6: begin // ADC_SPI_5
			sdi <= adc_spi_sdi[5];
			sck <= {3'b000, spi_sck, 5'b0000_0};
			sdo <= {3'b000, spi_sdo, 5'b0000_0};
			ncs <= {3'b111, spi_ncs, 5'b1111_1};
			ovf <= 0;
		end
		4'h7: begin // ADC_SPI_6
			sdi <= adc_spi_sdi[6];
			sck <= {2'b00, spi_sck, 6'b0000_00};
			sdo <= {2'b00, spi_sdo, 6'b0000_00};
			ncs <= {2'b11, spi_ncs, 6'b1111_11};
			ovf <= 0;
		end
		4'h8: begin // ADC_SPI_7
			sdi <= adc_spi_sdi[7];
			sck <= {1'b0, spi_sck, 7'b0000_000};
			sdo <= {1'b0, spi_sdo, 7'b0000_000};
			ncs <= {1'b1, spi_ncs, 7'b1111_111};
			ovf <= 0;
		end
		4'h9: begin // DST_SPI
			sdi <= dst_spi_sdi;
			sck <= {spi_sck, 8'b0000_0000};
			sdo <= {spi_sdo, 8'b0000_0000};
			ncs <= {spi_ncs, 8'b1111_1111};
			ovf <= 0;
		end
		default: begin
			sdi <= 1'b0;
			sck <= 0;
			sdo <= 0;
			ncs <= 0;
			ovf <= 0;
		end
		endcase
	end
end

endmodule
