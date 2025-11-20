def binary_to_bcd_8bit(binary):
    """
    使用 Double Dabble 算法将 8 位二进制数转换为 3 位 BCD（百位、十位、个位）
    输入: binary (int) 0 ~ 255
    输出: bcd (int) 12 位 BCD 编码，例如 255 -> 0b0010_0101_0101
    同时返回 (hundreds, tens, units) 三元组便于理解
    """
    if not (0 <= binary <= 255):
        raise ValueError("Input must be an 8-bit integer (0-255)")

    # 使用 12 位 BCD 寄存器（3 位 × 4 位），放在高 12 位，低 8 位放原始二进制
    # 总寄存器：[BCD: 12 位][binary: 8 位] → 共 20 位
    reg = (0 << 8) | binary  # 高 12 位为 BCD（初始 0），低 8 位为 binary

    # 进行 8 次迭代（每位二进制）
    for _ in range(8):
        # 检查每个 BCD 4 位组（百位、十位、个位），如果 >=5，则加 3
        # 个位（bits 0-3 of BCD → 位置 8~11 from LSB? 我们用偏移量）
        # 我们把 BCD 放在高 12 位，所以：
        #   个位：bit 8~11
        #   十位：bit 12~15
        #   百位：bit 16~19

        # 提取并处理个位（bit 8~11）
        units = (reg >> 8) & 0xF
        if units >= 5:
            reg += (3 << 8)

        # 提取并处理十位（bit 12~15）
        tens = (reg >> 12) & 0xF
        if tens >= 5:
            reg += (3 << 12)

        # 提取并处理百位（bit 16~19）
        hundreds = (reg >> 16) & 0xF
        if hundreds >= 5:
            reg += (3 << 16)

        # 整体左移 1 位（包括 BCD 和 binary 部分）
        reg <<= 1

    # 左移 8 次后，原始 binary 已全部移出，BCD 在高 12 位
    # 但我们最后多左移了 8 次，所以需要右移 8 位来对齐
    # 实际上：reg 的高 12 位就是结果，低 8 位是空的（或溢出）
    bcd_result = (reg >> 8) & 0xFFF  # 取高 12 位，掩码 0b111111111111

    # 分解 BCD 为三个数字
    units = bcd_result & 0xF
    tens = (bcd_result >> 4) & 0xF
    hundreds = (bcd_result >> 8) & 0xF

    # 验证范围
    decimal = hundreds * 100 + tens * 10 + units
    assert decimal == binary, f"Conversion error: expected {binary}, got {decimal}"

    return {
        'bcd': bcd_result,                    # 整数形式的 BCD（12 位）
        'bcd_bin': f"{bcd_result:012b}",      # 二进制字符串
        'hundreds': hundreds,
        'tens': tens,
        'units': units,
        'decimal': decimal
    }


def bcd_to_binary_8bit(bcd):
    """
    将 12 位 BCD（3 位十进制）转换为 8 位二进制数
    输入: bcd (int) 如 0b0010_0101_0101 表示 255
    输出: 对应的整数（0~255）
    """
    if not (0 <= bcd <= 0x999):  # 最大 BCD 是 999，但我们只接受 0~255
        raise ValueError("BCD value out of valid range (must be <= 999)")

    # 检查每个 4 位是否 <= 9（合法 BCD）
    units = bcd & 0xF
    tens = (bcd >> 4) & 0xF
    hundreds = (bcd >> 8) & 0xF

    if any(d > 9 for d in [units, tens, hundreds]):
        raise ValueError("Invalid BCD: digits must be 0-9")

    decimal = hundreds * 100 + tens * 10 + units

    if decimal > 255:
        raise ValueError("BCD represents value > 255, not 8-bit")

    return decimal


# 测试
test_values = [0, 1, 9, 10, 25, 99, 100, 127, 255]

for val in test_values:
    print(f"\n--- Converting {val} ---")
    result = binary_to_bcd_8bit(val)
    print(f"Binary {val} -> BCD: {result['bcd']}")
    print(f"BCD (binary): {result['bcd_bin']}")
    print(f"Decomposed: {result['hundreds']} {result['tens']} {result['units']} -> {result['decimal']}")

    # 反向转换验证
    binary_back = bcd_to_binary_8bit(result['bcd'])
    print(f"BCD -> Binary: {binary_back} (correct: {binary_back == val})")
