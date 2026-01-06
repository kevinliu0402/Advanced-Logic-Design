/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : U-2022.12-SP7
// Date      : Wed Dec  3 21:28:58 2025
/////////////////////////////////////////////////////////////


module fifomem ( rdata, wdata, waddr, raddr, wclken, wclk );
  output [7:0] rdata;
  input [7:0] wdata;
  input [3:0] waddr;
  input [3:0] raddr;
  input wclken, wclk;
  wire   N10, N11, N12, N13, \mem[0][7] , \mem[0][6] , \mem[0][5] ,
         \mem[0][4] , \mem[0][3] , \mem[0][2] , \mem[0][1] , \mem[0][0] ,
         \mem[1][7] , \mem[1][6] , \mem[1][5] , \mem[1][4] , \mem[1][3] ,
         \mem[1][2] , \mem[1][1] , \mem[1][0] , \mem[2][7] , \mem[2][6] ,
         \mem[2][5] , \mem[2][4] , \mem[2][3] , \mem[2][2] , \mem[2][1] ,
         \mem[2][0] , \mem[3][7] , \mem[3][6] , \mem[3][5] , \mem[3][4] ,
         \mem[3][3] , \mem[3][2] , \mem[3][1] , \mem[3][0] , \mem[4][7] ,
         \mem[4][6] , \mem[4][5] , \mem[4][4] , \mem[4][3] , \mem[4][2] ,
         \mem[4][1] , \mem[4][0] , \mem[5][7] , \mem[5][6] , \mem[5][5] ,
         \mem[5][4] , \mem[5][3] , \mem[5][2] , \mem[5][1] , \mem[5][0] ,
         \mem[6][7] , \mem[6][6] , \mem[6][5] , \mem[6][4] , \mem[6][3] ,
         \mem[6][2] , \mem[6][1] , \mem[6][0] , \mem[7][7] , \mem[7][6] ,
         \mem[7][5] , \mem[7][4] , \mem[7][3] , \mem[7][2] , \mem[7][1] ,
         \mem[7][0] , \mem[8][7] , \mem[8][6] , \mem[8][5] , \mem[8][4] ,
         \mem[8][3] , \mem[8][2] , \mem[8][1] , \mem[8][0] , \mem[9][7] ,
         \mem[9][6] , \mem[9][5] , \mem[9][4] , \mem[9][3] , \mem[9][2] ,
         \mem[9][1] , \mem[9][0] , \mem[10][7] , \mem[10][6] , \mem[10][5] ,
         \mem[10][4] , \mem[10][3] , \mem[10][2] , \mem[10][1] , \mem[10][0] ,
         \mem[11][7] , \mem[11][6] , \mem[11][5] , \mem[11][4] , \mem[11][3] ,
         \mem[11][2] , \mem[11][1] , \mem[11][0] , \mem[12][7] , \mem[12][6] ,
         \mem[12][5] , \mem[12][4] , \mem[12][3] , \mem[12][2] , \mem[12][1] ,
         \mem[12][0] , \mem[13][7] , \mem[13][6] , \mem[13][5] , \mem[13][4] ,
         \mem[13][3] , \mem[13][2] , \mem[13][1] , \mem[13][0] , \mem[14][7] ,
         \mem[14][6] , \mem[14][5] , \mem[14][4] , \mem[14][3] , \mem[14][2] ,
         \mem[14][1] , \mem[14][0] , \mem[15][7] , \mem[15][6] , \mem[15][5] ,
         \mem[15][4] , \mem[15][3] , \mem[15][2] , \mem[15][1] , \mem[15][0] ,
         n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80,
         n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94,
         n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105, n106,
         n107, n108, n109, n110, n111, n112, n113, n114, n115, n116, n117,
         n118, n119, n120, n121, n122, n123, n124, n125, n126, n127, n128,
         n129, n130, n131, n132, n133, n134, n135, n136, n137, n138, n139,
         n140, n141, n142, n143, n144, n145, n146, n147, n148, n149, n150,
         n151, n152, n153, n154, n155, n156, n157, n158, n159, n160, n161,
         n162, n163, n164, n165, n166, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10,
         n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24,
         n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38,
         n167, n168, n169, n170, n171, n172, n173, n174, n175, n176, n177,
         n178, n179, n180, n181, n182, n183, n184, n185, n186, n187, n188,
         n189, n190, n191, n192, n193, n194, n195, n196, n197, n198, n199,
         n200, n201, n202, n203, n204, n205, n206, n207, n208, n209, n210,
         n211, n212, n213, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n231, n232,
         n233, n234, n235, n236, n237, n238, n239, n240, n241, n242, n243,
         n244, n245, n246, n247, n248, n249, n250, n251, n252, n253, n254,
         n255, n256, n257, n258, n259, n260, n261, n262, n263, n264, n265,
         n266, n267, n268, n269, n270, n271, n272, n273, n274, n275, n276,
         n277, n278, n279, n280, n281, n282, n283, n284, n285, n286, n287,
         n288, n289, n290, n291, n292, n293, n294, n295, n296, n297, n298,
         n299, n300, n301, n302, n303, n304, n305, n306, n307, n308, n309,
         n310, n311, n312, n313, n314, n315, n316, n317, n318, n319, n320,
         n321, n322, n323, n324, n325, n326, n327, n328, n329, n330, n331,
         n332, n333, n334, n335, n336, n337, n338, n339, n340, n341, n342,
         n343, n344, n345, n346, n347, n348, n349, n350, n351, n352, n353,
         n354, n355, n356, n357, n358, n359, n360, n361, n362, n363, n364,
         n365, n366, n367, n368, n369, n370, n371, n372, n373, n374, n375,
         n376, n377, n378, n379, n380, n381, n382, n383, n384, n385, n386,
         n387, n388, n389, n390, n391, n392, n393, n394, n395, n396, n397,
         n398, n399, n400, n401, n402, n403, n404, n405, n406, n407, n408,
         n409, n410, n411, n412, n413, n414, n415, n416, n417, n418, n419,
         n420, n421, n422, n423, n424, n425, n426, n427, n428, n429, n430,
         n431, n432, n433, n434, n435, n436, n437, n438, n439, n440, n441,
         n442, n443;
  assign N10 = raddr[0];
  assign N11 = raddr[1];
  assign N12 = raddr[2];
  assign N13 = raddr[3];

  FD1 \mem_reg[0][7]  ( .D(n166), .CP(n10), .Q(\mem[0][7] ), .QN(n443) );
  FD1 \mem_reg[0][6]  ( .D(n165), .CP(n10), .Q(\mem[0][6] ), .QN(n442) );
  FD1 \mem_reg[0][5]  ( .D(n164), .CP(n9), .Q(\mem[0][5] ), .QN(n441) );
  FD1 \mem_reg[0][4]  ( .D(n163), .CP(n9), .Q(\mem[0][4] ), .QN(n440) );
  FD1 \mem_reg[0][3]  ( .D(n162), .CP(n9), .Q(\mem[0][3] ), .QN(n439) );
  FD1 \mem_reg[0][2]  ( .D(n161), .CP(n9), .Q(\mem[0][2] ), .QN(n438) );
  FD1 \mem_reg[0][1]  ( .D(n160), .CP(n9), .Q(\mem[0][1] ), .QN(n437) );
  FD1 \mem_reg[0][0]  ( .D(n159), .CP(n9), .Q(\mem[0][0] ), .QN(n436) );
  FD1 \mem_reg[1][7]  ( .D(n158), .CP(n9), .Q(\mem[1][7] ), .QN(n435) );
  FD1 \mem_reg[1][6]  ( .D(n157), .CP(n9), .Q(\mem[1][6] ), .QN(n434) );
  FD1 \mem_reg[1][5]  ( .D(n156), .CP(n9), .Q(\mem[1][5] ), .QN(n433) );
  FD1 \mem_reg[1][4]  ( .D(n155), .CP(n9), .Q(\mem[1][4] ), .QN(n432) );
  FD1 \mem_reg[1][3]  ( .D(n154), .CP(n9), .Q(\mem[1][3] ), .QN(n431) );
  FD1 \mem_reg[1][2]  ( .D(n153), .CP(n9), .Q(\mem[1][2] ), .QN(n430) );
  FD1 \mem_reg[1][1]  ( .D(n152), .CP(n9), .Q(\mem[1][1] ), .QN(n429) );
  FD1 \mem_reg[1][0]  ( .D(n151), .CP(n9), .Q(\mem[1][0] ), .QN(n428) );
  FD1 \mem_reg[2][7]  ( .D(n150), .CP(n8), .Q(\mem[2][7] ), .QN(n427) );
  FD1 \mem_reg[2][6]  ( .D(n149), .CP(n8), .Q(\mem[2][6] ), .QN(n426) );
  FD1 \mem_reg[2][5]  ( .D(n148), .CP(n8), .Q(\mem[2][5] ), .QN(n425) );
  FD1 \mem_reg[2][4]  ( .D(n147), .CP(n8), .Q(\mem[2][4] ), .QN(n424) );
  FD1 \mem_reg[2][3]  ( .D(n146), .CP(n8), .Q(\mem[2][3] ), .QN(n423) );
  FD1 \mem_reg[2][2]  ( .D(n145), .CP(n8), .Q(\mem[2][2] ), .QN(n422) );
  FD1 \mem_reg[2][1]  ( .D(n144), .CP(n8), .Q(\mem[2][1] ), .QN(n421) );
  FD1 \mem_reg[2][0]  ( .D(n143), .CP(n8), .Q(\mem[2][0] ), .QN(n420) );
  FD1 \mem_reg[3][7]  ( .D(n142), .CP(n8), .Q(\mem[3][7] ), .QN(n419) );
  FD1 \mem_reg[3][6]  ( .D(n141), .CP(n8), .Q(\mem[3][6] ), .QN(n418) );
  FD1 \mem_reg[3][5]  ( .D(n140), .CP(n8), .Q(\mem[3][5] ), .QN(n417) );
  FD1 \mem_reg[3][4]  ( .D(n139), .CP(n8), .Q(\mem[3][4] ), .QN(n416) );
  FD1 \mem_reg[3][3]  ( .D(n138), .CP(n8), .Q(\mem[3][3] ), .QN(n415) );
  FD1 \mem_reg[3][2]  ( .D(n137), .CP(n8), .Q(\mem[3][2] ), .QN(n414) );
  FD1 \mem_reg[3][1]  ( .D(n136), .CP(n7), .Q(\mem[3][1] ), .QN(n413) );
  FD1 \mem_reg[3][0]  ( .D(n135), .CP(n7), .Q(\mem[3][0] ), .QN(n412) );
  FD1 \mem_reg[4][7]  ( .D(n134), .CP(n7), .Q(\mem[4][7] ), .QN(n411) );
  FD1 \mem_reg[4][6]  ( .D(n133), .CP(n7), .Q(\mem[4][6] ), .QN(n410) );
  FD1 \mem_reg[4][5]  ( .D(n132), .CP(n7), .Q(\mem[4][5] ), .QN(n409) );
  FD1 \mem_reg[4][4]  ( .D(n131), .CP(n7), .Q(\mem[4][4] ), .QN(n408) );
  FD1 \mem_reg[4][3]  ( .D(n130), .CP(n7), .Q(\mem[4][3] ), .QN(n407) );
  FD1 \mem_reg[4][2]  ( .D(n129), .CP(n7), .Q(\mem[4][2] ), .QN(n406) );
  FD1 \mem_reg[4][1]  ( .D(n128), .CP(n7), .Q(\mem[4][1] ), .QN(n405) );
  FD1 \mem_reg[4][0]  ( .D(n127), .CP(n7), .Q(\mem[4][0] ), .QN(n404) );
  FD1 \mem_reg[5][7]  ( .D(n126), .CP(n7), .Q(\mem[5][7] ), .QN(n403) );
  FD1 \mem_reg[5][6]  ( .D(n125), .CP(n7), .Q(\mem[5][6] ), .QN(n402) );
  FD1 \mem_reg[5][5]  ( .D(n124), .CP(n7), .Q(\mem[5][5] ), .QN(n401) );
  FD1 \mem_reg[5][4]  ( .D(n123), .CP(n7), .Q(\mem[5][4] ), .QN(n400) );
  FD1 \mem_reg[5][3]  ( .D(n122), .CP(n6), .Q(\mem[5][3] ), .QN(n399) );
  FD1 \mem_reg[5][2]  ( .D(n121), .CP(n6), .Q(\mem[5][2] ), .QN(n398) );
  FD1 \mem_reg[5][1]  ( .D(n120), .CP(n6), .Q(\mem[5][1] ), .QN(n397) );
  FD1 \mem_reg[5][0]  ( .D(n119), .CP(n6), .Q(\mem[5][0] ), .QN(n396) );
  FD1 \mem_reg[6][7]  ( .D(n118), .CP(n6), .Q(\mem[6][7] ), .QN(n395) );
  FD1 \mem_reg[6][6]  ( .D(n117), .CP(n6), .Q(\mem[6][6] ), .QN(n394) );
  FD1 \mem_reg[6][5]  ( .D(n116), .CP(n6), .Q(\mem[6][5] ), .QN(n393) );
  FD1 \mem_reg[6][4]  ( .D(n115), .CP(n6), .Q(\mem[6][4] ), .QN(n392) );
  FD1 \mem_reg[6][3]  ( .D(n114), .CP(n6), .Q(\mem[6][3] ), .QN(n391) );
  FD1 \mem_reg[6][2]  ( .D(n113), .CP(n6), .Q(\mem[6][2] ), .QN(n390) );
  FD1 \mem_reg[6][1]  ( .D(n112), .CP(n6), .Q(\mem[6][1] ), .QN(n389) );
  FD1 \mem_reg[6][0]  ( .D(n111), .CP(n6), .Q(\mem[6][0] ), .QN(n388) );
  FD1 \mem_reg[7][7]  ( .D(n110), .CP(n6), .Q(\mem[7][7] ), .QN(n387) );
  FD1 \mem_reg[7][6]  ( .D(n109), .CP(n6), .Q(\mem[7][6] ), .QN(n386) );
  FD1 \mem_reg[7][5]  ( .D(n108), .CP(n5), .Q(\mem[7][5] ), .QN(n385) );
  FD1 \mem_reg[7][4]  ( .D(n107), .CP(n5), .Q(\mem[7][4] ), .QN(n384) );
  FD1 \mem_reg[7][3]  ( .D(n106), .CP(n5), .Q(\mem[7][3] ), .QN(n383) );
  FD1 \mem_reg[7][2]  ( .D(n105), .CP(n5), .Q(\mem[7][2] ), .QN(n382) );
  FD1 \mem_reg[7][1]  ( .D(n104), .CP(n5), .Q(\mem[7][1] ), .QN(n381) );
  FD1 \mem_reg[7][0]  ( .D(n103), .CP(n5), .Q(\mem[7][0] ), .QN(n380) );
  FD1 \mem_reg[8][7]  ( .D(n102), .CP(n5), .Q(\mem[8][7] ), .QN(n379) );
  FD1 \mem_reg[8][6]  ( .D(n101), .CP(n5), .Q(\mem[8][6] ), .QN(n378) );
  FD1 \mem_reg[8][5]  ( .D(n100), .CP(n5), .Q(\mem[8][5] ), .QN(n377) );
  FD1 \mem_reg[8][4]  ( .D(n99), .CP(n5), .Q(\mem[8][4] ), .QN(n376) );
  FD1 \mem_reg[8][3]  ( .D(n98), .CP(n5), .Q(\mem[8][3] ), .QN(n375) );
  FD1 \mem_reg[8][2]  ( .D(n97), .CP(n5), .Q(\mem[8][2] ), .QN(n374) );
  FD1 \mem_reg[8][1]  ( .D(n96), .CP(n5), .Q(\mem[8][1] ), .QN(n373) );
  FD1 \mem_reg[8][0]  ( .D(n95), .CP(n5), .Q(\mem[8][0] ), .QN(n372) );
  FD1 \mem_reg[9][7]  ( .D(n94), .CP(n4), .Q(\mem[9][7] ), .QN(n371) );
  FD1 \mem_reg[9][6]  ( .D(n93), .CP(n4), .Q(\mem[9][6] ), .QN(n370) );
  FD1 \mem_reg[9][5]  ( .D(n92), .CP(n4), .Q(\mem[9][5] ), .QN(n369) );
  FD1 \mem_reg[9][4]  ( .D(n91), .CP(n4), .Q(\mem[9][4] ), .QN(n368) );
  FD1 \mem_reg[9][3]  ( .D(n90), .CP(n4), .Q(\mem[9][3] ), .QN(n367) );
  FD1 \mem_reg[9][2]  ( .D(n89), .CP(n4), .Q(\mem[9][2] ), .QN(n366) );
  FD1 \mem_reg[9][1]  ( .D(n88), .CP(n4), .Q(\mem[9][1] ), .QN(n365) );
  FD1 \mem_reg[9][0]  ( .D(n87), .CP(n4), .Q(\mem[9][0] ), .QN(n364) );
  FD1 \mem_reg[10][7]  ( .D(n86), .CP(n4), .Q(\mem[10][7] ), .QN(n363) );
  FD1 \mem_reg[10][6]  ( .D(n85), .CP(n4), .Q(\mem[10][6] ), .QN(n362) );
  FD1 \mem_reg[10][5]  ( .D(n84), .CP(n4), .Q(\mem[10][5] ), .QN(n361) );
  FD1 \mem_reg[10][4]  ( .D(n83), .CP(n4), .Q(\mem[10][4] ), .QN(n360) );
  FD1 \mem_reg[10][3]  ( .D(n82), .CP(n4), .Q(\mem[10][3] ), .QN(n359) );
  FD1 \mem_reg[10][2]  ( .D(n81), .CP(n4), .Q(\mem[10][2] ), .QN(n358) );
  FD1 \mem_reg[10][1]  ( .D(n80), .CP(n3), .Q(\mem[10][1] ), .QN(n357) );
  FD1 \mem_reg[10][0]  ( .D(n79), .CP(n3), .Q(\mem[10][0] ), .QN(n356) );
  FD1 \mem_reg[11][7]  ( .D(n78), .CP(n3), .Q(\mem[11][7] ), .QN(n355) );
  FD1 \mem_reg[11][6]  ( .D(n77), .CP(n3), .Q(\mem[11][6] ), .QN(n354) );
  FD1 \mem_reg[11][5]  ( .D(n76), .CP(n3), .Q(\mem[11][5] ), .QN(n353) );
  FD1 \mem_reg[11][4]  ( .D(n75), .CP(n3), .Q(\mem[11][4] ), .QN(n352) );
  FD1 \mem_reg[11][3]  ( .D(n74), .CP(n3), .Q(\mem[11][3] ), .QN(n351) );
  FD1 \mem_reg[11][2]  ( .D(n73), .CP(n3), .Q(\mem[11][2] ), .QN(n350) );
  FD1 \mem_reg[11][1]  ( .D(n72), .CP(n3), .Q(\mem[11][1] ), .QN(n349) );
  FD1 \mem_reg[11][0]  ( .D(n71), .CP(n3), .Q(\mem[11][0] ), .QN(n348) );
  FD1 \mem_reg[12][7]  ( .D(n70), .CP(n3), .Q(\mem[12][7] ), .QN(n347) );
  FD1 \mem_reg[12][6]  ( .D(n69), .CP(n3), .Q(\mem[12][6] ), .QN(n346) );
  FD1 \mem_reg[12][5]  ( .D(n68), .CP(n3), .Q(\mem[12][5] ), .QN(n345) );
  FD1 \mem_reg[12][4]  ( .D(n67), .CP(n3), .Q(\mem[12][4] ), .QN(n344) );
  FD1 \mem_reg[12][3]  ( .D(n66), .CP(n2), .Q(\mem[12][3] ), .QN(n343) );
  FD1 \mem_reg[12][2]  ( .D(n65), .CP(n2), .Q(\mem[12][2] ), .QN(n342) );
  FD1 \mem_reg[12][1]  ( .D(n64), .CP(n2), .Q(\mem[12][1] ), .QN(n341) );
  FD1 \mem_reg[12][0]  ( .D(n63), .CP(n2), .Q(\mem[12][0] ), .QN(n340) );
  FD1 \mem_reg[13][7]  ( .D(n62), .CP(n2), .Q(\mem[13][7] ), .QN(n339) );
  FD1 \mem_reg[13][6]  ( .D(n61), .CP(n2), .Q(\mem[13][6] ), .QN(n338) );
  FD1 \mem_reg[13][5]  ( .D(n60), .CP(n2), .Q(\mem[13][5] ), .QN(n337) );
  FD1 \mem_reg[13][4]  ( .D(n59), .CP(n2), .Q(\mem[13][4] ), .QN(n336) );
  FD1 \mem_reg[13][3]  ( .D(n58), .CP(n2), .Q(\mem[13][3] ), .QN(n335) );
  FD1 \mem_reg[13][2]  ( .D(n57), .CP(n2), .Q(\mem[13][2] ), .QN(n334) );
  FD1 \mem_reg[13][1]  ( .D(n56), .CP(n2), .Q(\mem[13][1] ), .QN(n333) );
  FD1 \mem_reg[13][0]  ( .D(n55), .CP(n2), .Q(\mem[13][0] ), .QN(n332) );
  FD1 \mem_reg[14][7]  ( .D(n54), .CP(n2), .Q(\mem[14][7] ), .QN(n331) );
  FD1 \mem_reg[14][6]  ( .D(n53), .CP(n2), .Q(\mem[14][6] ), .QN(n330) );
  FD1 \mem_reg[14][5]  ( .D(n52), .CP(n1), .Q(\mem[14][5] ), .QN(n329) );
  FD1 \mem_reg[14][4]  ( .D(n51), .CP(n1), .Q(\mem[14][4] ), .QN(n328) );
  FD1 \mem_reg[14][3]  ( .D(n50), .CP(n1), .Q(\mem[14][3] ), .QN(n327) );
  FD1 \mem_reg[14][2]  ( .D(n49), .CP(n1), .Q(\mem[14][2] ), .QN(n326) );
  FD1 \mem_reg[14][1]  ( .D(n48), .CP(n1), .Q(\mem[14][1] ), .QN(n325) );
  FD1 \mem_reg[14][0]  ( .D(n47), .CP(n1), .Q(\mem[14][0] ), .QN(n324) );
  FD1 \mem_reg[15][7]  ( .D(n46), .CP(n1), .Q(\mem[15][7] ), .QN(n323) );
  FD1 \mem_reg[15][6]  ( .D(n45), .CP(n1), .Q(\mem[15][6] ), .QN(n322) );
  FD1 \mem_reg[15][5]  ( .D(n44), .CP(n1), .Q(\mem[15][5] ), .QN(n321) );
  FD1 \mem_reg[15][4]  ( .D(n43), .CP(n1), .Q(\mem[15][4] ), .QN(n320) );
  FD1 \mem_reg[15][3]  ( .D(n42), .CP(n1), .Q(\mem[15][3] ), .QN(n319) );
  FD1 \mem_reg[15][2]  ( .D(n41), .CP(n1), .Q(\mem[15][2] ), .QN(n318) );
  FD1 \mem_reg[15][1]  ( .D(n40), .CP(n1), .Q(\mem[15][1] ), .QN(n317) );
  FD1 \mem_reg[15][0]  ( .D(n39), .CP(n1), .Q(\mem[15][0] ), .QN(n316) );
  IVI U2 ( .A(n13), .Z(n2) );
  IVI U3 ( .A(n13), .Z(n3) );
  IVI U4 ( .A(n13), .Z(n4) );
  IVI U5 ( .A(n12), .Z(n5) );
  IVI U6 ( .A(n12), .Z(n6) );
  IVI U7 ( .A(n12), .Z(n7) );
  IVI U8 ( .A(n15), .Z(n13) );
  IVI U9 ( .A(n15), .Z(n12) );
  IVI U10 ( .A(n14), .Z(n1) );
  IVI U11 ( .A(n15), .Z(n14) );
  IVI U12 ( .A(n11), .Z(n8) );
  IVI U13 ( .A(n11), .Z(n9) );
  IVI U14 ( .A(n11), .Z(n10) );
  IVI U15 ( .A(n17), .Z(n15) );
  IVI U16 ( .A(n16), .Z(n11) );
  IVI U17 ( .A(n17), .Z(n16) );
  IVI U18 ( .A(wclk), .Z(n17) );
  NR2 U19 ( .A(n278), .B(N12), .Z(n22) );
  ND2 U20 ( .A(n22), .B(N10), .Z(n267) );
  NR2 U21 ( .A(N11), .B(N12), .Z(n23) );
  ND2 U22 ( .A(n23), .B(N10), .Z(n266) );
  AO4 U23 ( .A(\mem[11][0] ), .B(n267), .C(\mem[9][0] ), .D(n266), .Z(n19) );
  NR2 U24 ( .A(n276), .B(n278), .Z(n20) );
  ND2 U25 ( .A(N10), .B(n20), .Z(n269) );
  NR2 U26 ( .A(n276), .B(N11), .Z(n21) );
  ND2 U27 ( .A(n21), .B(N10), .Z(n268) );
  AO4 U28 ( .A(\mem[15][0] ), .B(n269), .C(\mem[13][0] ), .D(n268), .Z(n18) );
  NR2 U29 ( .A(n19), .B(n18), .Z(n35) );
  ND2 U30 ( .A(n20), .B(n279), .Z(n265) );
  ND2 U31 ( .A(n21), .B(n279), .Z(n264) );
  AO4 U32 ( .A(\mem[14][0] ), .B(n265), .C(\mem[12][0] ), .D(n264), .Z(n26) );
  ND2 U33 ( .A(n22), .B(n279), .Z(n263) );
  NR2 U34 ( .A(\mem[10][0] ), .B(n263), .Z(n25) );
  ND2 U35 ( .A(n23), .B(n279), .Z(n261) );
  NR2 U36 ( .A(\mem[8][0] ), .B(n261), .Z(n24) );
  NR4 U37 ( .A(n26), .B(n25), .C(n277), .D(n24), .Z(n34) );
  AO4 U38 ( .A(\mem[3][0] ), .B(n267), .C(\mem[1][0] ), .D(n266), .Z(n28) );
  AO4 U39 ( .A(\mem[7][0] ), .B(n269), .C(\mem[5][0] ), .D(n268), .Z(n27) );
  NR2 U40 ( .A(n28), .B(n27), .Z(n33) );
  AO4 U41 ( .A(\mem[6][0] ), .B(n265), .C(\mem[4][0] ), .D(n264), .Z(n31) );
  NR2 U42 ( .A(\mem[2][0] ), .B(n263), .Z(n30) );
  NR2 U43 ( .A(\mem[0][0] ), .B(n261), .Z(n29) );
  NR4 U44 ( .A(n31), .B(n30), .C(N13), .D(n29), .Z(n32) );
  AO2 U45 ( .A(n35), .B(n34), .C(n33), .D(n32), .Z(n36) );
  AO4 U46 ( .A(\mem[11][1] ), .B(n267), .C(\mem[9][1] ), .D(n266), .Z(n38) );
  AO4 U47 ( .A(\mem[15][1] ), .B(n269), .C(\mem[13][1] ), .D(n268), .Z(n37) );
  NR2 U48 ( .A(n38), .B(n37), .Z(n178) );
  AO4 U49 ( .A(\mem[14][1] ), .B(n265), .C(\mem[12][1] ), .D(n264), .Z(n169)
         );
  NR2 U50 ( .A(\mem[10][1] ), .B(n263), .Z(n168) );
  NR2 U51 ( .A(\mem[8][1] ), .B(n261), .Z(n167) );
  NR4 U52 ( .A(n169), .B(n168), .C(n277), .D(n167), .Z(n177) );
  AO4 U53 ( .A(\mem[3][1] ), .B(n267), .C(\mem[1][1] ), .D(n266), .Z(n171) );
  AO4 U54 ( .A(\mem[7][1] ), .B(n269), .C(\mem[5][1] ), .D(n268), .Z(n170) );
  NR2 U55 ( .A(n171), .B(n170), .Z(n176) );
  AO4 U56 ( .A(\mem[6][1] ), .B(n265), .C(\mem[4][1] ), .D(n264), .Z(n174) );
  NR2 U57 ( .A(\mem[2][1] ), .B(n263), .Z(n173) );
  NR2 U58 ( .A(\mem[0][1] ), .B(n261), .Z(n172) );
  NR4 U59 ( .A(n174), .B(n173), .C(N13), .D(n172), .Z(n175) );
  AO2 U60 ( .A(n178), .B(n177), .C(n176), .D(n175), .Z(n179) );
  AO4 U61 ( .A(\mem[11][2] ), .B(n267), .C(\mem[9][2] ), .D(n266), .Z(n181) );
  AO4 U62 ( .A(\mem[15][2] ), .B(n269), .C(\mem[13][2] ), .D(n268), .Z(n180)
         );
  NR2 U63 ( .A(n181), .B(n180), .Z(n193) );
  AO4 U64 ( .A(\mem[14][2] ), .B(n265), .C(\mem[12][2] ), .D(n264), .Z(n184)
         );
  NR2 U65 ( .A(\mem[10][2] ), .B(n263), .Z(n183) );
  NR2 U66 ( .A(\mem[8][2] ), .B(n261), .Z(n182) );
  NR4 U67 ( .A(n184), .B(n183), .C(n277), .D(n182), .Z(n192) );
  AO4 U68 ( .A(\mem[3][2] ), .B(n267), .C(\mem[1][2] ), .D(n266), .Z(n186) );
  AO4 U69 ( .A(\mem[7][2] ), .B(n269), .C(\mem[5][2] ), .D(n268), .Z(n185) );
  NR2 U70 ( .A(n186), .B(n185), .Z(n191) );
  AO4 U71 ( .A(\mem[6][2] ), .B(n265), .C(\mem[4][2] ), .D(n264), .Z(n189) );
  NR2 U72 ( .A(\mem[2][2] ), .B(n263), .Z(n188) );
  NR2 U73 ( .A(\mem[0][2] ), .B(n261), .Z(n187) );
  NR4 U74 ( .A(n189), .B(n188), .C(N13), .D(n187), .Z(n190) );
  AO2 U75 ( .A(n193), .B(n192), .C(n191), .D(n190), .Z(n194) );
  AO4 U76 ( .A(\mem[11][3] ), .B(n267), .C(\mem[9][3] ), .D(n266), .Z(n196) );
  AO4 U77 ( .A(\mem[15][3] ), .B(n269), .C(\mem[13][3] ), .D(n268), .Z(n195)
         );
  NR2 U78 ( .A(n196), .B(n195), .Z(n208) );
  AO4 U79 ( .A(\mem[14][3] ), .B(n265), .C(\mem[12][3] ), .D(n264), .Z(n199)
         );
  NR2 U80 ( .A(\mem[10][3] ), .B(n263), .Z(n198) );
  NR2 U81 ( .A(\mem[8][3] ), .B(n261), .Z(n197) );
  NR4 U82 ( .A(n199), .B(n198), .C(n277), .D(n197), .Z(n207) );
  AO4 U83 ( .A(\mem[3][3] ), .B(n267), .C(\mem[1][3] ), .D(n266), .Z(n201) );
  AO4 U84 ( .A(\mem[7][3] ), .B(n269), .C(\mem[5][3] ), .D(n268), .Z(n200) );
  NR2 U85 ( .A(n201), .B(n200), .Z(n206) );
  AO4 U86 ( .A(\mem[6][3] ), .B(n265), .C(\mem[4][3] ), .D(n264), .Z(n204) );
  NR2 U87 ( .A(\mem[2][3] ), .B(n263), .Z(n203) );
  NR2 U88 ( .A(\mem[0][3] ), .B(n261), .Z(n202) );
  NR4 U89 ( .A(n204), .B(n203), .C(N13), .D(n202), .Z(n205) );
  AO2 U90 ( .A(n208), .B(n207), .C(n206), .D(n205), .Z(n209) );
  AO4 U91 ( .A(\mem[11][4] ), .B(n267), .C(\mem[9][4] ), .D(n266), .Z(n211) );
  AO4 U92 ( .A(\mem[15][4] ), .B(n269), .C(\mem[13][4] ), .D(n268), .Z(n210)
         );
  NR2 U93 ( .A(n211), .B(n210), .Z(n223) );
  AO4 U94 ( .A(\mem[14][4] ), .B(n265), .C(\mem[12][4] ), .D(n264), .Z(n214)
         );
  NR2 U95 ( .A(\mem[10][4] ), .B(n263), .Z(n213) );
  NR2 U96 ( .A(\mem[8][4] ), .B(n261), .Z(n212) );
  NR4 U97 ( .A(n214), .B(n213), .C(n277), .D(n212), .Z(n222) );
  AO4 U98 ( .A(\mem[3][4] ), .B(n267), .C(\mem[1][4] ), .D(n266), .Z(n216) );
  AO4 U99 ( .A(\mem[7][4] ), .B(n269), .C(\mem[5][4] ), .D(n268), .Z(n215) );
  NR2 U100 ( .A(n216), .B(n215), .Z(n221) );
  AO4 U101 ( .A(\mem[6][4] ), .B(n265), .C(\mem[4][4] ), .D(n264), .Z(n219) );
  NR2 U102 ( .A(\mem[2][4] ), .B(n263), .Z(n218) );
  NR2 U103 ( .A(\mem[0][4] ), .B(n261), .Z(n217) );
  NR4 U104 ( .A(n219), .B(n218), .C(N13), .D(n217), .Z(n220) );
  AO2 U105 ( .A(n223), .B(n222), .C(n221), .D(n220), .Z(n224) );
  AO4 U106 ( .A(\mem[11][5] ), .B(n267), .C(\mem[9][5] ), .D(n266), .Z(n226)
         );
  AO4 U107 ( .A(\mem[15][5] ), .B(n269), .C(\mem[13][5] ), .D(n268), .Z(n225)
         );
  NR2 U108 ( .A(n226), .B(n225), .Z(n238) );
  AO4 U109 ( .A(\mem[14][5] ), .B(n265), .C(\mem[12][5] ), .D(n264), .Z(n229)
         );
  NR2 U110 ( .A(\mem[10][5] ), .B(n263), .Z(n228) );
  NR2 U111 ( .A(\mem[8][5] ), .B(n261), .Z(n227) );
  NR4 U112 ( .A(n229), .B(n228), .C(n277), .D(n227), .Z(n237) );
  AO4 U113 ( .A(\mem[3][5] ), .B(n267), .C(\mem[1][5] ), .D(n266), .Z(n231) );
  AO4 U114 ( .A(\mem[7][5] ), .B(n269), .C(\mem[5][5] ), .D(n268), .Z(n230) );
  NR2 U115 ( .A(n231), .B(n230), .Z(n236) );
  AO4 U116 ( .A(\mem[6][5] ), .B(n265), .C(\mem[4][5] ), .D(n264), .Z(n234) );
  NR2 U117 ( .A(\mem[2][5] ), .B(n263), .Z(n233) );
  NR2 U118 ( .A(\mem[0][5] ), .B(n261), .Z(n232) );
  NR4 U119 ( .A(n234), .B(n233), .C(N13), .D(n232), .Z(n235) );
  AO2 U120 ( .A(n238), .B(n237), .C(n236), .D(n235), .Z(n239) );
  AO4 U121 ( .A(\mem[11][6] ), .B(n267), .C(\mem[9][6] ), .D(n266), .Z(n241)
         );
  AO4 U122 ( .A(\mem[15][6] ), .B(n269), .C(\mem[13][6] ), .D(n268), .Z(n240)
         );
  NR2 U123 ( .A(n241), .B(n240), .Z(n253) );
  AO4 U124 ( .A(\mem[14][6] ), .B(n265), .C(\mem[12][6] ), .D(n264), .Z(n244)
         );
  NR2 U125 ( .A(\mem[10][6] ), .B(n263), .Z(n243) );
  NR2 U126 ( .A(\mem[8][6] ), .B(n261), .Z(n242) );
  NR4 U127 ( .A(n244), .B(n243), .C(n277), .D(n242), .Z(n252) );
  AO4 U128 ( .A(\mem[3][6] ), .B(n267), .C(\mem[1][6] ), .D(n266), .Z(n246) );
  AO4 U129 ( .A(\mem[7][6] ), .B(n269), .C(\mem[5][6] ), .D(n268), .Z(n245) );
  NR2 U130 ( .A(n246), .B(n245), .Z(n251) );
  AO4 U131 ( .A(\mem[6][6] ), .B(n265), .C(\mem[4][6] ), .D(n264), .Z(n249) );
  NR2 U132 ( .A(\mem[2][6] ), .B(n263), .Z(n248) );
  NR2 U133 ( .A(\mem[0][6] ), .B(n261), .Z(n247) );
  NR4 U134 ( .A(n249), .B(n248), .C(N13), .D(n247), .Z(n250) );
  AO2 U135 ( .A(n253), .B(n252), .C(n251), .D(n250), .Z(n254) );
  NR2 U136 ( .A(\mem[12][7] ), .B(n264), .Z(n257) );
  AO4 U137 ( .A(\mem[10][7] ), .B(n263), .C(\mem[8][7] ), .D(n261), .Z(n256)
         );
  AO4 U138 ( .A(\mem[9][7] ), .B(n266), .C(\mem[14][7] ), .D(n265), .Z(n255)
         );
  OR3 U139 ( .A(n257), .B(n256), .C(n255), .Z(n260) );
  AO4 U140 ( .A(\mem[13][7] ), .B(n268), .C(\mem[11][7] ), .D(n267), .Z(n259)
         );
  NR2 U141 ( .A(\mem[15][7] ), .B(n269), .Z(n258) );
  NR4 U142 ( .A(n260), .B(n259), .C(n258), .D(n277), .Z(n275) );
  OR2 U143 ( .A(\mem[0][7] ), .B(n261), .Z(n262) );
  AO3 U144 ( .A(\mem[2][7] ), .B(n263), .C(n262), .D(n277), .Z(n273) );
  AO4 U145 ( .A(\mem[6][7] ), .B(n265), .C(\mem[4][7] ), .D(n264), .Z(n272) );
  AO4 U146 ( .A(\mem[3][7] ), .B(n267), .C(\mem[1][7] ), .D(n266), .Z(n271) );
  AO4 U147 ( .A(\mem[7][7] ), .B(n269), .C(\mem[5][7] ), .D(n268), .Z(n270) );
  NR4 U148 ( .A(n273), .B(n272), .C(n271), .D(n270), .Z(n274) );
  OR2 U149 ( .A(n275), .B(n274), .Z(rdata[7]) );
  IVI U150 ( .A(N12), .Z(n276) );
  IVI U151 ( .A(N13), .Z(n277) );
  IVI U152 ( .A(N11), .Z(n278) );
  IVI U153 ( .A(N10), .Z(n279) );
  IVI U154 ( .A(n254), .Z(rdata[6]) );
  IVI U155 ( .A(n239), .Z(rdata[5]) );
  IVI U156 ( .A(n224), .Z(rdata[4]) );
  IVI U157 ( .A(n209), .Z(rdata[3]) );
  IVI U158 ( .A(n194), .Z(rdata[2]) );
  IVI U159 ( .A(n179), .Z(rdata[1]) );
  IVI U160 ( .A(n36), .Z(rdata[0]) );
  MUX21L U161 ( .A(n280), .B(n376), .S(n281), .Z(n99) );
  MUX21L U162 ( .A(n282), .B(n375), .S(n281), .Z(n98) );
  MUX21L U163 ( .A(n283), .B(n374), .S(n281), .Z(n97) );
  MUX21L U164 ( .A(n284), .B(n373), .S(n281), .Z(n96) );
  MUX21L U165 ( .A(n285), .B(n372), .S(n281), .Z(n95) );
  MUX21L U166 ( .A(n286), .B(n371), .S(n287), .Z(n94) );
  MUX21L U167 ( .A(n288), .B(n370), .S(n287), .Z(n93) );
  MUX21L U168 ( .A(n289), .B(n369), .S(n287), .Z(n92) );
  MUX21L U169 ( .A(n280), .B(n368), .S(n287), .Z(n91) );
  MUX21L U170 ( .A(n282), .B(n367), .S(n287), .Z(n90) );
  MUX21L U171 ( .A(n283), .B(n366), .S(n287), .Z(n89) );
  MUX21L U172 ( .A(n284), .B(n365), .S(n287), .Z(n88) );
  MUX21L U173 ( .A(n285), .B(n364), .S(n287), .Z(n87) );
  ND2 U174 ( .A(n290), .B(n291), .Z(n287) );
  MUX21L U175 ( .A(n286), .B(n363), .S(n292), .Z(n86) );
  MUX21L U176 ( .A(n288), .B(n362), .S(n292), .Z(n85) );
  MUX21L U177 ( .A(n289), .B(n361), .S(n292), .Z(n84) );
  MUX21L U178 ( .A(n280), .B(n360), .S(n292), .Z(n83) );
  MUX21L U179 ( .A(n282), .B(n359), .S(n292), .Z(n82) );
  MUX21L U180 ( .A(n283), .B(n358), .S(n292), .Z(n81) );
  MUX21L U181 ( .A(n284), .B(n357), .S(n292), .Z(n80) );
  MUX21L U182 ( .A(n285), .B(n356), .S(n292), .Z(n79) );
  ND2 U183 ( .A(n293), .B(n294), .Z(n292) );
  MUX21L U184 ( .A(n286), .B(n355), .S(n295), .Z(n78) );
  MUX21L U185 ( .A(n288), .B(n354), .S(n295), .Z(n77) );
  MUX21L U186 ( .A(n289), .B(n353), .S(n295), .Z(n76) );
  MUX21L U187 ( .A(n280), .B(n352), .S(n295), .Z(n75) );
  MUX21L U188 ( .A(n282), .B(n351), .S(n295), .Z(n74) );
  MUX21L U189 ( .A(n283), .B(n350), .S(n295), .Z(n73) );
  MUX21L U190 ( .A(n284), .B(n349), .S(n295), .Z(n72) );
  MUX21L U191 ( .A(n285), .B(n348), .S(n295), .Z(n71) );
  ND2 U192 ( .A(n293), .B(n290), .Z(n295) );
  MUX21L U193 ( .A(n286), .B(n347), .S(n296), .Z(n70) );
  MUX21L U194 ( .A(n288), .B(n346), .S(n296), .Z(n69) );
  MUX21L U195 ( .A(n289), .B(n345), .S(n296), .Z(n68) );
  MUX21L U196 ( .A(n280), .B(n344), .S(n296), .Z(n67) );
  MUX21L U197 ( .A(n282), .B(n343), .S(n296), .Z(n66) );
  MUX21L U198 ( .A(n283), .B(n342), .S(n296), .Z(n65) );
  MUX21L U199 ( .A(n284), .B(n341), .S(n296), .Z(n64) );
  MUX21L U200 ( .A(n285), .B(n340), .S(n296), .Z(n63) );
  ND2 U201 ( .A(n297), .B(n294), .Z(n296) );
  MUX21L U202 ( .A(n286), .B(n339), .S(n298), .Z(n62) );
  MUX21L U203 ( .A(n288), .B(n338), .S(n298), .Z(n61) );
  MUX21L U204 ( .A(n289), .B(n337), .S(n298), .Z(n60) );
  MUX21L U205 ( .A(n280), .B(n336), .S(n298), .Z(n59) );
  MUX21L U206 ( .A(n282), .B(n335), .S(n298), .Z(n58) );
  MUX21L U207 ( .A(n283), .B(n334), .S(n298), .Z(n57) );
  MUX21L U208 ( .A(n284), .B(n333), .S(n298), .Z(n56) );
  MUX21L U209 ( .A(n285), .B(n332), .S(n298), .Z(n55) );
  ND2 U210 ( .A(n297), .B(n290), .Z(n298) );
  MUX21L U211 ( .A(n286), .B(n331), .S(n299), .Z(n54) );
  MUX21L U212 ( .A(n288), .B(n330), .S(n299), .Z(n53) );
  MUX21L U213 ( .A(n289), .B(n329), .S(n299), .Z(n52) );
  MUX21L U214 ( .A(n280), .B(n328), .S(n299), .Z(n51) );
  MUX21L U215 ( .A(n282), .B(n327), .S(n299), .Z(n50) );
  MUX21L U216 ( .A(n283), .B(n326), .S(n299), .Z(n49) );
  MUX21L U217 ( .A(n284), .B(n325), .S(n299), .Z(n48) );
  MUX21L U218 ( .A(n285), .B(n324), .S(n299), .Z(n47) );
  ND2 U219 ( .A(n300), .B(n294), .Z(n299) );
  MUX21L U220 ( .A(n286), .B(n323), .S(n301), .Z(n46) );
  MUX21L U221 ( .A(n288), .B(n322), .S(n301), .Z(n45) );
  MUX21L U222 ( .A(n289), .B(n321), .S(n301), .Z(n44) );
  MUX21L U223 ( .A(n280), .B(n320), .S(n301), .Z(n43) );
  MUX21L U224 ( .A(n282), .B(n319), .S(n301), .Z(n42) );
  MUX21L U225 ( .A(n283), .B(n318), .S(n301), .Z(n41) );
  MUX21L U226 ( .A(n284), .B(n317), .S(n301), .Z(n40) );
  MUX21L U227 ( .A(n285), .B(n316), .S(n301), .Z(n39) );
  ND2 U228 ( .A(n300), .B(n290), .Z(n301) );
  AN3 U229 ( .A(wclken), .B(waddr[3]), .C(waddr[0]), .Z(n290) );
  MUX21L U230 ( .A(n286), .B(n443), .S(n302), .Z(n166) );
  MUX21L U231 ( .A(n288), .B(n442), .S(n302), .Z(n165) );
  MUX21L U232 ( .A(n289), .B(n441), .S(n302), .Z(n164) );
  MUX21L U233 ( .A(n280), .B(n440), .S(n302), .Z(n163) );
  MUX21L U234 ( .A(n282), .B(n439), .S(n302), .Z(n162) );
  MUX21L U235 ( .A(n283), .B(n438), .S(n302), .Z(n161) );
  MUX21L U236 ( .A(n284), .B(n437), .S(n302), .Z(n160) );
  MUX21L U237 ( .A(n285), .B(n436), .S(n302), .Z(n159) );
  ND2 U238 ( .A(n303), .B(n291), .Z(n302) );
  MUX21L U239 ( .A(n286), .B(n435), .S(n304), .Z(n158) );
  MUX21L U240 ( .A(n288), .B(n434), .S(n304), .Z(n157) );
  MUX21L U241 ( .A(n289), .B(n433), .S(n304), .Z(n156) );
  MUX21L U242 ( .A(n280), .B(n432), .S(n304), .Z(n155) );
  MUX21L U243 ( .A(n282), .B(n431), .S(n304), .Z(n154) );
  MUX21L U244 ( .A(n283), .B(n430), .S(n304), .Z(n153) );
  MUX21L U245 ( .A(n284), .B(n429), .S(n304), .Z(n152) );
  MUX21L U246 ( .A(n285), .B(n428), .S(n304), .Z(n151) );
  ND2 U247 ( .A(n305), .B(n291), .Z(n304) );
  MUX21L U248 ( .A(n286), .B(n427), .S(n306), .Z(n150) );
  MUX21L U249 ( .A(n288), .B(n426), .S(n306), .Z(n149) );
  MUX21L U250 ( .A(n289), .B(n425), .S(n306), .Z(n148) );
  MUX21L U251 ( .A(n280), .B(n424), .S(n306), .Z(n147) );
  MUX21L U252 ( .A(n282), .B(n423), .S(n306), .Z(n146) );
  MUX21L U253 ( .A(n283), .B(n422), .S(n306), .Z(n145) );
  MUX21L U254 ( .A(n284), .B(n421), .S(n306), .Z(n144) );
  MUX21L U255 ( .A(n285), .B(n420), .S(n306), .Z(n143) );
  ND2 U256 ( .A(n303), .B(n293), .Z(n306) );
  MUX21L U257 ( .A(n286), .B(n419), .S(n307), .Z(n142) );
  MUX21L U258 ( .A(n288), .B(n418), .S(n307), .Z(n141) );
  MUX21L U259 ( .A(n289), .B(n417), .S(n307), .Z(n140) );
  MUX21L U260 ( .A(n280), .B(n416), .S(n307), .Z(n139) );
  MUX21L U261 ( .A(n282), .B(n415), .S(n307), .Z(n138) );
  MUX21L U262 ( .A(n283), .B(n414), .S(n307), .Z(n137) );
  MUX21L U263 ( .A(n284), .B(n413), .S(n307), .Z(n136) );
  MUX21L U264 ( .A(n285), .B(n412), .S(n307), .Z(n135) );
  ND2 U265 ( .A(n305), .B(n293), .Z(n307) );
  NR2 U266 ( .A(n308), .B(waddr[2]), .Z(n293) );
  MUX21L U267 ( .A(n286), .B(n411), .S(n309), .Z(n134) );
  MUX21L U268 ( .A(n288), .B(n410), .S(n309), .Z(n133) );
  MUX21L U269 ( .A(n289), .B(n409), .S(n309), .Z(n132) );
  MUX21L U270 ( .A(n280), .B(n408), .S(n309), .Z(n131) );
  MUX21L U271 ( .A(n282), .B(n407), .S(n309), .Z(n130) );
  MUX21L U272 ( .A(n283), .B(n406), .S(n309), .Z(n129) );
  MUX21L U273 ( .A(n284), .B(n405), .S(n309), .Z(n128) );
  MUX21L U274 ( .A(n285), .B(n404), .S(n309), .Z(n127) );
  ND2 U275 ( .A(n303), .B(n297), .Z(n309) );
  MUX21L U276 ( .A(n286), .B(n403), .S(n310), .Z(n126) );
  MUX21L U277 ( .A(n288), .B(n402), .S(n310), .Z(n125) );
  MUX21L U278 ( .A(n289), .B(n401), .S(n310), .Z(n124) );
  MUX21L U279 ( .A(n280), .B(n400), .S(n310), .Z(n123) );
  MUX21L U280 ( .A(n282), .B(n399), .S(n310), .Z(n122) );
  MUX21L U281 ( .A(n283), .B(n398), .S(n310), .Z(n121) );
  MUX21L U282 ( .A(n284), .B(n397), .S(n310), .Z(n120) );
  MUX21L U283 ( .A(n285), .B(n396), .S(n310), .Z(n119) );
  ND2 U284 ( .A(n305), .B(n297), .Z(n310) );
  NR2 U285 ( .A(n311), .B(waddr[1]), .Z(n297) );
  MUX21L U286 ( .A(n286), .B(n395), .S(n312), .Z(n118) );
  MUX21L U287 ( .A(n288), .B(n394), .S(n312), .Z(n117) );
  MUX21L U288 ( .A(n289), .B(n393), .S(n312), .Z(n116) );
  MUX21L U289 ( .A(n280), .B(n392), .S(n312), .Z(n115) );
  MUX21L U290 ( .A(n282), .B(n391), .S(n312), .Z(n114) );
  MUX21L U291 ( .A(n283), .B(n390), .S(n312), .Z(n113) );
  MUX21L U292 ( .A(n284), .B(n389), .S(n312), .Z(n112) );
  MUX21L U293 ( .A(n285), .B(n388), .S(n312), .Z(n111) );
  ND2 U294 ( .A(n303), .B(n300), .Z(n312) );
  AN3 U295 ( .A(n313), .B(n314), .C(wclken), .Z(n303) );
  MUX21L U296 ( .A(n286), .B(n387), .S(n315), .Z(n110) );
  MUX21L U297 ( .A(n288), .B(n386), .S(n315), .Z(n109) );
  MUX21L U298 ( .A(n289), .B(n385), .S(n315), .Z(n108) );
  MUX21L U299 ( .A(n280), .B(n384), .S(n315), .Z(n107) );
  IV U300 ( .A(wdata[4]), .Z(n280) );
  MUX21L U301 ( .A(n282), .B(n383), .S(n315), .Z(n106) );
  IV U302 ( .A(wdata[3]), .Z(n282) );
  MUX21L U303 ( .A(n283), .B(n382), .S(n315), .Z(n105) );
  IV U304 ( .A(wdata[2]), .Z(n283) );
  MUX21L U305 ( .A(n284), .B(n381), .S(n315), .Z(n104) );
  IV U306 ( .A(wdata[1]), .Z(n284) );
  MUX21L U307 ( .A(n285), .B(n380), .S(n315), .Z(n103) );
  ND2 U308 ( .A(n305), .B(n300), .Z(n315) );
  NR2 U309 ( .A(n311), .B(n308), .Z(n300) );
  IV U310 ( .A(waddr[1]), .Z(n308) );
  IV U311 ( .A(waddr[2]), .Z(n311) );
  AN3 U312 ( .A(wclken), .B(n314), .C(waddr[0]), .Z(n305) );
  IV U313 ( .A(waddr[3]), .Z(n314) );
  IV U314 ( .A(wdata[0]), .Z(n285) );
  MUX21L U315 ( .A(n286), .B(n379), .S(n281), .Z(n102) );
  IV U316 ( .A(wdata[7]), .Z(n286) );
  MUX21L U317 ( .A(n288), .B(n378), .S(n281), .Z(n101) );
  IV U318 ( .A(wdata[6]), .Z(n288) );
  MUX21L U319 ( .A(n289), .B(n377), .S(n281), .Z(n100) );
  ND2 U320 ( .A(n294), .B(n291), .Z(n281) );
  NR2 U321 ( .A(waddr[2]), .B(waddr[1]), .Z(n291) );
  AN3 U322 ( .A(waddr[3]), .B(n313), .C(wclken), .Z(n294) );
  IV U323 ( .A(waddr[0]), .Z(n313) );
  IV U324 ( .A(wdata[5]), .Z(n289) );
endmodule


module wptr_full ( wfull, waddr, wptr, wrptr2, winc, wclk, wrst_n );
  output [3:0] waddr;
  output [4:0] wptr;
  input [4:0] wrptr2;
  input winc, wclk, wrst_n;
  output wfull;
  wire   \waddr[2] , \waddr[1] , \waddr[0] , N2, N10, n1, n2, n3, n4, n5, n6,
         n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21;
  wire   [4:0] wgnext;
  assign wptr[2] = \waddr[2] ;
  assign waddr[2] = \waddr[2] ;
  assign wptr[1] = \waddr[1] ;
  assign waddr[1] = \waddr[1] ;
  assign wptr[0] = \waddr[0] ;
  assign waddr[0] = \waddr[0] ;

  FD2 wfull_reg ( .D(N10), .CP(wclk), .CD(wrst_n), .Q(wfull), .QN(n21) );
  FD2 \wptr_reg[0]  ( .D(wgnext[0]), .CP(wclk), .CD(wrst_n), .Q(\waddr[0] ) );
  FD2 \wptr_reg[1]  ( .D(wgnext[1]), .CP(wclk), .CD(wrst_n), .Q(\waddr[1] ) );
  FD2 waddrmsb_reg ( .D(N2), .CP(wclk), .CD(wrst_n), .Q(waddr[3]) );
  FD2 \wptr_reg[2]  ( .D(wgnext[2]), .CP(wclk), .CD(wrst_n), .Q(\waddr[2] ) );
  FD2 \wptr_reg[4]  ( .D(wgnext[4]), .CP(wclk), .CD(wrst_n), .Q(wptr[4]) );
  FD2 \wptr_reg[3]  ( .D(wgnext[3]), .CP(wclk), .CD(wrst_n), .Q(wptr[3]), .QN(
        n20) );
  EO U3 ( .A(wgnext[4]), .B(N2), .Z(wgnext[3]) );
  NR4 U4 ( .A(n1), .B(n2), .C(n3), .D(n4), .Z(N10) );
  EO U5 ( .A(N2), .B(n5), .Z(n4) );
  EO U6 ( .A(wrptr2[4]), .B(wrptr2[3]), .Z(n5) );
  EO U7 ( .A(wrptr2[2]), .B(wgnext[2]), .Z(n3) );
  EO U8 ( .A(n6), .B(N2), .Z(wgnext[2]) );
  EO U9 ( .A(n7), .B(n8), .Z(N2) );
  ND2 U10 ( .A(n9), .B(n10), .Z(n2) );
  EO U11 ( .A(wrptr2[4]), .B(wgnext[4]), .Z(n10) );
  EO U12 ( .A(wptr[4]), .B(n11), .Z(wgnext[4]) );
  NR2 U13 ( .A(n8), .B(n7), .Z(n11) );
  ND2 U14 ( .A(n12), .B(n13), .Z(n7) );
  EN U15 ( .A(wgnext[1]), .B(wrptr2[1]), .Z(n9) );
  EO U16 ( .A(n14), .B(n6), .Z(wgnext[1]) );
  EO U17 ( .A(n12), .B(n13), .Z(n6) );
  AN2 U18 ( .A(n15), .B(n16), .Z(n12) );
  EO U19 ( .A(wrptr2[0]), .B(wgnext[0]), .Z(n1) );
  EN U20 ( .A(n17), .B(n14), .Z(wgnext[0]) );
  EO U21 ( .A(n15), .B(n16), .Z(n14) );
  NR2 U22 ( .A(n18), .B(n19), .Z(n15) );
  EN U23 ( .A(n19), .B(n18), .Z(n17) );
  ND2 U24 ( .A(winc), .B(n21), .Z(n18) );
  EN U25 ( .A(n16), .B(\waddr[0] ), .Z(n19) );
  EO U26 ( .A(n13), .B(\waddr[1] ), .Z(n16) );
  EN U27 ( .A(n8), .B(\waddr[2] ), .Z(n13) );
  EO U28 ( .A(n20), .B(wptr[4]), .Z(n8) );
endmodule


module rptr_empty ( rempty, raddr, rptr, rwptr2, rinc, rclk, rrst_n );
  output [3:0] raddr;
  output [4:0] rptr;
  input [4:0] rwptr2;
  input rinc, rclk, rrst_n;
  output rempty;
  wire   \raddr[2] , \raddr[1] , \raddr[0] , N1, N4, n1, n2, n3, n4, n5, n6,
         n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;
  wire   [4:0] rgnext;
  assign rptr[2] = \raddr[2] ;
  assign raddr[2] = \raddr[2] ;
  assign rptr[1] = \raddr[1] ;
  assign raddr[1] = \raddr[1] ;
  assign rptr[0] = \raddr[0] ;
  assign raddr[0] = \raddr[0] ;

  FD4 rempty_reg ( .D(N4), .CP(rclk), .SD(rrst_n), .Q(rempty), .QN(n20) );
  FD2 \rptr_reg[0]  ( .D(rgnext[0]), .CP(rclk), .CD(rrst_n), .Q(\raddr[0] ) );
  FD2 \rptr_reg[1]  ( .D(rgnext[1]), .CP(rclk), .CD(rrst_n), .Q(\raddr[1] ) );
  FD2 raddrmsb_reg ( .D(N1), .CP(rclk), .CD(rrst_n), .Q(raddr[3]) );
  FD2 \rptr_reg[2]  ( .D(rgnext[2]), .CP(rclk), .CD(rrst_n), .Q(\raddr[2] ) );
  FD2 \rptr_reg[4]  ( .D(rgnext[4]), .CP(rclk), .CD(rrst_n), .Q(rptr[4]) );
  FD2 \rptr_reg[3]  ( .D(rgnext[3]), .CP(rclk), .CD(rrst_n), .Q(rptr[3]), .QN(
        n19) );
  NR4 U3 ( .A(n1), .B(n2), .C(n3), .D(n4), .Z(N4) );
  EO U4 ( .A(rwptr2[4]), .B(rgnext[4]), .Z(n4) );
  EO U5 ( .A(rwptr2[3]), .B(rgnext[3]), .Z(n3) );
  EO U6 ( .A(N1), .B(rgnext[4]), .Z(rgnext[3]) );
  EO U7 ( .A(rptr[4]), .B(n5), .Z(rgnext[4]) );
  NR2 U8 ( .A(n6), .B(n7), .Z(n5) );
  ND2 U9 ( .A(n8), .B(n9), .Z(n2) );
  EN U10 ( .A(rgnext[1]), .B(rwptr2[1]), .Z(n9) );
  EO U11 ( .A(n10), .B(n11), .Z(rgnext[1]) );
  EN U12 ( .A(rgnext[2]), .B(rwptr2[2]), .Z(n8) );
  EO U13 ( .A(n11), .B(N1), .Z(rgnext[2]) );
  EO U14 ( .A(n12), .B(n13), .Z(n11) );
  EO U15 ( .A(rwptr2[0]), .B(rgnext[0]), .Z(n1) );
  EN U16 ( .A(n14), .B(n10), .Z(rgnext[0]) );
  EO U17 ( .A(n15), .B(n16), .Z(n10) );
  EN U18 ( .A(n17), .B(n18), .Z(n14) );
  EO U19 ( .A(n7), .B(n6), .Z(N1) );
  ND2 U20 ( .A(n12), .B(n13), .Z(n7) );
  AN2 U21 ( .A(n15), .B(n16), .Z(n12) );
  NR2 U22 ( .A(n18), .B(n17), .Z(n15) );
  EN U23 ( .A(n16), .B(\raddr[0] ), .Z(n17) );
  EO U24 ( .A(n13), .B(\raddr[1] ), .Z(n16) );
  EN U25 ( .A(n6), .B(\raddr[2] ), .Z(n13) );
  EO U26 ( .A(n19), .B(rptr[4]), .Z(n6) );
  ND2 U27 ( .A(rinc), .B(n20), .Z(n18) );
endmodule


module sync_r2w ( wptr_sync, rptr, wclk, wrst_n );
  output [4:0] wptr_sync;
  input [4:0] rptr;
  input wclk, wrst_n;
  wire   n1, n2;
  wire   [4:0] sync1;

  FD2 \sync1_reg[4]  ( .D(rptr[4]), .CP(n1), .CD(wrst_n), .Q(sync1[4]) );
  FD2 \sync1_reg[3]  ( .D(rptr[3]), .CP(n1), .CD(wrst_n), .Q(sync1[3]) );
  FD2 \sync1_reg[2]  ( .D(rptr[2]), .CP(n1), .CD(wrst_n), .Q(sync1[2]) );
  FD2 \sync1_reg[1]  ( .D(rptr[1]), .CP(n1), .CD(wrst_n), .Q(sync1[1]) );
  FD2 \sync1_reg[0]  ( .D(rptr[0]), .CP(n1), .CD(wrst_n), .Q(sync1[0]) );
  FD2 \wptr_sync_reg[4]  ( .D(sync1[4]), .CP(n1), .CD(wrst_n), .Q(wptr_sync[4]) );
  FD2 \wptr_sync_reg[3]  ( .D(sync1[3]), .CP(n1), .CD(wrst_n), .Q(wptr_sync[3]) );
  FD2 \wptr_sync_reg[2]  ( .D(sync1[2]), .CP(n1), .CD(wrst_n), .Q(wptr_sync[2]) );
  FD2 \wptr_sync_reg[1]  ( .D(sync1[1]), .CP(n1), .CD(wrst_n), .Q(wptr_sync[1]) );
  FD2 \wptr_sync_reg[0]  ( .D(sync1[0]), .CP(n1), .CD(wrst_n), .Q(wptr_sync[0]) );
  IVI U3 ( .A(n2), .Z(n1) );
  IVI U4 ( .A(wclk), .Z(n2) );
endmodule


module sync_w2r ( rptr_sync, wptr, rclk, rrst_n );
  output [4:0] rptr_sync;
  input [4:0] wptr;
  input rclk, rrst_n;

  wire   [4:0] sync1;

  FD2 \sync1_reg[4]  ( .D(wptr[4]), .CP(rclk), .CD(rrst_n), .Q(sync1[4]) );
  FD2 \sync1_reg[3]  ( .D(wptr[3]), .CP(rclk), .CD(rrst_n), .Q(sync1[3]) );
  FD2 \sync1_reg[2]  ( .D(wptr[2]), .CP(rclk), .CD(rrst_n), .Q(sync1[2]) );
  FD2 \sync1_reg[1]  ( .D(wptr[1]), .CP(rclk), .CD(rrst_n), .Q(sync1[1]) );
  FD2 \sync1_reg[0]  ( .D(wptr[0]), .CP(rclk), .CD(rrst_n), .Q(sync1[0]) );
  FD2 \rptr_sync_reg[4]  ( .D(sync1[4]), .CP(rclk), .CD(rrst_n), .Q(
        rptr_sync[4]) );
  FD2 \rptr_sync_reg[3]  ( .D(sync1[3]), .CP(rclk), .CD(rrst_n), .Q(
        rptr_sync[3]) );
  FD2 \rptr_sync_reg[2]  ( .D(sync1[2]), .CP(rclk), .CD(rrst_n), .Q(
        rptr_sync[2]) );
  FD2 \rptr_sync_reg[1]  ( .D(sync1[1]), .CP(rclk), .CD(rrst_n), .Q(
        rptr_sync[1]) );
  FD2 \rptr_sync_reg[0]  ( .D(sync1[0]), .CP(rclk), .CD(rrst_n), .Q(
        rptr_sync[0]) );
endmodule


module fifo ( clk1, wrst_n, clk2, rrst_n, winc, rinc, wdata, rdata, wfull, 
        rempty );
  input [7:0] wdata;
  output [7:0] rdata;
  input clk1, wrst_n, clk2, rrst_n, winc, rinc;
  output wfull, rempty;
  wire   _0_net_, n2;
  wire   [3:0] waddr;
  wire   [3:0] raddr;
  wire   [4:0] wptr;
  wire   [4:0] wrptr2;
  wire   [4:0] rptr;
  wire   [4:0] rwptr2;

  fifomem mem_inst ( .rdata(rdata), .wdata(wdata), .waddr(waddr), .raddr(raddr), .wclken(_0_net_), .wclk(clk1) );
  wptr_full wptr_full_inst ( .wfull(wfull), .waddr(waddr), .wptr(wptr), 
        .wrptr2(wrptr2), .winc(winc), .wclk(clk1), .wrst_n(wrst_n) );
  rptr_empty rptr_empty_inst ( .rempty(rempty), .raddr(raddr), .rptr(rptr), 
        .rwptr2(rwptr2), .rinc(rinc), .rclk(clk2), .rrst_n(rrst_n) );
  sync_r2w sync_r2w_inst ( .wptr_sync(wrptr2), .rptr(rptr), .wclk(clk1), 
        .wrst_n(wrst_n) );
  sync_w2r sync_w2r_inst ( .rptr_sync(rwptr2), .wptr(wptr), .rclk(clk2), 
        .rrst_n(rrst_n) );
  NR2 U3 ( .A(wfull), .B(n2), .Z(_0_net_) );
  IV U4 ( .A(winc), .Z(n2) );
endmodule

