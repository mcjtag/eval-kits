#
# Vivado (TM) v2018.3 (64-bit)
#
# project_top.tcl: Tcl script for re-creating project 'project_top'
#
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir [file dirname [info script]]

# Change current directory to project folder
cd [file dirname [info script]]

# Save old sources
file mkdir project_top.srcs
file mkdir project_top.sdk
file delete -force project_top.srcs.backup
file rename project_top.srcs project_top.srcs.backup
file delete -force project_top.sdk.backup
file rename project_top.sdk project_top.sdk.backup

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

variable script_file
set script_file "project_top.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argc]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir" { incr i; set origin_dir [lindex $::argv $i] }
      "--help"       { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/"]"

# Create project
create_project project_top . -part xc7a200tffg1156-2 -force
# Restore old sources
file delete -force project_top.srcs
file rename project_top.srcs.backup project_top.srcs
file delete -force project_top.sdk
file rename project_top.sdk.backup project_top.sdk

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [get_projects project_top]
set_property "default_lib" "xil_defaultlib" $obj
set_property "dsa.accelerator_binary_content" "bitstream" $obj
set_property "dsa.accelerator_binary_format" "xclbin2" $obj
set_property "dsa.description" "Vivado generated DSA" $obj
set_property "dsa.dr_bd_base_address" "0" $obj
set_property "dsa.emu_dir" "emu" $obj
set_property "dsa.flash_interface_type" "bpix16" $obj
set_property "dsa.flash_offset_address" "0" $obj
set_property "dsa.flash_size" "1024" $obj
set_property "dsa.host_architecture" "x86_64" $obj
set_property "dsa.host_interface" "pcie" $obj
set_property "dsa.num_compute_units" "60" $obj
set_property "dsa.platform_state" "pre_synth" $obj
set_property "dsa.vendor" "xilinx" $obj
set_property "dsa.version" "0.0" $obj
set_property "enable_vhdl_2008" "1" $obj
set_property "ip_cache_permissions" "disable" $obj
set_property "mem.enable_memory_map_generation" "1" $obj
set_property "part" "xc7a200tffg1156-2" $obj
set_property "sim.central_dir" "D:/projects/eval-kits/ek-m-mvm03/fpga/project_demo/project_top.ip_user_files" $obj
set_property "sim.ip.auto_export_scripts" "1" $obj
set_property "simulator_language" "Mixed" $obj
set_property "xpm_libraries" "XPM_CDC XPM_FIFO XPM_MEMORY" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
set obj [get_filesets sources_1]
set_property "ip_repo_paths" "[file normalize "$origin_dir/../../../ip_repo"]" $obj

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/project_top.srcs/sources_1/bd/design_top/design_top.bd"]"\
 "[file normalize "$origin_dir/project_top.srcs/sources_1/bd/design_top/hdl/design_top_wrapper.v"]"\
 "[file normalize "$origin_dir/project_top.srcs/sources_1/bd/design_top/ip/design_top_mig_7series_0_3/mig_b.prj"]"\
 "[file normalize "$origin_dir/project_top.srcs/sources_1/bd/design_top/ip/design_top_mig_7series_0_3/mig_a.prj"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
set file "design_top/design_top.bd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "registered_with_manager" "1" $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property "synth_checkpoint_mode" "Hierarchical" $file_obj
}

set file "design_top_mig_7series_0_3/mig_b.prj"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "scoped_to_cells" "design_top_mig_7series_0_3" $file_obj

set file "design_top_mig_7series_0_3/mig_a.prj"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "scoped_to_cells" "design_top_mig_7series_0_3" $file_obj


# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "design_top_wrapper" $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project_top.srcs/constrs_1/new/top.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "new/top.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project_top.srcs/constrs_1/new/link.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "new/link.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project_top.srcs/constrs_1/new/gtp.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "new/gtp.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project_top.srcs/constrs_1/new/dsp.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "new/dsp.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project_top.srcs/constrs_1/new/usb.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "new/usb.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project_top.srcs/constrs_1/new/ethernet.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "new/ethernet.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project_top.srcs/constrs_1/new/misc.xdc"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "new/misc.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "XDC" $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/project_top.srcs/constrs_1/new/eth_mac_1.0.tcl"]"
set file_added [add_files -norecurse -fileset $obj $file]
set file "new/eth_mac_1.0.tcl"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property "file_type" "TCL" $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property "target_part" "xc7a200tffg1156-2" $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "top" "design_top_wrapper" $obj
set_property "top_lib" "xil_defaultlib" $obj
set_property "xelab.nosort" "1" $obj
set_property "xelab.unifast" "" $obj

# Create 'synth' run (if not found)
if {[string equal [get_runs -quiet synth] ""]} {
  create_run -name synth -part xc7a200tffg1156-2 -flow {Vivado Synthesis 2018} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth]
  set_property flow "Vivado Synthesis 2018" [get_runs synth]
}
set obj [get_runs synth]
set_property "part" "xc7a200tffg1156-2" $obj
set_property "report_strategy" "Vivado Synthesis Default Reports" $obj
set_property "strategy" "Vivado Synthesis Defaults" $obj
set_property "steps.synth_design.reports" "synth_synth_report_utilization_0 synth_synth_synthesis_report_0" $obj

# set the current synth run
current_run -synthesis [get_runs synth]

# Create 'impl' run (if not found)
if {[string equal [get_runs -quiet impl] ""]} {
  create_run -name impl -part xc7a200tffg1156-2 -flow {Vivado Implementation 2018} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl]
  set_property flow "Vivado Implementation 2018" [get_runs impl]
}
set obj [get_runs impl]
set_property "part" "xc7a200tffg1156-2" $obj
set_property "report_strategy" "Vivado Implementation Default Reports" $obj
set_property "strategy" "Vivado Implementation Defaults" $obj
set_property "steps.init_design.reports" "impl_init_report_timing_summary_0" $obj
set_property "steps.opt_design.reports" "impl_opt_report_drc_0 impl_opt_report_timing_summary_0" $obj
set_property "steps.power_opt_design.reports" "impl_power_opt_report_timing_summary_0" $obj
set_property "steps.place_design.reports" "impl_place_report_io_0 impl_place_report_utilization_0 impl_place_report_control_sets_0 impl_place_report_incremental_reuse_0 impl_place_report_incremental_reuse_1 impl_place_report_timing_summary_0" $obj
set_property "steps.post_place_power_opt_design.reports" "impl_post_place_power_opt_report_timing_summary_0" $obj
set_property "steps.phys_opt_design.reports" "impl_phys_opt_report_timing_summary_0" $obj
set_property "steps.route_design.reports" "impl_route_report_drc_0 impl_route_report_methodology_0 impl_route_report_power_0 impl_route_report_route_status_0 impl_route_report_timing_summary_0 impl_route_report_incremental_reuse_0 impl_route_report_clock_utilization_0 impl_route_report_bus_skew_0 impl_route_implementation_log_0" $obj
set_property "steps.post_route_phys_opt_design.reports" "impl_post_route_phys_opt_report_timing_summary_0 impl_post_route_phys_opt_report_bus_skew_0" $obj
set_property "steps.write_bitstream.reports" "impl_bitstream_report_webtalk_0 impl_bitstream_implementation_log_0" $obj
set_property "steps.write_bitstream.args.readback_file" "0" $obj
set_property "steps.write_bitstream.args.verbose" "0" $obj

# set the current impl run
current_run -implementation [get_runs impl]

puts "INFO: Project created:project_top"
