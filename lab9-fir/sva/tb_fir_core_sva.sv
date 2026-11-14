// Stimulus for the FIR core. The checks live in fir_core_sva.sv, attached
// with bind; this file only drives traffic that obeys the interface rule
// (coefficients are loaded only while the core is idle) and then confirms
// the covers were hit and the golden model actually compared outputs.
//
// Reset starts high and drops at 1ns, so the async-reset flops see a real
// falling edge on 2-state simulators as well as 4-state ones.

`timescale 1ns/1ps

module tb_fir_core_sva;
    localparam DATA_WIDTH = 16;
    localparam ACC_WIDTH  = 32;
    localparam NUM_TAPS   = 64;
    localparam ADDR_WIDTH = 6;

    logic                  clk, rstn;
    logic [DATA_WIDTH-1:0] sample_in;
    logic                  sample_valid;
    logic                  sample_ready;
    logic [DATA_WIDTH-1:0] filter_out;
    logic                  output_valid;
    logic [DATA_WIDTH-1:0] coeff_data;
    logic [ADDR_WIDTH-1:0] coeff_addr;
    logic                  coeff_we;
    logic                  busy;

    fir_core #(
        .DATA_WIDTH (DATA_WIDTH),
        .ACC_WIDTH  (ACC_WIDTH),
        .NUM_TAPS   (NUM_TAPS),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) dut (.*);

    initial clk = 1'b0;
    always #5 clk = ~clk;

    int seed = 32'h4823;

    // Accepted-sample count, read from the checker so the tb does not need
    // to re-derive the handshake.
    function automatic int accepted();
        return dut.u_fir_core_sva.n_accepted;
    endfunction

    task automatic do_reset(int cycles);
        @(negedge clk);
        rstn         = 1'b0;
        sample_valid = 1'b0;
        coeff_we     = 1'b0;
        repeat (cycles) @(negedge clk);
        rstn = 1'b1;
        @(negedge clk);
    endtask

    // Triangular window (same as tb/tb_fir_core.v) or random signed taps.
    task automatic load_coeffs(bit random_taps);
        sample_valid = 1'b0;
        @(negedge clk);
        while (busy) @(negedge clk);
        for (int i = 0; i < NUM_TAPS; i++) begin
            coeff_addr = ADDR_WIDTH'(i);
            if (random_taps)
                coeff_data = DATA_WIDTH'($random(seed));
            else
                coeff_data = (i < NUM_TAPS/2) ? DATA_WIDTH'((i + 1) * 128)
                                              : DATA_WIDTH'((NUM_TAPS - i) * 128);
            coeff_we = 1'b1;
            @(negedge clk);
        end
        coeff_we = 1'b0;
    endtask

    // Every tap set to the same value (directed corner cases).
    task automatic load_coeffs_const(logic [DATA_WIDTH-1:0] value);
        sample_valid = 1'b0;
        @(negedge clk);
        while (busy) @(negedge clk);
        for (int i = 0; i < NUM_TAPS; i++) begin
            coeff_addr = ADDR_WIDTH'(i);
            coeff_data = value;
            coeff_we   = 1'b1;
            @(negedge clk);
        end
        coeff_we = 1'b0;
    endtask

    // Send `count` samples. mode 0: zeros, 1: impulse then zeros,
    // 2: random data, 3: full-scale positive (16'h7FFF). valid_pct sets how often sample_valid is offered;
    // 100 keeps valid high so samples go in back to back.
    task automatic send(int count, int mode, int valid_pct);
        int target = accepted() + count;
        int first  = accepted();
        while (accepted() < target) begin
            sample_valid = ($urandom_range(99) < valid_pct);
            case (mode)
                0: sample_in = '0;
                1: sample_in = (accepted() == first) ? 16'h4000 : 16'h0000;
                3: sample_in = 16'h7FFF;
                default: sample_in = DATA_WIDTH'($random(seed));
            endcase
            @(negedge clk);
        end
        sample_valid = 1'b0;
    endtask

    task automatic drain();
        sample_valid = 1'b0;
        repeat (80) @(negedge clk);
    endtask

    initial begin
        rstn         = 1'b1;
        sample_in    = '0;
        sample_valid = 1'b0;
        coeff_data   = '0;
        coeff_addr   = '0;
        coeff_we     = 1'b0;
        #1 rstn = 1'b0;
        repeat (4) @(negedge clk);
        rstn = 1'b1;

        // Phase 1: triangular taps, fill the buffer, then an impulse.
        // The impulse response should walk out the coefficients one by one.
        load_coeffs(0);
        send(NUM_TAPS, 0, 100);
        send(NUM_TAPS + 8, 1, 100);

        // Phase 2: random data with gaps in sample_valid.
        send(150, 2, 40);

        // Phase 3: random signed taps (reaches negative outputs and the
        // accumulator overflow corner), full-rate random data.
        drain();
        load_coeffs(1);
        send(200, 2, 100);

        // Phase 3b: directed overflow. Full-scale taps and samples push the
        // Q2.30 sum past +1.0, so the Q1.15 slice wraps (acc[31] != acc[30]).
        // The random phases reach this only by chance.
        drain();
        load_coeffs_const(16'h7FFF);
        send(NUM_TAPS + 4, 3, 100);

        // Phase 4: reset in the middle of the run, then keep going.
        do_reset(3);
        load_coeffs(0);
        send(NUM_TAPS + 40, 2, 70);
        drain();

        if (!dut.u_fir_core_sva.cov_back_to_back)
            $fatal(1, "cover: no back-to-back samples");
        if (!dut.u_fir_core_sva.cov_ptr_wrap)
            $fatal(1, "cover: write_ptr never wrapped");
        if (!dut.u_fir_core_sva.cov_negative_out)
            $fatal(1, "cover: never produced a negative output");
        if (!dut.u_fir_core_sva.cov_acc_overflow)
            $fatal(1, "cover: accumulator never overflowed the Q1.15 slice");
        if (!dut.u_fir_core_sva.cov_pd_off)
            $fatal(1, "cover: MAC power domain was never shut down");
        if (!dut.u_fir_core_sva.cov_wake_accept)
            $fatal(1, "cover: no sample accepted while PD_MAC was off");
        if (dut.u_fir_core_sva.n_checked < 300)
            $fatal(1, "golden model compared only %0d outputs", dut.u_fir_core_sva.n_checked);

        $display("SVA PASS fir_core: %0d outputs checked against the golden model",
                 dut.u_fir_core_sva.n_checked);
        $finish;
    end

    initial begin
        #2_000_000;
        $fatal(1, "fir_core SVA test timed out");
    end
endmodule
