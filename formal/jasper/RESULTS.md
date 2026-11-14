# JasperGold results: async FIFO and FIR core

Cadence JasperGold 2024.06p002 (FPV) on the Columbia micro servers.
Per-property status: `fifo_results.txt`, `../../lab9-fir/formal/jasper/fir_results.txt`.

## Async FIFO (`fifo.tcl`)

Two unrelated clocks, run at three ratios: equal, write 3x faster, read 3x faster.

| Ratio | Assertions proven | Covers reached | CEX | Time |
|---|---|---|---|---|
| equal | 16 / 16 enabled | 4 / 4 | 0 | 758 s |
| write 3x faster | 16 / 16 enabled | 4 / 4 | 0 | 734 s |
| read 3x faster | 16 / 16 enabled | 4 / 4 | 0 | 658 s |

- Proven: Gray-code write/read pointers change by at most one bit and by
  exactly one on an accepted access; pointers hold otherwise; both 2-flop
  synchronizers are exact 2-cycle delays; and data integrity (below).
- The reset-value checks (`a_*_reset`, `a_*_during_reset`) pass only
  vacuously here: JasperGold keeps reset released after its reset phase, so
  their preconditions are unreachable. Reset behavior stays checked in
  simulation.
- Data integrity (`sva/fifo_formal.sv`): the simulation scoreboard uses a
  queue, which formal tools cannot model. The formal version tracks one
  symbolic write chosen by the solver and proves the matching read returns
  the same data, so no word is lost, corrupted, duplicated, or reordered.
  A first version of this checker gave a false counterexample (151 cycles):
  the read counter wrapped and re-matched an old write number. Fixed by
  checking only the first matching read.
- `a_no_write_when_full` / `a_no_read_when_empty` are testbench rules, not
  RTL properties, so they are disabled rather than assumed: the RTL already
  ignores those accesses, and the proof holds for any `winc`/`rinc`.

## FIR core (`../../lab9-fir/formal/jasper/fir.tcl`)

| Assertions proven | Covers reached | CEX | Undetermined | Time |
|---|---|---|---|---|
| 36 / 36 | 6 / 6 | 0 | 0 | 297 s |

- Proven for all inputs: the FSM, the 66-cycle COMPUTE length and 69-cycle
  latency, exactly 64 MACs per sample, accumulator clear/hold, circular-buffer
  read-address and write-pointer arithmetic, and the low-power properties
  (isolation before switch-off, full wake-up time, no MAC activity unless
  PD_MAC is ready, PD_MAC on while computing, clock gate covers every
  accumulator update).
- `a_reset_state` is among the 36 but passes only vacuously (reset stays
  released after JasperGold's reset phase); the other 35 are real proofs.
- Covers reached: back-to-back samples, pointer wrap, negative output,
  accumulator overflow, PD_MAC shutdown, sample accepted while PD_MAC was off.
- Setup: `clock clk -both_edges` so the clock-gate latch is modeled;
  `reset -max_iterations 400` because the 68-cycle `$past` history needs more
  than the default 100 iterations to settle; inputs quiet during reset
  (`assume -reset`); coefficient writes only while idle (assumption).
- The queue-based golden model (section 6 of `sva/fir_core_sva.sv`) is
  simulation-only and excluded with `FORMAL`; the output values themselves
  stay checked in simulation (531/531).
