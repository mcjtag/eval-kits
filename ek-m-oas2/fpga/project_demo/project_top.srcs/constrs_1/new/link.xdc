#
# LINK Ports Constraints
#

# LINK Ports Constants
set link0_period [get_property PERIOD [get_clocks -of_objects [get_pins -hierarchical *link_port_0/lxclk_ref]]]
set link1_period [get_property PERIOD [get_clocks -of_objects [get_pins -hierarchical *link_port_1/lxclk_ref]]]
set link0_delay [expr {$link0_period / 4.0}]
set link1_delay [expr {$link1_period / 4.0}]

### LINK Port #0
## RX
# Clock
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxclkp]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxclkn]
create_clock -period $link0_period -name link0_lxclk [get_ports link0_rx_lxclkp]
# Data
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[0]]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[0]]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[1]]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[1]]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[2]]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[2]]
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[3]]
set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[3]]
#set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[4]]
#set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[4]]
#set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[5]]
#set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[5]]
#set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[6]]
#set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[6]]
#set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[7]]
#set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[7]]

# Control
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports link0_rx_lxack]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports link0_rx_lxbcmp]
# Input Delays
set_input_delay -clock [get_clocks link0_lxclk] -min -add_delay $link0_delay [get_ports {link0_rx_lxdatp[*]}]
set_input_delay -clock [get_clocks link0_lxclk] -max -add_delay $link0_delay [get_ports {link0_rx_lxdatp[*]}]
set_input_delay -clock [get_clocks link0_lxclk] -min -add_delay $link0_delay [get_ports {link0_rx_lxdatn[*]}]
set_input_delay -clock [get_clocks link0_lxclk] -max -add_delay $link0_delay [get_ports {link0_rx_lxdatn[*]}]
set_input_delay -clock [get_clocks link0_lxclk] -clock_fall -min -add_delay $link0_delay [get_ports {link0_rx_lxdatp[*]}]
set_input_delay -clock [get_clocks link0_lxclk] -clock_fall -max -add_delay $link0_delay [get_ports {link0_rx_lxdatp[*]}]
set_input_delay -clock [get_clocks link0_lxclk] -clock_fall -min -add_delay $link0_delay [get_ports {link0_rx_lxdatn[*]}]
set_input_delay -clock [get_clocks link0_lxclk] -clock_fall -max -add_delay $link0_delay [get_ports {link0_rx_lxdatn[*]}]
# IDELAY
set_property IDELAY_VALUE 8 [get_cells -hier -filter {NAME =~ *link_port_0/**/link_rx_if_inst/IDELAYE2_LXCLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *link_port_0/**/link_rx_if_inst/LXDATA[*].IDELAYE2_LXDAT}]

### LINK Port #1
## RX
# Clock
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxclkp]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxclkn]
create_clock -period $link1_period -name link1_lxclk [get_ports link1_rx_lxclkp]
# Data
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[0]]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[0]]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[1]]
set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[1]]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[2]]
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[2]]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[3]]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[3]]
#set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[4]]
#set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[4]]
#set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[5]]
#set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[5]]
#set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[6]]
#set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[6]]
#set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[7]]
#set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[7]]

# Control
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33 SLEW FAST} [get_ports link1_rx_lxack]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports link1_rx_lxbcmp]
# Input Delays
set_input_delay -clock [get_clocks link1_lxclk] -min -add_delay $link1_delay [get_ports {link1_rx_lxdatp[*]}]
set_input_delay -clock [get_clocks link1_lxclk] -max -add_delay $link1_delay [get_ports {link1_rx_lxdatp[*]}]
set_input_delay -clock [get_clocks link1_lxclk] -min -add_delay $link1_delay [get_ports {link1_rx_lxdatn[*]}]
set_input_delay -clock [get_clocks link1_lxclk] -max -add_delay $link1_delay [get_ports {link1_rx_lxdatn[*]}]
set_input_delay -clock [get_clocks link1_lxclk] -clock_fall -min -add_delay $link1_delay [get_ports {link1_rx_lxdatp[*]}]
set_input_delay -clock [get_clocks link1_lxclk] -clock_fall -max -add_delay $link1_delay [get_ports {link1_rx_lxdatp[*]}]
set_input_delay -clock [get_clocks link1_lxclk] -clock_fall -min -add_delay $link1_delay [get_ports {link1_rx_lxdatn[*]}]
set_input_delay -clock [get_clocks link1_lxclk] -clock_fall -max -add_delay $link1_delay [get_ports {link1_rx_lxdatn[*]}]
# IDELAY
set_property IDELAY_VALUE 8 [get_cells -hier -filter {NAME =~ *link_port_1/**/link_rx_if_inst/IDELAYE2_LXCLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *link_port_1/**/link_rx_if_inst/LXDATA[*].IDELAYE2_LXDAT}]

## Special Clock Constraints
set_clock_groups -asynchronous \
-group [list [get_clocks -of_objects [get_pins -hierarchical *link_port*/lxclkinp]]] \
-group [list [get_clocks -of_objects [get_pins -hierarchical *link_port*/lxclk_ref]]]