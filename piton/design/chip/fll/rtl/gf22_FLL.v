module gf22_FLL (
    output FLLCLK,
    input  FLLOE,
    input  REFCLK,
    output LOCK,
    input  CFGREQ,
    output CFGACK,
    input  [1:0] CFGAD,
    input  [31:0] CFGD,
    output [31:0] CFGQ,
    input  CFGWEB,
    input  RSTB,
    input  PWD,
    input  RET,
    input  TM,
    input  TE,
    input  TD,
    output TQ,
    input  JTD,
    output JTQ
);

reg [6:0] counter;

// Bypass clock
// assign FLLCLK = REFCLK;
reg fll_clk = 0;
always #5000 fll_clk = ~fll_clk; // 100 MHz
assign FLLCLK = fll_clk;

// Non-synthesizeable locked logic
// Starts out as 0 and changes to 1 100 ref_clk
// cycles after falling edge of reset (deasserting reset)
`ifndef VERILATOR
initial
begin
    force LOCK = 1'b0;
    wait (RSTB == 1'b0);
    wait (RSTB == 1'b1);
    repeat(100)@(posedge REFCLK);
    force LOCK = 1'b1;
end
`else
always @(posedge REFCLK)
begin
    if (RSTB == 0)
    begin
        counter = 7'd0;
    end
    else if (counter < 7'd100)
    begin
        counter = counter + 1'b1;
    end
end

assign LOCK = counter == 7'd100;
`endif

endmodule
