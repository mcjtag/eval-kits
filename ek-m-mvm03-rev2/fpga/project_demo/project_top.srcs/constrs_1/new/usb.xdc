#
# USB HS Constraints
#

#set_property -dict {PACKAGE_PIN V31  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_data[0]]
#set_property -dict {PACKAGE_PIN AB29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_data[1]]
#set_property -dict {PACKAGE_PIN Y28  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_data[2]]
#set_property -dict {PACKAGE_PIN W25  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_data[3]]
#set_property -dict {PACKAGE_PIN AC31 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_data[4]]
#set_property -dict {PACKAGE_PIN AC32 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_data[5]]
#set_property -dict {PACKAGE_PIN AB32 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_data[6]]
#set_property -dict {PACKAGE_PIN AA32 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_data[7]]
#set_property -dict {PACKAGE_PIN Y31  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_stp]
#set_property -dict {PACKAGE_PIN Y30  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports ulpi_reset]
#set_property -dict {PACKAGE_PIN Y33  IOSTANDARD LVCMOS33} [get_ports ulpi_dir]
#set_property -dict {PACKAGE_PIN Y32  IOSTANDARD LVCMOS33} [get_ports ulpi_nxt]
#set_property -dict {PACKAGE_PIN AB31 IOSTANDARD LVCMOS33} [get_ports ulpi_clk]

#create_clock -period 16.666 -name ulpi_clk60 [get_ports ulpi_clk]