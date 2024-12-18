module fll_ctrl (
    // External interface
    input [3:0] range,
    input       opmode,
    input       fll_cfgreq,
    input       ref_clk,
    input       rst_n,

    // FLL internal interface
    input           cfgack,
    output          cfgreq,
    output          cfgweb,
    output [1:0]    cfgad,
    output [31:0]   cfgd
);

localparam 
    WAIT_CHANGE = 2'b00, 
    START_CFG   = 2'b01, 
    WAIT_ACK    = 2'b10, 
    CLEAR_CFG   = 2'b11; 

reg [1:0] curr_state, next_state; 

wire [15:0] mul; 

reg cfgreq_value;
reg cfgweb_value;

assign mul   = 1 << range;
assign cfgad = 2'b01; 
assign cfgd  = {opmode, 1'b1, 4'h0, 10'h088, mul}; 
assign cfgreq = cfgreq_value;
assign cfgweb = cfgweb_value;

always @(curr_state, fll_cfgreq, cfgack) begin
    case (curr_state)
        WAIT_CHANGE:
            begin
                cfgreq_value = 1'b0;
                cfgweb_value = 1'b1;           
                if (fll_cfgreq)
                    next_state = START_CFG;
                else
                    next_state = WAIT_CHANGE;
            end
        START_CFG:
            begin
                cfgreq_value = 1'b1;
                cfgweb_value = 1'b0;
                next_state = WAIT_ACK;
            end
        WAIT_ACK:
            begin
                cfgreq_value = 1'b1;
                cfgweb_value = 1'b0;
                if (cfgack)
                    next_state = CLEAR_CFG;
                else
                    next_state = WAIT_ACK;
            end
        CLEAR_CFG: 
            begin
                cfgreq_value = 1'b0;
                cfgweb_value = 1'b1;
                if (cfgack || fll_cfgreq)
                    next_state = CLEAR_CFG;
                else 
                    next_state = WAIT_CHANGE;
            end
        default:
            begin
                cfgreq_value = 1'b0;
                cfgweb_value = 1'b1;   
                next_state = WAIT_CHANGE;
            end
    endcase
end

// Assign next state
always @(posedge ref_clk) begin
    if (!rst_n) begin
        curr_state      <= WAIT_CHANGE;
    end else begin
        curr_state      <= next_state;
    end
end

endmodule