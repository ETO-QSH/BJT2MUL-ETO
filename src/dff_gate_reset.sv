// Gate-level D flip-flop (master-slave) with asynchronous active-high reset (RST)
// Rising-edge triggered (master enabled when CLK=0, slave enabled when CLK=1)
// Uses only two-input gates (not, and, or, nor)

module dff_gate_reset (
    input  D,
    input  CLK,
    input  RST, // asynchronous active-high reset: when RST=1, Q <= 0
    output Q,
    output QN
);
    // Internal nets
    wire Dn, CLKn;
    wire sm, rm_int, rm;
    wire qm, qmb;
    wire qm_n;
    wire ss, rs_int, rs;

    // Inverters
    not U1 (Dn, D);
    not U2 (CLKn, CLK);

    // ----- Master latch (transparent when CLK = 0) -----
    and U3 (sm, D, CLKn);        // S_master = D & ~CLK
    and U4 (rm_int, Dn, CLKn);   // R_master_internal = ~D & ~CLK
    or  U5 (rm, rm_int, RST);    // R_master = R_master_internal OR RST (async reset)
    nor U6 (qm, rm, qmb);        // master SR latch
    nor U7 (qmb, sm, qm);

    // ----- Slave latch (transparent when CLK = 1) -----
    not U8 (qm_n, qm);
    and U9  (ss, qm, CLK);       // S_slave = qm & CLK
    and U10 (rs_int, qm_n, CLK); // R_slave_internal = ~qm & CLK
    or  U11 (rs, rs_int, RST);   // R_slave = R_slave_internal OR RST (async reset)
    nor U12 (Q, rs, QN);         // slave SR latch -> outputs
    nor U13 (QN, ss, Q);

endmodule
