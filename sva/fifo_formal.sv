// Formal-only data-integrity check for the async FIFO (used by
// formal/jasper/fifo.tcl). Replaces the simulation scoreboard queue in
// fifo_sva.sv, which a formal tool cannot model.
//
// Symbolic tracked word: the solver picks one accepted write (any write, at
// any time, through `pick`, a free input). Its data and its write number are
// recorded. The read with the same read number must return that data. Since
// the choice is arbitrary, a proof covers every write: data is neither lost,
// corrupted, duplicated, nor reordered.

module fifo_formal #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
) (
    input              clk1, clk2, wrst_n, rrst_n,
    input              winc, rinc, wfull, rempty,
    input [DSIZE-1:0]  wdata, rdata,
    input              pick              // free: left undriven, cut in the tcl
);
    localparam CW = ASIZE + 3;           // counters wrap well past FIFO depth

    logic [CW-1:0]    wr_cnt, rd_cnt, tracked_num;
    logic [DSIZE-1:0] tracked_data;
    logic             armed;
    logic             checked;           // the tracked read has happened

    wire wr_fire = winc && !wfull;
    wire rd_fire = rinc && !rempty;

    always_ff @(posedge clk1 or negedge wrst_n)
        if (!wrst_n) begin
            wr_cnt <= '0;
            armed  <= 1'b0;
        end else if (wr_fire) begin
            wr_cnt <= wr_cnt + 1'b1;
            if (!armed && pick) begin
                armed        <= 1'b1;
                tracked_num  <= wr_cnt;
                tracked_data <= wdata;
            end
        end

    // The read whose number matches is the tracked word's read. Only the
    // first match counts: the counter wraps, so later reads reuse the number.
    wire tracked_read = armed && !checked && rd_fire && rd_cnt == tracked_num;

    always_ff @(posedge clk2 or negedge rrst_n)
        if (!rrst_n) begin
            rd_cnt  <= '0;
            checked <= 1'b0;
        end else if (rd_fire) begin
            rd_cnt <= rd_cnt + 1'b1;
            if (tracked_read) checked <= 1'b1;
        end

    // The tracked word comes out intact and in order.
    a_data_integrity: assert property (
        @(posedge clk2) disable iff (!wrst_n || !rrst_n)
        tracked_read |-> rdata == tracked_data
    );

    // Never more words read than written, never more in flight than depth.
    a_no_underflow: assert property (
        @(posedge clk2) disable iff (!wrst_n || !rrst_n)
        CW'(wr_cnt - rd_cnt) <= CW'(1 << ASIZE)
    );

    c_tracked_read: cover property (
        @(posedge clk2) tracked_read && tracked_num > 2
    );
endmodule

bind fifo fifo_formal #(.DSIZE(DSIZE), .ASIZE(ASIZE)) u_fifo_formal (
    .clk1 (clk1), .clk2 (clk2), .wrst_n (wrst_n), .rrst_n (rrst_n),
    .winc (winc), .rinc (rinc), .wfull (wfull), .rempty (rempty),
    .wdata (wdata), .rdata (rdata), .pick ()
);
