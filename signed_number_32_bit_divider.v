module signed_number_32_bit_divider (
    input clk,
    input rst_n,
    input start,
    input signed [31:0] dividend,
    input signed [31:0] divisor,
    output reg signed [31:0] quotient,
    output reg signed [31:0] remainder,
    output reg done
);

    reg [63:0] dividend_extended;    // Mở rộng số bị chia
    reg [31:0] abs_dividend;         // Trị tuyệt đối của số bị chia
    reg [31:0] abs_divisor;          // Trị tuyệt đối của số chia
    reg [31:0] quotient_reg;         // Thương tạm thời
    reg [5:0] bit_count;             // Bộ đếm bit
    reg running;                     // Tín hiệu đang thực thi
    reg sign_quotient;               // Dấu của thương

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            dividend_extended <= 0;
            abs_dividend <= 0;
            abs_divisor <= 0;
            quotient_reg <= 0;
            bit_count <= 0;
            running <= 0;
            sign_quotient <= 0;
        end else if (start && !running) begin
            // Bắt đầu phép chia
            running <= 1;
            done <= 0;
            bit_count <= 0;
            quotient_reg <= 0;

            if (divisor == 0) begin
                // Báo lỗi chia cho 0
                quotient <= 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
                remainder <= 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
                done <= 1;
                running <= 0;
            end else begin
                // Tính trị tuyệt đối
                abs_dividend <= dividend[31] ? -dividend : dividend;
                abs_divisor <= divisor[31] ? -divisor : divisor;
                dividend_extended <= {32'b0, abs_dividend};

                // Xác định dấu của thương
                sign_quotient <= dividend[31] ^ divisor[31];
            end
        end else if (running) begin
            if (bit_count < 32) begin
                // Dịch trái và trừ
                dividend_extended <= dividend_extended << 1;
                if (dividend_extended[63:32] >= abs_divisor) begin
                    dividend_extended[63:32] <= dividend_extended[63:32] - abs_divisor;
                    quotient_reg <= (quotient_reg << 1) | 1;
                end else begin
                    quotient_reg <= quotient_reg << 1;
                end
                bit_count <= bit_count + 1;
            end else begin
                // Kết thúc phép chia
                running <= 0;
                done <= 1;

                // Gán thương
                quotient <= sign_quotient ? -quotient_reg : quotient_reg;

                // Gán số dư (cùng dấu với dividend)
                remainder <= dividend[31] ? -dividend_extended[31:0] : dividend_extended[31:0];
            end
        end
    end
endmodule