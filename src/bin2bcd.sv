module bin2bcd (
    input [7:0] bin,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    integer i;
    reg [11:0] bcd_reg; // {hundreds, tens, ones}
    reg [7:0] bin_temp;

    always @(*) begin
        bcd_reg = 12'b0;
        bin_temp = bin;
        for (i = 0; i < 8; i = i + 1) begin
            // 左移：将bcd_reg左移1位，bin_temp最高位移入bcd_reg[0]
            bcd_reg = {bcd_reg[10:0], bin_temp[7]};
            bin_temp = bin_temp << 1;
            
            // 调整：若BCD组≥5则加3（最后一次不移位，无需调整）
            if (i < 7) begin
                if (bcd_reg[3:0]  >= 4'd5) bcd_reg[3:0]  = bcd_reg[3:0]  + 4'd3;
                if (bcd_reg[7:4]  >= 4'd5) bcd_reg[7:4]  = bcd_reg[7:4]  + 4'd3;
                if (bcd_reg[11:8] >= 4'd5) bcd_reg[11:8] = bcd_reg[11:8] + 4'd3;
            end
        end
        // 输出分解
        hundreds = bcd_reg[11:8];
        tens     = bcd_reg[7:4];
        ones     = bcd_reg[3:0];
    end
endmodule
