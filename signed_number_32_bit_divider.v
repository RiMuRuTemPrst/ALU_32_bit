module signed_number_32_bit_divider (
    input signed [31:0] dividend,  // Số bị chia
    input signed [31:0] divisor,   // Số chia
    output reg signed [31:0] quotient,  // Thương
    output reg signed [31:0] remainder  // Số dư
);

    reg signed [63:0] dividend_extended;
    reg signed [31:0] quotient_reg;
    reg signed [31:0] remainder_reg;
    reg signed [31:0] temp_dividend, temp_divisor;
    reg sign;

    integer i;

    always @(*) begin
        // Khởi tạo
        temp_dividend = dividend;
        temp_divisor = divisor;
        quotient_reg = 0;
        remainder_reg = 0;
        sign = dividend[31] ^ divisor[31]; // Xác định dấu của kết quả

        // Chuyển đổi số bị chia và số chia sang dạng bù 2 nếu chúng là số âm  
        if (dividend[31] == 1) temp_dividend = -dividend;
        if (divisor[31] == 1) temp_divisor = -divisor;

        // Mở rộng số bị chia để thực hiện phép trừ dần
        dividend_extended = {32'b0, temp_dividend};

        // Thực hiện phép chia bằng dịch bit và trừ dần
        for (i = 31; i >= 0; i = i - 1) begin
            remainder_reg = {remainder_reg[30:0], dividend_extended[63]};
            dividend_extended = dividend_extended << 1;

            if (remainder_reg >= temp_divisor) begin
                remainder_reg = remainder_reg - temp_divisor;
                quotient_reg = quotient_reg | (1 << i);
            end
        end

        // Chuyển đổi lại kết quả về dạng bù 2 nếu cần
        if (sign == 1) quotient_reg = -quotient_reg;

        // Gán giá trị cho output
        quotient = quotient_reg;
        remainder = dividend[31] ? -remainder_reg : remainder_reg;
    end

endmodule
