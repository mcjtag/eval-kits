#
# Clock constraints
#

# HMC1031
set_property -dict {PACKAGE_PIN W34 IOSTANDARD LVCMOS33} [get_ports hmc1031_lkdop]
set_property -dict {PACKAGE_PIN V33 IOSTANDARD LVCMOS33} [get_ports hmc1031_d[0]]
set_property -dict {PACKAGE_PIN V34 IOSTANDARD LVCMOS33} [get_ports hmc1031_d[1]]

# HMC1033
set_property -dict {PACKAGE_PIN AC32 IOSTANDARD LVCMOS33} [get_ports hmc1033_cen]
set_property -dict {PACKAGE_PIN AA32 IOSTANDARD LVCMOS33} [get_ports hmc1033_sen]
set_property -dict {PACKAGE_PIN Y31  IOSTANDARD LVCMOS33} [get_ports hmc1033_sck]
set_property -dict {PACKAGE_PIN AA33 IOSTANDARD LVCMOS33} [get_ports hmc1033_sdi]
set_property -dict {PACKAGE_PIN AC31 IOSTANDARD LVCMOS33} [get_ports hmc1033_sdo]

# Global clock
set_property -dict {PACKAGE_PIN W30 IOSTANDARD LVCMOS33} [get_ports glclk]
