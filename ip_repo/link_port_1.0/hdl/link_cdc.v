`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 04.04.2019 14:27:06
// Design Name: 
// Module Name: link_cdc
// Project Name: link_port
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

module link_cdc #(
    parameter DATA_WIDTH = 4,
    parameter DDR_ENABLE = 1,
    parameter DATA_DEPTH = 16	// 16 is max value
)
(
    input wire src_rst,
    input wire src_clk,
    input wire src_we,
    input wire [DATA_WIDTH-1:0]src_data,
    output wire src_recv,
    input wire dst_rst,
    input wire dst_clk,
    input wire dst_re,
    output wire [DATA_WIDTH*(DDR_ENABLE+1)-1:0]dst_data,
    output wire dst_valid,
    input wire dst_recv
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

localparam ADDR_HIGH = clogb2(DATA_DEPTH)+1;

reg [4:0]wr_addr_p;
reg [4:0]wr_addr_n;
wire wr_half_p;
wire wr_half_n;
reg [4:0]rd_addr;
reg read_state;

wire [DATA_WIDTH-1:0]data_p;
wire [DATA_WIDTH-1:0]data_n;

assign dst_data = DDR_ENABLE ? {data_n,data_p} : data_p;
assign dst_valid = read_state;

genvar i;

/* POSITIVE DATA */
always @(posedge src_clk, posedge src_rst) begin
	if (src_rst == 1'b1) begin
		wr_addr_p <= 0;
	end else begin
	   if (src_we == 1'b1)
		  wr_addr_p <= wr_addr_p + 1;
	end
end

generate for (i = 0; i < DATA_WIDTH; i = i + 1) begin: DATA_P
	RAM32X1D #(
		.INIT(32'h00000000)
	) RAM32X1D_DAT_P (
		.DPO(data_p[i]),
		.SPO(),
		.A0(wr_addr_p[0]),
		.A1(wr_addr_p[1]),
		.A2(wr_addr_p[2]),
		.A3(wr_addr_p[3]),
		.A4(wr_addr_p[4]),
		.D(src_data[i]),
		.DPRA0(rd_addr[0]),
		.DPRA1(rd_addr[1]),
		.DPRA2(rd_addr[2]),
		.DPRA3(rd_addr[3]),
		.DPRA4(rd_addr[4]),
		.WCLK(src_clk),
		.WE(src_we)
	);
end endgenerate

xpm_cdc_single #(
	.DEST_SYNC_FF(2),
	.SIM_ASSERT_CHK(0),
	.SRC_INPUT_REG(0)
) xpm_cdc_single_p_inst (
	.src_clk(),
	.src_in(wr_addr_p[ADDR_HIGH-1]),
	.dest_clk(dst_clk),
	.dest_out(wr_half_p)
);

/* NEGATIVE DATA */
generate if (DDR_ENABLE) begin
always @(negedge src_clk, posedge src_rst) begin
	if (src_rst == 1'b1) begin
		wr_addr_n <= 0;
	end else begin
	   if (src_we == 1'b1)
		  wr_addr_n <= wr_addr_n + 1;
	end
end
end endgenerate

generate if (DDR_ENABLE) begin
for (i = 0; i < DATA_WIDTH; i = i + 1) begin: DATA_N
	RAM32X1D #(
		.INIT(32'h00000000)
	) RAM32X1D_DAT_N (
		.DPO(data_n[i]),
		.SPO(),
		.A0(wr_addr_n[0]),
		.A1(wr_addr_n[1]),
		.A2(wr_addr_n[2]),
		.A3(wr_addr_n[3]),
		.A4(wr_addr_n[4]),
		.D(src_data[i]),
		.DPRA0(rd_addr[0]),
		.DPRA1(rd_addr[1]),
		.DPRA2(rd_addr[2]),
		.DPRA3(rd_addr[3]),
		.DPRA4(rd_addr[4]),
		.WCLK(~src_clk),
		.WE(src_we)
	);
end

xpm_cdc_single #(
	.DEST_SYNC_FF(4),
	.SIM_ASSERT_CHK(0),
	.SRC_INPUT_REG(0)
) xpm_cdc_single_n_inst (
	.src_clk(),
	.src_in(wr_addr_n[ADDR_HIGH-1]),
	.dest_clk(dst_clk),
	.dest_out(wr_half_n)
);
end endgenerate

/* Data read control */
always @(posedge dst_clk, posedge dst_rst) begin
	if (dst_rst == 1'b1) begin
		read_state <= 1'b0;
		rd_addr <= 0;
	end else begin
		if (read_state == 1'b0) begin
			if ((rd_addr[ADDR_HIGH-1] != wr_half_p) && (DDR_ENABLE ? (rd_addr[ADDR_HIGH-1] != wr_half_n) : 1'b1)) begin
				read_state <= 1'b1;
			end
		end else begin
			if (dst_re == 1'b1) begin
				rd_addr <= rd_addr + 1;
			
				if (rd_addr[ADDR_HIGH-2:0] == {(ADDR_HIGH-1){1'b1}}) begin
					if ((rd_addr[ADDR_HIGH-1] != wr_half_p) && (DDR_ENABLE ? (rd_addr[ADDR_HIGH-1] != wr_half_n) : 1'b1)) begin
						read_state <= 1'b0;
					end else begin
						read_state <= 1'b1;
					end
				end
			end
		end
	end
end

/* Receive Handshake */
xpm_cdc_pulse #(
	.DEST_SYNC_FF(2),
	.RST_USED(1),
	.SIM_ASSERT_CHK(0)
) xpm_cdc_pulse_recv (
	.src_clk(dst_clk),
	.src_rst(dst_rst),
	.src_pulse(dst_recv),
	.dest_clk(src_clk),
	.dest_rst(src_rst),
	.dest_pulse(src_recv)
);

endmodule
