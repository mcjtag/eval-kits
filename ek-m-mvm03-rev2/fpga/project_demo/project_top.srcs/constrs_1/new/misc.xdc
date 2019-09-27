## User Switch
#set_property -dict {PACKAGE_PIN AG25 IOSTANDARD SSTL135} [get_ports usr_sw[0]]
#set_property -dict {PACKAGE_PIN AF23 IOSTANDARD SSTL135} [get_ports usr_sw[1]]

## User Buttons
#set_property -dict {PACKAGE_PIN AF33 IOSTANDARD SSTL135} [get_ports usr_btn[0]]
#set_property -dict {PACKAGE_PIN AF34 IOSTANDARD SSTL135} [get_ports usr_btn[1]]
#set_property -dict {PACKAGE_PIN AG34 IOSTANDARD SSTL135} [get_ports usr_btn[2]]
#set_property -dict {PACKAGE_PIN AD34 IOSTANDARD SSTL135} [get_ports usr_btn[3]]
#set_property -dict {PACKAGE_PIN AD33 IOSTANDARD SSTL135} [get_ports usr_btn[4]]

## User Flash
#set_property -dict {PACKAGE_PIN R32 IOSTANDARD LVCMOS33} [get_ports usr_flash_sck]
#set_property -dict {PACKAGE_PIN N32 IOSTANDARD LVCMOS33} [get_ports usr_flash_mosi]
#set_property -dict {PACKAGE_PIN T32 IOSTANDARD LVCMOS33} [get_ports usr_flash_miso]
#set_property -dict {PACKAGE_PIN U31 IOSTANDARD LVCMOS33} [get_ports usr_flash_ncs]

## TFT Display
set_property -dict {PACKAGE_PIN R30 IOSTANDARD LVCMOS33} [get_ports tft_gpi[0]] ; # reset
set_property -dict {PACKAGE_PIN R31 IOSTANDARD LVCMOS33} [get_ports tft_gpi[1]] ; # tp_irq
set_property -dict {PACKAGE_PIN P30 IOSTANDARD LVCMOS33} [get_ports tft_gpo[0]] ; # lcd_bl
set_property -dict {PACKAGE_PIN M32 IOSTANDARD LVCMOS33} [get_ports tft_gpo[1]] ; # lcd_dc
set_property -dict {PACKAGE_PIN M31 IOSTANDARD LVCMOS33} [get_ports tft_spi_sck_io]
set_property -dict {PACKAGE_PIN T30 IOSTANDARD LVCMOS33} [get_ports tft_spi_io0_io]
set_property -dict {PACKAGE_PIN M30 IOSTANDARD LVCMOS33} [get_ports tft_spi_io1_io]
set_property -dict {PACKAGE_PIN U30 IOSTANDARD LVCMOS33} [get_ports tft_spi_ss_io[0]] ; # lcd ( gpo[2] )
set_property -dict {PACKAGE_PIN P31 IOSTANDARD LVCMOS33} [get_ports tft_spi_ss_io[1]] ; # tp ( gpo[3] )
set_property -dict {PACKAGE_PIN N31 IOSTANDARD LVCMOS33} [get_ports tft_spi_ss_io[2]] ; # sd ( gpo[4] )

## CMOS Bus
#set_property -dict {PACKAGE_PIN M24 IOSTANDARD LVCMOS25} [get_ports cmos_bus[0]]
#set_property -dict {PACKAGE_PIN L24 IOSTANDARD LVCMOS25} [get_ports cmos_bus[1]]
#set_property -dict {PACKAGE_PIN K23 IOSTANDARD LVCMOS25} [get_ports cmos_bus[2]]
#set_property -dict {PACKAGE_PIN J23 IOSTANDARD LVCMOS25} [get_ports cmos_bus[3]]
#set_property -dict {PACKAGE_PIN G24 IOSTANDARD LVCMOS25} [get_ports cmos_bus[4]]
#set_property -dict {PACKAGE_PIN G25 IOSTANDARD LVCMOS25} [get_ports cmos_bus[5]]
#set_property -dict {PACKAGE_PIN K25 IOSTANDARD LVCMOS25} [get_ports cmos_bus[6]]
#set_property -dict {PACKAGE_PIN J25 IOSTANDARD LVCMOS25} [get_ports cmos_bus[7]]
#set_property -dict {PACKAGE_PIN M25 IOSTANDARD LVCMOS25} [get_ports cmos_bus[8]]
#set_property -dict {PACKAGE_PIN L25 IOSTANDARD LVCMOS25} [get_ports cmos_bus[9]]
#set_property -dict {PACKAGE_PIN J24 IOSTANDARD LVCMOS25} [get_ports cmos_bus[10]]
#set_property -dict {PACKAGE_PIN H24 IOSTANDARD LVCMOS25} [get_ports cmos_bus[11]]
#set_property -dict {PACKAGE_PIN H27 IOSTANDARD LVCMOS25} [get_ports cmos_bus[12]]
#set_property -dict {PACKAGE_PIN G27 IOSTANDARD LVCMOS25} [get_ports cmos_bus[13]]
#set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVCMOS25} [get_ports cmos_bus[14]]
#set_property -dict {PACKAGE_PIN G26 IOSTANDARD LVCMOS25} [get_ports cmos_bus[15]]
#set_property -dict {PACKAGE_PIN L27 IOSTANDARD LVCMOS25} [get_ports cmos_bus[16]]
#set_property -dict {PACKAGE_PIN K27 IOSTANDARD LVCMOS25} [get_ports cmos_bus[17]]
#set_property -dict {PACKAGE_PIN K26 IOSTANDARD LVCMOS25} [get_ports cmos_bus[18]]
#set_property -dict {PACKAGE_PIN J26 IOSTANDARD LVCMOS25} [get_ports cmos_bus[19]]
#set_property -dict {PACKAGE_PIN K28 IOSTANDARD LVCMOS25} [get_ports cmos_bus[20]]
#set_property -dict {PACKAGE_PIN H28 IOSTANDARD LVCMOS25} [get_ports cmos_bus[21]]
#set_property -dict {PACKAGE_PIN L28 IOSTANDARD LVCMOS25} [get_ports cmos_bus[22]] ; # DATA or CLK
#set_property -dict {PACKAGE_PIN J28 IOSTANDARD LVCMOS25} [get_ports cmos_bus[23]] ; # DATA or CLK

## LVDS Bus
#set_property -dict {PACKAGE_PIN G29 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[0]]
#set_property -dict {PACKAGE_PIN G30 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[0]]
#set_property -dict {PACKAGE_PIN H31 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[1]]
#set_property -dict {PACKAGE_PIN G31 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[1]]
#set_property -dict {PACKAGE_PIN H32 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[2]]
#set_property -dict {PACKAGE_PIN G32 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[2]]
#set_property -dict {PACKAGE_PIN K31 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[3]]
#set_property -dict {PACKAGE_PIN J31 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[3]]
#set_property -dict {PACKAGE_PIN L29 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[4]]
#set_property -dict {PACKAGE_PIN L30 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[4]]
#set_property -dict {PACKAGE_PIN H33 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[5]]
#set_property -dict {PACKAGE_PIN G34 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[5]]
#set_property -dict {PACKAGE_PIN K33 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[6]]
#set_property -dict {PACKAGE_PIN J34 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[6]]
#set_property -dict {PACKAGE_PIN L32 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[7]]
#set_property -dict {PACKAGE_PIN K32 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[7]]
#set_property -dict {PACKAGE_PIN J29 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[8]] ; # DATA or CLK
#set_property -dict {PACKAGE_PIN H29 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[8]] ; # DATA or CLK
#set_property -dict {PACKAGE_PIN K30 IOSTANDARD LVDS_25} [get_ports lvds_bus_p[9]] ; # DATA or CLK
#set_property -dict {PACKAGE_PIN J30 IOSTANDARD LVDS_25} [get_ports lvds_bus_n[9]] ; # DATA or CLK

#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[0]] ; Rx Only
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[0]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[1]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[1]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[2]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[2]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[3]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[3]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[4]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[4]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[5]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[5]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[6]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[6]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[7]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[7]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[8]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[8]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_p[9]] ; --
#set_property DIFF_TERM TRUE [get_ports lvds_bus_n[9]] ; --

## Audio Codec
set_property -dict {PACKAGE_PIN AA30 IOSTANDARD LVCMOS33} [get_ports audio_spi_sck_io]
set_property -dict {PACKAGE_PIN AC28 IOSTANDARD LVCMOS33} [get_ports audio_spi_io0_io] ; #MOSI
set_property -dict {PACKAGE_PIN V24 IOSTANDARD LVCMOS33} [get_ports audio_spi_io1_io] ; #MISO (Dummy)
set_property -dict {PACKAGE_PIN W31  IOSTANDARD LVCMOS33} [get_ports audio_spi_ss_io[0]] 
set_property -dict {PACKAGE_PIN AC29 IOSTANDARD LVCMOS33} [get_ports audio_i2s_bclk]
set_property -dict {PACKAGE_PIN AB30 IOSTANDARD LVCMOS33} [get_ports audio_i2s_dout]
set_property -dict {PACKAGE_PIN AA29 IOSTANDARD LVCMOS33} [get_ports audio_i2s_din]
set_property -dict {PACKAGE_PIN AA27 IOSTANDARD LVCMOS33} [get_ports audio_i2s_lrcout]
set_property -dict {PACKAGE_PIN AA28 IOSTANDARD LVCMOS33} [get_ports audio_i2s_lrcin]