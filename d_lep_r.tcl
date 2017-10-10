#----------------------------------------------------------------------
#  proc myApp_lep_r
#
#  Read all data from leparagliding.txt
#----------------------------------------------------------------------
proc myApp_lep_r { } {

    source "lep_GlobalWingVars.tcl"

    set file [open "lep/leparagliding.txt" r+]

    #----------------------------------------------------------------------
    #   Note: read structure and variables names exactly like in the
    #   leparagliding.f fortran file
    #----------------------------------------------------------------------

    # Read 1, Geometry
    set i 1
        while {$i <= 9} {
        set DataLine [gets $file]
        incr i
    }
    # BrandName
    set bname  [gets $file]
    set DataLine  [gets $file]
    # WingName
    set wname  [gets $file]
    set DataLine  [gets $file]
    # DrawScale
    set xkf    [gets $file]
    set DataLine  [gets $file]
    # WingScale
    set xwf    [gets $file]
    set DataLine  [gets $file]
    # NumCells
    set ncells [expr [gets $file]]
    set DataLine  [gets $file]
    # NumRibsTot
    set nribst [expr [gets $file]]
    set DataLine  [gets $file]

    # washin = negative Flügelschränkung
    # WashinAlphaLine
    set AlphaMaxParLine [gets $file]

    # Extract AlphaMaxParLine line
    # AlphaMax
    set alpham [lindex $AlphaMaxParLine 0]

    # WashinMode
    set kbbb   [lindex $AlphaMaxParLine 1]
    if { $kbbb == 2 } {
        # AlphaCenter
        set alphac [lindex $AlphaMaxParLine 2]
    }
    if { $kbbb == 1 } {
        set alphac 0.0
    }

    set DataLine [gets $file]

    set ParaTypeLine  [gets $file]

    # Extract ParaTypeLine line
    # ParaType
    set atp  [lindex $ParaTypeLine 0]

    # RotLeTriang - Rotate Leading Edge triangle
    set kaaa [lindex $ParaTypeLine 1]

    set DataLine [gets $file]
    set DataLine [gets $file]

    # NumRibsHalf
    set nribss [expr ceil($nribst/2)]
    # Erase ".0" at the end of string
    set l [string length $nribss]
    # NumberRibs
    set nribss [string range $nribss 0 [expr $l-3]]

    # Read matrix of geometry
    set i 1
    while {$i <= $nribss} {
        # RibGeomLine
        set ribg($i) [gets $file]
        foreach j {0 1 2 3 4 5 6 7 8} {
          # RibGeom
          set RibGeom($i,$j) [lindex $ribg($i) $j]
        }

        set rib($i,1) $RibGeom($i,0)
        set rib($i,2) $RibGeom($i,1)
        set rib($i,3) $RibGeom($i,2)
        set rib($i,4) $RibGeom($i,3)
        set rib($i,6) $RibGeom($i,4)
        set rib($i,7) $RibGeom($i,5)
        set rib($i,9) $RibGeom($i,6)
        set rib($i,10) $RibGeom($i,7)
        set rib($i,51) $RibGeom($i,8)

        incr i
    }

    # Set washin parameteres if kbbb=0 => manual washin
    if { $kbbb == 0 } {
        set alphac $RibGeom(1,8)
        set alpham $RibGeom($nribss,8)
    }

    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]

    # Read airfoil data
    set i 1
    while {$i <= $nribss} {
        set DataLine [gets $file]
        foreach j {0 1 2 3 4 5 6 7} {
            puts [lindex $DataLine $j]
            set RibGeom($i,$j) [lindex $DataLine $j]
        }


        set rib($i,1)  $RibGeom($i,0)
        # airfoilName
        set nomair($i) $RibGeom($i,1)
        set rib($i,11) $RibGeom($i,2)
        set rib($i,12) $RibGeom($i,3)
        set rib($i,14) $RibGeom($i,4)
        set rib($i,50) $RibGeom($i,5)
        set rib($i,55) $RibGeom($i,6)
        set rib($i,56) $RibGeom($i,7)

        incr i
    }

    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]

    # Read anchors A,B,C,D,E,F location
    set i 1
    while {$i <= $nribss} {
        set DataLine [gets $file]
        foreach j {0 1 2 3 4 5 6 7} {
            set RibGeom($i,$j) [lindex $DataLine $j]
        }

        set rib($i,1)  $RibGeom($i,0)
        set rib($i,15) $RibGeom($i,1)
        set rib($i,16) $RibGeom($i,2)
        set rib($i,17) $RibGeom($i,3)
        set rib($i,18) $RibGeom($i,4)
        set rib($i,19) $RibGeom($i,5)
        set rib($i,20) $RibGeom($i,6)
        set rib($i,21) $RibGeom($i,7)

        incr i
    }

    #   Read airfoil holes
    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]
    # AirfConfigNum - Number of Airfoil configurations
    set ndis  [gets $file]

    set ConfigIt 1
    while {$ConfigIt <= $ndis} {
        # Initial rib for first lightening configuration
        # holeRibNum1
        set nrib1($ConfigIt) [gets $file]
        # Final rib for first lightening configuration
        # holeRibNum2
        set nrib2($ConfigIt) [gets $file]
        # Number of holes for the first lightening configuration
        # numHoles
        set nhols($ConfigIt) [gets $file]

        set HoleIt 1
        while {$HoleIt <= $nhols($ConfigIt)} {
            set DataLine [gets $file]
            foreach j {0 1 2 3 4 5 6 7} {
                set HoleGeom($HoleIt,$j) [lindex $DataLine $j]
            }

            set hol($nrib1($ConfigIt),$HoleIt,9) $HoleGeom($HoleIt,0)
            set hol($nrib1($ConfigIt),$HoleIt,2) $HoleGeom($HoleIt,1)
            set hol($nrib1($ConfigIt),$HoleIt,3) $HoleGeom($HoleIt,2)
            set hol($nrib1($ConfigIt),$HoleIt,4) $HoleGeom($HoleIt,3)
            set hol($nrib1($ConfigIt),$HoleIt,5) $HoleGeom($HoleIt,4)
            set hol($nrib1($ConfigIt),$HoleIt,6) $HoleGeom($HoleIt,5)
            set hol($nrib1($ConfigIt),$HoleIt,7) $HoleGeom($HoleIt,6)
            set hol($nrib1($ConfigIt),$HoleIt,8) $HoleGeom($HoleIt,7)

            incr HoleIt
        }

        incr ConfigIt
    }

    # Read skin tension
    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]

    set i 1
    while {$i <= 6} {
        set DataLine [gets $file]
        foreach j {0 1 2 3} {
            # skinTension
            set skin($i,[expr $j+1]) [lindex $DataLine $j]
        }
        incr i
    }

    # strainMiniRibs
    set htens [gets $file]
    set DataLine [gets $file]
    # numStrainPoints
    set ndif  [lindex $DataLine 0]
    # strainCoef
    set xndif [lindex $DataLine 1]

    # Read sewing allowances
    set DataLine  [gets $file]
    set DataLine  [gets $file]
    set DataLine  [gets $file]

    set DataLine  [gets $file]
    # seamUp
    set xupp   [lindex $DataLine 0]
    # seamUpLe
    set xupple [lindex $DataLine 1]
    # seamUpTe
    set xuppte [lindex $DataLine 2]

    set DataLine  [gets $file]
    # seamLo
    set xlow   [lindex $DataLine 0]
    # seamLoLe
    set xlowle [lindex $DataLine 1]
    # seamloTe
    set xlowte [lindex $DataLine 2]

    # seamRib
    set xrib   [gets $file]
    # seamVRib
    set xvrib  [gets $file]

    # Read marks
    set DataLine  [gets $file]
    set DataLine  [gets $file]
    set DataLine  [gets $file]

    set DataLine  [gets $file]
    # markSpace
    set xmark  [lindex $DataLine 0]
    # markRad
    set xcir   [lindex $DataLine 1]
    # markDisp
    set xdes   [lindex $DataLine 2]

    # Read 8. Global angle of attack

    set DataLine  [gets $file]
    set DataLine  [gets $file]
    set DataLine  [gets $file]

    set DataLine   [gets $file]
    # finesse
    set finesse [gets $file]
    set DataLine  [gets $file]
    # posCOP
    set cpress [gets $file]
    set DataLine  [gets $file]
    # calage
    set calage [gets $file]
    set DataLine  [gets $file]
    # riserLength
    set clengr [gets $file]
    set DataLine  [gets $file]
    # lineLength
    set clengl [gets $file]
    set DataLine  [gets $file]
    # distTowP
    set clengk [gets $file]

    # Read 9. Suspension lines description

    set DataLine  [gets $file]
    set DataLine  [gets $file]
    set DataLine  [gets $file]

    # Line Control Parameter
    # lineMode
    set zcontrol [gets $file]
    # numLinePlan
    set slp      [gets $file]

    set LinePlanIt 1
    while {$LinePlanIt <= $slp} {

        # numLinePath
        set cam($LinePlanIt) [gets $file]

        # Read Line Paths
        set i 1
        while {$i <= $cam($LinePlanIt)} {
            set DataLine [gets $file]
            # LinePath
            set mc($LinePlanIt,$i,1)   [lindex $DataLine 0]
            set mc($LinePlanIt,$i,2)   [lindex $DataLine 1]
            set mc($LinePlanIt,$i,3)   [lindex $DataLine 2]
            set mc($LinePlanIt,$i,4)   [lindex $DataLine 3]
            set mc($LinePlanIt,$i,5)   [lindex $DataLine 4]
            set mc($LinePlanIt,$i,6)   [lindex $DataLine 5]
            set mc($LinePlanIt,$i,7)   [lindex $DataLine 6]
            set mc($LinePlanIt,$i,8)   [lindex $DataLine 7]
            set mc($LinePlanIt,$i,9)   [lindex $DataLine 8]
            set mc($LinePlanIt,$i,14)  [lindex $DataLine 9]
            set mc($LinePlanIt,$i,15)  [lindex $DataLine 10]
            incr i
        }

        incr LinePlanIt
    }

    # Read Brakes

    set DataLine  [gets $file]
    set DataLine  [gets $file]
    set DataLine  [gets $file]

    set LinePlanIt [expr $slp+1]

    # brakeLength
    set clengb   [gets $file]
    set cam($LinePlanIt) [gets $file]

    # Read 4 levels
    set i 1
    while {$i <= $cam($LinePlanIt)} {
        set DataLine  [gets $file]
        set mc($LinePlanIt,$i,1)   [lindex $DataLine 0]
        set mc($LinePlanIt,$i,2)   [lindex $DataLine 1]
        set mc($LinePlanIt,$i,3)   [lindex $DataLine 2]
        set mc($LinePlanIt,$i,4)   [lindex $DataLine 3]
        set mc($LinePlanIt,$i,5)   [lindex $DataLine 4]
        set mc($LinePlanIt,$i,6)   [lindex $DataLine 5]
        set mc($LinePlanIt,$i,7)   [lindex $DataLine 6]
        set mc($LinePlanIt,$i,8)   [lindex $DataLine 7]
        set mc($LinePlanIt,$i,9)   [lindex $DataLine 8]
        set mc($LinePlanIt,$i,14)  [lindex $DataLine 9]
        set brake($i,3)    [lindex $DataLine 10]
        incr i
    }

    set DataLine   [gets $file]

    set DataLine   [gets $file]
    # brakeDistr
    set bd(1,1) [lindex $DataLine 0]
    set bd(2,1) [lindex $DataLine 1]
    set bd(3,1) [lindex $DataLine 2]
    set bd(4,1) [lindex $DataLine 3]
    set bd(5,1) [lindex $DataLine 4]

    set DataLine   [gets $file]
    set bd(1,2) [lindex $DataLine 0]
    set bd(2,2) [lindex $DataLine 1]
    set bd(3,2) [lindex $DataLine 2]
    set bd(4,2) [lindex $DataLine 3]
    set bd(5,2) [lindex $DataLine 4]

    # Read 11. Ramification lengths

    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]

    set DataLine [gets $file]
    # ramLength
    set raml(3,1) [lindex $DataLine 0]
    set raml(3,3) [lindex $DataLine 1]

    set DataLine     [gets $file]
    set raml(4,1) [lindex $DataLine 0]
    set raml(4,3) [lindex $DataLine 1]
    set raml(4,4) [lindex $DataLine 2]

    set DataLine     [gets $file]
    set raml(5,1) [lindex $DataLine 0]
    set raml(5,3) [lindex $DataLine 1]

    set DataLine     [gets $file]
    set raml(6,1) [lindex $DataLine 0]
    set raml(6,3) [lindex $DataLine 1]
    set raml(6,4) [lindex $DataLine 2]

    # Read 12. H V and VH ribs

    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]

    # numMiniRibs
    set nhvr  [gets $file]

    set DataLine [gets $file]
    # miniRibXSep
    set xrsep [lindex $DataLine 0]
    # miniRibYSep
    set yrsep [lindex $DataLine 1]

    set i 1
    while {$i <= $nhvr} {
        set DataLine [gets $file]
        foreach j {0 1 2 3 4 5 6 7 8 9} {
            # miniRib
            set hvr($i,[expr $j+1]) [lindex $DataLine $j]
		}

        # If case 6 (V-rib type 6 general diagonal), read 12 numbers
		if { $hvr($i,2) == 6 } {
			foreach j {0 1 2 3 4 5 6 7 8 9 10 11} {
				set hvr($i,[expr $j+1]) [lindex $DataLine $j]
			}
		}
		incr i
    }

    # Read 15. Extrados colors

    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]

    # numTeCol
    set npce  [gets $file]

    set TeColIt 1

    while {$TeColIt <= $npce} {
		set DataLine [gets $file]
        # teColRibNum
        set npc1e($TeColIt) [lindex $DataLine 0]
        # numTeColMark
		set npc2e($TeColIt) [lindex $DataLine 1]

		set i 1
		while {$i <= $npc2e($TeColIt)} {
			set DataLine [gets $file]
            # teColMarkNum
            set npc3e($TeColIt,$i) [lindex $DataLine 0]
            # teColMarkYDist
			set xpc1e($TeColIt,$i) [lindex $DataLine 1]
            # teColMarkXDist
            set xpc2e($TeColIt,$i) [lindex $DataLine 2]
			incr i
		}
		incr TeColIt
    }

    # Read 16. Intrados colors

    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]

    # numLeCol
    set npci  [gets $file]

    set LeColIt 1
    while {$LeColIt <= $npci} {
			set DataLine [gets $file]
            # leColRibNum
			set npc1i($LeColIt) [lindex $DataLine 0]
            # numleColMark
			set npc2i($LeColIt) [lindex $DataLine 1]

			set i 1
			while {$i <= $npc2i($LeColIt)} {
    			set DataLine [gets $file]
                # leColMarkNum
                set npc3i($LeColIt,$i) [lindex $DataLine 0]
                # leColMarkYDist
                set xpc1i($LeColIt,$i) [lindex $DataLine 1]
                # leColMarkXDist
                set xpc2i($LeColIt,$i) [lindex $DataLine 2]
    			incr i
		}
		incr LeColIt
    }

    # Read 17. Aditional rib points

    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]

    # numAddRipPo
    set narp [gets $file]

    set i 1
    while {$i <= $narp} {
		set DataLine [gets $file]
        # addRipPoX
        set xarp($i) [lindex $DataLine 0]
        # addRipPoY
		set yarp($i) [lindex $DataLine 1]
		incr i
	}

    # Read 18. Elastic lines corrections

    set DataLine [gets $file]
    set DataLine [gets $file]
    set DataLine [gets $file]

    # loadTot
    set csusl [gets $file]

    # loadDistr
    set DataLine [gets $file]
    set cdis(2,1) [lindex $DataLine 0]
    set cdis(2,2) [lindex $DataLine 1]

    set DataLine [gets $file]
    set cdis(3,1) [lindex $DataLine 0]
    set cdis(3,2) [lindex $DataLine 1]
    set cdis(3,3) [lindex $DataLine 2]

    set DataLine [gets $file]
    set cdis(4,1) [lindex $DataLine 0]
    set cdis(4,2) [lindex $DataLine 1]
    set cdis(4,3) [lindex $DataLine 2]
    set cdis(4,4) [lindex $DataLine 3]

    set DataLine [gets $file]
    set cdis(5,1) [lindex $DataLine 0]
    set cdis(5,2) [lindex $DataLine 1]
    set cdis(5,3) [lindex $DataLine 2]
    set cdis(5,4) [lindex $DataLine 3]
    set cdis(5,5) [lindex $DataLine 4]

    # loadDeform
    # code to read this is missing

    #----------------------------------------------------------------------
    close $file
}
