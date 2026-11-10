#!/bin/bash
# Compile and run this repo's async-FIFO UVM testbench with VCS.
# The SVA bind is compiled too. A good run prints "UVM PASS fifo".
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="${TMPDIR:-/tmp}/kl3755_uvm/fifo"
rm -rf "$OUT"
mkdir -p "$OUT"

cd "$OUT"
vcs -sverilog -full64 \
    -ntb_opts uvm-1.2 \
    -timescale=1ns/1ps \
    -assert enable_hier \
    "${ROOT}/fifo.v" \
    "${ROOT}/fifomem.v" \
    "${ROOT}/wptr_full.v" \
    "${ROOT}/rptr_empty.v" \
    "${ROOT}/sync_w2r.v" \
    "${ROOT}/sync_r2w.v" \
    "${ROOT}/sva/fifo_sva.sv" \
    "${ROOT}/uvm/tb_fifo_uvm.sv" \
    -o simv
./simv +UVM_VERBOSITY=UVM_LOW -assert finish_maxfail=1 | tee sim.log
grep -q "UVM PASS fifo" sim.log
grep -q "UVM_ERROR :    0" sim.log
grep -q "UVM_FATAL :    0" sim.log
