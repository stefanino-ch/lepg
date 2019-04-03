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
set Separator "**********************************"

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

    # File header
    lassign [WriteFileHeaderV2_6 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #---------
    # Geometry
    lassign [WriteGeometrySectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------
    # Airfoil
    lassign [WriteAirfoilSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------
    # Anchor points
    lassign [WriteAnchorsSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------
    # Airfoil holes
    lassign [WriteAirfoilHoSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-------------
    # Skin tension
    #--------------
    # Anchor points
    lassign [WriteSkinTensSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #------------------
    # Sewing allowances
    lassign [WriteSewingAllowancesV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #------
    # Marks
    lassign [WriteMarksSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-----------------------
    # Global angle of attack
    lassign [WriteGlobalAoASectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-----------------
    # Suspension lines
    lassign [WriteSuspLinesSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-------
    # Brakes
    lassign [WriteBrakesSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #---------------------
    # Ramification lengths
    lassign [WriteRamLengthSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }


    #----------------
    # H V and VH ribs => miniRib
    lassign [WriteHV-VH-RibSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #----------------------
    # Trailing edge  colors
    lassign [WriteTeColSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------
    # Leading edge colors
    lassign [WriteLeColSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #----------------------
    # Additional rib points

    #--------------------------
    # Elastig lines corrections
    lassign [WriteElLinesCorrSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }


    #--------------------------
    # DXF

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
    puts $File "* lep input data file        v2.6"
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

    # miniRibXSep
    puts $File $miniRibXSep

    # miniRibYSep
    puts $File $miniRibYSep

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
