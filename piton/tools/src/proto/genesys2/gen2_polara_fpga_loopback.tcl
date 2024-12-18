
################################################################
# This is a generated script based on design: gen2_polara_fpga
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source gen2_polara_fpga_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set DV_ROOT $::env(DV_ROOT)
set PITON_ROOT $::env(PITON_ROOT)

set tmp_build_dir ${PITON_ROOT}/build/genesys2/bd_gen2
set tmp_prj "create_bd"

file delete -force ${tmp_build_dir}/${tmp_prj}

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
    create_project -force ${tmp_build_dir}/${tmp_prj} -part xc7k325tffg900-2    
    #   create_project project_1 myproj -part xc7k325tffg900-2
   set_property BOARD_PART digilentinc.com:genesys2:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name gen2_polara_fpga_loopback

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

create_bd_design $design_name -dir $DV_ROOT/design/chipset/xilinx/genesys2
current_bd_design $design_name

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set polara_gen2chipset_bus_i [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 polara_gen2chipset_bus_i ]

  set polara_gen2chipset_bus_o [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 polara_gen2chipset_bus_o ]


  # Create ports
  set bd_clk [ create_bd_port -dir I -type clk -freq_hz 40000000 bd_clk ]
  set mig_ddr3_sys_rst_n [ create_bd_port -dir I -type rst mig_ddr3_sys_rst_n ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO2_WIDTH {2} \
   CONFIG.C_GPIO_WIDTH {12} \
   CONFIG.C_IS_DUAL {1} \
   CONFIG.C_TRI_DEFAULT {0x00000300} \
 ] $axi_gpio_0

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]
  set_property -dict [ list \
   CONFIG.M_AXI_DATA_WIDTH {32} \
 ] $jtag_axi_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports polara_gen2chipset_bus_o] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO2 [get_bd_intf_ports polara_gen2chipset_bus_i] [get_bd_intf_pins axi_gpio_0/GPIO2]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins jtag_axi_0/M_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]

  # Create port connections
  connect_bd_net -net aclk_0_1 [get_bd_ports bd_clk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net sys_rst_0_1 [get_bd_ports mig_ddr3_sys_rst_n] [get_bd_pins proc_sys_reset_0/ext_reset_in]

  # Create address segments
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


