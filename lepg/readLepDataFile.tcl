#----------------------------------------------------------------------
#  proc DetectFileVersion_rLDF
#
#  Determines version of the lep data file to be read.
#----------------------------------------------------------------------
proc DetectFileVersion_rLDF {FilePathName} {
    source "lepFileConstants.tcl"

    # return values
    #  -1 : file not available or not readable
    # x.y : version string

    if {[catch {set file [open $FilePathName]}] == 0} {
        # puts "All cool file is open"
    } else {
        # puts "Could not open file."
        return -1
    }

    # check first for the data files <= 2.6
    set i 1
    while {$i <= 10} {
        set DataLine [gets $file]
        # The default 2.52 file has a version indicator in the header
        if { [string first "2.52" $DataLine] >= 0 } {
            close $file
            return "2.52"
        }
        # The default 2.6 file has no version idicator, but you never now
        if { [string first "2.6" $DataLine] >= 0 } {
            close $file
            return "2.6"
        }
        incr i
    }

    # Check for data files >2.6
    # First ten lines are read, start from scratch
    seek $file 0 start
    set i 1
    while {$i <= 20} {
        set DataLine [gets $file]

        if { [string first $c_VersionSectId $DataLine] >= 0 } {
            # file version 2.7 or later
            set DataLine [gets $file]
            set DataLine [gets $file]
            close $file
            return $DataLine
        }
        incr i
    }

    # If we arrive here it is not a 2.52 version file
    # It is also not a new style file
    # Therefore it could only be 2.6
    close $file
    return "2.6"
}

#----------------------------------------------------------------------
#  proc readLepDataFile
#  Reads the lep data file
#
# IN:   FilePathName    Full path and name of file
# OUT:  -1 : file not available or unsupported version
#        0 : all cool file read, data should be available
#----------------------------------------------------------------------
proc readLepDataFile {FilePathName} {

    source "fileReadHelpers.tcl"
    source "lepFileConstants.tcl"

    set ReturnValue -1

    # Check what file version to be read
    set FileVersion [DetectFileVersion_rLDF $FilePathName]

    # open data file
    # as we know the version number=> file is there and readable=> we don't need to do error handling anymore
    set File [open $FilePathName r+]

    # setup the suffix
    if { $FileVersion <= 2.6 } {
        set Suffix "Lbl"
        set Offset 1
    } else {
        set Suffix "Id"
        set Offset 0
    }

    #---------
    # Geometry
    lassign [jumpToSection [set c_GeometrySect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadGeometrySectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------
    # Airfoil
    lassign [jumpToSection [set c_AirfoilSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadAirfoilSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------
    # Anchor points
    lassign [jumpToSection [set c_AnchorPoSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadAnchorPoSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------
    # Airfoil holes
    lassign [jumpToSection [set c_AirfoilHoSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadAirfoilHoSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-------------
    # Skin tension
    lassign [jumpToSection [set c_SkinTensSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadSkinTensSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #------------------
    # Sewing allowances
    lassign [jumpToSection [set c_SewingSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadSewingSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #------
    # Marks
    lassign [jumpToSection [set c_MarksSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadMarksSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-----------------------
    # Global angle of attack
    lassign [jumpToSection [set c_GlobalAoASect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadGlobalAoASectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-----------------
    # Suspension lines
    lassign [jumpToSection [set c_SuspLinesSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadSuspLinesSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #-------
    # Brakes
    lassign [jumpToSection [set c_BrakesSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadBrakesSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #---------------------
    # Ramification lengths
    lassign [jumpToSection [set c_RamLengthSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadRamLengthSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #----------------
    # H V and VH ribs => miniRib
    lassign [jumpToSection [set c_MiniRibSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadMiniRibSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #----------------------
    # Trailing edge  colors
    lassign [jumpToSection [set c_TeColSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadTeColSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------
    # Leading edge colors
    lassign [jumpToSection [set c_LeColSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadLeColSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #----------------------
    # Additional rib points
    lassign [jumpToSection [set c_AddRibPoSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadAddRibPoSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------------------
    # Elastig lines corrections
    lassign [jumpToSection [set c_ElLinesCorrSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadElLinesCorrSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

# add DXF

    #----------
    # Well read
    close $File
    return 0
}



#----------------------------------------------------------------------
#  ReadGeometrySectV2_52
#  Reads the Geometry section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadGeometrySectV2_52 {File} {
    source "globalWingVars.tcl"

    set DataLine  [gets $File]
    # BrandName
    set brandName  [gets $File]
    regsub -all {"} $brandName {\1} brandName

    set DataLine  [gets $File]
    # WingName
    set wingName  [gets $File]
    regsub -all {"} $wingName {\1} wingName
    set DataLine  [gets $File]
    # DrawScale
    set drawScale    [gets $File]
    set DataLine  [gets $File]
    # WingScale
    set wingScale    [gets $File]
    set DataLine  [gets $File]
    # NumCells
    set numCells [expr [gets $File]]
    set DataLine  [gets $File]
    # NumRibsTot
    set numRibsTot [expr [gets $File]]
    set DataLine  [gets $File]

    # washin = negative Flügelschränkung
    # WashinAlphaLine
    set AlphaMaxParLine [gets $File]

    # Extract AlphaMaxParLine line
    # AlphaMax
    set alphaMax [lindex $AlphaMaxParLine 0]

    # WashinMode
    set washinMode   [lindex $AlphaMaxParLine 1]
    if { $washinMode == 2 } {
        # AlphaCenter
        set alphaCenter [lindex $AlphaMaxParLine 2]
    }
    if { $washinMode == 1 } {
        set alphaCenter 0.0
    }

    set DataLine [gets $File]

    set ParaTypeLine  [gets $File]

    # Extract ParaTypeLine line
    # ParaType
    set paraType  [lindex $ParaTypeLine 0]

    # RotLeTriang - Rotate Leading Edge triangle
    set rotLeTriang [lindex $ParaTypeLine 1]

    set DataLine [gets $File]
    set DataLine [gets $File]

    # NumRibsHalf
    set numRibsHalf [expr ceil($numRibsTot/2)]
    # Erase ".0" at the end of string
    set l [string length $numRibsHalf]
    # NumberRibs
    set numRibsHalf [string range $numRibsHalf 0 [expr $l-3]]

    # Read matrix of geometry
    set i 1
    while {$i <= $numRibsHalf} {
        # RibGeomLine
        set ribGeomLine($i) [gets $File]
        foreach j {0 1 2 3 4 5 6 7 8} {
          # RibGeom
          set RibGeom($i,$j) [lindex $ribGeomLine($i) $j]
        }

        set ribConfig($i,1) $RibGeom($i,0)
        set ribConfig($i,2) $RibGeom($i,1)
        set ribConfig($i,3) $RibGeom($i,2)
        set ribConfig($i,4) $RibGeom($i,3)
        set ribConfig($i,6) $RibGeom($i,4)
        set ribConfig($i,7) $RibGeom($i,5)
        set ribConfig($i,9) $RibGeom($i,6)
        set ribConfig($i,10) $RibGeom($i,7)
        set ribConfig($i,51) $RibGeom($i,8)

        incr i
    }

    # Set washin parameteres if washinMode=0 => manual washin
    if { $washinMode == 0 } {
        set alphaCenter $RibGeom(1,8)
        set alphaMax $RibGeom($numRibsHalf,8)
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadAirfoilSectV2_52
#  Reads the Airfoli section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadAirfoilSectV2_52 {File} {
    source "globalWingVars.tcl"

    set DataLine [gets $File]

    set i 1
    while {$i <= $numRibsHalf} {
        set DataLine [gets $File]
        foreach j {0 1 2 3 4 5 6 7} {
            set RibGeom($i,$j) [lindex $DataLine $j]
        }


        set ribConfig($i,1)  $RibGeom($i,0)
        # airfoilName
        set airfoilName($i) $RibGeom($i,1)
        set ribConfig($i,11) $RibGeom($i,2)
        set ribConfig($i,12) $RibGeom($i,3)
        set ribConfig($i,14) $RibGeom($i,4)
        set ribConfig($i,50) $RibGeom($i,5)
        set ribConfig($i,55) $RibGeom($i,6)
        set ribConfig($i,56) $RibGeom($i,7)

        incr i
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadAnchorPoSectV2_52
#  Reads the Anchor point section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadAnchorPoSectV2_52 {File} {
    source "globalWingVars.tcl"

    set DataLine [gets $File]

    set i 1
    while {$i <= $numRibsHalf} {
        set DataLine [gets $File]
        foreach j {0 1 2 3 4 5 6 7} {
            set RibGeom($i,$j) [lindex $DataLine $j]
        }

        set ribConfig($i,1)  $RibGeom($i,0)
        set ribConfig($i,15) $RibGeom($i,1)
        set ribConfig($i,16) $RibGeom($i,2)
        set ribConfig($i,17) $RibGeom($i,3)
        set ribConfig($i,18) $RibGeom($i,4)
        set ribConfig($i,19) $RibGeom($i,5)
        set ribConfig($i,20) $RibGeom($i,6)
        set ribConfig($i,21) $RibGeom($i,7)

        incr i
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadAirfoilHoSectV2_52
#  Reads the Airfoil holes section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadAirfoilHoSectV2_52 {File} {
    source "globalWingVars.tcl"

    # AirfConfigNum - Number of Airfoil configurations
    set airfConfigNum  [gets $File]

    set ConfigIt 1
    while {$ConfigIt <= $airfConfigNum} {
        # Initial rib for first lightening configuration
        # holeRibNum1
        set holeRibNum1($ConfigIt) [gets $File]
        # Final rib for first lightening configuration
        # holeRibNum2
        set holeRibNum2($ConfigIt) [gets $File]
        # Number of holes for the first lightening configuration
        # numHoles
        set numHoles($ConfigIt) [gets $File]

        set HoleIt 1
        while {$HoleIt <= $numHoles($ConfigIt)} {
            set DataLine [gets $File]
            foreach j {0 1 2 3 4 5 6 7} {
                set HoleGeom($HoleIt,$j) [lindex $DataLine $j]
            }

            set holeConfig($holeRibNum1($ConfigIt),$HoleIt,9) $HoleGeom($HoleIt,0)
            set holeConfig($holeRibNum1($ConfigIt),$HoleIt,2) $HoleGeom($HoleIt,1)
            set holeConfig($holeRibNum1($ConfigIt),$HoleIt,3) $HoleGeom($HoleIt,2)
            set holeConfig($holeRibNum1($ConfigIt),$HoleIt,4) $HoleGeom($HoleIt,3)
            set holeConfig($holeRibNum1($ConfigIt),$HoleIt,5) $HoleGeom($HoleIt,4)
            set holeConfig($holeRibNum1($ConfigIt),$HoleIt,6) $HoleGeom($HoleIt,5)
            set holeConfig($holeRibNum1($ConfigIt),$HoleIt,7) $HoleGeom($HoleIt,6)
            set holeConfig($holeRibNum1($ConfigIt),$HoleIt,8) $HoleGeom($HoleIt,7)

            incr HoleIt
        }

        incr ConfigIt
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadSkinTensSectV2_52
#  Reads the Airfoil holes section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadSkinTensSectV2_52 {File} {
    source "globalWingVars.tcl"

    set DataLine [gets $File]

    set i 1
    while {$i <= 6} {
        set DataLine [gets $File]
        foreach j {0 1 2 3} {
            # skinTension
            set skinTens($i,[expr $j+1]) [lindex $DataLine $j]
        }
        incr i
    }

    # strainMiniRibs
    set strainMiniRibs [gets $File]
    set DataLine [gets $File]
    # numStrainPoints
    set numStrainPoints  [lindex $DataLine 0]
    # strainCoef
    set strainCoef [lindex $DataLine 1]

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadSewingSectV2_52
#  Reads the Sewing section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadSewingSectV2_52 {File} {
    source "globalWingVars.tcl"

    set DataLine  [gets $File]
    # seamUp
    set seamUp   [lindex $DataLine 0]
    # seamUpLe
    set seamUpLe [lindex $DataLine 1]
    # seamUpTe
    set seamUpTe [lindex $DataLine 2]

    set DataLine  [gets $File]
    # seamLo
    set seamLo   [lindex $DataLine 0]
    # seamLoLe
    set seamLoLe [lindex $DataLine 1]
    # seamloTe
    set seamLoTe [lindex $DataLine 2]

    # seamRib
    set seamRib   [gets $File]
    # seamVRib
    set seamVRib  [gets $File]

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadMarksSectV2_52
#  Reads the Marks section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadMarksSectV2_52 {File} {
    source "globalWingVars.tcl"

    set DataLine  [gets $File]
    # markSpace
    set markSpace  [lindex $DataLine 0]
    # markRad
    set markRad   [lindex $DataLine 1]
    # markDisp
    set markDisp   [lindex $DataLine 2]

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadGlobalAoASectV2_52
#  Reads the Global AoA section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadGlobalAoASectV2_52 {File} {
    source "globalWingVars.tcl"

    set DataLine   [gets $File]

    set DataLine   [gets $File]
    # finesse
    set finesse [gets $File]
    set DataLine  [gets $File]
    # posCOP
    set posCop [gets $File]
    set DataLine  [gets $File]
    # calage
    set calage [gets $File]
    set DataLine  [gets $File]
    # riserLength
    set riserLength [gets $File]
    set DataLine  [gets $File]
    # lineLength
    set lineLength [gets $File]
    set DataLine  [gets $File]
    # distTowP
    set distTowP [gets $File]

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadSuspLinesSectV2_52
#  Reads the Suspension lines section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadSuspLinesSectV2_52 {File} {
    source "globalWingVars.tcl"

    # Line Control Parameter
    # lineMode
    set lineMode [gets $File]
    # numLinePlan
    set lineMode      [gets $File]

    set LinePlanIt 1
    while {$LinePlanIt <= $lineMode} {

        # numLinePath
        set numLinePath($LinePlanIt) [gets $File]

        # Read Line Paths
        set i 1
        while {$i <= $numLinePath($LinePlanIt)} {
            set DataLine [gets $File]
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

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadBrakesSectV2_52
#  Reads the Brakes section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadBrakesSectV2_52 {File} {
    source "globalWingVars.tcl"

    # be careful: works only if Suspension lines was read before!
    set LinePlanIt [expr $lineMode+1]

    # brakeLength
    set brakeLength   [gets $File]
    set numLinePath($LinePlanIt) [gets $File]


    # Read 4 levels
    set i 1
    while {$i <= $numLinePath($LinePlanIt)} {
        set DataLine  [gets $File]
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

    set DataLine   [gets $File]

    set DataLine   [gets $File]
    # brakeDistr
    set bd(1,1) [lindex $DataLine 0]
    set bd(2,1) [lindex $DataLine 1]
    set bd(3,1) [lindex $DataLine 2]
    set bd(4,1) [lindex $DataLine 3]
    set bd(5,1) [lindex $DataLine 4]

    set DataLine   [gets $File]
    set bd(1,2) [lindex $DataLine 0]
    set bd(2,2) [lindex $DataLine 1]
    set bd(3,2) [lindex $DataLine 2]
    set bd(4,2) [lindex $DataLine 3]
    set bd(5,2) [lindex $DataLine 4]

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadRamLengthSectV2_52
#  Reads the Ramification length section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadRamLengthSectV2_52 {File} {
    source "globalWingVars.tcl"

    set DataLine [gets $File]
    # ramLength
    set ramLength(3,1) [lindex $DataLine 0]
    set ramLength(3,3) [lindex $DataLine 1]

    set DataLine     [gets $File]
    set ramLength(4,1) [lindex $DataLine 0]
    set ramLength(4,3) [lindex $DataLine 1]
    set ramLength(4,4) [lindex $DataLine 2]

    set DataLine     [gets $File]
    set ramLength(5,1) [lindex $DataLine 0]
    set ramLength(5,3) [lindex $DataLine 1]

    set DataLine     [gets $File]
    set ramLength(6,1) [lindex $DataLine 0]
    set ramLength(6,3) [lindex $DataLine 1]
    set ramLength(6,4) [lindex $DataLine 2]

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadMiniRibSectV2_52
#  Reads the Mini rib section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadMiniRibSectV2_52 {File} {
    source "globalWingVars.tcl"

    # numMiniRibs
    set numMiniRibs  [gets $File]

    set DataLine [gets $File]
    # miniRibXSep
    set miniRibXSep [lindex $DataLine 0]
    # miniRibYSep
    set miniRibYSep [lindex $DataLine 1]

    set i 1
    while {$i <= $numMiniRibs} {
        set DataLine [gets $File]
        foreach j {0 1 2 3 4 5 6 7 8 9} {
            # miniRib
            set miniRib($i,[expr $j+1]) [lindex $DataLine $j]
        }

        # If case 6 (V-rib type 6 general diagonal), read 12 numbers
        if { $miniRib($i,2) == 6 } {
            foreach j {0 1 2 3 4 5 6 7 8 9 10 11} {
                set miniRib($i,[expr $j+1]) [lindex $DataLine $j]
            }
        }
        incr i
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadTeColSectV2_52
#  Reads the Trailind edge section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadTeColSectV2_52 {File} {
    source "globalWingVars.tcl"

    # numTeCol
    set numTeCol  [gets $File]

    set TeColIt 1

    while {$TeColIt <= $numTeCol} {
        set DataLine [gets $File]
        # teColRibNum
        set teColRibNum($TeColIt) [lindex $DataLine 0]
        # numTeColMark
        set numTeColMarks($TeColIt) [lindex $DataLine 1]

        set i 1
        while {$i <= $numTeColMarks($TeColIt)} {
            set DataLine [gets $File]
            # teColMarkNum
            set teColMarkNum($TeColIt,$i) [lindex $DataLine 0]
            # teColMarkYDist
            set teColMarkYDist($TeColIt,$i) [lindex $DataLine 1]
            # teColMarkXDist
            set teColMarkXDist($TeColIt,$i) [lindex $DataLine 2]
            incr i
        }
        incr TeColIt
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadLeColSectV2_52
#  Reads the Leading edge section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadLeColSectV2_52 {File} {
    source "globalWingVars.tcl"

    # numLeCol
    set numLeCol  [gets $File]

    set LeColIt 1
    while {$LeColIt <= $numLeCol} {
			set DataLine [gets $File]
            # leColRibNum
			set leColRibNum($LeColIt) [lindex $DataLine 0]
            # numleColMark
			set numleColMarks($LeColIt) [lindex $DataLine 1]

			set i 1
			while {$i <= $numleColMarks($LeColIt)} {
    			set DataLine [gets $File]
                # leColMarkNum
                set leColMarkNum($LeColIt,$i) [lindex $DataLine 0]
                # leColMarkYDist
                set leColMarkYDist($LeColIt,$i) [lindex $DataLine 1]
                # leColMarkXDist
                set leColMarkXDist($LeColIt,$i) [lindex $DataLine 2]
    			incr i
		}
		incr LeColIt
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadAddRibPoSectV2_52
#  Reads the Rib points section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadAddRibPoSectV2_52 {File} {
    source "globalWingVars.tcl"

    # numAddRipPo
    set numAddRipPo [gets $File]

    set i 1
    while {$i <= $numAddRipPo} {
        set DataLine [gets $File]
        # addRipPoX
        set addRipPoX($i) [lindex $DataLine 0]
        # addRipPoY
        set addRipPoY($i) [lindex $DataLine 1]
        incr i
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadElLinesCorrSectV2_52
#  Reads the elastic lines correction section of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadElLinesCorrSectV2_52 {File} {
    source "globalWingVars.tcl"

    # loadTot
    set loadTot [gets $File]

    # loadDistr
    set DataLine [gets $File]
    set loadDistr(2,1) [lindex $DataLine 0]
    set loadDistr(2,2) [lindex $DataLine 1]

    set DataLine [gets $File]
    set loadDistr(3,1) [lindex $DataLine 0]
    set loadDistr(3,2) [lindex $DataLine 1]
    set loadDistr(3,3) [lindex $DataLine 2]

    set DataLine [gets $File]
    set loadDistr(4,1) [lindex $DataLine 0]
    set loadDistr(4,2) [lindex $DataLine 1]
    set loadDistr(4,3) [lindex $DataLine 2]
    set loadDistr(4,4) [lindex $DataLine 3]

    set DataLine [gets $File]
    set loadDistr(5,1) [lindex $DataLine 0]
    set loadDistr(5,2) [lindex $DataLine 1]
    set loadDistr(5,3) [lindex $DataLine 2]
    set loadDistr(5,4) [lindex $DataLine 3]
    set loadDistr(5,5) [lindex $DataLine 4]

    # loadDeform
    # code to read this is missing

    return [list 0 $File]
}
