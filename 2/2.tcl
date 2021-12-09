# part 1

set infile [open input1]
set lines [split [read $infile] "\n"]
close $infile

set horz 0
set vert 0
foreach {direction amount} [join $lines] {
    switch $direction {
        forward {
            incr horz $amount
        }
        down {
            incr vert $amount
        }
        up {
            incr vert -$amount
        }
    }
}

puts "$horz * $vert = [expr $horz * $vert]"

# part 2

set infile [open input1]
set lines [split [read $infile] "\n"]
close $infile

set pos 0
set depth 0
set aim 0
foreach {direction amount} [join $lines] {
    switch $direction {
        forward {
            incr pos $amount
            incr depth [expr $aim * $amount]
        }
        down {
            incr aim $amount
        }
        up {
            incr aim -$amount
        }
    }
}

puts "$pos * $depth = [expr $pos * $depth]"
