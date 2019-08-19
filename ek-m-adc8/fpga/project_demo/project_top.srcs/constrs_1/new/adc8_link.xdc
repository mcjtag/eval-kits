#
# ADC Link
#

## ADC_0
# Clock
set_property -dict {PACKAGE_PIN AL30 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_clk_p]
set_property -dict {PACKAGE_PIN AM30 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_clk_n]
create_clock -period 8.000 -name adc0_clk [get_ports adc0_dq_adc_clk_p]
# Data
set_property -dict {PACKAGE_PIN AJ33 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_p[0]]
set_property -dict {PACKAGE_PIN AJ34 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_n[0]]
set_property -dict {PACKAGE_PIN AN33 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_p[1]]
set_property -dict {PACKAGE_PIN AP33 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_n[1]]
set_property -dict {PACKAGE_PIN AL32 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_p[2]]
set_property -dict {PACKAGE_PIN AM32 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_n[2]]
set_property -dict {PACKAGE_PIN AK33 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_p[3]]
set_property -dict {PACKAGE_PIN AL33 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_n[3]]
set_property -dict {PACKAGE_PIN AJ31 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_p[4]]
set_property -dict {PACKAGE_PIN AK32 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_n[4]]
set_property -dict {PACKAGE_PIN AN34 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_p[5]]
set_property -dict {PACKAGE_PIN AP34 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_n[5]]
set_property -dict {PACKAGE_PIN AL34 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_p[6]]
set_property -dict {PACKAGE_PIN AM34 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc0_dq_adc_dq_n[6]]
# Input Delays
set_input_delay -clock [get_clocks {adc0_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc0_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc0_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc0_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc0_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc0_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc0_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc0_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc0_clk}] -min -add_delay 2.1 [get_ports {adc0_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc0_clk}] -max -add_delay 3.5 [get_ports {adc0_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc0_clk}] -min -add_delay 2.1 [get_ports {adc0_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc0_clk}] -max -add_delay 3.5 [get_ports {adc0_dq_adc_dq_n[*]}]
# IDELAY
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_0/IDELAYE2_CLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_0/DATA[*].IDELAYE2_DAT}]

## ADC_1
# Clock
set_property -dict {PACKAGE_PIN AH28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_clk_p]
set_property -dict {PACKAGE_PIN AH29 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_clk_n]
create_clock -period 8.000 -name adc1_clk [get_ports adc1_dq_adc_clk_p]
# Data
set_property -dict {PACKAGE_PIN AG26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_p[0]]
set_property -dict {PACKAGE_PIN AH26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_n[0]]
set_property -dict {PACKAGE_PIN AD26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_p[1]]
set_property -dict {PACKAGE_PIN AE26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_n[1]]
set_property -dict {PACKAGE_PIN AG24 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_p[2]]
set_property -dict {PACKAGE_PIN AH24 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_n[2]]
set_property -dict {PACKAGE_PIN AC26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_p[3]]
set_property -dict {PACKAGE_PIN AC27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_n[3]]
set_property -dict {PACKAGE_PIN AG27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_p[4]]
set_property -dict {PACKAGE_PIN AH27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_n[4]]
set_property -dict {PACKAGE_PIN AE23 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_p[5]]
set_property -dict {PACKAGE_PIN AF23 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_n[5]]
set_property -dict {PACKAGE_PIN AE27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_p[6]]
set_property -dict {PACKAGE_PIN AF27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc1_dq_adc_dq_n[6]]
# Input Delays
set_input_delay -clock [get_clocks {adc1_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc1_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc1_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc1_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc1_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc1_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc1_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc1_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc1_clk}] -min -add_delay 2.1 [get_ports {adc1_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc1_clk}] -max -add_delay 3.5 [get_ports {adc1_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc1_clk}] -min -add_delay 2.1 [get_ports {adc1_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc1_clk}] -max -add_delay 3.5 [get_ports {adc1_dq_adc_dq_n[*]}]
# IDELAY
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_1/IDELAYE2_CLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_1/DATA[*].IDELAYE2_DAT}]

## ADC_2
# Clock
set_property -dict {PACKAGE_PIN AE28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_clk_p]
set_property -dict {PACKAGE_PIN AF28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_clk_n]
create_clock -period 8.000 -name adc2_clk [get_ports adc2_dq_adc_clk_p]
# Data
set_property -dict {PACKAGE_PIN AD31 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_p[0]]
set_property -dict {PACKAGE_PIN AE31 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_n[0]]
set_property -dict {PACKAGE_PIN AH33 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_p[1]]
set_property -dict {PACKAGE_PIN AH34 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_n[1]]
set_property -dict {PACKAGE_PIN AE32 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_p[2]]
set_property -dict {PACKAGE_PIN AF32 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_n[2]]
set_property -dict {PACKAGE_PIN AD33 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_p[3]]
set_property -dict {PACKAGE_PIN AD34 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_n[3]]
set_property -dict {PACKAGE_PIN AG32 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_p[4]]
set_property -dict {PACKAGE_PIN AH32 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_n[4]]
set_property -dict {PACKAGE_PIN AF34 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_p[5]]
set_property -dict {PACKAGE_PIN AG34 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_n[5]]
set_property -dict {PACKAGE_PIN AE33 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_p[6]]
set_property -dict {PACKAGE_PIN AF33 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc2_dq_adc_dq_n[6]]
# Input Delays
set_input_delay -clock [get_clocks {adc2_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc2_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc2_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc2_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc2_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc2_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc2_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc2_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc2_clk}] -min -add_delay 2.1 [get_ports {adc2_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc2_clk}] -max -add_delay 3.5 [get_ports {adc2_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc2_clk}] -min -add_delay 2.1 [get_ports {adc2_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc2_clk}] -max -add_delay 3.5 [get_ports {adc2_dq_adc_dq_n[*]}]
# IDELAY
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_2/IDELAYE2_CLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_2/DATA[*].IDELAYE2_DAT}]

## ADC_3
# Clock
set_property -dict {PACKAGE_PIN AL28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_clk_p]
set_property -dict {PACKAGE_PIN AL29 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_clk_n]
create_clock -period 8.000 -name adc3_clk [get_ports adc3_dq_adc_clk_p]
# Data
set_property -dict {PACKAGE_PIN AM29 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_p[0]]
set_property -dict {PACKAGE_PIN AN29 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_n[0]]
set_property -dict {PACKAGE_PIN AP29 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_p[1]]
set_property -dict {PACKAGE_PIN AP30 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_n[1]]
set_property -dict {PACKAGE_PIN AN28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_p[2]]
set_property -dict {PACKAGE_PIN AP28 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_n[2]]
set_property -dict {PACKAGE_PIN AM26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_p[3]]
set_property -dict {PACKAGE_PIN AN26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_n[3]]
set_property -dict {PACKAGE_PIN AK27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_p[4]]
set_property -dict {PACKAGE_PIN AL27 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_n[4]]
set_property -dict {PACKAGE_PIN AJ26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_p[5]]
set_property -dict {PACKAGE_PIN AK26 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_n[5]]
set_property -dict {PACKAGE_PIN AJ25 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_p[6]]
set_property -dict {PACKAGE_PIN AK25 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc3_dq_adc_dq_n[6]]
# Input Delays
set_input_delay -clock [get_clocks {adc3_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc3_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc3_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc3_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc3_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc3_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc3_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc3_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc3_clk}] -min -add_delay 2.1 [get_ports {adc3_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc3_clk}] -max -add_delay 3.5 [get_ports {adc3_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc3_clk}] -min -add_delay 2.1 [get_ports {adc3_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc3_clk}] -max -add_delay 3.5 [get_ports {adc3_dq_adc_dq_n[*]}]
# IDELAY
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_3/IDELAYE2_CLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_3/DATA[*].IDELAYE2_DAT}]

## ADC_4
# Clock
set_property -dict {PACKAGE_PIN AK7 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_clk_p]
set_property -dict {PACKAGE_PIN AL7 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_clk_n]
create_clock -period 8.000 -name adc4_clk [get_ports adc4_dq_adc_clk_p]
# Data
set_property -dict {PACKAGE_PIN AJ8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_p[0]]
set_property -dict {PACKAGE_PIN AK8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_n[0]]
set_property -dict {PACKAGE_PIN AN7  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_p[1]]
set_property -dict {PACKAGE_PIN AN6  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_n[1]]
set_property -dict {PACKAGE_PIN AN9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_p[2]]
set_property -dict {PACKAGE_PIN AP9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_n[2]]
set_property -dict {PACKAGE_PIN AN8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_p[3]]
set_property -dict {PACKAGE_PIN AP8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_n[3]]
set_property -dict {PACKAGE_PIN AL9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_p[4]]
set_property -dict {PACKAGE_PIN AM9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_n[4]]
set_property -dict {PACKAGE_PIN AP11 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_p[5]]
set_property -dict {PACKAGE_PIN AP10 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_n[5]]
set_property -dict {PACKAGE_PIN AJ10 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_p[6]]
set_property -dict {PACKAGE_PIN AK10 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc4_dq_adc_dq_n[6]]
# Input Delays
set_input_delay -clock [get_clocks {adc4_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc4_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc4_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc4_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc4_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc4_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc4_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc4_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc4_clk}] -min -add_delay 2.1 [get_ports {adc4_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc4_clk}] -max -add_delay 3.5 [get_ports {adc4_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc4_clk}] -min -add_delay 2.1 [get_ports {adc4_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc4_clk}] -max -add_delay 3.5 [get_ports {adc4_dq_adc_dq_n[*]}]
# IDELAY
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_4/IDELAYE2_CLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_4/DATA[*].IDELAYE2_DAT}]

## ADC_5
# Clock
set_property -dict {PACKAGE_PIN AE5 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_clk_p]
set_property -dict {PACKAGE_PIN AF5 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_clk_n]
create_clock -period 8.000 -name adc5_clk [get_ports adc5_dq_adc_clk_p]
# Data
set_property -dict {PACKAGE_PIN AD1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_p[0]]
set_property -dict {PACKAGE_PIN AE1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_n[0]]
set_property -dict {PACKAGE_PIN AG1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_p[1]]
set_property -dict {PACKAGE_PIN AH1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_n[1]]
set_property -dict {PACKAGE_PIN AE2 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_p[2]]
set_property -dict {PACKAGE_PIN AF2 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_n[2]]
set_property -dict {PACKAGE_PIN AF3 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_p[3]]
set_property -dict {PACKAGE_PIN AG2 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_n[3]]
set_property -dict {PACKAGE_PIN AF4 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_p[4]]
set_property -dict {PACKAGE_PIN AG4 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_n[4]]
set_property -dict {PACKAGE_PIN AH3 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_p[5]]
set_property -dict {PACKAGE_PIN AJ3 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_n[5]]
set_property -dict {PACKAGE_PIN AH2 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_p[6]]
set_property -dict {PACKAGE_PIN AJ1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc5_dq_adc_dq_n[6]]
# Input Delays
set_input_delay -clock [get_clocks {adc5_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc5_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc5_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc5_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc5_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc5_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc5_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc5_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc5_clk}] -min -add_delay 2.1 [get_ports {adc5_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc5_clk}] -max -add_delay 3.5 [get_ports {adc5_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc5_clk}] -min -add_delay 2.1 [get_ports {adc5_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc5_clk}] -max -add_delay 3.5 [get_ports {adc5_dq_adc_dq_n[*]}]
# IDELAY
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_5/IDELAYE2_CLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_5/DATA[*].IDELAYE2_DAT}]

## ADC_6
# Clock
set_property -dict {PACKAGE_PIN AD6 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_clk_p]
set_property -dict {PACKAGE_PIN AE6 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_clk_n]
create_clock -period 8.000 -name adc6_clk [get_ports adc6_dq_adc_clk_p]
# Data
set_property -dict {PACKAGE_PIN AF9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_p[0]]
set_property -dict {PACKAGE_PIN AF8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_n[0]]
set_property -dict {PACKAGE_PIN AD9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_p[1]]
set_property -dict {PACKAGE_PIN AD8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_n[1]]
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_p[2]]
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_n[2]]
set_property -dict {PACKAGE_PIN AH9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_p[3]]
set_property -dict {PACKAGE_PIN AH8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_n[3]]
set_property -dict {PACKAGE_PIN AE8  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_p[4]]
set_property -dict {PACKAGE_PIN AE7  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_n[4]]
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_p[5]]
set_property -dict {PACKAGE_PIN AG9  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_n[5]]
set_property -dict {PACKAGE_PIN AH7  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_p[6]]
set_property -dict {PACKAGE_PIN AH6  IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc6_dq_adc_dq_n[6]]
# Input Delays
set_input_delay -clock [get_clocks {adc6_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc6_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc6_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc6_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc6_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc6_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc6_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc6_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc6_clk}] -min -add_delay 2.1 [get_ports {adc6_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc6_clk}] -max -add_delay 3.5 [get_ports {adc6_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc6_clk}] -min -add_delay 2.1 [get_ports {adc6_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc6_clk}] -max -add_delay 3.5 [get_ports {adc6_dq_adc_dq_n[*]}]
# IDELAY
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_6/IDELAYE2_CLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_6/DATA[*].IDELAYE2_DAT}]

## ADC_7
# Clock
set_property -dict {PACKAGE_PIN AJ6 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_clk_p]
set_property -dict {PACKAGE_PIN AK6 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_clk_n]
create_clock -period 8.000 -name adc7_clk [get_ports adc7_dq_adc_clk_p]
# Data
set_property -dict {PACKAGE_PIN AK2 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_p[0]]
set_property -dict {PACKAGE_PIN AK1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_n[0]]
set_property -dict {PACKAGE_PIN AN4 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_p[1]]
set_property -dict {PACKAGE_PIN AP4 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_n[1]]
set_property -dict {PACKAGE_PIN AK3 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_p[2]]
set_property -dict {PACKAGE_PIN AL3 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_n[2]]
set_property -dict {PACKAGE_PIN AM2 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_p[3]]
set_property -dict {PACKAGE_PIN AN2 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_n[3]]
set_property -dict {PACKAGE_PIN AL2 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_p[4]]
set_property -dict {PACKAGE_PIN AM1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_n[4]]
set_property -dict {PACKAGE_PIN AN3 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_p[5]]
set_property -dict {PACKAGE_PIN AP3 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_n[5]]
set_property -dict {PACKAGE_PIN AN1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_p[6]]
set_property -dict {PACKAGE_PIN AP1 IOSTANDARD LVDS_25 DIFF_TERM TRUE} [get_ports adc7_dq_adc_dq_n[6]]
# Input Delays
set_input_delay -clock [get_clocks {adc7_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc7_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc7_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc7_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc7_clk}] -clock_fall -min -add_delay 2.1 [get_ports {adc7_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc7_clk}] -clock_fall -max -add_delay 3.5 [get_ports {adc7_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc7_clk}] -min -add_delay 2.1 [get_ports {adc7_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc7_clk}] -max -add_delay 3.5 [get_ports {adc7_dq_adc_dq_p[*]}]
set_input_delay -clock [get_clocks {adc7_clk}] -min -add_delay 2.1 [get_ports {adc7_dq_adc_dq_n[*]}]
set_input_delay -clock [get_clocks {adc7_clk}] -max -add_delay 3.5 [get_ports {adc7_dq_adc_dq_n[*]}]
# IDELAY
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_7/IDELAYE2_CLK}]
set_property IDELAY_VALUE 0 [get_cells -hier -filter {NAME =~ *adc8_0/**/adc_if_inst_7/DATA[*].IDELAYE2_DAT}]


## Special Clock Constraints
set_clock_groups -asynchronous \
-group [list [get_clocks adc*_clk]] \
-group [list [get_clocks -of_objects [get_pins -hierarchical *adc8*/aclk]]]
