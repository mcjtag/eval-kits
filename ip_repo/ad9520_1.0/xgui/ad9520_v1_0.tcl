# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {AXI Settings}]
  set_property tooltip {AXI Settings} ${Page_0}
  set C_S_AXI_DATA_WIDTH [ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_S_AXI_DATA_WIDTH}
  set C_S_AXI_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_S_AXI_ADDR_WIDTH}
  ipgui::add_param $IPINST -name "C_S_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_HIGHADDR" -parent ${Page_0}

  #Adding Page
  set SPI_Settings [ipgui::add_page $IPINST -name "SPI Settings"]
  set_property tooltip {SPI Settings} ${SPI_Settings}
  ipgui::add_param $IPINST -name "DEVICE_COUNT" -parent ${SPI_Settings}
  set SPI_CLOCK_PRESCALER [ipgui::add_param $IPINST -name "SPI_CLOCK_PRESCALER" -parent ${SPI_Settings}]
  set_property tooltip {SPI Clock Prescaler} ${SPI_CLOCK_PRESCALER}

  #Adding Page
  set Signals [ipgui::add_page $IPINST -name "Signals"]
  set IS_AD_RESET_PRESENT [ipgui::add_param $IPINST -name "IS_AD_RESET_PRESENT" -parent ${Signals}]
  set_property tooltip {Reset Signal Presence} ${IS_AD_RESET_PRESENT}
  set IS_AD_PD_PRESENT [ipgui::add_param $IPINST -name "IS_AD_PD_PRESENT" -parent ${Signals}]
  set_property tooltip {PD Sigmal Presence} ${IS_AD_PD_PRESENT}
  set IS_AD_SYNC_PRESENT [ipgui::add_param $IPINST -name "IS_AD_SYNC_PRESENT" -parent ${Signals}]
  set_property tooltip {SYNC Signal Presence} ${IS_AD_SYNC_PRESENT}
  set IS_AD_EEPROM_PRESENT [ipgui::add_param $IPINST -name "IS_AD_EEPROM_PRESENT" -parent ${Signals}]
  set_property tooltip {EEPROM Signal Presence} ${IS_AD_EEPROM_PRESENT}
  set IS_AD_REFMON_PRESENT [ipgui::add_param $IPINST -name "IS_AD_REFMON_PRESENT" -parent ${Signals}]
  set_property tooltip {REFMON Signal Presence} ${IS_AD_REFMON_PRESENT}
  set IS_AD_LD_PRESENT [ipgui::add_param $IPINST -name "IS_AD_LD_PRESENT" -parent ${Signals}]
  set_property tooltip {LD Signal Presence} ${IS_AD_LD_PRESENT}
  set IS_AD_STATUS_PRESENT [ipgui::add_param $IPINST -name "IS_AD_STATUS_PRESENT" -parent ${Signals}]
  set_property tooltip {STATUS Signal Presence} ${IS_AD_STATUS_PRESENT}


}

proc update_PARAM_VALUE.DEVICE_COUNT { PARAM_VALUE.DEVICE_COUNT } {
	# Procedure called to update DEVICE_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEVICE_COUNT { PARAM_VALUE.DEVICE_COUNT } {
	# Procedure called to validate DEVICE_COUNT
	return true
}

proc update_PARAM_VALUE.IS_AD_EEPROM_PRESENT { PARAM_VALUE.IS_AD_EEPROM_PRESENT } {
	# Procedure called to update IS_AD_EEPROM_PRESENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IS_AD_EEPROM_PRESENT { PARAM_VALUE.IS_AD_EEPROM_PRESENT } {
	# Procedure called to validate IS_AD_EEPROM_PRESENT
	return true
}

proc update_PARAM_VALUE.IS_AD_LD_PRESENT { PARAM_VALUE.IS_AD_LD_PRESENT } {
	# Procedure called to update IS_AD_LD_PRESENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IS_AD_LD_PRESENT { PARAM_VALUE.IS_AD_LD_PRESENT } {
	# Procedure called to validate IS_AD_LD_PRESENT
	return true
}

proc update_PARAM_VALUE.IS_AD_PD_PRESENT { PARAM_VALUE.IS_AD_PD_PRESENT } {
	# Procedure called to update IS_AD_PD_PRESENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IS_AD_PD_PRESENT { PARAM_VALUE.IS_AD_PD_PRESENT } {
	# Procedure called to validate IS_AD_PD_PRESENT
	return true
}

proc update_PARAM_VALUE.IS_AD_REFMON_PRESENT { PARAM_VALUE.IS_AD_REFMON_PRESENT } {
	# Procedure called to update IS_AD_REFMON_PRESENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IS_AD_REFMON_PRESENT { PARAM_VALUE.IS_AD_REFMON_PRESENT } {
	# Procedure called to validate IS_AD_REFMON_PRESENT
	return true
}

proc update_PARAM_VALUE.IS_AD_RESET_PRESENT { PARAM_VALUE.IS_AD_RESET_PRESENT } {
	# Procedure called to update IS_AD_RESET_PRESENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IS_AD_RESET_PRESENT { PARAM_VALUE.IS_AD_RESET_PRESENT } {
	# Procedure called to validate IS_AD_RESET_PRESENT
	return true
}

proc update_PARAM_VALUE.IS_AD_STATUS_PRESENT { PARAM_VALUE.IS_AD_STATUS_PRESENT } {
	# Procedure called to update IS_AD_STATUS_PRESENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IS_AD_STATUS_PRESENT { PARAM_VALUE.IS_AD_STATUS_PRESENT } {
	# Procedure called to validate IS_AD_STATUS_PRESENT
	return true
}

proc update_PARAM_VALUE.IS_AD_SYNC_PRESENT { PARAM_VALUE.IS_AD_SYNC_PRESENT } {
	# Procedure called to update IS_AD_SYNC_PRESENT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IS_AD_SYNC_PRESENT { PARAM_VALUE.IS_AD_SYNC_PRESENT } {
	# Procedure called to validate IS_AD_SYNC_PRESENT
	return true
}

proc update_PARAM_VALUE.SPI_CLOCK_PRESCALER { PARAM_VALUE.SPI_CLOCK_PRESCALER } {
	# Procedure called to update SPI_CLOCK_PRESCALER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SPI_CLOCK_PRESCALER { PARAM_VALUE.SPI_CLOCK_PRESCALER } {
	# Procedure called to validate SPI_CLOCK_PRESCALER
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

proc update_MODELPARAM_VALUE.DEVICE_COUNT { MODELPARAM_VALUE.DEVICE_COUNT PARAM_VALUE.DEVICE_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEVICE_COUNT}] ${MODELPARAM_VALUE.DEVICE_COUNT}
}

proc update_MODELPARAM_VALUE.SPI_CLOCK_PRESCALER { MODELPARAM_VALUE.SPI_CLOCK_PRESCALER PARAM_VALUE.SPI_CLOCK_PRESCALER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SPI_CLOCK_PRESCALER}] ${MODELPARAM_VALUE.SPI_CLOCK_PRESCALER}
}

proc update_MODELPARAM_VALUE.IS_AD_RESET_PRESENT { MODELPARAM_VALUE.IS_AD_RESET_PRESENT PARAM_VALUE.IS_AD_RESET_PRESENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IS_AD_RESET_PRESENT}] ${MODELPARAM_VALUE.IS_AD_RESET_PRESENT}
}

proc update_MODELPARAM_VALUE.IS_AD_PD_PRESENT { MODELPARAM_VALUE.IS_AD_PD_PRESENT PARAM_VALUE.IS_AD_PD_PRESENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IS_AD_PD_PRESENT}] ${MODELPARAM_VALUE.IS_AD_PD_PRESENT}
}

proc update_MODELPARAM_VALUE.IS_AD_SYNC_PRESENT { MODELPARAM_VALUE.IS_AD_SYNC_PRESENT PARAM_VALUE.IS_AD_SYNC_PRESENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IS_AD_SYNC_PRESENT}] ${MODELPARAM_VALUE.IS_AD_SYNC_PRESENT}
}

proc update_MODELPARAM_VALUE.IS_AD_EEPROM_PRESENT { MODELPARAM_VALUE.IS_AD_EEPROM_PRESENT PARAM_VALUE.IS_AD_EEPROM_PRESENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IS_AD_EEPROM_PRESENT}] ${MODELPARAM_VALUE.IS_AD_EEPROM_PRESENT}
}

proc update_MODELPARAM_VALUE.IS_AD_REFMON_PRESENT { MODELPARAM_VALUE.IS_AD_REFMON_PRESENT PARAM_VALUE.IS_AD_REFMON_PRESENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IS_AD_REFMON_PRESENT}] ${MODELPARAM_VALUE.IS_AD_REFMON_PRESENT}
}

proc update_MODELPARAM_VALUE.IS_AD_LD_PRESENT { MODELPARAM_VALUE.IS_AD_LD_PRESENT PARAM_VALUE.IS_AD_LD_PRESENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IS_AD_LD_PRESENT}] ${MODELPARAM_VALUE.IS_AD_LD_PRESENT}
}

proc update_MODELPARAM_VALUE.IS_AD_STATUS_PRESENT { MODELPARAM_VALUE.IS_AD_STATUS_PRESENT PARAM_VALUE.IS_AD_STATUS_PRESENT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IS_AD_STATUS_PRESENT}] ${MODELPARAM_VALUE.IS_AD_STATUS_PRESENT}
}

