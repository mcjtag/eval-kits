# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {Settings}]
  set_property tooltip {Settings} ${Page_0}
  ipgui::add_param $IPINST -name "LOCAL_MAC" -parent ${Page_0}
  ipgui::add_param $IPINST -name "GATEWAY_IP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SUBNET_MASK" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SOURCE_IP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SOURCE_PORT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEST_IP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEST_PORT" -parent ${Page_0}


}

proc update_PARAM_VALUE.CONFIG_ENABLE { PARAM_VALUE.CONFIG_ENABLE } {
	# Procedure called to update CONFIG_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CONFIG_ENABLE { PARAM_VALUE.CONFIG_ENABLE } {
	# Procedure called to validate CONFIG_ENABLE
	return true
}

proc update_PARAM_VALUE.DEST_IP { PARAM_VALUE.DEST_IP } {
	# Procedure called to update DEST_IP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEST_IP { PARAM_VALUE.DEST_IP } {
	# Procedure called to validate DEST_IP
	return true
}

proc update_PARAM_VALUE.DEST_PORT { PARAM_VALUE.DEST_PORT } {
	# Procedure called to update DEST_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEST_PORT { PARAM_VALUE.DEST_PORT } {
	# Procedure called to validate DEST_PORT
	return true
}

proc update_PARAM_VALUE.GATEWAY_IP { PARAM_VALUE.GATEWAY_IP } {
	# Procedure called to update GATEWAY_IP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GATEWAY_IP { PARAM_VALUE.GATEWAY_IP } {
	# Procedure called to validate GATEWAY_IP
	return true
}

proc update_PARAM_VALUE.LOCAL_MAC { PARAM_VALUE.LOCAL_MAC } {
	# Procedure called to update LOCAL_MAC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOCAL_MAC { PARAM_VALUE.LOCAL_MAC } {
	# Procedure called to validate LOCAL_MAC
	return true
}

proc update_PARAM_VALUE.SOURCE_IP { PARAM_VALUE.SOURCE_IP } {
	# Procedure called to update SOURCE_IP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SOURCE_IP { PARAM_VALUE.SOURCE_IP } {
	# Procedure called to validate SOURCE_IP
	return true
}

proc update_PARAM_VALUE.SOURCE_PORT { PARAM_VALUE.SOURCE_PORT } {
	# Procedure called to update SOURCE_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SOURCE_PORT { PARAM_VALUE.SOURCE_PORT } {
	# Procedure called to validate SOURCE_PORT
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

proc update_MODELPARAM_VALUE.GATEWAY_IP { MODELPARAM_VALUE.GATEWAY_IP PARAM_VALUE.GATEWAY_IP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.GATEWAY_IP}] ${MODELPARAM_VALUE.GATEWAY_IP}
}

proc update_MODELPARAM_VALUE.SUBNET_MASK { MODELPARAM_VALUE.SUBNET_MASK PARAM_VALUE.SUBNET_MASK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SUBNET_MASK}] ${MODELPARAM_VALUE.SUBNET_MASK}
}

proc update_MODELPARAM_VALUE.CONFIG_ENABLE { MODELPARAM_VALUE.CONFIG_ENABLE PARAM_VALUE.CONFIG_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CONFIG_ENABLE}] ${MODELPARAM_VALUE.CONFIG_ENABLE}
}

proc update_MODELPARAM_VALUE.SOURCE_IP { MODELPARAM_VALUE.SOURCE_IP PARAM_VALUE.SOURCE_IP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SOURCE_IP}] ${MODELPARAM_VALUE.SOURCE_IP}
}

proc update_MODELPARAM_VALUE.DEST_IP { MODELPARAM_VALUE.DEST_IP PARAM_VALUE.DEST_IP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEST_IP}] ${MODELPARAM_VALUE.DEST_IP}
}

proc update_MODELPARAM_VALUE.SOURCE_PORT { MODELPARAM_VALUE.SOURCE_PORT PARAM_VALUE.SOURCE_PORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SOURCE_PORT}] ${MODELPARAM_VALUE.SOURCE_PORT}
}

proc update_MODELPARAM_VALUE.DEST_PORT { MODELPARAM_VALUE.DEST_PORT PARAM_VALUE.DEST_PORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEST_PORT}] ${MODELPARAM_VALUE.DEST_PORT}
}

