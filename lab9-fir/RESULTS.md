# FIR core: pipelined MAC, clock gating, MAC power domain

Run on the Columbia micro servers (Synopsys DC U-2022.12-SP7, PrimeTime U-2022.12-SP5,
`class.db`, 30 ns clock, same constraints as the original lab 9 script).
Switching activity comes from the same lab testbench (`tb/tb_fir_core.v`)
run in Icarus Verilog for every version, read into PrimeTime as an RTL VCD.

## Timing, area, power

| Version | Setup slack @ 30 ns | Area (um^2) | Avg power | ALU power |
|---|---|---|---|---|
| Original (single-cycle MAC) | -1.067 ns, violated | 33,825 | 50.8 uW | 22.4 uW |
| Pipelined MAC, no clock gate | +0.001 ns, met | 33,852 | 38.2 uW | 9.8 uW |
| Pipelined MAC + ALU clock gate | +0.003 ns, met | 33,860 | 29.9 uW | 9.7 uW |

- The old critical path was sample-buffer read -> 16x16 multiply -> 32-bit
  add -> accumulator. The new one ends at the product register
  (`u_fir_alu/product_q_reg`). Latency per sample goes from 68 to 69 cycles.
- Power numbers are PrimeTime estimates from RTL-level activity, so they show
  the trend, not sign-off values. PrimeTime does not model the PD_MAC power
  switch (no UPF in the PrimeTime run), so leakage savings from power gating
  are not included.
- Reports: `results/` (baseline and no-clock-gate variant) and
  `results/pipelined_cg/`. `./run_ppa.sh` re-runs synthesis, STA and power.

## Verification

- `./run_sva.sh verilator`: all assertions pass; the golden model matches
  531/531 outputs. Covers hit: back-to-back samples, pointer wrap, negative
  output, accumulator overflow, PD_MAC shutdown, sample accepted while
  PD_MAC was off.
- New SVA (section 8 of `sva/fir_core_sva.sv`): isolation before switch-off,
  full wake time before isolation release, no MAC activity unless PD_MAC is
  ready, PD_MAC stays on while computing, the clock gate covers every
  accumulator update.
- Mutation check: 5 injected bugs (early isolation release, switch-off without
  isolation, clock gate missing a term, ready ignoring the wake-up, COMPUTE
  ending a cycle early) are each caught by the intended assertion.
- `tb/tb_fir_core.v` (original lab testbench): all 5 tests pass.
- `COV=1 ./run_uvm.sh` on VCS: UVM PASS, 463 outputs checked. DUT coverage:
  line 100%, condition 98.6%, toggle 99.4%, FSM transitions 83.3%,
  branch 96.4%, assertions 100% (`results/fir_uvm_coverage.txt`). The FSM
  transitions not hit are the reset arcs (WAKE -> OFF, STORE -> IDLE).
- `./run_lint.sh`: Verilator `-Wall` clean.
