# File: synth.tcl

read_verilog [list \
    ../src/fifo.v \
    ../src/fifomem.v \
    ../src/rptr_empty.v \
    ../src/wptr_full.v \
    ../src/sync_r2w.v \
    ../src/sync_w2r.v \
]

# Set libraries
set target_library "/tools/synopsys/syn/current/libraries/syn/class.db"
set link_library "* $target_library"

# Set the top-level design name
current_design fifo

# Link and check the design
link

# Compile with medium effort
compile -map_effort medium

# Save synthesized netlist
write -format verilog -hierarchy -output ../netlist/fifo.nl.v

# Save synthesis reports
report_timing > ../reports/timing.rpt
report_area > ../reports/area.rpt
report_power > ../reports/power.rpt