/////////////////////////////////////////////////////////////
// Created by: Synopsys Design Compiler(R)
// Version   : U-2022.12-SP7
// Date      : Wed Dec  3 22:06:57 2025
/////////////////////////////////////////////////////////////


module fifomem ( rdata, wdata, waddr, raddr, wclken, wclk );
  output [7:0] rdata;
  input [7:0] wdata;
  input [3:0] waddr;
  input [3:0] raddr;
  input wclken, wclk;
  wire   N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15,
         N16, N17, N18, N19, N20, N21, N22, N23, N24, N25, N26, N27, N28, N29,
         N30, \mem[0][7] , \mem[0][6] , \mem[0][5] , \mem[0][4] , \mem[0][3] ,
         \mem[0][2] , \mem[0][1] , \mem[0][0] , \mem[1][7] , \mem[1][6] ,
         \mem[1][5] , \mem[1][4] , \mem[1][3] , \mem[1][2] , \mem[1][1] ,
         \mem[1][0] , \mem[2][7] , \mem[2][6] , \mem[2][5] , \mem[2][4] ,
         \mem[2][3] , \mem[2][2] , \mem[2][1] , \mem[2][0] , \mem[3][7] ,
         \mem[3][6] , \mem[3][5] , \mem[3][4] , \mem[3][3] , \mem[3][2] ,
         \mem[3][1] , \mem[3][0] , \mem[4][7] , \mem[4][6] , \mem[4][5] ,
         \mem[4][4] , \mem[4][3] , \mem[4][2] , \mem[4][1] , \mem[4][0] ,
         \mem[5][7] , \mem[5][6] , \mem[5][5] , \mem[5][4] , \mem[5][3] ,
         \mem[5][2] , \mem[5][1] , \mem[5][0] , \mem[6][7] , \mem[6][6] ,
         \mem[6][5] , \mem[6][4] , \mem[6][3] , \mem[6][2] , \mem[6][1] ,
         \mem[6][0] , \mem[7][7] , \mem[7][6] , \mem[7][5] , \mem[7][4] ,
         \mem[7][3] , \mem[7][2] , \mem[7][1] , \mem[7][0] , \mem[8][7] ,
         \mem[8][6] , \mem[8][5] , \mem[8][4] , \mem[8][3] , \mem[8][2] ,
         \mem[8][1] , \mem[8][0] , \mem[9][7] , \mem[9][6] , \mem[9][5] ,
         \mem[9][4] , \mem[9][3] , \mem[9][2] , \mem[9][1] , \mem[9][0] ,
         \mem[10][7] , \mem[10][6] , \mem[10][5] , \mem[10][4] , \mem[10][3] ,
         \mem[10][2] , \mem[10][1] , \mem[10][0] , \mem[11][7] , \mem[11][6] ,
         \mem[11][5] , \mem[11][4] , \mem[11][3] , \mem[11][2] , \mem[11][1] ,
         \mem[11][0] , \mem[12][7] , \mem[12][6] , \mem[12][5] , \mem[12][4] ,
         \mem[12][3] , \mem[12][2] , \mem[12][1] , \mem[12][0] , \mem[13][7] ,
         \mem[13][6] , \mem[13][5] , \mem[13][4] , \mem[13][3] , \mem[13][2] ,
         \mem[13][1] , \mem[13][0] , \mem[14][7] , \mem[14][6] , \mem[14][5] ,
         \mem[14][4] , \mem[14][3] , \mem[14][2] , \mem[14][1] , \mem[14][0] ,
         \mem[15][7] , \mem[15][6] , \mem[15][5] , \mem[15][4] , \mem[15][3] ,
         \mem[15][2] , \mem[15][1] , \mem[15][0] , N31, N32, N33, N34, N35,
         N36, N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49,
         N50, N51, N52, N53, N54;

  \**SEQGEN**  \mem_reg[0][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[0][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N46) );
  \**SEQGEN**  \mem_reg[0][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[0][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N46) );
  \**SEQGEN**  \mem_reg[0][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[0][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N46) );
  \**SEQGEN**  \mem_reg[0][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[0][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N46) );
  \**SEQGEN**  \mem_reg[0][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[0][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N46) );
  \**SEQGEN**  \mem_reg[0][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[0][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N46) );
  \**SEQGEN**  \mem_reg[0][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[0][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N46) );
  \**SEQGEN**  \mem_reg[0][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[0][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N46) );
  \**SEQGEN**  \mem_reg[1][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[1][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N45) );
  \**SEQGEN**  \mem_reg[1][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[1][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N45) );
  \**SEQGEN**  \mem_reg[1][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[1][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N45) );
  \**SEQGEN**  \mem_reg[1][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[1][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N45) );
  \**SEQGEN**  \mem_reg[1][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[1][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N45) );
  \**SEQGEN**  \mem_reg[1][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[1][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N45) );
  \**SEQGEN**  \mem_reg[1][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[1][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N45) );
  \**SEQGEN**  \mem_reg[1][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[1][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N45) );
  \**SEQGEN**  \mem_reg[2][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[2][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N44) );
  \**SEQGEN**  \mem_reg[2][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[2][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N44) );
  \**SEQGEN**  \mem_reg[2][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[2][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N44) );
  \**SEQGEN**  \mem_reg[2][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[2][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N44) );
  \**SEQGEN**  \mem_reg[2][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[2][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N44) );
  \**SEQGEN**  \mem_reg[2][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[2][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N44) );
  \**SEQGEN**  \mem_reg[2][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[2][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N44) );
  \**SEQGEN**  \mem_reg[2][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[2][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N44) );
  \**SEQGEN**  \mem_reg[3][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[3][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N43) );
  \**SEQGEN**  \mem_reg[3][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[3][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N43) );
  \**SEQGEN**  \mem_reg[3][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[3][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N43) );
  \**SEQGEN**  \mem_reg[3][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[3][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N43) );
  \**SEQGEN**  \mem_reg[3][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[3][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N43) );
  \**SEQGEN**  \mem_reg[3][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[3][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N43) );
  \**SEQGEN**  \mem_reg[3][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[3][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N43) );
  \**SEQGEN**  \mem_reg[3][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[3][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N43) );
  \**SEQGEN**  \mem_reg[4][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[4][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N42) );
  \**SEQGEN**  \mem_reg[4][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[4][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N42) );
  \**SEQGEN**  \mem_reg[4][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[4][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N42) );
  \**SEQGEN**  \mem_reg[4][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[4][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N42) );
  \**SEQGEN**  \mem_reg[4][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[4][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N42) );
  \**SEQGEN**  \mem_reg[4][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[4][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N42) );
  \**SEQGEN**  \mem_reg[4][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[4][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N42) );
  \**SEQGEN**  \mem_reg[4][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[4][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N42) );
  \**SEQGEN**  \mem_reg[5][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[5][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N41) );
  \**SEQGEN**  \mem_reg[5][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[5][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N41) );
  \**SEQGEN**  \mem_reg[5][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[5][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N41) );
  \**SEQGEN**  \mem_reg[5][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[5][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N41) );
  \**SEQGEN**  \mem_reg[5][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[5][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N41) );
  \**SEQGEN**  \mem_reg[5][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[5][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N41) );
  \**SEQGEN**  \mem_reg[5][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[5][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N41) );
  \**SEQGEN**  \mem_reg[5][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[5][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N41) );
  \**SEQGEN**  \mem_reg[6][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[6][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N40) );
  \**SEQGEN**  \mem_reg[6][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[6][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N40) );
  \**SEQGEN**  \mem_reg[6][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[6][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N40) );
  \**SEQGEN**  \mem_reg[6][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[6][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N40) );
  \**SEQGEN**  \mem_reg[6][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[6][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N40) );
  \**SEQGEN**  \mem_reg[6][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[6][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N40) );
  \**SEQGEN**  \mem_reg[6][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[6][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N40) );
  \**SEQGEN**  \mem_reg[6][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[6][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N40) );
  \**SEQGEN**  \mem_reg[7][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[7][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N39) );
  \**SEQGEN**  \mem_reg[7][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[7][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N39) );
  \**SEQGEN**  \mem_reg[7][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[7][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N39) );
  \**SEQGEN**  \mem_reg[7][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[7][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N39) );
  \**SEQGEN**  \mem_reg[7][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[7][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N39) );
  \**SEQGEN**  \mem_reg[7][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[7][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N39) );
  \**SEQGEN**  \mem_reg[7][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[7][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N39) );
  \**SEQGEN**  \mem_reg[7][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[7][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N39) );
  \**SEQGEN**  \mem_reg[8][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[8][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N38) );
  \**SEQGEN**  \mem_reg[8][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[8][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N38) );
  \**SEQGEN**  \mem_reg[8][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[8][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N38) );
  \**SEQGEN**  \mem_reg[8][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[8][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N38) );
  \**SEQGEN**  \mem_reg[8][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[8][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N38) );
  \**SEQGEN**  \mem_reg[8][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[8][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N38) );
  \**SEQGEN**  \mem_reg[8][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[8][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N38) );
  \**SEQGEN**  \mem_reg[8][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[8][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N38) );
  \**SEQGEN**  \mem_reg[9][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[9][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N37) );
  \**SEQGEN**  \mem_reg[9][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[9][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N37) );
  \**SEQGEN**  \mem_reg[9][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[9][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N37) );
  \**SEQGEN**  \mem_reg[9][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[9][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N37) );
  \**SEQGEN**  \mem_reg[9][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[9][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N37) );
  \**SEQGEN**  \mem_reg[9][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[9][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N37) );
  \**SEQGEN**  \mem_reg[9][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[9][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N37) );
  \**SEQGEN**  \mem_reg[9][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[9][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N37) );
  \**SEQGEN**  \mem_reg[10][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[10][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N36) );
  \**SEQGEN**  \mem_reg[10][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[10][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N36) );
  \**SEQGEN**  \mem_reg[10][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[10][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N36) );
  \**SEQGEN**  \mem_reg[10][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[10][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N36) );
  \**SEQGEN**  \mem_reg[10][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[10][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N36) );
  \**SEQGEN**  \mem_reg[10][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[10][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N36) );
  \**SEQGEN**  \mem_reg[10][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[10][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N36) );
  \**SEQGEN**  \mem_reg[10][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[10][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N36) );
  \**SEQGEN**  \mem_reg[11][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[11][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N35) );
  \**SEQGEN**  \mem_reg[11][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[11][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N35) );
  \**SEQGEN**  \mem_reg[11][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[11][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N35) );
  \**SEQGEN**  \mem_reg[11][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[11][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N35) );
  \**SEQGEN**  \mem_reg[11][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[11][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N35) );
  \**SEQGEN**  \mem_reg[11][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[11][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N35) );
  \**SEQGEN**  \mem_reg[11][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[11][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N35) );
  \**SEQGEN**  \mem_reg[11][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[11][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N35) );
  \**SEQGEN**  \mem_reg[12][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[12][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N34) );
  \**SEQGEN**  \mem_reg[12][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[12][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N34) );
  \**SEQGEN**  \mem_reg[12][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[12][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N34) );
  \**SEQGEN**  \mem_reg[12][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[12][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N34) );
  \**SEQGEN**  \mem_reg[12][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[12][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N34) );
  \**SEQGEN**  \mem_reg[12][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[12][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N34) );
  \**SEQGEN**  \mem_reg[12][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[12][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N34) );
  \**SEQGEN**  \mem_reg[12][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[12][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N34) );
  \**SEQGEN**  \mem_reg[13][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[13][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N33) );
  \**SEQGEN**  \mem_reg[13][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[13][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N33) );
  \**SEQGEN**  \mem_reg[13][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[13][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N33) );
  \**SEQGEN**  \mem_reg[13][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[13][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N33) );
  \**SEQGEN**  \mem_reg[13][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[13][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N33) );
  \**SEQGEN**  \mem_reg[13][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[13][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N33) );
  \**SEQGEN**  \mem_reg[13][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[13][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N33) );
  \**SEQGEN**  \mem_reg[13][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[13][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N33) );
  \**SEQGEN**  \mem_reg[14][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[14][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N32) );
  \**SEQGEN**  \mem_reg[14][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[14][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N32) );
  \**SEQGEN**  \mem_reg[14][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[14][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N32) );
  \**SEQGEN**  \mem_reg[14][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[14][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N32) );
  \**SEQGEN**  \mem_reg[14][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[14][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N32) );
  \**SEQGEN**  \mem_reg[14][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[14][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N32) );
  \**SEQGEN**  \mem_reg[14][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[14][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N32) );
  \**SEQGEN**  \mem_reg[14][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[14][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N32) );
  \**SEQGEN**  \mem_reg[15][7]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[7]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[15][7] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N31) );
  \**SEQGEN**  \mem_reg[15][6]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[6]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[15][6] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N31) );
  \**SEQGEN**  \mem_reg[15][5]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[5]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[15][5] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N31) );
  \**SEQGEN**  \mem_reg[15][4]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[4]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[15][4] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N31) );
  \**SEQGEN**  \mem_reg[15][3]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[3]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[15][3] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N31) );
  \**SEQGEN**  \mem_reg[15][2]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[2]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[15][2] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N31) );
  \**SEQGEN**  \mem_reg[15][1]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[1]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[15][1] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N31) );
  \**SEQGEN**  \mem_reg[15][0]  ( .clear(1'b0), .preset(1'b0), .next_state(
        wdata[0]), .clocked_on(wclk), .data_in(1'b0), .enable(1'b0), .Q(
        \mem[15][0] ), .synch_clear(1'b0), .synch_preset(1'b0), .synch_toggle(
        1'b0), .synch_enable(N31) );
  GTECH_AND2 C276 ( .A(waddr[2]), .B(waddr[3]), .Z(N47) );
  GTECH_AND2 C277 ( .A(N0), .B(waddr[3]), .Z(N48) );
  GTECH_NOT I_0 ( .A(waddr[2]), .Z(N0) );
  GTECH_AND2 C278 ( .A(waddr[2]), .B(N1), .Z(N49) );
  GTECH_NOT I_1 ( .A(waddr[3]), .Z(N1) );
  GTECH_AND2 C279 ( .A(N2), .B(N3), .Z(N50) );
  GTECH_NOT I_2 ( .A(waddr[2]), .Z(N2) );
  GTECH_NOT I_3 ( .A(waddr[3]), .Z(N3) );
  GTECH_AND2 C280 ( .A(waddr[0]), .B(waddr[1]), .Z(N51) );
  GTECH_AND2 C281 ( .A(N4), .B(waddr[1]), .Z(N52) );
  GTECH_NOT I_4 ( .A(waddr[0]), .Z(N4) );
  GTECH_AND2 C282 ( .A(waddr[0]), .B(N5), .Z(N53) );
  GTECH_NOT I_5 ( .A(waddr[1]), .Z(N5) );
  GTECH_AND2 C283 ( .A(N6), .B(N7), .Z(N54) );
  GTECH_NOT I_6 ( .A(waddr[0]), .Z(N6) );
  GTECH_NOT I_7 ( .A(waddr[1]), .Z(N7) );
  GTECH_AND2 C284 ( .A(N47), .B(N51), .Z(N30) );
  GTECH_AND2 C285 ( .A(N47), .B(N52), .Z(N29) );
  GTECH_AND2 C286 ( .A(N47), .B(N53), .Z(N28) );
  GTECH_AND2 C287 ( .A(N47), .B(N54), .Z(N27) );
  GTECH_AND2 C288 ( .A(N48), .B(N51), .Z(N26) );
  GTECH_AND2 C289 ( .A(N48), .B(N52), .Z(N25) );
  GTECH_AND2 C290 ( .A(N48), .B(N53), .Z(N24) );
  GTECH_AND2 C291 ( .A(N48), .B(N54), .Z(N23) );
  GTECH_AND2 C292 ( .A(N49), .B(N51), .Z(N22) );
  GTECH_AND2 C293 ( .A(N49), .B(N52), .Z(N21) );
  GTECH_AND2 C294 ( .A(N49), .B(N53), .Z(N20) );
  GTECH_AND2 C295 ( .A(N49), .B(N54), .Z(N19) );
  GTECH_AND2 C296 ( .A(N50), .B(N51), .Z(N18) );
  GTECH_AND2 C297 ( .A(N50), .B(N52), .Z(N17) );
  GTECH_AND2 C298 ( .A(N50), .B(N53), .Z(N16) );
  GTECH_AND2 C299 ( .A(N50), .B(N54), .Z(N15) );
  SELECT_OP C300 ( .DATA1({N15, N16, N17, N18, N19, N20, N21, N22, N23, N24, 
        N25, N26, N27, N28, N29, N30}), .DATA2({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), 
        .CONTROL1(N8), .CONTROL2(N9), .Z({N46, N45, N44, N43, N42, N41, N40, 
        N39, N38, N37, N36, N35, N34, N33, N32, N31}) );
  GTECH_BUF B_0 ( .A(wclken), .Z(N8) );
  GTECH_BUF B_1 ( .A(N14), .Z(N9) );
  MUX_OP C301 ( .D0({\mem[0][0] , \mem[0][1] , \mem[0][2] , \mem[0][3] , 
        \mem[0][4] , \mem[0][5] , \mem[0][6] , \mem[0][7] }), .D1({\mem[1][0] , 
        \mem[1][1] , \mem[1][2] , \mem[1][3] , \mem[1][4] , \mem[1][5] , 
        \mem[1][6] , \mem[1][7] }), .D2({\mem[2][0] , \mem[2][1] , \mem[2][2] , 
        \mem[2][3] , \mem[2][4] , \mem[2][5] , \mem[2][6] , \mem[2][7] }), 
        .D3({\mem[3][0] , \mem[3][1] , \mem[3][2] , \mem[3][3] , \mem[3][4] , 
        \mem[3][5] , \mem[3][6] , \mem[3][7] }), .D4({\mem[4][0] , \mem[4][1] , 
        \mem[4][2] , \mem[4][3] , \mem[4][4] , \mem[4][5] , \mem[4][6] , 
        \mem[4][7] }), .D5({\mem[5][0] , \mem[5][1] , \mem[5][2] , \mem[5][3] , 
        \mem[5][4] , \mem[5][5] , \mem[5][6] , \mem[5][7] }), .D6({\mem[6][0] , 
        \mem[6][1] , \mem[6][2] , \mem[6][3] , \mem[6][4] , \mem[6][5] , 
        \mem[6][6] , \mem[6][7] }), .D7({\mem[7][0] , \mem[7][1] , \mem[7][2] , 
        \mem[7][3] , \mem[7][4] , \mem[7][5] , \mem[7][6] , \mem[7][7] }), 
        .D8({\mem[8][0] , \mem[8][1] , \mem[8][2] , \mem[8][3] , \mem[8][4] , 
        \mem[8][5] , \mem[8][6] , \mem[8][7] }), .D9({\mem[9][0] , \mem[9][1] , 
        \mem[9][2] , \mem[9][3] , \mem[9][4] , \mem[9][5] , \mem[9][6] , 
        \mem[9][7] }), .D10({\mem[10][0] , \mem[10][1] , \mem[10][2] , 
        \mem[10][3] , \mem[10][4] , \mem[10][5] , \mem[10][6] , \mem[10][7] }), 
        .D11({\mem[11][0] , \mem[11][1] , \mem[11][2] , \mem[11][3] , 
        \mem[11][4] , \mem[11][5] , \mem[11][6] , \mem[11][7] }), .D12({
        \mem[12][0] , \mem[12][1] , \mem[12][2] , \mem[12][3] , \mem[12][4] , 
        \mem[12][5] , \mem[12][6] , \mem[12][7] }), .D13({\mem[13][0] , 
        \mem[13][1] , \mem[13][2] , \mem[13][3] , \mem[13][4] , \mem[13][5] , 
        \mem[13][6] , \mem[13][7] }), .D14({\mem[14][0] , \mem[14][1] , 
        \mem[14][2] , \mem[14][3] , \mem[14][4] , \mem[14][5] , \mem[14][6] , 
        \mem[14][7] }), .D15({\mem[15][0] , \mem[15][1] , \mem[15][2] , 
        \mem[15][3] , \mem[15][4] , \mem[15][5] , \mem[15][6] , \mem[15][7] }), 
        .S0(N10), .S1(N11), .S2(N12), .S3(N13), .Z({rdata[0], rdata[1], 
        rdata[2], rdata[3], rdata[4], rdata[5], rdata[6], rdata[7]}) );
  GTECH_BUF B_2 ( .A(raddr[0]), .Z(N10) );
  GTECH_BUF B_3 ( .A(raddr[1]), .Z(N11) );
  GTECH_BUF B_4 ( .A(raddr[2]), .Z(N12) );
  GTECH_BUF B_5 ( .A(raddr[3]), .Z(N13) );
  GTECH_NOT I_8 ( .A(wclken), .Z(N14) );
endmodule

