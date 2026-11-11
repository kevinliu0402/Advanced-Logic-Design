# PPA summary

| Run | Design | Area | Seq% | Cells | Period(ns) | Setup WNS(ns) | Hold | Fmax(MHz) | Power(uW) |
|---|---|---|---|---|---|---|---|---|---|
| fir_dc | fir_core | 33839 | 45.6 | 11637 | 30.00 | -1.07 | 0.86 | 32.2 | 69.00 (DC) |
| fir_pt | fir_core | - | - | - | 30.00 | -1.07 | MET | 32.2 | 44.48 (PT) |
| async_fifo | fifo | 1992 | 60.3 | 545 | - | - | - | - | 73.55 (DC) |
| regfile_cmem | reg_file | 10935 | 66.6 | 2983 | - | - | - | - | - |

## Flags

- **fir_dc**: SETUP VIOLATED: worst slack -1.07 ns on u_sample_buf/rdata_reg[1] -> u_fir_alu/accumulator_reg[31] (4 path(s) reported failing)
- **fir_pt**: SETUP VIOLATED: worst slack -1.07 ns on u_sample_buf/rdata_reg[1] -> u_fir_alu/accumulator_reg[31] (4 path(s) reported failing); no area report found
- **async_fifo**: 1 reported path(s) are UNCONSTRAINED (missing clock or I/O delay constraints?)
- **regfile_cmem**: 1 reported path(s) are UNCONSTRAINED (missing clock or I/O delay constraints?); no power report found
