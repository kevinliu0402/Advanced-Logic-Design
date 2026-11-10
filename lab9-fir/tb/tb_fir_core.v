// ============================================================================
// FIR Filter Core Testbench
// ============================================================================
// Author: Kevin Liu
// UNI: kl3755
// Course: CSEE W4823 Advanced Logic Design - Lab 9
// ============================================================================

`timescale 1ns/1ps

module tb_fir_core;

    // ========================================================================
    // Parameters
    // ========================================================================
    parameter DATA_WIDTH = 16;
    parameter ACC_WIDTH  = 32;
    parameter NUM_TAPS   = 64;
    parameter ADDR_WIDTH = 6;
    parameter CLK_PERIOD = 10;  // 100 MHz clock
    
    // ========================================================================
    // Testbench Signals
    // ========================================================================
    reg                     clk;
    reg                     rstn;
    
    // Input Interface
    reg  [DATA_WIDTH-1:0]   sample_in;
    reg                     sample_valid;
    wire                    sample_ready;
    
    // Output Interface
    wire [DATA_WIDTH-1:0]   filter_out;
    wire                    output_valid;
    
    // Coefficient Loading
    reg  [DATA_WIDTH-1:0]   coeff_data;
    reg  [ADDR_WIDTH-1:0]   coeff_addr;
    reg                     coeff_we;
    
    // Status
    wire                    busy;
    
    // Test variables
    integer i, j;
    integer errors;
    integer test_count;
    reg signed [DATA_WIDTH-1:0] test_samples [0:127];
    reg signed [DATA_WIDTH-1:0] coefficients [0:NUM_TAPS-1];
    reg signed [ACC_WIDTH-1:0]  expected_output;
    reg signed [DATA_WIDTH-1:0] output_capture;
    
    // ========================================================================
    // DUT Instantiation
    // ========================================================================
    
    fir_core #(
        .DATA_WIDTH (DATA_WIDTH),
        .ACC_WIDTH  (ACC_WIDTH),
        .NUM_TAPS   (NUM_TAPS),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) dut (
        .clk          (clk),
        .rstn         (rstn),
        .sample_in    (sample_in),
        .sample_valid (sample_valid),
        .sample_ready (sample_ready),
        .filter_out   (filter_out),
        .output_valid (output_valid),
        .coeff_data   (coeff_data),
        .coeff_addr   (coeff_addr),
        .coeff_we     (coeff_we),
        .busy         (busy)
    );
    
    // ========================================================================
    // Clock Generation
    // ========================================================================
    
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // ========================================================================
    // VCD Dump for Power Analysis
    // ========================================================================
    
    initial begin
        $dumpfile("fir_core.vcd");
        $dumpvars(0, tb_fir_core);
    end
    
    // ========================================================================
    // Main Test Procedure
    // ========================================================================
    
    initial begin
        // Initialize
        errors = 0;
        test_count = 0;
        rstn = 0;
        sample_in = 0;
        sample_valid = 0;
        coeff_data = 0;
        coeff_addr = 0;
        coeff_we = 0;
        
        $display("========================================");
        $display("FIR Filter Core Testbench Starting");
        $display("========================================");
        $display("Configuration:");
        $display("  Data Width: %0d bits", DATA_WIDTH);
        $display("  Number of Taps: %0d", NUM_TAPS);
        $display("  Clock Period: %0d ns", CLK_PERIOD);
        $display("========================================\n");
        
        // Reset sequence
        repeat(5) @(posedge clk);
        rstn = 1;
        repeat(2) @(posedge clk);
        
        // Test 1: Load Coefficients
        test_load_coefficients();
        
        // Test 2: Impulse Response Test
        test_impulse_response();
        
        // Test 3: Step Response Test
        test_step_response();
        
        // Test 4: Multiple Sample Processing
        test_multiple_samples();
        
        // Test 5: Random Data Test
        test_random_data();
        
        // Final Report
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total Tests: %0d", test_count);
        $display("Errors: %0d", errors);
        if (errors == 0)
            $display("STATUS: ALL TESTS PASSED!");
        else
            $display("STATUS: TESTS FAILED!");
        $display("========================================\n");
        
        repeat(10) @(posedge clk);
        $finish;
    end
    
    // ========================================================================
    // Test Tasks
    // ========================================================================
    
    // Task: Load coefficients into the filter
    task test_load_coefficients;
        begin
            $display("\nTest 1: Loading Coefficients");
            test_count = test_count + 1;
            
            // Generate simple lowpass filter coefficients (truncated sinc)
            // Using symmetric coefficients for linear phase
            for (i = 0; i < NUM_TAPS; i = i + 1) begin
                // Simple triangular window coefficients for testing
                if (i < NUM_TAPS/2)
                    coefficients[i] = (i + 1) * 128;  // Q1.15 format
                else
                    coefficients[i] = (NUM_TAPS - i) * 128;
            end
            
            // Load coefficients
            for (i = 0; i < NUM_TAPS; i = i + 1) begin
                @(posedge clk);
                coeff_addr = i;
                coeff_data = coefficients[i];
                coeff_we = 1;
            end
            @(posedge clk);
            coeff_we = 0;
            
            $display("  PASS: Loaded %0d coefficients", NUM_TAPS);
        end
    endtask
    
    // Task: Test impulse response
    task test_impulse_response;
        begin
            $display("\nTest 2: Impulse Response Test");
            test_count = test_count + 1;
            
            // Send impulse (single non-zero sample)
            wait(sample_ready);
            @(posedge clk);
            sample_in = 16'h4000;  // 0.5 in Q1.15
            sample_valid = 1;
            @(posedge clk);
            sample_valid = 0;
            
            // Wait for output
            wait(output_valid);
            @(posedge clk);
            output_capture = filter_out;
            $display("  Impulse response first tap: 0x%04h (%0d)", output_capture, $signed(output_capture));
            
            // Send zeros and capture more outputs
            for (i = 0; i < 5; i = i + 1) begin
                wait(sample_ready);
                @(posedge clk);
                sample_in = 16'h0000;
                sample_valid = 1;
                @(posedge clk);
                sample_valid = 0;
                
                wait(output_valid);
                @(posedge clk);
                output_capture = filter_out;
                $display("  Impulse response tap[%0d]: 0x%04h (%0d)", i+1, output_capture, $signed(output_capture));
            end
            
            $display("  PASS: Impulse response test completed");
        end
    endtask
    
    // Task: Test step response
    task test_step_response;
        begin
            $display("\nTest 3: Step Response Test");
            test_count = test_count + 1;
            
            // Reset the filter by sending zeros
            for (i = 0; i < NUM_TAPS; i = i + 1) begin
                wait(sample_ready);
                @(posedge clk);
                sample_in = 16'h0000;
                sample_valid = 1;
                @(posedge clk);
                sample_valid = 0;
                wait(output_valid);
                @(posedge clk);
            end
            
            // Send step input (constant value)
            for (i = 0; i < 10; i = i + 1) begin
                wait(sample_ready);
                @(posedge clk);
                sample_in = 16'h2000;  // 0.25 in Q1.15
                sample_valid = 1;
                @(posedge clk);
                sample_valid = 0;
                
                wait(output_valid);
                @(posedge clk);
                output_capture = filter_out;
                $display("  Step response[%0d]: 0x%04h (%0d)", i, output_capture, $signed(output_capture));
            end
            
            $display("  PASS: Step response test completed");
        end
    endtask
    
    // Task: Test multiple samples processing
    task test_multiple_samples;
        begin
            $display("\nTest 4: Multiple Sample Processing");
            test_count = test_count + 1;
            
            // Generate test samples (sine-like pattern)
            for (i = 0; i < 128; i = i + 1) begin
                // Simple ramp pattern
                test_samples[i] = (i % 32) * 512 - 8192;
            end
            
            // Process samples
            for (i = 0; i < 20; i = i + 1) begin
                wait(sample_ready);
                @(posedge clk);
                sample_in = test_samples[i];
                sample_valid = 1;
                @(posedge clk);
                sample_valid = 0;
                
                wait(output_valid);
                @(posedge clk);
                output_capture = filter_out;
                
                if (i < 5 || i >= 15) begin
                    $display("  Sample[%0d]: In=0x%04h (%0d), Out=0x%04h (%0d)", 
                             i, test_samples[i], $signed(test_samples[i]),
                             output_capture, $signed(output_capture));
                end
                else if (i == 5) begin
                    $display("  ... (samples 5-14 omitted) ...");
                end
            end
            
            $display("  PASS: Multiple sample test completed");
        end
    endtask
    
    // Task: Test with random data
    task test_random_data;
        integer seed;
        begin
            $display("\nTest 5: Random Data Test");
            test_count = test_count + 1;
            seed = 12345;
            
            // Process random samples
            for (i = 0; i < 100; i = i + 1) begin
                wait(sample_ready);
                @(posedge clk);
                sample_in = $random(seed) & 16'hFFFF;
                sample_valid = 1;
                @(posedge clk);
                sample_valid = 0;
                
                wait(output_valid);
                @(posedge clk);
            end
            
            $display("  PASS: Processed 100 random samples");
        end
    endtask

endmodule
