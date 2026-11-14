// ============================================================================
// Power controller for the switchable MAC power domain (PD_MAC)
// ============================================================================
// Author: Kevin Liu
// UNI: kl3755
// ============================================================================
// Lives in the always-on domain. Drives the PD_MAC power switch (pwr_on) and
// the isolation enable on PD_MAC outputs (iso_en); see fir_core.upf.
//
//   OFF   : switch off, isolation on.
//   WAKE  : switch on, isolation still on, wait WAKE_CYCLES for the rail.
//   ON    : isolation off, domain usable (pwr_ready = 1).
//   SLEEP : isolation back on for one cycle, then the switch turns off.
//
// The domain is requested whenever the core is busy or a sample is offered,
// and is shut down after IDLE_TIMEOUT idle cycles. The accumulator is cleared
// at the start of every sample, so PD_MAC needs no retention.
// ============================================================================

`timescale 1ns/1ps

module fir_pmu #(
    parameter WAKE_CYCLES  = 4,
    parameter IDLE_TIMEOUT = 16
)(
    input  wire clk,
    input  wire rstn,
    input  wire req,            // core needs PD_MAC
    output reg  pwr_on,         // PD_MAC power switch enable
    output reg  iso_en,         // clamp PD_MAC outputs
    output wire pwr_ready       // PD_MAC on and isolation released
);

    localparam [1:0] OFF = 2'd0, WAKE = 2'd1, ON = 2'd2, SLEEP = 2'd3;
    // One counter serves both waits; size it for the longer one
    // (4 bits for the defaults; toggle coverage showed a 5th bit never moved).
    localparam CW = (IDLE_TIMEOUT > WAKE_CYCLES) ? $clog2(IDLE_TIMEOUT) : $clog2(WAKE_CYCLES);
    localparam integer  WAKE_LAST_I = WAKE_CYCLES - 1;
    localparam integer  IDLE_LAST_I = IDLE_TIMEOUT - 1;
    localparam [CW-1:0] WAKE_LAST   = WAKE_LAST_I[CW-1:0];
    localparam [CW-1:0] IDLE_LAST   = IDLE_LAST_I[CW-1:0];
    localparam [CW-1:0] ZERO      = {CW{1'b0}};
    localparam [CW-1:0] ONE       = {{(CW-1){1'b0}}, 1'b1};

    reg [1:0]    state;
    reg [CW-1:0] count;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state  <= OFF;
            count  <= ZERO;
            pwr_on <= 1'b0;
            iso_en <= 1'b1;
        end
        else begin
            case (state)
                OFF: begin
                    if (req) begin
                        state  <= WAKE;
                        pwr_on <= 1'b1;
                        count  <= ZERO;
                    end
                end
                WAKE: begin
                    if (count == WAKE_LAST) begin
                        state  <= ON;
                        iso_en <= 1'b0;
                        count  <= ZERO;
                    end
                    else
                        count <= count + ONE;
                end
                ON: begin
                    if (req)
                        count <= ZERO;
                    else if (count == IDLE_LAST) begin
                        state  <= SLEEP;
                        iso_en <= 1'b1;
                    end
                    else
                        count <= count + ONE;
                end
                SLEEP: begin
                    state  <= OFF;
                    pwr_on <= 1'b0;
                end
            endcase
        end
    end

    assign pwr_ready = (state == ON);

endmodule
