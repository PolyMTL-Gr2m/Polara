module fll_clk_mux (
    input   clk1,
    input   clk2,
    input   clksel,
    output  clk_muxed
);

`ifdef PITON_FPGA_SYNTH
    assign clk_muxed = clk2;
`else
    assign clk_muxed = clksel ? clk2 : clk1;
`endif
endmodule
