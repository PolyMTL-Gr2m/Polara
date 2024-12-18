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

#
# Board specific variables
# Not intended to be run standalone
#

set BOARD_PART "digilentinc.com:genesys2:part0:1.1"
set FPGA_PART "xc7k325tffg900-2"
set VIVADO_FLOW_PERF_OPT 0
set BOARD_DEFAULT_VERILOG_MACROS "GENESYS2_BOARD"

# First check if we are doing loopback test
if { [ info exists ::env(POLARA_LOOPBACK) ] } {
    # Create a block design containing a JTAG-AXI master using the FPGA_PART variable
    # It will produce the "gen2_polara_fpga.bd" file

    source $DV_ROOT/tools/src/proto/${BOARD}/gen2_polara_fpga_loopback.tcl

    # Grab the file from where the above tcl script has placed it
    set DESIGN_BD_FILES [list $DV_ROOT/design/chipset/xilinx/genesys2/gen2_polara_fpga_loopback/gen2_polara_fpga_loopback]
} elseif { [ info exists ::env(POLARA_GEN2_CHIPSETSE) ] } {
    # Single ended clock (for MIG input clock) has a specific block design
    # Create a block design containing a JTAG-AXI master using the FPGA_PART variable
    # It will produce the "gen2_polara_fpga.bd" file

    source $DV_ROOT/tools/src/proto/${BOARD}/gen2_polara_fpga_se_clk.tcl

    # Grab the file from where the above tcl script has placed it
    set DESIGN_BD_FILES [list $DV_ROOT/design/chipset/xilinx/genesys2/gen2_polara_fpga_se_clk/gen2_polara_fpga_se_clk]
} else {
    # Create a block design containing a JTAG-AXI master using the FPGA_PART variable
    # It will produce the "gen2_polara_fpga.bd" file

    source $DV_ROOT/tools/src/proto/${BOARD}/gen2_polara_fpga.tcl

    # Grab the file from where the above tcl script has placed it
    set DESIGN_BD_FILES [list $DV_ROOT/design/chipset/xilinx/genesys2/gen2_polara_fpga/gen2_polara_fpga]

}
