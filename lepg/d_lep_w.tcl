#----------------------------------------------------------------------
#  proc myApp_lep_w
#
#  write all data in leparagliding.txt
#----------------------------------------------------------------------
proc myApp_lep_w { } {

    global mtf mtfi mtfj maf

    global linea bname wname xkf xwf ncells nribst nribss alpham kbbb \
    alphac atp kaaa rib ribg nomair ndis nrib1 nrib2 nhols hol \
    skin htens ndif xndif \
    xupp xupple xuppte xlow xlowle xlowte xrib xvrib xmark xcir xdes \
    finesse cpress calage clengr clengl clengk zcontrol slp cam mc \
    clengb brake bd raml nhvr xrsep yrsep hvr \
    npce npc1e npc2e npc3e xpc1e xpc2e \
    npci npc1i npc2i npc3i xpc1i xpc2i \
    narp xarp yarp csusl cdis

    set file [open "lep/leparagliding_new.txt" w+]

    set estels \
    "**************************************************************"
    set seps ""
    set sep1 " "
    set sep2 "  "
    set sep3 "   "
    set sep4 "     "

#   Write 1, Geometry

#    set i 1 
#    while {$i <= 9} { 
#    puts $file "***"
#    incr i }
    
    puts $file $estels
    puts $file "* LABORATORI D'ENVOL PARAGLIDING DESIGN                      *"
    puts -nonewline $file "* Input data file version "
    puts -nonewline $file "2.52   "
    puts -nonewline $file "2016-08-21"
    puts $file "                  *"
    puts $file $estels
    puts $file "* Generated automatically by LEP GUI                         *"
    puts $file $estels
    puts $file "*             1. GEOMETRY                                    *"
    puts $file $estels

    puts $file "* Brand name"
    puts $file $bname
    puts $file "* Wing name"
    puts $file $wname
    puts $file "* Drawind scale" 
    puts $file $xkf    
    puts $file "* Wing scale"
    puts $file $xwf    
    puts $file "* Number of cells"
    puts $file $ncells
    puts $file "* Number of ribs"
    puts $file $nribst
    puts $file "* Alpha wing tip, parameter, alpha center"
    puts -nonewline $file $alpham ; puts -nonewline $file "   "; \
    puts $file $kbbb 

    puts $file "Paraglider type and parameter"
    puts -nonewline $file $atp
    puts -nonewline $file "    "
    puts $file $kaaa 

    puts $file "* Rib geometric parameters"
    puts $file "* Rib	x-rib	y-LE	y-TE	xp	z	beta	RP	Washin"

#   Matrix of geometry
    set i 1 
    while {$i <= $nribss} { 
    puts $file $ribg($i) 
    incr i
    }

#   Section 2. AIRFOILS
    puts $file $estels
    puts $file "*             2. AIRFOILS       	                     *"
    puts $file $estels
    puts $file "* Airfoil name, intake in, intake out, open , disp. rrw"

    # Load data in the auxiliar mtf matrix
    set i 1 
    while {$i <= $nribss} { 
    set mtf($i,1) $rib($i,1)
    set mtf($i,2) $nomair($i)
    set mtf($i,3) $rib($i,11)
    set mtf($i,4) $rib($i,12)
    set mtf($i,5) $rib($i,14)
    set mtf($i,6) $rib($i,50)
    set mtf($i,7) $rib($i,55)
    set mtf($i,8) $rib($i,56)
    set mtfi $nribss
    set mtfj 8
    incr i}

    # Call for format
    formatmatrix

    # Puts matrix in file
    set i 1 
    while {$i <= $nribss} { 
    puts -nonewline $file $maf($i,1) 
    puts -nonewline $file $maf($i,2) 
    puts -nonewline $file $maf($i,3) 
    puts -nonewline $file $maf($i,4) 
    puts -nonewline $file $maf($i,5) 
    puts -nonewline $file $maf($i,6) 
    puts -nonewline $file $maf($i,7) 
    puts            $file $maf($i,8) 
    incr i}
    unset maf
    
#   Section 3. ANCHOR POINTS
    puts $file $estels
    puts $file "*             3. ANCHOR POINTS    	                     *"
    puts $file $estels
    puts $file "* Airf	Anch	A	B	C	D	E	F"

 # Load data in the auxiliar mtf matrix
    set i 1 
    while {$i <= $nribss} { 
    set mtf($i,1) $rib($i,1)
    set mtf($i,2) $rib($i,15)
    set mtf($i,3) $rib($i,16)
    set mtf($i,4) $rib($i,17)
    set mtf($i,5) $rib($i,18)
    set mtf($i,6) $rib($i,19)
    set mtf($i,7) $rib($i,20)
    set mtf($i,8) $rib($i,21)
    set mtfi $nribss
    set mtfj 8
    incr i}

    # Call for format
    formatmatrix

    # Puts matrix in file
    set i 1 
    while {$i <= $nribss} { 
    puts -nonewline $file $maf($i,1) 
    puts -nonewline $file $maf($i,2) 
    puts -nonewline $file $maf($i,3) 
    puts -nonewline $file $maf($i,4) 
    puts -nonewline $file $maf($i,5) 
    puts -nonewline $file $maf($i,6) 
    puts -nonewline $file $maf($i,7) 
    puts            $file $maf($i,8) 
    incr i}
    unset maf

    
#   Section 4. AIRFOIL HOLES
    puts $file $estels
    puts $file "*             4. AIRFOIL HOLES    	                     *"
    puts $file $estels
   
    set m 1

    while {$m <= $ndis} {

    puts $file $nrib1($m)
    puts $file $nrib2($m)
    puts $file $nhols($m)

    set ir $nrib1($m)

    set l 1
    while {$l <= $nhols($m)} { 
    set mtf($l,1) $hol($ir,$l,9)
    set mtf($l,2) $hol($ir,$l,2)
    set mtf($l,3) $hol($ir,$l,3)
    set mtf($l,4) $hol($ir,$l,4)
    set mtf($l,5) $hol($ir,$l,5)
    set mtf($l,6) $hol($ir,$l,6)
    set mtf($l,7) $hol($ir,$l,7)
    set mtf($l,8) $hol($ir,$l,8)
    set mtfi $nhols($m)
    set mtfj 8
    incr l }

    # Call for format
    formatmatrix

    # Puts matrix in file
    set i 1 
    while {$i <= $nhols($m)} { 
    puts -nonewline $file $maf($i,1) 
    puts -nonewline $file $maf($i,2) 
    puts -nonewline $file $maf($i,3) 
    puts -nonewline $file $maf($i,4) 
    puts -nonewline $file $maf($i,5) 
    puts -nonewline $file $maf($i,6) 
    puts -nonewline $file $maf($i,7) 
    puts            $file $maf($i,8) 
    incr i}
    unset maf

    incr m }

#   Section 5. SKIN TENSION
    puts $file $estels
    puts $file "*             5. SKIN TENSION    	                     *"
    puts $file $estels
    puts $file "Extrados              Intrados"

    set k 1
    while {$k <= 6} { 
    set mtf($k,1) $skin($k,1)
    set mtf($k,2) $skin($k,2)
    set mtf($k,3) $skin($k,3)
    set mtf($k,4) $skin($k,4)
    set mtfi 6
    set mtfj 4
    incr k }

    # Call for format
    formatmatrix

    # Puts matrix in file

    set i 1 
    while {$i <= 6} { 
    puts -nonewline $file $maf($i,1) 
    puts -nonewline $file $maf($i,2) 
    puts -nonewline $file $maf($i,3) 
    puts            $file $maf($i,4) 
    incr i}
    unset maf
 
    puts $file $htens
    puts -nonewline $file $ndif; puts -nonewline $file "    "
    puts $file $xndif


#----------------------------------------------------------------------
#   6. SEWING ALLOWANCES
#----------------------------------------------------------------------

    puts $file $estels
    puts $file "*           6. SEWING ALLOWANCES                            *"
    puts $file $estels

    puts -nonewline $file $xupp;   puts -nonewline $file "    "
    puts -nonewline $file $xupple; puts -nonewline $file "    "
    puts -nonewline $file $xuppte; puts -nonewline $file "    "
    puts            $file "upper panels (mm)"

    puts -nonewline $file $xlow;   puts -nonewline $file "    "
    puts -nonewline $file $xlowle; puts -nonewline $file "    "
    puts -nonewline $file $xlowte; puts -nonewline $file "    "
    puts            $file "lower panels (mm)"

    puts -nonewline $file $xrib; puts -nonewline $file "    "
    puts            $file "ribs (mm)"

    puts -nonewline $file $xvrib; puts -nonewline $file "    "
    puts            $file "vribs (mm)"


#---------------------------------------------------------------------
#   7. MARKS
#---------------------------------------------------------------------

    puts $file $estels
    puts $file "*           7. MARKS                                        *"
    puts $file $estels
    puts -nonewline $file $xmark; puts -nonewline $file "    "
    puts -nonewline $file $xcir; puts -nonewline $file "    "
    puts $file $xdes

#---------------------------------------------------------------------
#   8. Global angle of attack
#---------------------------------------------------------------------

    puts $file $estels
    puts $file "*           8. Global angle of attack estimation            *"
    puts $file $estels

    puts $file "* Finesse GR"
    puts $file $finesse
    puts $file "* Center of pressure % of chord"
    puts $file $cpress
    puts $file "* Calage %"
    puts $file $calage
    puts $file "* Risers lenght cm"
    puts $file $clengr
    puts $file "* Line lenght cm"
    puts $file $clengl
    puts $file "* Karabiners cm"
    puts $file $clengk
	
#---------------------------------------------------------------------
#   9. Suspension lines description
#---------------------------------------------------------------------

    puts $file $estels
    puts $file "*          9. SUSPENSION LINES DESCRIPTION                  *"
    puts $file $estels

    puts $file $zcontrol
    puts $file $slp

    set ii 1
    while {$ii <= $slp} { 

    puts $file $cam($ii)    

    set i 1
    while {$i <= $cam($ii)} { 

    puts -nonewline $file $mc($ii,$i,1);   puts -nonewline $file "     "

    puts -nonewline $file $mc($ii,$i,2);   puts -nonewline $file " "
    puts -nonewline $file $mc($ii,$i,3);   puts -nonewline $file "     "

    puts -nonewline $file $mc($ii,$i,4);   puts -nonewline $file " "
    puts -nonewline $file $mc($ii,$i,5)
    set jlen [string length $mc($ii,$i,5)]
    if { $jlen == 1 } {
    puts -nonewline $file "     "
    } else { puts -nonewline $file "    "
    }

    puts -nonewline $file $mc($ii,$i,6);   puts -nonewline $file " "
    puts -nonewline $file $mc($ii,$i,7)
    set jlen [string length $mc($ii,$i,7)]
    if { $jlen == 1 } {
    puts -nonewline $file "     "
    } else { puts -nonewline $file "    "
    }

    puts -nonewline $file $mc($ii,$i,8);   puts -nonewline $file " "
    puts -nonewline $file $mc($ii,$i,9)
    set jlen [string length $mc($ii,$i,9)]
    if { $jlen == 1 } {
    puts -nonewline $file "     "
    } else { puts -nonewline $file "    "
    }

    puts -nonewline $file $mc($ii,$i,14);  puts -nonewline $file " "
    puts            $file $mc($ii,$i,15)

    incr i }

    incr ii }


#---------------------------------------------------------------------
#   10. Brakes
#---------------------------------------------------------------------

    
    puts $file $estels
    puts $file "*          10. BRAKES                                        *" 
    puts $file $estels

    set ii [expr $slp+1]

    puts $file $clengb
    puts $file $cam($ii)

#   Write 4 levels
    set i 1
    while {$i <= $cam($ii)} {

    puts -nonewline $file $mc($ii,$i,1);   puts -nonewline $file "     "

    puts -nonewline $file $mc($ii,$i,2);   puts -nonewline $file " "
    puts -nonewline $file $mc($ii,$i,3)
    set jlen [string length $mc($ii,$i,3)]
    if { $jlen == 1 } {
    puts -nonewline $file "     "
    } else { puts -nonewline $file "    "
    }

    puts -nonewline $file $mc($ii,$i,4);   puts -nonewline $file " "
    puts -nonewline $file $mc($ii,$i,5)
    set jlen [string length $mc($ii,$i,5)]
    if { $jlen == 1 } {
    puts -nonewline $file "     "
    } else { puts -nonewline $file "    "
    }

    puts -nonewline $file $mc($ii,$i,6);   puts -nonewline $file " "
    puts -nonewline $file $mc($ii,$i,7)
    set jlen [string length $mc($ii,$i,7)]
    if { $jlen == 1 } {
    puts -nonewline $file "     "
    } else { puts -nonewline $file "    "
    }

    puts -nonewline $file $mc($ii,$i,8);   puts -nonewline $file " "
    puts -nonewline $file $mc($ii,$i,9)
    set jlen [string length $mc($ii,$i,9)]
    if { $jlen == 1 } {
    puts -nonewline $file "     "
    } else { puts -nonewline $file "    "
    }

    puts -nonewline $file $mc($ii,$i,14);  puts -nonewline $file " "
    puts            $file $brake($i,3)

    incr i }

# Brake distribution
    set l 1
    while { $l <= 2 } { 

    puts -nonewline $file $bd(1,$l); puts -nonewline $file "     "
    puts -nonewline $file $bd(2,$l); puts -nonewline $file "     "
    puts -nonewline $file $bd(3,$l); puts -nonewline $file "     "
    puts -nonewline $file $bd(4,$l); puts -nonewline $file "     "
    puts            $file $bd(5,$l)

    incr l }


#---------------------------------------------------------------------
#   11. Ramification lengths
#---------------------------------------------------------------------

    puts $file $estels
    puts $file "*          11. Ramification lengths                         *" 
    puts $file $estels

    puts -nonewline $file $raml(3,1); puts -nonewline $file "     "
    puts            $file $raml(3,3)

    puts -nonewline $file $raml(4,1); puts -nonewline $file "     "
    puts -nonewline $file $raml(4,3); puts -nonewline $file "     "
    puts            $file $raml(4,4)

    puts -nonewline $file $raml(5,1); puts -nonewline $file "     "
    puts            $file $raml(5,3)

    puts -nonewline $file $raml(6,1); puts -nonewline $file "     "
    puts -nonewline $file $raml(6,3); puts -nonewline $file "     "
    puts            $file $raml(6,4)

#---------------------------------------------------------------------
#   12. H V and VH ribs
#---------------------------------------------------------------------

    puts $file $estels
    puts $file "*          12. H V and VH ribs                              *" 
    puts $file $estels

    puts $file $nhvr
    puts -nonewline $file $xrsep; puts -nonewline $file "     "
    puts            $file $yrsep

    set i 1
    while {$i <= $nhvr} {
#   Note: we can improve alignement of the matrix
    puts -nonewline $file $hvr($i,1); puts -nonewline $file "     "
    puts -nonewline $file $hvr($i,2); puts -nonewline $file "     "
    puts -nonewline $file $hvr($i,3); puts -nonewline $file "     "
    puts -nonewline $file $hvr($i,4); puts -nonewline $file "     "
    puts -nonewline $file $hvr($i,5); puts -nonewline $file "     "
    puts -nonewline $file $hvr($i,6); puts -nonewline $file "     "
    puts -nonewline $file $hvr($i,7); puts -nonewline $file "     "
    puts -nonewline $file $hvr($i,8); puts -nonewline $file "     "
    puts -nonewline $file $hvr($i,9); puts -nonewline $file "     "
#   Case 6
    if { $hvr($i,2) == 6 } {
    puts -nonewline $file $hvr($i,10); puts -nonewline $file "     "
    puts -nonewline $file $hvr($i,11); puts -nonewline $file "     "
    puts            $file $hvr($i,12)
    } else { puts   $file $hvr($i,10)
    }

    incr i }

#---------------------------------------------------------------------
#   15. Extrados colors
#---------------------------------------------------------------------
    
    puts $file $estels
    puts $file "*          15. Extrados colors                              *" 
    puts $file $estels

    puts $file $npce

    set k 1
    while {$k <= $npce} {

    puts -nonewline $file $npc1e($k) ; puts -nonewline $file "     "
    puts            $file $npc2e($k)

    set l 1
    while {$l <= $npc2e($k)} {
    
    puts -nonewline $file $npc3e($k,$l) ; puts -nonewline $file "     "
    puts -nonewline $file $xpc1e($k,$l) ; puts -nonewline $file "     "
    puts            $file $xpc2e($k,$l)

    incr l }

    incr k }


#---------------------------------------------------------------------
#   16. Intrados colors
#---------------------------------------------------------------------

    puts $file $estels
    puts $file "*          16. Intrados colors                              *" 
    puts $file $estels

    puts $file $npci

    set k 1
    while {$k <= $npci} {

    puts -nonewline $file $npc1i($k) ; puts -nonewline $file "     "
    puts            $file $npc2i($k)

    set l 1
    while {$l <= $npc2i($k)} {
    
    puts -nonewline $file $npc3i($k,$l) ; puts -nonewline $file "     "
    puts -nonewline $file $xpc1i($k,$l) ; puts -nonewline $file "     "
    puts            $file $xpc2i($k,$l)

    incr l }

    incr k }

#---------------------------------------------------------------------
#   17. Aditional rib points
#---------------------------------------------------------------------

    puts $file $estels
    puts $file "*          17. Aditional rib points                         *" 
    puts $file $estels

    puts $file $narp

    set i 1
    while {$i <= $narp} {

    puts -nonewline $file $xarp($i) ; puts -nonewline $file "     "
    puts            $file $yarp($i)

    incr i }

#---------------------------------------------------------------------
#   18. Elastic lines corrections
#---------------------------------------------------------------------

    puts $file $estels
    puts $file "*          18. Elastic lines corrections                    *" 
    puts $file $estels

    puts $file $csusl

    puts -nonewline $file $cdis(2,1) ; puts -nonewline $file "     "
    puts            $file $cdis(2,2)

    puts -nonewline $file $cdis(3,1) ; puts -nonewline $file "     "
    puts -nonewline $file $cdis(3,2) ; puts -nonewline $file "     "
    puts            $file $cdis(3,3)

    puts -nonewline $file $cdis(4,1) ; puts -nonewline $file "     "
    puts -nonewline $file $cdis(4,2) ; puts -nonewline $file "     "
    puts -nonewline $file $cdis(4,3) ; puts -nonewline $file "     "
    puts            $file $cdis(4,4)

    puts -nonewline $file $cdis(5,1) ; puts -nonewline $file "     "
    puts -nonewline $file $cdis(5,2) ; puts -nonewline $file "     "
    puts -nonewline $file $cdis(5,3) ; puts -nonewline $file "     "
    puts -nonewline $file $cdis(5,4) ; puts -nonewline $file "     "
    puts            $file $cdis(5,5)

#----------------------------------------------------------------------
    close $file
}
#----------------------------------------------------------------------


#----------------------------------------------------------------------
#
#   Procedure formatmatrix
#  
#   Formats matrix mtf in maf with 
#   data aligned in columns to the left :)
#----------------------------------------------------------------------
proc formatmatrix { } {

    global mtf mtfi mtfj maf

    set seps ""
    set sep1 " "
    set sep2 "  "
    set sep3 "   "
    set sep4 "     "

    set j 1
    while {$j <= $mtfj} { 
    set jmax($j) 0

#   Calcule max length of the colum j
    set i 1
    while {$i < [expr $mtfi+1]} { 
    set jlen($i,$j) [string length $mtf($i,$j)]

    if { $jlen($i,$j) >= $jmax($j) } {
    set jmax($j) $jlen($i,$j)
    }

    incr i}

#   Complete string with blanc spaces for constant lenth
    set i 1
    while {$i < [expr $mtfi+1]} { 
    set nblanc($i,$j) [expr $jmax($j)-$jlen($i,$j)]

#   Null chain of lenth nblanc
    set seps ""
    set k 0
    while {$nblanc($i,$j) > $k} {
    append sepss $seps " "
    set seps $sepss
    set sepss ""
    incr k}
    
    append maf($i,$j) $mtf($i,$j) $seps $sep4

    incr i}
    
    incr j}

    }
#----------------------------------------------------------------------


  
