#---------------------------------------------------------------------
#
#  Writes the data file for the wing file
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

global Separator
set Separator "*******************************************************************"

#----------------------------------------------------------------------
#  writeWingDataFile
#  Writes the Wing data file
#
# IN:   FilePathName    Full path and name of file
# OUT:  -1 : file not writeable
#        0 : all cool file read, data should be available
#----------------------------------------------------------------------
proc writeWingDataFile {FilePathName} {
    set ReturnValue -1

    if {[catch {set File [open $FilePathName w]}] == 0} {
        # puts "All cool file is open"
    } else {
        # puts "Could not open file."
        return -1
    }

    # 0. File header
    lassign [WriteFileHeaderV2_6 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #---------
    # 1. Geometry
    lassign [WriteGeometrySectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------
    # 2. Airfoils
    lassign [WriteAirfoilSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------
    # 3. Anchor points
    lassign [WriteAnchorsSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------
    # 4. Airfoil holes
    lassign [WriteAirfoilHoSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-------------
    # 5. Skin tension
    #--------------
    # Anchor points
    lassign [WriteSkinTensSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #------------------
    # 6. Sewing allowances
    lassign [WriteSewingAllowancesV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #------
    # 7. Marks
    lassign [WriteMarksSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-----------------------
    # 8. Global angle of attack
    lassign [WriteGlobalAoASectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-----------------
    # 9. Suspension lines
    lassign [WriteSuspLinesSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-------
    # 10. Brakes
    lassign [WriteBrakesSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #---------------------
    # 11. Ramification lengths
    lassign [WriteRamLengthSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }


    #----------------
    # 12. H V and VH ribs => miniRib
    lassign [WriteHV-VH-RibSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #----------------------
    # 15. Extrados Trailing edge  colors?
    lassign [WriteTeColSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------
    # 16. Intrados Leading edge colors?
    lassign [WriteLeColSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #----------------------
    # 17. Additional rib points
    lassign [WriteAddRibPoSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 18. Elastig lines corrections
    lassign [WriteElLinesCorrSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 19. DXF layer names
    lassign [WriteDXFLayNaSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 20. Marks types
    lassign [WriteMarksTySectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 21. Joncs definitions
    lassign [WriteJoncsDefSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 22. Nose mylars
    lassign [WriteNoseMySectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 23. Tab reinforcements
    lassign [WriteTabReinfSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 24. General 2D DXF options
    lassign [WriteGe2DopSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 25. General 3D DXF options
    lassign [WriteGe3DopSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 26. Glue vents
    lassign [WriteGlueVenSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 27. Special wingtip
    lassign [WriteSpecWtSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 28. Calage variation
    lassign [WriteCalagVarSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 29. 3D shaping
    lassign [WriteP3DShapingSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 30. Airfoil thickness
    lassign [WriteAirThickSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # 31. New skin tension
    lassign [WriteNewSkinSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    flush $File
    close $File

    set ReturnValue 0
    return $ReturnValue
}




#----------------------------------------------------------------------
#  WriteFileHeader
#  Writes the initial file header
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteFileHeaderV2_6 {File} {
    source "lepFileConstants.tcl"
    global Separator

    puts $File $Separator
    puts $File "* LABORATORI D'ENVOL PARAGLIDING DESIGN"
    puts $File "* lep input data file        v3.14"
    puts $File $Separator
    puts $File "*"
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteGeometrySectV2_52
#  Writes the Geometry section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteGeometrySectV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_GeometrySect_lFC_Lbl"
    puts $File $Separator

    puts $File "* Brand name"
    puts $File "\"$brandName\""

    puts $File "* Wing name"
    puts $File "\"$wingName\""

    puts $File "* Drawing scale"
    puts $File "$drawScale"

    puts $File "* Wing scale"
    puts $File "$wingScale"

    puts $File "* Number of cells"
    puts $File "\t$numCells"

    puts $File "* Number of ribs"
    puts $File "\t$numRibsTot"

    puts $File "* Alpha wingtip, parameter, (alpha center)"
    puts $File "\t$alphaMax     $washinMode     $alphaCenter"

    puts $File "* Paraglider type and parameter"
    puts $File "\"$paraType\" $rotLeTriang"

    puts $File "* Rib geometric parameters"
    puts $File "* Rib    x-rib       y-LE       y-TE         xp         z     beta      RP        Washin"
    # Write matrix of geometry
    set i 1
    while {$i <= $numRibsHalf} {

        puts -nonewline $File "$ribConfig($i,1)"
        puts -nonewline $File "     $ribConfig($i,2)"
        puts -nonewline $File "     $ribConfig($i,3)"
        puts -nonewline $File "     $ribConfig($i,4)"
        puts -nonewline $File "     $ribConfig($i,6)"
        puts -nonewline $File "     $ribConfig($i,7)"
        puts -nonewline $File "     $ribConfig($i,9)"
        puts -nonewline $File "     $ribConfig($i,10)"
        puts            $File "     $ribConfig($i,51)"
        incr i
    }


    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteAirfoilSectV2_52
#  Writes the Airfoils section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteAirfoilSectV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_AirfoilSect_lFC_Lbl"
    puts $File $Separator
    puts $File "* Airfoil name. intake in. intake out. open. disp   rweight"

    set i 1
    while {$i <= $numRibsHalf} {

        puts -nonewline $File "$ribConfig($i,1)"
        puts -nonewline $File "     $airfoilName($i)"
        puts -nonewline $File "     $ribConfig($i,11)"
        puts -nonewline $File "     $ribConfig($i,12)"
        puts -nonewline $File "     $ribConfig($i,14)"
        puts -nonewline $File "     $ribConfig($i,50)"
        puts -nonewline $File "     $ribConfig($i,55)"
        puts            $File "     $ribConfig($i,56)"

        incr i
    }


    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteAnchorsSectV2_52
#  Writes the Anchors section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteAnchorsSectV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_AnchorPoSect_lFC_Lbl"
    puts $File $Separator
    puts $File "* Airf	Anch	A	B	C	D	E	F"

    set i 1
    while {$i <= $numRibsHalf} {

        puts -nonewline $File "$ribConfig($i,1)"
        puts -nonewline $File "\t$ribConfig($i,15)"
        puts -nonewline $File "\t$ribConfig($i,16)"
        puts -nonewline $File "\t$ribConfig($i,17)"
        puts -nonewline $File "\t$ribConfig($i,18)"
        puts -nonewline $File "\t$ribConfig($i,19)"
        puts -nonewline $File "\t$ribConfig($i,20)"
        puts            $File "\t$ribConfig($i,21)"

        incr i
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteAirfoilHoSectV2_52
#  Writes the Airfoul holes section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteAirfoilHoSectV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_AirfoilHoSect_lFC_Lbl"
    puts $File $Separator

    # AirfConfigNum - Number of Airfoil configurations
    puts $File $airfConfigNum

    for { set ConfigIt 1 } { $ConfigIt <= $airfConfigNum } {incr ConfigIt } {
        # Initial rib for first lightening configuration
        puts $File $holeRibNum1($ConfigIt)

        # Final rib for first lightening configuration
        puts $File $holeRibNum2($ConfigIt)

        # Number of holes for the first lightening configuration
        puts $File $numHoles($ConfigIt)

        for { set HoleIt 1 } { $HoleIt <= $numHoles($ConfigIt) } { incr HoleIt } {
            puts -nonewline $File "$holeConfig($holeRibNum1($ConfigIt),$HoleIt,9)"
            puts -nonewline $File "\t$holeConfig($holeRibNum1($ConfigIt),$HoleIt,2)"
            puts -nonewline $File "\t$holeConfig($holeRibNum1($ConfigIt),$HoleIt,3)"
            puts -nonewline $File "\t$holeConfig($holeRibNum1($ConfigIt),$HoleIt,4)"
            puts -nonewline $File "\t$holeConfig($holeRibNum1($ConfigIt),$HoleIt,5)"
            puts -nonewline $File "\t$holeConfig($holeRibNum1($ConfigIt),$HoleIt,6)"
            puts -nonewline $File "\t$holeConfig($holeRibNum1($ConfigIt),$HoleIt,7)"
            puts            $File "\t$holeConfig($holeRibNum1($ConfigIt),$HoleIt,8)"
        }


    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteSkinTensSectV2_52
#  Writes the Skin Tension section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteSkinTensSectV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_SkinTensSect_lFC_Lbl"
    puts $File $Separator
    puts $File "Upper \tlower skin"

    for {set i 1} {$i <= 6} {incr i} {

        puts -nonewline $File $skinTens($i,1)
        puts -nonewline $File "\t$skinTens($i,2)"
        puts -nonewline $File "\t$skinTens($i,3)"
        puts            $File "\t$skinTens($i,4)"
    }

    # strainMiniRibs
    puts $File $strainMiniRibs

    # numStrainPoints, # strainCoef
    puts $File "$numStrainPoints    $strainCoef"

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  WriteSewingAllowancesV2_52
#  Writes the Sewing Allowances section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteSewingAllowancesV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_SewingSect_lFC_Lbl"
    puts $File $Separator

    puts $File "$seamUp\t$seamUpLe\t$seamUpTe\tupper panels (mm)"

    puts $File "$seamLo\t$seamLoLe\t$seamLoTe\tlower panels (mm)"

    puts $File "$seamRib\tribs (mm)"

    puts $File "$seamVRib\tvribs (mm)"

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteMarksSectV2_52
#  Writes the Marks section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteMarksSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_MarksSect_lFC_Lbl"
    puts $File $Separator

    puts $File "$markSpace\t$markRad\t$markDisp"

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteGlobalAoASectV2_52
#  Writes the global AoA estimation section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteGlobalAoASectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_GlobalAoASect_lFC_Lbl"
    puts $File $Separator

    puts $File "* Finesse GR"
    puts $File "\t$finesse"

    puts $File "* Center of pressure % of chord"
    puts $File "\t$posCop"

    puts $File "* Calage %"
    puts $File "\t$calage"

    puts $File "* Risers lenght cm"
    puts $File "\t$riserLength"

    puts $File "* Line lenght cm"
    puts $File "\t$lineLength"

    puts $File "* Karabiners cm"
    puts $File "\t$distTowP"

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteSuspLinesSectV2_52
#  Writes the Suspension Lines section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteSuspLinesSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_SuspLinesSect_lFC_Lbl"
    puts $File $Separator

    # Line Control Parameter
    # lineMode
    puts $File $lineMode

    # numLinePlan
    puts $File $numLinePlan

    set LinePlanIt 1
    for {set LinePlanIt 1} {$LinePlanIt <= $numLinePlan} {incr LinePlanIt} {

        # numLinePath
        puts $File $numLinePath($LinePlanIt)

        # Line Paths
        for {set i 1} {$i <= $numLinePath($LinePlanIt)} {incr i} {

            # LinePath
            puts -nonewline $File "$linePath($LinePlanIt,$i,1)\t"
            puts -nonewline $File "$linePath($LinePlanIt,$i,2)\t"
            puts -nonewline $File "$linePath($LinePlanIt,$i,3)\t"
            puts -nonewline $File "$linePath($LinePlanIt,$i,4)\t"
            puts -nonewline $File "$linePath($LinePlanIt,$i,5)\t"
            puts -nonewline $File "$linePath($LinePlanIt,$i,6)\t"
            puts -nonewline $File "$linePath($LinePlanIt,$i,7)\t"
            puts -nonewline $File "$linePath($LinePlanIt,$i,8)\t"
            puts -nonewline $File "$linePath($LinePlanIt,$i,9)\t"
            puts -nonewline $File "$linePath($LinePlanIt,$i,14)\t"
            puts            $File "$linePath($LinePlanIt,$i,15)"
        }
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteBrakesSectV2_52
#  Writes the brake lines section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteBrakesSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_BrakesSect_lFC_Lbl"
    puts $File $Separator

    # brakeLength
    puts $File $brakeLength
    puts $File $numBrakeLinePath

    # write the detailed path info
    for {set i 1} {$i <= $numBrakeLinePath} {incr i} {
        foreach j {1 2 3 4 5 6 7 8 9 14} {
            puts -nonewline $File "$brakeLinePath($i,$j)\t"
        }
        puts            $File "$brakeLinePath($i,15)"
    }

    puts $File "* Brake distribution"

    # line 1
    for {set i 1} {$i <= 4} {incr i} {
            puts -nonewline $File "$brakeDistr(1,$i)\t"
    }
    puts $File "$brakeDistr(1,5)"

    # line 1
    for {set i 1} {$i <= 4} {incr i} {
            puts -nonewline $File "$brakeDistr(2,$i)\t"
    }
    puts $File "$brakeDistr(2,5)"

    return [list 0 $File]
}



#----------------------------------------------------------------------
#  WriteRamLengthSectV2_52
#  Writes the ramification length section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteRamLengthSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_RamLengthSect_lFC_Lbl"
    puts $File $Separator


    puts -nonewline $File "$ramLength(3,1)"
    puts            $File "\t$ramLength(3,3)"

    puts -nonewline $File "$ramLength(4,1)"
    puts -nonewline $File "\t$ramLength(4,3)"
    puts            $File "\t$ramLength(4,4)"

    puts -nonewline $File "$ramLength(5,1)"
    puts            $File "\t$ramLength(5,3)"

    puts -nonewline $File "$ramLength(6,1)"
    puts -nonewline $File "\t$ramLength(6,3)"
    puts            $File "\t$ramLength(6,4)"

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  WriteHV-VH-RibSectV2_52
#  Writes the Mini rib section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteHV-VH-RibSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_MiniRibSect_lFC_Lbl"
    puts $File $Separator

    # numMiniRibs
    puts $File $numMiniRibs

    # miniRibXSep miniRibYSep
    puts $File "$miniRibXSep\t$miniRibYSep"

    for {set i 1} {$i <= $numMiniRibs} {incr i} {

        # first value
        puts -nonewline $File $miniRib($i,1)

        # rest of short parametersets
        for {set j 2} {$j <= 10} {incr j} {
            puts -nonewline $File "\t$miniRib($i,$j)"
        }

        # special type 6 handling
        if {$miniRib($i,2) == 6} {
            puts -nonewline $File "\t$miniRib($i,11)"
            puts -nonewline $File "\t$miniRib($i,12)"
        }

        # terminate the line
        puts $File ""
    }

    return [list 0 $File]
}



#----------------------------------------------------------------------
#  WriteTeColSectV2_52
#  Writes the Trailing Edge color section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteTeColSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_TeColSect_lFC_Lbl"
    puts $File $Separator

    # numTeCol
    puts $File $numTeCol

    for {set TeColIt 1} {$TeColIt <= $numTeCol} {incr TeColIt} {

        puts -nonewline $File "$teColRibNum($TeColIt)"
        puts            $File "\t$numTeColMarks($TeColIt)"

        for {set i 1} {$i <= $numTeColMarks($TeColIt)} {incr i} {

            puts -nonewline $File "$teColMarkNum($TeColIt,$i)"
            puts -nonewline $File "\t$teColMarkYDist($TeColIt,$i)"
            puts            $File "\t$teColMarkXDist($TeColIt,$i)"
        }
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteLeColSectV2_52
#  Writes the Leading Edge color section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteLeColSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_LeColSect_lFC_Lbl"
    puts $File $Separator

    # numTeCol
    puts $File $numLeCol

    for {set LeColIt 1} {$LeColIt <= $numLeCol} {incr LeColIt} {

        puts -nonewline $File "$leColRibNum($LeColIt)"
        puts            $File "\t$numLeColMarks($LeColIt)"

        for {set i 1} {$i <= $numLeColMarks($LeColIt)} {incr i} {

            puts -nonewline $File "$leColMarkNum($LeColIt,$i)"
            puts -nonewline $File "\t$leColMarkYDist($LeColIt,$i)"
            puts            $File "\t$leColMarkXDist($LeColIt,$i)"
        }
    }

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  WriteAddRibPoSectV2_52
#  Writes the additional rib points section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteAddRibPoSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_AddRibPoSect_lFC_Lbl"
    puts $File $Separator

    # numAddRipPo
    puts $File $numAddRipPo

    set i 1
    while {$i <= $numAddRipPo} {

        # addRipPoX
        puts -nonewline $File $addRipPoX($i)
        # addRipPoY
        puts            $File "\t$addRipPoY($i)"
        incr i
    }

    return [list 0 $File]
}



#----------------------------------------------------------------------
#  WriteElLinesCorrSectV2_52
#  Writes the elastic lines correction section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteElLinesCorrSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_ElLinesCorrSect_lFC_Lbl"
    puts $File $Separator

    puts $File $loadTot

    puts $File "$loadDistr(1,1)\t$loadDistr(1,2)"
    puts $File "$loadDistr(2,1)\t$loadDistr(2,2)\t$loadDistr(2,3)"
    puts $File "$loadDistr(3,1)\t$loadDistr(3,2)\t$loadDistr(3,3)\t$loadDistr(3,4)"
    puts $File "$loadDistr(4,1)\t$loadDistr(4,2)\t$loadDistr(4,3)\t$loadDistr(4,4)\t$loadDistr(4,5)"

    for {set i 1} {$i <=5} {incr i} {
        puts $File "$loadDeform($i,1)\t$loadDeform($i,2)\t$loadDeform($i,3)\t$loadDeform($i,4)"
    }

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  WriteDXFLayNaSectV2_52
#  Writes DXF layer names section in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteDXFLayNaSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_DXFLayNaSect_lFC_Lbl"
    puts $File $Separator

    # numAddRipPo
    puts $File $numDXFLayNa

    set i 1
    while {$i <= $numDXFLayNa} {

        # dxfLayNaX
        puts -nonewline $File $dxfLayNaX($i)
        # dxfLayNaY
        puts            $File "\t$dxfLayNaY($i)"
        incr i
    }

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  WriteMarksTySectV2_52
#  Writes Marks types section in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteMarksTySectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_MarksTySect_lFC_Lbl"
    puts $File $Separator

    # numAddRipPo
    puts $File $numMarksTy

    set i 1
    while {$i <= $numMarksTy} {

        # marksType0 to marksType6
        puts -nonewline $File $marksType0($i)
        puts -nonewline $File "\t$marksType1($i)"
        puts -nonewline $File "\t$marksType2($i)"
        puts -nonewline $File "\t$marksType3($i)"
        puts -nonewline $File "\t$marksType4($i)"
        puts -nonewline $File "\t$marksType5($i)"
        puts            $File "\t$marksType6($i)"
        incr i
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteAirThickSectV2_52
#  Writes joncs defintions data in section 21 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteJoncsDefSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_JoncsDefSect_lFC_Lbl"
    puts $File $Separator

    # K_section21
    puts $File $k_section21

    # Case scheme 0
    if {$k_section21 == 0 } {
    # do nothing
    }

    # Case scheme 1
    if {$k_section21 == 1 } {

        # Number of groups
        puts $File $numGroupsJD(1)

        # iterate in each group
    	set gr 1
    	while {$gr <= $numGroupsJD(1)} {
        	puts -nonewline $File $numJoncsDef(1,$gr,1)
        	puts -nonewline $File "\t$numJoncsDef(1,$gr,2)"
        	puts            $File "\t$numJoncsDef(1,$gr,3)"
                # Type 1 data
                foreach i {1 2 3} {
        	puts -nonewline $File $lineJoncsDef1(1,$gr,$i,1)
        	puts -nonewline $File "\t$lineJoncsDef1(1,$gr,$i,2)"
        	puts -nonewline $File "\t$lineJoncsDef1(1,$gr,$i,3)"
        	puts            $File "\t$lineJoncsDef1(1,$gr,$i,4)"
                }
              	incr gr
    	}
    }
    # Case scheme 1


    # Case scheme 2
    if {$k_section21 == 2 } {

        # Number of data blocs
        puts $File $numGroupsJDdb

        # Number of data blocs
        puts $File $numGroupsJDdb

        # iterate in each data bloc
    	set db 1
    	while {$db <= $numGroupsJDdb} {

            # Data bloc numbers
            puts -nonewline $File $numDataBlocJD($db,1)
            puts            $File $numDataBlocJD($db,2)

            # Number of groups
            puts $File $numGroupsJD($db)

            # iterate in each group
    	    set gr 1
            while {$gr <= $numGroupsJD($db)} {

            # case type 1
            if { $numDataBlocJD($db,2) == 1 } {

        	puts -nonewline $File $numJoncsDef(1,$gr,1)
        	puts -nonewline $File "\t$numJoncsDef(1,$gr,2)"
        	puts            $File "\t$numJoncsDef(1,$gr,3)"
                # Type 1 data
                foreach i {1 2 3} {
        	puts -nonewline $File $lineJoncsDef1(1,$gr,$i,1)
        	puts -nonewline $File "\t$lineJoncsDef1(1,$gr,$i,2)"
        	puts -nonewline $File "\t$lineJoncsDef1(1,$gr,$i,3)"
        	puts            $File "\t$lineJoncsDef1(1,$gr,$i,4)"
                }
              	incr gr
        	}
                # end case type 1

            # case type 2
            if { $numDataBlocJD($db,2) == 2 } {

                puts -nonewline $File $numJoncsDef($db,$gr,1)
                puts -nonewline $File "\t$numJoncsDef($db,$gr,2)"
        	puts            $File "\t$numJoncsDef($db,$gr,3)"
                # Type 2 data
        	puts -nonewline $File    $lineJoncsDef2($db,$gr,1,1)
        	puts -nonewline $File "\t$lineJoncsDef2($db,$gr,1,2)"
        	puts -nonewline $File "\t$lineJoncsDef2($db,$gr,1,3)"
        	puts -nonewline $File "\t$lineJoncsDef2($db,$gr,1,4)"
        	puts            $File "\t$lineJoncsDef2($db,$gr,1,5)"
                puts -nonewline $File    $lineJoncsDef2($db,$gr,2,1)
        	puts -nonewline $File "\t$lineJoncsDef2($db,$gr,2,2)"
        	puts -nonewline $File "\t$lineJoncsDef2($db,$gr,2,3)"
        	puts            $File "\t$lineJoncsDef2($db,$gr,2,4)"
                # end case type 2
                }

            incr gr
            # end group number
            }
        incr db
        # end data bloc
        }
    }
    # Case scheme 2

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteAirThickSectV2_52
#  Writes nose mylars data in section 22 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteNoseMySectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_NoseMySect_lFC_Lbl"
    puts $File $Separator

    # K_section31
    puts $File $k_section22

    # Case 0
    if {$k_section22 == 0 } {
    # do nothing
    }

    # Case 1
    if {$k_section22 == 1 } {

        # Number of groups
        puts $File $numGroupsMY

        # iterate in each group
    	set i 1
    	while {$i <= $numGroupsMY} {
        	puts -nonewline $File $numNoseMy($i,1)
        	puts -nonewline $File "\t$numNoseMy($i,2)"
        	puts            $File "\t$numNoseMy($i,3)"
        # Nose mylars data
        	puts -nonewline $File $lineNoseMy($i,1)
        	puts -nonewline $File "\t$lineNoseMy($i,2)"
        	puts -nonewline $File "\t$lineNoseMy($i,3)"
        	puts -nonewline $File "\t$lineNoseMy($i,4)"
        	puts -nonewline $File "\t$lineNoseMy($i,5)"
        	puts            $File "\t$lineNoseMy($i,6)"
              	incr i
    	}
    }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteTaReinfSectV2_52
#  Writes tab reinforcements data in section 23 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteTabReinfSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_TabReinfSect_lFC_Lbl"
    puts $File $Separator

    # K_section31
    puts $File $k_section23

    # Case 0
    if {$k_section23 == 0 } {
    # do nothing
    }

    # Case 1
    if {$k_section23 == 1 } {

        # Number of groups
        puts $File $numGroupsTR

        # iterate in each group
    	set i 1
    	while {$i <= $numGroupsTR} {
        	puts -nonewline $File $numTabReinf($i,1)
        	puts -nonewline $File "\t$numTabReinf($i,2)"
        	puts            $File "\t$numTabReinf($i,3)"
        # Nose mylars data
        	puts -nonewline $File $lineTabReinf($i,1)
        	puts -nonewline $File "\t$lineTabReinf($i,2)"
        	puts -nonewline $File "\t$lineTabReinf($i,3)"
        	puts -nonewline $File "\t$lineTabReinf($i,4)"
        	puts            $File "\t$lineTabReinf($i,5)"
              	incr i
    	}

        # schemes
        puts $File "schemes"
        # schemes data
        foreach i {1 2 3 4 5} {
        	puts -nonewline $File $schemesTR($i,1)
        	puts -nonewline $File "\t$schemesTR($i,2)"
        	puts -nonewline $File "\t$schemesTR($i,3)"
        	puts -nonewline $File "\t$schemesTR($i,4)"
        	puts -nonewline $File "\t$schemesTR($i,5)"
        	puts -nonewline $File "\t$schemesTR($i,6)"
        	puts            $File "\t$schemesTR($i,7)"
        }
    }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteGe2DopSectV2_52
#  Writes general 2D DXF options section 24 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteGe2DopSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_Ge2DopSect_lFC_Lbl"
    puts $File $Separator

    # k_section24
    puts $File $k_section24

    set i 1
    while {$i <= $numGe2Dop} {

        # marksType0 to marksType6
        puts -nonewline $File $dxf2DopA($i)
        puts -nonewline $File "\t$dxf2DopB($i)"
        puts            $File "\t$dxf2DopC($i)"
        incr i
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteGe3DopSectV2_52
#  Writes general 3D DXF options section 25 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteGe3DopSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_Ge3DopSect_lFC_Lbl"
    puts $File $Separator

    # k_section25
    puts $File $k_section25

    set i 1
    while {$i <= $numGe3Dop} {

        # marksType0 to marksType6
        puts -nonewline $File $dxf3DopA($i)
        puts -nonewline $File "\t$dxf3DopB($i)"
        puts            $File "\t$dxf3DopC($i)"
        incr i
    }

    set i [expr $numGe3Dop + 1]
    while {$i <= [expr $numGe3Dop + $numGe3Dopm]} {

        # marksType0 to marksType6
        puts -nonewline $File $dxf3DopA($i)
        puts -nonewline $File "\t$dxf3DopB($i)"
        puts -nonewline $File "\t$dxf3DopC($i)"
        puts            $File "\t$dxf3DopD($i)"
        incr i
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteGlueVenSectV2_52
#  Writes glue vents data in section 26 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteGlueVenSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_GlueVenSect_lFC_Lbl"
    puts $File $Separator

    # K_section26=0
    if {$k_section26 == 0} {
    puts $File $k_section26
    }

    # K_section26=1
    if {$k_section26 == 1} {
    puts $File $k_section26

    set i 1
    while {$i <= $numRibsHalf} {

        # marksType0 to marksType6
        puts -nonewline $File $glueVenA($i)
        puts            $File "\t$glueVenB($i)"
        incr i
    }
    }

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  WriteSpecWtSectV2_52
#  Writes special wingtip data in section 27 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteSpecWtSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_SpecWtSect_lFC_Lbl"
    puts $File $Separator

    # K_section27

    if {$k_section27 == 0 } {
    puts $File $k_section27
    }

    if {$k_section27 == 1 } {
        puts $File $k_section27
    	set i 1
    	while {$i <= 2} {
        	# Wingtip data
        	puts -nonewline $File $specWtA($i)
        	puts            $File "\t$specWtB($i)"
        	incr i
    	}
    }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteSpecWtSectV2_52
#  Writes calage variation data in section 28 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteCalagVarSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_CalagVarSect_lFC_Lbl"
    puts $File $Separator

    # K_section28

    if {$k_section28 == 0 } {
    puts $File $k_section28
    }

    if {$k_section28 == 1 } {
        puts $File $k_section28
    	
        puts $File $numRisersC

        puts -nonewline $File $calagVarA(1)
        puts -nonewline $File "\t$calagVarB(1)"
        puts -nonewline $File "\t$calagVarC(1)"
        puts -nonewline $File "\t$calagVarD(1)"
        puts -nonewline $File "\t$calagVarE(1)"
        puts            $File "\t$calagVarF(1)"

        puts -nonewline $File $speedVarA(1)
        puts -nonewline $File "\t$speedVarB(1)"
        puts -nonewline $File "\t$speedVarC(1)"
        puts            $File "\t$speedVarD(1)"

        }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteSpecWtSectV2_52
#  Writes 3D shaping data in section 29 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteP3DShapingSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_P3DShapingSect_lFC_Lbl"
    puts $File $Separator

    # K_section29
    if {$k_section29 == 0 } {
    puts $File $k_section29
    }

    if {$k_section29 == 1 } {
        puts $File $k_section29
        puts $File $k_section29b
        puts -nonewline $File $numGroups3DS(1)
        puts            $File "\t$numGroups3DS(2)"

        # iterate in each group
    	set i 1
    	while {$i <= $numGroups3DS(2)} {
                # data line 1
                puts -nonewline $File $num3DS($i,1)
                puts -nonewline $File "\t$num3DS($i,2)"
                puts -nonewline $File "\t$num3DS($i,3)"
                puts            $File "\t$num3DS($i,4)"
                # data line 2
                puts -nonewline $File $num3DS($i,5)
                puts -nonewline $File "\t$num3DS($i,6)"
                puts            $File "\t$num3DS($i,7)"
                    # print parameters extrados
    	            set j 1
    	            while {$j <= $num3DS($i,6)} {
                    puts -nonewline $File $line3DSu($i,$j,1)
                    puts -nonewline $File "\t$line3DSu($i,$j,2)"
                    puts -nonewline $File "\t$line3DSu($i,$j,3)"
                    puts            $File "\t$line3DSu($i,$j,4)"
                    incr j
                    }
                # data line 3
                puts -nonewline $File $num3DS($i,8)
                puts -nonewline $File "\t$num3DS($i,9)"
                puts            $File "\t$num3DS($i,10)"
                    # print parameters intrados
    	            set j 1
    	            while {$j <= $num3DS($i,9)} {
                    puts -nonewline $File $line3DSl($i,$j,1)
                    puts -nonewline $File "\t$line3DSl($i,$j,2)"
                    puts -nonewline $File "\t$line3DSl($i,$j,3)"
                    puts            $File "\t$line3DSl($i,$j,4)"
                    incr j
                    }
        incr i
        }     
                # print constant bloc of five lines
                    puts $File "* Print parameters"
                    set j 1
                    while {$j <= 5} {
                    puts -nonewline $File $line3DSpp($j,1)
                    puts -nonewline $File "\t$line3DSpp($j,2)"
                    puts -nonewline $File "\t$line3DSpp($j,3)"
                    puts -nonewline $File "\t$line3DSpp($j,4)"
                    puts            $File "\t$line3DSpp($j,5)"
                    incr j
                    }
        }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteAirThickSectV2_52
#  Writes airfoil thickness data in section 30 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteAirThickSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_AirThickSect_lFC_Lbl"
    puts $File $Separator

    # K_section30

    if {$k_section30 == 0 } {
    puts $File $k_section30
    }

    if {$k_section30 == 1 } {
        puts $File $k_section30
    	set i 1
    	while {$i <= $numRibsHalf} {
        	# Air thickness
        	puts -nonewline $File $airThickA($i)
        	puts            $File "\t$airThickB($i)"
        	incr i
    	}
    }
    return [list 0 $File]
}


#----------------------------------------------------------------------
#  WriteAirThickSectV2_52
#  Writes new skin tension data in section 31 in the V3.14 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteNewSkinSectV2_52 {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_NewSkinSect_lFC_Lbl"
    puts $File $Separator

    # K_section31
    puts $File $k_section31

    # Case 0
    if {$k_section31 == 0 } {
    # do nothing
    }

    # Case 1
    if {$k_section31 == 1 } {

        # Number of groups
        puts $File $numGroupsNS

        # iterate in each group
    	set i 1
    	while {$i <= $numGroupsNS} {

                puts -nonewline $File "* Skin tension group number $i from rib $numNewSkin($i,2) to "
                puts $File "$numNewSkin($i,3), $numNewSkin($i,4) points, type $numNewSkin($i,5)"

        	puts -nonewline $File $numNewSkin($i,1)
        	puts -nonewline $File "\t$numNewSkin($i,2)"
        	puts -nonewline $File "\t$numNewSkin($i,3)"
        	puts -nonewline $File "\t$numNewSkin($i,4)"
        	puts            $File "\t$numNewSkin($i,5)"
        # iterate in the number of points
    	set j 1
    	while {$j <= $numNewSkin($i,4)} {
        	puts -nonewline $File $lineNeSk($i,$j,1)
        	puts -nonewline $File "\t$lineNeSk($i,$j,2)"
        	puts -nonewline $File "\t$lineNeSk($i,$j,3)"
        	puts -nonewline $File "\t$lineNeSk($i,$j,4)"
        	puts            $File "\t$lineNeSk($i,$j,5)"
                incr j
              }
        	incr i
    	}
    }
    return [list 0 $File]
}



