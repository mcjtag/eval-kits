#
# Clock Distribution Constraints
#

# AD9520
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports ad9520_ld]
set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVCMOS33} [get_ports ad9520_cs]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports ad9520_pd]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports ad9520_sclk]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports ad9520_sdi]
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports ad9520_sdo]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33} [get_ports ad9520_sync]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports ad9520_status]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports ad9520_refmon]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports ad9520_reset]

# Disout
#set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports gen_clk]

# HMC1031
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports hmc1031_lkdop]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports hmc1031_d[0]]
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33} [get_ports hmc1031_d[1]]

# Global clock
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports glclk]

