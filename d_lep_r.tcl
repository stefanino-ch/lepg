#----------------------------------------------------------------------
#  proc myApp_lep_r
#
#  Read all data from leparagliding.txt
#----------------------------------------------------------------------
proc myApp_lep_r { } {

    global bname wname xkf xwf ncells nribst nribss alpham kbbb \
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

    # Read 1, Geometry

    set i 1
    while {$i <= 9} {
    set dataline [gets $file]
    incr i }
    # BrandName
    set bname  [gets $file]
    set dataline  [gets $file]
    # WingName
    set wname  [gets $file]
    set dataline  [gets $file]
    # DrawScale
    set xkf    [gets $file]
    set dataline  [gets $file]
    # WingScale
    set xwf    [gets $file]
    set dataline  [gets $file]
    # NumCells
    set ncells [expr [gets $file]]
    set dataline  [gets $file]
    # NumRibs
    set nribst [expr [gets $file]]
    set dataline  [gets $file]
    
    # washin = negative Flügelschränkung
    # WashinAlphaLine
    set alphamp [gets $file]

    # Extract alphamp line
    # WashinAlphaTip
    set alpham [lindex $alphamp 0]
    
    # WashinMode
    # 0: the washin will be done manually
    # 1: then washin will be done proportinal to the chord, 
    #    being maximun and positive at the tip, using only the first real of the line
    # 2: automatic washin angles are set from center airfoil to wingtip. 
    #    The first real is the washin in wingtip, then set "2", and the last real 
    #    is the washin in the central airfoil
    set kbbb   [lindex $alphamp 1]
    if { $kbbb == 2 } {
    # WashinAlphaCenter
    set alphac [lindex $alphamp 2]
    }
    if { $kbbb == 1 } {
    set alphac 0.0
    }

    set dataline [gets $file]
    #ParaTypeLine
    set atpp  [gets $file]

    # Extract atpp line
    # ParaType
    set atp  [lindex $atpp 0]
    
    # RotLeTriang - Rotate Leading Edge triangle
    set kaaa [lindex $atpp 1]

    set dataline [gets $file]
    set dataline [gets $file]

    set nribss [expr ceil($nribst/2)]
    # Erase ".0" at the end of string
    set l [string length $nribss]
    # NumberRibs
    set nribss [string range $nribss 0 [expr $l-3]]

    # Read matrix of geometry
    set i 1
    while {$i <= $nribss} {
        # RibGeometryLine
        set ribg($i) [gets $file]
          foreach j {0 1 2 3 4 5 6 7 8} {
          # RibGeometry
          set sib($i,$j) [lindex $ribg($i) $j]
        }
        # Rib
        # Rib Num Param Desc
        #     n   1     Rib number
        #     n   2     rib X coordinate
        #     n   3     Y coordinate of the leading edge
        #     n   4     Y coordinate of the trailing edge
        #     n   6     X' coordinate of the rib in its final position in space
        #     n   7     Z coordinate of the rib in its final position in space
        #     n   9     the angle "beta" of the rib to the vertical (degres)
        #     n   10    RP percentage of chord to be held on the relative torsion of the airfoils
# What does "RP" mean?
        
        #     n   51    washin in degrees defined manually (if parameter is set to "0")
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

    # Set washin parameteres if kbbb=0 => manual washin
    if { $kbbb == 0 } {
# Lines below do not work from my point of view?
# At this time during the read $rib(1,8) has not yet been initialized the value is not defined
        set alphac $rib(1,8)
        set alpham $rib($nribss,8)
        
# From my point of view code should look like
# set alphac $ribg(1,8)
# set alpham $ribg($nribss,8)

# OR maybe the more intuitive way
# set alphac $rib(1,51)
# set alpham $ribg($nribss,51)
    }

    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]

    # Read airfoil data
    set i 1
    while {$i <= $nribss} {
# Here in we do have twice a "rib" array?
# First array: one dimension to read the full line from the file
# Second array: two dimensional which holds the geometry data
# Would it make sense the code to change to something like: "set dataLine($i) [gets $file]"?
        set rib($i) [gets $file]
          foreach j {0 1 2 3 4 5 6 7} {
          set sib($i,$j) [lindex $rib($i) $j]
        }
        # Rib Num Param Desc
        #     n   1     Rib number
        #     n   11    Percentage of chord start of the air inlet
        #     n   12    Percentage of chord end of the air  inlet
        #     n   14    Value 1 or 0 to create closed cells, at the left of rib ("0" indicates closed-cell, "1" open)
        #     n   50    Displacement in cm of the rib perpendicular to the chord, and in the plane of the rib itself
        #     n   55    Relative weight of the chord, in relation to the load. Value is usually 1
        #     n   56    "0" or "1", only used in single skin paragliders
        #               "0" means that the triangles are not rotated, but they are set according to the angle "beta" specified in Section 1
        #               Real value "1" (or "1.") means that the triangles are rotated automatically in the corresponding profile. 
        #               Greater than 1.0 is possible define and draw trailing edge "miniribs" ("minicabs") in non "ss" paragliders: 
        #               The value, simply define the minirib length (in %).
        #               "100" activates a new specific programation. Middle unloaded ribs. New plan numbered "1-6"
        set rib($i,1)  $sib($i,0)
        # Name of Airfoil
        set nomair($i) $sib($i,1)
        set rib($i,11) $sib($i,2)
        set rib($i,12) $sib($i,3)
        set rib($i,14) $sib($i,4)
        set rib($i,50) $sib($i,5)
        set rib($i,55) $sib($i,6)
        set rib($i,56) $sib($i,7)

        incr i 
    }

    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]

    # Read anchors A,B,C,D,E,F location
    set i 1
    while {$i <= $nribss} {
        set rib($i) [gets $file]
# Here in we do have twice a "rib" array?
# First array: one dimension to read the full line from the file
# Second array: two dimensional which holds the geometry data
# Would it make sense the code to change to something like: "set dataLine($i) [gets $file]"?
            foreach j {0 1 2 3 4 5 6 7} {
            set sib($i,$j) [lindex $rib($i) $j]
        }
        # Rib Num Param Desc
        #     n   1     Rib number
        #     n   15    Number of anchors in the rib
        #     n   16    Anchor position A as% of rib 
        #     n   17    Anchor position B as% of rib
        #     n   18    Anchor position C as% of rib 
        #     n   19    Anchor position D as% of rib 
        #     n   20    Anchor position E as% of rib 
        #     n   21    Anchor position F as% of rib-> brake lines
        set rib($i,1)  $sib($i,0)
        set rib($i,15) $sib($i,1)
        set rib($i,16) $sib($i,2)
        set rib($i,17) $sib($i,3)
        set rib($i,18) $sib($i,4)
        set rib($i,19) $sib($i,5)
        set rib($i,20) $sib($i,6)
        set rib($i,21) $sib($i,7)

        incr i 
    }

    #   Read airfoil holes
    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]
    # Number of Airfoil configurations
    set ndis  [gets $file]

    set m 1
    while {$m <= $ndis} {
        # Initial rib for first lightening configuration
        set nrib1($m) [gets $file]
        # Final rib for first lightening configuration
        set nrib2($m) [gets $file]
        # Number of holes for the first lightening configuration
        set nhols($m) [gets $file]

        #Initial Rib Number
        set ir $nrib1($m)

        set l 1
        while {$l <= $nhols($m)} {
            set rib($l) [gets $file]
# Would it make sense the code to change to something like: "set dataLine($i) [gets $file]"?
            foreach j {0 1 2 3 4 5 6 7} {
            set sib($l,$j) [lindex $rib($l) $j]
        }
        # hol   InitialRib  HoleNum     ParamValue  Desc
        #       n           x           9           Hole type
        #                                           1: Ellipse
        #                                           2: ellipse or circle with central strip
        #                                           3: triangle
        #       n           x           2           T1: Distance from LE to hole center in% chord
        #                                           T2: Distance from LE to hole center in% chord
        #                                           T3: Distance from LE to triangle in% chord
        #       n           x           3           T1: Distance from the center of hole to the chord line in% of chord
        #                                           T2: Distance from the center of hole to the chord line in% of chord
        #                                           T3: Distance from the center of the triangle corner to the chord line in% of chord
        #       n           x           4           T1: Horizontal axis of the ellipse as% of chord
        #                                           T2: Horizontal axis of the ellipse as% of chord
        #                                           T3: Traingle base as% of chord
        #       n           x           5           T1: Ellipse vertical axis as% of chord
        #                                           T2: Ellipse vertical axis as% of chord
        #                                           T3: Triangle heigth as% of chord
        #       n           x           6           T1: Rotation angle of the ellipse
        #                                           T2: Rotation angle of the ellipse
        #                                           T3: Rotation angle of the base
        #       n           x           7           T1: 0. (not used)
        #                                           T2: central strip width
        #                                           T3: Radius of the smoothed corners
        #       n           x           8           T1: 0. (not used)
        #                                           T2: 0. (not used)
        #                                           T3: 0. (not used)
        # The 9th value on each config line is not read and saved, for all hole configuration it is not used

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

    # Read skin tension

    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]

    set k 1
    while {$k <= 6} {
        set rib($k) [gets $file]
# Would it make sense the code to change to something like: "set dataLine($i) [gets $file]"?
            foreach j {0 1 2 3} {
            # SkinTension
            set skin($k,[expr $j+1]) [lindex $rib($k) $j]
        }
        incr k 
    }
    # skin   ConfigLine     ParamNum    Desc
    #        1...6          1           Distance in% of chord on the leading edge of extrados
    #                       2           Extrados over-wide corresponding in % of chord 
    #                       3           Distance in% of chord on trailing edge
    #                       4           Intrados over-wide corresponding in% of chord
    
    # strain in mini-ribs           => don't touch
    set htens [gets $file]
    set dataline [gets $file]
    # Number of points np           => don't touch
    set ndif  [lindex $dataline 0]
    # k coeficient 0.0 to 1.0       => don't touch
    set xndif [lindex $dataline 1]

    # Read sewing allowances
    set dataline  [gets $file]
    set dataline  [gets $file]
    set dataline  [gets $file]

    set dataline  [gets $file]
    #Seam Allowance upper Panel
    set xupp   [lindex $dataline 0]
    #Seam Allowance upper Panel Leading Edge
    set xupple [lindex $dataline 1]
    #Seam Allowance upper Panel Trailing Edge
    set xuppte [lindex $dataline 2]

    set dataline  [gets $file]
    #Seam Allowance lower Panel
    set xlow   [lindex $dataline 0]
    #Seam Allowance lower Panel Leading Edge
    set xlowle [lindex $dataline 1]
    #Seam Allowance lower Panel Trailing Edge
    set xlowte [lindex $dataline 2]

    #Seam Allowance ribs
    set xrib   [gets $file]
    #Seam Allowance V-ribs
    set xvrib  [gets $file]

    # Read marks
    set dataline  [gets $file]
    set dataline  [gets $file]
    set dataline  [gets $file]

    set dataline  [gets $file]
    # Marks spacing
    set xmark  [lindex $dataline 0]
    # Mark point radius
    set xcir   [lindex $dataline 1]
    # Mark point displacement
    set xdes   [lindex $dataline 2]

    # Read 8. Global angle of attack

    set dataline  [gets $file]
    set dataline  [gets $file]
    set dataline  [gets $file]

    set dataline   [gets $file]
    # Finesse goal, according to the general proportions of the wing
    set finesse [gets $file]
    set dataline  [gets $file]
    # Position of the wing center of pressure estimated as % of central cord
    set cpress [gets $file]
    set dataline  [gets $file]
    # Calage in% (distance from the leading edge point to the perpendicular to the central chord from the pilot position)
    set calage [gets $file]
    set dataline  [gets $file]
    # Riser basic length [cm]
    set clengr [gets $file]
    set dataline  [gets $file]
    # Basic length of lines (maillons - sail) [cm]
    set clengl [gets $file]
    set dataline  [gets $file]
    # Separation between main carabiners [cm]
    set clengk [gets $file]

    # Read 9. Suspension lines description

    set dataline  [gets $file]
    set dataline  [gets $file]
    set dataline  [gets $file]

    # Line Control Parameter
    # 0 = lower branches lined only by geometric mean of the anchor points
    set zcontrol [gets $file]
    # Number of line plans
    set slp      [gets $file]

    set ii 1
    while {$ii <= $slp} {

        set cam($ii) [gets $file]

        # Read 4 levels
        set i 1
        while {$i <= $cam($ii)} {
            set dataline  [gets $file]
            set mc($ii,$i,1)   [lindex $dataline 0]
            set mc($ii,$i,2)   [lindex $dataline 1]
            set mc($ii,$i,3)   [lindex $dataline 2]
            set mc($ii,$i,4)   [lindex $dataline 3]
            set mc($ii,$i,5)   [lindex $dataline 4]
            set mc($ii,$i,6)   [lindex $dataline 5]
            set mc($ii,$i,7)   [lindex $dataline 6]
            set mc($ii,$i,8)   [lindex $dataline 7]
            set mc($ii,$i,9)   [lindex $dataline 8]
            set mc($ii,$i,14)  [lindex $dataline 9]
            set mc($ii,$i,15)  [lindex $dataline 10]
            incr i 
        }

        incr ii 
    }

    # Read 10. Brakes

    set dataline  [gets $file]
    set dataline  [gets $file]
    set dataline  [gets $file]

    set ii [expr $slp+1]

    set clengb   [gets $file]
    set cam($ii) [gets $file]

    # Read 4 levels
    set i 1
    while {$i <= $cam($ii)} {
        set dataline  [gets $file]
        set mc($ii,$i,1)   [lindex $dataline 0]
        set mc($ii,$i,2)   [lindex $dataline 1]
        set mc($ii,$i,3)   [lindex $dataline 2]
        set mc($ii,$i,4)   [lindex $dataline 3]
        set mc($ii,$i,5)   [lindex $dataline 4]
        set mc($ii,$i,6)   [lindex $dataline 5]
        set mc($ii,$i,7)   [lindex $dataline 6]
        set mc($ii,$i,8)   [lindex $dataline 7]
        set mc($ii,$i,9)   [lindex $dataline 8]
        set mc($ii,$i,14)  [lindex $dataline 9]
        set brake($i,3)    [lindex $dataline 10]
        incr i 
    }

    set dataline   [gets $file]

    set dataline   [gets $file]
    set bd(1,1) [lindex $dataline 0]
    set bd(2,1) [lindex $dataline 1]
    set bd(3,1) [lindex $dataline 2]
    set bd(4,1) [lindex $dataline 3]
    set bd(5,1) [lindex $dataline 4]

    set dataline   [gets $file]
    set bd(1,2) [lindex $dataline 0]
    set bd(2,2) [lindex $dataline 1]
    set bd(3,2) [lindex $dataline 2]
    set bd(4,2) [lindex $dataline 3]
    set bd(5,2) [lindex $dataline 4]

    # Read 11. Ramification lengths

    set dataline  [gets $file]
    set dataline  [gets $file]
    set dataline  [gets $file]

    set dataline     [gets $file]
    set raml(3,1) [lindex $dataline 0]
    set raml(3,3) [lindex $dataline 1]

    set dataline     [gets $file]
    set raml(4,1) [lindex $dataline 0]
    set raml(4,3) [lindex $dataline 1]
    set raml(4,4) [lindex $dataline 2]

    set dataline     [gets $file]
    set raml(5,1) [lindex $dataline 0]
    set raml(5,3) [lindex $dataline 1]

    set dataline     [gets $file]
    set raml(6,1) [lindex $dataline 0]
    set raml(6,3) [lindex $dataline 1]
    set raml(6,4) [lindex $dataline 2]

    # Read 12. H V and VH ribs

    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]

    set nhvr  [gets $file]

    set dataline [gets $file]
    set xrsep [lindex $dataline 0]
    set yrsep [lindex $dataline 1]

    set i 1
    while {$i <= $nhvr} {
        set dataline [gets $file]
        foreach j {0 1 2 3 4 5 6 7 8 9} {
            set hvr($i,[expr $j+1]) [lindex $dataline $j]
		}
		# If case 6, read 12 numbers
		if { $hvr($i,2) == 6 } {
			foreach j {0 1 2 3 4 5 6 7 8 9 10 11} {
				set hvr($i,[expr $j+1]) [lindex $dataline $j]
			}
		}
		incr i 
    }

    # Read 15. Extrados colors

    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]

    set npce  [gets $file]

    set k 1
    while {$k <= $npce} {
		set dataline [gets $file]
		set npc1e($k) [lindex $dataline 0]
		set npc2e($k) [lindex $dataline 1]

		set l 1
		while {$l <= $npc2e($k)} {
			set dataline [gets $file]
			set npc3e($k,$l) [lindex $dataline 0]
			set xpc1e($k,$l) [lindex $dataline 1]
			set xpc2e($k,$l) [lindex $dataline 2]
			incr l 
			}

		incr k 
    }

    # Read 16. Intrados colors

    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]

    set npci  [gets $file]

    set k 1
    while {$k <= $npci} {

			set dataline [gets $file]
			set npc1i($k) [lindex $dataline 0]
			set npc2i($k) [lindex $dataline 1]

			set l 1
			while {$l <= $npc2i($k)} {

			set dataline [gets $file]
			set npc3i($k,$l) [lindex $dataline 0]
			set xpc1i($k,$l) [lindex $dataline 1]
			set xpc2i($k,$l) [lindex $dataline 2]

			incr l 
		}

		incr k 
    }

    # Read 17. Aditional rib points

    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]

    set narp [gets $file]

    set i 1
    while {$i <= $narp} {
		set dataline [gets $file]
		set xarp($i) [lindex $dataline 0]
		set yarp($i) [lindex $dataline 1]
		incr i 
	}

    # Read 18. Elastic lines corrections

    set dataline [gets $file]
    set dataline [gets $file]
    set dataline [gets $file]

    set csusl [gets $file]

    set dataline [gets $file]
    set cdis(2,1) [lindex $dataline 0]
    set cdis(2,2) [lindex $dataline 1]

    set dataline [gets $file]
    set cdis(3,1) [lindex $dataline 0]
    set cdis(3,2) [lindex $dataline 1]
    set cdis(3,3) [lindex $dataline 2]

    set dataline [gets $file]
    set cdis(4,1) [lindex $dataline 0]
    set cdis(4,2) [lindex $dataline 1]
    set cdis(4,3) [lindex $dataline 2]
    set cdis(4,4) [lindex $dataline 3]

    set dataline [gets $file]
    set cdis(5,1) [lindex $dataline 0]
    set cdis(5,2) [lindex $dataline 1]
    set cdis(5,3) [lindex $dataline 2]
    set cdis(5,4) [lindex $dataline 3]
    set cdis(5,5) [lindex $dataline 4]

    #----------------------------------------------------------------------
    close $file
}





