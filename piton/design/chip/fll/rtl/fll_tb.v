`timescale 1ns/1ps

module tb_fll_top;

  reg fll_rst_n;
  reg fll_ref_clk;
  reg fll_bypass;
  reg fll_opmode;
  reg fll_cfgreq;
  reg [3:0] fll_range;
  wire fll_clk;
  wire fll_clkdiv;
  wire fll_lock;

  // Instantiate the module under test (MUT)
  fll_top uut (
      .fll_rst_n(fll_rst_n),
      .fll_ref_clk(fll_ref_clk),
      .fll_bypass(fll_bypass),
      .fll_opmode(fll_opmode),
      .fll_cfgreq(fll_cfgreq),
      .fll_range(fll_range),
      .fll_clk(fll_clk),
      .fll_clkdiv(fll_clkdiv),
      .fll_lock(fll_lock)
  );

  // Create a clock with period of 20ns
  always begin
    fll_ref_clk = 0; #23;
    fll_ref_clk = 1; #23;
  end

  // Stimulate the inputs and observe the outputs
  initial begin
    // Reset the module
    fll_bypass = 0;
    fll_opmode = 1;
    fll_cfgreq = 0;
    fll_range = 4'h0;
    fll_rst_n = 0;
    #425
    fll_rst_n = 1;
    #10000;

    // 750 MHz
    fll_bypass = 0;
    fll_opmode = 1;
    fll_cfgreq = 0;
    fll_range = 4'h5;
    fll_cfgreq = 1;
    #425;
    fll_cfgreq = 0;
    #500000;

    // 1.5 GHz
    fll_bypass = 0;
    fll_opmode = 1;
    fll_range = 4'h8;
    fll_cfgreq = 1;
    #425;
    fll_cfgreq = 0;
    #500000;

    // End of the test
    $finish;
  end

endmodule
