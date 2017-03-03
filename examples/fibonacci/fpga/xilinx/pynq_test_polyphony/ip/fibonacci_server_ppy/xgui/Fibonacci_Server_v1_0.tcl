# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "I_BYTES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "O_BYTES" -parent ${Page_0}


}

proc update_PARAM_VALUE.I_BYTES { PARAM_VALUE.I_BYTES } {
	# Procedure called to update I_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.I_BYTES { PARAM_VALUE.I_BYTES } {
	# Procedure called to validate I_BYTES
	return true
}

proc update_PARAM_VALUE.O_BYTES { PARAM_VALUE.O_BYTES } {
	# Procedure called to update O_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.O_BYTES { PARAM_VALUE.O_BYTES } {
	# Procedure called to validate O_BYTES
	return true
}


proc update_MODELPARAM_VALUE.I_BYTES { MODELPARAM_VALUE.I_BYTES PARAM_VALUE.I_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.I_BYTES}] ${MODELPARAM_VALUE.I_BYTES}
}

proc update_MODELPARAM_VALUE.O_BYTES { MODELPARAM_VALUE.O_BYTES PARAM_VALUE.O_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.O_BYTES}] ${MODELPARAM_VALUE.O_BYTES}
}

