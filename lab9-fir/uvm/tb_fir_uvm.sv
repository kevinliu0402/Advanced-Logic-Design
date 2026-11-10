// UVM testbench for the 64-tap FIR core. Compile with VCS -ntb_opts uvm-1.2.
// fir_core_sva.sv stays bound, so the FSM, handshake, and latency assertions
// still run. This bench sends the same two back-to-back samples as
// tb_fir_core_sva and counts the output pulses in a scoreboard.

`timescale 1ns/1ps

interface fir_if (input logic clk);
    logic        rstn;
    logic [15:0] sample_in;
    logic        sample_valid;
    logic        sample_ready;
    logic [15:0] filter_out;
    logic        output_valid;
    logic        busy;

    function bit covers_ok();
        return tb_fir_uvm.dut.u_fir_core_sva.cov_output
            && tb_fir_uvm.dut.u_fir_core_sva.cov_last_tap;
    endfunction
endinterface

import uvm_pkg::*;
`include "uvm_macros.svh"

class fir_item extends uvm_sequence_item;
    rand bit [15:0] sample;
    bit             last;
    `uvm_object_utils_begin(fir_item)
        `uvm_field_int(sample, UVM_ALL_ON)
        `uvm_field_int(last,   UVM_ALL_ON)
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

    task automatic do_reset();
        vif.rstn         <= 1'b0;
        vif.sample_in    <= 16'h0100;
        vif.sample_valid <= 1'b0;
        repeat (4) @(posedge vif.clk);
        vif.rstn <= 1'b1;
    endtask

    // Hold valid across the whole burst. Both samples use the same value
    // because the core requires sample_in to stay stable while busy.
    task automatic drive_burst(fir_item tr[$]);
        int seen;
        @(negedge vif.clk);
        vif.sample_in    <= tr[0].sample;
        vif.sample_valid <= 1'b1;
        seen = 0;
        while (seen < tr.size()) begin
            @(posedge vif.clk);
            if (vif.output_valid)
                seen++;
        end
        @(negedge vif.clk);
        vif.sample_valid <= 1'b0;
        repeat (4) @(posedge vif.clk);
    endtask

    task run_phase(uvm_phase phase);
        fir_item tr;
        fir_item burst[$];
        do_reset();
        // Block for each item. `last` tells the driver the burst is complete,
        // so it does not have to guess whether another item is coming.
        do begin
            seq_item_port.get_next_item(tr);
            burst.push_back(tr);
            seq_item_port.item_done();
        end while (!tr.last);
        drive_burst(burst);
        forever seq_item_port.get_next_item(tr);
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
    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if (vif.rstn && vif.output_valid) begin
                fir_item tr = fir_item::type_id::create("tr");
                tr.sample = vif.filter_out;
                ap.write(tr);
            end
        end
    endtask
endclass

class fir_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fir_scoreboard)
    uvm_analysis_imp #(fir_item, fir_scoreboard) imp;
    int n_output;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
    endfunction
    function void write(fir_item tr);
        n_output++;
        `uvm_info("FIR", $sformatf("output %0d data=%04h", n_output, tr.sample), UVM_LOW)
    endfunction
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

class fir_env extends uvm_env;
    `uvm_component_utils(fir_env)
    fir_agent      agt;
    fir_scoreboard sb;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        agt = fir_agent::type_id::create("agt", this);
        sb  = fir_scoreboard::type_id::create("sb", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        agt.mon.ap.connect(sb.imp);
    endfunction
endclass

class fir_sequence extends uvm_sequence #(fir_item);
    `uvm_object_utils(fir_sequence)
    function new(string name = "fir_sequence");
        super.new(name);
    endfunction
    task body();
        fir_item tr;
        // Two items, same sample. The driver holds that value for the burst.
        for (int i = 0; i < 2; i++) begin
            tr = fir_item::type_id::create("tr");
            start_item(tr);
            tr.sample = 16'h0100;
            tr.last   = (i == 1);
            finish_item(tr);
        end
        // The second item is the end of the burst. Both carry the same
        // sample because sample_in has to stay stable while the core is busy.
    endtask
endclass

class fir_uvm_test extends uvm_test;
    `uvm_component_utils(fir_uvm_test)
    fir_env env;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        env = fir_env::type_id::create("env", this);
    endfunction
    task run_phase(uvm_phase phase);
        fir_sequence seq = fir_sequence::type_id::create("seq");
        phase.raise_objection(this);
        seq.start(env.agt.sqr);
        // The driver consumes both items, then drives the burst, then blocks.
        // Wait until the scoreboard has both pulses. 200 us is far past the
        // 68-cycle latency of two 64-tap runs.
        fork
            wait (env.sb.n_output >= 2);
            begin
                #200us;
                `uvm_error("FIR", "timed out waiting for two outputs")
            end
        join_any
        disable fork;
        repeat (4) @(posedge env.agt.drv.vif.clk);
        if (env.sb.n_output != 2)
            `uvm_error("FIR", $sformatf("saw %0d outputs, expected 2", env.sb.n_output))
        else if (!env.agt.drv.vif.covers_ok())
            `uvm_error("FIR", "SVA covers for output and last tap were not hit")
        else
            `uvm_info("PASS", "UVM PASS fir", UVM_NONE)
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
        .coeff_data   (16'b0),
        .coeff_addr   (6'b0),
        .coeff_we     (1'b0),
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
