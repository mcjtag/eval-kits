//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Mon Sep 30 10:49:33 2019
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
    adc0_dq_adc_clk_n,
    adc0_dq_adc_clk_p,
    adc0_dq_adc_dq_n,
    adc0_dq_adc_dq_p,
    adc1_dq_adc_clk_n,
    adc1_dq_adc_clk_p,
    adc1_dq_adc_dq_n,
    adc1_dq_adc_dq_p,
    adc2_dq_adc_clk_n,
    adc2_dq_adc_clk_p,
    adc2_dq_adc_dq_n,
    adc2_dq_adc_dq_p,
    adc3_dq_adc_clk_n,
    adc3_dq_adc_clk_p,
    adc3_dq_adc_dq_n,
    adc3_dq_adc_dq_p,
    adc4_dq_adc_clk_n,
    adc4_dq_adc_clk_p,
    adc4_dq_adc_dq_n,
    adc4_dq_adc_dq_p,
    adc5_dq_adc_clk_n,
    adc5_dq_adc_clk_p,
    adc5_dq_adc_dq_n,
    adc5_dq_adc_dq_p,
    adc6_dq_adc_clk_n,
    adc6_dq_adc_clk_p,
    adc6_dq_adc_dq_n,
    adc6_dq_adc_dq_p,
    adc7_dq_adc_clk_n,
    adc7_dq_adc_clk_p,
    adc7_dq_adc_dq_n,
    adc7_dq_adc_dq_p,
    adc8_adc_amode,
    adc8_adc_spi_cs,
    adc8_adc_spi_miso,
    adc8_adc_spi_mosi,
    adc8_adc_spi_sclk,
    adc8_dst_ld,
    adc8_dst_pd,
    adc8_dst_refsel,
    adc8_dst_rst,
    adc8_dst_spi_cs,
    adc8_dst_spi_miso,
    adc8_dst_spi_mosi,
    adc8_dst_spi_sclk,
    adc8_dst_sync,
    clk_in,
    glclk,
    hmc1031_d,
    hmc1031_lkdop,
    hmc1033_cen,
    hmc1033_sck,
    hmc1033_sdi,
    hmc1033_sdo,
    hmc1033_sen,
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
    usr_btn,
    usr_led_a,
    usr_led_b,
    usr_sw);
  output [13:0]DDR3_addr;
  output [2:0]DDR3_ba;
  output DDR3_cas_n;
  output [0:0]DDR3_ck_n;
  output [0:0]DDR3_ck_p;
  output [0:0]DDR3_cke;
  output [0:0]DDR3_cs_n;
  output [7:0]DDR3_dm;
  inout [63:0]DDR3_dq;
  inout [7:0]DDR3_dqs_n;
  inout [7:0]DDR3_dqs_p;
  output [0:0]DDR3_odt;
  output DDR3_ras_n;
  output DDR3_reset_n;
  output DDR3_we_n;
  input adc0_dq_adc_clk_n;
  input adc0_dq_adc_clk_p;
  input [6:0]adc0_dq_adc_dq_n;
  input [6:0]adc0_dq_adc_dq_p;
  input adc1_dq_adc_clk_n;
  input adc1_dq_adc_clk_p;
  input [6:0]adc1_dq_adc_dq_n;
  input [6:0]adc1_dq_adc_dq_p;
  input adc2_dq_adc_clk_n;
  input adc2_dq_adc_clk_p;
  input [6:0]adc2_dq_adc_dq_n;
  input [6:0]adc2_dq_adc_dq_p;
  input adc3_dq_adc_clk_n;
  input adc3_dq_adc_clk_p;
  input [6:0]adc3_dq_adc_dq_n;
  input [6:0]adc3_dq_adc_dq_p;
  input adc4_dq_adc_clk_n;
  input adc4_dq_adc_clk_p;
  input [6:0]adc4_dq_adc_dq_n;
  input [6:0]adc4_dq_adc_dq_p;
  input adc5_dq_adc_clk_n;
  input adc5_dq_adc_clk_p;
  input [6:0]adc5_dq_adc_dq_n;
  input [6:0]adc5_dq_adc_dq_p;
  input adc6_dq_adc_clk_n;
  input adc6_dq_adc_clk_p;
  input [6:0]adc6_dq_adc_dq_n;
  input [6:0]adc6_dq_adc_dq_p;
  input adc7_dq_adc_clk_n;
  input adc7_dq_adc_clk_p;
  input [6:0]adc7_dq_adc_dq_n;
  input [6:0]adc7_dq_adc_dq_p;
  output [7:0]adc8_adc_amode;
  output [7:0]adc8_adc_spi_cs;
  input [7:0]adc8_adc_spi_miso;
  output [7:0]adc8_adc_spi_mosi;
  output [7:0]adc8_adc_spi_sclk;
  input adc8_dst_ld;
  output adc8_dst_pd;
  output adc8_dst_refsel;
  output adc8_dst_rst;
  output adc8_dst_spi_cs;
  input adc8_dst_spi_miso;
  output adc8_dst_spi_mosi;
  output adc8_dst_spi_sclk;
  output adc8_dst_sync;
  output clk_in;
  output glclk;
  output [1:0]hmc1031_d;
  input hmc1031_lkdop;
  output hmc1033_cen;
  output hmc1033_sck;
  output hmc1033_sdi;
  input hmc1033_sdo;
  output hmc1033_sen;
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
  input [7:0]usr_btn;
  output [7:0]usr_led_a;
  output [7:0]usr_led_b;
  input [7:0]usr_sw;

  wire [13:0]DDR3_addr;
  wire [2:0]DDR3_ba;
  wire DDR3_cas_n;
  wire [0:0]DDR3_ck_n;
  wire [0:0]DDR3_ck_p;
  wire [0:0]DDR3_cke;
  wire [0:0]DDR3_cs_n;
  wire [7:0]DDR3_dm;
  wire [63:0]DDR3_dq;
  wire [7:0]DDR3_dqs_n;
  wire [7:0]DDR3_dqs_p;
  wire [0:0]DDR3_odt;
  wire DDR3_ras_n;
  wire DDR3_reset_n;
  wire DDR3_we_n;
  wire adc0_dq_adc_clk_n;
  wire adc0_dq_adc_clk_p;
  wire [6:0]adc0_dq_adc_dq_n;
  wire [6:0]adc0_dq_adc_dq_p;
  wire adc1_dq_adc_clk_n;
  wire adc1_dq_adc_clk_p;
  wire [6:0]adc1_dq_adc_dq_n;
  wire [6:0]adc1_dq_adc_dq_p;
  wire adc2_dq_adc_clk_n;
  wire adc2_dq_adc_clk_p;
  wire [6:0]adc2_dq_adc_dq_n;
  wire [6:0]adc2_dq_adc_dq_p;
  wire adc3_dq_adc_clk_n;
  wire adc3_dq_adc_clk_p;
  wire [6:0]adc3_dq_adc_dq_n;
  wire [6:0]adc3_dq_adc_dq_p;
  wire adc4_dq_adc_clk_n;
  wire adc4_dq_adc_clk_p;
  wire [6:0]adc4_dq_adc_dq_n;
  wire [6:0]adc4_dq_adc_dq_p;
  wire adc5_dq_adc_clk_n;
  wire adc5_dq_adc_clk_p;
  wire [6:0]adc5_dq_adc_dq_n;
  wire [6:0]adc5_dq_adc_dq_p;
  wire adc6_dq_adc_clk_n;
  wire adc6_dq_adc_clk_p;
  wire [6:0]adc6_dq_adc_dq_n;
  wire [6:0]adc6_dq_adc_dq_p;
  wire adc7_dq_adc_clk_n;
  wire adc7_dq_adc_clk_p;
  wire [6:0]adc7_dq_adc_dq_n;
  wire [6:0]adc7_dq_adc_dq_p;
  wire [7:0]adc8_adc_amode;
  wire [7:0]adc8_adc_spi_cs;
  wire [7:0]adc8_adc_spi_miso;
  wire [7:0]adc8_adc_spi_mosi;
  wire [7:0]adc8_adc_spi_sclk;
  wire adc8_dst_ld;
  wire adc8_dst_pd;
  wire adc8_dst_refsel;
  wire adc8_dst_rst;
  wire adc8_dst_spi_cs;
  wire adc8_dst_spi_miso;
  wire adc8_dst_spi_mosi;
  wire adc8_dst_spi_sclk;
  wire adc8_dst_sync;
  wire clk_in;
  wire glclk;
  wire [1:0]hmc1031_d;
  wire hmc1031_lkdop;
  wire hmc1033_cen;
  wire hmc1033_sck;
  wire hmc1033_sdi;
  wire hmc1033_sdo;
  wire hmc1033_sen;
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
  wire [7:0]usr_btn;
  wire [7:0]usr_led_a;
  wire [7:0]usr_led_b;
  wire [7:0]usr_sw;

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
        .adc0_dq_adc_clk_n(adc0_dq_adc_clk_n),
        .adc0_dq_adc_clk_p(adc0_dq_adc_clk_p),
        .adc0_dq_adc_dq_n(adc0_dq_adc_dq_n),
        .adc0_dq_adc_dq_p(adc0_dq_adc_dq_p),
        .adc1_dq_adc_clk_n(adc1_dq_adc_clk_n),
        .adc1_dq_adc_clk_p(adc1_dq_adc_clk_p),
        .adc1_dq_adc_dq_n(adc1_dq_adc_dq_n),
        .adc1_dq_adc_dq_p(adc1_dq_adc_dq_p),
        .adc2_dq_adc_clk_n(adc2_dq_adc_clk_n),
        .adc2_dq_adc_clk_p(adc2_dq_adc_clk_p),
        .adc2_dq_adc_dq_n(adc2_dq_adc_dq_n),
        .adc2_dq_adc_dq_p(adc2_dq_adc_dq_p),
        .adc3_dq_adc_clk_n(adc3_dq_adc_clk_n),
        .adc3_dq_adc_clk_p(adc3_dq_adc_clk_p),
        .adc3_dq_adc_dq_n(adc3_dq_adc_dq_n),
        .adc3_dq_adc_dq_p(adc3_dq_adc_dq_p),
        .adc4_dq_adc_clk_n(adc4_dq_adc_clk_n),
        .adc4_dq_adc_clk_p(adc4_dq_adc_clk_p),
        .adc4_dq_adc_dq_n(adc4_dq_adc_dq_n),
        .adc4_dq_adc_dq_p(adc4_dq_adc_dq_p),
        .adc5_dq_adc_clk_n(adc5_dq_adc_clk_n),
        .adc5_dq_adc_clk_p(adc5_dq_adc_clk_p),
        .adc5_dq_adc_dq_n(adc5_dq_adc_dq_n),
        .adc5_dq_adc_dq_p(adc5_dq_adc_dq_p),
        .adc6_dq_adc_clk_n(adc6_dq_adc_clk_n),
        .adc6_dq_adc_clk_p(adc6_dq_adc_clk_p),
        .adc6_dq_adc_dq_n(adc6_dq_adc_dq_n),
        .adc6_dq_adc_dq_p(adc6_dq_adc_dq_p),
        .adc7_dq_adc_clk_n(adc7_dq_adc_clk_n),
        .adc7_dq_adc_clk_p(adc7_dq_adc_clk_p),
        .adc7_dq_adc_dq_n(adc7_dq_adc_dq_n),
        .adc7_dq_adc_dq_p(adc7_dq_adc_dq_p),
        .adc8_adc_amode(adc8_adc_amode),
        .adc8_adc_spi_cs(adc8_adc_spi_cs),
        .adc8_adc_spi_miso(adc8_adc_spi_miso),
        .adc8_adc_spi_mosi(adc8_adc_spi_mosi),
        .adc8_adc_spi_sclk(adc8_adc_spi_sclk),
        .adc8_dst_ld(adc8_dst_ld),
        .adc8_dst_pd(adc8_dst_pd),
        .adc8_dst_refsel(adc8_dst_refsel),
        .adc8_dst_rst(adc8_dst_rst),
        .adc8_dst_spi_cs(adc8_dst_spi_cs),
        .adc8_dst_spi_miso(adc8_dst_spi_miso),
        .adc8_dst_spi_mosi(adc8_dst_spi_mosi),
        .adc8_dst_spi_sclk(adc8_dst_spi_sclk),
        .adc8_dst_sync(adc8_dst_sync),
        .clk_in(clk_in),
        .glclk(glclk),
        .hmc1031_d(hmc1031_d),
        .hmc1031_lkdop(hmc1031_lkdop),
        .hmc1033_cen(hmc1033_cen),
        .hmc1033_sck(hmc1033_sck),
        .hmc1033_sdi(hmc1033_sdi),
        .hmc1033_sdo(hmc1033_sdo),
        .hmc1033_sen(hmc1033_sen),
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
        .usr_btn(usr_btn),
        .usr_led_a(usr_led_a),
        .usr_led_b(usr_led_b),
        .usr_sw(usr_sw));
endmodule
