/////////////////////////////////////////////////////////////
// Created by: Synopsys Design Compiler(R)
// Version   : U-2022.12-SP7
// Date      : Wed Dec  3 22:08:54 2025
/////////////////////////////////////////////////////////////


module rptr_empty ( rempty, raddr, rptr, rwptr2, rinc, rclk, rrst_n );
  output [3:0] raddr;
  output [4:0] rptr;
  input [4:0] rwptr2;
  input rinc, rclk, rrst_n;
  output rempty;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11;
  wire   [4:0] rgnext;
  wire   [3:0] rbin;
  wire   [3:0] rbnext;
  assign raddr[2] = rptr[2];
  assign raddr[1] = rptr[1];
  assign raddr[0] = rptr[0];

  \**SEQGEN**  raddrmsb_reg ( .clear(N0), .preset(1'b0), .next_state(N1), 
        .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(raddr[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_reg[4]  ( .clear(N0), .preset(1'b0), .next_state(
        rgnext[4]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_reg[3]  ( .clear(N0), .preset(1'b0), .next_state(
        rgnext[3]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_reg[2]  ( .clear(N0), .preset(1'b0), .next_state(
        rgnext[2]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_reg[1]  ( .clear(N0), .preset(1'b0), .next_state(
        rgnext[1]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_reg[0]  ( .clear(N0), .preset(1'b0), .next_state(
        rgnext[0]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  EQ_UNS_OP eq_50 ( .A(rgnext), .B(rwptr2), .Z(N4) );
  \**SEQGEN**  rempty_reg ( .clear(1'b0), .preset(N0), .next_state(N4), 
        .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(rempty), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  ADD_UNS_OP add_34_aco ( .A({rptr[4], rbin}), .B(N5), .Z({rgnext[4], rbnext})
         );
  MULT_UNS_OP mult_add_34_aco ( .A(rinc), .B(N2), .Z(N5) );
  GTECH_NOT I_0 ( .A(rrst_n), .Z(N0) );
  GTECH_XOR2 C60 ( .A(rgnext[4]), .B(rgnext[3]), .Z(N1) );
  GTECH_XOR2 C61 ( .A(N8), .B(rptr[0]), .Z(rbin[0]) );
  GTECH_XOR2 C62 ( .A(N7), .B(rptr[1]), .Z(N8) );
  GTECH_XOR2 C63 ( .A(N6), .B(rptr[2]), .Z(N7) );
  GTECH_XOR2 C64 ( .A(rptr[4]), .B(rptr[3]), .Z(N6) );
  GTECH_XOR2 C65 ( .A(N10), .B(rptr[1]), .Z(rbin[1]) );
  GTECH_XOR2 C66 ( .A(N9), .B(rptr[2]), .Z(N10) );
  GTECH_XOR2 C67 ( .A(rptr[4]), .B(rptr[3]), .Z(N9) );
  GTECH_XOR2 C68 ( .A(N11), .B(rptr[2]), .Z(rbin[2]) );
  GTECH_XOR2 C69 ( .A(rptr[4]), .B(rptr[3]), .Z(N11) );
  GTECH_XOR2 C70 ( .A(rptr[4]), .B(rptr[3]), .Z(rbin[3]) );
  GTECH_NOT I_1 ( .A(rempty), .Z(N2) );
  GTECH_BUF B_0 ( .A(N2), .Z(N3) );
  GTECH_XOR2 C76 ( .A(rgnext[4]), .B(rbnext[3]), .Z(rgnext[3]) );
  GTECH_XOR2 C77 ( .A(rbnext[3]), .B(rbnext[2]), .Z(rgnext[2]) );
  GTECH_XOR2 C78 ( .A(rbnext[2]), .B(rbnext[1]), .Z(rgnext[1]) );
  GTECH_XOR2 C79 ( .A(rbnext[1]), .B(rbnext[0]), .Z(rgnext[0]) );
  GTECH_BUF B_1 ( .A(rrst_n) );
  GTECH_OR2 C82 ( .A(N3), .B(rempty) );
endmodule

