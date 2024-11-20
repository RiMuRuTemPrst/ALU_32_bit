// Testbench sửa lỗi mất Test Case đầu tiên
`timescale 1ns / 1ps

module tb_signed_number_32_bit_divider;

    // Inputs
    reg clk;
    reg rst_n;
    reg start;
    reg signed [31:0] dividend;
    reg signed [31:0] divisor;

    // Outputs
    wire signed [31:0] quotient;
    wire signed [31:0] remainder;
    wire done;

    // Instantiate the module
    signed_number_32_bit_divider uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period: 10 ns
    end

    // Test sequence
    initial begin
    rst_n = 0;
    start = 0;
    dividend = 0;
    divisor = 0;

    // Reset module
    #50;
    rst_n = 1;

    // Test Case 1: 50 / 3
    #10;
    dividend = 50;
    divisor = 3;
    start = 1;
    #10;
    start = 0;
    wait (done);
    $display("Test Case 1: 50 / 3");
    $display("Quotient: %d, Remainder: %d", quotient, remainder);

    // Test Case 2: -50 / 3
    #10;
    dividend = -50;
    divisor = 3;
    start = 1;
    #10;
    start = 0;
    wait (done);
    $display("Test Case 2: -50 / 3");
    $display("Quotient: %d, Remainder: %d", quotient, remainder);

    // Test Case 3: 50 / -3
    #10;
    dividend = 50;
    divisor = -3;
    start = 1;
    #10;
    start = 0;
    wait (done);
    $display("Test Case 3: 50 / -3");
    $display("Quotient: %d, Remainder: %d", quotient, remainder);

    // Test Case 4: -50 / -3
    #10;
    dividend = -50;
    divisor = -3;
    start = 1;
    #10;
    start = 0;
    wait (done);
    $display("Test Case 4: -50 / -3");
    $display("Quotient: %d, Remainder: %d", quotient, remainder);

    // Test Case 5: Division by zero
    #10;
    dividend = 50;
    divisor = 0;
    start = 1;
    #10;
    start = 0;
    wait (done);
    $display("Test Case 5: 50 / 0");
    $display("Quotient: %d, Remainder: %d", quotient, remainder);

    $finish;
end

endmodule
