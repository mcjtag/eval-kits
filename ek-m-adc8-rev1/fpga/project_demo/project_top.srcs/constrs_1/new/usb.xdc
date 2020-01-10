#
# USB HS Constraints
#

#set_property -dict {PACKAGE_PIN AB34 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[0]}]
#set_property -dict {PACKAGE_PIN AA34 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[1]}]
#set_property -dict {PACKAGE_PIN AC29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[2]}]
#set_property -dict {PACKAGE_PIN AA29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[3]}]
#set_property -dict {PACKAGE_PIN AB29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[4]}]
#set_property -dict {PACKAGE_PIN AA28 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[5]}]
#set_property -dict {PACKAGE_PIN AC28 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[6]}]
#set_property -dict {PACKAGE_PIN AA27 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[7]}]
#set_property -dict {PACKAGE_PIN AA25 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ULPI_stop]
#set_property -dict {PACKAGE_PIN AB27 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ULPI_rst]
#set_property -dict {PACKAGE_PIN AA24 IOSTANDARD LVCMOS33} [get_ports ULPI_dir]
#set_property -dict {PACKAGE_PIN AB26 IOSTANDARD LVCMOS33} [get_ports ULPI_next]
#set_property -dict {PACKAGE_PIN AA30 IOSTANDARD LVCMOS33} [get_ports ULPI_clk]
#
#create_clock -period 16.666 -name ulpi_clk60 [get_ports ULPI_clk]
