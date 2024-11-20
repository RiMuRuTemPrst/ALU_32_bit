`timescale 1ns / 1ps

module tb_ALU_32_bit;

    // Parameters
    parameter N = 32;

    // Inputs
    reg clk;
    reg rst_n;
    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    reg [3:0] opcode;

    // Outputs
    wire signed [N-1:0] result;
    wire signed [N-1:0] remainder;
    wire carry_out;
    wire zero;
    wire overflow;
    wire done;

    // Instantiate the ALU
    ALU_32_bit #(N) uut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .remainder(remainder),
        .carry_out(carry_out),
        .zero(zero),
        .overflow(overflow),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk; // Clock period = 10ns (100 MHz)

    // Task to print results
    task print_results;
        input [3:0] opcode;
        begin
            $display("Time: %0t | Opcode: %b | a: %b | b: %b | Result: %b | Remainder: %b | Zero: %b | Overflow: %b | Carry Out: %b | Done: %b", 
                $time, opcode, a, b, result, remainder, zero, overflow, carry_out, done);
        end
    endtask

    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        a = 2147483647;
        b = 1;
        opcode = 4'b0000;

        // Apply reset
        #10 rst_n = 1;

        // Loop through all opcodes
        for (opcode = 4'b0000; opcode <= 4'b1001; opcode = opcode + 1) 
        begin
            if (opcode == 4'b1000 || opcode == 4'b1001) begin
                // Wait for 'done' only for multiplication (1000) and division (1001)
                while (!done) begin
                    #10; // Wait for 10ns (or 1 clock cycle)
                end
            end else begin
                // For other opcodes, no need to wait
                #10; // Allow some time for the operation to complete
            end

            // Print results for the current opcode
            print_results(opcode);

            // Wait a bit before switching to the next opcode
            #10;
        end

        // Finish simulation
        $finish;
    end

endmodule
