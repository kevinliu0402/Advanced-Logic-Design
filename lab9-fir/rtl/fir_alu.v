// ============================================================================
// FIR Filter ALU Module
// ============================================================================
// Author: Kevin Liu
// UNI: kl3755
// ============================================================================

module fir_alu (
    // Clock and Reset
    input  wire         clk,
    input  wire         rstn,           
    
    // Data Inputs
    input  wire [15:0]  sample_data,    
    input  wire [15:0]  coeff_data,     
    
    // Control Signals
    input  wire         mac_en,         // MAC
    input  wire         acc_clear,      // Clear
    
    // Data Output
    output wire [31:0]  acc_out         // output
);

    // ========================================================================
    // Internal Signals
    // ========================================================================
    
    // Multiplier output
    wire signed [31:0]  product;
    
    // Accumulator register
    reg  signed [31:0]  accumulator;
    
    // ========================================================================
    // Multiplier: 16-bit × 16-bit Signed Multiplication
    // ========================================================================
    
    assign product = $signed(sample_data) * $signed(coeff_data);
    
    // ========================================================================
    // Accumulator: 32-bit Register with Clear and Accumulate
    // ========================================================================
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            accumulator <= 32'sd0;
        end
        else if (acc_clear) begin
            accumulator <= 32'sd0;
        end
        else if (mac_en) begin
            accumulator <= accumulator + product;
        end
    end
    
    // ========================================================================
    // Output Assignment
    // ========================================================================
    
    assign acc_out = accumulator;

endmodule