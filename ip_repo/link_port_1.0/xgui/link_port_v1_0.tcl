
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/link_port_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {General}]
  set_property tooltip {General Options} ${Page_0}
  #Adding Group
  set General [ipgui::add_group $IPINST -name "General" -parent ${Page_0}]
  set_property tooltip {General Options} ${General}
  set LINK_RX_INST [ipgui::add_param $IPINST -name "LINK_RX_INST" -parent ${General}]
  set_property tooltip {Enable Link Receiver} ${LINK_RX_INST}
  set LINK_TX_INST [ipgui::add_param $IPINST -name "LINK_TX_INST" -parent ${General}]
  set_property tooltip {Enable Link Transmitter} ${LINK_TX_INST}

  #Adding Group
  set Delay [ipgui::add_group $IPINST -name "Delay" -parent ${Page_0} -display_name {RX Settings}]
  set_property tooltip {Receiver Settings} ${Delay}
  set BCMP_RX_USE [ipgui::add_param $IPINST -name "BCMP_RX_USE" -parent ${Delay}]
  set_property tooltip {Enable BCMPI Signal} ${BCMP_RX_USE}
  ipgui::add_param $IPINST -name "DELAY_CTRL_INST" -parent ${Delay}
  ipgui::add_param $IPINST -name "DELAY_GROUP" -parent ${Delay}

  #Adding Group
  set TX_Settings [ipgui::add_group $IPINST -name "TX Settings" -parent ${Page_0}]
  set_property tooltip {Transmitter Settings} ${TX_Settings}
  set BCMP_TX_USE [ipgui::add_param $IPINST -name "BCMP_TX_USE" -parent ${TX_Settings}]
  set_property tooltip {Enable BCMPO Signal} ${BCMP_TX_USE}



}

proc update_PARAM_VALUE.BCMP_RX_USE { PARAM_VALUE.BCMP_RX_USE PARAM_VALUE.LINK_RX_INST } {
	# Procedure called to update BCMP_RX_USE when any of the dependent parameters in the arguments change
	
	set BCMP_RX_USE ${PARAM_VALUE.BCMP_RX_USE}
	set LINK_RX_INST ${PARAM_VALUE.LINK_RX_INST}
	set values(LINK_RX_INST) [get_property value $LINK_RX_INST]
	if { [gen_USERPARAMETER_BCMP_RX_USE_ENABLEMENT $values(LINK_RX_INST)] } {
		set_property enabled true $BCMP_RX_USE
	} else {
		set_property enabled false $BCMP_RX_USE
	}
}

proc validate_PARAM_VALUE.BCMP_RX_USE { PARAM_VALUE.BCMP_RX_USE } {
	# Procedure called to validate BCMP_RX_USE
	return true
}

proc update_PARAM_VALUE.BCMP_TX_USE { PARAM_VALUE.BCMP_TX_USE PARAM_VALUE.LINK_TX_INST } {
	# Procedure called to update BCMP_TX_USE when any of the dependent parameters in the arguments change
	
	set BCMP_TX_USE ${PARAM_VALUE.BCMP_TX_USE}
	set LINK_TX_INST ${PARAM_VALUE.LINK_TX_INST}
	set values(LINK_TX_INST) [get_property value $LINK_TX_INST]
	if { [gen_USERPARAMETER_BCMP_TX_USE_ENABLEMENT $values(LINK_TX_INST)] } {
		set_property enabled true $BCMP_TX_USE
	} else {
		set_property enabled false $BCMP_TX_USE
	}
}

proc validate_PARAM_VALUE.BCMP_TX_USE { PARAM_VALUE.BCMP_TX_USE } {
	# Procedure called to validate BCMP_TX_USE
	return true
}

proc update_PARAM_VALUE.DELAY_CTRL_INST { PARAM_VALUE.DELAY_CTRL_INST PARAM_VALUE.LINK_RX_INST } {
	# Procedure called to update DELAY_CTRL_INST when any of the dependent parameters in the arguments change
	
	set DELAY_CTRL_INST ${PARAM_VALUE.DELAY_CTRL_INST}
	set LINK_RX_INST ${PARAM_VALUE.LINK_RX_INST}
	set values(LINK_RX_INST) [get_property value $LINK_RX_INST]
	if { [gen_USERPARAMETER_DELAY_CTRL_INST_ENABLEMENT $values(LINK_RX_INST)] } {
		set_property enabled true $DELAY_CTRL_INST
	} else {
		set_property enabled false $DELAY_CTRL_INST
	}
}

proc validate_PARAM_VALUE.DELAY_CTRL_INST { PARAM_VALUE.DELAY_CTRL_INST } {
	# Procedure called to validate DELAY_CTRL_INST
	return true
}

proc update_PARAM_VALUE.DELAY_GROUP { PARAM_VALUE.DELAY_GROUP } {
	# Procedure called to update DELAY_GROUP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_GROUP { PARAM_VALUE.DELAY_GROUP } {
	# Procedure called to validate DELAY_GROUP
	return true
}

proc update_PARAM_VALUE.LINK_RX_INST { PARAM_VALUE.LINK_RX_INST } {
	# Procedure called to update LINK_RX_INST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LINK_RX_INST { PARAM_VALUE.LINK_RX_INST } {
	# Procedure called to validate LINK_RX_INST
	return true
}

proc update_PARAM_VALUE.LINK_TX_INST { PARAM_VALUE.LINK_TX_INST } {
	# Procedure called to update LINK_TX_INST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LINK_TX_INST { PARAM_VALUE.LINK_TX_INST } {
	# Procedure called to validate LINK_TX_INST
	return true
}


proc update_MODELPARAM_VALUE.DELAY_GROUP { MODELPARAM_VALUE.DELAY_GROUP PARAM_VALUE.DELAY_GROUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_GROUP}] ${MODELPARAM_VALUE.DELAY_GROUP}
}

proc update_MODELPARAM_VALUE.DELAY_CTRL_INST { MODELPARAM_VALUE.DELAY_CTRL_INST PARAM_VALUE.DELAY_CTRL_INST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_CTRL_INST}] ${MODELPARAM_VALUE.DELAY_CTRL_INST}
}

proc update_MODELPARAM_VALUE.LINK_RX_INST { MODELPARAM_VALUE.LINK_RX_INST PARAM_VALUE.LINK_RX_INST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LINK_RX_INST}] ${MODELPARAM_VALUE.LINK_RX_INST}
}

proc update_MODELPARAM_VALUE.LINK_TX_INST { MODELPARAM_VALUE.LINK_TX_INST PARAM_VALUE.LINK_TX_INST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LINK_TX_INST}] ${MODELPARAM_VALUE.LINK_TX_INST}
}

proc update_MODELPARAM_VALUE.BCMP_RX_USE { MODELPARAM_VALUE.BCMP_RX_USE PARAM_VALUE.BCMP_RX_USE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BCMP_RX_USE}] ${MODELPARAM_VALUE.BCMP_RX_USE}
}

proc update_MODELPARAM_VALUE.BCMP_TX_USE { MODELPARAM_VALUE.BCMP_TX_USE PARAM_VALUE.BCMP_TX_USE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BCMP_TX_USE}] ${MODELPARAM_VALUE.BCMP_TX_USE}
}

