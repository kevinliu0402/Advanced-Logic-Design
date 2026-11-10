#!/bin/bash
# Compile and run this repo's FIR SVA testbench.
#   ./run_sva.sh            VCS (default)
#   ./run_sva.sh verilator  Verilator 5.x
# An assertion failure stops the sim. A good run prints "SVA PASS fir".
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
OUT="${TMPDIR:-/tmp}/kl3755_sva/fir"
rm -rf "$OUT"
mkdir -p "$OUT"

SRCS=(
    "${ROOT}/rtl/fir_core.v"
    "${ROOT}/rtl/fir_alu.v"
    "${ROOT}/rtl/cmem.v"
    "${ROOT}/rtl/reg_file.v"
    "${ROOT}/sva/fir_core_sva.sv"
    "${ROOT}/sva/tb_fir_core_sva.sv"
)

cd "$OUT"
case "${1:-vcs}" in
    vcs)
        vcs -sverilog -full64 \
            -timescale=1ns/1ps \
            -assert enable_hier \
            "${SRCS[@]}" \
            -o simv
        ./simv -assert finish_maxfail=1
        ;;
    verilator)
        verilator --binary --assert --timing \
            -Wno-fatal -Wno-lint -Wno-style -Wno-TIMESCALEMOD -Wno-TICKCOUNT \
            --Mdir obj --top-module tb_fir_core_sva \
            "${SRCS[@]}"
        ./obj/Vtb_fir_core_sva
        ;;
    *)
        echo "usage: $0 [vcs|verilator]" >&2
        exit 2
        ;;
esac
