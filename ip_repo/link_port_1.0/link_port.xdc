#set_clock_groups -asynchronous \
#-group [list [get_clocks -of_objects [get_pins -hierarchical *link_port*/lxclkinp]]] \
#-group [list [get_clocks -of_objects [get_pins -hierarchical *link_port*/lxclk_ref]]]