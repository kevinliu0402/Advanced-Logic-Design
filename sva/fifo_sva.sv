// Concurrent assertions for the async FIFO in src/fifo.v.
//
// This file is not part of the synthesizable design. `bind` attaches the
// checkers underneath the existing modules at elaboration, so the RTL does
// not have to change.
//
// Every property below is clocked by exactly one clock. That is the form
// Verilator can run, and it is also the form that stays meaningful for a
// design with two clock domains. A single property must not mix clk1 and clk2.

`timescale 1ns/1ps

// ---------------------------------------------------------------------------
// Top-level FIFO checks: protocol, Gray pointers, reset, scoreboard, covers.
// ---------------------------------------------------------------------------
module fifo_sva #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
) (
    input                     clk1,
    input                     clk2,
    input                     wrst_n,
    input                     rrst_n,
    input                     winc,
    input                     rinc,
    input      [DSIZE-1:0]    wdata,
    input      [DSIZE-1:0]    rdata,
    input                     wfull,
    input                     rempty,
    input      [ASIZE:0]      wptr,
    input      [ASIZE:0]      rptr
);
    bit cov_full;
    bit cov_left_empty;
    bit cov_full_to_empty;
    bit seen_full;

    // Scoreboard. Pushed in the write domain, popped in the read domain.
    // A temporal SVA property cannot do this by itself: several words can be
    // in flight, and the read that matches a given write happens a variable
    // number of read-clocks later. A queue is the usual model for that.
`ifndef FORMAL
    // Formal tools cannot model a queue; sva/fifo_formal.sv proves data
    // order there with a symbolic tracked word instead.
    logic [DSIZE-1:0] exp_q[$];
`endif

    // Interface rules. These constrain the testbench, not the RTL.
    // `assert` makes a bad driver fail in simulation. Wrap them in
    // `assume property` if you move the same checks into a formal tool:
    // formal assumptions restrict the environment, they do not test it.
    a_no_write_when_full: assert property (
        @(posedge clk1) disable iff (!wrst_n) wfull |-> !winc
    ) else $error("write while full");

    a_no_read_when_empty: assert property (
        @(posedge clk2) disable iff (!rrst_n) rempty |-> !rinc
    ) else $error("read while empty");

    // Reset values. Sampled on a clock while reset is held, and again on the
    // first clock where that reset is released.
    a_wfull_during_reset: assert property (
        @(posedge clk1) !wrst_n |-> !wfull
    ) else $error("wfull was high in reset");

    a_rempty_during_reset: assert property (
        @(posedge clk2) !rrst_n |-> rempty
    ) else $error("rempty was low in reset");

    a_wfull_after_reset: assert property (
        @(posedge clk1) $rose(wrst_n) |-> !wfull
    ) else $error("wfull was high coming out of reset");

    a_rempty_after_reset: assert property (
        @(posedge clk2) $rose(rrst_n) |-> rempty
    ) else $error("rempty was low coming out of reset");

    // Gray-code safety. Sampled values are the values *before* the clock
    // edge, so `wptr ^ $past(wptr)` is the step taken by the previous edge.
    // $past(wrst_n) skips the first cycle out of reset, where $past(wptr)
    // still belongs to the reset value and is not a real step.
    //
    // This is intentionally on wptr/rptr, the pointers in their own clock
    // domain. The synchronized copies (wrptr2, rwptr2) can change by several
    // bits in one receiving clock when the sending clock is faster, because
    // several legal one-bit steps happened between two samples.
    a_wptr_gray: assert property (
        @(posedge clk1) disable iff (!wrst_n)
        $past(wrst_n) |-> ($countones(wptr ^ $past(wptr)) <= 1)
    ) else $error("wptr changed by more than one bit");

    a_rptr_gray: assert property (
        @(posedge clk2) disable iff (!rrst_n)
        $past(rrst_n) |-> ($countones(rptr ^ $past(rptr)) <= 1)
    ) else $error("rptr changed by more than one bit");

    // |=> evaluates the right-hand side one clock later. $stable there means
    // "the update caused by *this* clock did not change the pointer".
    // |-> $stable would be one cycle early: it would describe the previous
    // update, not the winc being sampled now.
    a_wptr_holds: assert property (
        @(posedge clk1) disable iff (!wrst_n)
        $past(wrst_n) && (!winc || wfull) |=> $stable(wptr)
    ) else $error("wptr moved with no accepted write");

    a_rptr_holds: assert property (
        @(posedge clk2) disable iff (!rrst_n)
        $past(rrst_n) && (!rinc || rempty) |=> $stable(rptr)
    ) else $error("rptr moved with no accepted read");

    // An accepted write/read steps the binary pointer by one, so the Gray
    // pointer changes by exactly one bit.
    a_wptr_steps: assert property (
        @(posedge clk1) disable iff (!wrst_n)
        (winc && !wfull) |=> ($countones(wptr ^ $past(wptr)) == 1)
    ) else $error("accepted write did not step wptr by one Gray bit");

    a_rptr_steps: assert property (
        @(posedge clk2) disable iff (!rrst_n)
        (rinc && !rempty) |=> ($countones(rptr ^ $past(rptr)) == 1)
    ) else $error("accepted read did not step rptr by one Gray bit");

    // wfull and rempty are allowed to both be 1 for a few cycles. Each flag
    // is conservative until the other pointer crosses its synchronizer, so a
    // fast drain can show empty on the read side before the write side drops
    // full. Do not assert !(wfull && rempty).

    always @(posedge clk1 or negedge wrst_n) begin
        if (!wrst_n) begin
`ifndef FORMAL
            exp_q.delete();
`endif
            seen_full <= 1'b0;
        end else begin
            if (wfull)
                seen_full <= 1'b1;
`ifndef FORMAL
            if (winc && !wfull)
                exp_q.push_back(wdata);
`endif
        end
    end

`ifndef FORMAL
    always @(posedge clk2) begin
        if (rrst_n && wrst_n && rinc && !rempty) begin
            a_scoreboard_not_empty: assert (exp_q.size() != 0)
                else $error("read with an empty scoreboard");
            if (exp_q.size() != 0) begin
                a_data_order: assert (rdata === exp_q[0])
                    else $error("FIFO data mismatch: got %h expected %h", rdata, exp_q[0]);
                exp_q.pop_front();
            end
        end
    end
`endif

    c_reached_full: cover property (@(posedge clk1) $rose(wfull))
        cov_full = 1'b1;

    // Fell, rather than "rempty is high": reset already holds rempty high,
    // so a level cover would pass without the FIFO ever going empty *again*.
    c_left_empty: cover property (@(posedge clk2) $fell(rempty))
        cov_left_empty = 1'b1;

    c_full_then_empty: cover property (
        @(posedge clk2) seen_full && $rose(rempty) && $past(rrst_n)
    ) cov_full_to_empty = 1'b1;

endmodule

bind fifo fifo_sva #(
    .DSIZE(DSIZE),
    .ASIZE(ASIZE)
) u_fifo_sva (
    .clk1    (clk1),
    .clk2    (clk2),
    .wrst_n  (wrst_n),
    .rrst_n  (rrst_n),
    .winc    (winc),
    .rinc    (rinc),
    .wdata   (wdata),
    .rdata   (rdata),
    .wfull   (wfull),
    .rempty  (rempty),
    .wptr    (wptr),
    .rptr    (rptr)
);

// ---------------------------------------------------------------------------
// 2-flop synchronizers. $past here is in the *receiving* clock, so it means
// "the value this clock sampled two edges ago", which is exactly what a
// 2-flop synchronizer is supposed to hold.
// ---------------------------------------------------------------------------
module sync_w2r_sva #(
    parameter ADDRSIZE = 4
) (
    input                      rclk,
    input                      rrst_n,
    input      [ADDRSIZE:0]    wptr,
    input      [ADDRSIZE:0]    rptr_sync
);
    // Both of the previous receiving clocks have to be out of reset.
    // $past(rrst_n, 2) alone would still pass a cycle where reset was low
    // in between, and the two flops would not be holding wptr from then.
    a_w2r_delay: assert property (
        @(posedge rclk) disable iff (!rrst_n)
        ($past(rrst_n) && $past(rrst_n, 2)) |-> (rptr_sync == $past(wptr, 2))
    ) else $error("sync_w2r is not a 2-flop delay of wptr");

    a_w2r_reset: assert property (
        @(posedge rclk) !rrst_n |-> (rptr_sync == '0)
    ) else $error("sync_w2r did not reset to 0");
endmodule

module sync_r2w_sva #(
    parameter ADDRSIZE = 4
) (
    input                      wclk,
    input                      wrst_n,
    input      [ADDRSIZE:0]    rptr,
    input      [ADDRSIZE:0]    wptr_sync
);
    a_r2w_delay: assert property (
        @(posedge wclk) disable iff (!wrst_n)
        ($past(wrst_n) && $past(wrst_n, 2)) |-> (wptr_sync == $past(rptr, 2))
    ) else $error("sync_r2w is not a 2-flop delay of rptr");

    a_r2w_reset: assert property (
        @(posedge wclk) !wrst_n |-> (wptr_sync == '0)
    ) else $error("sync_r2w did not reset to 0");
endmodule

bind sync_w2r sync_w2r_sva #(.ADDRSIZE(ADDRSIZE)) u_sync_w2r_sva (
    .rclk      (rclk),
    .rrst_n    (rrst_n),
    .wptr      (wptr),
    .rptr_sync (rptr_sync)
);

bind sync_r2w sync_r2w_sva #(.ADDRSIZE(ADDRSIZE)) u_sync_r2w_sva (
    .wclk      (wclk),
    .wrst_n    (wrst_n),
    .rptr      (rptr),
    .wptr_sync (wptr_sync)
);
