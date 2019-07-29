# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {General}]
  set C_S_AXI_DATA_WIDTH [ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_S_AXI_DATA_WIDTH}
  set C_S_AXI_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_S_AXI_ADDR_WIDTH}
  ipgui::add_param $IPINST -name "C_S_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_HIGHADDR" -parent ${Page_0}

  #Adding Page
  set Parameters [ipgui::add_page $IPINST -name "Parameters"]
  #Adding Group
  set Clock [ipgui::add_group $IPINST -name "Clock" -parent ${Parameters}]
  ipgui::add_param $IPINST -name "SYNC_CLK_WIDTH" -parent ${Clock}

  #Adding Group
  set Link [ipgui::add_group $IPINST -name "Link" -parent ${Parameters}]
  ipgui::add_param $IPINST -name "SYNC_LNK_CDELAY" -parent ${Link}
  ipgui::add_param $IPINST -name "SYNC_LNK_CWIDTH" -parent ${Link}
  ipgui::add_param $IPINST -name "SYNC_LNK_DDELAY" -parent ${Link}
  ipgui::add_param $IPINST -name "SYNC_LNK_DWIDTH" -parent ${Link}

  #Adding Group
  set Raw [ipgui::add_group $IPINST -name "Raw" -parent ${Parameters}]
  ipgui::add_param $IPINST -name "SYNC_RAW_DWIDTH" -parent ${Raw}

  #Adding Group
  set DDC [ipgui::add_group $IPINST -name "DDC" -parent ${Parameters}]
  ipgui::add_param $IPINST -name "SYNC_CAP_CDELAY" -parent ${DDC}
  ipgui::add_param $IPINST -name "SYNC_CAP_CWIDTH" -parent ${DDC}
  ipgui::add_param $IPINST -name "SYNC_CAP_DDC_DDELAY" -parent ${DDC}
  ipgui::add_param $IPINST -name "SYNC_CAP_DDC_DWIDTH" -parent ${DDC}
  ipgui::add_param $IPINST -name "SYNC_CAP_LNK_DDELAY" -parent ${DDC}
  ipgui::add_param $IPINST -name "SYNC_CAP_LNK_DWIDTH" -parent ${DDC}



}

proc update_PARAM_VALUE.SYNC_CAP_CDELAY { PARAM_VALUE.SYNC_CAP_CDELAY } {
	# Procedure called to update SYNC_CAP_CDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_CAP_CDELAY { PARAM_VALUE.SYNC_CAP_CDELAY } {
	# Procedure called to validate SYNC_CAP_CDELAY
	return true
}

proc update_PARAM_VALUE.SYNC_CAP_CWIDTH { PARAM_VALUE.SYNC_CAP_CWIDTH } {
	# Procedure called to update SYNC_CAP_CWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_CAP_CWIDTH { PARAM_VALUE.SYNC_CAP_CWIDTH } {
	# Procedure called to validate SYNC_CAP_CWIDTH
	return true
}

proc update_PARAM_VALUE.SYNC_CAP_DDC_DDELAY { PARAM_VALUE.SYNC_CAP_DDC_DDELAY } {
	# Procedure called to update SYNC_CAP_DDC_DDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_CAP_DDC_DDELAY { PARAM_VALUE.SYNC_CAP_DDC_DDELAY } {
	# Procedure called to validate SYNC_CAP_DDC_DDELAY
	return true
}

proc update_PARAM_VALUE.SYNC_CAP_DDC_DWIDTH { PARAM_VALUE.SYNC_CAP_DDC_DWIDTH } {
	# Procedure called to update SYNC_CAP_DDC_DWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_CAP_DDC_DWIDTH { PARAM_VALUE.SYNC_CAP_DDC_DWIDTH } {
	# Procedure called to validate SYNC_CAP_DDC_DWIDTH
	return true
}

proc update_PARAM_VALUE.SYNC_CAP_LNK_DDELAY { PARAM_VALUE.SYNC_CAP_LNK_DDELAY } {
	# Procedure called to update SYNC_CAP_LNK_DDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_CAP_LNK_DDELAY { PARAM_VALUE.SYNC_CAP_LNK_DDELAY } {
	# Procedure called to validate SYNC_CAP_LNK_DDELAY
	return true
}

proc update_PARAM_VALUE.SYNC_CAP_LNK_DWIDTH { PARAM_VALUE.SYNC_CAP_LNK_DWIDTH } {
	# Procedure called to update SYNC_CAP_LNK_DWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_CAP_LNK_DWIDTH { PARAM_VALUE.SYNC_CAP_LNK_DWIDTH } {
	# Procedure called to validate SYNC_CAP_LNK_DWIDTH
	return true
}

proc update_PARAM_VALUE.SYNC_CLK_WIDTH { PARAM_VALUE.SYNC_CLK_WIDTH } {
	# Procedure called to update SYNC_CLK_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_CLK_WIDTH { PARAM_VALUE.SYNC_CLK_WIDTH } {
	# Procedure called to validate SYNC_CLK_WIDTH
	return true
}

proc update_PARAM_VALUE.SYNC_LNK_CDELAY { PARAM_VALUE.SYNC_LNK_CDELAY } {
	# Procedure called to update SYNC_LNK_CDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_LNK_CDELAY { PARAM_VALUE.SYNC_LNK_CDELAY } {
	# Procedure called to validate SYNC_LNK_CDELAY
	return true
}

proc update_PARAM_VALUE.SYNC_LNK_CWIDTH { PARAM_VALUE.SYNC_LNK_CWIDTH } {
	# Procedure called to update SYNC_LNK_CWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_LNK_CWIDTH { PARAM_VALUE.SYNC_LNK_CWIDTH } {
	# Procedure called to validate SYNC_LNK_CWIDTH
	return true
}

proc update_PARAM_VALUE.SYNC_LNK_DDELAY { PARAM_VALUE.SYNC_LNK_DDELAY } {
	# Procedure called to update SYNC_LNK_DDELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_LNK_DDELAY { PARAM_VALUE.SYNC_LNK_DDELAY } {
	# Procedure called to validate SYNC_LNK_DDELAY
	return true
}

proc update_PARAM_VALUE.SYNC_LNK_DWIDTH { PARAM_VALUE.SYNC_LNK_DWIDTH } {
	# Procedure called to update SYNC_LNK_DWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_LNK_DWIDTH { PARAM_VALUE.SYNC_LNK_DWIDTH } {
	# Procedure called to validate SYNC_LNK_DWIDTH
	return true
}

proc update_PARAM_VALUE.SYNC_RAW_DWIDTH { PARAM_VALUE.SYNC_RAW_DWIDTH } {
	# Procedure called to update SYNC_RAW_DWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYNC_RAW_DWIDTH { PARAM_VALUE.SYNC_RAW_DWIDTH } {
	# Procedure called to validate SYNC_RAW_DWIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to update C_S_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to validate C_S_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to update C_S_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_HIGHADDR { PARAM_VALUE.C_S_AXI_HIGHADDR } {
	# Procedure called to validate C_S_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.SYNC_CLK_WIDTH { MODELPARAM_VALUE.SYNC_CLK_WIDTH PARAM_VALUE.SYNC_CLK_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_CLK_WIDTH}] ${MODELPARAM_VALUE.SYNC_CLK_WIDTH}
}

proc update_MODELPARAM_VALUE.SYNC_CAP_CDELAY { MODELPARAM_VALUE.SYNC_CAP_CDELAY PARAM_VALUE.SYNC_CAP_CDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_CAP_CDELAY}] ${MODELPARAM_VALUE.SYNC_CAP_CDELAY}
}

proc update_MODELPARAM_VALUE.SYNC_CAP_CWIDTH { MODELPARAM_VALUE.SYNC_CAP_CWIDTH PARAM_VALUE.SYNC_CAP_CWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_CAP_CWIDTH}] ${MODELPARAM_VALUE.SYNC_CAP_CWIDTH}
}

proc update_MODELPARAM_VALUE.SYNC_LNK_CDELAY { MODELPARAM_VALUE.SYNC_LNK_CDELAY PARAM_VALUE.SYNC_LNK_CDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_LNK_CDELAY}] ${MODELPARAM_VALUE.SYNC_LNK_CDELAY}
}

proc update_MODELPARAM_VALUE.SYNC_LNK_DDELAY { MODELPARAM_VALUE.SYNC_LNK_DDELAY PARAM_VALUE.SYNC_LNK_DDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_LNK_DDELAY}] ${MODELPARAM_VALUE.SYNC_LNK_DDELAY}
}

proc update_MODELPARAM_VALUE.SYNC_LNK_CWIDTH { MODELPARAM_VALUE.SYNC_LNK_CWIDTH PARAM_VALUE.SYNC_LNK_CWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_LNK_CWIDTH}] ${MODELPARAM_VALUE.SYNC_LNK_CWIDTH}
}

proc update_MODELPARAM_VALUE.SYNC_LNK_DWIDTH { MODELPARAM_VALUE.SYNC_LNK_DWIDTH PARAM_VALUE.SYNC_LNK_DWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_LNK_DWIDTH}] ${MODELPARAM_VALUE.SYNC_LNK_DWIDTH}
}

proc update_MODELPARAM_VALUE.SYNC_RAW_DWIDTH { MODELPARAM_VALUE.SYNC_RAW_DWIDTH PARAM_VALUE.SYNC_RAW_DWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_RAW_DWIDTH}] ${MODELPARAM_VALUE.SYNC_RAW_DWIDTH}
}

proc update_MODELPARAM_VALUE.SYNC_CAP_DDC_DDELAY { MODELPARAM_VALUE.SYNC_CAP_DDC_DDELAY PARAM_VALUE.SYNC_CAP_DDC_DDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_CAP_DDC_DDELAY}] ${MODELPARAM_VALUE.SYNC_CAP_DDC_DDELAY}
}

proc update_MODELPARAM_VALUE.SYNC_CAP_DDC_DWIDTH { MODELPARAM_VALUE.SYNC_CAP_DDC_DWIDTH PARAM_VALUE.SYNC_CAP_DDC_DWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_CAP_DDC_DWIDTH}] ${MODELPARAM_VALUE.SYNC_CAP_DDC_DWIDTH}
}

proc update_MODELPARAM_VALUE.SYNC_CAP_LNK_DDELAY { MODELPARAM_VALUE.SYNC_CAP_LNK_DDELAY PARAM_VALUE.SYNC_CAP_LNK_DDELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_CAP_LNK_DDELAY}] ${MODELPARAM_VALUE.SYNC_CAP_LNK_DDELAY}
}

proc update_MODELPARAM_VALUE.SYNC_CAP_LNK_DWIDTH { MODELPARAM_VALUE.SYNC_CAP_LNK_DWIDTH PARAM_VALUE.SYNC_CAP_LNK_DWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYNC_CAP_LNK_DWIDTH}] ${MODELPARAM_VALUE.SYNC_CAP_LNK_DWIDTH}
}

