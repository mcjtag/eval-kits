#
# USB HS Constraints
#

#set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[0]}]
#set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[1]}]
#set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[2]}]
#set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[3]}]
#set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[4]}]
#set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[5]}]
#set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[6]}]
#set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {ulpi_data[7]}]
#set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_stp]
#set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_reset]
#set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports ulpi_dir]
#set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports ulpi_nxt]
#set_property -dict {PACKAGE_PIN Y12 IOSTANDARD LVCMOS33} [get_ports ulpi_clk]

#create_clock -period 16.666 -name ulpi_clk60 [get_ports ulpi_clk]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets ulpi_clk_IBUF]

