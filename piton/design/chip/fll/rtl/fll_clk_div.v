module fll_clk_div #(
    parameter NUM_FLOPS = 16
) (
    input   rst_n,
    input   clk_in,
    output  clk_out
);

    reg [NUM_FLOPS-1:0] count = 0; 

    always @(posedge clk_in) begin
        if (!rst_n) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

    assign clk_out = count[NUM_FLOPS-1];

endmodule
