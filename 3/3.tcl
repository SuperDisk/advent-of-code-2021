# part 1

set infile [open input]
set lines [split [read $infile] "\n"]
close $infile

proc mostcommon {num} {
    set count 0
    foreach char [split $num ""] {
        case $char {
            1 {incr count}
            0 {incr count -1}
        }
    }
    if {$count > 0} {return 1}
    if {$count < 0} {return 0}
    return "?"
}

array set columns {}
array unset columns
foreach line $lines {
    for {set i 0} {$i < [string length $line]} {incr i} {
        if {![info exists columns($i)]} {
            set columns($i) ""
        }
        set columns($i) $columns($i)[string index $line $i]
    }
}

set epsilon {}
set gamma {}

foreach column [lsort -integer [array names columns]] {
    if {[mostcommon $columns($column)] == 0} {
        set epsilon ${epsilon}0
        set gamma ${gamma}1
    } else {
        set epsilon ${epsilon}1
        set gamma ${gamma}0
    }
}

puts "epsilon = $epsilon, [expr 0b$epsilon]"
puts "gamma = $gamma, [expr 0b$gamma]"
puts "gamma * epsilon = [expr 0b$gamma * 0b$epsilon]"

# part 2

set infile [open input]
set lines [split [read $infile] "\n"]
close $infile

proc getcolumns {nums} {
    foreach line $nums {
        for {set i 0} {$i < [string length $line]} {incr i} {
            if {![info exists columns($i)]} {
                set columns($i) ""
            }
            set columns($i) $columns($i)[string index $line $i]
        }
    }
    return [array get columns]
}

proc getcommonness {nums} {
    array set columns [getcolumns $nums]

    foreach column [lsort -integer [array names columns]] {
        lappend commonness [mostcommon $columns($column)]
    }

    return $commonness
}

set oxylines $lines
set cidx 0
while {[llength $oxylines] > 1} {
    # puts ""
    # puts "testing bit $cidx"
    set commonness [getcommonness $oxylines]
    # puts $commonness

    set oxylines [lmap line $oxylines {
        set bit [string index $line $cidx]
        set looking_for [lindex $commonness $cidx]
        if {(($looking_for == "?") && ($bit == 1)) ^ ($bit == $looking_for)} {
            # puts "keeping $line"
            list $line
        } else {
            continue
        }
    }]
    incr cidx
}

puts "oxy = $oxylines = [expr 0b$oxylines]"
set oxy $oxylines

# co2

set oxylines $lines
set cidx 0
while {[llength $oxylines] > 1} {
    # puts ""
    # puts "testing bit $cidx"
    set commonness [getcommonness $oxylines]
    # puts $commonness

    set oxylines [lmap line $oxylines {
        set bit [string index $line $cidx]
        set looking_for [lindex $commonness $cidx]
        if {(($looking_for == {?}) && ($bit == 0)) || ($looking_for != {?} && ($bit != $looking_for))} {
            # puts "keeping $line (cidx = $cidx, bit = $bit, looking_for = $looking_for)"
            list $line
        } else {
            continue
        }
    }]
    incr cidx
}

puts "co2 = $oxylines = [expr 0b$oxylines]"
set co2 $oxylines

puts "output = [expr 0b$oxy * 0b$co2]"
