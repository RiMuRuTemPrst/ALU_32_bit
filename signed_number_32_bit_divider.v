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

    // Thực hiện phép chia từng bước một
    for (i = 0; i < 32; i = i + 1) begin
        dividend_extended = dividend_extended << 1;
        if (dividend_extended[63:32] >= temp_divisor) begin
            dividend_extended[63:32] = dividend_extended[63:32] - temp_divisor;
            quotient_reg = quotient_reg << 1;
            quotient_reg[0] = 1;
        end else begin
            quotient_reg = quotient_reg << 1;
        end
    end

    // Gán giá trị thương và số dư
    quotient = sign ? -quotient_reg : quotient_reg;
    remainder = dividend_extended[31:0];
end
endmodule
