set infile [open input]
set lines [split [read $infile] "\n"]
close $infile

proc lc {s1 s2} {
    return [expr {[string length $s1] - [string length $s2]}]
}

set outputs {}
foreach line $lines {
    set result [string trim [lindex [split $line "|"] 1]]
    set out {}
    foreach res $result {
        lappend out [lsort [split $res ""]]
    }
    lappend outputs $out
}

set inputs {}
foreach line $lines {
    set result [string trim [lindex [split $line "|"] 0]]
    set out {}
    foreach res $result {
        lappend out [lsort [split $res ""]]
    }
    lappend inputs [lsort -command lc $out]
}

set uniques 0
foreach output $outputs {
    foreach dig $output {
        set len [llength $dig]
        if {$len == 2 || $len == 4 || $len == 3 || $len == 7} {
            incr uniques
        }
    }
}
puts "uniques = $uniques"

proc grab {lst idxs} {
    set out {}
    foreach idx $idxs {
        lappend out [lindex $lst $idx]
    }
    return $out
}

# UGLY!
proc jives {l1 l2} {
    set huh 0
    set numhuh [llength [lsearch -exact -all $l2 "?"]]
    foreach el $l1 {
        if {([lsearch -exact $l2 $el] != -1)} {continue}
        if {([lsearch -exact $l2 "?"] != -1) && ($huh < $numhuh)} {
            incr numhuh
            continue
        }
        return 0
    }
    return 1
}

proc works {config nums} {
    foreach num $nums {
        # 1
        if {[llength $num] == 2} {
            if {![jives $num [grab $config {2 5}]]} {
                return 0
            }
        }

        # 7
        if {[llength $num] == 3} {
            if {![jives $num [grab $config {0 2 5}]]} {
                return 0
            }
        }

        # 4
        if {[llength $num] == 4} {
            if {![jives $num [grab $config {1 2 3 5}]]} {
                return 0
            }
        }

        # 2, 3, and 5
        if {[llength $num] == 5} {
            if {!([jives $num [grab $config {0 2 3 4 6}]] || [jives $num [grab $config {0 2 3 5 6}]] || [jives $num [grab $config {0 1 3 5 6}]])} {
                return 0
            }
        }

        # 0, 6, and 9
        if {[llength $num] == 6} {
            if {!([jives $num [grab $config {0 1 2 4 5 6}]] || [jives $num [grab $config {0 1 3 4 5 6}]] || [jives $num [grab $config {0 1 2 3 5 6}]])} {
                return 0
            }
        }

        # 8
        if {[llength $num] == 8} {
            if {![jives $num [lsort $config]]} {
                return 0
            }
        }
    }
    return 1
}

proc search {config nums index} {
    if {$index > 6} {
        return $config
    }
    foreach candidate "a b c d e f g" {
        if {[lsearch -exact $config $candidate] != -1} {continue}
        set newConfig $config
        lset newConfig $index $candidate
        if {[works $newConfig $nums]} {
            set res [search $newConfig $nums [expr {$index + 1}]]
            if {$res != "fail"} {
                return $res
            }
        }
    }
    return fail
}

set mapping {
    "012456" 0
    "25" 1
    "02346" 2
    "02356" 3
    "1235" 4
    "01356" 5
    "013456" 6
    "025" 7
    "0123456" 8
    "012356" 9
}

# set config [search [list ? ? ? ? ? ? ?] [lindex $inputs 0] 0]

proc translate {input config} {
    variable mapping

    set lol {}
    foreach q $input {
        set idx [lsearch $config $q]
        lappend lol $idx
    }
    return [dict get $mapping [join [lsort -ascii $lol] ""]]
}

proc convoutput {data config} {
    set out {}
    foreach datum $data {
        set out "$out[translate $datum $config]"
    }
    return [string trimleft $out "0"]
}

set total 0
foreach inp $inputs out $outputs {
    puts "processing $inp"
        set config [search [list ? ? ? ? ? ? ?] $inp 0]
        incr total [convoutput $out $config]
}

puts "total = $total"
