#
# Top Constraints
#

# System
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]

# System Clock
set_property PACKAGE_PIN AG20 [get_ports sys_clk_p]
set_property PACKAGE_PIN AH20 [get_ports sys_clk_n]
create_clock -period 10.000 -name sys_clk [get_ports sys_clk_p]

# Clock Generator
set_property -dict {PACKAGE_PIN R25 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {clk_gen0_ss[0]}]
set_property -dict {PACKAGE_PIN P25 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {clk_gen0_ss[1]}]
set_property -dict {PACKAGE_PIN U26 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}	[get_ports {clk_gen0_oe[0]}]
set_property -dict {PACKAGE_PIN U27 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}	[get_ports {clk_gen0_oe[1]}]
set_property -dict {PACKAGE_PIN T25 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {clk_gen0_sclk}]
#set_property -dict {PACKAGE_PIN P24 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {clk_gen0_data}]

set_property -dict {PACKAGE_PIN V33 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {clk_gen1_ss[0]}]
set_property -dict {PACKAGE_PIN W34 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {clk_gen1_ss[1]}]
set_property -dict {PACKAGE_PIN V34 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}	[get_ports {clk_gen1_oe[0]}]
set_property -dict {PACKAGE_PIN W33 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {clk_gen1_sclk}]
#set_property -dict {PACKAGE_PIN AA34 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {clk_gen0_data}]

# I2C GPIO
set_property -dict {PACKAGE_PIN N27 IOSTANDARD LVCMOS33 PULLUP true} [get_ports gpio_scl_io]
set_property -dict {PACKAGE_PIN N26 IOSTANDARD LVCMOS33 PULLUP true} [get_ports gpio_sda_io]

# USB-UART
set_property -dict {PACKAGE_PIN V32 IOSTANDARD LVCMOS33 PULLUP true} [get_ports uart_rx]
set_property -dict {PACKAGE_PIN W30 IOSTANDARD LVCMOS33 PULLUP true} [get_ports uart_tx]

# LED
set_property -dict {PACKAGE_PIN AC34 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led_fast[0]}]
set_property -dict {PACKAGE_PIN AB34 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led_fast[1]}]
set_property -dict {PACKAGE_PIN AC33 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led_fast[2]}]
set_property -dict {PACKAGE_PIN AA33 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {led_fast[3]}]

