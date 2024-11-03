`include "define.tmp.h"
`include "piton_system.vh"

// Filename: polara_loopback.v
// Author: Raphael Rowley (2024-08)
// Contact: raphael.rowley@polymtl.ca
// Description: Chipset implementation that just sends
//              dummy packets into chip to test its NoC

module chipset_impl_polara_loopback(
    // Clocks and resets
    input           chipset_clk,
    input           chipset_rst_n,

    // Switches
    input           sw_channel_msb,
    input           sw_channel_lsb,
    input           sw_march,
    input           sw_go,
    output          sanity_is_waiting,

    // Main chip interface
    /*                                    
    output reg [`NOC_DATA_WIDTH-1:0] chipset_intf_data_noc1,
    output reg [`NOC_DATA_WIDTH-1:0] chipset_intf_data_noc2,
    output reg [`NOC_DATA_WIDTH-1:0] chipset_intf_data_noc3,*/
    output [64-1:0] chipset_intf_data_noc1,
    output [64-1:0] chipset_intf_data_noc2,
    output [64-1:0] chipset_intf_data_noc3, 
    output          chipset_intf_val_noc1,
    output          chipset_intf_val_noc2,
    output          chipset_intf_val_noc3,
    input           chipset_intf_rdy_noc1,
    input           chipset_intf_rdy_noc2,
    input           chipset_intf_rdy_noc3,

    /*input [`NOC_DATA_WIDTH-1:0] intf_chipset_data_noc1,
    input [`NOC_DATA_WIDTH-1:0] intf_chipset_data_noc2,
    input [`NOC_DATA_WIDTH-1:0] intf_chipset_data_noc3,*/
    input [64-1:0]  intf_chipset_data_noc1,
    input [64-1:0]  intf_chipset_data_noc2,
    input [64-1:0]  intf_chipset_data_noc3,
    input           intf_chipset_val_noc1,
    input           intf_chipset_val_noc2,
    input           intf_chipset_val_noc3,
    output          intf_chipset_rdy_noc1,
    output          intf_chipset_rdy_noc2,
    output          intf_chipset_rdy_noc3,

    // Chip and other BD signals
    input           mc_clk, // not sure if needed
    input           mig_ddr3_sys_se_clock_clk,
    output          chip_async_mux,
    output          chip_clk_en,
    output          chip_clk_mux_sel,
    output          chip_rst_n,
    output          init_calib_complete,
    output          test_start,

    // FLL
    input           fll_clkdiv,
    input           fll_lock,
    output          fll_bypass,
    output          fll_cfg_req,
    output          fll_opmode,
    output [3:0]    fll_range,
    output          fll_rst_n, 
                                    
    // Just dummy signals
    output          uart_tx,
    input           uart_rx,
    input           uart_boot_en,
    input           uart_timeout_en
);
   
// /////////////////////
// Type declarations  //
// /////////////////////

// /////////////////////////////////////////////////////////////////
// NoC message for polara loopback
// CHIPID: 14'b10000000000000
// XPOS: 8'd0
// YPOS: 8'd0
// FBITS: 4'b0010
// PAYLOAD LENGTH: 8'd0
// MESSAGE TYPE: MSG_TYPE_INV_FWD // Causes dummy invalidations 8'd18=8'b00010010
// MSHR/TAG: 8'd0
// RESERVED: 6'd0
// /////////////////////////////////////////////////////////////////

   wire [1:0]                           polara_gen2chipset_bus_i;
   wire [11:0]                          polara_gen2chipset_bus_o;
   wire                                 chip_rst_n_inter;
                        
   wire                                  sw_msb_debounced;
   wire                                  sw_lsb_debounced;
   wire [1:0]                            sw_debounced;
   wire                                  sw_march_debounced;
   wire                                  sw_go_debounced;

   reg                                   Q1, chipset_rstn_sync;
   
//////////////////////
// Sequential Logic //
//////////////////////
   
/////////////////////////
// Combinational Logic //
/////////////////////////

   // Instantiate the packet generator
   polara_loopback_packet_gen packet_gen_i(
                                           .chipset_clk(chipset_clk),
                                           .chip_rst_n(chip_rst_n_inter),
                                           .sw_debounced(sw_debounced),
                                           .march(sw_march_debounced),
                                           .go(sw_go_debounced),
                                           .sanity_is_waiting(sanity_is_waiting),
                                           .chipset_intf_data_noc1(chipset_intf_data_noc1),
                                           .chipset_intf_data_noc2(chipset_intf_data_noc2),
                                           .chipset_intf_data_noc3(chipset_intf_data_noc3),
                                           .chipset_intf_val_noc1(chipset_intf_val_noc1),
                                           .chipset_intf_val_noc2(chipset_intf_val_noc2),
                                           .chipset_intf_val_noc3(chipset_intf_val_noc3),
                                           .chipset_intf_rdy_noc1(chipset_intf_rdy_noc1),
                                           .chipset_intf_rdy_noc2(chipset_intf_rdy_noc2),
                                           .chipset_intf_rdy_noc3(chipset_intf_rdy_noc3),
                                           .intf_chipset_rdy_noc1(intf_chipset_rdy_noc1),
                                           .intf_chipset_rdy_noc2(intf_chipset_rdy_noc2),
                                           .intf_chipset_rdy_noc3(intf_chipset_rdy_noc3)
                                           );
 
   // Instantiate the block design
   gen2_polara_fpga_loopback gen2_polara_fpga_i(
                                                .bd_clk(chipset_clk),
                                                .mig_ddr3_sys_rst_n(chipset_rstn_sync),
                                                .polara_gen2chipset_bus_i_tri_i(polara_gen2chipset_bus_i),
                                                .polara_gen2chipset_bus_o_tri_o(polara_gen2chipset_bus_o)
                                                );

   // Synchronize the reset signal and send to the rest of the blocks
   always @ (posedge chipset_clk, negedge chipset_rst_n)
     if(!chipset_rst_n) begin
        Q1 <= 1'b0;
        chipset_rstn_sync <= 1'b0;
     end else begin
        Q1 <= 1'b1;
        chipset_rstn_sync <= Q1;
     end
   
   // Instantiate debouncers for the 2 channel switches
   debouncer debouncer_sw_msb(
                              .clk(chipset_clk),
                              .rstn(chipset_rstn_sync),
                              .i_sig(sw_channel_msb),
                              .o_sig_debounced(sw_msb_debounced));
   debouncer debouncer_sw_lsb(
                              .clk(chipset_clk),
                              .rstn(chipset_rstn_sync),
                              .i_sig(sw_channel_lsb),
                              .o_sig_debounced(sw_lsb_debounced));
   assign sw_debounced = {sw_msb_debounced, sw_lsb_debounced};

   debouncer debouncer_sw_march(
                              .clk(chipset_clk),
                              .rstn(chipset_rstn_sync),
                              .i_sig(sw_march),
                              .o_sig_debounced(sw_march_debounced));
   debouncer debouncer_sw_go(
                             .clk(chipset_clk),
                             .rstn(chipset_rstn_sync),
                             .i_sig(sw_go),
                             .o_sig_debounced(sw_go_debounced));
   
   

   // Route polara_gen2chipset_bus signals
   assign chip_rst_n = chip_rst_n_inter;
   assign chip_rst_n_inter = polara_gen2chipset_bus_o[0];
   assign chip_async_mux = polara_gen2chipset_bus_o[1];
   assign chip_clk_en = polara_gen2chipset_bus_o[2];
   assign chip_clk_mux_sel = polara_gen2chipset_bus_o[3];

   assign fll_rst_n = polara_gen2chipset_bus_o[4];
   assign fll_bypass = polara_gen2chipset_bus_o[5];
   assign fll_opmode = polara_gen2chipset_bus_o[6];
   assign fll_cfg_req = polara_gen2chipset_bus_o[7];

   assign fll_range[3:0] = polara_gen2chipset_bus_o[11:8];
   
   assign polara_gen2chipset_bus_i[0] = fll_lock;
   assign polara_gen2chipset_bus_i[1] = fll_clkdiv;

   
   
   // Assign network I/Os
   assign test_start = 1'b1;

   
endmodule
