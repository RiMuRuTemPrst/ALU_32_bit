`timescale 1ns / 1ps

module tb_signed_number_32_bit_multiplier;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg signed [31:0] a;
    reg signed [31:0] b;

    // Outputs
    wire signed [63:0] product;
    wire done;

    // Instantiate the multiplier module
    signed_number_32_bit_multiplier uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .product(product),
        .done(done)
    );

    // Generate clock signal
    always #5 clk = ~clk; // 10 ns period (100 MHz clock)

    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        start = 0;
        a = 0;
        b = 0;

        // Wait for global reset
        #20;
        rst = 0;

        // Test Case 1: 5 * 3 = 15
        a = 32'd5;
        b = 32'd3;
        start = 1;
        #10; // Wait for one clock cycle
        start = 0;
        wait (done); // Wait until the done signal is high
        #10;
        $display("Test Case 1: a = 5, b = 3, product = %d (Expected: 15)", product);

        // Test Case 2: -5 * 3 = -15
        a = -32'd5;
        b = 32'd3;
        start = 1;
        #10; // Wait for one clock cycle
        start = 0;
        wait (done); // Wait until the done signal is high
        #10;
        $display("Test Case 2: a = -5, b = 3, product = %d (Expected: -15)", product);

        // Test Case 3: -5 * -3 = 15
        a = -32'd5;
        b = -32'd3;
        start = 1;
        #10; // Wait for one clock cycle
        start = 0;
        wait (done); // Wait until the done signal is high
        #10;
        $display("Test Case 3: a = -5, b = -3, product = %d (Expected: 15)", product);

        // Test Case 4: 0 * 12345 = 0
        a = 32'd0;
        b = 32'd12345;
        start = 1;
        #10; // Wait for one clock cycle
        start = 0;
        wait (done); // Wait until the done signal is high
        #10;
        $display("Test Case 4: a = 0, b = 12345, product = %d (Expected: 0)", product);

        // Test Case 5: Large numbers
        a = 32'd2147483647; // Max positive 32-bit signed integer
        b = 32'd2;
        start = 1;
        #10; // Wait for one clock cycle
        start = 0;
        wait (done); // Wait until the done signal is high
        #10;
        $display("Test Case 5: a = 2147483647, b = 2, product = %d (Expected: 4294967294)", product);

        // Test Case 6: -2147483648 * 1 = -2147483648
        a = -32'd2147483648; // Min negative 32-bit signed integer
        b = 32'd1;
        start = 1;
        #10; // Wait for one clock cycle
        start = 0;
        wait (done); // Wait until the done signal is high
        #10;
        $display("Test Case 6: a = -2147483648, b = 1, product = %d (Expected: -2147483648)", product);

        // Finish simulation
        $finish;
    end
endmodule
