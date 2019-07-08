#
# Ethernet 10/100/1000
#

set_property -dict {PACKAGE_PIN N29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports rgmii_td[0]]
set_property -dict {PACKAGE_PIN M29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports rgmii_td[1]]
set_property -dict {PACKAGE_PIN P29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports rgmii_td[2]]; # U29
set_property -dict {PACKAGE_PIN T29 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports rgmii_td[3]]
set_property -dict {PACKAGE_PIN R28 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports rgmii_tx_ctl]
set_property -dict {PACKAGE_PIN R33 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports rgmii_txc]

set_property -dict {PACKAGE_PIN P33 IOSTANDARD LVCMOS33} [get_ports rgmii_rd[0]]
set_property -dict {PACKAGE_PIN N34 IOSTANDARD LVCMOS33} [get_ports rgmii_rd[1]]
set_property -dict {PACKAGE_PIN N33 IOSTANDARD LVCMOS33} [get_ports rgmii_rd[2]]
set_property -dict {PACKAGE_PIN M34 IOSTANDARD LVCMOS33} [get_ports rgmii_rd[3]]
set_property -dict {PACKAGE_PIN P34 IOSTANDARD LVCMOS33} [get_ports rgmii_rx_ctl]
set_property -dict {PACKAGE_PIN U29 IOSTANDARD LVCMOS33} [get_ports rgmii_rxc] ; # P29

set_property -dict {PACKAGE_PIN T33 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports mdc]
set_property -dict {PACKAGE_PIN T34 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports mdio]
set_property -dict {PACKAGE_PIN U32 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports phy_rst]

create_clock -period 8.000 -name rgmii_clk [get_ports rgmii_rxc]