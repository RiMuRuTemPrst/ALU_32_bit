`timescale 1ns / 1ps

module tb_ALU_32_bit;

    // Parameters
    parameter N = 32;

    // Inputs
    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    reg [3:0] opcode;

    // Outputs
    wire signed [N-1:0] result;
    wire signed [N-1:0] remainder;
    wire carry_out;
    wire zero;
    wire overflow;

    // Instantiate the ALU
    ALU_32_bit #(N) uut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .remainder(remainder),
        .carry_out(carry_out),
        .zero(zero),
        .overflow(overflow)
    );

    // Task to print results
    task print_results;
        input [3:0] opcode;
        begin
            $display("Opcode: %b, a: %d, b: %d, Result: %b, Remainder: %b,Zero: %b , Overflow: %b,Carry Out: %b ", 
                opcode, a, b, result, remainder, zero, overflow, carry_out);
        end
    endtask

    initial begin
        // Test case variables

        // Initialize inputs
        a = 2147483647;
      // a= 3000000000;
        b = 0;
        opcode = 0;

        // Loop through all opcodes
        for (opcode = 4'b0000; opcode <= 4'b1001; opcode = opcode + 1) 
        begin 
                    #10;
                    // Print results
                    print_results(opcode);
        end
        
        

        // Finish simulation
        $finish;
    end

endmodule
