module signed_number_32_bit_adder 
(
    signed [31:0] A,
    signed [31:1] B,
    output signed [32:0] sum
)

    assign sum = A + B;

endmodule