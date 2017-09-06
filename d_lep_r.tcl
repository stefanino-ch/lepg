#----------------------------------------------------------------------
#  proc myApp_lep_r
#
#  Read all data from leparagliding.txt
#----------------------------------------------------------------------
proc myApp_lep_r { } {

    global linea bname wname xkf xwf ncells nribst nribss alpham kbbb \
    alphac atp kaaa rib ribg nomair ndis nrib1 nrib2 nhols hol \
    skin htens ndif xndif \
    xupp xupple xuppte xlow xlowle xlowte xrib xvrib xmark xcir xdes \
    finesse cpress calage clengr clengl clengk zcontrol slp cam mc \
    clengb brake bd raml nhvr xrsep yrsep hvr \
    npce npc1e npc2e npc3e xpc1e xpc2e \
    npci npc1i npc2i npc3i xpc1i xpc2i \
    narp xarp yarp csusl cdis
    
    set file [open "lep/leparagliding.txt" r+]

#----------------------------------------------------------------------
#   Note: read structure and variables names exactly like in the
#   leparagliding.f fortran file
#----------------------------------------------------------------------

#   Read 1, Geometry

    set i 1 
    while {$i <= 9} { 
    set linea [gets $file] 
    incr i }
    set bname  [gets $file]
    set linea  [gets $file] 
    set wname  [gets $file] 
    set linea  [gets $file] 
    set xkf    [gets $file] 
    set linea  [gets $file] 
    set xwf    [gets $file] 
    set linea  [gets $file] 
    set ncells [expr [gets $file]]
    set linea  [gets $file] 
    set nribst [expr [gets $file]]
    set linea  [gets $file] 
    set alphamp [gets $file] 

#   Extract alphamp line
    set alpham [lindex $alphamp 0]
    set kbbb   [lindex $alphamp 1]
    if { $kbbb == 2 } {
    set alphac [lindex $alphamp 2]
    }
    if { $kbbb == 1 } {
    set alphac 0.0
    }

    set linea [gets $file] 
    set atpp  [gets $file] 

#   Extract atpp line
    set atp  [lindex $atpp 0]
    set kaaa [lindex $atpp 1]

    set linea [gets $file] 
    set linea [gets $file] 

    set nribss [expr ceil($nribst/2)]
#   Erase ".0" at the end of string
    set l [string length $nribss]
    set nribss [string range $nribss 0 [expr $l-3]]

#   Read matrix of geometry
    set i 1 
    while {$i <= $nribss} { 
    set ribg($i) [gets $file] 
      foreach j {0 1 2 3 4 5 6 7 8} {
      set sib($i,$j) [lindex $ribg($i) $j]
    }
    set rib($i,1) $sib($i,0)
    set rib($i,2) $sib($i,1)
    set rib($i,3) $sib($i,2)
    set rib($i,4) $sib($i,3)
    set rib($i,6) $sib($i,4)
    set rib($i,7) $sib($i,5)
    set rib($i,9) $sib($i,6)
    set rib($i,10) $sib($i,7)
    set rib($i,51) $sib($i,8)

    incr i }

#   Set washin parameteres if kbbb=0
    if { $kbbb == 0 } {
    set alphac $rib(1,8)
    set alpham $rib($nribss,8)
    }

    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file] 

#   Read airfoil data
    set i 1 
    while {$i <= $nribss} { 
    set rib($i) [gets $file] 
      foreach j {0 1 2 3 4 5 6 7} {
      set sib($i,$j) [lindex $rib($i) $j]
      }

    set rib($i,1)  $sib($i,0)
    set nomair($i) $sib($i,1)
    set rib($i,11) $sib($i,2)
    set rib($i,12) $sib($i,3)
    set rib($i,14) $sib($i,4)
    set rib($i,50) $sib($i,5)
    set rib($i,55) $sib($i,6)
    set rib($i,56) $sib($i,7)

    incr i }

    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file] 

#   Read anchors A,B,C,D,E,F location
    set i 1 
    while {$i <= $nribss} { 
    set rib($i) [gets $file] 
      foreach j {0 1 2 3 4 5 6 7} {
      set sib($i,$j) [lindex $rib($i) $j]
      }

    set rib($i,1)  $sib($i,0)
    set rib($i,15) $sib($i,1)
    set rib($i,16) $sib($i,2)
    set rib($i,17) $sib($i,3)
    set rib($i,18) $sib($i,4)
    set rib($i,19) $sib($i,5)
    set rib($i,20) $sib($i,6)
    set rib($i,21) $sib($i,7)

    incr i }


#   Read airfoil holes

    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file] 
    set ndis  [gets $file] 

    set m 1 
    while {$m <= $ndis} {
    set nrib1($m) [gets $file] 
    set nrib2($m) [gets $file] 
    set nhols($m) [gets $file] 

    set ir $nrib1($m)

    set l 1
    while {$l <= $nhols($m)} { 
    set rib($l) [gets $file] 
      foreach j {0 1 2 3 4 5 6 7} {
      set sib($l,$j) [lindex $rib($l) $j]
      }
    set hol($ir,$l,9) $sib($l,0)
    set hol($ir,$l,2) $sib($l,1)
    set hol($ir,$l,3) $sib($l,2)
    set hol($ir,$l,4) $sib($l,3)
    set hol($ir,$l,5) $sib($l,4)
    set hol($ir,$l,6) $sib($l,5)
    set hol($ir,$l,7) $sib($l,6)
    set hol($ir,$l,8) $sib($l,7)

    incr l }

    incr m }

#   Read skin tension

    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file] 

    set k 1
    while {$k <= 6} { 
    set rib($k) [gets $file] 
      foreach j {0 1 2 3} {
      set skin($k,[expr $j+1]) [lindex $rib($k) $j]
      }
    incr k }

    set htens [gets $file] 
    set linea [gets $file] 
    set ndif  [lindex $linea 0]
    set xndif [lindex $linea 1]

#   Read sewing allowances

    set linea  [gets $file] 
    set linea  [gets $file] 
    set linea  [gets $file]
 
    set linea  [gets $file] 
    set xupp   [lindex $linea 0]
    set xupple [lindex $linea 1]
    set xuppte [lindex $linea 2]

    set linea  [gets $file] 
    set xlow   [lindex $linea 0]
    set xlowle [lindex $linea 1]
    set xlowte [lindex $linea 2]

    set xrib   [gets $file] 
    set xvrib  [gets $file] 

#   Read marks

    set linea  [gets $file] 
    set linea  [gets $file] 
    set linea  [gets $file]
 
    set linea  [gets $file] 
    set xmark  [lindex $linea 0]
    set xcir   [lindex $linea 1]
    set xdes   [lindex $linea 2]

#   Read 8. Global angle of attack

    set linea  [gets $file] 
    set linea  [gets $file] 
    set linea  [gets $file]

    set linea   [gets $file]
    set finesse [gets $file]
    set linea  [gets $file]
    set cpress [gets $file]
    set linea  [gets $file]
    set calage [gets $file]
    set linea  [gets $file]
    set clengr [gets $file]
    set linea  [gets $file]
    set clengl [gets $file]
    set linea  [gets $file]
    set clengk [gets $file]

#   Read 9. Suspension lines description

    set linea  [gets $file] 
    set linea  [gets $file] 
    set linea  [gets $file]

    set zcontrol [gets $file]
    set slp      [gets $file]

    set ii 1
    while {$ii <= $slp} { 

    set cam($ii) [gets $file]

#   Read 4 levels
    set i 1
    while {$i <= $cam($ii)} {
    set linea  [gets $file] 
    set mc($ii,$i,1)   [lindex $linea 0]
    set mc($ii,$i,2)   [lindex $linea 1]
    set mc($ii,$i,3)   [lindex $linea 2]
    set mc($ii,$i,4)   [lindex $linea 3]
    set mc($ii,$i,5)   [lindex $linea 4]
    set mc($ii,$i,6)   [lindex $linea 5]
    set mc($ii,$i,7)   [lindex $linea 6]
    set mc($ii,$i,8)   [lindex $linea 7]
    set mc($ii,$i,9)   [lindex $linea 8]
    set mc($ii,$i,14)  [lindex $linea 9]
    set mc($ii,$i,15)  [lindex $linea 10]
    incr i }

    incr ii }

#   Read 10. Brakes

    set linea  [gets $file] 
    set linea  [gets $file] 
    set linea  [gets $file]

    set ii [expr $slp+1]

    set clengb   [gets $file]
    set cam($ii) [gets $file]

#   Read 4 levels
    set i 1
    while {$i <= $cam($ii)} {
    set linea  [gets $file] 
    set mc($ii,$i,1)   [lindex $linea 0]
    set mc($ii,$i,2)   [lindex $linea 1]
    set mc($ii,$i,3)   [lindex $linea 2]
    set mc($ii,$i,4)   [lindex $linea 3]
    set mc($ii,$i,5)   [lindex $linea 4]
    set mc($ii,$i,6)   [lindex $linea 5]
    set mc($ii,$i,7)   [lindex $linea 6]
    set mc($ii,$i,8)   [lindex $linea 7]
    set mc($ii,$i,9)   [lindex $linea 8]
    set mc($ii,$i,14)  [lindex $linea 9]
    set brake($i,3)    [lindex $linea 10]
    incr i }

    set linea   [gets $file] 

    set linea   [gets $file] 
    set bd(1,1) [lindex $linea 0]
    set bd(2,1) [lindex $linea 1]
    set bd(3,1) [lindex $linea 2]
    set bd(4,1) [lindex $linea 3]
    set bd(5,1) [lindex $linea 4]

    set linea   [gets $file] 
    set bd(1,2) [lindex $linea 0]
    set bd(2,2) [lindex $linea 1]
    set bd(3,2) [lindex $linea 2]
    set bd(4,2) [lindex $linea 3]
    set bd(5,2) [lindex $linea 4]

#   Read 11. Ramification lengths

    set linea  [gets $file] 
    set linea  [gets $file] 
    set linea  [gets $file]

    set linea     [gets $file] 
    set raml(3,1) [lindex $linea 0]
    set raml(3,3) [lindex $linea 1]

    set linea     [gets $file] 
    set raml(4,1) [lindex $linea 0]
    set raml(4,3) [lindex $linea 1]
    set raml(4,4) [lindex $linea 2]

    set linea     [gets $file] 
    set raml(5,1) [lindex $linea 0]
    set raml(5,3) [lindex $linea 1]

    set linea     [gets $file] 
    set raml(6,1) [lindex $linea 0]
    set raml(6,3) [lindex $linea 1]
    set raml(6,4) [lindex $linea 2]

#   Read 12. H V and VH ribs

    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file]

    set nhvr  [gets $file] 

    set linea [gets $file] 
    set xrsep [lindex $linea 0]
    set yrsep [lindex $linea 1]

    set i 1
    while {$i <= $nhvr} {
    set linea [gets $file]
    foreach j {0 1 2 3 4 5 6 7 8 9} {
    set hvr($i,[expr $j+1]) [lindex $linea $j]
    }
    # If case 6, read 12 numbers
    if { $hvr($i,2) == 6 } {
    foreach j {0 1 2 3 4 5 6 7 8 9 10 11} {
    set hvr($i,[expr $j+1]) [lindex $linea $j]
    }
    }
    incr i }

#   Read 15. Extrados colors

    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file]

    set npce  [gets $file] 

    set k 1
    while {$k <= $npce} {

    set linea [gets $file] 
    set npc1e($k) [lindex $linea 0]
    set npc2e($k) [lindex $linea 1]

    set l 1
    while {$l <= $npc2e($k)} {

    set linea [gets $file] 
    set npc3e($k,$l) [lindex $linea 0]
    set xpc1e($k,$l) [lindex $linea 1]
    set xpc2e($k,$l) [lindex $linea 2]

    incr l }

    incr k }

#   Read 16. Intrados colors

    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file]

    set npci  [gets $file] 

    set k 1
    while {$k <= $npci} {

    set linea [gets $file] 
    set npc1i($k) [lindex $linea 0]
    set npc2i($k) [lindex $linea 1]

    set l 1
    while {$l <= $npc2i($k)} {

    set linea [gets $file] 
    set npc3i($k,$l) [lindex $linea 0]
    set xpc1i($k,$l) [lindex $linea 1]
    set xpc2i($k,$l) [lindex $linea 2]

    incr l }

    incr k }

#   Read 17. Aditional rib points

    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file]

    set narp [gets $file] 

    set i 1
    while {$i <= $narp} {
    set linea [gets $file] 
    set xarp($i) [lindex $linea 0]
    set yarp($i) [lindex $linea 1]
    incr i }

#   Read 18. Elastic lines corrections

    set linea [gets $file] 
    set linea [gets $file] 
    set linea [gets $file]

    set csusl [gets $file]

    set linea [gets $file] 
    set cdis(2,1) [lindex $linea 0]
    set cdis(2,2) [lindex $linea 1]

    set linea [gets $file] 
    set cdis(3,1) [lindex $linea 0]
    set cdis(3,2) [lindex $linea 1]
    set cdis(3,3) [lindex $linea 2]

    set linea [gets $file] 
    set cdis(4,1) [lindex $linea 0]
    set cdis(4,2) [lindex $linea 1]
    set cdis(4,3) [lindex $linea 2]
    set cdis(4,4) [lindex $linea 3]

    set linea [gets $file] 
    set cdis(5,1) [lindex $linea 0]
    set cdis(5,2) [lindex $linea 1]
    set cdis(5,3) [lindex $linea 2]
    set cdis(5,4) [lindex $linea 3]
    set cdis(5,5) [lindex $linea 4]

#----------------------------------------------------------------------
    close $file
}





