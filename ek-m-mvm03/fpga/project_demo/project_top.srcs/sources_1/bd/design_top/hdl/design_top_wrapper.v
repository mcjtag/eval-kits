//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Fri Jul  5 17:11:08 2019
//Host        : matyunin-d running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target design_top_wrapper.bd
//Design      : design_top_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_top_wrapper
   (DDR3_addr,
    DDR3_ba,
    DDR3_cas_n,
    DDR3_ck_n,
    DDR3_ck_p,
    DDR3_cke,
    DDR3_cs_n,
    DDR3_dm,
    DDR3_dq,
    DDR3_dqs_n,
    DDR3_dqs_p,
    DDR3_odt,
    DDR3_ras_n,
    DDR3_reset_n,
    DDR3_we_n,
    audio_i2s_bclk,
    audio_i2s_din,
    audio_i2s_dout,
    audio_i2s_lrcin,
    audio_i2s_lrcout,
    audio_spi_io0_io,
    audio_spi_io1_io,
    audio_spi_sck_io,
    audio_spi_ss_io,
    bus_freq_div,
    clk_gen0_oe,
    clk_gen0_sclk,
    clk_gen0_ss,
    clk_gen1_oe,
    clk_gen1_sclk,
    clk_gen1_ss,
    dsp_bus_freq_tri_i,
    dsp_core_freq_tri_i,
    dsp_pll_divr,
    dsp_reset_tri_io,
    dsp_temp_scl_io,
    dsp_temp_sda_io,
    dsp_vadc_spi_io0_io,
    dsp_vadc_spi_io1_io,
    dsp_vadc_spi_sck_io,
    dsp_vadc_spi_ss_io,
    gpio_scl_io,
    gpio_sda_io,
    led_fast,
    link0_rx_lxack,
    link0_rx_lxbcmp,
    link0_rx_lxclkn,
    link0_rx_lxclkp,
    link0_rx_lxdatn,
    link0_rx_lxdatp,
    link0_tx_lxack,
    link0_tx_lxbcmp,
    link0_tx_lxclkn,
    link0_tx_lxclkp,
    link0_tx_lxdatn,
    link0_tx_lxdatp,
    link1_rx_lxack,
    link1_rx_lxbcmp,
    link1_rx_lxclkn,
    link1_rx_lxclkp,
    link1_rx_lxdatn,
    link1_rx_lxdatp,
    link1_tx_lxack,
    link1_tx_lxbcmp,
    link1_tx_lxclkn,
    link1_tx_lxclkp,
    link1_tx_lxdatn,
    link1_tx_lxdatp,
    mdc,
    mdio,
    phy_rst,
    rdr_scl,
    rgmii_rd,
    rgmii_rx_ctl,
    rgmii_rxc,
    rgmii_td,
    rgmii_tx_ctl,
    rgmii_txc,
    sys_clk_n,
    sys_clk_p,
    tft_gpi,
    tft_gpo,
    tft_spi_io0_io,
    tft_spi_io1_io,
    tft_spi_sck_io,
    tft_spi_ss_io,
    uart_rx,
    uart_tx);
  output [13:0]DDR3_addr;
  output [2:0]DDR3_ba;
  output DDR3_cas_n;
  output [0:0]DDR3_ck_n;
  output [0:0]DDR3_ck_p;
  output [0:0]DDR3_cke;
  output [0:0]DDR3_cs_n;
  output [3:0]DDR3_dm;
  inout [31:0]DDR3_dq;
  inout [3:0]DDR3_dqs_n;
  inout [3:0]DDR3_dqs_p;
  output [0:0]DDR3_odt;
  output DDR3_ras_n;
  output DDR3_reset_n;
  output DDR3_we_n;
  output audio_i2s_bclk;
  input audio_i2s_din;
  output audio_i2s_dout;
  output audio_i2s_lrcin;
  output audio_i2s_lrcout;
  inout audio_spi_io0_io;
  inout audio_spi_io1_io;
  inout audio_spi_sck_io;
  inout [0:0]audio_spi_ss_io;
  inout [1:0]bus_freq_div;
  output [1:0]clk_gen0_oe;
  output [0:0]clk_gen0_sclk;
  output [1:0]clk_gen0_ss;
  output [0:0]clk_gen1_oe;
  output [0:0]clk_gen1_sclk;
  output [1:0]clk_gen1_ss;
  input [1:0]dsp_bus_freq_tri_i;
  input [1:0]dsp_core_freq_tri_i;
  output [4:0]dsp_pll_divr;
  inout [0:0]dsp_reset_tri_io;
  inout dsp_temp_scl_io;
  inout dsp_temp_sda_io;
  inout dsp_vadc_spi_io0_io;
  inout dsp_vadc_spi_io1_io;
  inout dsp_vadc_spi_sck_io;
  inout [2:0]dsp_vadc_spi_ss_io;
  inout gpio_scl_io;
  inout gpio_sda_io;
  output [3:0]led_fast;
  output link0_rx_lxack;
  input link0_rx_lxbcmp;
  input link0_rx_lxclkn;
  input link0_rx_lxclkp;
  input [3:0]link0_rx_lxdatn;
  input [3:0]link0_rx_lxdatp;
  input link0_tx_lxack;
  output link0_tx_lxbcmp;
  output link0_tx_lxclkn;
  output link0_tx_lxclkp;
  output [3:0]link0_tx_lxdatn;
  output [3:0]link0_tx_lxdatp;
  output link1_rx_lxack;
  input link1_rx_lxbcmp;
  input link1_rx_lxclkn;
  input link1_rx_lxclkp;
  input [3:0]link1_rx_lxdatn;
  input [3:0]link1_rx_lxdatp;
  input link1_tx_lxack;
  output link1_tx_lxbcmp;
  output link1_tx_lxclkn;
  output link1_tx_lxclkp;
  output [3:0]link1_tx_lxdatn;
  output [3:0]link1_tx_lxdatp;
  output mdc;
  output mdio;
  output phy_rst;
  output [0:0]rdr_scl;
  input [3:0]rgmii_rd;
  input rgmii_rx_ctl;
  input rgmii_rxc;
  output [3:0]rgmii_td;
  output rgmii_tx_ctl;
  output rgmii_txc;
  input sys_clk_n;
  input sys_clk_p;
  input [1:0]tft_gpi;
  output [1:0]tft_gpo;
  inout tft_spi_io0_io;
  inout tft_spi_io1_io;
  inout tft_spi_sck_io;
  inout [2:0]tft_spi_ss_io;
  input [0:0]uart_rx;
  output [0:0]uart_tx;

  wire [13:0]DDR3_addr;
  wire [2:0]DDR3_ba;
  wire DDR3_cas_n;
  wire [0:0]DDR3_ck_n;
  wire [0:0]DDR3_ck_p;
  wire [0:0]DDR3_cke;
  wire [0:0]DDR3_cs_n;
  wire [3:0]DDR3_dm;
  wire [31:0]DDR3_dq;
  wire [3:0]DDR3_dqs_n;
  wire [3:0]DDR3_dqs_p;
  wire [0:0]DDR3_odt;
  wire DDR3_ras_n;
  wire DDR3_reset_n;
  wire DDR3_we_n;
  wire audio_i2s_bclk;
  wire audio_i2s_din;
  wire audio_i2s_dout;
  wire audio_i2s_lrcin;
  wire audio_i2s_lrcout;
  wire audio_spi_io0_i;
  wire audio_spi_io0_io;
  wire audio_spi_io0_o;
  wire audio_spi_io0_t;
  wire audio_spi_io1_i;
  wire audio_spi_io1_io;
  wire audio_spi_io1_o;
  wire audio_spi_io1_t;
  wire audio_spi_sck_i;
  wire audio_spi_sck_io;
  wire audio_spi_sck_o;
  wire audio_spi_sck_t;
  wire [0:0]audio_spi_ss_i_0;
  wire [0:0]audio_spi_ss_io_0;
  wire [0:0]audio_spi_ss_o_0;
  wire audio_spi_ss_t;
  wire [1:0]bus_freq_div;
  wire [1:0]clk_gen0_oe;
  wire [0:0]clk_gen0_sclk;
  wire [1:0]clk_gen0_ss;
  wire [0:0]clk_gen1_oe;
  wire [0:0]clk_gen1_sclk;
  wire [1:0]clk_gen1_ss;
  wire [1:0]dsp_bus_freq_tri_i;
  wire [1:0]dsp_core_freq_tri_i;
  wire [4:0]dsp_pll_divr;
  wire [0:0]dsp_reset_tri_i_0;
  wire [0:0]dsp_reset_tri_io_0;
  wire [0:0]dsp_reset_tri_o_0;
  wire [0:0]dsp_reset_tri_t_0;
  wire dsp_temp_scl_i;
  wire dsp_temp_scl_io;
  wire dsp_temp_scl_o;
  wire dsp_temp_scl_t;
  wire dsp_temp_sda_i;
  wire dsp_temp_sda_io;
  wire dsp_temp_sda_o;
  wire dsp_temp_sda_t;
  wire dsp_vadc_spi_io0_i;
  wire dsp_vadc_spi_io0_io;
  wire dsp_vadc_spi_io0_o;
  wire dsp_vadc_spi_io0_t;
  wire dsp_vadc_spi_io1_i;
  wire dsp_vadc_spi_io1_io;
  wire dsp_vadc_spi_io1_o;
  wire dsp_vadc_spi_io1_t;
  wire dsp_vadc_spi_sck_i;
  wire dsp_vadc_spi_sck_io;
  wire dsp_vadc_spi_sck_o;
  wire dsp_vadc_spi_sck_t;
  wire [0:0]dsp_vadc_spi_ss_i_0;
  wire [1:1]dsp_vadc_spi_ss_i_1;
  wire [2:2]dsp_vadc_spi_ss_i_2;
  wire [0:0]dsp_vadc_spi_ss_io_0;
  wire [1:1]dsp_vadc_spi_ss_io_1;
  wire [2:2]dsp_vadc_spi_ss_io_2;
  wire [0:0]dsp_vadc_spi_ss_o_0;
  wire [1:1]dsp_vadc_spi_ss_o_1;
  wire [2:2]dsp_vadc_spi_ss_o_2;
  wire dsp_vadc_spi_ss_t;
  wire gpio_scl_i;
  wire gpio_scl_io;
  wire gpio_scl_o;
  wire gpio_scl_t;
  wire gpio_sda_i;
  wire gpio_sda_io;
  wire gpio_sda_o;
  wire gpio_sda_t;
  wire [3:0]led_fast;
  wire link0_rx_lxack;
  wire link0_rx_lxbcmp;
  wire link0_rx_lxclkn;
  wire link0_rx_lxclkp;
  wire [3:0]link0_rx_lxdatn;
  wire [3:0]link0_rx_lxdatp;
  wire link0_tx_lxack;
  wire link0_tx_lxbcmp;
  wire link0_tx_lxclkn;
  wire link0_tx_lxclkp;
  wire [3:0]link0_tx_lxdatn;
  wire [3:0]link0_tx_lxdatp;
  wire link1_rx_lxack;
  wire link1_rx_lxbcmp;
  wire link1_rx_lxclkn;
  wire link1_rx_lxclkp;
  wire [3:0]link1_rx_lxdatn;
  wire [3:0]link1_rx_lxdatp;
  wire link1_tx_lxack;
  wire link1_tx_lxbcmp;
  wire link1_tx_lxclkn;
  wire link1_tx_lxclkp;
  wire [3:0]link1_tx_lxdatn;
  wire [3:0]link1_tx_lxdatp;
  wire mdc;
  wire mdio;
  wire phy_rst;
  wire [0:0]rdr_scl;
  wire [3:0]rgmii_rd;
  wire rgmii_rx_ctl;
  wire rgmii_rxc;
  wire [3:0]rgmii_td;
  wire rgmii_tx_ctl;
  wire rgmii_txc;
  wire sys_clk_n;
  wire sys_clk_p;
  wire [1:0]tft_gpi;
  wire [1:0]tft_gpo;
  wire tft_spi_io0_i;
  wire tft_spi_io0_io;
  wire tft_spi_io0_o;
  wire tft_spi_io0_t;
  wire tft_spi_io1_i;
  wire tft_spi_io1_io;
  wire tft_spi_io1_o;
  wire tft_spi_io1_t;
  wire tft_spi_sck_i;
  wire tft_spi_sck_io;
  wire tft_spi_sck_o;
  wire tft_spi_sck_t;
  wire [0:0]tft_spi_ss_i_0;
  wire [1:1]tft_spi_ss_i_1;
  wire [2:2]tft_spi_ss_i_2;
  wire [0:0]tft_spi_ss_io_0;
  wire [1:1]tft_spi_ss_io_1;
  wire [2:2]tft_spi_ss_io_2;
  wire [0:0]tft_spi_ss_o_0;
  wire [1:1]tft_spi_ss_o_1;
  wire [2:2]tft_spi_ss_o_2;
  wire tft_spi_ss_t;
  wire [0:0]uart_rx;
  wire [0:0]uart_tx;

  IOBUF audio_spi_io0_iobuf
       (.I(audio_spi_io0_o),
        .IO(audio_spi_io0_io),
        .O(audio_spi_io0_i),
        .T(audio_spi_io0_t));
  IOBUF audio_spi_io1_iobuf
       (.I(audio_spi_io1_o),
        .IO(audio_spi_io1_io),
        .O(audio_spi_io1_i),
        .T(audio_spi_io1_t));
  IOBUF audio_spi_sck_iobuf
       (.I(audio_spi_sck_o),
        .IO(audio_spi_sck_io),
        .O(audio_spi_sck_i),
        .T(audio_spi_sck_t));
  IOBUF audio_spi_ss_iobuf_0
       (.I(audio_spi_ss_o_0),
        .IO(audio_spi_ss_io[0]),
        .O(audio_spi_ss_i_0),
        .T(audio_spi_ss_t));
  design_top design_top_i
       (.DDR3_addr(DDR3_addr),
        .DDR3_ba(DDR3_ba),
        .DDR3_cas_n(DDR3_cas_n),
        .DDR3_ck_n(DDR3_ck_n),
        .DDR3_ck_p(DDR3_ck_p),
        .DDR3_cke(DDR3_cke),
        .DDR3_cs_n(DDR3_cs_n),
        .DDR3_dm(DDR3_dm),
        .DDR3_dq(DDR3_dq),
        .DDR3_dqs_n(DDR3_dqs_n),
        .DDR3_dqs_p(DDR3_dqs_p),
        .DDR3_odt(DDR3_odt),
        .DDR3_ras_n(DDR3_ras_n),
        .DDR3_reset_n(DDR3_reset_n),
        .DDR3_we_n(DDR3_we_n),
        .audio_i2s_bclk(audio_i2s_bclk),
        .audio_i2s_din(audio_i2s_din),
        .audio_i2s_dout(audio_i2s_dout),
        .audio_i2s_lrcin(audio_i2s_lrcin),
        .audio_i2s_lrcout(audio_i2s_lrcout),
        .audio_spi_io0_i(audio_spi_io0_i),
        .audio_spi_io0_o(audio_spi_io0_o),
        .audio_spi_io0_t(audio_spi_io0_t),
        .audio_spi_io1_i(audio_spi_io1_i),
        .audio_spi_io1_o(audio_spi_io1_o),
        .audio_spi_io1_t(audio_spi_io1_t),
        .audio_spi_sck_i(audio_spi_sck_i),
        .audio_spi_sck_o(audio_spi_sck_o),
        .audio_spi_sck_t(audio_spi_sck_t),
        .audio_spi_ss_i(audio_spi_ss_i_0),
        .audio_spi_ss_o(audio_spi_ss_o_0),
        .audio_spi_ss_t(audio_spi_ss_t),
        .bus_freq_div(bus_freq_div),
        .clk_gen0_oe(clk_gen0_oe),
        .clk_gen0_sclk(clk_gen0_sclk),
        .clk_gen0_ss(clk_gen0_ss),
        .clk_gen1_oe(clk_gen1_oe),
        .clk_gen1_sclk(clk_gen1_sclk),
        .clk_gen1_ss(clk_gen1_ss),
        .dsp_bus_freq_tri_i(dsp_bus_freq_tri_i),
        .dsp_core_freq_tri_i(dsp_core_freq_tri_i),
        .dsp_pll_divr(dsp_pll_divr),
        .dsp_reset_tri_i(dsp_reset_tri_i_0),
        .dsp_reset_tri_o(dsp_reset_tri_o_0),
        .dsp_reset_tri_t(dsp_reset_tri_t_0),
        .dsp_temp_scl_i(dsp_temp_scl_i),
        .dsp_temp_scl_o(dsp_temp_scl_o),
        .dsp_temp_scl_t(dsp_temp_scl_t),
        .dsp_temp_sda_i(dsp_temp_sda_i),
        .dsp_temp_sda_o(dsp_temp_sda_o),
        .dsp_temp_sda_t(dsp_temp_sda_t),
        .dsp_vadc_spi_io0_i(dsp_vadc_spi_io0_i),
        .dsp_vadc_spi_io0_o(dsp_vadc_spi_io0_o),
        .dsp_vadc_spi_io0_t(dsp_vadc_spi_io0_t),
        .dsp_vadc_spi_io1_i(dsp_vadc_spi_io1_i),
        .dsp_vadc_spi_io1_o(dsp_vadc_spi_io1_o),
        .dsp_vadc_spi_io1_t(dsp_vadc_spi_io1_t),
        .dsp_vadc_spi_sck_i(dsp_vadc_spi_sck_i),
        .dsp_vadc_spi_sck_o(dsp_vadc_spi_sck_o),
        .dsp_vadc_spi_sck_t(dsp_vadc_spi_sck_t),
        .dsp_vadc_spi_ss_i({dsp_vadc_spi_ss_i_2,dsp_vadc_spi_ss_i_1,dsp_vadc_spi_ss_i_0}),
        .dsp_vadc_spi_ss_o({dsp_vadc_spi_ss_o_2,dsp_vadc_spi_ss_o_1,dsp_vadc_spi_ss_o_0}),
        .dsp_vadc_spi_ss_t(dsp_vadc_spi_ss_t),
        .gpio_scl_i(gpio_scl_i),
        .gpio_scl_o(gpio_scl_o),
        .gpio_scl_t(gpio_scl_t),
        .gpio_sda_i(gpio_sda_i),
        .gpio_sda_o(gpio_sda_o),
        .gpio_sda_t(gpio_sda_t),
        .led_fast(led_fast),
        .link0_rx_lxack(link0_rx_lxack),
        .link0_rx_lxbcmp(link0_rx_lxbcmp),
        .link0_rx_lxclkn(link0_rx_lxclkn),
        .link0_rx_lxclkp(link0_rx_lxclkp),
        .link0_rx_lxdatn(link0_rx_lxdatn),
        .link0_rx_lxdatp(link0_rx_lxdatp),
        .link0_tx_lxack(link0_tx_lxack),
        .link0_tx_lxbcmp(link0_tx_lxbcmp),
        .link0_tx_lxclkn(link0_tx_lxclkn),
        .link0_tx_lxclkp(link0_tx_lxclkp),
        .link0_tx_lxdatn(link0_tx_lxdatn),
        .link0_tx_lxdatp(link0_tx_lxdatp),
        .link1_rx_lxack(link1_rx_lxack),
        .link1_rx_lxbcmp(link1_rx_lxbcmp),
        .link1_rx_lxclkn(link1_rx_lxclkn),
        .link1_rx_lxclkp(link1_rx_lxclkp),
        .link1_rx_lxdatn(link1_rx_lxdatn),
        .link1_rx_lxdatp(link1_rx_lxdatp),
        .link1_tx_lxack(link1_tx_lxack),
        .link1_tx_lxbcmp(link1_tx_lxbcmp),
        .link1_tx_lxclkn(link1_tx_lxclkn),
        .link1_tx_lxclkp(link1_tx_lxclkp),
        .link1_tx_lxdatn(link1_tx_lxdatn),
        .link1_tx_lxdatp(link1_tx_lxdatp),
        .mdc(mdc),
        .mdio(mdio),
        .phy_rst(phy_rst),
        .rdr_scl(rdr_scl),
        .rgmii_rd(rgmii_rd),
        .rgmii_rx_ctl(rgmii_rx_ctl),
        .rgmii_rxc(rgmii_rxc),
        .rgmii_td(rgmii_td),
        .rgmii_tx_ctl(rgmii_tx_ctl),
        .rgmii_txc(rgmii_txc),
        .sys_clk_n(sys_clk_n),
        .sys_clk_p(sys_clk_p),
        .tft_gpi(tft_gpi),
        .tft_gpo(tft_gpo),
        .tft_spi_io0_i(tft_spi_io0_i),
        .tft_spi_io0_o(tft_spi_io0_o),
        .tft_spi_io0_t(tft_spi_io0_t),
        .tft_spi_io1_i(tft_spi_io1_i),
        .tft_spi_io1_o(tft_spi_io1_o),
        .tft_spi_io1_t(tft_spi_io1_t),
        .tft_spi_sck_i(tft_spi_sck_i),
        .tft_spi_sck_o(tft_spi_sck_o),
        .tft_spi_sck_t(tft_spi_sck_t),
        .tft_spi_ss_i({tft_spi_ss_i_2,tft_spi_ss_i_1,tft_spi_ss_i_0}),
        .tft_spi_ss_o({tft_spi_ss_o_2,tft_spi_ss_o_1,tft_spi_ss_o_0}),
        .tft_spi_ss_t(tft_spi_ss_t),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx));
  IOBUF dsp_reset_tri_iobuf_0
       (.I(dsp_reset_tri_o_0),
        .IO(dsp_reset_tri_io[0]),
        .O(dsp_reset_tri_i_0),
        .T(dsp_reset_tri_t_0));
  IOBUF dsp_temp_scl_iobuf
       (.I(dsp_temp_scl_o),
        .IO(dsp_temp_scl_io),
        .O(dsp_temp_scl_i),
        .T(dsp_temp_scl_t));
  IOBUF dsp_temp_sda_iobuf
       (.I(dsp_temp_sda_o),
        .IO(dsp_temp_sda_io),
        .O(dsp_temp_sda_i),
        .T(dsp_temp_sda_t));
  IOBUF dsp_vadc_spi_io0_iobuf
       (.I(dsp_vadc_spi_io0_o),
        .IO(dsp_vadc_spi_io0_io),
        .O(dsp_vadc_spi_io0_i),
        .T(dsp_vadc_spi_io0_t));
  IOBUF dsp_vadc_spi_io1_iobuf
       (.I(dsp_vadc_spi_io1_o),
        .IO(dsp_vadc_spi_io1_io),
        .O(dsp_vadc_spi_io1_i),
        .T(dsp_vadc_spi_io1_t));
  IOBUF dsp_vadc_spi_sck_iobuf
       (.I(dsp_vadc_spi_sck_o),
        .IO(dsp_vadc_spi_sck_io),
        .O(dsp_vadc_spi_sck_i),
        .T(dsp_vadc_spi_sck_t));
  IOBUF dsp_vadc_spi_ss_iobuf_0
       (.I(dsp_vadc_spi_ss_o_0),
        .IO(dsp_vadc_spi_ss_io[0]),
        .O(dsp_vadc_spi_ss_i_0),
        .T(dsp_vadc_spi_ss_t));
  IOBUF dsp_vadc_spi_ss_iobuf_1
       (.I(dsp_vadc_spi_ss_o_1),
        .IO(dsp_vadc_spi_ss_io[1]),
        .O(dsp_vadc_spi_ss_i_1),
        .T(dsp_vadc_spi_ss_t));
  IOBUF dsp_vadc_spi_ss_iobuf_2
       (.I(dsp_vadc_spi_ss_o_2),
        .IO(dsp_vadc_spi_ss_io[2]),
        .O(dsp_vadc_spi_ss_i_2),
        .T(dsp_vadc_spi_ss_t));
  IOBUF gpio_scl_iobuf
       (.I(gpio_scl_o),
        .IO(gpio_scl_io),
        .O(gpio_scl_i),
        .T(gpio_scl_t));
  IOBUF gpio_sda_iobuf
       (.I(gpio_sda_o),
        .IO(gpio_sda_io),
        .O(gpio_sda_i),
        .T(gpio_sda_t));
  IOBUF tft_spi_io0_iobuf
       (.I(tft_spi_io0_o),
        .IO(tft_spi_io0_io),
        .O(tft_spi_io0_i),
        .T(tft_spi_io0_t));
  IOBUF tft_spi_io1_iobuf
       (.I(tft_spi_io1_o),
        .IO(tft_spi_io1_io),
        .O(tft_spi_io1_i),
        .T(tft_spi_io1_t));
  IOBUF tft_spi_sck_iobuf
       (.I(tft_spi_sck_o),
        .IO(tft_spi_sck_io),
        .O(tft_spi_sck_i),
        .T(tft_spi_sck_t));
  IOBUF tft_spi_ss_iobuf_0
       (.I(tft_spi_ss_o_0),
        .IO(tft_spi_ss_io[0]),
        .O(tft_spi_ss_i_0),
        .T(tft_spi_ss_t));
  IOBUF tft_spi_ss_iobuf_1
       (.I(tft_spi_ss_o_1),
        .IO(tft_spi_ss_io[1]),
        .O(tft_spi_ss_i_1),
        .T(tft_spi_ss_t));
  IOBUF tft_spi_ss_iobuf_2
       (.I(tft_spi_ss_o_2),
        .IO(tft_spi_ss_io[2]),
        .O(tft_spi_ss_i_2),
        .T(tft_spi_ss_t));
endmodule
