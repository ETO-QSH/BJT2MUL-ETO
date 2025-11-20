// 8-bit Synchronous Binary Up Counter with carry_out
// Designed to directly map to Multisim D_FF components
// Uses explicit D_FF instances (like in Multisim)
module counter_8bit_sync_gate_with_carry (
    input      clk,        // Global clock
    input      rst,        // Async reset (active high)
    output [7:0]  count,    // Count output
    output        carry_out // Carry out: high when count == 8'hFF
);

    // Internal wires for D_FF connections
    wire [7:0] D;
    wire [7:0] Q;
    wire [7:0] QN;
    wire [7:0] carry;

    // Assign count
    assign count = Q;

    // -------------------------------
    // Carry Chain: carry[i] = carry[i-1] & Q[i-1]
    // -------------------------------
    assign carry[0] = 1'b1;
    assign carry[1] = carry[0] & Q[0];
    assign carry[2] = carry[1] & Q[1];
    assign carry[3] = carry[2] & Q[2];
    assign carry[4] = carry[3] & Q[3];
    assign carry[5] = carry[4] & Q[4];
    assign carry[6] = carry[5] & Q[5];
    assign carry[7] = carry[6] & Q[6];

    // -------------------------------
    // D[i] = Q[i] ^ carry[i]
    // We implement XOR using: a ^ b = (a & ~b) | (~a & b)
    // But simpler: use assign D[i] = Q[i] ^ carry[i]
    // (In Multisim, you'd use XOR gate or logic)
    // -------------------------------
    assign D[0] = Q[0] ^ carry[0];
    assign D[1] = Q[1] ^ carry[1];
    assign D[2] = Q[2] ^ carry[2];
    assign D[3] = Q[3] ^ carry[3];
    assign D[4] = Q[4] ^ carry[4];
    assign D[5] = Q[5] ^ carry[5];
    assign D[6] = Q[6] ^ carry[6];
    assign D[7] = Q[7] ^ carry[7];

    // -------------------------------
    // carry_out = 1 when all Q are 1
    // -------------------------------
    assign carry_out = &Q;  // Q[0] & Q[1] & ... & Q[7]

    // -------------------------------
    // Instantiate D_FF (Multisim style)
    // Each D_FF has: D, CLK, R, S, Q, QN
    // -------------------------------
    D_FF ff0 (
        .D(D[0]),
        .CLK(clk),
        .R(rst),
        .S(1'b0),      // Not used, tie to 0
        .Q(Q[0]),
        .QN(QN[0])
    );

    D_FF ff1 (
        .D(D[1]),
        .CLK(clk),
        .R(rst),
        .S(1'b0),
        .Q(Q[1]),
        .QN(QN[1])
    );

    D_FF ff2 (
        .D(D[2]),
        .CLK(clk),
        .R(rst),
        .S(1'b0),
        .Q(Q[2]),
        .QN(QN[2])
    );

    D_FF ff3 (
        .D(D[3]),
        .CLK(clk),
        .R(rst),
        .S(1'b0),
        .Q(Q[3]),
        .QN(QN[3])
    );

    D_FF ff4 (
        .D(D[4]),
        .CLK(clk),
        .R(rst),
        .S(1'b0),
        .Q(Q[4]),
        .QN(QN[4])
    );

    D_FF ff5 (
        .D(D[5]),
        .CLK(clk),
        .R(rst),
        .S(1'b0),
        .Q(Q[5]),
        .QN(QN[5])
    );

    D_FF ff6 (
        .D(D[6]),
        .CLK(clk),
        .R(rst),
        .S(1'b0),
        .Q(Q[6]),
        .QN(QN[6])
    );

    D_FF ff7 (
        .D(D[7]),
        .CLK(clk),
        .R(rst),
        .S(1'b0),      // S not used
        .Q(Q[7]),
        .QN(QN[7])
    );

endmodule


// --------------------------------------------------------
// D_FF Model (for simulation only)
// This models the Multisim D_FF component
// In real simulation, you may not need to define it
// But for standalone Verilog sim, we provide behavioral model
// --------------------------------------------------------
module D_FF (
    input      D,
    input      CLK,
    input      R,   // Async reset, active high
    input      S,   // Async set,  active high
    output reg Q,
    output     QN
);

    assign QN = ~Q;

    always @(posedge CLK or posedge R or posedge S) begin
        if (R)
            Q <= 1'b0;
        else if (S)
            Q <= 1'b1;
        else
            Q <= D;
    end

endmodule
