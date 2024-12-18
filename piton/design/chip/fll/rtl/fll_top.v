module fll_top (
    input fll_rst_n,
    input fll_ref_clk,
    input fll_bypass,
    input fll_opmode,
    input fll_cfgreq,
    input [3:0] fll_range,
    output fll_clk,
    output fll_clkdiv,
    output fll_lock
);

// Wire definitions
wire clk_out;
wire lock;

wire cfgack;
wire cfgreq;
wire cfgweb;
wire [1:0]  cfgad; 
wire [31:0] cfgd;  

// Behavioral model of the FLL
// Will be replace by hard macro in the backend.
gf22_FLL behav_fll (
    .FLLCLK (clk_out), 
    .FLLOE  (!fll_bypass),
    .REFCLK (fll_ref_clk),
    .LOCK   (lock),
    .CFGREQ (cfgreq),
    .CFGACK (cfgack),
    .CFGAD  (cfgad),
    .CFGD   (cfgd),
    .CFGQ   (),
    .CFGWEB (cfgweb),
    .RSTB   (fll_rst_n),
    .RET    (1'b0),
    .PWD    (1'b0),
    .TM     (1'b0),
    .TE     (1'b0),
    .TD     (1'b0),
    .TQ     (),
    .JTD    (1'b0),
    .JTQ    ()
);

// FLL control unit
fll_ctrl ctrl_unit (
    .range      (fll_range),
    .opmode     (fll_opmode),
    .fll_cfgreq (fll_cfgreq),
    .ref_clk    (fll_ref_clk),
    .rst_n      (fll_rst_n),
    .cfgack     (cfgack),
    .cfgreq     (cfgreq),
    .cfgweb     (cfgweb),
    .cfgad      (cfgad ),
    .cfgd       (cfgd  )

);

// Clock division unit
fll_clk_div clk_div (
    .rst_n (fll_rst_n & lock),
    .clk_in (clk_out),
    .clk_out(fll_clkdiv)
);

assign fll_lock = lock;
assign fll_clk = clk_out;

endmodule
