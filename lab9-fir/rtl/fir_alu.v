// ============================================================================
// FIR Filter ALU Module (2-stage pipelined MAC)
// ============================================================================
// Author: Kevin Liu
// UNI: kl3755
// ============================================================================
// Stage 1 registers the 16x16 product; stage 2 adds it into the accumulator.
// The original single-cycle MAC put memory read -> multiply -> 32-bit add on
// one path, which missed the 30 ns clock. Splitting it moves the add to its
// own cycle, at the cost of one extra cycle of latency per sample.
// ============================================================================

`timescale 1ns/1ps

module fir_alu (
    // Clock and Reset
    input  wire         clk,
    input  wire         rstn,

    // Data Inputs
    input  wire [15:0]  sample_data,
    input  wire [15:0]  coeff_data,

    // Control Signals
    input  wire         mac_en,         // product of this cycle's operands is valid
    input  wire         acc_clear,      // clear the accumulator (has priority)

    // Data Output
    output wire [31:0]  acc_out,
    output wire         acc_en          // stage-2 enable: accumulator adds this cycle
);

    // ========================================================================
    // Stage 1: 16-bit x 16-bit signed multiply, registered
    // ========================================================================

    wire signed [31:0]  product = $signed(sample_data) * $signed(coeff_data);

    reg  signed [31:0]  product_q;
    reg                 mac_en_q;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            product_q <= 32'sd0;
            mac_en_q  <= 1'b0;
        end
        else begin
            mac_en_q <= mac_en;
            if (mac_en)
                product_q <= product;
        end
    end

    // ========================================================================
    // Stage 2: 32-bit accumulator with clear and accumulate
    // ========================================================================

    reg  signed [31:0]  accumulator;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            accumulator <= 32'sd0;
        end
        else if (acc_clear) begin
            accumulator <= 32'sd0;
        end
        else if (mac_en_q) begin
            accumulator <= accumulator + product_q;
        end
    end

    // ========================================================================
    // Output Assignment
    // ========================================================================

    assign acc_out = accumulator;
    assign acc_en  = mac_en_q;

endmodule
