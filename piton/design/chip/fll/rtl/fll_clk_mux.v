module fll_clk_mux (
    input   clk1,
    input   clk2,
    input   clksel,
    output  clk_muxed
);

    assign clk_muxed = clksel ? clk2 : clk1;

endmodule
