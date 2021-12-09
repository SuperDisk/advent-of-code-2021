set infile [open input2]
set crabs [split [gets $infile] ","]
close $infile

set min [tcl::mathfunc::min {*}$crabs]
set max [tcl::mathfunc::max {*}$crabs]

puts "$min, $max"

proc triangle {n} {
    return [expr {($n**2 + $n) / 2}]
}

set best Inf
for {set i $min} {$i <= $max} {incr i} {
    set fuel 0
    foreach crab $crabs {
        incr fuel [triangle [expr {abs($crab - $i)}]]
    }
    if {$fuel < $best} {set best $fuel}
}

puts "best = $best"
