#!/usr/bin/env perl
# =============================================================================
# vcd_fsm_trace.pl - Cycle-by-cycle FSM analysis from a VCD waveform dump
# =============================================================================
# Reads a VCD file (VCS, ModelSim/Questa, Xcelium, Verilator, Icarus), samples
# the chosen signals on every rising clock edge (the value a flop would see,
# i.e. just BEFORE the edge), and reports:
#
#   * state-transition matrix (how often each A -> B transition happened)
#   * dwell time per state: min / avg / max cycles per visit
#   * illegal transitions, checked against an --allow list
#   * X/Z on the state register after reset
#   * latency in cycles between two states (e.g. IDLE -> OUTPUT per sample)
#   * a text "waveform" of any cycle window, for cycle-by-cycle debug
#   * optional per-cycle CSV for plotting or diffing two runs
#
# Usage:
#   vcd_fsm_trace.pl --vcd sim.vcd --clk dut.clk --state dut.state
#        [--names 0=IDLE,1=STORE,2=COMPUTE,3=OUTPUT]
#        [--allow IDLE>STORE,STORE>COMPUTE,...]   [--reset dut.rstn] [--reset-high]
#        [--watch dut.mac_en,dut.tap_counter]      [--latency IDLE:OUTPUT]
#        [--window 100:140] [--csv cycles.csv] [--list]
#
# Signal names can be full hierarchical paths (tb.dut.state) or any unique
# suffix of one (dut.state, or just state if only one signal has that name).
# Bit-blasted buses (one $var per bit, as some simulators dump them) are
# put back together automatically.
#
# Author: Kevin Liu. Uses core Perl only (no CPAN modules).
# =============================================================================
use strict;
use warnings;
use Getopt::Long;

my %o = (window => '', watch => '', names => '', allow => '', latency => '');
GetOptions(\%o, 'vcd=s', 'clk=s', 'state=s', 'names=s', 'allow=s', 'reset=s',
           'reset-high', 'watch=s', 'latency=s', 'window=s', 'csv=s', 'list', 'help')
    or die "Bad options. Try --help\n";
if ($o{help} || !$o{vcd}) {
    print "Usage: $0 --vcd FILE --clk SIG --state SIG [--names 0=IDLE,...] [--allow A>B,...]\n",
          "       [--reset SIG [--reset-high]] [--watch SIG,...] [--latency FROM:TO]\n",
          "       [--window START:END] [--csv FILE] [--list]\n";
    exit($o{help} ? 0 : 1);
}

# -----------------------------------------------------------------------------
# 1. Parse the VCD header: build full hierarchical name -> id code.
# -----------------------------------------------------------------------------
open(my $fh, '<', $o{vcd}) or die "Cannot open $o{vcd}: $!\n";
my (@scope, %name2id, %bus_bits, $timescale);
my $hdr = '';
while (my $l = <$fh>) {
    $hdr .= $l;
    last if $l =~ /\$enddefinitions/;
}
$timescale = $1 if $hdr =~ /\$timescale\s+(\S+(?:\s*[a-z]s)?)\s+\$end/s;
for my $tok ($hdr =~ /(\$(?:scope|upscope|var)\b.*?\$end)/gs) {
    if    ($tok =~ /^\$scope\s+\S+\s+(\S+)/) { push @scope, $1 }
    elsif ($tok =~ /^\$upscope/)            { pop @scope }
    elsif ($tok =~ /^\$var\s+\S+\s+(\d+)\s+(\S+)\s+(\S+)\s*(\[[^\]]*\])?/) {
        my ($width, $id, $ref, $range) = ($1, $2, $3, $4 // '');
        my $full = join('.', @scope, $ref);
        if ($width == 1 && $range =~ /^\[(\d+)\]$/) {     # one bit of a blasted bus
            $bus_bits{$full}{$1} = $id;
        } else {
            $name2id{$full} //= $id;
        }
    }
}
# Rebuild blasted buses as pseudo-signals "bus:<id>,<id>,..." (MSB first).
my %bus_ids;
for my $full (keys %bus_bits) {
    next if exists $name2id{$full};
    my @ids = map { $bus_bits{$full}{$_} } sort { $b <=> $a } keys %{ $bus_bits{$full} };
    $name2id{$full} = "bus:$full";
    $bus_ids{"bus:$full"} = \@ids;
}

if ($o{list}) {
    print "$_\n" for sort keys %name2id;
    exit 0;
}
die "--clk and --state are required (use --list to see signal names)\n"
    unless $o{clk} && $o{state};

sub resolve {
    my ($want) = @_;
    return $want if exists $name2id{$want};
    my @hits = grep { $_ eq $want || /\.\Q$want\E$/ } keys %name2id;
    die "Signal '$want' not found in VCD (try --list)\n" unless @hits;
    die "Signal '$want' is ambiguous: @hits\n" if @hits > 1;
    return $hits[0];
}

my $clk_name   = resolve($o{clk});
my $state_name = resolve($o{state});
my $rst_name   = $o{reset} ? resolve($o{reset}) : undef;
my @watch      = map { resolve($_) } grep { length } split /,/, $o{watch};

my %names;   # numeric state value -> label
for (grep { length } split /,/, $o{names}) {
    my ($v, $n) = split /=/;
    $names{$v} = $n;
}
sub label {
    my ($bits) = @_;
    return $bits if $bits =~ /[xXzZ]/;
    my $v = oct("0b$bits");
    return $names{$v} // $v;
}

# Which id codes we must track (scalar ids, plus every bit of blasted buses).
my %need;
for my $n ($clk_name, $state_name, @watch, grep { defined } $rst_name) {
    my $id = $name2id{$n};
    if ($bus_ids{$id}) { $need{$_} = 1 for @{ $bus_ids{$id} } } else { $need{$id} = 1 }
}

# -----------------------------------------------------------------------------
# 2. Stream value changes; sample on each clk 0->1 using pre-edge values.
# -----------------------------------------------------------------------------
my %val;            # id -> current value string (binary for vectors)
my %pending;        # changes at the current timestamp, applied at the next '#'
my ($now, $clk_id) = (0, $name2id{$clk_name});
my @cycles;         # each: { t => time, state => bits, w => {name => bits}, rst => bit }

sub cur {
    my ($name) = @_;
    my $id = $name2id{$name};
    return join('', map { $val{$_} // 'x' } @{ $bus_ids{$id} }) if $bus_ids{$id};
    return $val{$id} // 'x';
}

sub flush_timestamp {
    my $old_clk = $val{$clk_id} // 'x';
    my $new_clk = exists $pending{$clk_id} ? $pending{$clk_id} : $old_clk;
    if ($old_clk eq '0' && $new_clk eq '1') {        # rising edge: sample BEFORE applying
        push @cycles, {
            t     => $now,
            state => cur($state_name),
            rst   => defined $rst_name ? cur($rst_name) : undef,
            w     => { map { $_ => cur($_) } @watch },
        };
    }
    @val{ keys %pending } = values %pending;
    %pending = ();
}

while (my $l = <$fh>) {
    if ($l =~ /^#(\d+)/) {
        flush_timestamp();
        $now = $1;
    }
    elsif ($l =~ /^([01xXzZ])(\S+)\s*$/) {
        $pending{$2} = lc $1 if $need{$2};
    }
    elsif ($l =~ /^[bB]([01xXzZ]+)\s+(\S+)/) {
        $pending{$2} = lc $1 if $need{$2};
    }
    # real values (r...) and $dumpvars/$end keywords are ignored
}
flush_timestamp();
close $fh;

die "No rising edges of $clk_name found.\n" unless @cycles;

# Pad vectors to the state width so oct() works on short dumps (b10 -> 10).
# Drop cycles where reset is asserted.
my $rst_active = $o{'reset-high'} ? '1' : '0';
my $first_live = 0;
if (defined $rst_name) {
    $first_live++ while $first_live < @cycles && ($cycles[$first_live]{rst} // 'x') ne ($rst_active eq '0' ? '1' : '0');
}
my @live = @cycles[$first_live .. $#cycles];
die "Reset never deasserts in the dump.\n" unless @live;

# -----------------------------------------------------------------------------
# 3. Analysis
# -----------------------------------------------------------------------------
my (%trans, %visits, @xz, @illegal, @lat);
my %allowed = map { $_ => 1 } grep { length } split /,/, $o{allow};
my ($lat_from, $lat_to) = split /:/, $o{latency} // '';
my ($cur_state, $run_len, $lat_start) = (undef, 0, undef);

for my $i (0 .. $#live) {
    my $s = label($live[$i]{state});
    my $cyc = $first_live + $i;
    push @xz, $cyc if $s =~ /[xz]/i;
    if (!defined $cur_state) {
        ($cur_state, $run_len) = ($s, 1);
        $lat_start = $cyc if $lat_from && $s eq $lat_from;
        next;
    }
    if ($s eq $cur_state) { $run_len++; next }

    # state changed: close the visit of the old state
    push @{ $visits{$cur_state} }, $run_len;
    $trans{$cur_state}{$s}++;
    push @illegal, [$cyc, $cur_state, $s] if %allowed && !$allowed{"$cur_state>$s"};

    if ($lat_from) {
        $lat_start = $cyc if $s eq $lat_from;
        if ($s eq $lat_to && defined $lat_start) { push @lat, $cyc - $lat_start; undef $lat_start }
    }
    ($cur_state, $run_len) = ($s, 1);
}
push @{ $visits{$cur_state} }, $run_len if defined $cur_state;   # last (possibly open) visit

# -----------------------------------------------------------------------------
# 4. Report
# -----------------------------------------------------------------------------
my @order = (map { $names{$_} } sort { $a <=> $b } keys %names);
my %seen = map { $_ => 1 } @order;
push @order, grep { !$seen{$_}++ } sort(keys %visits, map { keys %$_ } values %trans);

printf "VCD          : %s  (timescale %s)\n", $o{vcd}, $timescale // '?';
printf "Clock / state: %s / %s\n", $clk_name, $state_name;
printf "Cycles       : %d total, %d after reset (first live cycle %d at t=%s)\n",
       scalar @cycles, scalar @live, $first_live, $live[0]{t};

print "\nSTATE TRANSITIONS (row = from, col = to)\n";
my $cw = 8;
$cw = length($_) + 1 > $cw ? length($_) + 1 : $cw for @order;
printf "%-*s", $cw, 'from\\to';
printf "%*s", $cw, $_ for @order;
print "\n";
for my $f (@order) {
    printf "%-*s", $cw, $f;
    printf "%*s", $cw, ($trans{$f}{$_} // '.') for @order;
    print "\n";
}

print "\nDWELL TIME PER VISIT (cycles)\n";
printf "  %-*s %7s %7s %7s %7s %9s\n", $cw, 'state', 'visits', 'min', 'avg', 'max', 'total';
for my $s (@order) {
    my $v = $visits{$s} or next;
    my ($mn, $mx, $sum) = ($v->[0], $v->[0], 0);
    for (@$v) { $mn = $_ if $_ < $mn; $mx = $_ if $_ > $mx; $sum += $_ }
    printf "  %-*s %7d %7d %7.1f %7d %8.1f%%\n", $cw, $s, scalar @$v, $mn, $sum / @$v, $mx, 100 * $sum / @live;
}

if ($lat_from) {
    print "\nLATENCY $lat_from -> $lat_to (cycles from entering $lat_from to entering $lat_to)\n";
    if (@lat) {
        my %h; $h{$_}++ for @lat;
        my ($mn, $mx) = (sort { $a <=> $b } @lat)[0, -1];
        my $sum = 0; $sum += $_ for @lat;
        printf "  %d transactions: min %d, avg %.2f, max %d\n", scalar @lat, $mn, $sum / @lat, $mx;
        print "  histogram: ", join(', ', map { "$_ cyc x$h{$_}" } sort { $a <=> $b } keys %h), "\n";
    } else {
        print "  none found\n";
    }
}

print "\nCHECKS\n";
printf "  X/Z on state after reset : %s\n", @xz ? scalar(@xz) . " cycle(s), first at cycle $xz[0]" : 'none';
if (%allowed) {
    printf "  illegal transitions      : %s\n", @illegal ? scalar @illegal : 'none';
    printf "    cycle %d: %s -> %s\n", @$_ for @illegal[0 .. ($#illegal < 9 ? $#illegal : 9)];
    my @never = grep { my ($a, $b) = split />/; !$trans{$a}{$b} } sort keys %allowed;
    printf "  allowed but never taken  : %s\n", @never ? join(', ', @never) : 'none (all arcs covered)';
}
my @unvisited = grep { !$visits{$_} } map { $names{$_} } sort keys %names;
printf "  states never visited     : %s\n", @unvisited ? join(', ', @unvisited) : 'none';

# Text waveform for a window of cycles
if ($o{window} =~ /^(\d+):(\d+)$/) {
    my ($a, $b) = ($1, $2 > $#cycles ? $#cycles : $2);
    print "\nCYCLE TRACE $a..$b (values sampled just before each rising edge)\n";
    my @cols = ('cycle', 'time', 'state', map { (split /\./)[-1] } @watch);
    my @rows;
    for my $c ($a .. $b) {
        my $r = $cycles[$c];
        push @rows, [ $c, $r->{t}, label($r->{state}),
                      map { my $v = $r->{w}{$_}; length($v) > 1 && $v !~ /[xz]/ ? oct("0b$v") : $v } @watch ];
    }
    my @w = map { length } @cols;
    for my $r (@rows) { for (0 .. $#$r) { $w[$_] = length $r->[$_] if length $r->[$_] > $w[$_] } }
    print '  ', join('  ', map { sprintf "%-*s", $w[$_], $cols[$_] } 0 .. $#cols), "\n";
    my $prev;
    for my $r (@rows) {
        my $mark = defined $prev && $prev ne $r->[2] ? '>' : ' ';
        print "$mark ", join('  ', map { sprintf "%-*s", $w[$_], $r->[$_] } 0 .. $#$r), "\n";
        $prev = $r->[2];
    }
}

if ($o{csv}) {
    open(my $out, '>', $o{csv}) or die "Cannot write $o{csv}: $!\n";
    print $out join(',', 'cycle', 'time', 'state', @watch), "\n";
    for my $c (0 .. $#cycles) {
        my $r = $cycles[$c];
        print $out join(',', $c, $r->{t}, label($r->{state}), map { $r->{w}{$_} } @watch), "\n";
    }
    close $out;
    print "\nWrote $o{csv} (", scalar @cycles, " cycles)\n";
}
