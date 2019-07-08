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
set_property -dict {PACKAGE_PIN AK7 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxclkp]
set_property -dict {PACKAGE_PIN AL7 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxclkn]
create_clock -period $link0_period -name link0_lxclk [get_ports link0_rx_lxclkp]
# Data
set_property -dict {PACKAGE_PIN AN9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[0]]
set_property -dict {PACKAGE_PIN AP9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[0]]
set_property -dict {PACKAGE_PIN AJ8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[1]]
set_property -dict {PACKAGE_PIN AK8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[1]]
set_property -dict {PACKAGE_PIN AM11 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[2]]
set_property -dict {PACKAGE_PIN AN11 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[2]]
set_property -dict {PACKAGE_PIN AN8 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatp[3]]
set_property -dict {PACKAGE_PIN AP8 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link0_rx_lxdatn[3]]
# Control
set_property -dict {PACKAGE_PIN AK3  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports link0_rx_lxack]
set_property -dict {PACKAGE_PIN AP10 IOSTANDARD LVCMOS25} [get_ports link0_rx_lxbcmp]
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

## TX
# Clock
set_property -dict {PACKAGE_PIN AN3 IOSTANDARD LVDS_25} [get_ports link0_tx_lxclkp]
set_property -dict {PACKAGE_PIN AP3 IOSTANDARD LVDS_25} [get_ports link0_tx_lxclkn]
# Data
set_property -dict {PACKAGE_PIN AN4 IOSTANDARD LVDS_25} [get_ports link0_tx_lxdatp[0]]
set_property -dict {PACKAGE_PIN AP4 IOSTANDARD LVDS_25} [get_ports link0_tx_lxdatn[0]]
set_property -dict {PACKAGE_PIN AJ6 IOSTANDARD LVDS_25} [get_ports link0_tx_lxdatp[1]]
set_property -dict {PACKAGE_PIN AK6 IOSTANDARD LVDS_25} [get_ports link0_tx_lxdatn[1]]
set_property -dict {PACKAGE_PIN AL9 IOSTANDARD LVDS_25} [get_ports link0_tx_lxdatp[2]]
set_property -dict {PACKAGE_PIN AM9 IOSTANDARD LVDS_25} [get_ports link0_tx_lxdatn[2]]
set_property -dict {PACKAGE_PIN AN7 IOSTANDARD LVDS_25} [get_ports link0_tx_lxdatp[3]]
set_property -dict {PACKAGE_PIN AN6 IOSTANDARD LVDS_25} [get_ports link0_tx_lxdatn[3]]
# Control
set_property -dict {PACKAGE_PIN AP11 IOSTANDARD LVCMOS25 } [get_ports link0_tx_lxack]
set_property -dict {PACKAGE_PIN AL3  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports link0_tx_lxbcmp]
# Output Delays

### LINK Port #1
## RX
# Clock
set_property -dict {PACKAGE_PIN AL5 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxclkp]
set_property -dict {PACKAGE_PIN AM5 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxclkn]
create_clock -period $link1_period -name link1_lxclk [get_ports link1_rx_lxclkp]
# Data
set_property -dict {PACKAGE_PIN AN1  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[0]]
set_property -dict {PACKAGE_PIN AP1  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[0]]
set_property -dict {PACKAGE_PIN AJ10 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[1]]
set_property -dict {PACKAGE_PIN AK10 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[1]]
set_property -dict {PACKAGE_PIN AM7  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[2]]
set_property -dict {PACKAGE_PIN AM6  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[2]]
set_property -dict {PACKAGE_PIN AM2  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatp[3]]
set_property -dict {PACKAGE_PIN AN2  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_rx_lxdatn[3]]
# Control
set_property -dict {PACKAGE_PIN AP6  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports link1_rx_lxack]
set_property -dict {PACKAGE_PIN AM10 IOSTANDARD LVCMOS25} [get_ports link1_rx_lxbcmp]
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

## TX
# Clock
set_property -dict {PACKAGE_PIN AK2 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxclkp]
set_property -dict {PACKAGE_PIN AK1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxclkn]
# Data
set_property -dict {PACKAGE_PIN AL2  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxdatp[0]]
set_property -dict {PACKAGE_PIN AM1  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxdatn[0]]
set_property -dict {PACKAGE_PIN AJ11 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxdatp[1]]
set_property -dict {PACKAGE_PIN AK11 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxdatn[1]]
set_property -dict {PACKAGE_PIN AL4  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxdatp[2]]
set_property -dict {PACKAGE_PIN AM4  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxdatn[2]]
set_property -dict {PACKAGE_PIN AJ5  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxdatp[3]]
set_property -dict {PACKAGE_PIN AK5  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports link1_tx_lxdatn[3]]
# Control
set_property -dict {PACKAGE_PIN AL10 IOSTANDARD LVCMOS25} [get_ports link1_tx_lxack]
set_property -dict {PACKAGE_PIN AP5  IOSTANDARD LVCMOS25 SLEW FAST} [get_ports link1_tx_lxbcmp]
# Output Delays

## Special Clock Constraints
set_clock_groups -asynchronous \
-group [list [get_clocks -of_objects [get_pins -hierarchical *link_port*/lxclkinp]]] \
-group [list [get_clocks -of_objects [get_pins -hierarchical *link_port*/lxclk_ref]]]
