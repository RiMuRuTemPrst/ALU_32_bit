module signed_number_32_bit_multiplier (
    input clk,                  // Clock
    input rst,                  // Reset
    input start,                // Tín hiệu bắt đầu phép nhân
    input signed [31:0] a,      // Số thứ nhất
    input signed [31:0] b,      // Số thứ hai
    output reg signed [63:0] product, // Kết quả phép nhân
    output reg done             // Tín hiệu hoàn thành
);

    // Thanh ghi tạm thời
    reg signed [31:0] multiplicand;
    reg signed [31:0] multiplier;
    reg signed [63:0] temp_product;
    reg sign;                   // Dấu của kết quả
    reg [5:0] count;            // Counter (tối đa 32 bước)
    reg working;                // Trạng thái đang thực hiện phép nhân

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset toàn bộ các thanh ghi
            product <= 0;
            temp_product <= 0;
            multiplicand <= 0;
            multiplier <= 0;
            sign <= 0;
            count <= 0;
            done <= 0;
            working <= 0;
        end else if (start && !working) begin
            // Khởi tạo giá trị khi bắt đầu phép nhân
            working <= 1;
            done <= 0;
            count <= 0;
            temp_product <= 0;
            multiplicand <= a[31] ? -a : a; // Chuyển đổi số âm
            multiplier <= b[31] ? -b : b;  // Chuyển đổi số âm
            sign <= a[31] ^ b[31];         // Xác định dấu của kết quả
        end else if (working) begin
            if (count < 32) begin
                // Thực hiện phép dịch bit và cộng dồn từng bước
                if (multiplier[count]) begin
                    temp_product <= temp_product + (multiplicand << count);
                end
                count <= count + 1;
            end else begin
                // Kết thúc phép nhân
                product <= sign ? -temp_product : temp_product; // Gán kết quả với dấu
                done <= 1;
                working <= 0;
            end
        end
    end

endmodule
