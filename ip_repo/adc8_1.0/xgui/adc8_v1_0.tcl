# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {Delay Settings}]
  set_property tooltip {Delay Settings} ${Page_0}
  #Adding Group
  set Delay_0 [ipgui::add_group $IPINST -name "Delay 0" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "DELAY_CTRL_ENABLE_0" -parent ${Delay_0} -widget comboBox
  ipgui::add_param $IPINST -name "DELAY_GROUP_0" -parent ${Delay_0}

  #Adding Group
  set Delay_1 [ipgui::add_group $IPINST -name "Delay 1" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "DELAY_CTRL_ENABLE_1" -parent ${Delay_1} -widget comboBox
  ipgui::add_param $IPINST -name "DELAY_GROUP_1" -parent ${Delay_1}

  #Adding Group
  set Delay_2 [ipgui::add_group $IPINST -name "Delay 2" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "DELAY_CTRL_ENABLE_2" -parent ${Delay_2} -widget comboBox
  ipgui::add_param $IPINST -name "DELAY_GROUP_2" -parent ${Delay_2}

  #Adding Group
  set Delay_3 [ipgui::add_group $IPINST -name "Delay 3" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "DELAY_CTRL_ENABLE_3" -parent ${Delay_3} -widget comboBox
  ipgui::add_param $IPINST -name "DELAY_GROUP_3" -parent ${Delay_3}

  #Adding Group
  set Delay_4 [ipgui::add_group $IPINST -name "Delay 4" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "DELAY_CTRL_ENABLE_4" -parent ${Delay_4} -widget comboBox
  ipgui::add_param $IPINST -name "DELAY_GROUP_4" -parent ${Delay_4}

  #Adding Group
  set Delay_5 [ipgui::add_group $IPINST -name "Delay 5" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "DELAY_CTRL_ENABLE_5" -parent ${Delay_5} -widget comboBox
  ipgui::add_param $IPINST -name "DELAY_GROUP_5" -parent ${Delay_5}

  #Adding Group
  set Delay_6 [ipgui::add_group $IPINST -name "Delay 6" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "DELAY_CTRL_ENABLE_6" -parent ${Delay_6} -widget comboBox
  ipgui::add_param $IPINST -name "DELAY_GROUP_6" -parent ${Delay_6}

  #Adding Group
  set Delay_7 [ipgui::add_group $IPINST -name "Delay 7" -parent ${Page_0} -layout horizontal]
  ipgui::add_param $IPINST -name "DELAY_CTRL_ENABLE_7" -parent ${Delay_7} -widget comboBox
  ipgui::add_param $IPINST -name "DELAY_GROUP_7" -parent ${Delay_7}



}

proc update_PARAM_VALUE.DELAY_CTRL_ENABLE_0 { PARAM_VALUE.DELAY_CTRL_ENABLE_0 } {
	# Procedure called to update DELAY_CTRL_ENABLE_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_CTRL_ENABLE_0 { PARAM_VALUE.DELAY_CTRL_ENABLE_0 } {
	# Procedure called to validate DELAY_CTRL_ENABLE_0
	return true
}

proc update_PARAM_VALUE.DELAY_CTRL_ENABLE_1 { PARAM_VALUE.DELAY_CTRL_ENABLE_1 } {
	# Procedure called to update DELAY_CTRL_ENABLE_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_CTRL_ENABLE_1 { PARAM_VALUE.DELAY_CTRL_ENABLE_1 } {
	# Procedure called to validate DELAY_CTRL_ENABLE_1
	return true
}

proc update_PARAM_VALUE.DELAY_CTRL_ENABLE_2 { PARAM_VALUE.DELAY_CTRL_ENABLE_2 } {
	# Procedure called to update DELAY_CTRL_ENABLE_2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_CTRL_ENABLE_2 { PARAM_VALUE.DELAY_CTRL_ENABLE_2 } {
	# Procedure called to validate DELAY_CTRL_ENABLE_2
	return true
}

proc update_PARAM_VALUE.DELAY_CTRL_ENABLE_3 { PARAM_VALUE.DELAY_CTRL_ENABLE_3 } {
	# Procedure called to update DELAY_CTRL_ENABLE_3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_CTRL_ENABLE_3 { PARAM_VALUE.DELAY_CTRL_ENABLE_3 } {
	# Procedure called to validate DELAY_CTRL_ENABLE_3
	return true
}

proc update_PARAM_VALUE.DELAY_CTRL_ENABLE_4 { PARAM_VALUE.DELAY_CTRL_ENABLE_4 } {
	# Procedure called to update DELAY_CTRL_ENABLE_4 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_CTRL_ENABLE_4 { PARAM_VALUE.DELAY_CTRL_ENABLE_4 } {
	# Procedure called to validate DELAY_CTRL_ENABLE_4
	return true
}

proc update_PARAM_VALUE.DELAY_CTRL_ENABLE_5 { PARAM_VALUE.DELAY_CTRL_ENABLE_5 } {
	# Procedure called to update DELAY_CTRL_ENABLE_5 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_CTRL_ENABLE_5 { PARAM_VALUE.DELAY_CTRL_ENABLE_5 } {
	# Procedure called to validate DELAY_CTRL_ENABLE_5
	return true
}

proc update_PARAM_VALUE.DELAY_CTRL_ENABLE_6 { PARAM_VALUE.DELAY_CTRL_ENABLE_6 } {
	# Procedure called to update DELAY_CTRL_ENABLE_6 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_CTRL_ENABLE_6 { PARAM_VALUE.DELAY_CTRL_ENABLE_6 } {
	# Procedure called to validate DELAY_CTRL_ENABLE_6
	return true
}

proc update_PARAM_VALUE.DELAY_CTRL_ENABLE_7 { PARAM_VALUE.DELAY_CTRL_ENABLE_7 } {
	# Procedure called to update DELAY_CTRL_ENABLE_7 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_CTRL_ENABLE_7 { PARAM_VALUE.DELAY_CTRL_ENABLE_7 } {
	# Procedure called to validate DELAY_CTRL_ENABLE_7
	return true
}

proc update_PARAM_VALUE.DELAY_GROUP_0 { PARAM_VALUE.DELAY_GROUP_0 } {
	# Procedure called to update DELAY_GROUP_0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP_0 { PARAM_VALUE.DELAY_GROUP_0 } {
	# Procedure called to validate DELAY_GROUP_0
	return true
}

proc update_PARAM_VALUE.DELAY_GROUP_1 { PARAM_VALUE.DELAY_GROUP_1 } {
	# Procedure called to update DELAY_GROUP_1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP_1 { PARAM_VALUE.DELAY_GROUP_1 } {
	# Procedure called to validate DELAY_GROUP_1
	return true
}

proc update_PARAM_VALUE.DELAY_GROUP_2 { PARAM_VALUE.DELAY_GROUP_2 } {
	# Procedure called to update DELAY_GROUP_2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP_2 { PARAM_VALUE.DELAY_GROUP_2 } {
	# Procedure called to validate DELAY_GROUP_2
	return true
}

proc update_PARAM_VALUE.DELAY_GROUP_3 { PARAM_VALUE.DELAY_GROUP_3 } {
	# Procedure called to update DELAY_GROUP_3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP_3 { PARAM_VALUE.DELAY_GROUP_3 } {
	# Procedure called to validate DELAY_GROUP_3
	return true
}

proc update_PARAM_VALUE.DELAY_GROUP_4 { PARAM_VALUE.DELAY_GROUP_4 } {
	# Procedure called to update DELAY_GROUP_4 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP_4 { PARAM_VALUE.DELAY_GROUP_4 } {
	# Procedure called to validate DELAY_GROUP_4
	return true
}

proc update_PARAM_VALUE.DELAY_GROUP_5 { PARAM_VALUE.DELAY_GROUP_5 } {
	# Procedure called to update DELAY_GROUP_5 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP_5 { PARAM_VALUE.DELAY_GROUP_5 } {
	# Procedure called to validate DELAY_GROUP_5
	return true
}

proc update_PARAM_VALUE.DELAY_GROUP_6 { PARAM_VALUE.DELAY_GROUP_6 } {
	# Procedure called to update DELAY_GROUP_6 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP_6 { PARAM_VALUE.DELAY_GROUP_6 } {
	# Procedure called to validate DELAY_GROUP_6
	return true
}

proc update_PARAM_VALUE.DELAY_GROUP_7 { PARAM_VALUE.DELAY_GROUP_7 } {
	# Procedure called to update DELAY_GROUP_7 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP_7 { PARAM_VALUE.DELAY_GROUP_7 } {
	# Procedure called to validate DELAY_GROUP_7
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

proc update_MODELPARAM_VALUE.DELAY_GROUP_0 { MODELPARAM_VALUE.DELAY_GROUP_0 PARAM_VALUE.DELAY_GROUP_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP_0}] ${MODELPARAM_VALUE.DELAY_GROUP_0}
}

proc update_MODELPARAM_VALUE.DELAY_CTRL_ENABLE_0 { MODELPARAM_VALUE.DELAY_CTRL_ENABLE_0 PARAM_VALUE.DELAY_CTRL_ENABLE_0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_CTRL_ENABLE_0}] ${MODELPARAM_VALUE.DELAY_CTRL_ENABLE_0}
}

proc update_MODELPARAM_VALUE.DELAY_GROUP_1 { MODELPARAM_VALUE.DELAY_GROUP_1 PARAM_VALUE.DELAY_GROUP_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP_1}] ${MODELPARAM_VALUE.DELAY_GROUP_1}
}

proc update_MODELPARAM_VALUE.DELAY_GROUP_2 { MODELPARAM_VALUE.DELAY_GROUP_2 PARAM_VALUE.DELAY_GROUP_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP_2}] ${MODELPARAM_VALUE.DELAY_GROUP_2}
}

proc update_MODELPARAM_VALUE.DELAY_GROUP_3 { MODELPARAM_VALUE.DELAY_GROUP_3 PARAM_VALUE.DELAY_GROUP_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP_3}] ${MODELPARAM_VALUE.DELAY_GROUP_3}
}

proc update_MODELPARAM_VALUE.DELAY_GROUP_4 { MODELPARAM_VALUE.DELAY_GROUP_4 PARAM_VALUE.DELAY_GROUP_4 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP_4}] ${MODELPARAM_VALUE.DELAY_GROUP_4}
}

proc update_MODELPARAM_VALUE.DELAY_GROUP_5 { MODELPARAM_VALUE.DELAY_GROUP_5 PARAM_VALUE.DELAY_GROUP_5 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP_5}] ${MODELPARAM_VALUE.DELAY_GROUP_5}
}

proc update_MODELPARAM_VALUE.DELAY_GROUP_6 { MODELPARAM_VALUE.DELAY_GROUP_6 PARAM_VALUE.DELAY_GROUP_6 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP_6}] ${MODELPARAM_VALUE.DELAY_GROUP_6}
}

proc update_MODELPARAM_VALUE.DELAY_GROUP_7 { MODELPARAM_VALUE.DELAY_GROUP_7 PARAM_VALUE.DELAY_GROUP_7 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP_7}] ${MODELPARAM_VALUE.DELAY_GROUP_7}
}

proc update_MODELPARAM_VALUE.DELAY_CTRL_ENABLE_1 { MODELPARAM_VALUE.DELAY_CTRL_ENABLE_1 PARAM_VALUE.DELAY_CTRL_ENABLE_1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_CTRL_ENABLE_1}] ${MODELPARAM_VALUE.DELAY_CTRL_ENABLE_1}
}

proc update_MODELPARAM_VALUE.DELAY_CTRL_ENABLE_2 { MODELPARAM_VALUE.DELAY_CTRL_ENABLE_2 PARAM_VALUE.DELAY_CTRL_ENABLE_2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_CTRL_ENABLE_2}] ${MODELPARAM_VALUE.DELAY_CTRL_ENABLE_2}
}

proc update_MODELPARAM_VALUE.DELAY_CTRL_ENABLE_3 { MODELPARAM_VALUE.DELAY_CTRL_ENABLE_3 PARAM_VALUE.DELAY_CTRL_ENABLE_3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_CTRL_ENABLE_3}] ${MODELPARAM_VALUE.DELAY_CTRL_ENABLE_3}
}

proc update_MODELPARAM_VALUE.DELAY_CTRL_ENABLE_4 { MODELPARAM_VALUE.DELAY_CTRL_ENABLE_4 PARAM_VALUE.DELAY_CTRL_ENABLE_4 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_CTRL_ENABLE_4}] ${MODELPARAM_VALUE.DELAY_CTRL_ENABLE_4}
}

proc update_MODELPARAM_VALUE.DELAY_CTRL_ENABLE_5 { MODELPARAM_VALUE.DELAY_CTRL_ENABLE_5 PARAM_VALUE.DELAY_CTRL_ENABLE_5 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_CTRL_ENABLE_5}] ${MODELPARAM_VALUE.DELAY_CTRL_ENABLE_5}
}

proc update_MODELPARAM_VALUE.DELAY_CTRL_ENABLE_6 { MODELPARAM_VALUE.DELAY_CTRL_ENABLE_6 PARAM_VALUE.DELAY_CTRL_ENABLE_6 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_CTRL_ENABLE_6}] ${MODELPARAM_VALUE.DELAY_CTRL_ENABLE_6}
}

proc update_MODELPARAM_VALUE.DELAY_CTRL_ENABLE_7 { MODELPARAM_VALUE.DELAY_CTRL_ENABLE_7 PARAM_VALUE.DELAY_CTRL_ENABLE_7 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_CTRL_ENABLE_7}] ${MODELPARAM_VALUE.DELAY_CTRL_ENABLE_7}
}

