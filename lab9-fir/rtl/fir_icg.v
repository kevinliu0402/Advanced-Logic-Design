// ============================================================================
// Integrated clock-gating cell (latch + AND), behavioral model
// ============================================================================
// Author: Kevin Liu
// UNI: kl3755
// ============================================================================
// The enable is captured by a latch that is transparent while clk is low, so
// it cannot change while clk is high and the gated clock never glitches.
// test_en forces the clock on for scan. In synthesis this module should be
// replaced by the library's ICG cell (e.g. with set_dont_touch on a mapped
// instance), or removed in favour of compile -gate_clock.
// ============================================================================

`timescale 1ns/1ps

module fir_icg (
    input  wire clk,
    input  wire en,
    input  wire test_en,
    output wire gclk
);

    reg en_latched;

    /* verilator lint_off LATCH */
    always @(*) begin
        if (!clk)
            en_latched = en | test_en;
    end
    /* verilator lint_on LATCH */

    assign gclk = clk & en_latched;

endmodule
