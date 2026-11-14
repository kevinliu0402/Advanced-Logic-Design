# JasperGold FPV: FIR core control, datapath-control, latency, and low-power
# properties (sva/fir_core_sva.sv sections 1-5 and 8; the queue-based golden
# model in section 6 is simulation-only and excluded with FORMAL).
# Run from this directory: jg -batch -tcl fir.tcl
set R ../..
clear -all
analyze -sv12 +define+FORMAL \
    $R/rtl/cmem.v $R/rtl/reg_file.v $R/rtl/fir_alu.v $R/rtl/fir_icg.v \
    $R/rtl/fir_pmu.v $R/rtl/fir_core.v $R/sva/fir_core_sva.sv
elaborate -top fir_core -bbox_mul 256 -bbox_div 256 -bbox_mod 256
# Both edges: the clock-gate latch is transparent while clk is low.
clock clk -both_edges
# Inputs are quiet while rstn is held, so reset analysis converges (free
# coefficient writes would keep changing the coefficient memory).
assume -reset {!coeff_we && !sample_valid}
# The 68-cycle $past history in the latency checks needs ~140 half-cycle
# iterations to settle with -both_edges (default limit is 100).
reset -expression {!rstn} -max_iterations 400
# Coefficients are only loaded while idle (a_no_coeff_write_while_busy is a
# testbench rule); make it an assumption for the proof.
foreach p [get_property_list -include {name *a_no_coeff_write_while_busy}] {
    assert -disable $p
}
assume -name env_no_coeff_write_while_busy {@(posedge clk) disable iff (!rstn) coeff_we |-> !busy}
set_prove_time_limit 1800s
set t0 [::tcl::clock::seconds]
prove -all
set dt [expr {[::tcl::clock::seconds] - $t0}]
foreach p [get_property_list -include {type {assert cover}}] {
    puts "FIR_RESULT $p [get_property_info -list status $p]"
}
puts "FIR_TIME ${dt}s"
exit -force
