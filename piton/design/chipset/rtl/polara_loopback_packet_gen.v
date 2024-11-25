//`include "define.tmp.h"
//`include "piton_system.vh"

// Filename: polara_loopback.v
// Author: Raphael Rowley (2024-09)
// Contact: raphael.rowley@polymtl.ca
// Description: Packet generation logic for polara_loopback.v
module polara_loopback_packet_gen(
                                  input               chipset_clk,
                                  input               chip_rst_n,
                                  input [1:0]         sw_debounced,
                                  input               march,
                                  input               go,               
                                  output reg          sanity_is_waiting, 
                                  // Main chip interface
                                  /*                                    
                                   output reg [`NOC_DATA_WIDTH-1:0] chipset_intf_data_noc1,
                                   output reg [`NOC_DATA_WIDTH-1:0] chipset_intf_data_noc2,
                                   output reg [`NOC_DATA_WIDTH-1:0] chipset_intf_data_noc3,*/
                                  output reg [64-1:0] chipset_intf_data_noc1,
                                  output reg [64-1:0] chipset_intf_data_noc2,
                                  output reg [64-1:0] chipset_intf_data_noc3, 
                                  output reg          chipset_intf_val_noc1,
                                  output reg          chipset_intf_val_noc2,
                                  output reg          chipset_intf_val_noc3,
                                  input               chipset_intf_rdy_noc1,
                                  input               chipset_intf_rdy_noc2,
                                  input               chipset_intf_rdy_noc3,


                                  output              intf_chipset_rdy_noc1,
                                  output              intf_chipset_rdy_noc2,
                                  output              intf_chipset_rdy_noc3
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

   parameter STATE_RESET         = 3'b000;
   parameter STATE_SEND          = 3'b001;
   parameter STATE_WAIT          = 3'b010;
   parameter STATE_SEND_HEADER   = 3'b011;
   parameter STATE_SEND_DATA     = 3'b100;
   parameter STATE_SPECIAL_WAIT  = 3'b101;
   
   
   reg [2:0]                            CurrentState, NextState;
   //wire [`NOC_DATA_WIDTH-1:0]           out_data;
   reg [64-1:0]                         out_data, next_data;    
   reg [6:0]                            payload_count;
                            
   reg                                 noc_rdy;                                


   
   // ////////////////////
   // Sequential Logic  //
   // ////////////////////
   always @ (posedge chipset_clk, negedge chip_rst_n)
     begin: SEQ
        if (~chip_rst_n)
          begin
             CurrentState <= STATE_RESET;
             out_data <= {64{1'b0}};
             payload_count <= 7'd0;
             sanity_is_waiting <= 1'b1;
          end
        else
          begin
             case (CurrentState)
               STATE_RESET:
                 begin
                    sanity_is_waiting <= 1'b1;
                    if (go)
                      begin
                         sanity_is_waiting <= 1'b0;
                         CurrentState <= STATE_SPECIAL_WAIT;
                      end
                 end // case: STATE_RESET
               STATE_SPECIAL_WAIT:
                 begin
                    sanity_is_waiting <= 1'b0;
                    CurrentState <= STATE_SEND;
                    out_data <= {14'b10000000000000, 8'd0, 8'd0, 4'b0010, 8'd0, 8'd18, 8'd0, 6'd0};
                 end
               
               STATE_WAIT:
                 begin
                    sanity_is_waiting <= 1'b0;
                    if (march)
                      begin
                         CurrentState <= STATE_SEND_HEADER;
                         out_data <= {14'b10000000000000, 8'd0, 8'd0, 4'b0010, 8'd65, 8'd18, 8'd0, 6'd0};
                      end
                    else
                      begin
                         CurrentState <= STATE_SEND;
                         out_data <= {14'b10000000000000, 8'd0, 8'd0, 4'b0010, 8'd0, 8'd18, 8'd0, 6'd0};
                      end
                 end

               STATE_SEND_HEADER:
                 begin
                    sanity_is_waiting <= 1'b0;
                    if (noc_rdy)
                      begin
                         CurrentState <= STATE_SEND_DATA;
                         out_data <= {64{1'b0}};
                         payload_count <= 7'd0;
                      end
                 end // case: STATE_SEND_HEADER

               STATE_SEND_DATA:
                 begin
                    sanity_is_waiting <= 1'b0;
                    if (noc_rdy)
                      begin
                         if (payload_count == 7'd64)
                           begin
                              sanity_is_waiting <= 1'b1;
                              CurrentState <= STATE_RESET;
                              out_data <= {64{1'b0}};
                              payload_count <= 7'd0;
                           end
                         else if (payload_count == 7'd0)
                           begin
                              out_data <= { {63{1'b0}} , {1'b1} };
                              payload_count <= payload_count + 1'd1;
                           end
                         else
                           begin
                              out_data <= out_data << 1;
                              payload_count <= payload_count + 1'd1;
                           end
                      end
                 end // case: STATE_SEND_DATA
               
               STATE_SEND:
                 begin
                    sanity_is_waiting <= 1'b0;
                    if (noc_rdy)
                      begin
                         sanity_is_waiting <= 1'b1;
                         CurrentState = STATE_WAIT;
                         out_data <= {64{1'b0}};
                      end
                    else
                      begin
                         CurrentState = STATE_SEND;
                      end
                 end // case: STATE_SEND
               
               default: // STATE_WAIT
                 begin
                    sanity_is_waiting <= 1'b1;
                    CurrentState <= STATE_RESET;
                 end
               
             endcase // case (CurrentState)
          end // else: !if(~chip_rst_n)
     end // block: SEQ
   
        
        

   // ///////////////////////
   // Combinational Logic  //
   // ///////////////////////

   // Demuxes to route data and valid signals
   // `NOC_DATA_WIDTH = 64
   // And choose which rdy signal to monitor to transmit on
   always @(*) begin : RDY_DEMUX
      case(sw_debounced)
        2'h1: noc_rdy = chipset_intf_rdy_noc1;
        2'h2: noc_rdy = chipset_intf_rdy_noc2;
        default: noc_rdy = chipset_intf_rdy_noc3;
      endcase // case (sw_debounced)
   end
   
   always @(*) begin : DATA_DEMUX
      case(sw_debounced)
        2'h1: {chipset_intf_data_noc1, chipset_intf_data_noc2, chipset_intf_data_noc3} = {out_data, {64{1'b0}}, {64{1'b0}} };
        2'h2: {chipset_intf_data_noc1, chipset_intf_data_noc2, chipset_intf_data_noc3} = { {64{1'b0}}, out_data, {64{1'b0}} };
        2'h3: {chipset_intf_data_noc1, chipset_intf_data_noc2, chipset_intf_data_noc3} = { {64{1'b0}}, {64{1'b0}}, out_data};
        default: {chipset_intf_data_noc1, chipset_intf_data_noc2, chipset_intf_data_noc3} = { {64{1'b0}}, {64{1'b0}}, {64{1'b0}} };
      endcase
   end

   always @(*) begin : VALID_DEMUX
      case(sw_debounced)
        2'h1: {chipset_intf_val_noc1, chipset_intf_val_noc2, chipset_intf_val_noc3} = {(CurrentState != STATE_RESET), 1'b0, 1'b0 };
        2'h2: {chipset_intf_val_noc1, chipset_intf_val_noc2, chipset_intf_val_noc3} = { 1'b0, (CurrentState != STATE_RESET), 1'b0 };
        2'h3: {chipset_intf_val_noc1, chipset_intf_val_noc2, chipset_intf_val_noc3} = { 1'b0, 1'b0, (CurrentState != STATE_RESET) };
        default: {chipset_intf_val_noc1, chipset_intf_val_noc2, chipset_intf_val_noc3} = { 1'b0, 1'b0, 1'b0 };
      endcase
   end

   /*
    assign chipset_intf_data_noc1 = {`NOC_DATA_WIDTH{1'bx}};
    assign chipset_intf_data_noc2 = out_data;
    assign chipset_intf_data_noc3 = {`NOC_DATA_WIDTH{1'bx}};

    assign chipset_intf_val_noc1 = 1'b0;
    assign chipset_intf_val_noc2 = (CurrentState != STATE_RESET);
    assign chipset_intf_val_noc3 = 1'b0;
    */
   assign intf_chipset_rdy_noc1 = 1'b0;
   assign intf_chipset_rdy_noc2 = 1'b0;
   assign intf_chipset_rdy_noc3 = 1'b0;
   
endmodule // polara_loopback_packet_gen
