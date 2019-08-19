#
# Misc Constraints
#

## User LEDs 
set_property -dict {PACKAGE_PIN P31 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_a[0]}]
set_property -dict {PACKAGE_PIN N31 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_a[1]}]
set_property -dict {PACKAGE_PIN N32 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_a[2]}]
set_property -dict {PACKAGE_PIN N33 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_a[3]}]
set_property -dict {PACKAGE_PIN P33 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_a[4]}]
set_property -dict {PACKAGE_PIN R32 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_a[5]}]
set_property -dict {PACKAGE_PIN T34 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_a[6]}]
set_property -dict {PACKAGE_PIN U32 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_a[7]}]
set_property -dict {PACKAGE_PIN U31 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_b[0]}]
set_property -dict {PACKAGE_PIN T32 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_b[1]}]
set_property -dict {PACKAGE_PIN M32 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_b[2]}]
set_property -dict {PACKAGE_PIN M34 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_b[3]}]
set_property -dict {PACKAGE_PIN N34 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_b[4]}]
set_property -dict {PACKAGE_PIN R33 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_b[5]}]
set_property -dict {PACKAGE_PIN T33 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_b[6]}]
set_property -dict {PACKAGE_PIN U34 IOSTANDARD LVCMOS33 DRIVE 12} [get_ports {usr_led_b[7]}]

## User Buttons
set_property -dict {PACKAGE_PIN AD4  IOSTANDARD LVCMOS25} [get_ports usr_btn[0]]
set_property -dict {PACKAGE_PIN AH4  IOSTANDARD LVCMOS25} [get_ports usr_btn[1]]
set_property -dict {PACKAGE_PIN AJ4  IOSTANDARD LVCMOS25} [get_ports usr_btn[2]]
set_property -dict {PACKAGE_PIN AD3  IOSTANDARD LVCMOS25} [get_ports usr_btn[3]]
set_property -dict {PACKAGE_PIN AE3  IOSTANDARD LVCMOS25} [get_ports usr_btn[4]]
set_property -dict {PACKAGE_PIN AG6  IOSTANDARD LVCMOS25} [get_ports usr_btn[5]]
set_property -dict {PACKAGE_PIN AE11 IOSTANDARD LVCMOS25} [get_ports usr_btn[6]]
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVCMOS25} [get_ports usr_btn[7]]

## User Switch
set_property -dict {PACKAGE_PIN AJ5  IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[0]]
set_property -dict {PACKAGE_PIN AK5  IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[1]]
set_property -dict {PACKAGE_PIN AP6  IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[2]]
set_property -dict {PACKAGE_PIN AP5  IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[3]]
set_property -dict {PACKAGE_PIN AL4  IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[4]]
set_property -dict {PACKAGE_PIN AM4  IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[5]]
set_property -dict {PACKAGE_PIN AN11 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[6]]
set_property -dict {PACKAGE_PIN AJ11 IOSTANDARD LVCMOS25 PULLUP TRUE} [get_ports usr_sw[7]]

## User Flash
#set_property -dict {PACKAGE_PIN AB30 IOSTANDARD LVCMOS33} [get_ports usr_flash_sck]
#set_property -dict {PACKAGE_PIN W33 IOSTANDARD LVCMOS33} [get_ports usr_flash_mosi]
#set_property -dict {PACKAGE_PIN W31 IOSTANDARD LVCMOS33} [get_ports usr_flash_miso]
#set_property -dict {PACKAGE_PIN W24 IOSTANDARD LVCMOS33} [get_ports usr_flash_ncs]

## TFT Display
#set_property -dict {PACKAGE_PIN P26 IOSTANDARD LVCMOS33} [get_ports tft_ts_busy]
#set_property -dict {PACKAGE_PIN N24 IOSTANDARD LVCMOS33} [get_ports tft_ts_irq]

#set_property -dict {PACKAGE_PIN R25 IOSTANDARD LVCMOS33} [get_ports tft_spi_sck]
#set_property -dict {PACKAGE_PIN P25 IOSTANDARD LVCMOS33} [get_ports tft_spi_ncs]
#set_property -dict {PACKAGE_PIN N26 IOSTANDARD LVCMOS33} [get_ports tft_spi_mosi]
#set_property -dict {PACKAGE_PIN P24 IOSTANDARD LVCMOS33} [get_ports tft_spi_miso]

set_property -dict {PACKAGE_PIN T24 IOSTANDARD LVCMOS33} [get_ports tft_lcd_pwm]
set_property -dict {PACKAGE_PIN U30 IOSTANDARD LVCMOS33} [get_ports tft_lcd_clk]
set_property -dict {PACKAGE_PIN M31 IOSTANDARD LVCMOS33} [get_ports tft_lcd_de]
set_property -dict {PACKAGE_PIN R31 IOSTANDARD LVCMOS33} [get_ports tft_lcd_dps] ; # dummy
set_property -dict {PACKAGE_PIN T30 IOSTANDARD LVCMOS33} [get_ports tft_lcd_hsync]
set_property -dict {PACKAGE_PIN M30 IOSTANDARD LVCMOS33} [get_ports tft_lcd_vsync]
set_property -dict {PACKAGE_PIN N27 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[0]]
set_property -dict {PACKAGE_PIN P28 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[1]]
set_property -dict {PACKAGE_PIN U29 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[2]]
set_property -dict {PACKAGE_PIN N28 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[3]]
set_property -dict {PACKAGE_PIN P29 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[4]]
set_property -dict {PACKAGE_PIN N29 IOSTANDARD LVCMOS33} [get_ports tft_lcd_red[5]]
set_property -dict {PACKAGE_PIN T29 IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[0]]
set_property -dict {PACKAGE_PIN M27 IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[1]]
set_property -dict {PACKAGE_PIN R28 IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[2]]
set_property -dict {PACKAGE_PIN R27 IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[3]]
set_property -dict {PACKAGE_PIN R26 IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[4]]
set_property -dict {PACKAGE_PIN T25 IOSTANDARD LVCMOS33} [get_ports tft_lcd_green[5]]
set_property -dict {PACKAGE_PIN U25 IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[0]]
set_property -dict {PACKAGE_PIN U26 IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[1]]
set_property -dict {PACKAGE_PIN T27 IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[2]]
set_property -dict {PACKAGE_PIN U27 IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[3]]
set_property -dict {PACKAGE_PIN T28 IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[4]]
set_property -dict {PACKAGE_PIN M29 IOSTANDARD LVCMOS33} [get_ports tft_lcd_blue[5]]

## RS485
#set_property -dict {PACKAGE_PIN Y32 IOSTANDARD LVCMOS33} [get_ports rs485_rx]
#set_property -dict {PACKAGE_PIN Y33 IOSTANDARD LVCMOS33} [get_ports rs485_tx]
#set_property -dict {PACKAGE_PIN V27 IOSTANDARD LVCMOS33} [get_ports rs485_de]
