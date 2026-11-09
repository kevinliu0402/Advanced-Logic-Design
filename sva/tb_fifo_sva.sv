// Stimulus for the async FIFO. The assertions live in fifo_sva.sv and are
// attached with bind, so this file only has to obey the interface rules:
// do not write while wfull, do not read while rempty.
//
// Clock edges are placed so a posedge of clk1 never lands on a posedge of
// clk2 (8ns vs 12ns, read clock offset by 1ns). The scoreboard pushes on
// one clock and pops on the other; coincident edges would race the queue.

`timescale 1ns/1ps

module tb_fifo_sva;
    localparam DSIZE = 8;
    localparam ASIZE = 4;
    localparam DEPTH = 1 << ASIZE;

    logic             clk1, clk2;
    logic             wrst_n, rrst_n;
    logic             winc, rinc;
    logic [DSIZE-1:0] wdata, rdata;
    logic             wfull, rempty;

    fifo #(.DSIZE(DSIZE), .ASIZE(ASIZE)) dut (
        .clk1   (clk1),
        .wrst_n (wrst_n),
        .clk2   (clk2),
        .rrst_n (rrst_n),
        .winc   (winc),
        .rinc   (rinc),
        .wdata  (wdata),
        .rdata  (rdata),
        .wfull  (wfull),
        .rempty (rempty)
    );

    initial clk1 = 1'b0;
    always #4 clk1 = ~clk1;

    initial begin
        clk2 = 1'b0;
        #1;
        forever #6 clk2 = ~clk2;
    end

    task automatic write_byte(input logic [DSIZE-1:0] data);
        @(negedge clk1);
        while (wfull) @(negedge clk1);
        wdata <= data;
        winc  <= 1'b1;
        @(negedge clk1);
        winc  <= 1'b0;
    endtask

    task automatic read_byte();
        @(negedge clk2);
        while (rempty) @(negedge clk2);
        rinc <= 1'b1;
        @(negedge clk2);
        rinc <= 1'b0;
    endtask

    initial begin
        wrst_n = 1'b0;
        rrst_n = 1'b0;
        winc   = 1'b0;
        rinc   = 1'b0;
        wdata  = '0;

        repeat (4) @(posedge clk1);
        repeat (4) @(posedge clk2);
        wrst_n = 1'b1;
        rrst_n = 1'b1;
        repeat (2) @(posedge clk1);

        // A few ordered words, then a fill and a drain. The fill is what
        // hits the "full" cover; the drain is what hits "full then empty".
        for (int i = 0; i < 5; i++)
            write_byte(8'hA0 + i);
        repeat (6) @(posedge clk2);
        for (int i = 0; i < 5; i++)
            read_byte();

        for (int i = 0; i < DEPTH; i++)
            write_byte(8'h10 + i);
        @(negedge clk1);
        if (!wfull)
            $fatal(1, "expected wfull after %0d writes", DEPTH);

        repeat (4) @(posedge clk2);
        for (int i = 0; i < DEPTH; i++)
            read_byte();
        @(negedge clk2);
        if (!rempty)
            $fatal(1, "expected rempty after draining");

        // Let the |=> pointer checks and the cover action blocks finish.
        repeat (4) @(posedge clk1);
        repeat (4) @(posedge clk2);

        if (!dut.u_fifo_sva.cov_full)
            $fatal(1, "cover: FIFO never went full");
        if (!dut.u_fifo_sva.cov_left_empty)
            $fatal(1, "cover: FIFO never left empty");
        if (!dut.u_fifo_sva.cov_full_to_empty)
            $fatal(1, "cover: FIFO never went from full back to empty");

        $display("SVA PASS fifo");
        $finish;
    end

    initial begin
        #100000;
        $fatal(1, "fifo SVA test timed out");
    end
endmodule
