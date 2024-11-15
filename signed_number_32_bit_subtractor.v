module signed_number_32_bit_subtractor 
(
    signed [31:0] A,
    signed [31:1] B,
    output signed [32:0] difference
);

    assign difference = A - B;
endmodule

   