#set_property IDELAY_VALUE 0 [get_cells -hierarchical *eth_mac*/phy_rx_ctl_idelay]
#set_property IDELAY_VALUE 0 [get_cells -hierarchical *eth_mac*/phy_rxd_idelay*]      

#set_property IODELAY_GROUP "RGMII_DELAY_GROUP" [get_cells -hierarchical *eth_mac*/phy_rx_ctl_idelay]
#set_property IODELAY_GROUP "RGMII_DELAY_GROUP" [get_cells -hierarchical *eth_mac*/phy_rxd_idelay*]      
#set_property IODELAY_GROUP "RGMII_DELAY_GROUP" [get_cells -hierarchical *eth_mac*/idelayctrl_inst]
