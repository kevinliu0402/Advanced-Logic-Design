#!/bin/bash
# Compile and run this repo's FIR SVA testbench with VCS.
# An assertion failure stops the sim. A good run prints "SVA PASS fir".
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="${TMPDIR:-/tmp}/kl3755_sva/fir"
rm -rf "$OUT"
mkdir -p "$OUT"

cd "$OUT"
vcs -sverilog -full64 \
    -timescale=1ns/1ps \
    -assert enable_hier \
    "${ROOT}/rtl/fir_core.v" \
    "${ROOT}/rtl/fir_alu.v" \
    "${ROOT}/rtl/cmem.v" \
    "${ROOT}/rtl/reg_file.v" \
    "${ROOT}/sva/fir_core_sva.sv" \
    "${ROOT}/sva/tb_fir_core_sva.sv" \
    -o simv
./simv -assert finish_maxfail=1
