# ===========================================================================
# Synthesis Script for FIR Filter Core
# ===========================================================================
# Author: Kevin Liu
# UNI: kl3755
# Course: CSEE W4823 Advanced Logic Design - Lab 9
# ===========================================================================

set DESIGN_NAME "fir_core"

# ===========================================================================
# Library Setup
# ===========================================================================
# Note: Update the path to match your environment
set target_library "/tools/synopsys/syn/current/libraries/syn/class.db"
set link_library "* $target_library"

# ===========================================================================
# Read RTL Design Files
# ===========================================================================

puts "========================================="
puts "Reading RTL files..."
puts "========================================="

# Read all RTL modules
read_verilog ../rtl/fir_alu.v
read_verilog ../rtl/cmem.v
read_verilog ../rtl/reg_file.v
read_verilog ../rtl/fir_icg.v
read_verilog ../rtl/fir_pmu.v
read_verilog ../rtl/fir_core.v

# Set current design
current_design $DESIGN_NAME

# Link the design
link

# Check design
check_design

# ===========================================================================
# Design Constraints
# ===========================================================================

puts "========================================="
puts "Setting design constraints..."
puts "========================================="

# Clock period in ns (33 MHz - relaxed for timing closure)
set CLK_PERIOD 30
set CLK_NAME "clk"

# Create clock
create_clock -name $CLK_NAME -period $CLK_PERIOD [get_ports clk]

# Set clock uncertainty (for setup/hold margin)
set_clock_uncertainty 0.2 [get_clocks $CLK_NAME]

# Set clock transition
set_clock_transition 0.1 [get_clocks $CLK_NAME]

# Set clock latency
set_clock_latency -source 0.5 [get_clocks $CLK_NAME]
set_clock_latency 0.3 [get_clocks $CLK_NAME]

# Input delays (70% of clock period)
set INPUT_DELAY [expr $CLK_PERIOD * 0.7]
set_input_delay $INPUT_DELAY -clock $CLK_NAME [remove_from_collection [all_inputs] [get_ports clk]]

# Output delays (30% of clock period)
set OUTPUT_DELAY [expr $CLK_PERIOD * 0.3]
set_output_delay $OUTPUT_DELAY -clock $CLK_NAME [all_outputs]

# Set driving cell for inputs
set_driving_cell -lib_cell BUFX2 -pin Y [remove_from_collection [all_inputs] [get_ports clk]]

# Set load on outputs
set_load 0.05 [all_outputs]

# ===========================================================================
# Design Rules
# ===========================================================================

puts "========================================="
puts "Setting design rules..."
puts "========================================="

# Set maximum transition time
set_max_transition 0.5 [current_design]

# Set maximum fanout
set_max_fanout 20 [current_design]

# Set maximum capacitance
set_max_capacitance 0.5 [all_outputs]

# Set area optimization effort
set_max_area 0

# ===========================================================================
# Compile the Design
# ===========================================================================

puts "========================================="
puts "Compiling design..."
puts "========================================="

# First compile
compile -map_effort medium

# Incremental compile for optimization
compile -incremental_mapping

puts "========================================="
puts "Generating reports..."
puts "========================================="

# Create reports directory
sh mkdir -p ../reports

# Report timing
report_timing -max_paths 10 -nworst 1 -delay_type max > ../reports/${DESIGN_NAME}_timing.rpt
report_timing -delay_type min > ../reports/${DESIGN_NAME}_timing_min.rpt

# Report area
report_area -hierarchy > ../reports/${DESIGN_NAME}_area.rpt

# Report power (estimated)
report_power -hierarchy > ../reports/${DESIGN_NAME}_power_est.rpt

# Report constraints
report_constraint -all_violators > ../reports/${DESIGN_NAME}_constraints.rpt

# Clock gating: the RTL ICG (u_alu_icg) gates the pipelined MAC; also report
# the gating checks DC derives on it.
report_clock_gating -verbose > ../reports/${DESIGN_NAME}_clock_gating.rpt

# Report design
report_design > ../reports/${DESIGN_NAME}_design.rpt

# Report resources
report_resources > ../reports/${DESIGN_NAME}_resources.rpt

# Report cell usage
report_cell > ../reports/${DESIGN_NAME}_cells.rpt

# ===========================================================================
# Write Output Files
# ===========================================================================

puts "========================================="
puts "Writing output files..."
puts "========================================="

# Create outputs directory
sh mkdir -p ../netlist

# Write gate-level netlist
write -format verilog -hierarchy -output ../netlist/${DESIGN_NAME}_nl.v

# Write SDC constraints for PrimeTime
write_sdc ../netlist/${DESIGN_NAME}.sdc

# Write SDF for timing simulation
write_sdf ../netlist/${DESIGN_NAME}.sdf

# Write DDC (compiled design database)
write -format ddc -hierarchy -output ../netlist/${DESIGN_NAME}.ddc

# ===========================================================================
# Summary
# ===========================================================================

puts "========================================="
puts "Synthesis Complete!"
puts "========================================="
puts "Output files in: ../netlist/"
puts "  - ${DESIGN_NAME}_nl.v (gate-level netlist)"
puts "  - ${DESIGN_NAME}.sdc (timing constraints)"
puts "  - ${DESIGN_NAME}.sdf (timing annotation)"
puts ""
puts "Report files in: ../reports/"
puts "  - ${DESIGN_NAME}_timing.rpt"
puts "  - ${DESIGN_NAME}_area.rpt"
puts "  - ${DESIGN_NAME}_power_est.rpt"
puts "========================================="

# Print QoR summary
report_qor

exit
