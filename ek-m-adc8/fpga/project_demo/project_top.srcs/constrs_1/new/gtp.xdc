#
# GT Constraints
#

## Redriver
#set_property -dict {PACKAGE_PIN R30 IOSTANDARD LVCMOS33} [get_ports pcie_rdrv_scl]
#set_property -dict {PACKAGE_PIN P30 IOSTANDARD LVCMOS33} [get_ports pcie_rdrv_sda]

## PCIe Sig
#set_property -dict {PACKAGE_PIN P34 IOSTANDARD LVCMOS33} [get_ports pcie_sig_cperst]
#set_property -dict {PACKAGE_PIN U24 IOSTANDARD LVCMOS33} [get_ports pcie_sig_cwake]

## PCI Gen
#set_property -dict {PACKAGE_PIN Y30  IOSTANDARD LVCMOS33} [get_ports pcie_gen_scl]
#set_property -dict {PACKAGE_PIN AC34 IOSTANDARD LVCMOS33} [get_ports pcie_gen_sda]
#set_property -dict {PACKAGE_PIN AB31 IOSTANDARD LVCMOS33} [get_ports pcie_gen_ss[0]]
#set_property -dict {PACKAGE_PIN AC33 IOSTANDARD LVCMOS33} [get_ports pcie_gen_ss[1]]
#set_property -dict {PACKAGE_PIN AB32 IOSTANDARD LVCMOS33} [get_ports pcie_gen_diff]

## GTP
#set_property PACKAGE_PIN H18 [get_ports gt_refclk0_p]
#set_property PACKAGE_PIN G18 [get_ports gt_refclk0_n]
#set_property PACKAGE_PIN H20 [get_ports gt_refclk1_p]
#set_property PACKAGE_PIN G20 [get_ports gt_refclk1_n]
#set_property PACKAGE_PIN F21 [get_ports gt_rxp[0]]
#set_property PACKAGE_PIN E21 [get_ports gt_rxn[0]]
#set_property PACKAGE_PIN D20 [get_ports gt_rxp[1]]
#set_property PACKAGE_PIN C20 [get_ports gt_rxn[1]]
#set_property PACKAGE_PIN F19 [get_ports gt_rxp[2]]
#set_property PACKAGE_PIN E19 [get_ports gt_rxn[2]]
#set_property PACKAGE_PIN D18 [get_ports gt_rxp[3]]
#set_property PACKAGE_PIN C18 [get_ports gt_rxn[3]]
#set_property PACKAGE_PIN B23 [get_ports gt_txp[0]]
#set_property PACKAGE_PIN A23 [get_ports gt_txn[0]]
#set_property PACKAGE_PIN D22 [get_ports gt_txp[1]]
#set_property PACKAGE_PIN C22 [get_ports gt_txn[1]]
#set_property PACKAGE_PIN B21 [get_ports gt_txp[2]]
#set_property PACKAGE_PIN A21 [get_ports gt_txn[2]]
#set_property PACKAGE_PIN B19 [get_ports gt_txp[3]]
#set_property PACKAGE_PIN A19 [get_ports gt_txn[3]]     

#create_clock -period 10.000 -name gt_clk0 [get_ports gt_refclk0_p]
#create_clock -period 10.000 -name gt_clk1 [get_ports gt_refclk1_p] 
