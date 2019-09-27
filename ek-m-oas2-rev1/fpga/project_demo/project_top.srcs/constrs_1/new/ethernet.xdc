#
# Ethernet 10/100/1000
#

set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {rgmii_td[0]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {rgmii_td[1]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {rgmii_td[2]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {rgmii_td[3]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports rgmii_tx_ctl]
set_property -dict {PACKAGE_PIN W12 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports rgmii_txc]

set_property -dict {PACKAGE_PIN W10 IOSTANDARD LVCMOS33} [get_ports {rgmii_rd[0]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports {rgmii_rd[1]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {rgmii_rd[2]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {rgmii_rd[3]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports rgmii_rx_ctl]
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33} [get_ports rgmii_rxc]

set_property -dict {PACKAGE_PIN AA10 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports mdc]
set_property -dict {PACKAGE_PIN AA11 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports mdio]
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports phy_rst]

create_clock -period 8.000 -name rgmii_clk [get_ports rgmii_rxc]