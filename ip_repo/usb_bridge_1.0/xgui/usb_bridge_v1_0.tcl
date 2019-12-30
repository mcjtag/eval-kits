
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/usb_bridge_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {Settings}]
  set_property tooltip {Settings} ${Page_0}
  ipgui::add_param $IPINST -name "HIGH_SPEED" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "SERIAL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PACKET_MODE" -parent ${Page_0} -widget comboBox
  #Adding Group
  set Channel [ipgui::add_group $IPINST -name "Channel" -parent ${Page_0} -layout horizontal]
  #Adding Group
  set Channel_In [ipgui::add_group $IPINST -name "Channel In" -parent ${Channel} -display_name {IN}]
  set_property tooltip {Channel IN} ${Channel_In}
  set CHANNEL_IN_ENABLE [ipgui::add_param $IPINST -name "CHANNEL_IN_ENABLE" -parent ${Channel_In}]
  set_property tooltip {Channel IN Enable} ${CHANNEL_IN_ENABLE}
  ipgui::add_param $IPINST -name "DATA_IN_WIDTH" -parent ${Channel_In} -widget comboBox
  ipgui::add_param $IPINST -name "DATA_IN_ENDIAN" -parent ${Channel_In} -widget comboBox
  set FIFO_IN_ENABLE [ipgui::add_param $IPINST -name "FIFO_IN_ENABLE" -parent ${Channel_In} -widget comboBox]
  set_property tooltip {FIFO In Enable} ${FIFO_IN_ENABLE}
  set FIFO_IN_DEPTH [ipgui::add_param $IPINST -name "FIFO_IN_DEPTH" -parent ${Channel_In}]
  set_property tooltip {FIFO In Depth} ${FIFO_IN_DEPTH}
  set FIFO_IN_PACKET [ipgui::add_param $IPINST -name "FIFO_IN_PACKET" -parent ${Channel_In} -widget comboBox]
  set_property tooltip {FIFO In Mode} ${FIFO_IN_PACKET}

  #Adding Group
  set Channel_OUT [ipgui::add_group $IPINST -name "Channel OUT" -parent ${Channel} -display_name {OUT}]
  set CHANNEL_OUT_ENABLE [ipgui::add_param $IPINST -name "CHANNEL_OUT_ENABLE" -parent ${Channel_OUT}]
  set_property tooltip {Channel OUT Enable} ${CHANNEL_OUT_ENABLE}
  ipgui::add_param $IPINST -name "DATA_OUT_WIDTH" -parent ${Channel_OUT} -widget comboBox
  ipgui::add_param $IPINST -name "DATA_OUT_ENDIAN" -parent ${Channel_OUT} -widget comboBox
  set FIFO_OUT_ENABLE [ipgui::add_param $IPINST -name "FIFO_OUT_ENABLE" -parent ${Channel_OUT} -widget comboBox]
  set_property tooltip {FIFO Out Enable} ${FIFO_OUT_ENABLE}
  set FIFO_OUT_DEPTH [ipgui::add_param $IPINST -name "FIFO_OUT_DEPTH" -parent ${Channel_OUT}]
  set_property tooltip {FIFO Out Depth} ${FIFO_OUT_DEPTH}
  set FIFO_OUT_PACKET [ipgui::add_param $IPINST -name "FIFO_OUT_PACKET" -parent ${Channel_OUT} -widget comboBox]
  set_property tooltip {FIFO Out Mode} ${FIFO_OUT_PACKET}




}

proc update_PARAM_VALUE.DATA_IN_ENDIAN { PARAM_VALUE.DATA_IN_ENDIAN PARAM_VALUE.CHANNEL_IN_ENABLE } {
	# Procedure called to update DATA_IN_ENDIAN when any of the dependent parameters in the arguments change
	
	set DATA_IN_ENDIAN ${PARAM_VALUE.DATA_IN_ENDIAN}
	set CHANNEL_IN_ENABLE ${PARAM_VALUE.CHANNEL_IN_ENABLE}
	set values(CHANNEL_IN_ENABLE) [get_property value $CHANNEL_IN_ENABLE]
	if { [gen_USERPARAMETER_DATA_IN_ENDIAN_ENABLEMENT $values(CHANNEL_IN_ENABLE)] } {
		set_property enabled true $DATA_IN_ENDIAN
	} else {
		set_property enabled false $DATA_IN_ENDIAN
	}
}

proc validate_PARAM_VALUE.DATA_IN_ENDIAN { PARAM_VALUE.DATA_IN_ENDIAN } {
	# Procedure called to validate DATA_IN_ENDIAN
	return true
}

proc update_PARAM_VALUE.DATA_IN_WIDTH { PARAM_VALUE.DATA_IN_WIDTH PARAM_VALUE.CHANNEL_IN_ENABLE } {
	# Procedure called to update DATA_IN_WIDTH when any of the dependent parameters in the arguments change
	
	set DATA_IN_WIDTH ${PARAM_VALUE.DATA_IN_WIDTH}
	set CHANNEL_IN_ENABLE ${PARAM_VALUE.CHANNEL_IN_ENABLE}
	set values(CHANNEL_IN_ENABLE) [get_property value $CHANNEL_IN_ENABLE]
	if { [gen_USERPARAMETER_DATA_IN_WIDTH_ENABLEMENT $values(CHANNEL_IN_ENABLE)] } {
		set_property enabled true $DATA_IN_WIDTH
	} else {
		set_property enabled false $DATA_IN_WIDTH
	}
}

proc validate_PARAM_VALUE.DATA_IN_WIDTH { PARAM_VALUE.DATA_IN_WIDTH } {
	# Procedure called to validate DATA_IN_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_OUT_ENDIAN { PARAM_VALUE.DATA_OUT_ENDIAN PARAM_VALUE.CHANNEL_OUT_ENABLE } {
	# Procedure called to update DATA_OUT_ENDIAN when any of the dependent parameters in the arguments change
	
	set DATA_OUT_ENDIAN ${PARAM_VALUE.DATA_OUT_ENDIAN}
	set CHANNEL_OUT_ENABLE ${PARAM_VALUE.CHANNEL_OUT_ENABLE}
	set values(CHANNEL_OUT_ENABLE) [get_property value $CHANNEL_OUT_ENABLE]
	if { [gen_USERPARAMETER_DATA_OUT_ENDIAN_ENABLEMENT $values(CHANNEL_OUT_ENABLE)] } {
		set_property enabled true $DATA_OUT_ENDIAN
	} else {
		set_property enabled false $DATA_OUT_ENDIAN
	}
}

proc validate_PARAM_VALUE.DATA_OUT_ENDIAN { PARAM_VALUE.DATA_OUT_ENDIAN } {
	# Procedure called to validate DATA_OUT_ENDIAN
	return true
}

proc update_PARAM_VALUE.DATA_OUT_WIDTH { PARAM_VALUE.DATA_OUT_WIDTH PARAM_VALUE.CHANNEL_OUT_ENABLE } {
	# Procedure called to update DATA_OUT_WIDTH when any of the dependent parameters in the arguments change
	
	set DATA_OUT_WIDTH ${PARAM_VALUE.DATA_OUT_WIDTH}
	set CHANNEL_OUT_ENABLE ${PARAM_VALUE.CHANNEL_OUT_ENABLE}
	set values(CHANNEL_OUT_ENABLE) [get_property value $CHANNEL_OUT_ENABLE]
	if { [gen_USERPARAMETER_DATA_OUT_WIDTH_ENABLEMENT $values(CHANNEL_OUT_ENABLE)] } {
		set_property enabled true $DATA_OUT_WIDTH
	} else {
		set_property enabled false $DATA_OUT_WIDTH
	}
}

proc validate_PARAM_VALUE.DATA_OUT_WIDTH { PARAM_VALUE.DATA_OUT_WIDTH } {
	# Procedure called to validate DATA_OUT_WIDTH
	return true
}

proc update_PARAM_VALUE.FIFO_IN_DEPTH { PARAM_VALUE.FIFO_IN_DEPTH PARAM_VALUE.CHANNEL_IN_ENABLE PARAM_VALUE.FIFO_IN_ENABLE } {
	# Procedure called to update FIFO_IN_DEPTH when any of the dependent parameters in the arguments change
	
	set FIFO_IN_DEPTH ${PARAM_VALUE.FIFO_IN_DEPTH}
	set CHANNEL_IN_ENABLE ${PARAM_VALUE.CHANNEL_IN_ENABLE}
	set FIFO_IN_ENABLE ${PARAM_VALUE.FIFO_IN_ENABLE}
	set values(CHANNEL_IN_ENABLE) [get_property value $CHANNEL_IN_ENABLE]
	set values(FIFO_IN_ENABLE) [get_property value $FIFO_IN_ENABLE]
	if { [gen_USERPARAMETER_FIFO_IN_DEPTH_ENABLEMENT $values(CHANNEL_IN_ENABLE) $values(FIFO_IN_ENABLE)] } {
		set_property enabled true $FIFO_IN_DEPTH
	} else {
		set_property enabled false $FIFO_IN_DEPTH
	}
}

proc validate_PARAM_VALUE.FIFO_IN_DEPTH { PARAM_VALUE.FIFO_IN_DEPTH } {
	# Procedure called to validate FIFO_IN_DEPTH
	return true
}

proc update_PARAM_VALUE.FIFO_IN_ENABLE { PARAM_VALUE.FIFO_IN_ENABLE PARAM_VALUE.CHANNEL_IN_ENABLE } {
	# Procedure called to update FIFO_IN_ENABLE when any of the dependent parameters in the arguments change
	
	set FIFO_IN_ENABLE ${PARAM_VALUE.FIFO_IN_ENABLE}
	set CHANNEL_IN_ENABLE ${PARAM_VALUE.CHANNEL_IN_ENABLE}
	set values(CHANNEL_IN_ENABLE) [get_property value $CHANNEL_IN_ENABLE]
	if { [gen_USERPARAMETER_FIFO_IN_ENABLE_ENABLEMENT $values(CHANNEL_IN_ENABLE)] } {
		set_property enabled true $FIFO_IN_ENABLE
	} else {
		set_property enabled false $FIFO_IN_ENABLE
	}
}

proc validate_PARAM_VALUE.FIFO_IN_ENABLE { PARAM_VALUE.FIFO_IN_ENABLE } {
	# Procedure called to validate FIFO_IN_ENABLE
	return true
}

proc update_PARAM_VALUE.FIFO_IN_PACKET { PARAM_VALUE.FIFO_IN_PACKET PARAM_VALUE.CHANNEL_IN_ENABLE PARAM_VALUE.PACKET_MODE PARAM_VALUE.FIFO_IN_ENABLE } {
	# Procedure called to update FIFO_IN_PACKET when any of the dependent parameters in the arguments change
	
	set FIFO_IN_PACKET ${PARAM_VALUE.FIFO_IN_PACKET}
	set CHANNEL_IN_ENABLE ${PARAM_VALUE.CHANNEL_IN_ENABLE}
	set PACKET_MODE ${PARAM_VALUE.PACKET_MODE}
	set FIFO_IN_ENABLE ${PARAM_VALUE.FIFO_IN_ENABLE}
	set values(CHANNEL_IN_ENABLE) [get_property value $CHANNEL_IN_ENABLE]
	set values(PACKET_MODE) [get_property value $PACKET_MODE]
	set values(FIFO_IN_ENABLE) [get_property value $FIFO_IN_ENABLE]
	if { [gen_USERPARAMETER_FIFO_IN_PACKET_ENABLEMENT $values(CHANNEL_IN_ENABLE) $values(PACKET_MODE) $values(FIFO_IN_ENABLE)] } {
		set_property enabled true $FIFO_IN_PACKET
	} else {
		set_property enabled false $FIFO_IN_PACKET
	}
}

proc validate_PARAM_VALUE.FIFO_IN_PACKET { PARAM_VALUE.FIFO_IN_PACKET } {
	# Procedure called to validate FIFO_IN_PACKET
	return true
}

proc update_PARAM_VALUE.FIFO_OUT_DEPTH { PARAM_VALUE.FIFO_OUT_DEPTH PARAM_VALUE.CHANNEL_OUT_ENABLE PARAM_VALUE.FIFO_OUT_ENABLE } {
	# Procedure called to update FIFO_OUT_DEPTH when any of the dependent parameters in the arguments change
	
	set FIFO_OUT_DEPTH ${PARAM_VALUE.FIFO_OUT_DEPTH}
	set CHANNEL_OUT_ENABLE ${PARAM_VALUE.CHANNEL_OUT_ENABLE}
	set FIFO_OUT_ENABLE ${PARAM_VALUE.FIFO_OUT_ENABLE}
	set values(CHANNEL_OUT_ENABLE) [get_property value $CHANNEL_OUT_ENABLE]
	set values(FIFO_OUT_ENABLE) [get_property value $FIFO_OUT_ENABLE]
	if { [gen_USERPARAMETER_FIFO_OUT_DEPTH_ENABLEMENT $values(CHANNEL_OUT_ENABLE) $values(FIFO_OUT_ENABLE)] } {
		set_property enabled true $FIFO_OUT_DEPTH
	} else {
		set_property enabled false $FIFO_OUT_DEPTH
	}
}

proc validate_PARAM_VALUE.FIFO_OUT_DEPTH { PARAM_VALUE.FIFO_OUT_DEPTH } {
	# Procedure called to validate FIFO_OUT_DEPTH
	return true
}

proc update_PARAM_VALUE.FIFO_OUT_ENABLE { PARAM_VALUE.FIFO_OUT_ENABLE PARAM_VALUE.CHANNEL_OUT_ENABLE } {
	# Procedure called to update FIFO_OUT_ENABLE when any of the dependent parameters in the arguments change
	
	set FIFO_OUT_ENABLE ${PARAM_VALUE.FIFO_OUT_ENABLE}
	set CHANNEL_OUT_ENABLE ${PARAM_VALUE.CHANNEL_OUT_ENABLE}
	set values(CHANNEL_OUT_ENABLE) [get_property value $CHANNEL_OUT_ENABLE]
	if { [gen_USERPARAMETER_FIFO_OUT_ENABLE_ENABLEMENT $values(CHANNEL_OUT_ENABLE)] } {
		set_property enabled true $FIFO_OUT_ENABLE
	} else {
		set_property enabled false $FIFO_OUT_ENABLE
	}
}

proc validate_PARAM_VALUE.FIFO_OUT_ENABLE { PARAM_VALUE.FIFO_OUT_ENABLE } {
	# Procedure called to validate FIFO_OUT_ENABLE
	return true
}

proc update_PARAM_VALUE.FIFO_OUT_PACKET { PARAM_VALUE.FIFO_OUT_PACKET PARAM_VALUE.CHANNEL_OUT_ENABLE PARAM_VALUE.PACKET_MODE PARAM_VALUE.FIFO_OUT_ENABLE } {
	# Procedure called to update FIFO_OUT_PACKET when any of the dependent parameters in the arguments change
	
	set FIFO_OUT_PACKET ${PARAM_VALUE.FIFO_OUT_PACKET}
	set CHANNEL_OUT_ENABLE ${PARAM_VALUE.CHANNEL_OUT_ENABLE}
	set PACKET_MODE ${PARAM_VALUE.PACKET_MODE}
	set FIFO_OUT_ENABLE ${PARAM_VALUE.FIFO_OUT_ENABLE}
	set values(CHANNEL_OUT_ENABLE) [get_property value $CHANNEL_OUT_ENABLE]
	set values(PACKET_MODE) [get_property value $PACKET_MODE]
	set values(FIFO_OUT_ENABLE) [get_property value $FIFO_OUT_ENABLE]
	if { [gen_USERPARAMETER_FIFO_OUT_PACKET_ENABLEMENT $values(CHANNEL_OUT_ENABLE) $values(PACKET_MODE) $values(FIFO_OUT_ENABLE)] } {
		set_property enabled true $FIFO_OUT_PACKET
	} else {
		set_property enabled false $FIFO_OUT_PACKET
	}
}

proc validate_PARAM_VALUE.FIFO_OUT_PACKET { PARAM_VALUE.FIFO_OUT_PACKET } {
	# Procedure called to validate FIFO_OUT_PACKET
	return true
}

proc update_PARAM_VALUE.CHANNEL_IN_ENABLE { PARAM_VALUE.CHANNEL_IN_ENABLE } {
	# Procedure called to update CHANNEL_IN_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHANNEL_IN_ENABLE { PARAM_VALUE.CHANNEL_IN_ENABLE } {
	# Procedure called to validate CHANNEL_IN_ENABLE
	return true
}

proc update_PARAM_VALUE.CHANNEL_OUT_ENABLE { PARAM_VALUE.CHANNEL_OUT_ENABLE } {
	# Procedure called to update CHANNEL_OUT_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHANNEL_OUT_ENABLE { PARAM_VALUE.CHANNEL_OUT_ENABLE } {
	# Procedure called to validate CHANNEL_OUT_ENABLE
	return true
}

proc update_PARAM_VALUE.HIGH_SPEED { PARAM_VALUE.HIGH_SPEED } {
	# Procedure called to update HIGH_SPEED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HIGH_SPEED { PARAM_VALUE.HIGH_SPEED } {
	# Procedure called to validate HIGH_SPEED
	return true
}

proc update_PARAM_VALUE.PACKET_MODE { PARAM_VALUE.PACKET_MODE } {
	# Procedure called to update PACKET_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PACKET_MODE { PARAM_VALUE.PACKET_MODE } {
	# Procedure called to validate PACKET_MODE
	return true
}

proc update_PARAM_VALUE.SERIAL { PARAM_VALUE.SERIAL } {
	# Procedure called to update SERIAL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SERIAL { PARAM_VALUE.SERIAL } {
	# Procedure called to validate SERIAL
	return true
}


proc update_MODELPARAM_VALUE.HIGH_SPEED { MODELPARAM_VALUE.HIGH_SPEED PARAM_VALUE.HIGH_SPEED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HIGH_SPEED}] ${MODELPARAM_VALUE.HIGH_SPEED}
}

proc update_MODELPARAM_VALUE.PACKET_MODE { MODELPARAM_VALUE.PACKET_MODE PARAM_VALUE.PACKET_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PACKET_MODE}] ${MODELPARAM_VALUE.PACKET_MODE}
}

proc update_MODELPARAM_VALUE.DATA_IN_WIDTH { MODELPARAM_VALUE.DATA_IN_WIDTH PARAM_VALUE.DATA_IN_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_IN_WIDTH}] ${MODELPARAM_VALUE.DATA_IN_WIDTH}
}

proc update_MODELPARAM_VALUE.DATA_OUT_WIDTH { MODELPARAM_VALUE.DATA_OUT_WIDTH PARAM_VALUE.DATA_OUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_OUT_WIDTH}] ${MODELPARAM_VALUE.DATA_OUT_WIDTH}
}

proc update_MODELPARAM_VALUE.DATA_IN_ENDIAN { MODELPARAM_VALUE.DATA_IN_ENDIAN PARAM_VALUE.DATA_IN_ENDIAN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_IN_ENDIAN}] ${MODELPARAM_VALUE.DATA_IN_ENDIAN}
}

proc update_MODELPARAM_VALUE.DATA_OUT_ENDIAN { MODELPARAM_VALUE.DATA_OUT_ENDIAN PARAM_VALUE.DATA_OUT_ENDIAN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_OUT_ENDIAN}] ${MODELPARAM_VALUE.DATA_OUT_ENDIAN}
}

proc update_MODELPARAM_VALUE.FIFO_IN_ENABLE { MODELPARAM_VALUE.FIFO_IN_ENABLE PARAM_VALUE.FIFO_IN_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_IN_ENABLE}] ${MODELPARAM_VALUE.FIFO_IN_ENABLE}
}

proc update_MODELPARAM_VALUE.FIFO_IN_PACKET { MODELPARAM_VALUE.FIFO_IN_PACKET PARAM_VALUE.FIFO_IN_PACKET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_IN_PACKET}] ${MODELPARAM_VALUE.FIFO_IN_PACKET}
}

proc update_MODELPARAM_VALUE.FIFO_IN_DEPTH { MODELPARAM_VALUE.FIFO_IN_DEPTH PARAM_VALUE.FIFO_IN_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_IN_DEPTH}] ${MODELPARAM_VALUE.FIFO_IN_DEPTH}
}

proc update_MODELPARAM_VALUE.FIFO_OUT_ENABLE { MODELPARAM_VALUE.FIFO_OUT_ENABLE PARAM_VALUE.FIFO_OUT_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_OUT_ENABLE}] ${MODELPARAM_VALUE.FIFO_OUT_ENABLE}
}

proc update_MODELPARAM_VALUE.FIFO_OUT_PACKET { MODELPARAM_VALUE.FIFO_OUT_PACKET PARAM_VALUE.FIFO_OUT_PACKET } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_OUT_PACKET}] ${MODELPARAM_VALUE.FIFO_OUT_PACKET}
}

proc update_MODELPARAM_VALUE.FIFO_OUT_DEPTH { MODELPARAM_VALUE.FIFO_OUT_DEPTH PARAM_VALUE.FIFO_OUT_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FIFO_OUT_DEPTH}] ${MODELPARAM_VALUE.FIFO_OUT_DEPTH}
}

proc update_MODELPARAM_VALUE.CHANNEL_IN_ENABLE { MODELPARAM_VALUE.CHANNEL_IN_ENABLE PARAM_VALUE.CHANNEL_IN_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHANNEL_IN_ENABLE}] ${MODELPARAM_VALUE.CHANNEL_IN_ENABLE}
}

proc update_MODELPARAM_VALUE.CHANNEL_OUT_ENABLE { MODELPARAM_VALUE.CHANNEL_OUT_ENABLE PARAM_VALUE.CHANNEL_OUT_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHANNEL_OUT_ENABLE}] ${MODELPARAM_VALUE.CHANNEL_OUT_ENABLE}
}

proc update_MODELPARAM_VALUE.SERIAL { MODELPARAM_VALUE.SERIAL PARAM_VALUE.SERIAL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SERIAL}] ${MODELPARAM_VALUE.SERIAL}
}

