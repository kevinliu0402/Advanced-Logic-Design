#!/bin/bash
# Compile and run this repo's async-FIFO SVA testbench with VCS.
# An assertion failure stops the sim. A good run prints "SVA PASS fifo".
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="${TMPDIR:-/tmp}/kl3755_sva/fifo"
rm -rf "$OUT"
mkdir -p "$OUT"

cd "$OUT"
vcs -sverilog -full64 \
    -timescale=1ns/1ps \
    -assert enable_hier \
    "${ROOT}/fifo.v" \
    "${ROOT}/fifomem.v" \
    "${ROOT}/wptr_full.v" \
    "${ROOT}/rptr_empty.v" \
    "${ROOT}/sync_w2r.v" \
    "${ROOT}/sync_r2w.v" \
    "${ROOT}/sva/fifo_sva.sv" \
    "${ROOT}/sva/tb_fifo_sva.sv" \
    -o simv
./simv -assert finish_maxfail=1
