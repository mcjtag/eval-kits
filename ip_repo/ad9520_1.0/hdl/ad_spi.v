`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 26.03.2019 10:25:08
// Design Name: 
// Module Name: ad_spi
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

module ad_spi # (
    parameter DEV_COUNT = 1, // 1, 2, 3, 4
    parameter PRESCALER = 2,
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 4
)
(
    input wire clk,
    input wire rst,
    // Control
    input wire [DEV_COUNT-1:0]dev_num,
    input wire [DATA_WIDTH-1:0]data_in,
    input wire data_wr,
    output wire [DATA_WIDTH-1:0]data_out,
    input wire data_rd,
    output wire [7:0]status,
    // SPI signals
    output wire sclk,
    output wire sdo,
    input wire sdi,
    output wire [DEV_COUNT-1:0]cs
);

function integer clogb2;
    input [31:0]value;
    begin
        value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
            value = value >> 1;
        end
    end
endfunction

localparam BC_WIDTH = clogb2(DATA_WIDTH);

wire fifo_tx_full;
wire fifo_rx_full;
wire fifo_tx_empty;
wire fifo_rx_empty;
wire [DATA_WIDTH-1:0]fifo_tx_dout;
reg [1:0]wr_ff;
reg wr_rise;
reg [1:0]rd_ff;
reg rd_rise;

reg [15:0]precounter;
reg pclk;
reg [1:0]p_ff;
reg pclk_rise;
reg pclk_fall;

reg [DATA_WIDTH-1:0]tx_data;
reg [DATA_WIDTH-1:0]rx_data;
reg tx_rden;
reg rx_wren;
reg tx_active;
reg tx_last;
reg [BC_WIDTH-1:0]bcount;

(* IOB = "TRUE" *) reg spi_sclk;
(* IOB = "TRUE" *) reg spi_sdo;
(* IOB = "TRUE" *) reg spi_sdi;
(* IOB = "TRUE" *) reg [DEV_COUNT-1:0]spi_cs;

assign status = {fifo_tx_full,fifo_tx_empty,fifo_rx_full,fifo_rx_empty,1'b0,1'b0,1'b0,tx_active|tx_last};

assign sclk = spi_sclk;
assign sdo = spi_sdo;
assign cs = spi_cs;

// SPI CS signal
always @(posedge clk) begin
    if (rst == 1'b1) begin
        spi_cs <= {DEV_COUNT{1'b1}};
    end
    spi_cs <= ~dev_num;  
end

// SPI SDI signal
always @(*) begin
    spi_sdi <= sdi;
end

always @(posedge clk) begin
    if (rst == 1'b1) begin
        tx_rden <= 1'b0;
        rx_wren <= 1'b0;
        bcount <= 0;
        spi_sdo <= 1'b0;
        spi_sclk <= 1'b0;
        tx_last <= 1'b0;
        tx_active <= 1'b0;
    end else begin
        if (tx_active == 1'b0) begin
            if (tx_last == 1'b1) begin
                rx_wren <= 1'b0;
                if (pclk_rise == 1'b1) begin
                    tx_last <= 1'b0;
                end
                if (pclk_fall == 1'b1) begin
                    spi_sclk <= 1'b0;
                    spi_sdo <= 1'b0;
                end
            end else begin
                if (fifo_tx_empty == 1'b0 && pclk_rise == 1'b1) begin
                    tx_active <= 1'b1;
                    bcount <= DATA_WIDTH - 1;
                    tx_data <= fifo_tx_dout;
                    tx_rden <= 1'b1;
                end
            end
        end else begin
            tx_rden <= 1'b0;
            case ({pclk_rise,pclk_fall})
                2'b01: begin
                    spi_sdo <= tx_data[bcount];
                    spi_sclk <= 1'b0;
                end
                2'b10: begin
                    rx_data[bcount] <= spi_sdi;
                    spi_sclk <= 1'b1;
                    bcount <= bcount - 1;
                    if (bcount == 0) begin
                        tx_active <= 1'b0;
                        tx_last <= 1'b1;
                        rx_wren <= 1'b1; 
                    end
                end
            endcase
        end
    end
end

// Prescaler clocking
always @(posedge clk) begin
    if (rst == 1'b1) begin
        precounter <= 0;
        pclk <= 1'b0;
    end else begin
        if (precounter == (PRESCALER - 1)) begin
            precounter <= 0;
            pclk <= ~pclk;
        end else begin
            precounter <= precounter + 1;
        end
    end
end

// Prescaler rising and falling PCLK
always @(posedge clk) begin
    p_ff[0] <= pclk;
    p_ff[1] <= p_ff[0];
end

always @(pclk, p_ff[0]) begin
    pclk_rise <= pclk & ~p_ff[0];
    pclk_fall <= ~pclk & p_ff[0];
end

// Catch rising data_wr
always @(posedge clk) begin
    wr_ff[0] <= data_wr;
    wr_ff[1] <= wr_ff[0];
end

always @(data_wr, wr_ff[0]) begin
    wr_rise <= data_wr & ~wr_ff[0];
end

// Catch rising data_rd
always @(posedge clk) begin
    rd_ff[0] <= data_rd;
    rd_ff[1] <= rd_ff[0];
end

always @(data_rd, rd_ff[0]) begin
    rd_rise <= data_rd & ~rd_ff[0];
end

spi_fifo # (
    .DATA_WIDTH(DATA_WIDTH),
    .DATA_DEPTH(FIFO_DEPTH)
) fifo_tx (
    .clk(clk),
    .rst(rst),
    .full(fifo_tx_full),
    .din(data_in),
    .wr_en(wr_rise),
    .empty(fifo_tx_empty),
    .dout(fifo_tx_dout),
    .rd_en(tx_rden)
);

spi_fifo # (
    .DATA_WIDTH(DATA_WIDTH),
    .DATA_DEPTH(FIFO_DEPTH)
) fifo_rx (
    .clk(clk),
    .rst(rst),
    .full(fifo_rx_full),
    .din(rx_data),
    .wr_en(rx_wren),
    .empty(fifo_rx_empty),
    .dout(data_out),
    .rd_en(rd_rise)
);

endmodule
