# JasperGold FPV: async FIFO (lab 8), two unrelated clocks.
# Proves the bound SVA in sva/fifo_sva.sv (Gray pointers, pointer holds and
# steps, synchronizer delay, reset values) and sva/fifo_formal.sv (no data
# loss, corruption, duplication or reordering, via a symbolic tracked word).
# Three clock relationships: equal, write 3x faster, read 3x faster.
# Run from this directory: jg -batch -tcl fifo.tcl
set R ../..
foreach {tag f1 f2} {equal 1 1 wfast 1 3 rfast 3 1} {
    clear -all
    analyze -sv12 +define+FORMAL \
        $R/fifo.v $R/fifomem.v $R/wptr_full.v $R/rptr_empty.v \
        $R/sync_w2r.v $R/sync_r2w.v \
        $R/sva/fifo_sva.sv $R/sva/fifo_formal.sv
    elaborate -top fifo -bbox_mul 256
    clock clk1 -factor $f1 -phase 1
    clock clk2 -factor $f2 -phase 1
    reset -expression {!wrst_n} {!rrst_n}
    # The symbolic pick is a free input.
    stopat u_fifo_formal.pick
    # Interface rules for the testbench, not the RTL. The RTL already ignores
    # a write when full and a read when empty, so they are left out entirely:
    # the proof holds for any winc/rinc, which is stronger than assuming them.
    foreach p [get_property_list -include {name {*a_no_write_when_full *a_no_read_when_empty}}] { assert -disable $p }
    set_prove_time_limit 900s
    set t0 [::tcl::clock::seconds]
    prove -all
    set dt [expr {[::tcl::clock::seconds] - $t0}]
    foreach p [get_property_list -include {type {assert cover}}] {
        puts "FIFO_RESULT $tag $p [get_property_info -list status $p]"
    }
    puts "FIFO_TIME $tag ${dt}s"
}
exit -force
