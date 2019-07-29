//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Thu Jul 25 11:44:36 2019
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
    ad9520_cs,
    ad9520_ld,
    ad9520_pd,
    ad9520_refmon,
    ad9520_reset,
    ad9520_sclk,
    ad9520_sdi,
    ad9520_sdo,
    ad9520_status,
    ad9520_sync,
    clk_ref,
    dsp0_boot,
    dsp1_boot,
    dsp_coh_a,
    dsp_coh_b,
    dsp_dmar0,
    dsp_dmar1,
    dsp_irq0,
    dsp_irq1,
    dsp_reset,
    dsp_reset_all,
    glclk,
    hmc1031_d,
    hmc1031_lkdop,
    led,
    link0_rx_lxack,
    link0_rx_lxbcmp,
    link0_rx_lxclkn,
    link0_rx_lxclkp,
    link0_rx_lxdatn,
    link0_rx_lxdatp,
    link1_rx_lxack,
    link1_rx_lxbcmp,
    link1_rx_lxclkn,
    link1_rx_lxclkp,
    link1_rx_lxdatn,
    link1_rx_lxdatp,
    mdc,
    mdio,
    phy_rst,
    rgmii_rd,
    rgmii_rx_ctl,
    rgmii_rxc,
    rgmii_td,
    rgmii_tx_ctl,
    rgmii_txc,
    sys_clk_n,
    sys_clk_p,
    tft_lcd_blue,
    tft_lcd_clk,
    tft_lcd_de,
    tft_lcd_dps,
    tft_lcd_green,
    tft_lcd_hsync,
    tft_lcd_pwm,
    tft_lcd_red,
    tft_lcd_vsync,
    usr_sw);
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
  output [0:0]ad9520_cs;
  input [0:0]ad9520_ld;
  output [0:0]ad9520_pd;
  input [0:0]ad9520_refmon;
  output [0:0]ad9520_reset;
  output ad9520_sclk;
  input ad9520_sdi;
  output ad9520_sdo;
  input [0:0]ad9520_status;
  output [0:0]ad9520_sync;
  output clk_ref;
  input [2:0]dsp0_boot;
  input [2:0]dsp1_boot;
  output [1:0]dsp_coh_a;
  output [1:0]dsp_coh_b;
  output [1:0]dsp_dmar0;
  output [1:0]dsp_dmar1;
  output [1:0]dsp_irq0;
  output [1:0]dsp_irq1;
  output [1:0]dsp_reset;
  output dsp_reset_all;
  output glclk;
  output [1:0]hmc1031_d;
  input hmc1031_lkdop;
  output [7:0]led;
  output link0_rx_lxack;
  input link0_rx_lxbcmp;
  input link0_rx_lxclkn;
  input link0_rx_lxclkp;
  input [3:0]link0_rx_lxdatn;
  input [3:0]link0_rx_lxdatp;
  output link1_rx_lxack;
  input link1_rx_lxbcmp;
  input link1_rx_lxclkn;
  input link1_rx_lxclkp;
  input [3:0]link1_rx_lxdatn;
  input [3:0]link1_rx_lxdatp;
  output mdc;
  output mdio;
  output phy_rst;
  input [3:0]rgmii_rd;
  input rgmii_rx_ctl;
  input rgmii_rxc;
  output [3:0]rgmii_td;
  output rgmii_tx_ctl;
  output rgmii_txc;
  input sys_clk_n;
  input sys_clk_p;
  output [5:0]tft_lcd_blue;
  output tft_lcd_clk;
  output tft_lcd_de;
  output tft_lcd_dps;
  output [5:0]tft_lcd_green;
  output tft_lcd_hsync;
  output tft_lcd_pwm;
  output [5:0]tft_lcd_red;
  output tft_lcd_vsync;
  input [3:0]usr_sw;

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
  wire [0:0]ad9520_cs;
  wire [0:0]ad9520_ld;
  wire [0:0]ad9520_pd;
  wire [0:0]ad9520_refmon;
  wire [0:0]ad9520_reset;
  wire ad9520_sclk;
  wire ad9520_sdi;
  wire ad9520_sdo;
  wire [0:0]ad9520_status;
  wire [0:0]ad9520_sync;
  wire clk_ref;
  wire [2:0]dsp0_boot;
  wire [2:0]dsp1_boot;
  wire [1:0]dsp_coh_a;
  wire [1:0]dsp_coh_b;
  wire [1:0]dsp_dmar0;
  wire [1:0]dsp_dmar1;
  wire [1:0]dsp_irq0;
  wire [1:0]dsp_irq1;
  wire [1:0]dsp_reset;
  wire dsp_reset_all;
  wire glclk;
  wire [1:0]hmc1031_d;
  wire hmc1031_lkdop;
  wire [7:0]led;
  wire link0_rx_lxack;
  wire link0_rx_lxbcmp;
  wire link0_rx_lxclkn;
  wire link0_rx_lxclkp;
  wire [3:0]link0_rx_lxdatn;
  wire [3:0]link0_rx_lxdatp;
  wire link1_rx_lxack;
  wire link1_rx_lxbcmp;
  wire link1_rx_lxclkn;
  wire link1_rx_lxclkp;
  wire [3:0]link1_rx_lxdatn;
  wire [3:0]link1_rx_lxdatp;
  wire mdc;
  wire mdio;
  wire phy_rst;
  wire [3:0]rgmii_rd;
  wire rgmii_rx_ctl;
  wire rgmii_rxc;
  wire [3:0]rgmii_td;
  wire rgmii_tx_ctl;
  wire rgmii_txc;
  wire sys_clk_n;
  wire sys_clk_p;
  wire [5:0]tft_lcd_blue;
  wire tft_lcd_clk;
  wire tft_lcd_de;
  wire tft_lcd_dps;
  wire [5:0]tft_lcd_green;
  wire tft_lcd_hsync;
  wire tft_lcd_pwm;
  wire [5:0]tft_lcd_red;
  wire tft_lcd_vsync;
  wire [3:0]usr_sw;

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
        .ad9520_cs(ad9520_cs),
        .ad9520_ld(ad9520_ld),
        .ad9520_pd(ad9520_pd),
        .ad9520_refmon(ad9520_refmon),
        .ad9520_reset(ad9520_reset),
        .ad9520_sclk(ad9520_sclk),
        .ad9520_sdi(ad9520_sdi),
        .ad9520_sdo(ad9520_sdo),
        .ad9520_status(ad9520_status),
        .ad9520_sync(ad9520_sync),
        .clk_ref(clk_ref),
        .dsp0_boot(dsp0_boot),
        .dsp1_boot(dsp1_boot),
        .dsp_coh_a(dsp_coh_a),
        .dsp_coh_b(dsp_coh_b),
        .dsp_dmar0(dsp_dmar0),
        .dsp_dmar1(dsp_dmar1),
        .dsp_irq0(dsp_irq0),
        .dsp_irq1(dsp_irq1),
        .dsp_reset(dsp_reset),
        .dsp_reset_all(dsp_reset_all),
        .glclk(glclk),
        .hmc1031_d(hmc1031_d),
        .hmc1031_lkdop(hmc1031_lkdop),
        .led(led),
        .link0_rx_lxack(link0_rx_lxack),
        .link0_rx_lxbcmp(link0_rx_lxbcmp),
        .link0_rx_lxclkn(link0_rx_lxclkn),
        .link0_rx_lxclkp(link0_rx_lxclkp),
        .link0_rx_lxdatn(link0_rx_lxdatn),
        .link0_rx_lxdatp(link0_rx_lxdatp),
        .link1_rx_lxack(link1_rx_lxack),
        .link1_rx_lxbcmp(link1_rx_lxbcmp),
        .link1_rx_lxclkn(link1_rx_lxclkn),
        .link1_rx_lxclkp(link1_rx_lxclkp),
        .link1_rx_lxdatn(link1_rx_lxdatn),
        .link1_rx_lxdatp(link1_rx_lxdatp),
        .mdc(mdc),
        .mdio(mdio),
        .phy_rst(phy_rst),
        .rgmii_rd(rgmii_rd),
        .rgmii_rx_ctl(rgmii_rx_ctl),
        .rgmii_rxc(rgmii_rxc),
        .rgmii_td(rgmii_td),
        .rgmii_tx_ctl(rgmii_tx_ctl),
        .rgmii_txc(rgmii_txc),
        .sys_clk_n(sys_clk_n),
        .sys_clk_p(sys_clk_p),
        .tft_lcd_blue(tft_lcd_blue),
        .tft_lcd_clk(tft_lcd_clk),
        .tft_lcd_de(tft_lcd_de),
        .tft_lcd_dps(tft_lcd_dps),
        .tft_lcd_green(tft_lcd_green),
        .tft_lcd_hsync(tft_lcd_hsync),
        .tft_lcd_pwm(tft_lcd_pwm),
        .tft_lcd_red(tft_lcd_red),
        .tft_lcd_vsync(tft_lcd_vsync),
        .usr_sw(usr_sw));
endmodule
