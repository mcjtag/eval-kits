# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "IFG_DELAY"
  ipgui::add_param $IPINST -name "USE_DELAY_CTRL" -widget comboBox
  ipgui::add_param $IPINST -name "DELAY_GROUP"

}

proc update_PARAM_VALUE.DELAY_GROUP { PARAM_VALUE.DELAY_GROUP } {
	# Procedure called to update DELAY_GROUP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP { PARAM_VALUE.DELAY_GROUP } {
	# Procedure called to validate DELAY_GROUP
	return true
}

proc update_PARAM_VALUE.IFG_DELAY { PARAM_VALUE.IFG_DELAY } {
	# Procedure called to update IFG_DELAY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IFG_DELAY { PARAM_VALUE.IFG_DELAY } {
	# Procedure called to validate IFG_DELAY
	return true
}

proc update_PARAM_VALUE.USE_DELAY_CTRL { PARAM_VALUE.USE_DELAY_CTRL } {
	# Procedure called to update USE_DELAY_CTRL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USE_DELAY_CTRL { PARAM_VALUE.USE_DELAY_CTRL } {
	# Procedure called to validate USE_DELAY_CTRL
	return true
}


proc update_MODELPARAM_VALUE.IFG_DELAY { MODELPARAM_VALUE.IFG_DELAY PARAM_VALUE.IFG_DELAY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IFG_DELAY}] ${MODELPARAM_VALUE.IFG_DELAY}
}

proc update_MODELPARAM_VALUE.USE_DELAY_CTRL { MODELPARAM_VALUE.USE_DELAY_CTRL PARAM_VALUE.USE_DELAY_CTRL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USE_DELAY_CTRL}] ${MODELPARAM_VALUE.USE_DELAY_CTRL}
}

proc update_MODELPARAM_VALUE.DELAY_GROUP { MODELPARAM_VALUE.DELAY_GROUP PARAM_VALUE.DELAY_GROUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP}] ${MODELPARAM_VALUE.DELAY_GROUP}
}

