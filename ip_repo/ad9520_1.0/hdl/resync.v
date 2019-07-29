`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin
// 
// Create Date: 27.03.2019 11:13:52
// Design Name: 
// Module Name: resync
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

module resync (
    input wire clk,
    input wire rst,
    input wire [7:0]sync_in,
    input wire esync_en,
    input wire sync_clk,
    input wire esync,
    output wire [7:0]sync_out
);

wire src_rcv;
wire src_send;
wire dest_req;

wire rst_cdc;
wire [7:0]sync_cdc;
wire esync_en_cdc;

(* IOB = "TRUE" *) reg [7:0]sync_out_r;

assign sync_out = sync_out_r;

assign src_send = (rst == 1'b1) ? 1'b0 : ~src_rcv;

always @(posedge sync_clk) begin
    if (rst_cdc == 1'b1) begin
        sync_out_r <= 8'hFF;
    end else begin
        if (esync_en_cdc == 1'b1) begin
            sync_out_r <= ~{8{esync}};
        end else begin
            sync_out_r <= ~sync_cdc;
        end
    end
end

xpm_cdc_sync_rst #(
    .DEST_SYNC_FF(4),
    .INIT(1),
    .SIM_ASSERT_CHK(0)
) xpm_cdc_sync_rst_inst (
    .src_rst(rst),
    .dest_clk(sync_clk),
    .dest_rst(rst_cdc)
);

xpm_cdc_single #(
    .DEST_SYNC_FF(4),
    .SIM_ASSERT_CHK(0),
    .SRC_INPUT_REG(1)
) xpm_cdc_single_inst (
    .src_clk(clk),
    .src_in(esync_en),
    .dest_clk(sync_clk),
    .dest_out(esync_en_cdc)
);

xpm_cdc_handshake #(
    .DEST_EXT_HSK(0),
    .DEST_SYNC_FF(4),
    .SIM_ASSERT_CHK(0),
    .SRC_SYNC_FF(4),
    .WIDTH(8)
) xpm_cdc_handshake_inst (
    .src_clk(clk),
    .src_in(sync_in),
    .src_send(src_send),
    .src_rcv(),
    .dest_clk(sync_clk),
    .dest_req(dest_req),
    .dest_ack(1'b0),
    .dest_out(sync_cdc)
);

endmodule