// Debouncer module to use for the switches in the Polara loopback chipset.
// Taken from: https://github.com/iammituraj/debouncer/blob/main/debouncer.sv
// N_BOUNCE = ceil(log_2(T_bounce / T_clk))
// For T_bounce = 10ms and T_clk = 40MHz, this gives N_BOUNCE = 19
/*===============================================================================================================================
   Module       : Debouncer

   Description  : Debouncer is used to filter bouncing found in typical switches and provide a clean, glitch-free state change.
                  -- Configurable bouncing interval in powers of 2 (threshold).
                  -- Changes state at the output based on counting the no. of times the same input is sampled consecutively.
                     Switch state transition appears at output only if the count crosses the threshold. 
                  -- Debounces both assertion and release of switches.                            
                  -- Supports both pull-up and pull-down switch inputs.
                  -- Debouncer is designed to debounce switches with pull-down (OFF state = '0', ON state = '1').                                        
                     For pull-up switches (OFF state = '1', ON state = '0'), debounced signal should be treated as valid 
                     only after one bouncing interval latency after reset. Because on reset, debounced signal 
                     drives '0' by default, which is ON state for pull-up switch. This may be undesirable. 
                     If the initial latency is undesired, IS_PULLUP parameter can be set.                      

   Developer    : Mitu Raj, chip@chipmunklogic.com at Chipmunk Logic ™, https://chipmunklogic.com
   Notes        : Fully synthesisable, portable and tested code.
                  < 10 MHz clock is recommended for minimal resource usage assuming < 10 ms as switch bouncing time.
   License      : Open-source.
   Date         : Nov-09-2021
===============================================================================================================================*/

/*-------------------------------------------------------------------------------------------------------------------------------
                                                      D E B O U N C E R
-------------------------------------------------------------------------------------------------------------------------------*/

module debouncer #(
   
   // Global Parameters   
   parameter N_BOUNCE    =  19   ,           // Bouncing interval in clock cycles = 2^N_BOUNCE
   parameter IS_PULLUP   =  0               // Optional: '1' for pull-up switch, '0' for pull-down switch
                                                  
) 

(
   input  logic clk             ,           // Clock
   input  logic rstn            ,           // Active-low synchronous reset
   input  logic i_sig           ,           // Bouncing signal from switch
   output logic o_sig_debounced             // Debounced signal
) ;


/*-------------------------------------------------------------------------------------------------------------------------------
   Internal Registers/Signals
-------------------------------------------------------------------------------------------------------------------------------*/
logic                isig_rg, isig_sync_rg              ;        // Registers in 2FF Synchronizer 
logic                sig_rg, sig_d_rg, sig_debounced_rg ;        // Registers for switch's state
logic [N_BOUNCE : 0] counter_rg                         ;        // Counter
logic [N_BOUNCE : 0] nxt_cnt                            ;        // Next count


/*-------------------------------------------------------------------------------------------------------------------------------
   Synchronous logic for debouncing
-------------------------------------------------------------------------------------------------------------------------------*/
always @(posedge clk) begin
   
   // Reset  
   if (!rstn) begin
      
      // Internal Registers
      sig_rg           <= IS_PULLUP ; 
      sig_d_rg         <= IS_PULLUP ;
      sig_debounced_rg <= IS_PULLUP ;
      counter_rg       <=  1        ;

   end
   
   // Out of reset
   else begin
      
      // Register state of switch      
      sig_rg   <= isig_sync_rg  ;
      sig_d_rg <= sig_rg        ;

      // Increment counter if two consecutive states are same, otherwise reset
      counter_rg <= (sig_d_rg == sig_rg) ? nxt_cnt : 1 ;
      
      // Counter overflow, valid state registered
      if (counter_rg [N_BOUNCE]) begin
         sig_debounced_rg <= sig_d_rg ;
      end

   end

end

assign nxt_cnt = (counter_rg [N_BOUNCE])? counter_rg : (counter_rg + 1) ;


/*-------------------------------------------------------------------------------------------------------------------------------
   2FF Synchronizer
-------------------------------------------------------------------------------------------------------------------------------*/
always @(posedge clk) begin
   
   // Reset  
   if (!rstn) begin
      
      // Internal Registers
      isig_rg      <= IS_PULLUP ;
      isig_sync_rg <= IS_PULLUP ;
      
   end
   
   // Out of reset
   else begin
      
      isig_rg      <= i_sig   ;        // Metastable flop
      isig_sync_rg <= isig_rg ;        // Synchronizing flop

   end

end


/*-------------------------------------------------------------------------------------------------------------------------------
   Continuous Assignments
-------------------------------------------------------------------------------------------------------------------------------*/
assign o_sig_debounced = sig_debounced_rg ;


endmodule

/*-------------------------------------------------------------------------------------------------------------------------------
                                                      D E B O U N C E R
-------------------------------------------------------------------------------------------------------------------------------*/
