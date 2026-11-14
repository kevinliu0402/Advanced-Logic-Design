#!/bin/bash
# Lint the FIR core RTL with Verilator (-Wall). Exits non-zero on any warning.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
verilator --lint-only -Wall --top-module fir_core \
    "${ROOT}/rtl/fir_core.v" "${ROOT}/rtl/fir_alu.v" "${ROOT}/rtl/cmem.v" \
    "${ROOT}/rtl/reg_file.v" "${ROOT}/rtl/fir_icg.v" "${ROOT}/rtl/fir_pmu.v"
echo "LINT CLEAN fir_core"
