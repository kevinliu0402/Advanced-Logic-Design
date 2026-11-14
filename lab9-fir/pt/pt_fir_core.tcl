# ===========================================================================
# PrimeTime Analysis Script for FIR Filter Core
# ===========================================================================
# Author: Kevin Liu
# UNI: kl3755
# Course: CSEE W4823 Advanced Logic Design - Lab 9
# ===========================================================================

set DESIGN_NAME "fir_core"

puts "========================================="
puts "PrimeTime Analysis for $DESIGN_NAME"
puts "========================================="

# ===========================================================================
# Library Setup
# ===========================================================================

# Note: Update these paths to match your environment
set target_library "/tools/synopsys/syn/current/libraries/syn/class.db"
set link_library "* $target_library"
set search_path ". ../netlist /tools/synopsys/syn/current/libraries/syn"

# ===========================================================================
# Read Design and Constraints
# ===========================================================================

puts "\nReading gate-level netlist..."

# Read the synthesized netlist
read_verilog ../netlist/${DESIGN_NAME}_nl.v

# Set current design
current_design $DESIGN_NAME

# Link the design
link_design

# Read timing constraints from synthesis
if {[file exists ../netlist/${DESIGN_NAME}.sdc]} {
    puts "Reading SDC constraints..."
    read_sdc ../netlist/${DESIGN_NAME}.sdc
} else {
    puts "Warning: SDC file not found, creating constraints..."
    # Create clock constraint
    set CLK_PERIOD 30
    create_clock -name clk -period $CLK_PERIOD [get_ports clk]
    set_clock_uncertainty 0.2 [get_clocks clk]
    
    # Input/output delays
    set INPUT_DELAY [expr $CLK_PERIOD * 0.7]
    set OUTPUT_DELAY [expr $CLK_PERIOD * 0.3]
    set_input_delay $INPUT_DELAY -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
    set_output_delay $OUTPUT_DELAY -clock clk [all_outputs]
}

# ===========================================================================
# Read Switching Activity from VCD
# ===========================================================================

puts "\n========================================="
puts "Reading switching activity from VCD..."
puts "========================================="

# Read VCD file for accurate power analysis
# Strip the testbench hierarchy to map to DUT signals
if {[file exists ../sim/fir_core.vcd]} {
    read_vcd ../sim/fir_core.vcd -strip_path tb_fir_core/dut
    puts "VCD file loaded successfully"
} else {
    puts "Warning: VCD file not found at ../sim/fir_core.vcd"
    puts "Using default switching activity (0.1)"
    set_switching_activity -static_probability 0.5 -toggle_rate 0.1 [all_inputs]
    set_switching_activity -static_probability 0.5 -toggle_rate 0.1 [all_outputs]
}

# ===========================================================================
# Timing Analysis
# ===========================================================================

puts "\n========================================="
puts "Performing Timing Analysis..."
puts "========================================="

# Create reports directory
sh mkdir -p ../reports_pt

# Update timing
update_timing -full

# Check timing setup
check_timing

# Report timing summary (setup - worst path)
puts "\nGenerating timing reports..."
report_timing -delay max -max_paths 1 > ../reports_pt/${DESIGN_NAME}_timing_summary.rpt

# Report detailed timing paths
report_timing -delay max -max_paths 20 -nworst 1 \
    -transition_time -capacitance -nets > ../reports_pt/${DESIGN_NAME}_timing_detailed.rpt

# Report setup timing with full clock path
report_timing -delay max -path_type full_clock -max_paths 10 > ../reports_pt/${DESIGN_NAME}_setup_timing.rpt

# Report hold timing
report_timing -delay min -path_type full_clock -max_paths 10 > ../reports_pt/${DESIGN_NAME}_hold_timing.rpt

# Report clock timing
report_clock_timing -type summary > ../reports_pt/${DESIGN_NAME}_clock_timing.rpt
report_clock_timing -type skew > ../reports_pt/${DESIGN_NAME}_clock_skew.rpt

# Report constraint violations
report_constraint -all_violators > ../reports_pt/${DESIGN_NAME}_violations.rpt

# Report design statistics
report_design > ../reports_pt/${DESIGN_NAME}_design_stats.rpt

# ===========================================================================
# Power Analysis
# ===========================================================================

puts "\n========================================="
puts "Performing Power Analysis..."
puts "========================================="

# Enable power analysis
set power_enable_analysis true

# Set operating conditions if needed
# set_operating_conditions nom_pvt

# Update power calculation
update_power

# Report total power
puts "\nGenerating power reports..."
report_power > ../reports_pt/${DESIGN_NAME}_power_total.rpt

# Report power by hierarchy
report_power -hierarchy > ../reports_pt/${DESIGN_NAME}_power_hierarchy.rpt

# Report verbose power breakdown
report_power -verbose > ../reports_pt/${DESIGN_NAME}_power_verbose.rpt

# Report switching activity
report_switching_activity > ../reports_pt/${DESIGN_NAME}_switching_activity.rpt

# Report power by cell type
report_power -cell > ../reports_pt/${DESIGN_NAME}_power_by_cell.rpt

# Report power by net
report_power -net > ../reports_pt/${DESIGN_NAME}_power_by_net.rpt

# ===========================================================================
# Generate Executive Summary Report
# ===========================================================================

puts "\n========================================="
puts "Generating Executive Summary..."
puts "========================================="

set summary_file "../reports_pt/${DESIGN_NAME}_executive_summary.rpt"
set fp [open $summary_file w]

puts $fp "=============================================================="
puts $fp "  FIR Filter Core - Timing & Power Executive Summary"
puts $fp "=============================================================="
puts $fp "  Design: $DESIGN_NAME"
puts $fp "  Date: [clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}]"
puts $fp "=============================================================="
puts $fp ""

# Timing Summary
puts $fp "TIMING ANALYSIS:"
puts $fp "----------------"

# Get timing information
set timing_path [get_timing_paths -delay max]
set slack [get_attribute $timing_path slack]
set clk_obj [get_clocks clk]
set period [get_attribute $clk_obj period]

if {$slack >= 0} {
    puts $fp "  Setup Time: MET"
    puts $fp "  Slack: [format %.3f $slack] ns"
    set max_freq [expr 1000.0 / ($period - $slack)]
    puts $fp "  Target Frequency: [format %.2f [expr 1000.0 / $period]] MHz"
    puts $fp "  Max Achievable Frequency: [format %.2f $max_freq] MHz"
} else {
    puts $fp "  Setup Time: VIOLATED"
    puts $fp "  Slack: [format %.3f $slack] ns"
    puts $fp "  Target Frequency: [format %.2f [expr 1000.0 / $period]] MHz"
    puts $fp "  ACTION REQUIRED: Reduce clock frequency or optimize design"
}
puts $fp ""

# Power Summary
puts $fp "POWER ANALYSIS:"
puts $fp "---------------"

set total_power [get_attribute [current_design] total_power]
set dynamic_power [get_attribute [current_design] dynamic_power]
set leakage_power [get_attribute [current_design] leakage_power]

puts $fp "  Total Power:   [format %.6f $total_power] W ([format %.3f [expr $total_power * 1000]] mW)"
puts $fp "  Dynamic Power: [format %.6f $dynamic_power] W ([format %.3f [expr $dynamic_power * 1000]] mW)"
puts $fp "  Leakage Power: [format %.6f $leakage_power] W ([format %.3f [expr $leakage_power * 1000]] mW)"
puts $fp ""

# Area Summary
puts $fp "AREA:"
puts $fp "-----"
set cell_area [get_attribute [current_design] area]
puts $fp "  Total Cell Area: [format %.2f $cell_area] um^2"
puts $fp ""

# Performance Metrics
puts $fp "PERFORMANCE METRICS:"
puts $fp "--------------------"

# Energy per sample (64-tap FIR with the pipelined MAC: 69 cycles per sample)
set cycles_per_sample 69
set energy_per_sample [expr $total_power * $period * $cycles_per_sample * 1e-9]
puts $fp "  Cycles per Sample: $cycles_per_sample"
puts $fp "  Energy per Sample: [format %.3e $energy_per_sample] J ([format %.2f [expr $energy_per_sample * 1e12]] pJ)"

# Throughput
set throughput [expr 1.0 / ($period * $cycles_per_sample * 1e-9)]
puts $fp "  Max Throughput: [format %.2f [expr $throughput / 1e6]] MSamples/sec"

# Power efficiency
set power_efficiency [expr $throughput / ($total_power * 1e6)]
puts $fp "  Power Efficiency: [format %.2f $power_efficiency] MSamples/sec/mW"
puts $fp ""

puts $fp "=============================================================="
puts $fp "                    End of Summary Report"
puts $fp "=============================================================="

close $fp

# Display summary to console
puts "\n"
set fp_read [open $summary_file r]
puts [read $fp_read]
close $fp_read

# ===========================================================================
# Completion Message
# ===========================================================================

puts "\n========================================="
puts "PrimeTime Analysis Complete!"
puts "========================================="
puts "Reports generated in: ../reports_pt/"
puts ""
puts "Key Reports:"
puts "  - ${DESIGN_NAME}_timing_summary.rpt      (Critical path timing)"
puts "  - ${DESIGN_NAME}_power_total.rpt         (Power breakdown)"
puts "  - ${DESIGN_NAME}_power_hierarchy.rpt     (Power by module)"
puts "  - ${DESIGN_NAME}_executive_summary.rpt   (Executive summary)"
puts "========================================="

exit
