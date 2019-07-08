set_false_path -to [get_pins LINK_RX_GEN.link_rx_inst/link_rx_ctrl_inst/link_fifo_rx/genblk5_0.fifo_18_bl_1.fifo_18_bl_1/RST]
set_false_path -to [get_pins LINK_TX_GEN.link_tx_inst/link_tx_ctrl_inst/link_fifo_tx_div4/genblk5_0.fifo_18_bl_1.fifo_18_bl_1/RST]

set_false_path -to [get_pins LINK_RX_GEN.link_rx_inst/link_rx_cdc_if_data/DATA_P[*].RAM32X1D_DAT_P/SP/I]
set_false_path -to [get_pins LINK_RX_GEN.link_rx_inst/link_rx_cdc_if_data/DATA_N[*].RAM32X1D_DAT_N/SP/I]
set_false_path -to [get_pins LINK_RX_GEN.link_rx_inst/link_rx_cdc_if_bcmp/DATA_P[*].RAM32X1D_DAT_P/SP/I]

#set_clock_groups -asynchronous \
#-group [list [get_clocks -of_objects [get_ports lxclkinp]]] \
#-group [list [get_clocks -of_objects [get_ports lxclk_ref]]]