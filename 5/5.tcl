# part 1

set infile [open input]
set lines [split [read $infile] "\n"]
close $infile

set coords {}

foreach line $lines {
    set x [split $line "->"]
    lappend coords [list \
                        [split [string trim [lindex $x 0]] ","] \
                        [split [string trim [lindex $x 2]] ","]]
}

array unset bitmap

proc movetoward {num target} {
    upvar $num x
    if {$x < $target} {incr x} else {incr x -1}
}

# Okay, not strictly necessary, but fun to mess around with Tcl's weird uplevel stuff

proc for2 {init cond update code} {
    uplevel 1 $init
    set testcmd [list expr $cond]
    while {[uplevel 1 $testcmd]} {
        uplevel 1 $code
        uplevel 1 $update
    }
    uplevel 1 $code
}

foreach line $coords {
    set x1 [lindex $line 0 0]
    set x2 [lindex $line 1 0]
    set y1 [lindex $line 0 1]
    set y2 [lindex $line 1 1]

    if {$x1 == $x2} {
        for2 {set i $y1} {$i != $y2} {movetoward i $y2} {
            if {![info exists bitmap($x1,$i)]} {set bitmap($x1,$i) 0}
            incr bitmap($x1,$i)
        }
    } elseif {$y1 == $y2} {
        for2 {set i $x1} {$i != $x2} {movetoward i $x2} {
            if {![info exists bitmap($i,$y1)]} {set bitmap($i,$y1) 0}
            incr bitmap($i,$y1)
        }
    } else {
        for2 {
            set x $x1
            set y $y1
        } {$x != $x2} {
            movetoward x $x2
            movetoward y $y2
        } {
            if {![info exists bitmap($x,$y)]} {set bitmap($x,$y) 0}
            incr bitmap($x,$y)
        }
    }
}

set total 0
foreach {pos num} [array get bitmap] {
    if {$num >= 2} {
        incr total
    }
}

puts "total: $total"
