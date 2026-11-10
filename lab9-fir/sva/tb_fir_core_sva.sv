// Holds one sample across a full 64-tap compute, then a second sample.
// sample_valid and sample_in stay constant while sample_ready is low;
// fir_core_sva.sv checks that, the FSM transitions, and the output latency.

`timescale 1ns/1ps

module tb_fir_core_sva;
    logic              clk;
    logic              rstn;
    logic [15:0]       sample_in;
    logic              sample_valid;
    logic              sample_ready;
    logic [15:0]       filter_out;
    logic              output_valid;
    logic [15:0]       coeff_data;
    logic [5:0]        coeff_addr;
    logic              coeff_we;
    logic              busy;

    fir_core dut (
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

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rstn         = 1'b0;
        sample_in    = 16'h0100;
        sample_valid = 1'b0;
        coeff_data   = '0;
        coeff_addr   = '0;
        coeff_we     = 1'b0;

        repeat (4) @(posedge clk);
        rstn = 1'b1;

        // Two back-to-back samples. valid stays high, so the second accept
        // happens on the same IDLE cycle as the first output_valid pulse.
        @(negedge clk);
        sample_valid = 1'b1;
        sample_in    = 16'h0100;

        repeat (2) begin
            @(posedge clk);
            while (!output_valid) @(posedge clk);
        end

        @(negedge clk);
        sample_valid = 1'b0;

        repeat (4) @(posedge clk);

        if (!dut.u_fir_core_sva.cov_output)
            $fatal(1, "cover: output_valid never fired");
        if (!dut.u_fir_core_sva.cov_last_tap)
            $fatal(1, "cover: tap_counter never reached the last tap");

        $display("SVA PASS fir");
        $finish;
    end

    initial begin
        #100000;
        $fatal(1, "fir SVA test timed out");
    end
endmodule
