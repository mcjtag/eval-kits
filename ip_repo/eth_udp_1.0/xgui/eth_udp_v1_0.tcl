# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Group
  set Default_Settings [ipgui::add_group $IPINST -name "Default Settings"]
  ipgui::add_param $IPINST -name "LOCAL_MAC" -parent ${Default_Settings}
  ipgui::add_param $IPINST -name "LOCAL_IP" -parent ${Default_Settings}
  ipgui::add_param $IPINST -name "GATEWAY_IP" -parent ${Default_Settings}
  ipgui::add_param $IPINST -name "SUBNET_MASK" -parent ${Default_Settings}


}

proc update_PARAM_VALUE.GATEWAY_IP { PARAM_VALUE.GATEWAY_IP } {
	# Procedure called to update GATEWAY_IP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GATEWAY_IP { PARAM_VALUE.GATEWAY_IP } {
	# Procedure called to validate GATEWAY_IP
	return true
}

proc update_PARAM_VALUE.LOCAL_IP { PARAM_VALUE.LOCAL_IP } {
	# Procedure called to update LOCAL_IP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOCAL_IP { PARAM_VALUE.LOCAL_IP } {
	# Procedure called to validate LOCAL_IP
	return true
}

proc update_PARAM_VALUE.LOCAL_MAC { PARAM_VALUE.LOCAL_MAC } {
	# Procedure called to update LOCAL_MAC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOCAL_MAC { PARAM_VALUE.LOCAL_MAC } {
	# Procedure called to validate LOCAL_MAC
	return true
}

proc update_PARAM_VALUE.SUBNET_MASK { PARAM_VALUE.SUBNET_MASK } {
	# Procedure called to update SUBNET_MASK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SUBNET_MASK { PARAM_VALUE.SUBNET_MASK } {
	# Procedure called to validate SUBNET_MASK
	return true
}


proc update_MODELPARAM_VALUE.LOCAL_MAC { MODELPARAM_VALUE.LOCAL_MAC PARAM_VALUE.LOCAL_MAC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LOCAL_MAC}] ${MODELPARAM_VALUE.LOCAL_MAC}
}

proc update_MODELPARAM_VALUE.LOCAL_IP { MODELPARAM_VALUE.LOCAL_IP PARAM_VALUE.LOCAL_IP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LOCAL_IP}] ${MODELPARAM_VALUE.LOCAL_IP}
}

proc update_MODELPARAM_VALUE.GATEWAY_IP { MODELPARAM_VALUE.GATEWAY_IP PARAM_VALUE.GATEWAY_IP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.GATEWAY_IP}] ${MODELPARAM_VALUE.GATEWAY_IP}
}

proc update_MODELPARAM_VALUE.SUBNET_MASK { MODELPARAM_VALUE.SUBNET_MASK PARAM_VALUE.SUBNET_MASK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SUBNET_MASK}] ${MODELPARAM_VALUE.SUBNET_MASK}
}

