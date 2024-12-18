`timescale 1ns / 1ps

// Filename: polara_loopback_packet_gen_tb.v
// Author: Raphael Rowley (2024-09)
// Contact: raphael.rowley@polymtl.ca
// Description: Testbench to functionnally simulate the packet gen logic for polara_loopback.v

module polara_loopback_packet_gen_tb();

   // /////////////////////
   // Type declarations  //
   // /////////////////////
   reg                  chipset_clk;
   reg                  chip_rst_n_inter;
   reg [1:0]            sw_debounced;
   reg                  march;
   reg                  go;                 

   wire                 sanity;
   
   wire [64-1:0]          chipset_intf_data_noc1;
   wire [64-1:0]          chipset_intf_data_noc2;
   wire [64-1:0]          chipset_intf_data_noc3;

   wire                  chipset_intf_val_noc1;
   wire                  chipset_intf_val_noc2;
   wire                  chipset_intf_val_noc3;

   reg                  chipset_intf_rdy_noc1;
   reg                  chipset_intf_rdy_noc2;
   reg                  chipset_intf_rdy_noc3;

   wire                  intf_chipset_rdy_noc1;
   wire                  intf_chipset_rdy_noc2;
   wire                  intf_chipset_rdy_noc3;
   
   // Instantiate DUT
   polara_loopback_packet_gen dut(
                                  .chipset_clk(chipset_clk),
                                  .chip_rst_n(chip_rst_n_inter),
                                  .sw_debounced(sw_debounced),
                                  .march(march),
                                  .go(go),
                                  .sanity_is_waiting(sanity),
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
   // Clock gen
   initial begin
      assign chipset_clk = 1'b0;
      forever #12.5 assign chipset_clk = ~chipset_clk;
   end

   // Reset generation
   initial begin
      chip_rst_n_inter = 1'b0;
       #50
      chip_rst_n_inter = 1'b1;
      $display("rst_n is over: %h", chip_rst_n_inter);
       #50
         $display("Current state should be 1, it is: %h", dut.CurrentState);
      
   end

   // Stimulus
   initial begin
      sw_debounced = 2'b01;
      chipset_intf_rdy_noc1 = 1'b0;
      chipset_intf_rdy_noc2 = 1'b0;
      chipset_intf_rdy_noc3 = 1'b0;
      march = 1'b0;
      go = 1'b1;
      
      #150
        chipset_intf_rdy_noc1 = 1'b1;
      #150
        go = 1'b0;
        chip_rst_n_inter = 1'b0;
      chipset_intf_rdy_noc1 = 1'b0;
      march = 1'b1;
      #50
        go = 1'b1;
      #50
        chip_rst_n_inter = 1'b1;
      #50
        chipset_intf_rdy_noc1 = 1'b1;
      #500
        chipset_intf_rdy_noc1 = 1'b0;
      #500
        chipset_intf_rdy_noc1 = 1'b1;
      #2000
        chip_rst_n_inter = 1'b0;
      go = 1'b0;
      #100
        chip_rst_n_inter = 1'b1;
      $display("rst_n is over: %h", chip_rst_n_inter);
      #50
        $display("Current state should be 1, it is: %h", dut.CurrentState);
      #400
        go = 1'b1;
      #400
        go = 1'b0;
      #2000
        go = 1'b1;
      #1000
      $finish;
      
   end
   
   
endmodule // polara_loopback_packet_gen_tb
