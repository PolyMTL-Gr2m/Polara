# ####################################################################
#
# test_jtag_axi.tcl
#
# Author : Raphael Rowley (2024/06)
#
# Description :
# Script to automate testing of JTAG-AXI Xilinx IP on Genesys Chipset
#
# ####################################################################

# Inspired by: https://www.xilinx.com/video/software/jtag-to-axi-master-core.html

# Assumptions:
# core is named hw_axi_1
# DDR3 base address 0x0000_0000

# 1. Reset the core
reset_hw_axi [get_hw_axis hw_axi_1]

# 2. Create a write transaction (16 word AXI burst write)
create_hw_axi_txn -force write0 [get_hw_axis hw_axi_1] -address 00000000 -data {FFFFFFFF_EEEEEEEE_DDDDDDDD_CCCCCCCC_BBBBBBBB_AAAAAAAA_99999999_88888888_77777777_66666666_55555555_44444444_33333333_22222222_11111111_00000000} -len 16 -type write

# 3. Run the write transaction
run_hw_axi [get_hw_axi_txns write0]

# 4. Create a read transaction (16 word AXI burst read)
create_hw_axi_txn -force read0 [get_hw_axis hw_axi_1] -address 00000000 -len 16 -type read

# 5. Run the read transaction
run_hw_axi [get_hw_axi_txns read0]
