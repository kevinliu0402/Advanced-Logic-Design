// UVM testbench for the async FIFO. VCS compiles this with -ntb_opts uvm-1.2.
// The existing fifo_sva.sv bind is still compiled, so the assertions run too.
//
// Pieces:
//   fifo_item       one write or one read
//   fifo_sequence   the same traffic as tb_fifo_sva: 5 words, then fill and drain
//   fifo_driver     performs the bus cycle, and waits out full/empty
//   fifo_monitor    watches accepted writes and reads
//   fifo_scoreboard checks that reads come back in order
//   fifo_uvm_test   starts the sequence and checks the SVA covers

`timescale 1ns/1ps

interface fifo_if (input logic clk1, input logic clk2);
    logic             wrst_n, rrst_n;
    logic             winc, rinc;
    logic             wfull, rempty;
    logic [7:0]       wdata, rdata;

    function bit covers_ok();
        return tb_fifo_uvm.dut.u_fifo_sva.cov_full
            && tb_fifo_uvm.dut.u_fifo_sva.cov_left_empty
            && tb_fifo_uvm.dut.u_fifo_sva.cov_full_to_empty;
    endfunction
endinterface

import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_item extends uvm_sequence_item;
    rand bit       is_write;
    rand bit [7:0] data;
    `uvm_object_utils_begin(fifo_item)
        `uvm_field_int(is_write, UVM_ALL_ON)
        `uvm_field_int(data,     UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name = "fifo_item");
        super.new(name);
    endfunction
endclass

class fifo_sequencer extends uvm_sequencer #(fifo_item);
    `uvm_component_utils(fifo_sequencer)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class fifo_driver extends uvm_driver #(fifo_item);
    `uvm_component_utils(fifo_driver)
    virtual fifo_if vif;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "fifo_if was not passed to the driver")
    endfunction

    task automatic do_reset();
        vif.wrst_n <= 1'b0;
        vif.rrst_n <= 1'b0;
        vif.winc   <= 1'b0;
        vif.rinc   <= 1'b0;
        vif.wdata  <= '0;
        repeat (4) @(posedge vif.clk1);
        repeat (4) @(posedge vif.clk2);
        vif.wrst_n <= 1'b1;
        vif.rrst_n <= 1'b1;
        repeat (2) @(posedge vif.clk1);
    endtask

    task automatic do_write(bit [7:0] data);
        @(negedge vif.clk1);
        while (vif.wfull) @(negedge vif.clk1);
        vif.wdata <= data;
        vif.winc  <= 1'b1;
        @(negedge vif.clk1);
        vif.winc  <= 1'b0;
    endtask

    task automatic do_read();
        @(negedge vif.clk2);
        while (vif.rempty) @(negedge vif.clk2);
        vif.rinc <= 1'b1;
        @(negedge vif.clk2);
        vif.rinc <= 1'b0;
    endtask

    task run_phase(uvm_phase phase);
        fifo_item tr;
        do_reset();
        forever begin
            seq_item_port.get_next_item(tr);
            if (tr.is_write)
                do_write(tr.data);
            else
                do_read();
            seq_item_port.item_done();
        end
    endtask
endclass

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)
    virtual fifo_if vif;
    uvm_analysis_port #(fifo_item) ap;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction
    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "fifo_if was not passed to the monitor")
    endfunction
    task run_phase(uvm_phase phase);
        fork
            forever begin
                @(posedge vif.clk1);
                if (vif.wrst_n && vif.winc && !vif.wfull)
                    publish(1'b1, vif.wdata);
            end
            forever begin
                @(posedge vif.clk2);
                if (vif.rrst_n && vif.rinc && !vif.rempty)
                    publish(1'b0, vif.rdata);
            end
        join
    endtask
    function void publish(bit is_write, bit [7:0] data);
        fifo_item tr = fifo_item::type_id::create("tr");
        tr.is_write = is_write;
        tr.data     = data;
        ap.write(tr);
    endfunction
endclass

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)
    uvm_analysis_imp #(fifo_item, fifo_scoreboard) imp;
    bit [7:0] expect_q[$];
    int n_write, n_read, n_mismatch;
    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
    endfunction
    function void write(fifo_item tr);
        if (tr.is_write) begin
            expect_q.push_back(tr.data);
            n_write++;
        end else begin
            n_read++;
            if (expect_q.size() == 0) begin
                n_mismatch++;
                `uvm_error("FIFO", "read with nothing written")
            end else if (tr.data !== expect_q[0]) begin
                n_mismatch++;
                `uvm_error("FIFO", $sformatf("got %02h expected %02h", tr.data, expect_q[0]))
            end else begin
                void'(expect_q.pop_front());
            end
        end
    endfunction
endclass

class fifo_agent extends uvm_agent;
    `uvm_component_utils(fifo_agent)
    fifo_driver    drv;
    fifo_monitor   mon;
    fifo_sequencer sqr;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        drv = fifo_driver::type_id::create("drv", this);
        mon = fifo_monitor::type_id::create("mon", this);
        sqr = fifo_sequencer::type_id::create("sqr", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)
    fifo_agent      agt;
    fifo_scoreboard sb;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        agt = fifo_agent::type_id::create("agt", this);
        sb  = fifo_scoreboard::type_id::create("sb", this);
    endfunction
    function void connect_phase(uvm_phase phase);
        agt.mon.ap.connect(sb.imp);
    endfunction
endclass

class fifo_sequence extends uvm_sequence #(fifo_item);
    `uvm_object_utils(fifo_sequence)
    function new(string name = "fifo_sequence");
        super.new(name);
    endfunction
    task automatic send_item(bit is_write, bit [7:0] data = '0);
        fifo_item tr = fifo_item::type_id::create("tr");
        start_item(tr);
        tr.is_write = is_write;
        tr.data     = data;
        finish_item(tr);
    endtask
    task body();
        for (int i = 0; i < 5; i++)
            send_item(1, 8'hA0 + i);
        for (int i = 0; i < 5; i++)
            send_item(0);
        for (int i = 0; i < 16; i++)
            send_item(1, 8'h10 + i);
        for (int i = 0; i < 16; i++)
            send_item(0);
    endtask
endclass

class fifo_uvm_test extends uvm_test;
    `uvm_component_utils(fifo_uvm_test)
    fifo_env env;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        env = fifo_env::type_id::create("env", this);
    endfunction
    task run_phase(uvm_phase phase);
        fifo_sequence seq = fifo_sequence::type_id::create("seq");
        phase.raise_objection(this);
        seq.start(env.agt.sqr);
        repeat (4) @(posedge env.agt.drv.vif.clk1);
        repeat (4) @(posedge env.agt.drv.vif.clk2);
        if (env.sb.n_mismatch != 0 || env.sb.n_write != 21 || env.sb.n_read != 21)
            `uvm_error("FIFO", $sformatf("scoreboard writes=%0d reads=%0d mismatches=%0d",
                       env.sb.n_write, env.sb.n_read, env.sb.n_mismatch))
        else if (!env.agt.drv.vif.covers_ok())
            `uvm_error("FIFO", "SVA covers for full and empty were not hit")
        else
            `uvm_info("PASS", "UVM PASS fifo", UVM_NONE)
        phase.drop_objection(this);
    endtask
endclass

module tb_fifo_uvm;
    logic clk1, clk2;
    fifo_if vif(.clk1(clk1), .clk2(clk2));

    fifo #(.DSIZE(8), .ASIZE(4)) dut (
        .clk1   (clk1),
        .wrst_n (vif.wrst_n),
        .clk2   (clk2),
        .rrst_n (vif.rrst_n),
        .winc   (vif.winc),
        .rinc   (vif.rinc),
        .wdata  (vif.wdata),
        .rdata  (vif.rdata),
        .wfull  (vif.wfull),
        .rempty (vif.rempty)
    );

    initial clk1 = 1'b0;
    always #4 clk1 = ~clk1;
    initial begin
        clk2 = 1'b0;
        #1;
        forever #6 clk2 = ~clk2;
    end

    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
        run_test("fifo_uvm_test");
    end

    initial begin
        #2ms;
        $fatal(1, "fifo UVM test timed out");
    end
endmodule
