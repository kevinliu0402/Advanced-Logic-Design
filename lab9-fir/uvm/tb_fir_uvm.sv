// UVM testbench for the 64-tap FIR core. Compile with VCS -ntb_opts uvm-1.2
// (see run_uvm.sh). fir_core_sva.sv stays bound, so every assertion in it
// runs underneath this bench as well.
//
// Pieces:
//   fir_item          one coefficient write, one input sample, a reset, or
//                     (from the monitor) one filter output
//   fir_coeff_seq     loads all 64 taps: triangular window or random signed
//   fir_sample_seq    zeros, an impulse, or random samples with corner values
//   fir_reset_seq     pulses rstn in the middle of a run
//   fir_driver        drives on the falling edge; waits for sample_ready and
//                     only writes coefficients while the core is idle
//   fir_monitor       samples through a clocking block and publishes
//                     coefficient writes, accepted samples, outputs, resets
//   fir_scoreboard    reference FIR model; compares every output once the
//                     sample buffer has been filled since the last reset
//   fir_coverage      covergroups on sample, coefficient, and output values
//   fir_uvm_test      the same four phases as sva/tb_fir_core_sva.sv

`timescale 1ns/1ps

interface fir_if (input logic clk);
    logic        rstn;
    logic [15:0] sample_in;
    logic        sample_valid;
    logic        sample_ready;
    logic [15:0] filter_out;
    logic        output_valid;
    logic [15:0] coeff_data;
    logic [5:0]  coeff_addr;
    logic        coeff_we;
    logic        busy;

    // The monitor reads through this so it always sees the values the DUT
    // sampled on that edge, never the values the edge produced.
    clocking mon_cb @(posedge clk);
        default input #1step;
        input rstn, sample_in, sample_valid, sample_ready;
        input filter_out, output_valid, coeff_data, coeff_addr, coeff_we, busy;
    endclocking

    function bit covers_ok();
        return tb_fir_uvm.dut.u_fir_core_sva.cov_back_to_back
            && tb_fir_uvm.dut.u_fir_core_sva.cov_ptr_wrap
            && tb_fir_uvm.dut.u_fir_core_sva.cov_negative_out
            && tb_fir_uvm.dut.u_fir_core_sva.cov_acc_overflow;
    endfunction
endinterface

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum {FIR_COEFF, FIR_SAMPLE, FIR_RESET, FIR_OUTPUT} fir_kind_e;

class fir_item extends uvm_sequence_item;
    rand fir_kind_e   kind;
    rand bit [5:0]    addr;   // coefficient address
    rand bit [15:0]   data;   // coefficient, sample, or filter output
    rand int unsigned idle;   // IDLE cycles to wait before offering a sample

    // Hit the Q1.15 corners far more often than uniform random would.
    constraint c_data {
        data dist {
            16'h0000                :/ 2,
            16'h7FFF                :/ 2,
            16'h8000                :/ 2,
            [16'h0001:16'h7FFE]     :/ 47,
            [16'h8001:16'hFFFF]     :/ 47
        };
    }
    // 0 means "offer the next sample while the core is still busy", which
    // lands it on the first IDLE cycle (back to back).
    constraint c_idle { idle dist {0 :/ 6, [1:3] :/ 4}; }

    `uvm_object_utils_begin(fir_item)
        `uvm_field_enum(fir_kind_e, kind, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(idle, UVM_ALL_ON | UVM_DEC)
    `uvm_object_utils_end

    function new(string name = "fir_item");
        super.new(name);
    endfunction
endclass

class fir_sequencer extends uvm_sequencer #(fir_item);
    `uvm_component_utils(fir_sequencer)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// ---------------------------------------------------------------------------
// Sequences
// ---------------------------------------------------------------------------
class fir_coeff_seq extends uvm_sequence #(fir_item);
    `uvm_object_utils(fir_coeff_seq)
    bit random_taps;
    function new(string name = "fir_coeff_seq");
        super.new(name);
    endfunction
    task body();
        for (int i = 0; i < 64; i++) begin
            fir_item tr = fir_item::type_id::create("tr");
            start_item(tr);
            if (!tr.randomize() with { kind == FIR_COEFF; addr == i; })
                `uvm_fatal("RAND", "coefficient item failed to randomize")
            // Same triangular window as tb/tb_fir_core.v.
            if (!random_taps)
                tr.data = (i < 32) ? 16'((i + 1) * 128) : 16'((64 - i) * 128);
            finish_item(tr);
        end
    endtask
endclass

class fir_sample_seq extends uvm_sequence #(fir_item);
    `uvm_object_utils(fir_sample_seq)
    typedef enum {ZEROS, IMPULSE, RANDOM} mode_e;
    int unsigned count = 1;
    mode_e       mode  = RANDOM;
    bit          gaps  = 1;   // 0: every sample back to back
    function new(string name = "fir_sample_seq");
        super.new(name);
    endfunction
    task body();
        for (int i = 0; i < count; i++) begin
            fir_item tr = fir_item::type_id::create("tr");
            start_item(tr);
            if (!tr.randomize() with { kind == FIR_SAMPLE; })
                `uvm_fatal("RAND", "sample item failed to randomize")
            if (mode == ZEROS)
                tr.data = '0;
            else if (mode == IMPULSE)
                tr.data = (i == 0) ? 16'h4000 : 16'h0000;   // 0.5 in Q1.15
            if (!gaps)
                tr.idle = 0;
            finish_item(tr);
        end
    endtask
endclass

class fir_reset_seq extends uvm_sequence #(fir_item);
    `uvm_object_utils(fir_reset_seq)
    function new(string name = "fir_reset_seq");
        super.new(name);
    endfunction
    task body();
        fir_item tr = fir_item::type_id::create("tr");
        start_item(tr);
        if (!tr.randomize() with { kind == FIR_RESET; })
            `uvm_fatal("RAND", "reset item failed to randomize")
        finish_item(tr);
    endtask
endclass

// ---------------------------------------------------------------------------
// Agent
// ---------------------------------------------------------------------------
class fir_driver extends uvm_driver #(fir_item);
    `uvm_component_utils(fir_driver)
    virtual fir_if vif;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual fir_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "fir_if was not passed to the driver")
    endfunction

    task automatic idle_inputs();
        vif.sample_valid <= 1'b0;
        vif.coeff_we     <= 1'b0;
    endtask

    // rstn starts high and falls at 1ns, so the async-reset flops see a real
    // falling edge on 2-state simulators as well as 4-state ones.
    task automatic power_on_reset();
        vif.rstn       <= 1'b1;
        vif.sample_in  <= '0;
        vif.coeff_data <= '0;
        vif.coeff_addr <= '0;
        idle_inputs();
        #1 vif.rstn <= 1'b0;
        repeat (4) @(negedge vif.clk);
        vif.rstn <= 1'b1;
    endtask

    task automatic drive_reset();
        @(negedge vif.clk);
        vif.rstn <= 1'b0;
        idle_inputs();
        repeat (3) @(negedge vif.clk);
        vif.rstn <= 1'b1;
    endtask

    // Interface rule (a_no_coeff_write_while_busy): only write while idle.
    // sample_valid is low here, so the core cannot leave IDLE under us.
    task automatic drive_coeff(fir_item tr);
        @(negedge vif.clk);
        while (vif.busy) @(negedge vif.clk);
        vif.coeff_addr <= tr.addr;
        vif.coeff_data <= tr.data;
        vif.coeff_we   <= 1'b1;
        @(negedge vif.clk);
        vif.coeff_we   <= 1'b0;
    endtask

    // Offer one sample and hold it until a rising edge sees sample_ready.
    // Values are driven on the falling edge, so the level of sample_ready at
    // a falling edge is the level the next rising edge will sample.
    task automatic drive_sample(fir_item tr);
        @(negedge vif.clk);
        if (tr.idle != 0) begin
            while (!vif.sample_ready) @(negedge vif.clk);
            repeat (tr.idle) @(negedge vif.clk);
        end
        vif.sample_in    <= tr.data;
        vif.sample_valid <= 1'b1;
        while (!vif.sample_ready) @(negedge vif.clk);
        @(posedge vif.clk);   // accepted on this edge
        @(negedge vif.clk);
        vif.sample_valid <= 1'b0;
    endtask

    task run_phase(uvm_phase phase);
        fir_item tr;
        power_on_reset();
        forever begin
            seq_item_port.get_next_item(tr);
            case (tr.kind)
                FIR_COEFF:  drive_coeff(tr);
                FIR_SAMPLE: drive_sample(tr);
                FIR_RESET:  drive_reset();
                default:    `uvm_error("DRV", $sformatf("cannot drive %s", tr.kind.name()))
            endcase
            seq_item_port.item_done();
        end
    endtask
endclass

class fir_monitor extends uvm_monitor;
    `uvm_component_utils(fir_monitor)
    virtual fir_if vif;
    uvm_analysis_port #(fir_item) ap;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual fir_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "fir_if was not passed to the monitor")
    endfunction

    function void publish(fir_kind_e kind, bit [5:0] addr, bit [15:0] data);
        fir_item tr = fir_item::type_id::create("tr");
        tr.kind = kind;
        tr.addr = addr;
        tr.data = data;
        tr.idle = 0;
        ap.write(tr);
    endfunction

    task run_phase(uvm_phase phase);
        bit was_in_reset = 1'b0;
        forever begin
            @(vif.mon_cb);
            if (!vif.mon_cb.rstn) begin
                if (!was_in_reset)
                    publish(FIR_RESET, '0, '0);
                was_in_reset = 1'b1;
                continue;
            end
            was_in_reset = 1'b0;
            // Coefficient first: a write and an accept can share an edge,
            // and the RTL uses the new tap for that sample.
            if (vif.mon_cb.coeff_we)
                publish(FIR_COEFF, vif.mon_cb.coeff_addr, vif.mon_cb.coeff_data);
            if (vif.mon_cb.sample_valid && vif.mon_cb.sample_ready)
                publish(FIR_SAMPLE, '0, vif.mon_cb.sample_in);
            if (vif.mon_cb.output_valid)
                publish(FIR_OUTPUT, '0, vif.mon_cb.filter_out);
        end
    endtask
endclass

class fir_agent extends uvm_agent;
    `uvm_component_utils(fir_agent)
    fir_driver    drv;
    fir_monitor   mon;
    fir_sequencer sqr;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        drv = fir_driver::type_id::create("drv", this);
        mon = fir_monitor::type_id::create("mon", this);
        sqr = fir_sequencer::type_id::create("sqr", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

// ---------------------------------------------------------------------------
// Scoreboard: y[n] = sum_{k=0}^{63} c[k] * x[n-k], 32-bit wrapping
// accumulator, Q2.30 -> Q1.15 by taking acc[30:15] (same as the RTL).
//
// The sample buffer is not reset, so after any reset the first 63 outputs
// depend on what was left in it. Those are counted but not compared.
// ---------------------------------------------------------------------------
class fir_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fir_scoreboard)
    uvm_analysis_imp #(fir_item, fir_scoreboard) imp;

    bit signed [15:0] coeff [64];
    bit signed [15:0] hist  [64];   // hist[0] is the newest sample
    int unsigned      n_since_reset;
    bit        [15:0] expect_q[$];
    bit               check_q [$];

    int unsigned n_sample, n_output, n_checked, n_skipped, n_mismatch;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
    endfunction

    function bit [15:0] golden();
        bit signed [31:0] acc = '0;
        for (int k = 0; k < 64; k++)
            acc = acc + 32'(coeff[k] * hist[k]);
        return acc[30:15];
    endfunction

    function void write(fir_item tr);
        case (tr.kind)
            FIR_RESET: begin
                expect_q.delete();
                check_q.delete();
                n_since_reset = 0;
            end
            FIR_COEFF:
                coeff[tr.addr] = tr.data;
            FIR_SAMPLE: begin
                for (int k = 63; k > 0; k--)
                    hist[k] = hist[k-1];
                hist[0] = tr.data;
                n_since_reset++;
                n_sample++;
                expect_q.push_back(golden());
                check_q.push_back(n_since_reset >= 64);
            end
            FIR_OUTPUT: begin
                n_output++;
                if (expect_q.size() == 0) begin
                    n_mismatch++;
                    `uvm_error("SB", $sformatf("output %04h with no sample outstanding", tr.data))
                end else begin
                    bit [15:0] exp = expect_q.pop_front();
                    bit        chk = check_q.pop_front();
                    if (!chk) begin
                        n_skipped++;
                    end else if (tr.data !== exp) begin
                        n_mismatch++;
                        `uvm_error("SB", $sformatf("FIR mismatch: got %04h (%0d) expected %04h (%0d)",
                                   tr.data, $signed(tr.data), exp, $signed(exp)))
                    end else begin
                        n_checked++;
                    end
                end
            end
        endcase
    endfunction

    function void check_phase(uvm_phase phase);
        if (expect_q.size() != 0)
            `uvm_error("SB", $sformatf("%0d samples never produced an output", expect_q.size()))
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SB", $sformatf("samples=%0d outputs=%0d checked=%0d skipped=%0d mismatches=%0d",
                  n_sample, n_output, n_checked, n_skipped, n_mismatch), UVM_NONE)
    endfunction
endclass

// ---------------------------------------------------------------------------
// Functional coverage on what the monitor saw.
// ---------------------------------------------------------------------------
class fir_coverage extends uvm_subscriber #(fir_item);
    `uvm_component_utils(fir_coverage)
    fir_item tr;

    covergroup cg_sample;
        option.per_instance = 1;
        cp_value: coverpoint tr.data {
            bins zero    = {16'h0000};
            bins max_pos = {16'h7FFF};
            bins max_neg = {16'h8000};
            bins pos     = {[16'h0001:16'h7FFE]};
            bins neg     = {[16'h8001:16'hFFFF]};
        }
    endgroup

    covergroup cg_coeff;
        option.per_instance = 1;
        cp_addr: coverpoint tr.addr {
            bins first = {0};
            bins mid   = {[1:62]};
            bins last  = {63};
        }
        cp_sign: coverpoint tr.data[15] {
            bins pos = {0};
            bins neg = {1};
        }
        addr_x_sign: cross cp_addr, cp_sign;
    endgroup

    covergroup cg_output;
        option.per_instance = 1;
        cp_value: coverpoint tr.data {
            bins zero = {16'h0000};
            bins pos  = {[16'h0001:16'h7FFF]};
            bins neg  = {[16'h8000:16'hFFFF]};
        }
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_sample = new();
        cg_coeff  = new();
        cg_output = new();
    endfunction

    function void write(fir_item t);
        tr = t;
        case (t.kind)
            FIR_SAMPLE: cg_sample.sample();
            FIR_COEFF:  cg_coeff.sample();
            FIR_OUTPUT: cg_output.sample();
            default: ;
        endcase
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("COV", $sformatf("sample %0.1f%%  coeff %0.1f%%  output %0.1f%%",
                  cg_sample.get_inst_coverage(), cg_coeff.get_inst_coverage(),
                  cg_output.get_inst_coverage()), UVM_NONE)
    endfunction
endclass

class fir_env extends uvm_env;
    `uvm_component_utils(fir_env)
    fir_agent      agt;
    fir_scoreboard sb;
    fir_coverage   cov;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        agt = fir_agent::type_id::create("agt", this);
        sb  = fir_scoreboard::type_id::create("sb", this);
        cov = fir_coverage::type_id::create("cov", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        agt.mon.ap.connect(sb.imp);
        agt.mon.ap.connect(cov.analysis_export);
    endfunction
endclass

// ---------------------------------------------------------------------------
// Test
// ---------------------------------------------------------------------------
class fir_uvm_test extends uvm_test;
    `uvm_component_utils(fir_uvm_test)
    fir_env env;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        env = fir_env::type_id::create("env", this);
    endfunction

    task automatic load_coeffs(bit random_taps);
        fir_coeff_seq seq = fir_coeff_seq::type_id::create("coeff_seq");
        seq.random_taps = random_taps;
        seq.start(env.agt.sqr);
    endtask

    task automatic send(int unsigned count, fir_sample_seq::mode_e mode, bit gaps);
        fir_sample_seq seq = fir_sample_seq::type_id::create("sample_seq");
        seq.count = count;
        seq.mode  = mode;
        seq.gaps  = gaps;
        seq.start(env.agt.sqr);
    endtask

    task automatic reset_dut();
        fir_reset_seq seq = fir_reset_seq::type_id::create("reset_seq");
        seq.start(env.agt.sqr);
    endtask

    // Wait for every accepted sample to come out (68-cycle latency each).
    // Polled per clock: `wait` on a method call is not re-evaluated
    // consistently across simulators.
    task automatic drain();
        fork
            while (env.sb.expect_q.size() != 0)
                @(posedge env.agt.drv.vif.clk);
            begin
                #50us;
                `uvm_error("TEST", "timed out waiting for outputs to drain")
            end
        join_any
        disable fork;
        repeat (4) @(posedge env.agt.drv.vif.clk);
    endtask

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        // Phase 1: triangular taps, fill the buffer, then an impulse. The
        // impulse response walks the coefficients out one output at a time.
        load_coeffs(0);
        send(64, fir_sample_seq::ZEROS,   0);
        send(72, fir_sample_seq::IMPULSE, 0);

        // Phase 2: random data with gaps between samples.
        send(150, fir_sample_seq::RANDOM, 1);
        drain();

        // Phase 3: random signed taps, back-to-back random data. Reaches
        // negative outputs and the accumulator overflow corner.
        load_coeffs(1);
        send(200, fir_sample_seq::RANDOM, 0);

        // Phase 4: reset in the middle of the run, reload, keep going.
        reset_dut();
        load_coeffs(0);
        send(104, fir_sample_seq::RANDOM, 1);
        drain();

        if (env.sb.n_mismatch != 0)
            `uvm_error("TEST", $sformatf("%0d output mismatches", env.sb.n_mismatch))
        else if (env.sb.n_checked < 300)
            `uvm_error("TEST", $sformatf("only %0d outputs were compared", env.sb.n_checked))
        else if (!env.agt.drv.vif.covers_ok())
            `uvm_error("TEST", "SVA covers (back-to-back, pointer wrap, negative, overflow) were not all hit")
        else
            `uvm_info("PASS", $sformatf("UVM PASS fir: %0d outputs checked against the reference model",
                      env.sb.n_checked), UVM_NONE)

        phase.drop_objection(this);
    endtask
endclass

module tb_fir_uvm;
    logic clk;
    fir_if vif(.clk(clk));

    fir_core dut (
        .clk          (clk),
        .rstn         (vif.rstn),
        .sample_in    (vif.sample_in),
        .sample_valid (vif.sample_valid),
        .sample_ready (vif.sample_ready),
        .filter_out   (vif.filter_out),
        .output_valid (vif.output_valid),
        .coeff_data   (vif.coeff_data),
        .coeff_addr   (vif.coeff_addr),
        .coeff_we     (vif.coeff_we),
        .busy         (vif.busy)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        uvm_config_db#(virtual fir_if)::set(null, "*", "vif", vif);
        run_test("fir_uvm_test");
    end

    initial begin
        #2ms;
        $fatal(1, "fir UVM test timed out");
    end
endmodule
