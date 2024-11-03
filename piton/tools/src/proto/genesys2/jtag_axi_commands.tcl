# ####################################################################
#
# test_jtag_axi.tcl
#
# Author : Raphael Rowley (2024/07)
#
# Description :
# Useful commands for JTAG-AXI Xilinx IP on Genesys Chipset
#
# ####################################################################

# Inspired by: https://www.xilinx.com/video/software/jtag-to-axi-master-core.html
# AXI GPIO documentation: https://docs.amd.com/v/u/en-US/pg144-axi-gpio

# Assumptions:
# core is named hw_axi_1
# DDR3 base address 0x0000_0000
# GPIO base address 0x4000_0000

# Channel 1 GPIO mapping (outputs)
# Channel 1 AXI GPIO Data Register Address Space Offset: 0x0000
# 0 (LSB): chip_rst_n
# 1: chip_async_mux
# 2: chip_clk_en
# 3: chip_clk_mux_sel
# 4: fll_rst_n
# 5: fll_bypass
# 6: fll_opmode
# 7: fll_cfg_req
# 11-8: fll_range[3:0]

# Channel 2 GPIO mapping (inputs)
# Channel 2 AXI GPIO Data Register Address Space Offset: 0x0008
# 0: fll_lock
# 1: fll_clkdiv
# set_msg_config -id "Labtoolstcl 44-481" -limit 5500

# ####################################################################
# Init
# ####################################################################
# 1. Reset the core
reset_hw_axi [get_hw_axis hw_axi_1]

# ####################################################################
# Loopback flow. We are not using FLL
# ####################################################################
# 1. Reset the core
reset_hw_axi [get_hw_axis hw_axi_1]
# 2. rst_n on
create_hw_axi_txn -force rston [get_hw_axis hw_axi_1] -address 40000000 -data {00000000} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns rston]
# 3. chip_async_mux = 1, chip_clk_en = 1, chip_clk_mux_sel = 1, rst on
create_hw_axi_txn -force cfgrst [get_hw_axis hw_axi_1] -address 40000000 -data {0000000E} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns cfgrst]
# 4. cfg take off rst
create_hw_axi_txn -force cfgrstoff [get_hw_axis hw_axi_1] -address 40000000 -data {0000000F} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns cfgrstoff]

# ####################################################################
# Loopback flow. We are not using FLL. All synchronous
# ####################################################################
# 1. Reset the core
reset_hw_axi [get_hw_axis hw_axi_1]
# 2. rst_n on
create_hw_axi_txn -force rston [get_hw_axis hw_axi_1] -address 40000000 -data {00000000} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns rston]
# 3. chip_async_mux = 0, chip_clk_en = 1, chip_clk_mux_sel = 1, rst on
create_hw_axi_txn -force cfgrst [get_hw_axis hw_axi_1] -address 40000000 -data {0000000C} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns cfgrst]
# 4. cfg take off rst
create_hw_axi_txn -force cfgrstoff [get_hw_axis hw_axi_1] -address 40000000 -data {0000000D} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns cfgrstoff]

# ####################################################################
# Loopback flow. FLL
# ####################################################################
# 1. Reset the core
reset_hw_axi [get_hw_axis hw_axi_1]
# 2. rst_n on
create_hw_axi_txn -force rston [get_hw_axis hw_axi_1] -address 40000000 -data {00000000} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns rston]
# ------------------------------------------
# f_fll = 2^2 * f_ref
# ------------------------------------------
# 3. Set opmode = 1, fll_rst_n = 1, fll_range = 0010
create_hw_axi_txn -force op2rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000250} -len 1 -type write
run_hw_axi [get_hw_axi_txns op2rstoff]
# 4. Set cfgreq = 1
create_hw_axi_txn -force op2cfg [get_hw_axis hw_axi_1] -address 40000000 -data {000002D0} -len 1 -type write
run_hw_axi [get_hw_axi_txns op2cfg]
# 5. Set cfgreq = 0
run_hw_axi [get_hw_axi_txns op2rstoff]
# FLL previously configured with range = 2
# 7. Keep the config but activate: async_mux = 1, clk_en = 1
create_hw_axi_txn -force en2rston [get_hw_axis hw_axi_1] -address 40000000 -data {00000256} -len 1 -type write
run_hw_axi [get_hw_axi_txns en2rston]
# 8. Release the reset
create_hw_axi_txn -force en2rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000257} -len 1 -type write
run_hw_axi [get_hw_axi_txns en2rstoff]


# ####################################################################
# Genesys 2 Memory Test
# ####################################################################
# 2. Create a write transaction (16 word AXI burst write)
create_hw_axi_txn -force write0 [get_hw_axis hw_axi_1] -address 00000000 -data {FFFFFFFF_EEEEEEEE_DDDDDDDD_CCCCCCCC_BBBBBBBB_AAAAAAAA_99999999_88888888_77777777_66666666_55555555_44444444_33333333_22222222_11111111_00000000} -len 16 -type write

# 3. Run the write transaction
run_hw_axi [get_hw_axi_txns write0]

# 4. Create a read transaction (16 word AXI burst read)
create_hw_axi_txn -force read0 [get_hw_axis hw_axi_1] -address 00000000 -len 16 -type read

# 5. Run the read transaction
run_hw_axi [get_hw_axi_txns read0]

# ####################################################################
# VC707 chip emulation useful commands
# ####################################################################
# 6. Assert chip reset_n
create_hw_axi_txn -force rston [get_hw_axis hw_axi_1] -address 40000000 -data {00000000} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns rston]

# 7. Deassert chip reset_n
create_hw_axi_txn -force rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000001} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns rstoff]

# ####################################################################
# Polara ASIC useful commands
# ####################################################################

# ------------------------------------------
# FLL Tests (chip stays in reset)
# ------------------------------------------
# Test bypass
# ------------------------------------------
create_hw_axi_txn -force fllrstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000010} -len 1 -type write
run_hw_axi [get_hw_axi_txns fllrstoff]
# 1. Set bypass = 1, opmode = 1, fll_rst_n = 1
create_hw_axi_txn -force bypassrstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000070} -len 1 -type write
run_hw_axi [get_hw_axi_txns bypassrstoff]
# 2. Set cfgreq = 1
create_hw_axi_txn -force bypasscfg [get_hw_axis hw_axi_1] -address 40000000 -data {000000F0} -len 1 -type write
run_hw_axi [get_hw_axi_txns bypasscfg]
# 3. Set cfgreq = 0
run_hw_axi [get_hw_axi_txns bypassrstoff]
# 4. Reset everything
create_hw_axi_txn -force rston [get_hw_axis hw_axi_1] -address 40000000 -data {00000000} -len 1 -type write
run_hw_axi [get_hw_axi_txns rston]
# ------------------------------------------
# Test FLL, f_fll = 2^0 * f_ref
# ------------------------------------------
# 1. Set opmode = 1, fll_rst_n = 1, fll_range = 0000
create_hw_axi_txn -force oprstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000050} -len 1 -type write
run_hw_axi [get_hw_axi_txns oprstoff]
# 2. Set cfgreq = 1
create_hw_axi_txn -force opcfg [get_hw_axis hw_axi_1] -address 40000000 -data {000000D0} -len 1 -type write
run_hw_axi [get_hw_axi_txns opcfg]
# 3. Set cfgreq = 0
run_hw_axi [get_hw_axi_txns oprstoff]
# 4. Reset everything
run_hw_axi [get_hw_axi_txns rston]
# ------------------------------------------
# Test FLL, f_fll = 2^1 * f_ref
# ------------------------------------------
# 1. Set opmode = 1, fll_rst_n = 1, fll_range = 0001
create_hw_axi_txn -force op1rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000150} -len 1 -type write
run_hw_axi [get_hw_axi_txns op1rstoff]
# 2. Set cfgreq = 1
create_hw_axi_txn -force op1cfg [get_hw_axis hw_axi_1] -address 40000000 -data {000001D0} -len 1 -type write
run_hw_axi [get_hw_axi_txns op1cfg]
# 3. Set cfgreq = 0
run_hw_axi [get_hw_axi_txns op1rstoff]
# 4. Reset everything
run_hw_axi [get_hw_axi_txns rston]
# ------------------------------------------
# Test FLL, f_fll = 2^2 * f_ref
# ------------------------------------------
# 1. Set opmode = 1, fll_rst_n = 1, fll_range = 0010
create_hw_axi_txn -force op2rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000250} -len 1 -type write
run_hw_axi [get_hw_axi_txns op2rstoff]
# 2. Set cfgreq = 1
create_hw_axi_txn -force op2cfg [get_hw_axis hw_axi_1] -address 40000000 -data {000002D0} -len 1 -type write
run_hw_axi [get_hw_axi_txns op2cfg]
# 3. Set cfgreq = 0
run_hw_axi [get_hw_axi_txns op2rstoff]
# 4. Reset everything
run_hw_axi [get_hw_axi_txns rston]
# ------------------------------------------
# Test FLL, f_fll = 2^4 * f_ref
# ------------------------------------------
# 1. Set opmode = 1, fll_rst_n = 1, fll_range = 0100
create_hw_axi_txn -force op4rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000350} -len 1 -type write
run_hw_axi [get_hw_axi_txns op4rstoff]
# 2. Set cfgreq = 1
create_hw_axi_txn -force op4cfg [get_hw_axis hw_axi_1] -address 40000000 -data {000003D0} -len 1 -type write
run_hw_axi [get_hw_axi_txns op4cfg]
# 3. Set cfgreq = 0
run_hw_axi [get_hw_axi_txns op4rstoff]
# 4. Reset everything
run_hw_axi [get_hw_axi_txns rston]
# ------------------------------------------
# Test FLL, f_fll = 2^8 * f_ref
# ------------------------------------------
# 1. Set opmode = 1, fll_rst_n = 1, fll_range = 1000
create_hw_axi_txn -force op8rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000850} -len 1 -type write
run_hw_axi [get_hw_axi_txns op8rstoff]
# 2. Set cfgreq = 1
create_hw_axi_txn -force op8cfg [get_hw_axis hw_axi_1] -address 40000000 -data {000008D0} -len 1 -type write
run_hw_axi [get_hw_axi_txns op8cfg]
# 3. Set cfgreq = 0
run_hw_axi [get_hw_axi_txns op8rstoff]
# 4. Reset everything
run_hw_axi [get_hw_axi_txns rston]

# ------------------------------------------
# Hello world, no FLL (brouillon)
# ------------------------------------------
# 1. rst_n off
create_hw_axi_txn -force rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000001} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns rstoff]
# 2. rst_n on
create_hw_axi_txn -force rston [get_hw_axis hw_axi_1] -address 40000000 -data {00000000} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns rston]
# 3. chip_async_mux = 1, chip_clk_en = 1, chip_clk_mux_sel = 1, rst on
create_hw_axi_txn -force cfgrst [get_hw_axis hw_axi_1] -address 40000000 -data {0000000E} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns cfgrst]
# 4. cfg take off rst
create_hw_axi_txn -force cfgrstoff [get_hw_axis hw_axi_1] -address 40000000 -data {0000000F} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns cfgrstoff]


# ------------------------------------------
# Hello world, with FLL
# ------------------------------------------
# FLL previously configured with range = 2
# 1. Keep the config but activate: async_mux = 1, clk_en = 1
create_hw_axi_txn -force en2rston [get_hw_axis hw_axi_1] -address 40000000 -data {00000256} -len 1 -type write
run_hw_axi [get_hw_axi_txns en2rston]
# 2. Release the reset
create_hw_axi_txn -force en2rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000257} -len 1 -type write
run_hw_axi [get_hw_axi_txns en2rstoff]

# Does not seem to work

# ------------------------------------------
# Hello world, with FLL
# ------------------------------------------
# 1. rst_n off
create_hw_axi_txn -force rstoff [get_hw_axis hw_axi_1] -address 40000000 -data {00000001} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns rstoff]
# 2. rst_n on
create_hw_axi_txn -force rston [get_hw_axis hw_axi_1] -address 40000000 -data {00000000} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns rston]
# 3. chip_clk_mux_sel = 1 (seems to work cuz current goes up)
create_hw_axi_txn -force muxon [get_hw_axis hw_axi_1] -address 40000000 -data {00000008} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns muxon]
# 3. chip_clk_en = 1
create_hw_axi_txn -force enon [get_hw_axis hw_axi_1] -address 40000000 -data {0000000C} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns enon]
# 4. Take rst off (current goes down a bit)
create_hw_axi_txn -force syson [get_hw_axis hw_axi_1] -address 40000000 -data {0000000D} -len 1 -type write
# Run it
run_hw_axi [get_hw_axi_txns syson]
