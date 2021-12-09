# Part 1

set infile [open input]
set moves [split [gets $infile] ","]
gets $infile

set curboard {}
set boards {}
while {[gets $infile line] >= 0} {
    if {$line == ""} {
        lappend boards $curboard
        set curboard {}
    } else {
        set row [string trim [regsub -all { +} $line { }]]
        lappend curboard [lmap el $row {list $el 0}]
    }
}
lappend boards $curboard
set curboard {}

# puts $moves
# puts $boards

close $infile

proc winner {board} {
    for {set v 0} {$v < [llength $board]} {incr v} {
        set good 1
        for {set i 0} {$i < [llength [lindex $board 0]]} {incr i} {
            if {!([lindex $board $v $i 1])} {set good 0}
        }
        if {$good} {return 1}
    }

    for {set h 0} {$h < [llength [lindex $board 0]]} {incr h} {
        set good 1
        for {set i 0} {$i < [llength [lindex $board]]} {incr i} {
            if {!([lindex $board $i $h 1])} {set good 0}
        }
        if {$good} {return 1}
    }

    return 0
}

proc mark {board num} {
    set row 0
    foreach rowstr $board {
        if {[set col [lsearch -index {0} $rowstr $num]] > -1} {
            lset board $row $col 1 1
        }
        incr row
    }
    return $board
}

proc bingo {} {
    global moves
    global boards

    array set winners {}
    array unset winners

    foreach move $moves {
        if {$move == 10} {
            puts [lindex $boards 2]
        }
        for {set i 0} {$i < [llength $boards]} {incr i} {
            set board [mark [lindex $boards $i] $move]
            lset boards $i $board
            if {[winner $board]} {
                if {[info exists winners($i)]} {continue}
                set winners($i) 1

                puts "we got a winner baby $i"
                puts "number just called = $move"
                set unmarked 0
                foreach {num marked} [join [join $board]] {
                    if {! $marked} {incr unmarked $num}
                }
                puts "sum of unmarked = $unmarked"
                puts "final result = [expr $unmarked * $move]"
            }
        }
    }
}

bingo
