#!/bin/bash
# Compile and run this repo's FIR UVM testbench with VCS.
# The SVA bind is compiled too. A good run prints "UVM PASS fir".
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="${TMPDIR:-/tmp}/kl3755_uvm/fir"
rm -rf "$OUT"
mkdir -p "$OUT"

cd "$OUT"
vcs -sverilog -full64 \
    -ntb_opts uvm-1.2 \
    -timescale=1ns/1ps \
    -assert enable_hier \
    "${ROOT}/rtl/fir_core.v" \
    "${ROOT}/rtl/fir_alu.v" \
    "${ROOT}/rtl/cmem.v" \
    "${ROOT}/rtl/reg_file.v" \
    "${ROOT}/sva/fir_core_sva.sv" \
    "${ROOT}/uvm/tb_fir_uvm.sv" \
    -o simv
./simv +UVM_VERBOSITY=UVM_LOW -assert finish_maxfail=1 | tee sim.log
grep -q "UVM PASS fir" sim.log
grep -q "UVM_ERROR :    0" sim.log
grep -q "UVM_FATAL :    0" sim.log
