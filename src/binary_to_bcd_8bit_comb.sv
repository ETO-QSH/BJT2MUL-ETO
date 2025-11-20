module binary_to_bcd_8bit_comb (
    input      [7:0]  binary,
    output     [11:0] bcd_result
);

    // 定义每一级的 20 位寄存器：[19:8] BCD, [7:0] binary
    wire [19:0] level0, level1, level2, level3, level4, level5, level6, level7, level8;

    // Level 0: 初始值 = {12'd0, binary}
    assign level0 = {12'd0, binary};

    // 生成 8 级迭代
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage
            wire [19:0] in_reg = (i == 0) ? level0 :
                               (i == 1) ? level1 :
                               (i == 2) ? level2 :
                               (i == 3) ? level3 :
                               (i == 4) ? level4 :
                               (i == 5) ? level5 :
                               (i == 6) ? level6 :
                               (i == 7) ? level7 : 20'd0;

            wire [3:0] units_in    = in_reg[11:8];
            wire [3:0] tens_in     = in_reg[15:12];
            wire [3:0] hundreds_in = in_reg[19:16];

            wire [3:0] units_corr;
            wire [3:0] tens_corr;
            wire [3:0] hundreds_corr;

            // 实例化校正模块
            bcd_digit_correct u_units (
                .digit_in (units_in),
                .digit_out (units_corr)
            );

            bcd_digit_correct u_tens (
                .digit_in (tens_in),
                .digit_out (tens_corr)
            );

            bcd_digit_correct u_hunds (
                .digit_in (hundreds_in),
                .digit_out (hundreds_corr)
            );

            // 构建校正后的 BCD 部分
            wire [19:8] bcd_corr = {hundreds_corr, tens_corr, units_corr};

            // 整体左移：{bcd_corr, in_reg[7:0]} << 1
            // 注意：in_reg[7:0] 是剩余二进制位
            wire [19:0] corrected_reg = {bcd_corr, in_reg[7:0]};

            // 左移 1 位
            wire [19:0] shifted = corrected_reg << 1;

            // 输出到下一级
            case (i)
                0: assign level1 = shifted;
                1: assign level2 = shifted;
                2: assign level3 = shifted;
                3: assign level4 = shifted;
                4: assign level5 = shifted;
                5: assign level6 = shifted;
                6: assign level7 = shifted;
                7: assign level8 = shifted;
            endcase
        end
    endgenerate

    // 最终结果：level8 的高 12 位
    assign bcd_result = level8[19:8];

endmodule
