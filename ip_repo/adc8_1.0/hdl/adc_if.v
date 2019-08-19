`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 05.08.2019 17:06:01
// Design Name: 
// Module Name: adc_if
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

module adc_if #(
	parameter DELAY_GROUP = "ADC_IF_GROUP",
	parameter DELAY_CTRL_ENABLE = 0
)
(
	input wire clk,
	input wire rst,
	input wire ref_clk,
	output wire del_rdy,
	input wire adc_clk_p,
	input wire adc_clk_n,
	input wire [6:0]adc_dq_p,
	input wire [6:0]adc_dq_n,
	output wire [15:0]data,
	output wire data_valid,
	output wire [7:0]calib_data
);

wire adc_clk_b;
wire adc_clk_d;
wire adc_clk;
wire [6:0]adc_dq_b;
wire [6:0]adc_dq_d;
wire [6:0]adc_dat_p;
wire [6:0]adc_dat_n;
reg [15:0]adc_data;

genvar i;

/* Clock */
IBUFGDS #(
	.IBUF_LOW_PWR("FALSE")
) IBUFGDS_CLK (
	.I(adc_clk_p),
	.IB(adc_clk_n),
	.O(adc_clk_b)
);

(* IODELAY_GROUP = DELAY_GROUP *)
IDELAYE2 # (
	.CINVCTRL_SEL("FALSE"),
	.DELAY_SRC("IDATAIN"),
	.HIGH_PERFORMANCE_MODE("TRUE"),
	.IDELAY_TYPE("FIXED"),
	.IDELAY_VALUE(0),
	.REFCLK_FREQUENCY(200.0),
	.PIPE_SEL("FALSE"),
	.SIGNAL_PATTERN("CLOCK")
) IDELAYE2_CLK (
	.DATAOUT(adc_clk_d),
	.DATAIN(1'b0),
	.C(1'b0),
	.CE(),
	.INC(),
	.IDATAIN(adc_clk_b),
	.LD(1'b0),
	.REGRST(),
	.LDPIPEEN(1'b0),
	.CNTVALUEIN(5'b00000),
	.CNTVALUEOUT(),
	.CINVCTRL(1'b0)
);

BUFR #(
	.BUFR_DIVIDE("BYPASS"),
	.SIM_DEVICE("7SERIES")
) BUFR_CLK (
	.I(adc_clk_d),
	.O(adc_clk),
	.CE(1'b1),
	.CLR(1'b0)
);

/* DATA */
generate for (i = 0; i < 7; i = i + 1) begin: DATA
    IBUFDS #(
        .IBUF_LOW_PWR("FALSE")
    ) IBUFDS_DAT (
        .I(adc_dq_p[i]),
        .IB(adc_dq_n[i]),
		.O(adc_dq_b[i])
	);
	
	(* IODELAY_GROUP = DELAY_GROUP *)
    IDELAYE2 # (
	   .CINVCTRL_SEL("FALSE"),
	   .DELAY_SRC("IDATAIN"),
	   .HIGH_PERFORMANCE_MODE("TRUE"),
	   .IDELAY_TYPE("FIXED"),
	   .IDELAY_VALUE(0),
	   .REFCLK_FREQUENCY(200.0),
	   .PIPE_SEL("FALSE"),
	   .SIGNAL_PATTERN("DATA")
    ) IDELAYE2_DAT (
	   .DATAOUT(adc_dq_d[i]),
	   .DATAIN(1'b0),
	   .C(1'b0),
	   .CE(),
	   .INC(),
	   .IDATAIN(adc_dq_b[i]),
	   .LD(1'b0),
	   .REGRST(),
	   .LDPIPEEN(1'b0),
	   .CNTVALUEIN(5'b00000),
	   .CNTVALUEOUT(),
	   .CINVCTRL(1'b0)
    );
    
	IDDR #(
		.DDR_CLK_EDGE("SAME_EDGE"),
		.INIT_Q1(1'b0),
		.INIT_Q2(1'b0),
		.SRTYPE("ASYNC")
	) IDDR_DAT (
		.Q1(adc_dat_p[i]),
		.Q2(adc_dat_n[i]),
		.C(adc_clk),
		.CE(1'b1),
		.D(adc_dq_d[i]),
		.R(rst | ~del_rdy),
		.S(1'b0)
	);
    
end endgenerate

/* IDELAYCTRL Instance */
generate if (DELAY_CTRL_ENABLE == 1)
	(* IODELAY_GROUP = DELAY_GROUP *)
	IDELAYCTRL IDELAYCTRL_inst (
		.RDY(del_rdy),
		.REFCLK(ref_clk),
		.RST(rst)
	);
else
	assign del_rdy = 1'b1;
endgenerate

always @(posedge adc_clk) begin
	adc_data <= {
		adc_dat_p[6], adc_dat_n[6],
		adc_dat_p[5], adc_dat_n[5],
		adc_dat_p[4], adc_dat_n[4],
		adc_dat_p[3], adc_dat_n[3],
		adc_dat_p[2], adc_dat_n[2],
		adc_dat_p[1], adc_dat_n[1],
		adc_dat_p[0], adc_dat_n[0],
		1'b0, 1'b0
	};
end

adc_cdc adc_cdc_inst (
	.src_rst(rst),
    .src_clk(adc_clk),
    .src_data(adc_data),
	.dst_rst(rst),
	.dst_clk(clk),
	.dst_data(data),
	.dst_valid(data_valid),
	.calib_data(calib_data)
);

endmodule

module adc_cdc #(
    parameter DATA_WIDTH = 16,
    parameter DATA_DEPTH = 16
)
(
    input wire src_rst,
    input wire src_clk,
    input wire [DATA_WIDTH-1:0]src_data,
    input wire dst_rst,
    input wire dst_clk,
    output wire [DATA_WIDTH-1:0]dst_data,
    output wire dst_valid,
    output wire [7:0]calib_data
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

reg [ADDR_HIGH-1:0]wr_addr;
wire wr_half;
reg [ADDR_HIGH-1:0]rd_addr;
reg read_state;
reg [7:0]calib_cnt;
wire [DATA_WIDTH-1:0]data;

genvar i;

assign dst_data = data;
assign dst_valid = read_state;
assign calib_data = calib_cnt;

always @(posedge dst_clk) begin
	calib_cnt[7:ADDR_HIGH] <= 0;
	calib_cnt[ADDR_HIGH-1:0] <= wr_addr;
end

always @(posedge src_clk or posedge src_rst) begin
	if (src_rst == 1'b1) begin
		wr_addr <= 0;
	end else begin
		wr_addr <= wr_addr + 1;
	end
end

generate for (i = 0; i < DATA_WIDTH; i = i + 1) begin: DATA
	RAM32X1D #(
		.INIT(32'h00000000)
	) RAM32X1D_DAT (
		.DPO(data[i]),
		.SPO(),
		.A0(wr_addr[0]),
		.A1(wr_addr[1]),
		.A2(wr_addr[2]),
		.A3(wr_addr[3]),
		.A4(wr_addr[4]),
		.D(src_data[i]),
		.DPRA0(rd_addr[0]),
		.DPRA1(rd_addr[1]),
		.DPRA2(rd_addr[2]),
		.DPRA3(rd_addr[3]),
		.DPRA4(rd_addr[4]),
		.WCLK(src_clk),
		.WE(1'b1)
	);
end endgenerate

xpm_cdc_single #(
	.DEST_SYNC_FF(2),
	.SIM_ASSERT_CHK(0),
	.SRC_INPUT_REG(0)
) xpm_cdc_single_inst (
	.src_clk(),
	.src_in(wr_addr[ADDR_HIGH-1]),
	.dest_clk(dst_clk),
	.dest_out(wr_half)
);

/* Data read control */
always @(posedge dst_clk or posedge dst_rst) begin
	if (dst_rst == 1'b1) begin
		read_state <= 1'b0;
		rd_addr <= 0;
	end else begin
		if (read_state == 1'b0) begin
			if (rd_addr[ADDR_HIGH-1] != wr_half) begin
				read_state <= 1'b1;
			end
		end else begin
			rd_addr <= rd_addr + 1;
			if (rd_addr[ADDR_HIGH-2:0] == {(ADDR_HIGH-1){1'b1}}) begin
				if (rd_addr[ADDR_HIGH-1] != wr_half) begin
					read_state <= 1'b0;
				end else begin
					read_state <= 1'b1;
				end
			end
		end
	end
end

endmodule
