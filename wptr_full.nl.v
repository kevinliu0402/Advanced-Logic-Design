/////////////////////////////////////////////////////////////
// Created by: Synopsys Design Compiler(R)
// Version   : U-2022.12-SP7
// Date      : Wed Dec  3 22:07:48 2025
/////////////////////////////////////////////////////////////


module wptr_full ( wfull, waddr, wptr, wrptr2, winc, wclk, wrst_n );
  output [3:0] waddr;
  output [4:0] wptr;
  input [4:0] wrptr2;
  input winc, wclk, wrst_n;
  output wfull;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18;
  wire   [4:0] wgnext;
  wire   [3:0] wbin;
  wire   [3:0] wbnext;
  assign waddr[2] = wptr[2];
  assign waddr[1] = wptr[1];
  assign waddr[0] = wptr[0];

  \**SEQGEN**  waddrmsb_reg ( .clear(N1), .preset(1'b0), .next_state(N2), 
        .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(waddr[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \wptr_reg[4]  ( .clear(N1), .preset(1'b0), .next_state(
        wgnext[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        wptr[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \wptr_reg[3]  ( .clear(N1), .preset(1'b0), .next_state(
        wgnext[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        wptr[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \wptr_reg[2]  ( .clear(N1), .preset(1'b0), .next_state(
        wgnext[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        wptr[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \wptr_reg[1]  ( .clear(N1), .preset(1'b0), .next_state(
        wgnext[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        wptr[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \wptr_reg[0]  ( .clear(N1), .preset(1'b0), .next_state(
        wgnext[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        wptr[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  GTECH_XOR2 C51 ( .A(wgnext[4]), .B(wrptr2[4]), .Z(N5) );
  GTECH_XOR2 C54 ( .A(N6), .B(N7), .Z(N0) );
  GTECH_NOT I_0 ( .A(N0), .Z(N8) );
  EQ_UNS_OP eq_51_2 ( .A(wgnext[2:0]), .B(wrptr2[2:0]), .Z(N9) );
  \**SEQGEN**  wfull_reg ( .clear(N1), .preset(1'b0), .next_state(N10), 
        .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(wfull), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  ADD_UNS_OP add_36_aco ( .A({wptr[4], wbin}), .B(N11), .Z({wgnext[4], wbnext}) );
  MULT_UNS_OP mult_add_36_aco ( .A(winc), .B(N3), .Z(N11) );
  GTECH_NOT I_1 ( .A(wrst_n), .Z(N1) );
  GTECH_XOR2 C65 ( .A(wgnext[4]), .B(wgnext[3]), .Z(N2) );
  GTECH_XOR2 C66 ( .A(N14), .B(wptr[0]), .Z(wbin[0]) );
  GTECH_XOR2 C67 ( .A(N13), .B(wptr[1]), .Z(N14) );
  GTECH_XOR2 C68 ( .A(N12), .B(wptr[2]), .Z(N13) );
  GTECH_XOR2 C69 ( .A(wptr[4]), .B(wptr[3]), .Z(N12) );
  GTECH_XOR2 C70 ( .A(N16), .B(wptr[1]), .Z(wbin[1]) );
  GTECH_XOR2 C71 ( .A(N15), .B(wptr[2]), .Z(N16) );
  GTECH_XOR2 C72 ( .A(wptr[4]), .B(wptr[3]), .Z(N15) );
  GTECH_XOR2 C73 ( .A(N17), .B(wptr[2]), .Z(wbin[2]) );
  GTECH_XOR2 C74 ( .A(wptr[4]), .B(wptr[3]), .Z(N17) );
  GTECH_XOR2 C75 ( .A(wptr[4]), .B(wptr[3]), .Z(wbin[3]) );
  GTECH_NOT I_2 ( .A(wfull), .Z(N3) );
  GTECH_BUF B_0 ( .A(N3), .Z(N4) );
  GTECH_XOR2 C81 ( .A(wgnext[4]), .B(wbnext[3]), .Z(wgnext[3]) );
  GTECH_XOR2 C82 ( .A(wbnext[3]), .B(wbnext[2]), .Z(wgnext[2]) );
  GTECH_XOR2 C83 ( .A(wbnext[2]), .B(wbnext[1]), .Z(wgnext[1]) );
  GTECH_XOR2 C84 ( .A(wbnext[1]), .B(wbnext[0]), .Z(wgnext[0]) );
  GTECH_BUF B_1 ( .A(wrst_n) );
  GTECH_XOR2 C87 ( .A(wgnext[4]), .B(wgnext[3]), .Z(N6) );
  GTECH_XOR2 C88 ( .A(wrptr2[4]), .B(wrptr2[3]), .Z(N7) );
  GTECH_AND2 C89 ( .A(N18), .B(N9), .Z(N10) );
  GTECH_AND2 C90 ( .A(N5), .B(N8), .Z(N18) );
  GTECH_OR2 C91 ( .A(N4), .B(wfull) );
endmodule

