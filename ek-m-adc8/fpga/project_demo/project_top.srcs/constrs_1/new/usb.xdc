#
# USB HS Constraints
#

#set_property -dict {PACKAGE_PIN AB34 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[0]}]
#set_property -dict {PACKAGE_PIN AA34 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[1]}]
#set_property -dict {PACKAGE_PIN AC29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[2]}]
#set_property -dict {PACKAGE_PIN AA29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[3]}]
#set_property -dict {PACKAGE_PIN AB29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[4]}]
#set_property -dict {PACKAGE_PIN AA28 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[5]}]
#set_property -dict {PACKAGE_PIN AC28 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[6]}]
#set_property -dict {PACKAGE_PIN AA27 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[7]}]
#set_property -dict {PACKAGE_PIN AA25 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_stp]
#set_property -dict {PACKAGE_PIN AB27 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_reset]
#set_property -dict {PACKAGE_PIN AA24 IOSTANDARD LVCMOS33} [get_ports ulpi_dir]
#set_property -dict {PACKAGE_PIN AB26 IOSTANDARD LVCMOS33} [get_ports ulpi_nxt]
#set_property -dict {PACKAGE_PIN AA30 IOSTANDARD LVCMOS33} [get_ports ulpi_clk]

#create_clock -period 16.666 -name ulpi_clk60 [get_ports ulpi_clk]
