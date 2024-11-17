module signed_number_32_bit_multiplier (
    input signed [31:0] a,  // first number
    input signed [31:0] b,  // second number
    output reg signed [63:0] product  // product
);

    reg signed [31:0] multiplicand;
    reg signed [31:0] multiplier;
    reg signed [63:0] temp_product;
    reg sign;

    always @(*) begin
        // Initialization
        temp_product = 0;
        multiplicand = a;
        multiplier = b;
        sign = a[31] ^ b[31]; // identify sign of the result

        // Convert negative numbers to 2's complement if necessary
        if (a[31] == 1) multiplicand = -a;
        if (b[31] == 1) multiplier = -b;    

        
        
        // Convert the result back to 2's complement if necessaryS
        if (sign == 1) temp_product = -temp_product;

        // G�n gi� tr? cho output
        product = temp_product;
    end

endmodule
