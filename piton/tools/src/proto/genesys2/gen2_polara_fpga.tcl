
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
set design_name gen2_polara_fpga

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
  set ddr3_axi [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ddr3_axi ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.FREQ_HZ {225022502} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {6} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $ddr3_axi

  set ddr3_sdram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3_sdram ]

  set mig_ddr3_sys_diff_clock [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 mig_ddr3_sys_diff_clock ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $mig_ddr3_sys_diff_clock


  # Create ports
  set mig_ddr3_init_calib_complete [ create_bd_port -dir O mig_ddr3_init_calib_complete ]
  set mig_ddr3_sys_rst_n [ create_bd_port -dir I -type rst mig_ddr3_sys_rst_n ]
  set mig_ddr3_ui_clk [ create_bd_port -dir O -type clk mig_ddr3_ui_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {ddr3_axi} \
   CONFIG.FREQ_HZ {225022502} \
 ] $mig_ddr3_ui_clk
  set mig_ddr3_ui_clk_sync_rst [ create_bd_port -dir O -type rst mig_ddr3_ui_clk_sync_rst ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $mig_ddr3_ui_clk_sync_rst

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]
  set_property -dict [ list \
   CONFIG.M_AXI_DATA_WIDTH {32} \
 ] $jtag_axi_0

  # Create instance: mig_7series_0, and set properties
  set mig_7series_0_gen2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0_gen2 ]
  set_property -dict [ list \
   CONFIG.BOARD_MIG_PARAM {ddr3_sdram} \
 ] $mig_7series_0_gen2

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $smartconnect_0

  # Create interface connections
  connect_bd_intf_net -intf_net S01_AXI_0_1 [get_bd_intf_ports ddr3_axi] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins jtag_axi_0/M_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net mig_7series_0_gen2_DDR3 [get_bd_intf_ports ddr3_sdram] [get_bd_intf_pins mig_7series_0_gen2/DDR3]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins mig_7series_0_gen2/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net sys_diff_clock_1 [get_bd_intf_ports mig_ddr3_sys_diff_clock] [get_bd_intf_pins mig_7series_0_gen2/SYS_CLK]

  # Create port connections
  connect_bd_net -net mig_7series_0_init_calib_complete [get_bd_ports mig_ddr3_init_calib_complete] [get_bd_pins mig_7series_0_gen2/init_calib_complete]
  connect_bd_net -net mig_7series_0_ui_clk [get_bd_ports mig_ddr3_ui_clk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins mig_7series_0_gen2/ui_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst [get_bd_ports mig_ddr3_ui_clk_sync_rst] [get_bd_pins mig_7series_0_gen2/ui_clk_sync_rst]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins mig_7series_0_gen2/aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net sys_rst_0_1 [get_bd_ports mig_ddr3_sys_rst_n] [get_bd_pins mig_7series_0_gen2/sys_rst] [get_bd_pins proc_sys_reset_0/ext_reset_in]

  # Create address segments
  assign_bd_address -offset 0x80000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs mig_7series_0_gen2/memmap/memaddr] -force
  assign_bd_address -offset 0x80000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces ddr3_axi] [get_bd_addr_segs mig_7series_0_gen2/memmap/memaddr] -force


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

close_project

file delete -force ${tmp_build_dir}/${tmp_prj}
