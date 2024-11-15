module ALU_32_bit (#parameter N  = 32 )
(
    input signed [N - 1: 0] a;
    input signed [N - 1: 0] b;
    input wire   [3  : 0]   opcode;


    output reg   [N - 1: 0] result;
    output reg   [N - 1: 0] remainder;
    output reg  carry_out;
    output reg  zero;
    output reg  overflow;
)
    reg signed [N - 1: 0] a_reg;
    reg signed [N - 1: 0] b_reg;
    reg signed [2N - 1: 0] result_reg;
    reg signed [N - 1: 0] remainder_reg;

    wire signed [N - 1: 0] quotient;    //Result of divider
    wire signed [N - 1: 0] remainder;   
    wire signed [2N - 1: 0] product;    //Result of multiplier
    wire signed [N : 0] sum;
    wire signed [N : 0] diff;

    reg and_mode, or_mode, xor_mode, not_mode, neg_A_mode, neg_B_mode, adder_mode, subtractor_mode, multiplier_mode, divider_mode; 
    integer i;

     //Set Mode depends on Opcode
    /*
    AND - 0000
    OR - 0001
    XOR - 0010
    NOT - 0011
    NEG A - 0100
    NEG B - 0101
    ADD (+) - 0110
    SUB (-) - 0111
    MUL (x) - 1000
    DIV (/) - 1001
    */
    always @(opcode)
    begin
        case(opcode)
            4'b0000: begin and_mode = 1; or_mode = 0; xor_mode = 0; not_mode = 0; neg_A_mode = 0; neg_B_mode = 0; adder_mode = 0; subtractor_mode = 0; multiplier_mode = 0; divider_mode = 0; end
            4'b0001: begin and_mode = 0; or_mode = 1; xor_mode = 0; not_mode = 0; neg_A_mode = 0; neg_B_mode = 0; adder_mode = 0; subtractor_mode = 0; multiplier_mode = 0; divider_mode = 0; end
            4'b0010: begin and_mode = 0; or_mode = 0; xor_mode = 1; not_mode = 0; neg_A_mode = 0; neg_B_mode = 0; adder_mode = 0; subtractor_mode = 0; multiplier_mode = 0; divider_mode = 0; end
            4'b0011: begin and_mode = 0; or_mode = 0; xor_mode = 0; not_mode = 1; neg_A_mode = 0; neg_B_mode = 0; adder_mode = 0; subtractor_mode = 0; multiplier_mode = 0; divider_mode = 0; end
            4'b0100: begin and_mode = 0; or_mode = 0; xor_mode = 0; not_mode = 0; neg_A_mode = 1; neg_B_mode = 0; adder_mode = 0; subtractor_mode = 0; multiplier_mode = 0; divider_mode = 0; end
            4'b0101: begin and_mode = 0; or_mode = 0; xor_mode = 0; not_mode = 0; neg_A_mode = 0; neg_B_mode = 1; adder_mode = 0; subtractor_mode = 0; multiplier_mode = 0; divider_mode = 0; end
            4'b0110: begin and_mode = 0; or_mode = 0; xor_mode = 0; not_mode = 0; neg_A_mode = 0; neg_B_mode = 0; adder_mode = 1; subtractor_mode = 0; multiplier_mode = 0; divider_mode = 0; end
            4'b0111: begin and_mode = 0; or_mode = 0; xor_mode = 0; not_mode = 0; neg_A_mode = 0; neg_B_mode = 0; adder_mode = 0; subtractor_mode = 1; multiplier_mode = 0; divider_mode = 0; end
            4'b1000: begin and_mode = 0; or_mode = 0; xor_mode = 0; not_mode = 0; neg_A_mode = 0; neg_B_mode = 0; adder_mode = 0; subtractor_mode = 0; multiplier_mode = 1; divider_mode = 0; end
            4'b1001: begin and_mode = 0; or_mode = 0; xor_mode = 0; not_mode = 0; neg_A_mode = 0; neg_B_mode = 0; adder_mode = 0; subtractor_mode = 0; multiplier_mode = 0; divider_mode = 1; end
            default: begin and_mode = 0; or_mode = 0; xor_mode = 0; not_mode = 0; neg_A_mode = 0; neg_B_mode = 0; adder_mode = 0; subtractor_mode = 0; multiplier_mode = 0; divider_mode = 0; end
        endcase
    end

endmodule