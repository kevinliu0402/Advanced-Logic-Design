// Concurrent assertions for rtl/fir_core.v.
// Bound in, so the Lab 9 RTL stays synthesizable and unchanged.
//
// Two of the checks that are tempting here do not match this RTL:
//
//   * The state register is binary, 2 bits, and all four codes are used
//     (IDLE=0, STORE=1, COMPUTE=2, OUTPUT=3). A one-hot assertion
//     ($countones(state) == 1) is for an encoding this module does not have,
//     and it would fail on IDLE. The real FSM check is the legal transitions.
//
//   * tap_counter is ADDR_WIDTH bits (6). It cannot hold 64. The COMPUTE
//     increment is `tap_counter + 1` while tap_counter < NUM_TAPS, so the
//     step from 63 wraps to 0 instead of landing on 64. "never past 63"
//     is true, and it is true because of the width, not because the
//     increment stops at 63. The exit condition uses tap_counter_d1 == 63,
//     which is reached on the cycle before that wrap.

`timescale 1ns/1ps

module fir_core_sva #(
    parameter NUM_TAPS   = 64,
    parameter DATA_WIDTH = 16,
    parameter ADDR_WIDTH = 6
) (
    input                          clk,
    input                          rstn,
    input                          sample_valid,
    input                          sample_ready,
    input      [DATA_WIDTH-1:0]    sample_in,
    input                          output_valid,
    input                          busy,
    input      [1:0]               state,
    input      [ADDR_WIDTH-1:0]    tap_counter
);
    localparam IDLE    = 2'd0;
    localparam STORE   = 2'd1;
    localparam COMPUTE = 2'd2;
    localparam OUTPUT  = 2'd3;

    // Accept is sampled in IDLE. The core then takes
    //   1 STORE cycle + (NUM_TAPS + 1) COMPUTE cycles + the OUTPUT cycle
    // and output_valid is a registered pulse, so it is visible one clock
    // after OUTPUT. That is NUM_TAPS + 4 clocks after the accept.
    // For the default 64-tap core this is ##68.
    localparam int OUT_LAT = NUM_TAPS + 4;

    bit cov_output;
    bit cov_last_tap;

    a_idle_next: assert property (
        @(posedge clk) disable iff (!rstn)
        (state == IDLE) |=> (state == IDLE || state == STORE)
    ) else $error("illegal transition out of IDLE");

    a_store_next: assert property (
        @(posedge clk) disable iff (!rstn)
        (state == STORE) |=> (state == COMPUTE)
    ) else $error("STORE did not go to COMPUTE");

    a_compute_next: assert property (
        @(posedge clk) disable iff (!rstn)
        (state == COMPUTE) |=> (state == COMPUTE || state == OUTPUT)
    ) else $error("illegal transition out of COMPUTE");

    a_output_next: assert property (
        @(posedge clk) disable iff (!rstn)
        (state == OUTPUT) |=> (state == IDLE)
    ) else $error("OUTPUT did not return to IDLE");

    // Handshake. sample_ready is high only in IDLE, so once a sample has
    // been accepted the producer has to hold sample_in and sample_valid
    // until the core is idle again. This is a driver rule, checked as an
    // assert so a testbench that drops the input mid-compute fails here.
    a_hold_while_busy: assert property (
        @(posedge clk) disable iff (!rstn)
        (sample_valid && !sample_ready) |=> ($stable(sample_in) && sample_valid)
    ) else $error("sample_in/sample_valid changed while the core was not ready");

    a_ready_matches_idle: assert property (
        @(posedge clk) disable iff (!rstn)
        sample_ready == (state == IDLE)
    ) else $error("sample_ready is not tied to IDLE");

    a_busy_matches_state: assert property (
        @(posedge clk) disable iff (!rstn)
        busy == (state != IDLE)
    ) else $error("busy is not tied to a non-IDLE state");

    // Cycle 0 of this sequence is the accept cycle, where output_valid may
    // still be high from the previous sample (back-to-back accepts land on
    // the same IDLE cycle as the previous pulse). From the next cycle the
    // line must stay low until exactly OUT_LAT.
    a_output_latency: assert property (
        @(posedge clk) disable iff (!rstn)
        (sample_valid && sample_ready)
            |-> ##1 (!output_valid)[*(OUT_LAT-1)] ##1 output_valid
    ) else $error("output_valid was not exactly %0d cycles after accept", OUT_LAT);

    a_output_is_a_pulse: assert property (
        @(posedge clk) disable iff (!rstn)
        output_valid |=> !output_valid
    ) else $error("output_valid stayed high for more than one cycle");

    // < NUM_TAPS, i.e. <= 63. A 6-bit vector satisfies this on its own;
    // the useful companion is that the counter steps by 0 or +1, or wraps
    // back to 0 (the 63 -> 0 truncation, or the clear in IDLE).
    a_tap_counter_range: assert property (
        @(posedge clk) disable iff (!rstn)
        tap_counter < NUM_TAPS
    ) else $error("tap_counter went past %0d", NUM_TAPS-1);

    a_tap_counter_step: assert property (
        @(posedge clk) disable iff (!rstn)
        $past(rstn) |-> (
            (tap_counter == $past(tap_counter)) ||
            (tap_counter == ADDR_WIDTH'($past(tap_counter) + 1'b1)) ||
            (tap_counter == '0)
        )
    ) else $error("tap_counter jumped");

    c_saw_output: cover property (@(posedge clk) output_valid)
        cov_output = 1'b1;

    c_last_tap: cover property (@(posedge clk) tap_counter == NUM_TAPS-1)
        cov_last_tap = 1'b1;

endmodule

bind fir_core fir_core_sva #(
    .NUM_TAPS   (NUM_TAPS),
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
) u_fir_core_sva (
    .clk           (clk),
    .rstn          (rstn),
    .sample_valid  (sample_valid),
    .sample_ready  (sample_ready),
    .sample_in     (sample_in),
    .output_valid  (output_valid),
    .busy          (busy),
    .state         (state),
    .tap_counter   (tap_counter)
);
