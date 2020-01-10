#
# USB HS Constraints
#

#set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[0]}]
#set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[1]}]
#set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[2]}]
#set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[3]}]
#set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[4]}]
#set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[5]}]
#set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[6]}]
#set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ULPI_data_io[7]}]
#set_property -dict {PACKAGE_PIN Y13  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ULPI_stop]
#set_property -dict {PACKAGE_PIN Y14  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ULPI_rst]
#set_property -dict {PACKAGE_PIN W14  IOSTANDARD LVCMOS33} [get_ports ULPI_dir]
#set_property -dict {PACKAGE_PIN Y16  IOSTANDARD LVCMOS33} [get_ports ULPI_next]
#set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS33} [get_ports ULPI_clk]
#
#create_clock -period 16.666 -name ulpi_clk60 [get_ports ULPI_clk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ULPI_clk_IBUF]
