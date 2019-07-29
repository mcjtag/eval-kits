#
# Misc Constraints
#

## LEDs 
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {led[3]}]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {led[5]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {led[6]}]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {led[7]}]

## User Flash
#set_property -dict {PACKAGE_PIN AB12 IOSTANDARD LVCMOS33} [get_ports usr_flash_sck]
#set_property -dict {PACKAGE_PIN AB11 IOSTANDARD LVCMOS33} [get_ports usr_flash_mosi]
#set_property -dict {PACKAGE_PIN AB10 IOSTANDARD LVCMOS33} [get_ports usr_flash_miso]
#set_property -dict {PACKAGE_PIN AA9  IOSTANDARD LVCMOS33} [get_ports usr_flash_ncs] 

# User Switch
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[0]]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[1]]
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[2]]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[3]]

# User Buttons
#set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_btn[0]]
#set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_btn[1]]
#set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_btn[2]]
#set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_btn[3]]

# TFT Display
#set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33} [get_ports tft_ts_busy]
#set_property -dict {PACKAGE_PIN P14  IOSTANDARD LVCMOS33} [get_ports tft_ts_irq]

#set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports tft_spi_sck]
#set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports tft_spi_ncs]
#set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports tft_spi_mosi]
#set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports tft_spi_miso]

set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports tft_lcd_pwm]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports tft_lcd_clk]
set_property -dict {PACKAGE_PIN P15  IOSTANDARD LVCMOS33} [get_ports tft_lcd_de]
set_property -dict {PACKAGE_PIN Y17  IOSTANDARD LVCMOS33} [get_ports tft_lcd_dps] ; # dummy
set_property -dict {PACKAGE_PIN N17  IOSTANDARD LVCMOS33} [get_ports tft_lcd_hsync]
set_property -dict {PACKAGE_PIN U17  IOSTANDARD LVCMOS33} [get_ports tft_lcd_vsync]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[0]]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[1]]
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[2]]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[3]]
set_property -dict {PACKAGE_PIN Y21  IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[4]]
set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[5]]
set_property -dict {PACKAGE_PIN Y22  IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[0]]
set_property -dict {PACKAGE_PIN W21  IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[1]]
set_property -dict {PACKAGE_PIN U18  IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[2]]
set_property -dict {PACKAGE_PIN W22  IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[3]]
set_property -dict {PACKAGE_PIN U21  IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[4]]
set_property -dict {PACKAGE_PIN T20  IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[5]]
set_property -dict {PACKAGE_PIN T21  IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[0]]
set_property -dict {PACKAGE_PIN T18  IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[1]]
set_property -dict {PACKAGE_PIN R19  IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[2]]
set_property -dict {PACKAGE_PIN P19  IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[3]]
set_property -dict {PACKAGE_PIN R18  IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[4]]
set_property -dict {PACKAGE_PIN P17  IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[5]]
