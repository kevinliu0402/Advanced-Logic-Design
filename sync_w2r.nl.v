/////////////////////////////////////////////////////////////
// Created by: Synopsys Design Compiler(R)
// Version   : U-2022.12-SP7
// Date      : Wed Dec  3 22:10:17 2025
/////////////////////////////////////////////////////////////


module sync_w2r ( rptr_sync, wptr, rclk, rrst_n );
  output [4:0] rptr_sync;
  input [4:0] wptr;
  input rclk, rrst_n;
  wire   N0;
  wire   [4:0] sync1;

  \**SEQGEN**  \sync1_reg[4]  ( .clear(N0), .preset(1'b0), .next_state(wptr[4]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(sync1[4]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \sync1_reg[3]  ( .clear(N0), .preset(1'b0), .next_state(wptr[3]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(sync1[3]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \sync1_reg[2]  ( .clear(N0), .preset(1'b0), .next_state(wptr[2]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(sync1[2]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \sync1_reg[1]  ( .clear(N0), .preset(1'b0), .next_state(wptr[1]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(sync1[1]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \sync1_reg[0]  ( .clear(N0), .preset(1'b0), .next_state(wptr[0]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(sync1[0]), 
        .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(1'b0), 
        .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_sync_reg[4]  ( .clear(N0), .preset(1'b0), .next_state(
        sync1[4]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr_sync[4]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_sync_reg[3]  ( .clear(N0), .preset(1'b0), .next_state(
        sync1[3]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr_sync[3]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_sync_reg[2]  ( .clear(N0), .preset(1'b0), .next_state(
        sync1[2]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr_sync[2]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_sync_reg[1]  ( .clear(N0), .preset(1'b0), .next_state(
        sync1[1]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr_sync[1]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  \**SEQGEN**  \rptr_sync_reg[0]  ( .clear(N0), .preset(1'b0), .next_state(
        sync1[0]), .clocked_on(rclk), .data_in(1'b0), .enable(1'b0), .Q(
        rptr_sync[0]), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(1'b1) );
  GTECH_NOT I_0 ( .A(rrst_n), .Z(N0) );
endmodule

