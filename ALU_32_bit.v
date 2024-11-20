module ALU_32_bit #(parameter N = 32) (
    input clk,
    input rst_n,
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    input wire [3:0] opcode,

    output reg signed [N-1:0] result,
    output reg signed [N-1:0] remainder,
    output reg carry_out,
    output reg zero,
    output reg overflow,
    output reg done
);

    // Các tín hiệu nội bộ
    reg signed [2*N-1:0] result_reg;
    reg signed [N-1:0] remainder_reg;


    reg start_multiplier, start_divider;
    wire multiplier_done, divider_done;

    wire signed [N-1:0] quotient;
    wire signed [N-1:0] remainder_wire;
    wire signed [2*N-1:0] product;
    wire signed [N:0] sum;
    wire signed [N:0] diff;

    reg  [3:0] state;     

    // Các trạng thái của state machine
    localparam and_mode     = 4'b0000;
    localparam or_mode      = 4'b0001;
    localparam xor_mode     = 4'b0010;
    localparam not_mode     = 4'b0011;
    localparam neg_A_mode   = 4'b0100;
    localparam neg_B_mode   = 4'b0101;
    localparam adder_mode   = 4'b0110;
    localparam sub_mode     = 4'b0111;
    localparam multi_mode   = 4'b1000;
    localparam div_mode     = 4'b1001;


    // Mode Option
    always @(opcode or a or b)
    begin
        case (opcode)
            and_mode: 
            begin
                result_reg = a & b;
                remainder_reg = 0;
            end      
            or_mode:
            begin
                result_reg = a | b;
                remainder_reg = 0;
            end
            xor_mode:
            begin
                result_reg = a ^ b;
                remainder_reg = 0;
            end
            not_mode:
            begin
                result_reg = ~a;
                remainder_reg = 0;
            end
            neg_A_mode:
            begin
                result_reg = -a;
                remainder_reg = 0;
            end
            neg_B_mode:
            begin
                result_reg = -b;
                remainder_reg = 0;
            end
            adder_mode:
            begin
                result_reg = sum;
                remainder_reg = 0;
                carry_out = sum[N];
            end
            sub_mode:
            begin
                carry_out = diff[N];
                result_reg = diff;
                remainder_reg = 0;
            end
            multi_mode:
            begin
                state = multi_mode;
            end
            div_mode:
            begin
                state = div_mode;
            end
            default: 
            begin
                result_reg = 0;
                remainder_reg = 0;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
    begin
        result <= 0;
        remainder <= 0;
        carry_out <= 0;
        zero <= 0;
        overflow <= 0;
        done <= 0;
        start_multiplier <= 0;
        start_divider <= 0;
    end
    else
    begin
        case (state)
            multi_mode:
            begin
                if (!start_multiplier && !multiplier_done)
                begin
                    start_multiplier <= 1; // Bắt đầu phép nhân
                    done <= 0; // Đang xử lý, chưa hoàn thành
                end
                else if (multiplier_done)
                begin
                    start_multiplier <= 0; // Dừng phép nhân
                    result_reg <= product[2*N - 1 : 0]; // Lấy phần kết quả
                    remainder_reg <= 0; // Phép nhân không có dư
                    done <= 1; // Phép tính hoàn thành
                end
            end

            div_mode:
            begin
                if (!start_divider && !divider_done)
                begin
                    start_divider <= 1; // Bắt đầu phép chia
                    done <= 0; // Đang xử lý, chưa hoàn thành
                end
                else if (divider_done)
                begin
                    start_divider <= 0; // Dừng phép chia
                    result_reg <= quotient; // Lấy thương
                    remainder_reg <= remainder_wire; // Lấy dư
                    done <= 1; // Phép tính hoàn thành
                end
            end

            default:
            begin
                start_multiplier <= 0;
                start_divider <= 0;
                done <= 1;
            end
        endcase
    end
end
    // Assign Output flat
    always @(result_reg)
    begin
        if (done == 1)
        begin
            result = result_reg [31:0];
            remainder = remainder_reg;
            if (state == div_mode)
            begin
                if (b == 0)
                begin
                    overflow = 1;
                end
                else overflow = 0;
            end
            else if (state == multi_mode)
            begin
                overflow = ((product[2*N - 1 : N] != 0)||((a[N-1]== b[N-1]) && (result_reg[2*N -1] != a[N-1])));
            end
            else 
            begin
                overflow = (a[N-1] == b[N-1]) && (result_reg[N-1] != a[N-1]);
            end
        end
        else if (done == 0 && (opcode != multi_mode && opcode != div_mode))
        begin
            overflow = 0;
        end
        //Assign zero flag
        if (result_reg == 0) begin zero = 1; end else begin zero = 0; end 

    end

    // Kết nối các module con
    signed_number_32_bit_adder adder(.A(a), .B(b), .sum(sum));
    signed_number_32_bit_subtractor subtractor(.A(a), .B(b), .diff(diff));
    signed_number_32_bit_multiplier multiplier(
        .clk(clk),
        .rst(rst_n),
        .start(start_multiplier),
        .a(a),
        .b(b),
        .product(product),
        .done(multiplier_done)
    );
    signed_number_32_bit_divider divider(
        .clk(clk),
        .rst_n(rst_n),
        .start(start_divider),
        .dividend(a),
        .divisor(b),
        .quotient(quotient),
        .remainder(remainder_wire),
        .done(divider_done)
    );

endmodule
