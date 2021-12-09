############## part 1

set infile [open input]
set lines [split [read $infile] "\n"]
close $infile

set previous 0
set increased 0
foreach val $lines {
    if {$val > $previous} {
        incr increased
    }
    set previous $val
}
incr increased -1

puts "$current $increased"

############## part 2

set infile [open part2_input]
set lines [split [read $infile] "\n"]
close $infile

set readings ""
for {set i 0} {$i < [llength $lines] - 2} {incr i} {
    lappend readings [tcl::mathop::+ {*}[lrange $lines $i [expr $i+2]]]
}
puts $readings

set previous 0
set increased 0
foreach val $readings {
    if {$val > $previous} {
        incr increased
    }
    set previous $val
}
incr increased -1

puts "$previous $increased"
