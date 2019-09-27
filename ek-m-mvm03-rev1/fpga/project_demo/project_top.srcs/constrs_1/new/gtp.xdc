#
# GTP/Redriver Constraints
#

### GTP
## GTP_0
#set_property PACKAGE_PIN H20 [get_ports gt0_refclk_p]
#set_property PACKAGE_PIN G20 [get_ports gt0_refclk_n]
#set_property PACKAGE_PIN F21 [get_ports gt0_rxp[0]]
#set_property PACKAGE_PIN E21 [get_ports gt0_rxn[0]]
#set_property PACKAGE_PIN D20 [get_ports gt0_rxp[1]]
#set_property PACKAGE_PIN C20 [get_ports gt0_rxn[1]]
#set_property PACKAGE_PIN F19 [get_ports gt0_rxp[2]]
#set_property PACKAGE_PIN E19 [get_ports gt0_rxn[2]]
#set_property PACKAGE_PIN D18 [get_ports gt0_rxp[3]]
#set_property PACKAGE_PIN C18 [get_ports gt0_rxn[3]]
#set_property PACKAGE_PIN B23 [get_ports gt0_txp[0]]
#set_property PACKAGE_PIN A23 [get_ports gt0_txn[0]]
#set_property PACKAGE_PIN D22 [get_ports gt0_txp[1]]
#set_property PACKAGE_PIN C22 [get_ports gt0_txn[1]]
#set_property PACKAGE_PIN B21 [get_ports gt0_txp[2]]
#set_property PACKAGE_PIN A21 [get_ports gt0_txn[2]]
#set_property PACKAGE_PIN B19 [get_ports gt0_txp[3]]
#set_property PACKAGE_PIN A19 [get_ports gt0_txn[3]]
#create_clock -period 10.000 -name gt0_clk [get_ports gt0_refclk_p]
### GTP_1
#set_property PACKAGE_PIN H16 [get_ports gt1_refclk_p]
#set_property PACKAGE_PIN G16 [get_ports gt1_refclk_n]
#set_property PACKAGE_PIN F13 [get_ports gt1_rxp[0]]
#set_property PACKAGE_PIN E13 [get_ports gt1_rxn[0]]
#set_property PACKAGE_PIN F15 [get_ports gt1_rxp[1]]
#set_property PACKAGE_PIN E15 [get_ports gt1_rxn[1]]
#set_property PACKAGE_PIN D16 [get_ports gt1_rxp[2]]
#set_property PACKAGE_PIN C16 [get_ports gt1_rxn[2]]
#set_property PACKAGE_PIN F17 [get_ports gt1_rxp[3]]
#set_property PACKAGE_PIN E17 [get_ports gt1_rxn[3]]
#set_property PACKAGE_PIN B13 [get_ports gt1_txp[0]]
#set_property PACKAGE_PIN A13 [get_ports gt1_txn[0]]
#set_property PACKAGE_PIN D14 [get_ports gt1_txp[1]]
#set_property PACKAGE_PIN C14 [get_ports gt1_txn[1]]
#set_property PACKAGE_PIN B15 [get_ports gt1_txp[2]]
#set_property PACKAGE_PIN A15 [get_ports gt1_txn[2]]
#set_property PACKAGE_PIN B17 [get_ports gt1_txp[3]]
#set_property PACKAGE_PIN A17 [get_ports gt1_txn[3]]
#create_clock -period 10.000 -name gt1_clk [get_ports gt1_refclk_p]

### ReDriver
set_property -dict {PACKAGE_PIN AB24 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {rdr_scl}]
#set_property -dict {PACKAGE_PIN AB25 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports {rdr_sda}]