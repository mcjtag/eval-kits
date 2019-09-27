#
# Top Constraints
#

## System
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]

## System Clock
set_property PACKAGE_PIN F6 [get_ports sys_clk_p]
set_property PACKAGE_PIN E6 [get_ports sys_clk_n]
create_clock -period 8.000 -name sys_clk [get_ports sys_clk_p]

#set_property PACKAGE_PIN F10 [get_ports sys_clk2_p]
#set_property PACKAGE_PIN E10 [get_ports sys_clk2_n]
#create_clock -period 8.000 -name sys2_clk [get_ports sys_clk2_p]

## PIN
set_property -dict {PACKAGE_PIN G21 IOSTANDARD LVCMOS25} [get_ports clk_ref]
#set_property -dict {PACKAGE_PIN G22 IOSTANDARD LVCMOS25} [get_ports pin[1]]

## UART
#set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports uart_tx]
#set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports uart_rx]
