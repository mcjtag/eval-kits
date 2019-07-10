`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Milandr
// Engineer: Dmitry Matyunin (https://github.com/mcjtag)
// 
// Create Date: 26.04.2019 15:43:07
// Design Name: 
// Module Name: eth_mac_v1_0
// Project Name: eth_mac
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

module eth_mac_v1_0 #(
	parameter IFG_DELAY = 12,
	parameter USE_DELAY_CTRL = 0,
	parameter DELAY_GROUP = "RGMII_DELAY_GROUP"
)
(
	/* AXI4-Stream Interface */
	input wire aclk,
	input wire aresetn,
	input wire [7:0]s_axis_tdata,
	input wire s_axis_tvalid,
	output wire s_axis_tready,
	input wire s_axis_tlast,
	output wire [7:0]m_axis_tdata,
	output wire m_axis_tvalid,
	input wire m_axis_tready,
	output wire m_axis_tlast,
	/* GTX */
	input wire gtx_clk,
	input wire gtx_clk90,
	input wire gtx_rst,
	/* Delay Control */
	input wire delay_clk, // 200 Mhz
	/* RGMII Interface */
	input wire [3:0]rgmii_rxd,
	input wire rgmii_rx_ctl,
	input wire rgmii_rxc,
	output wire [3:0]rgmii_txd,
	output wire rgmii_tx_ctl,
	output wire rgmii_txc,
	/*  */
	output wire mdc,
	output wire mdio,
	/* Phy */
	output wire phy_rst,
	/* Status */
	output wire [1:0]speed
);

wire rx_clk;
wire rx_rst;
wire tx_clk;
wire tx_rst;

wire [7:0]tx_axis_tdata;
wire tx_axis_tvalid;
wire tx_axis_tready;
wire tx_axis_tlast;
wire tx_axis_tuser;

wire [7:0]rx_axis_tdata;
wire rx_axis_tvalid;
wire rx_axis_tlast;
wire rx_axis_tuser;

wire [3:0]rgmii_rxd_d;
wire rgmii_rx_ctl_d;

wire status_tx_error_underflow;
wire status_rx_error_bad_frame;
wire status_rx_error_bad_fcs;
wire [1:0]status_speed;

assign phy_rst = ~gtx_rst;
assign mdc = 1'b0;
assign mdio = 1'b0;

/* Delay */
genvar i;
wire del_rdy;

generate if (USE_DELAY_CTRL) begin
	(* IODELAY_GROUP = DELAY_GROUP *)
	IDELAYCTRL idelayctrl_inst (
		.REFCLK(delay_clk),
		.RST(~aresetn),
		.RDY(del_rdy)
	);
end else begin
	assign del_rdy = 1'b1;
end endgenerate

generate for (i = 0; i < 4; i = i + 1) begin : RXD_DELAY
	(* IODELAY_GROUP = DELAY_GROUP *)
	IDELAYE2 #(
		.IDELAY_TYPE("FIXED")
	) phy_rxd_idelay (
		.IDATAIN(rgmii_rxd[i]),
		.DATAOUT(rgmii_rxd_d[i]),
		.DATAIN(1'b0),
		.C(1'b0),
		.CE(1'b0),
		.INC(1'b0),
		.CINVCTRL(1'b0),
		.CNTVALUEIN(5'd0),
		.CNTVALUEOUT(),
		.LD(1'b0),
		.LDPIPEEN(1'b0),
		.REGRST(1'b0)
	);
end endgenerate

(* IODELAY_GROUP = DELAY_GROUP *)
IDELAYE2 #(
	.IDELAY_TYPE("FIXED")
) phy_rx_ctl_idelay (
	.IDATAIN(rgmii_rx_ctl),
	.DATAOUT(rgmii_rx_ctl_d),
	.DATAIN(1'b0),
	.C(1'b0),
	.CE(1'b0),
	.INC(1'b0),
	.CINVCTRL(1'b0),
	.CNTVALUEIN(5'd0),
	.CNTVALUEOUT(),
	.LD(1'b0),
	.LDPIPEEN(1'b0),
	.REGRST(1'b0)
);          

eth_mac_1g_rgmii #(
	.USE_CLK90("TRUE"),
	.ENABLE_PADDING(1),
	.MIN_FRAME_LENGTH(64)
) eth_mac_1g_rgmii_inst (
	.gtx_clk(gtx_clk),
	.gtx_clk90(gtx_clk90),
	.gtx_rst(gtx_rst & ~del_rdy),
	.rx_clk(rx_clk),
	.rx_rst(rx_rst),
	.tx_clk(tx_clk),
	.tx_rst(tx_rst),
	.tx_axis_tdata(tx_axis_tdata),
	.tx_axis_tvalid(tx_axis_tvalid),
	.tx_axis_tready(tx_axis_tready),
	.tx_axis_tlast(tx_axis_tlast),
	.tx_axis_tuser(tx_axis_tuser),
	.rx_axis_tdata(rx_axis_tdata),
	.rx_axis_tvalid(rx_axis_tvalid),
	.rx_axis_tlast(rx_axis_tlast),
	.rx_axis_tuser(rx_axis_tuser),
	.rgmii_rx_clk(rgmii_rxc),
	.rgmii_rxd(rgmii_rxd_d),
	.rgmii_rx_ctl(rgmii_rx_ctl_d),
	.rgmii_tx_clk(rgmii_txc),
	.rgmii_txd(rgmii_txd),
	.rgmii_tx_ctl(rgmii_tx_ctl),
	.tx_error_underflow(status_tx_error_underflow),
	.rx_error_bad_frame(status_rx_error_bad_frame),
	.rx_error_bad_fcs(status_rx_error_bad_fcs),
	.speed(status_speed),
	.ifg_delay(IFG_DELAY)
);

/* Tx FIFO */

xpm_fifo_axis #(
	.CDC_SYNC_STAGES(2),
	.CLOCKING_MODE("independent_clock"),
	.ECC_MODE("no_ecc"),
	.FIFO_DEPTH(2048),
	.FIFO_MEMORY_TYPE("auto"),
	.PACKET_FIFO("true"),
	.PROG_EMPTY_THRESH(10),
	.PROG_FULL_THRESH(10),
	.RD_DATA_COUNT_WIDTH(1),
	.RELATED_CLOCKS(0),
	.TDATA_WIDTH(8),
	.TDEST_WIDTH(1),
	.TID_WIDTH(1),
	.TUSER_WIDTH(1),
	.USE_ADV_FEATURES("1000"),
	.WR_DATA_COUNT_WIDTH(1)
) xpm_fifo_axis_tx (
	.s_aclk(aclk),
	.s_aresetn(aresetn),
	.s_axis_tdata(s_axis_tdata),
	.s_axis_tuser(0),
	.s_axis_tvalid(s_axis_tvalid),
	.s_axis_tready(s_axis_tready),
	.s_axis_tlast(s_axis_tlast),
	.s_axis_tdest(1'b0),
	.s_axis_tid(1'b0),
	.s_axis_tkeep(1'b1),
	.s_axis_tstrb(1'b1),
	.m_aclk(tx_clk),
	.m_axis_tdata(tx_axis_tdata),
	.m_axis_tuser(tx_axis_tuser),
	.m_axis_tvalid(tx_axis_tvalid),
	.m_axis_tready(tx_axis_tready),
	.m_axis_tlast(tx_axis_tlast),
	.m_axis_tdest(),
	.m_axis_tid(),
	.m_axis_tkeep(),
	.m_axis_tstrb()
);

/* Rx FIFO */

xpm_fifo_axis #(
	.CDC_SYNC_STAGES(2),
	.CLOCKING_MODE("independent_clock"),
	.ECC_MODE("no_ecc"),
	.FIFO_DEPTH(2048),
	.FIFO_MEMORY_TYPE("auto"),
	.PACKET_FIFO("false"),
	.PROG_EMPTY_THRESH(10),
	.PROG_FULL_THRESH(10),
	.RD_DATA_COUNT_WIDTH(1),
	.RELATED_CLOCKS(0),
	.TDATA_WIDTH(8),
	.TDEST_WIDTH(1),
	.TID_WIDTH(1),
	.TUSER_WIDTH(1),
	.USE_ADV_FEATURES("1000"),
	.WR_DATA_COUNT_WIDTH(1)
) xpm_fifo_axis_rx (
	.s_aclk(rx_clk),
	.s_aresetn(~rx_rst),
	.s_axis_tdata(rx_axis_tdata),
	.s_axis_tuser(rx_axis_tuser),
	.s_axis_tvalid(rx_axis_tvalid),
	.s_axis_tready(),
	.s_axis_tlast(rx_axis_tlast),
	.s_axis_tdest(1'b0),
	.s_axis_tid(1'b0),
	.s_axis_tkeep(1'b1),
	.s_axis_tstrb(1'b1),
	.m_aclk(aclk),
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tuser(),
	.m_axis_tvalid(m_axis_tvalid),
	.m_axis_tready(m_axis_tready),
	.m_axis_tlast(m_axis_tlast),
	.m_axis_tdest(),
	.m_axis_tid(),
	.m_axis_tkeep(),
	.m_axis_tstrb()
);

/* CDC */
wire src_rcv;
xpm_cdc_handshake #(
	.DEST_EXT_HSK(0),
	.DEST_SYNC_FF(4),
	.INIT_SYNC_FF(0),
	.SIM_ASSERT_CHK(0),
	.SRC_SYNC_FF(4),
	.WIDTH(2)
) xpm_cdc_handshake_speed (
	.dest_out(speed),
	.dest_req(),
	.src_rcv(src_rcv),
	.dest_ack(),
	.dest_clk(aclk),
	.src_clk(tx_clk),
	.src_in(status_speed),
	.src_send(~src_rcv)
);

endmodule
