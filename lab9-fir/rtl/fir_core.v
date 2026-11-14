// ============================================================================
// FIR Filter Core - Top Level Module (Circular Buffer, Pipelined MAC,
// Clock-Gated ALU, Switchable MAC Power Domain)
// ============================================================================
// Author: Kevin Liu
// UNI: kl3755
// Course: CSEE W4823 Advanced Logic Design - Lab 9
// ============================================================================
// Description:
//   64-tap FIR filter core integrating:
//   - FIR ALU (Lab 6): MAC operations
//   - Coefficient Memory (Lab 7): Stores filter coefficients  
//   - Sample Register File (Lab 7): Circular buffer for delayed samples
//   - fir_icg: clock gate for the ALU, enabled only while a MAC is in flight
//   - fir_pmu: power controller for PD_MAC (the ALU), see fir_core.upf
// ============================================================================

`timescale 1ns/1ps

module fir_core #(
    parameter DATA_WIDTH = 16,      // Sample/coefficient width (Q1.15)
    parameter ACC_WIDTH  = 32,      // Accumulator width (Q2.30)
    parameter NUM_TAPS   = 64,      // Number of filter taps
    parameter ADDR_WIDTH = 6        // Address width for 64 taps
)(
    // Clock and Reset
    input  wire                     clk,
    input  wire                     rstn,
    
    // Input Interface
    input  wire [DATA_WIDTH-1:0]    sample_in,
    input  wire                     sample_valid,
    output wire                     sample_ready,
    
    // Output Interface
    output wire [DATA_WIDTH-1:0]    filter_out,
    output wire                     output_valid,
    
    // Coefficient Loading Interface
    input  wire [DATA_WIDTH-1:0]    coeff_data,
    input  wire [ADDR_WIDTH-1:0]    coeff_addr,
    input  wire                     coeff_we,
    
    // Status
    output wire                     busy
);

    // ========================================================================
    // Internal Signals
    // ========================================================================
    
    // FSM States
    localparam IDLE      = 2'd0;
    localparam STORE     = 2'd1;
    localparam COMPUTE   = 2'd2;
    localparam OUTPUT    = 2'd3;
    
    reg [1:0] state, next_state;

    // NUM_TAPS == 2**ADDR_WIDTH, so the last tap index is all ones.
    localparam [ADDR_WIDTH-1:0] LAST_TAP = {ADDR_WIDTH{1'b1}};
    
    // Circular buffer write pointer (points to oldest sample location)
    reg [ADDR_WIDTH-1:0] write_ptr;
    
    // Control signals
    reg [ADDR_WIDTH-1:0] tap_counter;
    reg                  mac_en;
    reg                  acc_clear;
    
    // Sample buffer write control
    reg                  sample_we;
    reg [DATA_WIDTH-1:0] new_sample_reg;
    
    // Read addresses (computed for circular buffer)
    wire [ADDR_WIDTH-1:0] sample_raddr;
    reg  [ADDR_WIDTH-1:0] coeff_raddr;
    
    // Data paths
    wire [DATA_WIDTH-1:0] sample_data_out;
    wire [DATA_WIDTH-1:0] coeff_data_out;
    // Only acc_out[30:15] (Q2.30 -> Q1.15) is used; the rest is dropped on purpose.
    /* verilator lint_off UNUSEDSIGNAL */
    wire [ACC_WIDTH-1:0]  acc_out;
    /* verilator lint_on UNUSEDSIGNAL */
    wire                  acc_en;

    // Clock gating and power control
    wire                  alu_gclk;
    wire                  alu_clk_en;
    wire                  mac_pwr_ready;
    // Read by the UPF power switch and isolation strategy, not by RTL logic.
    /* verilator lint_off UNUSEDSIGNAL */
    wire                  mac_pwr_on;
    wire                  mac_iso_en;
    /* verilator lint_on UNUSEDSIGNAL */
    
    // Output register
    reg [DATA_WIDTH-1:0]  output_reg;
    reg                   output_valid_reg;
    
    // Pipeline registers for memory latency
    reg                   mac_en_d1;
    reg [ADDR_WIDTH-1:0]  tap_counter_d1;
    reg [ADDR_WIDTH-1:0]  tap_counter_d2;   // matches the extra MAC pipeline stage
    
    // ========================================================================
    // Circular Buffer Address Calculation
    // ========================================================================
    // sample[0] (newest) is at write_ptr
    // sample[n] (older) is at (write_ptr - n) mod NUM_TAPS
    // NUM_TAPS == 2**ADDR_WIDTH, so ADDR_WIDTH-bit subtraction wraps correctly.

    assign sample_raddr = write_ptr - tap_counter;
    
    // ========================================================================
    // Coefficient Memory Instance (from Lab 7)
    // ========================================================================
    
    cmem #(
        .MEM_SIZE   (NUM_TAPS),
        .DATA_WIDTH (DATA_WIDTH)
    ) u_coeff_mem (
        .clk        (clk),
        // Read port - for MAC operations
        .addr_a     (coeff_raddr),
        .data_out_a (coeff_data_out),
        // Write port - for coefficient loading
        .addr_b     (coeff_addr),
        .data_in_b  (coeff_data),
        .we_b       (coeff_we)
    );
    
    // ========================================================================
    // Sample Register File Instance (from Lab 7)
    // ========================================================================
    
    reg_file #(
        .DEPTH (NUM_TAPS),
        .WIDTH (DATA_WIDTH)
    ) u_sample_buf (
        .clk   (clk),
        .we    (sample_we),
        .waddr (write_ptr),
        .wdata (new_sample_reg),
        .raddr (sample_raddr),
        .rdata (sample_data_out)
    );
    
    // ========================================================================
    // FIR ALU Instance (from Lab 6)
    // ========================================================================
    
    // The ALU (PD_MAC) gets a gated clock: it only toggles while a clear,
    // a stage-1 multiply, or a stage-2 accumulate is pending.
    assign alu_clk_en = acc_clear | mac_en_d1 | acc_en;

    fir_icg u_alu_icg (
        .clk     (clk),
        .en      (alu_clk_en),
        .test_en (1'b0),
        .gclk    (alu_gclk)
    );

    fir_alu u_fir_alu (
        .clk         (alu_gclk),
        .rstn        (rstn),
        .sample_data (sample_data_out),
        .coeff_data  (coeff_data_out),
        .mac_en      (mac_en_d1),
        .acc_clear   (acc_clear),
        .acc_out     (acc_out),
        .acc_en      (acc_en)
    );

    // ========================================================================
    // Power controller for PD_MAC (always-on domain)
    // ========================================================================
    // PD_MAC is requested while the core is busy or a sample is offered, and
    // switched off after an idle timeout. The interface does not change: a
    // sample is still accepted in IDLE, and the core holds in STORE until
    // PD_MAC is ready.

    fir_pmu u_pmu (
        .clk       (clk),
        .rstn      (rstn),
        .req       (sample_valid | (state != IDLE)),
        .pwr_on    (mac_pwr_on),
        .iso_en    (mac_iso_en),
        .pwr_ready (mac_pwr_ready)
    );
    
    // ========================================================================
    // Pipeline Delay for Memory Read Latency
    // ========================================================================
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            mac_en_d1      <= 1'b0;
            tap_counter_d1 <= 0;
            tap_counter_d2 <= 0;
        end
        else begin
            mac_en_d1      <= mac_en;
            tap_counter_d1 <= tap_counter;
            tap_counter_d2 <= tap_counter_d1;
        end
    end
    
    // ========================================================================
    // FSM: State Register
    // ========================================================================
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // ========================================================================
    // FSM: Next State Logic
    // ========================================================================
    
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (sample_valid)
                    next_state = STORE;
            end

            // STORE also waits here while PD_MAC wakes up.
            STORE: begin
                if (mac_pwr_ready)
                    next_state = COMPUTE;
            end
            
            COMPUTE: begin
                // Wait for all 64 MACs + memory and MAC pipeline delay
                if (tap_counter_d2 == LAST_TAP)
                    next_state = OUTPUT;
            end
            
            OUTPUT: begin
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end
    
    // ========================================================================
    // FSM: Output Logic & Datapath Control
    // ========================================================================
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            write_ptr        <= 0;
            tap_counter      <= 0;
            mac_en           <= 1'b0;
            acc_clear        <= 1'b0;
            sample_we        <= 1'b0;
            new_sample_reg   <= 0;
            coeff_raddr      <= 0;
            output_reg       <= 0;
            output_valid_reg <= 1'b0;
        end
        else begin
            // Default values
            mac_en           <= 1'b0;
            acc_clear        <= 1'b0;
            sample_we        <= 1'b0;
            output_valid_reg <= 1'b0;
            
            case (state)
                IDLE: begin
                    tap_counter <= 0;
                    if (sample_valid) begin
                        // Capture new sample
                        new_sample_reg <= sample_in;
                        // Write the sample now so it is in the buffer before tap 0 is read
                        sample_we      <= 1'b1;
                    end
                end

                STORE: begin
                    // The sample buffer and coefficients are always on, so the
                    // sample is already stored. The MAC start waits for PD_MAC.
                    tap_counter <= 0;
                    coeff_raddr <= 0;
                    if (mac_pwr_ready) begin
                        // Clear the accumulator for the new computation; it
                        // lands two cycles before the first accumulate.
                        acc_clear <= 1'b1;
                        // Start MACs now: mac_en_d1 then lines up with coeff[0] / sample[n]
                        mac_en    <= 1'b1;
                    end
                end
                
                COMPUTE: begin
                    // Perform MAC operations for all taps
                    // (a 6-bit tap_counter is always < NUM_TAPS, so no range check)
                    mac_en      <= 1'b1;
                    coeff_raddr <= tap_counter + 1'b1;
                    tap_counter <= tap_counter + 1'b1;
                end
                
                OUTPUT: begin
                    // Capture filter output
                    // Q2.30 -> Q1.15: take bits [30:15] for proper scaling
                    output_reg       <= acc_out[30:15];
                    output_valid_reg <= 1'b1;
                    // Update write pointer for next sample (circular buffer)
                    write_ptr        <= (write_ptr == LAST_TAP) ? {ADDR_WIDTH{1'b0}} : write_ptr + 1'b1;
                end
            endcase
        end
    end
    
    // ========================================================================
    // Output Assignments
    // ========================================================================
    
    assign sample_ready = (state == IDLE);
    assign filter_out   = output_reg;
    assign output_valid = output_valid_reg;
    assign busy         = (state != IDLE);

endmodule
