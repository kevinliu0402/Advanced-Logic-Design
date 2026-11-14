#!/bin/bash
# Synthesize the FIR core with Design Compiler, regenerate switching activity,
# and run PrimeTime timing + power. Needs dc_shell, pt_shell and iverilog (or
# swap in VCS for the VCD step). Reports land in reports/ and reports_pt/.
#   ./run_ppa.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"

# 1. Activity for PrimeTime power: run the lab testbench and dump a VCD.
mkdir -p "$ROOT/sim"
cd "$ROOT/sim"
iverilog -g2012 -o tb.vvp ../tb/tb_fir_core.v ../rtl/fir_core.v ../rtl/fir_alu.v \
    ../rtl/cmem.v ../rtl/reg_file.v ../rtl/fir_icg.v ../rtl/fir_pmu.v
vvp -n tb.vvp | tee tb.log
grep -q "ALL TESTS PASSED" tb.log

# 2. Synthesis.
cd "$ROOT/synth"
dc_shell -f synth_fir_core.tcl | tee dc.log

# 3. Static timing and power on the netlist.
cd "$ROOT/pt"
pt_shell -f pt_fir_core.tcl | tee pt.log

cat "$ROOT/reports_pt/fir_core_executive_summary.rpt"
