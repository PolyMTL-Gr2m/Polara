# Copyright (c) 2016 Princeton University
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Princeton University nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Clock signals
#set_property IOSTANDARD LVDS [get_ports chipset_clk_osc_p]
#set_property PACKAGE_PIN E19 [get_ports chipset_clk_osc_p]
#set_property PACKAGE_PIN E18 [get_ports chipset_clk_osc_n]
#set_property IOSTANDARD LVDS [get_ports chipset_clk_osc_n]
#set_property IOSTANDARD LVDS [get_ports clk_osc_p]
#set_property PACKAGE_PIN E19 [get_ports clk_osc_p]
#set_property PACKAGE_PIN E18 [get_ports clk_osc_n]
#set_property IOSTANDARD LVDS [get_ports clk_osc_n]

#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets chipset/clk_mmcm/inst/clk_in1_clk_mmcm]

# Reset
set_property IOSTANDARD LVCMOS18 [get_ports rst_n]
set_property PACKAGE_PIN C39 [get_ports rst_n]

# False paths
#set_false_path -to [get_cells -hierarchical *afifo_ui_rst_r*]
#set_false_path -to [get_cells -hierarchical *ui_clk_sync_rst_r*]
#set_false_path -to [get_cells -hierarchical *ui_clk_syn_rst_delayed*]
#set_false_path -to [get_cells -hierarchical *init_calib_complete_f*]
#set_false_path -to [get_cells -hierarchical *chipset_rst_n*]
#set_false_path -from [get_clocks chipset_clk_clk_mmcm] -to [get_clocks net_axi_clk_clk_mmcm]

#set_clock_groups -name sync_gr1 -logically_exclusive -group chipset_clk_clk_mmcm -group [get_clocks -include_generated_clocks mc_sys_clk_clk_mmcm]

# UART
#IO_L11N_T1_SRCC_35 Sch=uart_rxd_out
#set_property IOSTANDARD LVCMOS18 [get_ports uart_tx]
#set_property PACKAGE_PIN AU36 [get_ports uart_tx]
#set_property IOSTANDARD LVCMOS18 [get_ports uart_rx]
#set_property PACKAGE_PIN AU33 [get_ports uart_rx]

# Switches
#set_property PACKAGE_PIN AV30 [get_ports sw[0]]
#set_property IOSTANDARD LVCMOS18 [get_ports sw[0]]
#set_property PACKAGE_PIN AY33 [get_ports sw[1]]
#set_property IOSTANDARD LVCMOS18 [get_ports sw[1]]
#set_property PACKAGE_PIN BA31 [get_ports sw[2]]
#set_property IOSTANDARD LVCMOS18 [get_ports sw[2]]
#set_property PACKAGE_PIN BA32 [get_ports sw[3]]
#set_property IOSTANDARD LVCMOS18 [get_ports sw[3]]
#set_property PACKAGE_PIN AW30 [get_ports sw[4]]
#set_property IOSTANDARD LVCMOS18 [get_ports sw[4]]
#set_property PACKAGE_PIN AY30 [get_ports sw[5]]
#set_property IOSTANDARD LVCMOS18 [get_ports sw[5]]
#set_property PACKAGE_PIN BA30 [get_ports sw[6]]
#set_property IOSTANDARD LVCMOS18 [get_ports sw[6]]
#set_property PACKAGE_PIN BB31 [get_ports sw[7]]
#set_property IOSTANDARD LVCMOS18 [get_ports sw[7]]

# SD
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AN30 DRIVE 16 SLEW FAST} [get_ports sd_clk_out]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AP30} [get_ports sd_cmd]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AR30} [get_ports {sd_dat[0]}]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AU31} [get_ports {sd_dat[1]}]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AV31} [get_ports {sd_dat[2]}]
#set_property -dict {IOSTANDARD LVCMOS18 PACKAGE_PIN AT30} [get_ports {sd_dat[3]}]
# set_property IOSTANDARD LVCMOS18 [get_ports sd_cd]
# set_property PACKAGE_PIN AP32 [get_ports sd_cd]

#set_property PACKAGE_PIN AV30 [get_ports uart_lb_sw]
#set_property IOSTANDARD LVCMOS18 [get_ports uart_lb_sw]

## LEDs

set_property PACKAGE_PIN AM39 [get_ports leds[0]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[0]]
set_property PACKAGE_PIN AN39 [get_ports leds[1]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[1]]
set_property PACKAGE_PIN AR37 [get_ports leds[2]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[2]]
set_property PACKAGE_PIN AT37 [get_ports leds[3]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[3]]
set_property PACKAGE_PIN AR35 [get_ports leds[4]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[4]]
set_property PACKAGE_PIN AP41 [get_ports leds[5]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[5]]
set_property PACKAGE_PIN AP42 [get_ports leds[6]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[6]]
set_property PACKAGE_PIN AU39 [get_ports leds[7]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[7]]

#############################################
# SD Card Constraints for 25MHz
#############################################
#create_generated_clock -name sd_fast_clk -source [get_pins chipset/clk_mmcm/sd_sys_clk] -divide_by 2 [get_pins chipset/chipset_impl/piton_sd_top/sdc_controller/clock_divider0/fast_clk_reg/Q]
#create_generated_clock -name sd_slow_clk -source [get_pins chipset/clk_mmcm/sd_sys_clk] -divide_by 200 [get_pins chipset/chipset_impl/piton_sd_top/sdc_controller/clock_divider0/slow_clk_reg/Q]
#create_generated_clock -name sd_clk_out   -source [get_pins chipset/sd_clk_oddr/C] -divide_by 1 -add -master_clock sd_fast_clk [get_ports sd_clk_out]
#create_generated_clock -name sd_clk_out_1 -source [get_pins chipset/sd_clk_oddr/C] -divide_by 1 -add -master_clock sd_slow_clk [get_ports sd_clk_out]

# compensate for board trace uncertainty
#set_clock_uncertainty 0.500 [get_clocks sd_clk_out]
#set_clock_uncertainty 0.500 [get_clocks sd_clk_out_1]

#################
# FPGA out / card in
# data is aligned with clock (source synchronous)

# hold fast (spec requires minimum 2ns), note that data is launched on falling edge, so 0.0 is ok here
#set_output_delay -clock [get_clocks sd_clk_out] -min -add_delay -6.000 [get_ports {sd_dat[*]}]
#set_output_delay -clock [get_clocks sd_clk_out] -min -add_delay -6.000 [get_ports sd_cmd]

# setup fast (spec requires minimum 6ns)
#set_output_delay -clock [get_clocks sd_clk_out] -max -add_delay 8.000 [get_ports {sd_dat[*]}]
#set_output_delay -clock [get_clocks sd_clk_out] -max -add_delay 8.000 [get_ports sd_cmd]

# hold slow (spec requires minimum 5ns), note that data is launched on falling edge, so 0.0 is ok here
#set_output_delay -clock [get_clocks sd_clk_out_1] -min -add_delay -8.000 [get_ports {sd_dat[*]}]
#set_output_delay -clock [get_clocks sd_clk_out_1] -min -add_delay -8.000 [get_ports sd_cmd]

# setup slow (spec requires minimum 5ns)
#set_output_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 8.000 [get_ports {sd_dat[*]}]
#set_output_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 8.000 [get_ports sd_cmd]

#################
# card out / FPGA in
# data is launched on negative clock edge here

# propdelay fast
#set_input_delay -clock [get_clocks sd_clk_out] -clock_fall -max -add_delay 14.000 [get_ports {sd_dat[*]}]
#set_input_delay -clock [get_clocks sd_clk_out] -clock_fall -max -add_delay 14.000 [get_ports sd_cmd]

# contamination delay fast
#set_input_delay -clock [get_clocks sd_clk_out] -clock_fall -min -add_delay -14.000 [get_ports {sd_dat[*]}]
#set_input_delay -clock [get_clocks sd_clk_out] -clock_fall -min -add_delay -14.000 [get_ports sd_cmd]

# propdelay slow
#set_input_delay -clock [get_clocks sd_clk_out_1] -clock_fall -max -add_delay 14.000 [get_ports {sd_dat[*]}]
#set_input_delay -clock [get_clocks sd_clk_out_1] -clock_fall -max -add_delay 14.000 [get_ports sd_cmd]

# contamination  slow
#set_input_delay -clock [get_clocks sd_clk_out_1] -clock_fall -min -add_delay -14.000 [get_ports {sd_dat[*]}]
#set_input_delay -clock [get_clocks sd_clk_out_1] -clock_fall -min -add_delay -14.000 [get_ports sd_cmd]

#################
# clock groups

#set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks sd_clk_out] -group [get_clocks -include_generated_clocks sd_clk_out_1]
#set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks sd_fast_clk] -group [get_clocks -include_generated_clocks sd_slow_clk]
#set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks chipset_clk_clk_mmcm] -group [get_clocks -filter { NAME =~  "*sd*" }]

#############################################
# FMC
#############################################
# Clock signals from chipset

# 66.6667MHz
#create_clock -period 14.9999993 -name io_clk -waveform {0.000 7.49999965} [get_ports io_clk]
#create_clock -period 14.9999993 -name core_ref_clk -waveform {0.000 7.49999965} [get_ports core_ref_clk]
# 64MHz
#create_clock -period 15.625 -name io_clk -waveform {0.000 7.8125} [get_ports io_clk]
#create_clock -period 15.625 -name core_ref_clk -waveform {0.000 7.8125} [get_ports core_ref_clk]
# 50MHz
create_clock -period 20 -name io_clk -waveform {0.000 10} [get_ports io_clk]
create_clock -period 20 -name core_ref_clk -waveform {0.000 10} [get_ports core_ref_clk]
# Needed to pass placement (2024/07/08 RR)
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {io_clk_IBUF}]
set_property -dict {PACKAGE_PIN C38 IOSTANDARD LVCMOS18} [get_ports io_clk]
set_property -dict {PACKAGE_PIN E33 IOSTANDARD LVCMOS18} [get_ports core_ref_clk]

#[Place 30-876] Port 'core_ref_clk'  is assigned to PACKAGE_PIN 'L40'  which can only be used as the N side of a differential clock input. 
#Please use the following constraint(s) to pass this DRC check:
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {core_ref_clk_IBUF}]

set_property -dict {PACKAGE_PIN L31 IOSTANDARD LVCMOS18} [get_ports chip_intf_channel[1]]
set_property -dict {PACKAGE_PIN K32 IOSTANDARD LVCMOS18} [get_ports chip_intf_channel[0]]

#set_property -dict {PACKAGE_PIN J25 IOSTANDARD LVCMOS18} [get_ports chipset_prsnt_n]

set_property -dict {PACKAGE_PIN J31 IOSTANDARD LVCMOS18} [get_ports chip_intf_credit_back[2]]
set_property -dict {PACKAGE_PIN L32 IOSTANDARD LVCMOS18} [get_ports chip_intf_credit_back[1]]
set_property -dict {PACKAGE_PIN M32 IOSTANDARD LVCMOS18} [get_ports chip_intf_credit_back[0]]

set_property -dict {PACKAGE_PIN H41 IOSTANDARD LVCMOS18} [get_ports intf_chip_channel[1]]
set_property -dict {PACKAGE_PIN H40 IOSTANDARD LVCMOS18} [get_ports intf_chip_channel[0]]

set_property -dict {PACKAGE_PIN N41 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[31]]
set_property -dict {PACKAGE_PIN P41 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[30]]
set_property -dict {PACKAGE_PIN K38 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[29]]
set_property -dict {PACKAGE_PIN K37 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[28]]
set_property -dict {PACKAGE_PIN P40 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[27]]
set_property -dict {PACKAGE_PIN R40 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[26]]
set_property -dict {PACKAGE_PIN M38 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[25]]
set_property -dict {PACKAGE_PIN M37 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[24]]
set_property -dict {PACKAGE_PIN L42 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[23]]
set_property -dict {PACKAGE_PIN M42 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[22]]
set_property -dict {PACKAGE_PIN K40 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[21]]
set_property -dict {PACKAGE_PIN K39 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[20]]
set_property -dict {PACKAGE_PIN M31 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[19]]
set_property -dict {PACKAGE_PIN N30 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[18]]
set_property -dict {PACKAGE_PIN B33 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[17]]
set_property -dict {PACKAGE_PIN B32 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[16]]
set_property -dict {PACKAGE_PIN A34 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[15]]
set_property -dict {PACKAGE_PIN B34 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[14]]
set_property -dict {PACKAGE_PIN G39 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[13]]
set_property -dict {PACKAGE_PIN H39 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[12]]
set_property -dict {PACKAGE_PIN P42 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[11]]
set_property -dict {PACKAGE_PIN R42 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[10]]
set_property -dict {PACKAGE_PIN L41 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[9]]
set_property -dict {PACKAGE_PIN M41 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[8]]
set_property -dict {PACKAGE_PIN J41 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[7]]
set_property -dict {PACKAGE_PIN J40 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[6]]
set_property -dict {PACKAGE_PIN N40 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[5]]
set_property -dict {PACKAGE_PIN N39 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[4]]
set_property -dict {PACKAGE_PIN M39 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[3]]
set_property -dict {PACKAGE_PIN N38 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[2]]
set_property -dict {PACKAGE_PIN J42 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[1]]
set_property -dict {PACKAGE_PIN K42 IOSTANDARD LVCMOS18} [get_ports intf_chip_data[0]]

set_property -dict {PACKAGE_PIN A37 IOSTANDARD LVCMOS18} [get_ports piton_prsnt_n]
set_property -dict {PACKAGE_PIN J26 IOSTANDARD LVCMOS18} [get_ports piton_ready_n]

set_property -dict {PACKAGE_PIN A36 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[31]]
set_property -dict {PACKAGE_PIN A35 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[30]]
set_property -dict {PACKAGE_PIN F37 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[29]]
set_property -dict {PACKAGE_PIN F36 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[28]]
set_property -dict {PACKAGE_PIN E39 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[27]]
set_property -dict {PACKAGE_PIN F39 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[26]]
set_property -dict {PACKAGE_PIN U29 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[25]]
set_property -dict {PACKAGE_PIN V29 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[24]]
set_property -dict {PACKAGE_PIN V31 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[23]]
set_property -dict {PACKAGE_PIN V30 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[22]]
set_property -dict {PACKAGE_PIN L30 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[21]]
set_property -dict {PACKAGE_PIN L29 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[20]]
set_property -dict {PACKAGE_PIN P31 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[19]]
set_property -dict {PACKAGE_PIN R30 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[18]]
set_property -dict {PACKAGE_PIN N29 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[17]]
set_property -dict {PACKAGE_PIN N28 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[16]]
set_property -dict {PACKAGE_PIN W31 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[15]]
set_property -dict {PACKAGE_PIN W30 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[14]]
set_property -dict {PACKAGE_PIN T31 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[13]]
set_property -dict {PACKAGE_PIN U31 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[12]]
set_property -dict {PACKAGE_PIN M29 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[11]]
set_property -dict {PACKAGE_PIN M28 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[10]]
set_property -dict {PACKAGE_PIN T30 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[9]]
set_property -dict {PACKAGE_PIN T29 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[8]]
set_property -dict {PACKAGE_PIN K30 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[7]]
set_property -dict {PACKAGE_PIN K29 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[6]]
set_property -dict {PACKAGE_PIN P28 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[5]]
set_property -dict {PACKAGE_PIN R28 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[4]]
set_property -dict {PACKAGE_PIN H30 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[3]]
set_property -dict {PACKAGE_PIN J30 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[2]]
set_property -dict {PACKAGE_PIN N31 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[1]]
set_property -dict {PACKAGE_PIN P30 IOSTANDARD LVCMOS18} [get_ports chip_intf_data[0]]

set_property -dict {PACKAGE_PIN F40 IOSTANDARD LVCMOS18} [get_ports intf_chip_credit_back[2]]
set_property -dict {PACKAGE_PIN G42 IOSTANDARD LVCMOS18} [get_ports intf_chip_credit_back[1]]
set_property -dict {PACKAGE_PIN G41 IOSTANDARD LVCMOS18} [get_ports intf_chip_credit_back[0]]
