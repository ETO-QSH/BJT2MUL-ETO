// Hexadecimal 7-segment display driver
// Minimal at 30 NANDs
//
// By Kim Øyhus 2018 (c) into (CC BY-SA 3.0)
// This work is licensed under the Creative Commons Attribution 3.0
// Unported License. To view a copy of this license, visit
// https://creativecommons.org/licenses/by-sa/3.0/
//
// This is my entry to win this Programming Puzzle & Code Golf
// at Stack Exchange: 
// https://codegolf.stackexchange.com/questions/37648/drive-a-hexadecimal-7-segment-display-using-nand-logic-gates
//
// I am quite sure there are no simpler solutions to this problem,
// except perhaps by changing the symbols on the display,
// but that would be another and different problem.
//
// Since this is actually something useful to do, for instance when
// programming an FPGA to show output, I provide this Verilog code.
//
// As for the minimalism: Of course it was tricky to make.
// It is not comprehensible, since a 7-segment display is
// just a fairly random way of showing numbers, resulting
// in a circuit that is fairly random too.
// And as is typical for these minimal circuits, its logical depth
// is somewhat higher than for close solutions. I guess this is because
// serial is simpler than parallel.
//
// 4 bits of input "in_00?", and 7 bits of output,
// one bit per LED in the segment.
//   A
// F   B
//   G
// E   C
//   D

module display7 ( in_000, in_001, in_002, in_003,  G, F, E, D, C, B, A );
  input in_000, in_001, in_002, in_003;
  output G, F, E, D, C, B, A;
  wire wir000, wir001, wir002, wir003, wir004, wir005, wir006, wir007, wir008, wir009, wir010, wir011, wir012, wir013, wir014, wir015, wir016, wir017, wir018, wir019, wir020, wir021, wir022 ;

  nand gate000 ( wir000, in_000, in_002 );
  nand gate001 ( wir001, in_000, in_000 );
  nand gate002 ( wir002, wir000, in_001 );
  nand gate003 ( wir003, in_001, wir002 );
  nand gate004 ( wir004, wir000, wir002 );
  nand gate005 ( wir005, in_002, wir003 );
  nand gate006 ( wir006, in_003, wir001 );
  nand gate007 ( wir007, wir006, wir004 );
  nand gate008 ( wir008, in_003, wir005 );
  nand gate009 ( wir009, wir005, wir008 );
  nand gate010 ( wir010, in_003, wir008 );
  nand gate011 ( wir011, wir010, wir009 );
  nand gate012 ( wir012, wir010, wir007 );
  nand gate013 ( wir013, wir001, wir011 );
  nand gate014 ( wir014, wir003, wir004 );
  nand gate015 (      G, wir011, wir014 );
  nand gate016 ( wir015, in_003, wir014 );
  nand gate017 ( wir016, wir015, wir013 );
  nand gate018 (      C, wir016, wir012 );
  nand gate019 ( wir017, wir016, wir007 );
  nand gate020 ( wir018, wir003, wir012 );
  nand gate021 ( wir019, wir017, in_003 );
  nand gate022 (      F, wir011, wir017 );
  nand gate023 (      D, wir018, wir017 );
  nand gate024 (      B, wir012,      F );
  nand gate025 ( wir020, wir004, wir018 );
  nand gate026 ( wir021, wir001,      D );
  nand gate027 (      E, wir019, wir021 );
  nand gate028 ( wir022,      D, wir019 );
  nand gate029 (      A, wir020, wir022 );
  
endmodule
