
################################################################
# This is a generated script based on design: polara_fpga
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
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./tmp_proj/project_1.xpr> in the current working folder.

set DV_ROOT $::env(DV_ROOT)
set PITON_ROOT $::env(PITON_ROOT)1

set tmp_build_dir ${PITON_ROOT}/build/alveou280/bd_alveo
set tmp_prj "create_bd"

file delete -force ${tmp_build_dir}/${tmp_prj}

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project -force ${tmp_build_dir}/${tmp_prj} -part xcu280-fsvh2892-2L-e
   set_property BOARD_PART xilinx.com:au280:part0:1.2 [current_project]
}

# CHANGE DESIGN NAME HERE
variable design_name
set design_name polara_fpga

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

create_bd_design $design_name -dir $DV_ROOT/design/chipset/xilinx/alveou280
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
  set c0_ddr4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4 ]

  set c0_ddr4_s_axi [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 c0_ddr4_s_axi ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {64} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.FREQ_HZ {300000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {0} \
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
   ] $c0_ddr4_s_axi

  set c0_ddr4_s_axi_ctrl [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 c0_ddr4_s_axi_ctrl ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_PROT {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {0} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {1} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $c0_ddr4_s_axi_ctrl

  set c0_sysclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 c0_sysclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $c0_sysclk

  set pci_express_x16 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pci_express_x16 ]

  set pcie_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk ]


  # Create ports
  set c0_ddr4_ui_clk [ create_bd_port -dir O -type clk c0_ddr4_ui_clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {c0_ddr4_s_axi:c0_ddr4_s_axi_ctrl} \
 ] $c0_ddr4_ui_clk
  set c0_ddr4_ui_clk_sync_rst [ create_bd_port -dir O -type rst c0_ddr4_ui_clk_sync_rst ]
  set c0_init_calib_complete [ create_bd_port -dir O c0_init_calib_complete ]
  set chip_rstn [ create_bd_port -dir O -from 0 -to 0 chip_rstn ]
  set pcie_perstn [ create_bd_port -dir I -type rst pcie_perstn ]
  set resetn [ create_bd_port -dir I -type rst resetn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $resetn

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {2} \
 ] $axi_gpio_0

  # Create instance: chip_rstn, and set properties
  set chip_rstn [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 chip_rstn ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {1} \
   CONFIG.DIN_TO {1} \
   CONFIG.DIN_WIDTH {2} \
   CONFIG.DOUT_WIDTH {1} \
 ] $chip_rstn

  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]
  set_property -dict [ list \
   CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {100} \
   CONFIG.C0.CKE_WIDTH {1} \
   CONFIG.C0.CS_WIDTH {1} \
   CONFIG.C0.DDR4_AUTO_AP_COL_A3 {true} \
   CONFIG.C0.DDR4_AxiAddressWidth {34} \
   CONFIG.C0.DDR4_AxiDataWidth {512} \
   CONFIG.C0.DDR4_AxiNarrowBurst.VALUE_SRC {USER} \
   CONFIG.C0.DDR4_AxiIDWidth.VALUE_SRC {USER} \
   CONFIG.C0.DDR4_AxiIDWidth {7} \
   CONFIG.C0.DDR4_AxiNarrowBurst {true} \
   CONFIG.C0.DDR4_CLKFBOUT_MULT {15} \
   CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
   CONFIG.C0.DDR4_CasLatency {17} \
   CONFIG.C0.DDR4_CasWriteLatency {12} \
   CONFIG.C0.DDR4_DataMask {NONE} \
   CONFIG.C0.DDR4_DataWidth {72} \
   CONFIG.C0.DDR4_EN_PARITY {true} \
   CONFIG.C0.DDR4_Ecc {true} \
   CONFIG.C0.DDR4_InputClockPeriod {9996} \
   CONFIG.C0.DDR4_Mem_Add_Map {ROW_COLUMN_BANK_INTLV} \
   CONFIG.C0.DDR4_MemoryPart {MTA18ASF2G72PZ-2G3} \
   CONFIG.C0.DDR4_MemoryType {RDIMMs} \
   CONFIG.C0.DDR4_Specify_MandD {false} \
   CONFIG.C0.DDR4_TimePeriod {833} \
   CONFIG.C0.ODT_WIDTH {1} \
 ] $ddr4_0

  # Create instance: proc_sys_rst_pcie, and set properties
  set proc_sys_rst_pcie [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_rst_pcie ]

  # Create instance: qdma_0, and set properties
  set qdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:qdma:4.0 qdma_0 ]
  set_property -dict [ list \
   CONFIG.MAILBOX_ENABLE {true} \
   CONFIG.PF0_SRIOV_FIRST_VF_OFFSET {4} \
   CONFIG.PF1_SRIOV_FIRST_VF_OFFSET {7} \
   CONFIG.PF2_SRIOV_FIRST_VF_OFFSET {10} \
   CONFIG.PF3_SRIOV_FIRST_VF_OFFSET {13} \
   CONFIG.SRIOV_CAP_ENABLE {true} \
   CONFIG.SRIOV_FIRST_VF_OFFSET {4} \
   CONFIG.axi_data_width {256_bit} \
   CONFIG.barlite_mb_pf0 {1} \
   CONFIG.coreclk_freq {250} \
   CONFIG.dma_intf_sel_qdma {AXI_MM} \
   CONFIG.en_axi_st_qdma {false} \
   CONFIG.flr_enable {true} \
   CONFIG.mode_selection {Advanced} \
   CONFIG.pf0_ari_enabled {true} \
   CONFIG.pf0_bar0_prefetchable_qdma {true} \
   CONFIG.pf0_bar2_prefetchable_qdma {true} \
   CONFIG.pf0_device_id {902F} \
   CONFIG.pf1_bar0_prefetchable_qdma {true} \
   CONFIG.pf1_bar2_prefetchable_qdma {true} \
   CONFIG.pf1_msix_enabled_qdma {false} \
   CONFIG.pf2_bar0_prefetchable_qdma {true} \
   CONFIG.pf2_bar2_prefetchable_qdma {true} \
   CONFIG.pf2_device_id {922F} \
   CONFIG.pf2_msix_enabled_qdma {false} \
   CONFIG.pf3_bar0_prefetchable_qdma {true} \
   CONFIG.pf3_bar2_prefetchable_qdma {true} \
   CONFIG.pf3_device_id {932F} \
   CONFIG.pf3_msix_enabled_qdma {false} \
   CONFIG.pl_link_cap_max_link_speed {5.0_GT/s} \
   CONFIG.testname {mm} \
 ] $qdma_0

  # Create instance: rst_ea_CLK0, and set properties
  set rst_ea_CLK0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ea_CLK0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
 ] $smartconnect_0

  # Create instance: sys_rstn, and set properties
  set sys_rstn [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 sys_rstn ]
  set_property -dict [ list \
   CONFIG.DIN_WIDTH {2} \
 ] $sys_rstn

  # Create instance: util_ds_buf, and set properties
  set util_ds_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $util_ds_buf

  # Create instance: vdd_0, and set properties
  set vdd_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vdd_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_CTRL_0_1 [get_bd_intf_ports c0_ddr4_s_axi_ctrl] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI_CTRL]
  connect_bd_intf_net -intf_net S01_AXI_0_1 [get_bd_intf_ports c0_ddr4_s_axi] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net c0_sysclk_1 [get_bd_intf_ports c0_sysclk] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports c0_ddr4] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net pcie_refclk_1 [get_bd_intf_ports pcie_refclk] [get_bd_intf_pins util_ds_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net qdma_0_M_AXI [get_bd_intf_pins qdma_0/M_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net qdma_0_M_AXI_LITE [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins qdma_0/M_AXI_LITE]
  connect_bd_intf_net -intf_net qdma_0_pcie_mgt [get_bd_intf_ports pci_express_x16] [get_bd_intf_pins qdma_0/pcie_mgt]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins rst_ea_CLK0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins chip_rstn/Din] [get_bd_pins sys_rstn/Din]
  connect_bd_net -net chip_rstn_Dout [get_bd_ports chip_rstn] [get_bd_pins chip_rstn/Dout]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_ports c0_ddr4_ui_clk] [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins rst_ea_CLK0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst [get_bd_ports c0_ddr4_ui_clk_sync_rst] [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst]
  connect_bd_net -net ddr4_0_c0_init_calib_complete [get_bd_ports c0_init_calib_complete] [get_bd_pins ddr4_0/c0_init_calib_complete]
  connect_bd_net -net pcie_perstn_1 [get_bd_ports pcie_perstn] [get_bd_pins qdma_0/soft_reset_n] [get_bd_pins qdma_0/sys_rst_n]
  connect_bd_net -net qdma_0_axi_aclk [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins proc_sys_rst_pcie/slowest_sync_clk] [get_bd_pins qdma_0/axi_aclk] [get_bd_pins smartconnect_0/aclk1]
  connect_bd_net -net qdma_0_axi_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins proc_sys_rst_pcie/ext_reset_in] [get_bd_pins qdma_0/axi_aresetn]
  connect_bd_net -net qdma_0_phy_ready [get_bd_pins proc_sys_rst_pcie/dcm_locked] [get_bd_pins qdma_0/phy_ready]
  connect_bd_net -net resetn_1 [get_bd_ports resetn] [get_bd_pins rst_ea_CLK0/ext_reset_in]
  connect_bd_net -net rst_ea_CLK0_peripheral_reset [get_bd_pins ddr4_0/sys_rst] [get_bd_pins rst_ea_CLK0/peripheral_reset]
  connect_bd_net -net sys_rstn_Dout [get_bd_pins rst_ea_CLK0/aux_reset_in] [get_bd_pins sys_rstn/Dout]
  connect_bd_net -net util_ds_buf_IBUF_DS_ODIV2 [get_bd_pins qdma_0/sys_clk] [get_bd_pins util_ds_buf/IBUF_DS_ODIV2]
  connect_bd_net -net util_ds_buf_IBUF_OUT [get_bd_pins qdma_0/sys_clk_gt] [get_bd_pins util_ds_buf/IBUF_OUT]
  connect_bd_net -net vdd_0_dout [get_bd_pins qdma_0/qsts_out_rdy] [get_bd_pins qdma_0/tm_dsc_sts_rdy] [get_bd_pins vdd_0/dout]

  # Create address segments
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI_LITE] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces qdma_0/M_AXI] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces c0_ddr4_s_axi] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces c0_ddr4_s_axi_ctrl] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] -force



 # ###########################################################
  # Final changes. Use this block to customize the bd

  # Decrease the PCIe speed for better timing results

 # ###########################################################

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


