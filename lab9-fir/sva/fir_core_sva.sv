// Concurrent assertions for the 64-tap FIR core in rtl/fir_core.v.
//
// Not part of the synthesizable design. `bind` attaches this checker inside
// fir_core at elaboration, so it can see the FSM, the tap counter, and the
// circular-buffer pointer without any change to the RTL.
//
// Only the portable SVA subset is used (|->, |=>, $past, $stable, $rose,
// $isunknown, disable iff). Fixed latencies are written as
// `consequent == $past(antecedent, N)` instead of `##N`, so the same file
// runs on Verilator 5.0x and on VCS/Questa/Xcelium.
//
// What is checked:
//   1. Interface rules (no coefficient write while busy).
//   2. FSM: legal transitions, ready/busy decode, fixed COMPUTE length.
//   3. Datapath control: sample write, MAC enable count, accumulator clear.
//   4. Circular buffer: write pointer advance/wrap, read-address arithmetic.
//   5. Latency: an output for every accepted sample, exactly LATENCY cycles later.
//   6. End-to-end: a golden FIR model compares filter_out on every output.
//   7. Covers for back-to-back samples, pointer wrap, negative output, overflow,
//      MAC power-domain shutdown, and a sample accepted after a wake-up.
//   8. Low power: PD_MAC switch/isolation sequencing, no MAC activity while
//      PD_MAC is not ready, and the ALU clock gate covering every ALU update.

`timescale 1ns/1ps

module fir_core_sva #(
    parameter DATA_WIDTH = 16,
    parameter ACC_WIDTH  = 32,
    parameter NUM_TAPS   = 64,
    parameter ADDR_WIDTH = 6
) (
    input                         clk,
    input                         rstn,
    // ports
    input        [DATA_WIDTH-1:0] sample_in,
    input                         sample_valid,
    input                         sample_ready,
    input        [DATA_WIDTH-1:0] filter_out,
    input                         output_valid,
    input        [DATA_WIDTH-1:0] coeff_data,
    input        [ADDR_WIDTH-1:0] coeff_addr,
    input                         coeff_we,
    input                         busy,
    // internals
    input        [1:0]            state,
    input        [ADDR_WIDTH-1:0] write_ptr,
    input        [ADDR_WIDTH-1:0] tap_counter,
    input        [ADDR_WIDTH-1:0] sample_raddr,
    input                         sample_we,
    input                         mac_en_d1,   // stage-1 (multiply) enable
    input                         acc_en,      // stage-2 (accumulate) enable
    input                         acc_clear,
    input        [ACC_WIDTH-1:0]  acc_out,
    // clock gating and power control
    input                         alu_clk_en,
    input                         mac_pwr_on,
    input                         mac_iso_en,
    input                         mac_pwr_ready
);
    // Same encoding as fir_core.
    localparam [1:0] IDLE = 2'd0, STORE = 2'd1, COMPUTE = 2'd2, OUTPUT = 2'd3;

    // Cycles spent in COMPUTE per sample. tap_counter walks 0..63, and the
    // exit test looks at the two-cycle-delayed copy (one cycle for the memory
    // read, one for the pipelined multiply), so it is NUM_TAPS + 2.
    localparam int COMPUTE_CYCLES = NUM_TAPS + 2;
    // PD_MAC wake-up: switch on, then isolation released this many cycles later.
    localparam int WAKE_CYCLES = 4;
    // Accept (IDLE) -> STORE -> COMPUTE x N -> OUTPUT -> output_valid, when
    // PD_MAC is already on. STORE stretches while PD_MAC wakes up, so the
    // fixed latency is measured from the MAC start (last STORE cycle).
    localparam int LATENCY       = 1 + 1 + COMPUTE_CYCLES + 1;
    localparam int START_TO_OUT  = 1 + COMPUTE_CYCLES + 1;
    // Longest STORE stall: wake request, WAKE_CYCLES, isolation release.
    localparam int MAX_STORE     = WAKE_CYCLES + 3;

    bit cov_back_to_back;
    bit cov_ptr_wrap;
    bit cov_negative_out;
    bit cov_acc_overflow;
    bit cov_pd_off;
    bit cov_wake_accept;
    int n_checked;   // outputs compared against the golden model

    wire accept = sample_valid && sample_ready;
    // MAC start: the STORE cycle in which PD_MAC is ready.
    wire start  = (state == STORE) && mac_pwr_ready;

    // -----------------------------------------------------------------------
    // 1. Interface rules. The golden model below assumes coefficients do not
    // change while a sample is being filtered. Use `assume property` for these
    // if the checker is reused in a formal tool.
    // -----------------------------------------------------------------------
    a_no_coeff_write_while_busy: assert property (
        @(posedge clk) disable iff (!rstn) coeff_we |-> !busy
    ) else $error("coefficient written while the filter was busy");

    // -----------------------------------------------------------------------
    // 2. FSM
    // -----------------------------------------------------------------------
    a_no_x_outputs: assert property (
        @(posedge clk) disable iff (!rstn)
        !$isunknown({state, sample_ready, busy, output_valid})
    ) else $error("X on FSM state or handshake outputs");

    a_ready_is_idle: assert property (
        @(posedge clk) disable iff (!rstn) sample_ready == (state == IDLE)
    ) else $error("sample_ready does not match state == IDLE");

    a_busy_not_ready: assert property (
        @(posedge clk) disable iff (!rstn) busy == !sample_ready
    ) else $error("busy and sample_ready are not complements");

    a_reset_state: assert property (
        @(posedge clk) !rstn |-> (state == IDLE && !output_valid)
    ) else $error("FSM not in IDLE during reset");

    a_idle_accept: assert property (
        @(posedge clk) disable iff (!rstn)
        (state == IDLE && accept) |=> state == STORE
    ) else $error("accepted sample in IDLE did not move to STORE");

    a_idle_wait: assert property (
        @(posedge clk) disable iff (!rstn)
        (state == IDLE && !accept) |=> state == IDLE
    ) else $error("left IDLE without an accepted sample");

    a_store_to_compute: assert property (
        @(posedge clk) disable iff (!rstn) start |=> state == COMPUTE
    ) else $error("STORE did not go to COMPUTE once PD_MAC was ready");

    a_store_waits: assert property (
        @(posedge clk) disable iff (!rstn)
        (state == STORE && !mac_pwr_ready) |=> state == STORE
    ) else $error("left STORE before PD_MAC was ready");

    // With PD_MAC already on, STORE lasts exactly one cycle (no stall).
    a_no_stall_when_on: assert property (
        @(posedge clk) disable iff (!rstn) (accept && mac_pwr_ready) |=> start
    ) else $error("STORE stalled although PD_MAC was on");

    // The wake-up stall is bounded.
    int store_run;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)                 store_run <= 0;
        else if (state == STORE)   store_run <= store_run + 1;
        else                       store_run <= 0;
    end

    a_store_bounded: assert property (
        @(posedge clk) disable iff (!rstn) state == STORE |-> store_run < MAX_STORE
    ) else $error("STORE waited %0d cycles for PD_MAC", store_run);

    a_compute_next: assert property (
        @(posedge clk) disable iff (!rstn)
        state == COMPUTE |=> (state == COMPUTE || state == OUTPUT)
    ) else $error("COMPUTE went somewhere other than COMPUTE/OUTPUT");

    a_output_to_idle: assert property (
        @(posedge clk) disable iff (!rstn) state == OUTPUT |=> state == IDLE
    ) else $error("OUTPUT did not return to IDLE");

    // COMPUTE length. A run counter is the portable form of
    // `$rose(state==COMPUTE) |-> (state==COMPUTE)[*N] ##1 state==OUTPUT`.
    int compute_run;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)                     compute_run <= 0;
        else if (state == COMPUTE)     compute_run <= compute_run + 1;
        else                           compute_run <= 0;
    end

    a_compute_not_too_long: assert property (
        @(posedge clk) disable iff (!rstn)
        state == COMPUTE |-> compute_run < COMPUTE_CYCLES
    ) else $error("COMPUTE ran longer than %0d cycles", COMPUTE_CYCLES);

    a_compute_exact: assert property (
        @(posedge clk) disable iff (!rstn)
        state == OUTPUT |-> compute_run == COMPUTE_CYCLES
    ) else $error("COMPUTE lasted %0d cycles, expected %0d", compute_run, COMPUTE_CYCLES);

    // -----------------------------------------------------------------------
    // 3. Datapath control
    // -----------------------------------------------------------------------
    // The new sample is written into the buffer exactly once per accepted
    // sample, in STORE or the first COMPUTE cycle. Whether that write lands
    // before tap 0 is read is what a_filter_out ends up checking.
    a_sample_we_window: assert property (
        @(posedge clk) disable iff (!rstn)
        sample_we |-> (state == STORE || (state == COMPUTE && compute_run == 0))
    ) else $error("sample_we outside STORE / first COMPUTE cycle");

    int we_count;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)          we_count <= 0;
        else if (accept)    we_count <= 0;
        else if (sample_we) we_count <= we_count + 1;
    end

    a_sample_written_once: assert property (
        @(posedge clk) disable iff (!rstn)
        state == OUTPUT |-> we_count == 1
    ) else $error("sample written %0d times for one input", we_count);

    // The accumulator is cleared when the sample is accepted.
    a_acc_clear_on_start: assert property (
        @(posedge clk) disable iff (!rstn)
        $past(rstn) |-> acc_clear == $past(start)
    ) else $error("acc_clear does not follow the MAC start");

    a_acc_zero_after_clear: assert property (
        @(posedge clk) disable iff (!rstn) acc_clear |=> acc_out == '0
    ) else $error("accumulator not zero after acc_clear");

    // MACs per sample. Count the accumulate enables between the clear and
    // the cycle the output register captures acc_out (state == OUTPUT).
    int mac_count;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)          mac_count <= 0;
        else if (acc_clear) mac_count <= 0;
        else if (acc_en)    mac_count <= mac_count + 1;
    end

    a_mac_count: assert property (
        @(posedge clk) disable iff (!rstn)
        state == OUTPUT |-> mac_count == NUM_TAPS
    ) else $error("%0d MACs before output capture, expected %0d", mac_count, NUM_TAPS);

    // The accumulator only moves on a clear or an enabled MAC.
    a_acc_holds: assert property (
        @(posedge clk) disable iff (!rstn)
        (!acc_clear && !acc_en) |=> $stable(acc_out)
    ) else $error("accumulator changed with no clear and no MAC");

    // -----------------------------------------------------------------------
    // 4. Circular buffer
    // -----------------------------------------------------------------------
    a_wptr_advance: assert property (
        @(posedge clk) disable iff (!rstn)
        state == OUTPUT |=> write_ptr == ADDR_WIDTH'(($past(write_ptr) + 1) % NUM_TAPS)
    ) else $error("write_ptr did not advance by one (mod %0d) after OUTPUT", NUM_TAPS);

    a_wptr_holds: assert property (
        @(posedge clk) disable iff (!rstn)
        state != OUTPUT |=> $stable(write_ptr)
    ) else $error("write_ptr moved outside OUTPUT");

    a_wptr_in_range: assert property (
        @(posedge clk) disable iff (!rstn) write_ptr < NUM_TAPS
    ) else $error("write_ptr out of range");

    // Tap k reads sample[n-k], i.e. address (write_ptr - k) mod NUM_TAPS.
    a_read_addr: assert property (
        @(posedge clk) disable iff (!rstn)
        state == COMPUTE |->
            sample_raddr == ADDR_WIDTH'((write_ptr + NUM_TAPS - tap_counter) % NUM_TAPS)
    ) else $error("circular-buffer read address wrong: wp=%0d tap=%0d raddr=%0d",
                  write_ptr, tap_counter, sample_raddr);

    a_tap_steps: assert property (
        @(posedge clk) disable iff (!rstn)
        state == COMPUTE |=> tap_counter == ADDR_WIDTH'($past(tap_counter) + 1)
    ) else $error("tap_counter did not step by one in COMPUTE");

    // -----------------------------------------------------------------------
    // 5. Latency. Equality in both directions: every accepted sample produces
    // one output LATENCY cycles later, and no output appears without one.
    // -----------------------------------------------------------------------
    // Only once reset has been released for the whole window: a sample
    // accepted before a reset never produces an output.
    int since_reset;
    always @(posedge clk or negedge rstn) begin
        if (!rstn)                     since_reset <= 0;
        else if (since_reset < 1000)   since_reset <= since_reset + 1;
    end

    a_latency: assert property (
        @(posedge clk) disable iff (!rstn)
        since_reset >= START_TO_OUT |-> output_valid == $past(start, START_TO_OUT)
    ) else $error("output_valid is not the MAC start delayed by %0d cycles", START_TO_OUT);

    // End to end, with PD_MAC on: an accepted sample produces its output
    // exactly LATENCY cycles later.
    a_latency_when_on: assert property (
        @(posedge clk) disable iff (!rstn)
        (since_reset >= LATENCY && $past(accept && mac_pwr_ready, LATENCY)) |-> output_valid
    ) else $error("output not %0d cycles after a sample accepted with PD_MAC on", LATENCY);

    a_output_pulse: assert property (
        @(posedge clk) disable iff (!rstn) output_valid |=> !output_valid
    ) else $error("output_valid held for more than one cycle");

    a_output_stable: assert property (
        @(posedge clk) disable iff (!rstn)
        ($past(rstn) && !output_valid) |-> $stable(filter_out)
    ) else $error("filter_out changed without output_valid");

    // -----------------------------------------------------------------------
    // 6. Golden model. Mirrors coefficient writes, keeps the history of
    // accepted samples, and computes
    //     y[n] = sum_{k=0}^{NUM_TAPS-1} c[k] * x[n-k]
    // with the same 32-bit wrapping accumulator and Q2.30 -> Q1.15 slice.
    //
    // The sample buffer is not reset in RTL, so the first NUM_TAPS-1 outputs
    // after reset depend on power-up contents (X on a 4-state simulator).
    // Those outputs are skipped; every output after that is compared.
    // -----------------------------------------------------------------------
    logic signed [DATA_WIDTH-1:0] coeff_m [NUM_TAPS];
    logic signed [DATA_WIDTH-1:0] hist    [NUM_TAPS];  // hist[0] = newest
    int n_accepted;
    logic signed [DATA_WIDTH-1:0] expect_q[$];
    bit                           check_q [$];

    function automatic logic signed [DATA_WIDTH-1:0] golden();
        logic signed [ACC_WIDTH-1:0] acc = '0;
        for (int k = 0; k < NUM_TAPS; k++)
            acc = acc + ACC_WIDTH'($signed(coeff_m[k]) * $signed(hist[k]));
        return acc[30:15];
    endfunction

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            n_accepted = 0;
            expect_q.delete();
            check_q.delete();
        end else begin
            if (coeff_we)
                coeff_m[coeff_addr] = coeff_data;
            if (accept) begin
                for (int k = NUM_TAPS - 1; k > 0; k--)
                    hist[k] = hist[k-1];
                hist[0] = sample_in;
                n_accepted++;
                expect_q.push_back(golden());
                check_q.push_back(n_accepted >= NUM_TAPS);
            end
            if (output_valid) begin
                a_output_has_sample: assert (expect_q.size() != 0)
                    else $error("output_valid with no accepted sample outstanding");
                if (expect_q.size() != 0) begin
                    if (check_q[0]) begin
                        a_filter_out: assert (filter_out === expect_q[0])
                            else $error("FIR mismatch: got %h (%0d) expected %h (%0d)",
                                        filter_out, $signed(filter_out),
                                        expect_q[0], expect_q[0]);
                        n_checked++;
                    end
                    expect_q.pop_front();
                    check_q.pop_front();
                end
            end
        end
    end

    // -----------------------------------------------------------------------
    // 8. Low power
    // -----------------------------------------------------------------------
    // PD_MAC is isolated whenever its switch is off.
    a_off_is_isolated: assert property (
        @(posedge clk) disable iff (!rstn) !mac_pwr_on |-> mac_iso_en
    ) else $error("PD_MAC switched off without isolation");

    // Isolation goes on at least one cycle before the switch turns off.
    a_iso_before_off: assert property (
        @(posedge clk) disable iff (!rstn) $fell(mac_pwr_on) |-> $past(mac_iso_en)
    ) else $error("PD_MAC switched off in the same cycle isolation was enabled");

    // Isolation is released only after the switch has been on for the full
    // wake-up time.
    a_wake_time: assert property (
        @(posedge clk) disable iff (!rstn)
        $fell(mac_iso_en) |-> ($past(mac_pwr_on, 1) && $past(mac_pwr_on, WAKE_CYCLES))
    ) else $error("isolation released before PD_MAC finished waking up");

    a_ready_means_on: assert property (
        @(posedge clk) disable iff (!rstn)
        mac_pwr_ready |-> (mac_pwr_on && !mac_iso_en)
    ) else $error("pwr_ready while PD_MAC is off or isolated");

    // No MAC activity unless PD_MAC is powered and de-isolated.
    a_no_mac_when_off: assert property (
        @(posedge clk) disable iff (!rstn)
        (acc_clear || mac_en_d1 || acc_en) |-> mac_pwr_ready
    ) else $error("ALU used while PD_MAC was not ready");

    // PD_MAC is never shut down while a sample is in flight.
    // Once the MACs have started, PD_MAC stays on until the output.
    a_on_while_busy: assert property (
        @(posedge clk) disable iff (!rstn)
        (state == COMPUTE || state == OUTPUT) |-> mac_pwr_ready
    ) else $error("PD_MAC not ready while the core is computing");

    // Clock gating: the ALU only changes on edges where its clock was enabled.
    a_cg_covers_alu: assert property (
        @(posedge clk) disable iff (!rstn)
        $changed(acc_out) |-> $past(alu_clk_en)
    ) else $error("accumulator changed on a gated-off clock edge");

    // -----------------------------------------------------------------------
    // 7. Covers
    //
    // Each condition is a named wire, used twice: by a `cover property`
    // (VCS/Questa list these in their assertion coverage report) and by an
    // always block that latches a cov_* flag for the testbench to check.
    // The flag is not set from the cover's action block because Verilator
    // 5.0x does not execute cover action blocks.
    // -----------------------------------------------------------------------
    logic [1:0]            prev_state;
    logic [ADDR_WIDTH-1:0] prev_wptr;
    logic                  prev_pwr_on;
    always @(posedge clk) begin
        prev_state     <= state;
        prev_wptr      <= write_ptr;
        prev_pwr_on    <= mac_pwr_on;
    end

    // A new sample accepted on the first IDLE cycle after an output.
    wire cond_back_to_back = (prev_state == OUTPUT) && accept;
    wire cond_ptr_wrap     = (prev_wptr == ADDR_WIDTH'(NUM_TAPS - 1)) && (write_ptr == '0);
    wire cond_negative_out = output_valid && filter_out[DATA_WIDTH-1];
    // The Q2.30 -> Q1.15 slice drops acc[31]. When acc[31] != acc[30] the
    // result wraps. The RTL does not saturate; this shows the stimulus
    // reached that corner (the golden model wraps the same way).
    wire cond_acc_overflow = (state == OUTPUT) && (acc_out[31] != acc_out[30]);
    // PD_MAC went through a full shutdown, and a sample was accepted while it
    // was off (so STORE had to wait for the wake-up).
    wire cond_pd_off       = prev_pwr_on && !mac_pwr_on;
    wire cond_wake_accept  = accept && !mac_pwr_on;

    c_back_to_back: cover property (@(posedge clk) disable iff (!rstn) cond_back_to_back);
    c_ptr_wrap:     cover property (@(posedge clk) disable iff (!rstn) cond_ptr_wrap);
    c_negative_out: cover property (@(posedge clk) disable iff (!rstn) cond_negative_out);
    c_acc_overflow: cover property (@(posedge clk) disable iff (!rstn) cond_acc_overflow);
    c_pd_off:       cover property (@(posedge clk) disable iff (!rstn) cond_pd_off);
    c_wake_accept:  cover property (@(posedge clk) disable iff (!rstn) cond_wake_accept);

    always @(posedge clk) begin
        if (rstn && $past(rstn)) begin
            if (cond_back_to_back) cov_back_to_back <= 1'b1;
            if (cond_ptr_wrap)     cov_ptr_wrap     <= 1'b1;
            if (cond_negative_out) cov_negative_out <= 1'b1;
            if (cond_acc_overflow) cov_acc_overflow <= 1'b1;
            if (cond_pd_off)       cov_pd_off       <= 1'b1;
            if (cond_wake_accept)  cov_wake_accept  <= 1'b1;
        end
    end

endmodule

bind fir_core fir_core_sva #(
    .DATA_WIDTH (DATA_WIDTH),
    .ACC_WIDTH  (ACC_WIDTH),
    .NUM_TAPS   (NUM_TAPS),
    .ADDR_WIDTH (ADDR_WIDTH)
) u_fir_core_sva (
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
    .busy         (busy),
    .state        (state),
    .write_ptr    (write_ptr),
    .tap_counter  (tap_counter),
    .sample_raddr (sample_raddr),
    .sample_we    (sample_we),
    .mac_en_d1    (mac_en_d1),
    .acc_en       (acc_en),
    .acc_clear    (acc_clear),
    .acc_out      (acc_out),
    .alu_clk_en   (alu_clk_en),
    .mac_pwr_on   (mac_pwr_on),
    .mac_iso_en   (mac_iso_en),
    .mac_pwr_ready(mac_pwr_ready)
);
