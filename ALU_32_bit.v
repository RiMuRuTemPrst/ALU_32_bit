module ALU_32_bit #(parameter N  = 32 )
(
    input signed [N - 1: 0] a,
    input signed [N - 1: 0] b,
    input wire   [3  : 0]   opcode,


    output reg   [N - 1: 0] result,
    output reg   [N - 1: 0] remainder,
    output reg  carry_out,
    output reg  zero,
    output reg  overflow
);
    reg signed [N - 1: 0] a_reg;
    reg signed [N - 1: 0] b_reg;
    reg signed [2*N - 1: 0] result_reg;
    reg signed [N - 1: 0] remainder_reg;

    wire signed [N - 1: 0] quotient;    //Result of divider
    wire signed [2*N - 1: 0] product;    //Result of multiplier

    wire signed [N - 1: 0] remainder_wire;
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
    /**
     * @brief This always block is used to set the value of a_reg and b_reg
     * 
     */
    always @(a or b)
    begin
        a_reg = a;
        b_reg = b;
    end
    
    always @(and_mode or or_mode or xor_mode or not_mode or neg_A_mode or neg_B_mode or adder_mode or 
    subtractor_mode or multiplier_mode or divider_mode or a_reg or b_reg)
    begin
        overflow = 0;
        carry_out = 0;
        if(and_mode)
        begin
            result_reg = a_reg & b_reg;
            remainder_reg = 0;
        end
        else if(or_mode)
        begin
            result_reg = a_reg | b_reg;
            remainder_reg = 0;
        end
        else if(xor_mode)
        begin
            result_reg = a_reg ^ b_reg;
            remainder_reg = 0;
        end
        else if(not_mode)
        begin
            result_reg = ~a_reg;
            remainder_reg = 0;
        end
        else if(neg_A_mode)
        begin
            result_reg = -a_reg;
            remainder_reg = 0;
        end
        else if(neg_B_mode)
        begin
            result_reg = -b_reg;
            remainder_reg = 0;
        end
        else if(adder_mode)
        begin
            result_reg = sum[N - 1:0];
            carry_out = sum[N];
            // Phát hiện signed overflow trong phép cộng
            overflow = (a[N-1] == b[N-1]) && (result_reg[N-1] != a[N-1]);
            remainder_reg = 0;
        end
        else if(subtractor_mode)
        begin
            result_reg = diff[N - 1:0];
            carry_out = diff[N];
            // Phát hiện signed overflow trong phép trừ
            overflow = (a[N-1] != b[N-1]) && (result_reg[N-1] != a[N-1]);
            remainder_reg = 0;
        end
        else if(multiplier_mode)
        begin
            result_reg = product[2*N - 1:0];
            //Overflow unsigned and overflow sined
            overflow = ((product[2*N - 1 : N] != 0)||((a[N-1]== b[N-1]) && (result_reg[2*N -1] != a[N-1])));
        end
        else if(divider_mode)
        begin
            if (b_reg == 0)
            begin
                result_reg = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
                remainder_reg = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
                overflow = 1;
            end
            else if (a_reg == 0)
            begin
                result_reg = 0;
                remainder_reg = 0;
            end
            else
            begin
                result_reg = quotient;
                remainder_reg = remainder_wire;
            end
        end
    end




    always @(result_reg or remainder_reg)
    begin
        result = result_reg[N - 1:0];
        remainder = remainder_reg;
        zero = (result === 0);
    end

    signed_number_32_bit_adder adder(.A(a), .B(b), .sum(sum));
    signed_number_32_bit_multiplier multiplier(.a(a), .b(b), .product(product));
    signed_number_32_bit_divider divider(.dividend(a), .divisor(b), .quotient(quotient), .remainder(remainder_wire));
    signed_number_32_bit_subtractor subtractor(.A(a), .B(b), .diff(diff));

endmodule