# Enable Power Analysis
set_app_var power_enable_analysis true

set script_dir [file dirname [file normalize [info script]]]
set proj_root  [file normalize "$script_dir/.."]
set netlist_dir "$proj_root/netlist"
set sim_dir     "$proj_root/sim"
set reports_dir "$proj_root/reports"

# Set library and search paths
set search_path "$netlist_dir $sim_dir /tools/synopsys/syn/current/libraries/syn"
set target_library [list /tools/synopsys/syn/current/libraries/syn/class.db]
set link_path $target_library

# Read netlist
read_verilog "$netlist_dir/fifo.nl.v"
current_design fifo
link

# Define clocks if ports exist
if {[sizeof_collection [get_ports clk1 -quiet]]} {
    create_clock -name clk1 -period 10 [get_ports clk1]
}
if {[sizeof_collection [get_ports clk2 -quiet]]} {
    create_clock -name clk2 -period 10 [get_ports clk2]
}

# Set time units
set_units -time ns

# Read switching activity from VCD
read_vcd "$sim_dir/fifo.vcd" -strip_path fifo_tb
update_power

# Generate reports
file mkdir $reports_dir
report_power  > "$reports_dir/pt_power.rpt"
report_timing > "$reports_dir/pt_timing.rpt"