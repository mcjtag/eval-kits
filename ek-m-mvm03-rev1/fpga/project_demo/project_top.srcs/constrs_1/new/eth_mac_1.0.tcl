# RGMII PHY IF timing constraints

foreach if_inst [get_cells -hier -filter {(ORIG_REF_NAME == rgmii_phy_if || REF_NAME == rgmii_phy_if)}] {
	set reset_ffs [get_cells -hier -regexp ".*/(rx|tx)_rst_reg_reg\\\[\\d\\\]" -filter "PARENT == $if_inst"]
	set_property ASYNC_REG TRUE $reset_ffs
	set_false_path -to [get_pins -of_objects $reset_ffs -filter {IS_PRESET || IS_RESET}]
	set_property ASYNC_REG TRUE [get_cells $if_inst/clk_oddr_inst/ODDR[0].oddr_inst]
	set src_clk [get_clocks -of_objects [get_pins $if_inst/rgmii_tx_clk_1_reg/C]]
	set_max_delay -from [get_cells $if_inst/rgmii_tx_clk_1_reg] -to [get_cells $if_inst/clk_oddr_inst/ODDR[0].oddr_inst] -datapath_only [expr [get_property -min PERIOD $src_clk]/4]
	set_max_delay -from [get_cells $if_inst/rgmii_tx_clk_2_reg] -to [get_cells $if_inst/clk_oddr_inst/ODDR[0].oddr_inst] -datapath_only [expr [get_property -min PERIOD $src_clk]/4]
}

# RGMII Gigabit Ethernet MAC timing constraints

foreach mac_inst [get_cells -hier -filter {(ORIG_REF_NAME == eth_mac_1g_rgmii || REF_NAME == eth_mac_1g_rgmii)}] {
	set select_ffs [get_cells -hier -regexp ".*/tx_mii_select_sync_reg\\\[\\d\\\]" -filter "PARENT == $mac_inst"]
	if {[llength $select_ffs]} {
		set_property ASYNC_REG TRUE $select_ffs
		set src_clk [get_clocks -of_objects [get_pins $mac_inst/mii_select_reg_reg/C]]
		set_max_delay -from [get_cells $mac_inst/mii_select_reg_reg] -to [get_cells $mac_inst/tx_mii_select_sync_reg[0]] -datapath_only [get_property -min PERIOD $src_clk]
	}

	set select_ffs [get_cells -hier -regexp ".*/rx_mii_select_sync_reg\\\[\\d\\\]" -filter "PARENT == $mac_inst"]
	if {[llength $select_ffs]} {
		set_property ASYNC_REG TRUE $select_ffs
		set src_clk [get_clocks -of_objects [get_pins $mac_inst/mii_select_reg_reg/C]]
		set_max_delay -from [get_cells $mac_inst/mii_select_reg_reg] -to [get_cells $mac_inst/rx_mii_select_sync_reg[0]] -datapath_only [get_property -min PERIOD $src_clk]
	}

	set prescale_ffs [get_cells -hier -regexp ".*/rx_prescale_sync_reg\\\[\\d\\\]" -filter "PARENT == $mac_inst"]
	if {[llength $prescale_ffs]} {
		set_property ASYNC_REG TRUE $prescale_ffs
		set src_clk [get_clocks -of_objects [get_pins $mac_inst/rx_prescale_reg[2]/C]]
		set_max_delay -from [get_cells $mac_inst/rx_prescale_reg[2]] -to [get_cells $mac_inst/rx_prescale_sync_reg[0]] -datapath_only [get_property -min PERIOD $src_clk]
	}
}
