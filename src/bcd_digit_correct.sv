// Module: bcd_digit_correct
// 功能：如果输入 digit >= 5，则输出 digit + 3；否则输出 digit
// 使用基本门和 4 位加法器实现

module bcd_digit_correct (
    input      [3:0] digit_in,
    output reg [3:0] digit_out
);

    wire ge5;
    wire [3:0] add3_result;

    // 判五逻辑
    assign ge5 = digit_in[3] | (digit_in[2] & (digit_in[1] | digit_in[0]));

    // 4位加法器：digit_in + 3 (即 4'b0011)
    // 我们用全加器链实现加法器（基础门）
    // digit_in + 3 = digit_in + 4'b0011

    // 全加器定义（内联）
    // FA: sum = a ^ b ^ cin, cout = (a&b) | (cin&(a^b))

    // 加法器：digit_in + 3 (3 = 4'b0011)
    wire c1, c2, c3;

    // bit 0: digit_in[0] + 1 + 0
    assign add3_result[0] = digit_in[0] ^ 1'b1 ^ 1'b0;
    assign c1 = (digit_in[0] & 1'b1) | (1'b0 & (digit_in[0] ^ 1'b1));

    // bit 1: digit_in[1] + 1 + c1
    assign add3_result[1] = digit_in[1] ^ 1'b1 ^ c1;
    assign c2 = (digit_in[1] & 1'b1) | (c1 & (digit_in[1] ^ 1'b1));

    // bit 2: digit_in[2] + 0 + c2
    assign add3_result[2] = digit_in[2] ^ 1'b0 ^ c2;
    assign c3 = (digit_in[2] & 1'b0) | (c2 & (digit_in[2] ^ 1'b0));

    // bit 3: digit_in[3] + 0 + c3
    assign add3_result[3] = digit_in[3] ^ 1'b0 ^ c3;
    // carry_out = c3 & digit_in[3]? 不需要 carry

    // 多路选择：ge5 ? add3_result : digit_in
    // 使用门实现 4 位 2:1 MUX
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : mux
            assign digit_out[i] = (ge5 & add3_result[i]) | (~ge5 & digit_in[i]);
        end
    endgenerate

endmodule
