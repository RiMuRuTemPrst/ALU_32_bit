module signed_number_multiplier (
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

        // Th?c hi?n ph�p nh�n b?ng d?ch bit v� c?ng d?n
        if (multiplier[0] == 1) temp_product = temp_product + (multiplicand << 0);
        if (multiplier[1] == 1) temp_product = temp_product + (multiplicand << 1);
        if (multiplier[2] == 1) temp_product = temp_product + (multiplicand << 2);
        if (multiplier[3] == 1) temp_product = temp_product + (multiplicand << 3);
        if (multiplier[4] == 1) temp_product = temp_product + (multiplicand << 4);
        if (multiplier[5] == 1) temp_product = temp_product + (multiplicand << 5);
        if (multiplier[6] == 1) temp_product = temp_product + (multiplicand << 6);
        if (multiplier[7] == 1) temp_product = temp_product + (multiplicand << 7);
        if (multiplier[8] == 1) temp_product = temp_product + (multiplicand << 8);
        if (multiplier[9] == 1) temp_product = temp_product + (multiplicand << 9);
        if (multiplier[10] == 1) temp_product = temp_product + (multiplicand << 10);
        if (multiplier[11] == 1) temp_product = temp_product + (multiplicand << 11);
        if (multiplier[12] == 1) temp_product = temp_product + (multiplicand << 12);
        if (multiplier[13] == 1) temp_product = temp_product + (multiplicand << 13);
        if (multiplier[14] == 1) temp_product = temp_product + (multiplicand << 14);
        if (multiplier[15] == 1) temp_product = temp_product + (multiplicand << 15);
        if (multiplier[16] == 1) temp_product = temp_product + (multiplicand << 16);
        if (multiplier[17] == 1) temp_product = temp_product + (multiplicand << 17);
        if (multiplier[18] == 1) temp_product = temp_product + (multiplicand << 18);
        if (multiplier[19] == 1) temp_product = temp_product + (multiplicand << 19);
        if (multiplier[20] == 1) temp_product = temp_product + (multiplicand << 20);
        if (multiplier[21] == 1) temp_product = temp_product + (multiplicand << 21);
        if (multiplier[22] == 1) temp_product = temp_product + (multiplicand << 22);
        if (multiplier[23] == 1) temp_product = temp_product + (multiplicand << 23);
        if (multiplier[24] == 1) temp_product = temp_product + (multiplicand << 24);
        if (multiplier[25] == 1) temp_product = temp_product + (multiplicand << 25);
        if (multiplier[26] == 1) temp_product = temp_product + (multiplicand << 26);
        if (multiplier[27] == 1) temp_product = temp_product + (multiplicand << 27);
        if (multiplier[28] == 1) temp_product = temp_product + (multiplicand << 28);
        if (multiplier[29] == 1) temp_product = temp_product + (multiplicand << 29);
        if (multiplier[30] == 1) temp_product = temp_product + (multiplicand << 30);
        if (multiplier[31] == 1) temp_product = temp_product + (multiplicand << 31);
        
        // Convert the result back to 2's complement if necessaryS
        if (sign == 1) temp_product = -temp_product;

        // G�n gi� tr? cho output
        product = temp_product;
    end

endmodule
