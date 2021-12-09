set infile [open input]
set fish [split [gets $infile] ","]
close $infile

array unset ocean

for {set i 0} {$i <= 8} {incr i} {set ocean($i) 0}
foreach f $fish {incr ocean($f)}

parray ocean

proc dotimes {times code} {
    for {set i 0} {$i < $times} {incr i} {uplevel 1 $code}
}

dotimes 256 {
    foreach {idx val} [array get ocean] {
        if {$idx == 0} {
            incr ocean($idx) -$val
            incr ocean(8) $val
            incr ocean(6) $val
        } else {
            incr ocean($idx) -$val
            incr ocean([expr {$idx - 1}]) $val
        }
    }
}

set total 0
foreach {idx val} [array get ocean] {
    incr total $val
}
puts "total = $total"
