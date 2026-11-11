#!/usr/bin/env perl
# =============================================================================
# ppa_report.pl - Summarize Synopsys Design Compiler / PrimeTime reports
# =============================================================================
# Scans one or more report directories, works out what each *.rpt file is from
# its "Report :" header (not from its file name), and pulls out the PPA numbers:
#
#   area    : total cell area, comb/seq split, cell counts, top hierarchy blocks
#   timing  : clock period, worst setup slack, # violating paths, critical
#             path start/end points, worst hold slack, Fmax
#   power   : total dynamic power (DC and PT, normalized to uW), top blocks
#
# It then prints one comparison table, flags problems (setup/hold violations,
# unconstrained paths, missing reports), and can write CSV and Markdown.
#
# Usage:
#   ppa_report.pl [--csv out.csv] [--md out.md] [--top N] DIR[=LABEL] ...
#
# Example:
#   ppa_report.pl "lab9/reports=fir_dc" "lab9/reports_pt=fir_pt" \
#                 "kl3755_lab8/reports=async_fifo" --csv ppa.csv --md ppa.md
#
# Author: Kevin Liu. Uses core Perl only (no CPAN modules).
# =============================================================================
use strict;
use warnings;
use Getopt::Long;
use File::Basename qw(basename);

my ($csv_out, $md_out, $top_n, $help) = (undef, undef, 3, 0);
GetOptions(
    'csv=s' => \$csv_out,
    'md=s'  => \$md_out,
    'top=i' => \$top_n,
    'help'  => \$help,
) or die "Bad options. Try --help\n";
if ($help || !@ARGV) {
    print <<"USAGE";
Usage: $0 [--csv FILE] [--md FILE] [--top N] DIR[=LABEL] ...
  DIR    directory holding Design Compiler / PrimeTime *.rpt files
  LABEL  optional name for that run in the table (default: DIR)
USAGE
    exit($help ? 0 : 1);
}

# -----------------------------------------------------------------------------
# Unit helpers
# -----------------------------------------------------------------------------
my %SI = (f => 1e-15, p => 1e-12, n => 1e-9, u => 1e-6, m => 1e-3, '' => 1);

# "100nW" -> 1e-7 (watts per reported unit)
sub power_unit_to_watts {
    my ($u) = @_;
    return undef unless defined $u && $u =~ /^\s*([\d.eE+-]*)\s*([fpnum]?)W/;
    my $mult = length $1 ? $1 : 1;
    return $mult * $SI{$2};
}

sub fmt {
    my ($v, $p) = @_;
    return '-' unless defined $v;
    return sprintf("%.${p}f", $v);
}

# -----------------------------------------------------------------------------
# Report parsers. Each takes the full text and returns a hashref of metrics.
# -----------------------------------------------------------------------------
sub parse_area {
    my ($t) = @_;
    my %m;
    $m{area_total} = $1 if $t =~ /Total cell area:\s+([\d.]+)/;
    $m{area_comb}  = $1 if $t =~ /Combinational area:\s+([\d.]+)/;
    $m{area_seq}   = $1 if $t =~ /Noncombinational area:\s+([\d.]+)/;
    $m{area_bufinv}= $1 if $t =~ m{Buf/Inv area:\s+([\d.]+)};
    $m{cells}      = $1 if $t =~ /Number of cells:\s+(\d+)/;
    $m{seq_cells}  = $1 if $t =~ /Number of sequential cells:\s+(\d+)/;

    # Hierarchical area table: "u_coeff_mem   13526.0000   40.0  ..."
    # Only keep first-level instances (no '/') so blocks are not double counted.
    if ($t =~ /Hierarchical area distribution(.*?)\nTotal/s) {
        my @blocks;
        for my $line (split /\n/, $1) {
            next unless $line =~ /^(\S+)\s+([\d.]+)\s+([\d.]+)\s+[\d.]+\s+[\d.]+\s+[\d.]+\s+(\S+)/;
            my ($inst, $abs, $pct, $mod) = ($1, $2, $3, $4);
            next if $inst =~ m{/} || $pct >= 100;
            push @blocks, { name => $inst, value => $abs, pct => $pct };
        }
        $m{area_blocks} = [ sort { $b->{value} <=> $a->{value} } @blocks ];
    }
    return \%m;
}

sub parse_timing {
    my ($t) = @_;
    my %m;
    my $is_min = ($t =~ /-delay(?:_type)?\s+min/) ? 1 : 0;
    $m{kind} = $is_min ? 'hold' : 'setup';

    if ($t =~ /No paths with slack less than/) {
        $m{no_violations} = 1;
        return \%m;
    }

    # Split into individual paths on "Startpoint:".
    my @paths = split /(?=^\s*Startpoint:)/m, $t;
    shift @paths unless $paths[0] =~ /Startpoint:/;
    my ($worst, $nviol, $nunc) = (undef, 0, 0);
    for my $p (@paths) {
        if ($p =~ /\(Path is unconstrained\)/) { $nunc++; next; }
        next unless $p =~ /slack \((MET|VIOLATED)[^)]*\)\s+(-?[\d.]+)/;
        my $slack = $2;
        $nviol++ if $1 eq 'VIOLATED';
        if (!defined $worst || $slack < $worst->{slack}) {
            my ($sp) = $p =~ /Startpoint:\s+(\S+)/;
            my ($ep) = $p =~ /Endpoint:\s+(\S+)/;
            my ($arr) = $p =~ /data arrival time\s+(-?[\d.]+)/;
            # Period = time of the capturing clock edge (2nd "clock X (rise edge)").
            my @edges = $p =~ /clock \S+ \((?:rise|fall) edge\)\s+[\d.]+\s+([\d.]+)/g;
            $worst = { slack => $slack, start => $sp, end => $ep,
                       arrival => $arr, period => $edges[1] };
        }
    }
    $m{paths}         = scalar @paths;
    $m{violating}     = $nviol;
    $m{unconstrained} = $nunc;
    $m{worst}         = $worst;
    return \%m;
}

sub parse_power {
    my ($t, $kind) = @_;
    my %m;
    my $unit_w = power_unit_to_watts(($t =~ /Dynamic Power Units\s*=\s*(\S+)/)[0]);

    if ($kind eq 'pt') {
        # PrimeTime "Averaged Power": values are in watts.
        $m{power_uw} = $1 * 1e6 if $t =~ /^Total Power\s+=\s+([\d.eE+-]+)/m;
        $m{leak_uw}  = $1 * 1e6 if $t =~ /Cell Leakage Power\s+=\s+([\d.eE+-]+)/;
    }
    elsif ($t =~ /Total Dynamic Power\s+=\s+([\d.eE+-]+)\s*([fpnum]?)W/) {
        # DC flat report: value carries its own unit.
        $m{power_uw} = $1 * $SI{$2} * 1e6;
    }

    # DC hierarchical table: "  u_fir_alu (fir_alu)  203.644 0.000 0.000 203.644 29.5"
    if ($t =~ /^-+\n\s*Switch\s+Int.*?\nHierarchy.*?\n-+\n(.*?)(?:\n1\s*$|\z)/ms) {
        my @blocks;
        for my $line (split /\n/, $1) {
            next unless $line =~ /^(\s*)(\S+)(?:\s+\(\S+\))?\s+[\d.]+\s+[\d.]+\s+\S+\s+([\d.]+)\s+([\d.]+)/;
            my ($indent, $name, $tot, $pct) = (length $1, $2, $3, $4);
            if ($indent == 0) {            # top level row
                $m{power_uw} //= $tot * $unit_w * 1e6 if defined $unit_w;
                next;
            }
            next if $indent > 2;           # only first-level children
            push @blocks, { name => $name, value => $tot, pct => $pct };
        }
        $m{power_blocks} = [ sort { $b->{value} <=> $a->{value} } @blocks ];
    }
    return \%m;
}

# -----------------------------------------------------------------------------
# Scan directories
# -----------------------------------------------------------------------------
my @runs;
for my $arg (@ARGV) {
    my ($dir, $label) = split /=/, $arg, 2;
    $label //= $dir;
    unless (-d $dir) { warn "WARNING: '$dir' is not a directory, skipped\n"; next; }

    my %run = (label => $label, dir => $dir, files => [], flags => []);
    opendir(my $dh, $dir) or die "Cannot open $dir: $!\n";
    my @rpts = sort grep { /\.rpt$/ && -f "$dir/$_" } readdir $dh;
    closedir $dh;

    for my $f (@rpts) {
        open(my $fh, '<', "$dir/$f") or do { warn "Cannot read $dir/$f: $!\n"; next };
        local $/;
        my $t = <$fh>;
        close $fh;
        next unless $t =~ /^Report\s*:\s*(.+?)\s*$/m;
        my $type = lc $1;
        $run{design}  //= ($t =~ /^Design\s*:\s*(\S+)/m)[0];
        $run{version} //= ($t =~ /^Version\s*:\s*(\S+)/m)[0];

        if ($type eq 'area') {
            %run = (%run, %{ parse_area($t) });
            push @{ $run{files} }, "$f(area)";
        }
        elsif ($type eq 'timing') {
            my $tm = parse_timing($t);
            if ($tm->{kind} eq 'hold') {
                if ($tm->{no_violations}) { $run{hold_slack} //= 'MET' }
                elsif ($tm->{worst} && (!defined $run{hold_num} || $tm->{worst}{slack} < $run{hold_num})) {
                    $run{hold_num} = $tm->{worst}{slack};
                    $run{hold_slack} = $tm->{worst}{slack};
                }
            }
            else {
                my $w = $tm->{worst};
                if ($w && (!defined $run{setup_slack} || $w->{slack} < $run{setup_slack})) {
                    $run{setup_slack} = $w->{slack};
                    $run{period}      = $w->{period};
                    $run{crit_start}  = $w->{start};
                    $run{crit_end}    = $w->{end};
                }
                $run{violating} = $tm->{violating}
                    if !defined $run{violating} || ($tm->{violating} // 0) > $run{violating};
                $run{unconstrained} += $tm->{unconstrained} // 0;
            }
            push @{ $run{files} }, "$f($tm->{kind})";
        }
        elsif ($type eq 'power' || $type eq 'averaged power') {
            my $kind = $type eq 'averaged power' ? 'pt' : 'dc';
            my $pm = parse_power($t, $kind);
            if (defined $pm->{power_uw} && !defined $run{power_uw}) {
                $run{power_uw}  = $pm->{power_uw};
                $run{power_src} = uc $kind;
            }
            $run{power_blocks} //= $pm->{power_blocks} if $pm->{power_blocks} && @{ $pm->{power_blocks} };
            push @{ $run{files} }, "$f(power-$kind)";
        }
    }

    # Derived metrics
    if (defined $run{period} && defined $run{setup_slack}) {
        my $min_period = $run{period} - $run{setup_slack};
        $run{fmax_mhz} = 1000 / $min_period if $min_period > 0;   # ns -> MHz
        $run{target_mhz} = 1000 / $run{period} if $run{period} > 0;
    }

    # Flags
    push @{ $run{flags} }, sprintf("SETUP VIOLATED: worst slack %.2f ns on %s -> %s (%d path(s) reported failing)",
        $run{setup_slack}, $run{crit_start}, $run{crit_end}, $run{violating} // 0)
        if defined $run{setup_slack} && $run{setup_slack} < 0;
    push @{ $run{flags} }, "HOLD VIOLATED: worst slack $run{hold_slack} ns"
        if defined $run{hold_num} && $run{hold_num} < 0;
    push @{ $run{flags} }, "$run{unconstrained} reported path(s) are UNCONSTRAINED (missing clock or I/O delay constraints?)"
        if $run{unconstrained};
    push @{ $run{flags} }, "no area report found"   unless defined $run{area_total};
    push @{ $run{flags} }, "no timing report found" unless grep { /\((setup|hold)\)/ } @{ $run{files} };
    push @{ $run{flags} }, "no power report found"  unless defined $run{power_uw};

    push @runs, \%run;
}
die "No report directories could be read.\n" unless @runs;

# -----------------------------------------------------------------------------
# Output
# -----------------------------------------------------------------------------
my @cols = (
    [ 'Run',            sub { $_[0]{label} } ],
    [ 'Design',         sub { $_[0]{design} // '-' } ],
    [ 'Area',           sub { fmt($_[0]{area_total}, 0) } ],
    [ 'Seq%',           sub { defined $_[0]{area_total} && defined $_[0]{area_seq} && $_[0]{area_total} > 0
                                ? fmt(100 * $_[0]{area_seq} / $_[0]{area_total}, 1) : '-' } ],
    [ 'Cells',          sub { $_[0]{cells} // '-' } ],
    [ 'Period(ns)',     sub { fmt($_[0]{period}, 2) } ],
    [ 'Setup WNS(ns)',  sub { fmt($_[0]{setup_slack}, 2) } ],
    [ 'Hold',           sub { $_[0]{hold_slack} // '-' } ],
    [ 'Fmax(MHz)',      sub { fmt($_[0]{fmax_mhz}, 1) } ],
    [ 'Power(uW)',      sub { defined $_[0]{power_uw} ? fmt($_[0]{power_uw}, 2) . " ($_[0]{power_src})" : '-' } ],
);

my @rows = map { my $r = $_; [ map { $_->[1]->($r) } @cols ] } @runs;
my @hdr  = map { $_->[0] } @cols;
my @w    = map { length } @hdr;
for my $row (@rows) { $w[$_] = length($row->[$_]) > $w[$_] ? length($row->[$_]) : $w[$_] for 0 .. $#$row }

my $line = join('-+-', map { '-' x $_ } @w);
print "\nPPA SUMMARY\n", join(' | ', map { sprintf "%-*s", $w[$_], $hdr[$_] } 0 .. $#hdr), "\n$line\n";
for my $row (@rows) {
    print join(' | ', map { sprintf "%-*s", $w[$_], $row->[$_] } 0 .. $#$row), "\n";
}

print "\nDETAILS\n";
for my $r (@runs) {
    print "\n[$r->{label}]  dir=$r->{dir}  tool=", ($r->{version} // '?'), "\n";
    print "  reports parsed: ", join(', ', @{ $r->{files} }), "\n";
    if (defined $r->{crit_start}) {
        print "  critical path : $r->{crit_start} -> $r->{crit_end}\n";
    }
    for my $kind (qw(area power)) {
        my $b = $r->{"${kind}_blocks"} or next;
        next unless @$b;
        my $n = $top_n < @$b ? $top_n : scalar @$b;
        printf "  %-14s: %s\n", "top $kind", join(', ', map { "$_->{name} $_->{pct}%" } @$b[0 .. $n - 1]);
    }
    print "  ** $_\n" for @{ $r->{flags} };
    print "  OK: no flags\n" unless @{ $r->{flags} };
}
print "\n";

if ($csv_out) {
    open(my $fh, '>', $csv_out) or die "Cannot write $csv_out: $!\n";
    my @k = qw(label design dir area_total area_comb area_seq cells seq_cells period
               setup_slack violating hold_slack fmax_mhz power_uw power_src crit_start crit_end);
    print $fh join(',', @k, 'flags'), "\n";
    for my $r (@runs) {
        my @v = map { my $x = $r->{$_} // ''; $x =~ /[,"]/ ? do { $x =~ s/"/""/g; qq("$x") } : $x } @k;
        (my $fl = join('; ', @{ $r->{flags} })) =~ s/"/""/g;
        print $fh join(',', @v, qq("$fl")), "\n";
    }
    close $fh;
    print "Wrote $csv_out\n";
}

if ($md_out) {
    open(my $fh, '>', $md_out) or die "Cannot write $md_out: $!\n";
    print $fh "# PPA summary\n\n| ", join(' | ', @hdr), " |\n|", join('|', map { '---' } @hdr), "|\n";
    print $fh "| ", join(' | ', @$_), " |\n" for @rows;
    print $fh "\n## Flags\n\n";
    for my $r (@runs) {
        print $fh "- **$r->{label}**: ", (@{ $r->{flags} } ? join('; ', @{ $r->{flags} }) : 'none'), "\n";
    }
    close $fh;
    print "Wrote $md_out\n";
}
