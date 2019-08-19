#
# ADC8 Clock constraints
#

set_property -dict {PACKAGE_PIN Y26 IOSTANDARD LVCMOS33} [get_ports adc8_dst_refsel]
set_property -dict {PACKAGE_PIN V26 IOSTANDARD LVCMOS33} [get_ports adc8_dst_ld]
set_property -dict {PACKAGE_PIN Y25 IOSTANDARD LVCMOS33} [get_ports adc8_dst_spi_cs]
set_property -dict {PACKAGE_PIN Y28 IOSTANDARD LVCMOS33} [get_ports adc8_dst_sync]
set_property -dict {PACKAGE_PIN V31 IOSTANDARD LVCMOS33} [get_ports adc8_dst_rst]
set_property -dict {PACKAGE_PIN V32 IOSTANDARD LVCMOS33} [get_ports adc8_dst_pd]
set_property -dict {PACKAGE_PIN W25 IOSTANDARD LVCMOS33} [get_ports adc8_dst_spi_sclk]
set_property -dict {PACKAGE_PIN W28 IOSTANDARD LVCMOS33} [get_ports adc8_dst_spi_mosi]
set_property -dict {PACKAGE_PIN W29 IOSTANDARD LVCMOS33} [get_ports adc8_dst_spi_miso]

set_property -dict {PACKAGE_PIN L24 IOSTANDARD LVCMOS18} [get_ports adc8_adc_amode[0]]
set_property -dict {PACKAGE_PIN K23 IOSTANDARD LVCMOS18} [get_ports adc8_adc_amode[1]]
set_property -dict {PACKAGE_PIN H26 IOSTANDARD LVCMOS18} [get_ports adc8_adc_amode[2]]
set_property -dict {PACKAGE_PIN G27 IOSTANDARD LVCMOS18} [get_ports adc8_adc_amode[3]]
set_property -dict {PACKAGE_PIN G29 IOSTANDARD LVCMOS18} [get_ports adc8_adc_amode[4]]
set_property -dict {PACKAGE_PIN J31 IOSTANDARD LVCMOS18} [get_ports adc8_adc_amode[5]]
set_property -dict {PACKAGE_PIN G32 IOSTANDARD LVCMOS18} [get_ports adc8_adc_amode[6]]
set_property -dict {PACKAGE_PIN K32 IOSTANDARD LVCMOS18} [get_ports adc8_adc_amode[7]]
