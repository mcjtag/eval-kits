#
# Top Constraints
#

## System
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]

## System Clock
set_property PACKAGE_PIN AG18 [get_ports sys_clk_p]
set_property PACKAGE_PIN AH18 [get_ports sys_clk_n]
create_clock -period 8.000 -name sys_clk [get_ports sys_clk_p]

#set_property PACKAGE_PIN AG20 [get_ports sys1_clk_p]
#set_property PACKAGE_PIN AH20 [get_ports sys1_clk_n]
#create_clock -period 8.000 -name sys1_clk [get_ports sys1_clk_p]

set_property -dict {PACKAGE_PIN AK31 IOSTANDARD LVCMOS25} [get_ports clk_in]
