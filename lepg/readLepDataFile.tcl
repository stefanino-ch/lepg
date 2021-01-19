#---------------------------------------------------------------------
#
#  Reads the lep data file
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

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

        if { [string first $c_VersionSect_lFC_Id $DataLine] >= 0 } {
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
    Debug_rLDF "Check file version..."
    set FileVersion [DetectFileVersion_rLDF $FilePathName]
    Debug_rLDF "$FileVersion \n"

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
    # 1. Geometry
    Debug_rLDF "Geometry: jump..."
    lassign [jumpToSection [set c_GeometrySect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "read..."
    lassign [ReadGeometrySectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "done\n"

    #--------
    # 2. Airfoil
    Debug_rLDF "Airfoil: jump..."
    lassign [jumpToSection [set c_AirfoilSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "read..."
    lassign [ReadAirfoilSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "done\n"

    #--------------
    # 3. Anchor points
    Debug_rLDF "Anchor points: jump..."
    lassign [jumpToSection [set c_AnchorPoSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "read..."
    lassign [ReadAnchorPoSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "done\n"

    #--------------
    # 4. Airfoil holes
    Debug_rLDF "Airfoil holes: jump..."
    lassign [jumpToSection [set c_AirfoilHoSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "read..."
    lassign [ReadAirfoilHoSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "done\n"

    #-------------
    # 5. Skin tension
    Debug_rLDF "Skin tension: jump..."
    lassign [jumpToSection [set c_SkinTensSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "read..."
    lassign [ReadSkinTensSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "done\n"

    #------------------
    # 6. Sewing allowances
    Debug_rLDF "Sewing allowances: jump..."
    lassign [jumpToSection [set c_SewingSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "read..."
    lassign [ReadSewingSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "done\n"

    #------
    # 7. Marks
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
    # 8. Global angle of attack
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
    # 9. Suspension lines
    Debug_rLDF "Suspension lines: jump..."
    lassign [jumpToSection [set c_SuspLinesSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "read..."
    lassign [ReadSuspLinesSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "done\n"

    #-------
    # 10. Brakes
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
    # 11. Ramification lengths
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
    # 12. H V and VH ribs => miniRib
    lassign [jumpToSection [set c_MiniRibSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadHV-VH-RibSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #----------------------
    # 15. Extrados colors (TE?)
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
    # 16. Intrados colors (LE?)
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
    # 17. Additional rib points
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
    # 18. Elastig lines corrections
    Debug_rLDF "Elastig lines corrections: jump..."
    lassign [jumpToSection [set c_ElLinesCorrSect_lFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "read..."
    lassign [ReadElLinesCorrSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    Debug_rLDF "done\n"

    #--------------------------    
    # 19. DXF layer names
    lassign [jumpToSection [set c_DXFLayNaSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadDXFLayNaSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 20. Marks types
    lassign [jumpToSection [set c_MarksTySect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadMarksTySectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 21. Joncs definition
    lassign [jumpToSection [set c_JoncsDefSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadJoncsDefSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 22. Nose Mylars
    lassign [jumpToSection [set c_NoseMySect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadNoseMySectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 23. Tab reinforcements
    lassign [jumpToSection [set c_TabReinfSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadTabReinfSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 24. General 2D DXF options
    lassign [jumpToSection [set c_Ge2DopSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadGe2DopSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 25. General 3D DXF options
    lassign [jumpToSection [set c_Ge3DopSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadGe3DopSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 26. Glue vents
    lassign [jumpToSection [set c_GlueVenSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadGlueVenSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 27. Special wingtip
    lassign [jumpToSection [set c_SpecWtSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadSpecWtSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 28. Calage variations
    lassign [jumpToSection [set c_CalagVarSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadCalagVarSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 30. Airfoil thickness
    lassign [jumpToSection [set c_P3DShapingSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadP3DShapingSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 30. Airfoil thickness
    lassign [jumpToSection [set c_AirThickSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadAirThickSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }

    #--------------------------    
    # 31. New skin tension
    lassign [jumpToSection [set c_NewSkinSect_lFC_$Suffix] $Offset $File] ReturnValue File

    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }
    lassign [ReadNewSkinSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
        puts $returnValue
    }


#    ADD MORE SECTIONS HERE!!!!!!!!!!!!





    #----------
    # Well read
    close $File
    return 0
}

#----------------------------------------------------------------------
#  ReadGeometrySectV2_52
#  Reads the Geometry section 1 of a lep data file
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
    # if the number of Ribs total is odd (uneven) we must increase the half num of Ribs
    set numRibsHalf [expr ceil($numRibsTot/2)]

    # Erase ".0" at the end of string
    set l [string length $numRibsHalf]
    # NumberRibs
    set numRibsHalf [string range $numRibsHalf 0 [expr $l-3]]

    if { [expr ($numRibsTot % 2)] != 0 } {
        # odd (uneven7 ungerade)
        # increment by one unless we miss the middle rib
        incr numRibsHalf
    }

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

    # Set num ribs for section 01C matrix edit
    set numRibsGeo $numRibsHalf

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadAirfoilSectV2_52
#  Reads the Airfoils section 2 of a lep data file
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
#  Reads the Anchor point section 3 of a lep data file
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
#  Reads the Airfoil holes section 4 of a lep data file
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
        set holeRibNum1($ConfigIt) [gets $File]
        Debug_rLDF "\nConfigIt - holeRibNum1 $ConfigIt - $holeRibNum1($ConfigIt)"

        # Final rib for first lightening configuration
        set holeRibNum2($ConfigIt) [gets $File]
        Debug_rLDF "\n ConfigIt - holeRibNum2 $holeRibNum2($ConfigIt) - $ConfigIt"

        # Number of holes for the first lightening configuration
        set numHoles($ConfigIt) [gets $File]
        Debug_rLDF "\n ConfigIt numHoles $ConfigIt - $numHoles($ConfigIt)"

        set HoleIt 1
        while {$HoleIt <= $numHoles($ConfigIt)} {
            set DataLine [gets $File]
            foreach j {0 1 2 3 4 5 6 7} {
                set HoleGeom($HoleIt,$j) [lindex $DataLine $j]
            }

            set holeConfig($holeRibNum1($ConfigIt),$HoleIt,9)     $HoleGeom($HoleIt,0)
            Debug_rLDF "\n  ConfigIt $ConfigIt - HoleIt $HoleIt - holeRibNum1(ConfigIt) $holeRibNum1($ConfigIt)"

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
#  Reads the skin tension section 5 of a lep data file
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

    # read the extrados line
    set DataLine [gets $File]

    set i 1
    while {$i <= 6} {
        set DataLine [gets $File]
        Debug_rLDF "\nRead Skin Tens: DataLine $DataLine\n"
        foreach j { 0 1 2 3 } {
            # skinTension
            set skinTens($i,[expr $j+1]) [lindex $DataLine $j]
            Debug_rLDF "skinTens $i [expr $j+1] $skinTens($i,[expr $j+1])\n"
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
#  Reads the Sewing section 6 of a lep data file
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

    set DataLine  [gets $File]
    # seamRib
    set seamRib   [lindex $DataLine 0]

    set DataLine  [gets $File]
    # seamVRib
    set seamVRib  [lindex $DataLine 0]

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadMarksSectV2_52
#  Reads the Marks section 7 of a lep data file
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
#  Reads the Global AoA section 8 of a lep data file
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

    # finesse
    set DataLine    [gets $File]
    set DataLine    [gets $File]
    set finesse     [lindex $DataLine 0]

    # posCOP
    set DataLine    [gets $File]
    set DataLine    [gets $File]
    set posCop      [lindex $DataLine 0]

    # calage
    set DataLine    [gets $File]
    set DataLine    [gets $File]
    set calage      [lindex $DataLine 0]

    # riserLength
    set DataLine    [gets $File]
    set DataLine    [gets $File]
    set riserLength [lindex $DataLine 0]

    # lineLength
    set DataLine    [gets $File]
    set DataLine    [gets $File]
    set lineLength  [lindex $DataLine 0]

    # distTowP
    set DataLine    [gets $File]
    set DataLine    [gets $File]
    set distTowP    [lindex $DataLine 0]

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadSuspLinesSectV2_52
#  Reads the Suspension lines section 9 of a lep data file
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
    Debug_rLDF "lineMode $lineMode\n"

    # numLinePlan
    set numLinePlan      [gets $File]
    Debug_rLDF "numLinePlan $numLinePlan\n"

    set LinePlanIt 1
    while {$LinePlanIt <= $numLinePlan} {

        # numLinePath
        set numLinePath($LinePlanIt) [gets $File]
        Debug_rLDF "numLinePath($LinePlanIt) $numLinePath($LinePlanIt)\n"

        # Read Line Paths
        set i 1
        while {$i <= $numLinePath($LinePlanIt)} {
            set DataLine [gets $File]
            # LinePath
            set linePath($LinePlanIt,$i,1)   [lindex $DataLine 0]
            set linePath($LinePlanIt,$i,2)   [lindex $DataLine 1]
            set linePath($LinePlanIt,$i,3)   [lindex $DataLine 2]
            set linePath($LinePlanIt,$i,4)   [lindex $DataLine 3]
            set linePath($LinePlanIt,$i,5)   [lindex $DataLine 4]
            set linePath($LinePlanIt,$i,6)   [lindex $DataLine 5]
            set linePath($LinePlanIt,$i,7)   [lindex $DataLine 6]
            set linePath($LinePlanIt,$i,8)   [lindex $DataLine 7]
            set linePath($LinePlanIt,$i,9)   [lindex $DataLine 8]
            set linePath($LinePlanIt,$i,14)  [lindex $DataLine 9]
            set linePath($LinePlanIt,$i,15)  [lindex $DataLine 10]
            incr i
        }

        incr LinePlanIt
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadBrakesSectV2_52
#  Reads the Brakes section 10 of a lep data file
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

    # brakeLength
    set brakeLength         [gets $File]
    set numBrakeLinePath    [gets $File]

    # read the detailed path info
    for {set i 1} {$i <= $numBrakeLinePath} {incr i} {
        set DataLine  [gets $File]
        set brakeLinePath($i,1)   [lindex $DataLine 0]
        set brakeLinePath($i,2)   [lindex $DataLine 1]
        set brakeLinePath($i,3)   [lindex $DataLine 2]
        set brakeLinePath($i,4)   [lindex $DataLine 3]
        set brakeLinePath($i,5)   [lindex $DataLine 4]
        set brakeLinePath($i,6)   [lindex $DataLine 5]
        set brakeLinePath($i,7)   [lindex $DataLine 6]
        set brakeLinePath($i,8)   [lindex $DataLine 7]
        set brakeLinePath($i,9)   [lindex $DataLine 8]
        set brakeLinePath($i,14)  [lindex $DataLine 9]
        set brakeLinePath($i,15)  [lindex $DataLine 10]
    }

    # jump over the subtitle
    set DataLine   [gets $File]

    # read the brake distribution
    set DataLine   [gets $File]
    set brakeDistr(1,1) [lindex $DataLine 0]
    set brakeDistr(1,2) [lindex $DataLine 1]
    set brakeDistr(1,3) [lindex $DataLine 2]
    set brakeDistr(1,4) [lindex $DataLine 3]
    set brakeDistr(1,5) [lindex $DataLine 4]

    set DataLine   [gets $File]
    set brakeDistr(2,1) [lindex $DataLine 0]
    set brakeDistr(2,2) [lindex $DataLine 1]
    set brakeDistr(2,3) [lindex $DataLine 2]
    set brakeDistr(2,4) [lindex $DataLine 3]
    set brakeDistr(2,5) [lindex $DataLine 4]

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadRamLengthSectV2_52
#  Reads the Ramification length section 11 of a lep data file
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
#  proc ReadHV-VH-RibSectV2_52
#  Reads the Mini rib section 12 of a lep data file
#  Applicable versions 2.52 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadHV-VH-RibSectV2_52 {File} {
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
#  Reads the extrados colors section 15 of a lep data file
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

    # numTeCol (extrados colors)
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
#  Reads the intrados colors section 16 of a lep data file
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

    # numLeCol (intrados colors)
    set numLeCol  [gets $File]

    set LeColIt 1
    while {$LeColIt <= $numLeCol} {
			set DataLine [gets $File]
            # leColRibNum
			set leColRibNum($LeColIt) [lindex $DataLine 0]
            # numleColMark
			set numLeColMarks($LeColIt) [lindex $DataLine 1]

			set i 1
			while {$i <= $numLeColMarks($LeColIt)} {
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
#  Reads the Rib points section 17 of a lep data file
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
#  Reads the elastic lines correction section 18 of a lep data file
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
    set loadDistr(1,1) [lindex $DataLine 0]
    set loadDistr(1,2) [lindex $DataLine 1]

    set DataLine [gets $File]
    set loadDistr(2,1) [lindex $DataLine 0]
    set loadDistr(2,2) [lindex $DataLine 1]
    set loadDistr(2,3) [lindex $DataLine 2]

    set DataLine [gets $File]
    set loadDistr(3,1) [lindex $DataLine 0]
    set loadDistr(3,2) [lindex $DataLine 1]
    set loadDistr(3,3) [lindex $DataLine 2]
    set loadDistr(3,4) [lindex $DataLine 3]

    set DataLine [gets $File]
    set loadDistr(4,1) [lindex $DataLine 0]
    set loadDistr(4,2) [lindex $DataLine 1]
    set loadDistr(4,3) [lindex $DataLine 2]
    set loadDistr(4,4) [lindex $DataLine 3]
    set loadDistr(4,5) [lindex $DataLine 4]

    for {set i 1} {$i <=5} {incr i} {
        set DataLine [gets $File]
        set loadDeform($i,1) [lindex $DataLine 0]
        set loadDeform($i,2) [lindex $DataLine 1]
        set loadDeform($i,3) [lindex $DataLine 2]
        set loadDeform($i,4) [lindex $DataLine 3]
    }

    return [list 0 $File]
}



#----------------------------------------------------------------------
#  proc ReadDXFLayNaSectV2_52
#  Reads the dxf layer names section 19 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadDXFLayNaSectV2_52 {File} {
    source "globalWingVars.tcl"

    # numDXFLayNa
    set numDXFLayNa [gets $File]

    set i 1
    while {$i <= $numDXFLayNa} {
        set DataLine [gets $File]
        # addRipPoX
        set dxfLayNaX($i) [lindex $DataLine 0]
        # addRipPoY
        set dxfLayNaY($i) [lindex $DataLine 1]
        incr i
    }

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  proc ReadMarksTySectV2_52
#  Reads the Marks types section 20 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadMarksTySectV2_52 {File} {
    source "globalWingVars.tcl"

    # numMarksTy
    set numMarksTy [gets $File]

    set i 1
    while {$i <= $numMarksTy} {
        set DataLine [gets $File]
        # marksType0
        set marksType0($i) [lindex $DataLine 0]
        # marksType1
        set marksType1($i) [lindex $DataLine 1]
        # marksType2
        set marksType2($i) [lindex $DataLine 2]
        # marksType3
        set marksType3($i) [lindex $DataLine 3]
        # marksType4
        set marksType4($i) [lindex $DataLine 4]
        # marksType5
        set marksType5($i) [lindex $DataLine 5]
        # marksType6
        set marksType6($i) [lindex $DataLine 6]

        incr i
    }

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  proc ReadAirThickSectV2_52
#  Reads data for joncs definition section 21 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadJoncsDefSectV2_52 {File} { 
    source "globalWingVars.tcl"

    # k_section21 (scheme)
    set k_section21 [gets $File]

    # Case scheme 0
    if {$k_section21 == 0 } {
    #  Stop reading
    #  set data blocs number to 0
    set numGroupsJDdb 0
    #  set data blocs number to 0
    set numGroupsJDdb 0
    # set data bloc number and type
    set numDataBlocJD(1,1) 0
    set numDataBlocJD(1,2) 0
    }

    # Case scheme 1
    if {$k_section21 == 1 } {
    #  set data blocs number to 1
    set numGroupsJDdb 1
    # set data bloc number and type
    set numDataBlocJD(1,1) 1
    set numDataBlocJD(1,2) 1

    # set number of groups
    set numGroupsJD(1) [gets $File]

    # read each group type 1
    set gr 1
    while {$gr <= $numGroupsJD(1)} {

    	 set DataLine [gets $File]
   	 set numJoncsDef(1,$gr,1) [lindex $DataLine 0]
   	 set numJoncsDef(1,$gr,2) [lindex $DataLine 1]
   	 set numJoncsDef(1,$gr,3) [lindex $DataLine 2]

   	 foreach i {1 2 3} {
   	 set DataLine [gets $File]
    	 set lineJoncsDef1(1,$gr,$i,1) [lindex $DataLine 0]
    	 set lineJoncsDef1(1,$gr,$i,2) [lindex $DataLine 1]
   	 set lineJoncsDef1(1,$gr,$i,3) [lindex $DataLine 2]
    	 set lineJoncsDef1(1,$gr,$i,4) [lindex $DataLine 3]
         }

    incr gr
    }
    # end scheme 1
    }

    # Case scheme 2
    if {$k_section21 == 2 } { 
    #  set data blocs number
    set numGroupsJDdb [gets $File]

    # iterate in each data bloc
    set db 1
    while {$db <= $numGroupsJDdb} { 

    # set data bloc number and type
    set DataLine [gets $File]
    set numDataBlocJD($db,1) [lindex $DataLine 0]
    set numDataBlocJD($db,2) [lindex $DataLine 1]

    # set number of groups
    set numGroupsJD($db) [gets $File]

    # iterate in each group
    set gr 1
    while {$gr <= $numGroupsJD($db)} {

    # read group type 1
    if {$numDataBlocJD($db,2) == 1} {

    	 set DataLine [gets $File]
   	 set numJoncsDef($db,$gr,1) [lindex $DataLine 0]
   	 set numJoncsDef($db,$gr,2) [lindex $DataLine 1]
   	 set numJoncsDef($db,$gr,3) [lindex $DataLine 2]

   	 foreach i {1 2 3} {
   	 set DataLine [gets $File]
    	 set lineJoncsDef1($db,$gr,$i,1) [lindex $DataLine 0]
    	 set lineJoncsDef1($db,$gr,$i,2) [lindex $DataLine 1]
   	 set lineJoncsDef1($db,$gr,$i,3) [lindex $DataLine 2]
    	 set lineJoncsDef1($db,$gr,$i,4) [lindex $DataLine 3]
         }

#     puts "group 1 from $numJoncsDef($db,$gr,2) to $numJoncsDef($db,$gr,3)"
     }
    # read group type 2
    if {$numDataBlocJD($db,2) == 2} {

    	 set DataLine [gets $File]
   	 set numJoncsDef($db,$gr,1) [lindex $DataLine 0]
   	 set numJoncsDef($db,$gr,2) [lindex $DataLine 1]
   	 set numJoncsDef($db,$gr,3) [lindex $DataLine 2]

   	 set DataLine [gets $File]
    	 set lineJoncsDef2($db,$gr,1,1) [lindex $DataLine 0]
    	 set lineJoncsDef2($db,$gr,1,2) [lindex $DataLine 1]
   	 set lineJoncsDef2($db,$gr,1,3) [lindex $DataLine 2]
    	 set lineJoncsDef2($db,$gr,1,4) [lindex $DataLine 3]
    	 set lineJoncsDef2($db,$gr,1,5) [lindex $DataLine 4]

         set DataLine [gets $File]
    	 set lineJoncsDef2($db,$gr,2,1) [lindex $DataLine 0]
    	 set lineJoncsDef2($db,$gr,2,2) [lindex $DataLine 1]
   	 set lineJoncsDef2($db,$gr,2,3) [lindex $DataLine 2]
    	 set lineJoncsDef2($db,$gr,2,4) [lindex $DataLine 3]

#     puts "group 2 from $numJoncsDef($db,$gr,2) to $numJoncsDef($db,$gr,3)"

     }
    # end groups in data bloc
    incr gr
    } 
    # end data blocs
    incr db
    } 
    # end scheme 2
    } 

    return [list 0 $File]
} 


#----------------------------------------------------------------------
#  proc ReadAirThickSectV2_52
#  Reads data for nose mylars section 22 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadNoseMySectV2_52 {File} {
    source "globalWingVars.tcl"

    # k_section22
    set k_section22 [gets $File]

    # Case 0
    if {$k_section22 == 0 } {
    #  Stop reading
    set numGroupsMY 8
    foreach i {1 2 3 4 5 6 7 8 9 10} {
    foreach j {1 2 3 4 5 6 7 8 9 10} {
    set numNoseMy($i,$j) 1
    set lineNoseMy($i,$j) 1
    }
    }
    }

    # Case 1
    if {$k_section22 == 1 } {

        # Number of groups
        set numGroupsMY [gets $File]

        # iterate in each group
    	set i 1
    	while {$i <= $numGroupsMY} {
                # data line
        	set DataLine [gets $File]
        	set numNoseMy($i,1) [lindex $DataLine 0]
        	set numNoseMy($i,2) [lindex $DataLine 1]
        	set numNoseMy($i,3) [lindex $DataLine 2]
                # read parameters
        	set DataLine [gets $File]
        	set lineNoseMy($i,1) [lindex $DataLine 0]
                set lineNoseMy($i,2) [lindex $DataLine 1]
                set lineNoseMy($i,3) [lindex $DataLine 2]
                set lineNoseMy($i,4) [lindex $DataLine 3]
                set lineNoseMy($i,5) [lindex $DataLine 4]
                set lineNoseMy($i,6) [lindex $DataLine 5]
                incr i
        }
    }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadAirThickSectV2_52
#  Reads data for tab reinforcements section 23 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadTabReinfSectV2_52 {File} {
    source "globalWingVars.tcl"

    # k_section22
    set k_section23 [gets $File]

    # Case 0
    if {$k_section23 == 0 } {
    #  Stop reading
    set numGroupsTR 1
    }

    # Case 1
    if {$k_section23 == 1 } {
        # Number of groups
        set numGroupsTR [gets $File]

        # iterate in each group
    	set i 1
    	while {$i <= $numGroupsTR} {
                # data line
        	set DataLine [gets $File]
        	set numTabReinf($i,1) [lindex $DataLine 0]
        	set numTabReinf($i,2) [lindex $DataLine 1]
        	set numTabReinf($i,3) [lindex $DataLine 2]
                # read parameters
        	set DataLine [gets $File]
        	set lineTabReinf($i,1) [lindex $DataLine 0]
                set lineTabReinf($i,2) [lindex $DataLine 1]
                set lineTabReinf($i,3) [lindex $DataLine 2]
                set lineTabReinf($i,4) [lindex $DataLine 3]
                set lineTabReinf($i,5) [lindex $DataLine 4]
                incr i
        }

        # schemes
        set DataLine [gets $File]
        # schemes data
        foreach i {1 2 3 4 5} {
        set DataLine [gets $File]
        foreach j {1 2 3 4 5 6 7} {
        set schemesTR($i,$j) [lindex $DataLine [expr ($j - 1)]]
        }
        }
    }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadMarksTySectV2_52
#  Reads general 2D DXF options section 24 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadGe2DopSectV2_52 {File} {
    source "globalWingVars.tcl"

    set numGe2Dop 6

    # k_section24
    set k_section24 [gets $File]

    set i 1
    while {$i <= $numGe2Dop} {
        set DataLine [gets $File]
        # value0
        set dxf2DopA($i) [lindex $DataLine 0]
        # value1
        set dxf2DopB($i) [lindex $DataLine 1]
        # value2
        set dxf2DopC($i) [lindex $DataLine 2]
        # value3
        incr i
    }

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  proc ReadMarksTySectV2_52
#  Reads general 3D DXF options section 25 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadGe3DopSectV2_52 {File} {
    source "globalWingVars.tcl"

    set numGe3Dop 6
    set numGe3Dopm 3

    # k_section25
    set k_section25 [gets $File]

    # Fisrt bloc
    set i 1
    while {$i <= $numGe3Dop} {
        set DataLine [gets $File]
        # value0
        set dxf3DopA($i) [lindex $DataLine 0]
        # value1
        set dxf3DopB($i) [lindex $DataLine 1]
        # value2
        set dxf3DopC($i) [lindex $DataLine 2]
        # value3
#        set dxf3DopD($i) [lindex $DataLine 3]
        # value3

        incr i
    }

    # Second bloc
    set i [expr $numGe3Dop + 1]
    while {$i <= [expr $numGe3Dop + $numGe3Dopm] } {
        set DataLine [gets $File]
        # value0
        set dxf3DopA($i) [lindex $DataLine 0]
        # value1
        set dxf3DopB($i) [lindex $DataLine 1]
        # value2
        set dxf3DopC($i) [lindex $DataLine 2]
        # value3
        set dxf3DopD($i) [lindex $DataLine 3]
        # value4
        incr i
    }

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  proc ReadGlueVenSectV2_52
#  Reads data for glue vents section 26 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadGlueVenSectV2_52 {File} {
    source "globalWingVars.tcl"

    # k_section26
    set k_section26 [gets $File]

    if {$k_section26 == 0} {
#   Nothing
    }

    if {$k_section26 == 1} {
    set i 1
    while {$i <= $numRibsHalf} {
        set DataLine [gets $File]
        # value0
        set glueVenA($i) [lindex $DataLine 0]
        # value1
        set glueVenB($i) [lindex $DataLine 1]
        incr i
        }
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadAirThickSectV2_52
#  Reads data for special wingtip section 27 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadSpecWtSectV2_52 {File} {
    source "globalWingVars.tcl"

    # k_section27
    set k_section27 [gets $File]

    # Wingtip type 0, do nothing
    if {$k_section27 == 0 } {
    #  Stop reading
    }

    # Wingtip type 1
    if {$k_section27 == 1 } {
    	set i 1
    	while {$i <= 2} {
        	set DataLine [gets $File]
        	# value0
        	set specWtA($i) [lindex $DataLine 0]
        	# value1
        	set specWtB($i) [lindex $DataLine 1]
        	incr i
    	}
    }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadAirThickSectV2_52
#  Reads data for calage variations section 28 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadCalagVarSectV2_52 {File} {
    source "globalWingVars.tcl"

    # k_section28
    set k_section28 [gets $File]

    # Calage variation type 0, do nothing
    if {$k_section28 == 0 } {
    #  Stop reading
    }

    # Calage variation type 1
    if {$k_section28 == 1 } {

    	# numCalagVar
    	set numRisersC [gets $File]

        # Points position %
        set DataLine [gets $File]
        	# value0
        	set calagVarA(1) [lindex $DataLine 0]
        	# value1
        	set calagVarB(1) [lindex $DataLine 1]
        	# value2
        	set calagVarC(1) [lindex $DataLine 2]
        	# value3
        	set calagVarD(1) [lindex $DataLine 3]
        	# value4
        	set calagVarE(1) [lindex $DataLine 4]
        	# value5
        	set calagVarF(1) [lindex $DataLine 5]
        	
    	# Speed-trim
        set DataLine [gets $File]
        	# value0
        	set speedVarA(1) [lindex $DataLine 0]
        	# value1
        	set speedVarB(1) [lindex $DataLine 1]
        	# value2
        	set speedVarC(1) [lindex $DataLine 2]
        	# value3
        	set speedVarD(1) [lindex $DataLine 3]

    }
    return [list 0 $File]
}




#----------------------------------------------------------------------
#  proc ReadAirThickSectV2_52
#  Reads data for 3D-Sphaping section 29 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadP3DShapingSectV2_52 {File} {
    source "globalWingVars.tcl"

    # k_section29
    set k_section29 [gets $File]

    # Case 0
    if {$k_section29 == 0 } {
    #  Stop reading
    set k_section29b 1
    set numGroups3DS(1) groups
    set numGroups3DS(2) 0

    # set values pp by default
    }

    # Case 1
    if {$k_section29 == 1 } {

    # k_section29b
    set k_section29b [gets $File]

    # Number of groups
    set DataLine [gets $File]
    set numGroups3DS(1) [lindex $DataLine 0]
    set numGroups3DS(2) [lindex $DataLine 1]

        # iterate in each group
    	set i 1
    	while {$i <= $numGroups3DS(2)} {
                # data line 1
        	set DataLine [gets $File]
        	set num3DS($i,1) [lindex $DataLine 0]
        	set num3DS($i,2) [lindex $DataLine 1]
        	set num3DS($i,3) [lindex $DataLine 2]
        	set num3DS($i,4) [lindex $DataLine 3]
                # data line 2
        	set DataLine [gets $File]
        	set num3DS($i,5) [lindex $DataLine 0]
        	set num3DS($i,6) [lindex $DataLine 1]
        	set num3DS($i,7) [lindex $DataLine 2]
                # read parameters extrados
                      set j 1
                      while {$j <= $num3DS($i,6)} {
                      set DataLine [gets $File]
        	      set line3DSu($i,$j,1) [lindex $DataLine 0]
        	      set line3DSu($i,$j,2) [lindex $DataLine 1]
        	      set line3DSu($i,$j,3) [lindex $DataLine 2]
        	      set line3DSu($i,$j,4) [lindex $DataLine 3]
                      incr j
                      }
                # data line 3
        	set DataLine [gets $File]
        	set num3DS($i,8) [lindex $DataLine 0]
        	set num3DS($i,9) [lindex $DataLine 1]
        	set num3DS($i,10) [lindex $DataLine 2]
                # read parameters intrados
                      set j 1
                      while {$j <= $num3DS($i,9)} {
                      set DataLine [gets $File]
        	      set line3DSl($i,$j,1) [lindex $DataLine 0]
        	      set line3DSl($i,$j,2) [lindex $DataLine 1]
        	      set line3DSl($i,$j,3) [lindex $DataLine 2]
        	      set line3DSl($i,$j,4) [lindex $DataLine 3]
                      incr j
                      }
                incr i
        }
                # read constant bloc of five lines
                      set DataLine [gets $File]
                      set j 1
                      while {$j <= 5} {
                      set DataLine [gets $File]
        	      set line3DSpp($j,1) [lindex $DataLine 0]
        	      set line3DSpp($j,2) [lindex $DataLine 1]
        	      set line3DSpp($j,3) [lindex $DataLine 2]
        	      set line3DSpp($j,4) [lindex $DataLine 3]
        	      set line3DSpp($j,5) [lindex $DataLine 4]
                      incr j
                      }
    }
    return [list 0 $File]
}


#----------------------------------------------------------------------
#  proc ReadAirThickSectV2_52
#  Reads data for airfoil thickness section 30 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadAirThickSectV2_52 {File} {
    source "globalWingVars.tcl"

    # k_section30
    set k_section30 [gets $File]

    if {$k_section30 == 0 } {
    #  Stop reading
    }

    if {$k_section30 == 1 } {
    	set i 1
    	while {$i <= $numRibsHalf} {
        	set DataLine [gets $File]
        	# value0
        	set airThickA($i) [lindex $DataLine 0]
        	# value1
        	set airThickB($i) [lindex $DataLine 1]
        	incr i
    	}
    }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadAirThickSectV2_52
#  Reads data for new skin tension section 31 of a lep data file
#  Applicable versions 3.14 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadNewSkinSectV2_52 {File} {
    source "globalWingVars.tcl"

    # k_section31
    set k_section31 [gets $File]

    # Case 0
    if {$k_section31 == 0 } {
    #  Stop reading
    set numGroupsNS 0
    }

    # Case 1
    if {$k_section31 == 1 } {

        # Number of groups
        set numGroupsNS [gets $File]

        # iterate in each group
    	set i 1
    	while {$i <= $numGroupsNS} {
                # comment line
                set Dataline [gets $File]
                # data line
        	set DataLine [gets $File]
        	set numNewSkin($i,1) [lindex $DataLine 0]
        	set numNewSkin($i,2) [lindex $DataLine 1]
        	set numNewSkin($i,3) [lindex $DataLine 2]
        	set numNewSkin($i,4) [lindex $DataLine 3]
        	set numNewSkin($i,5) [lindex $DataLine 4]
        # iterate in the number of points
        set j 1
    	while {$j <= $numNewSkin($i,4)} {
        	set DataLine [gets $File]
        	set lineNeSk($i,$j,1) [lindex $DataLine 0]
                set lineNeSk($i,$j,2) [lindex $DataLine 1]
                set lineNeSk($i,$j,3) [lindex $DataLine 2]
                set lineNeSk($i,$j,4) [lindex $DataLine 3]
                set lineNeSk($i,$j,5) [lindex $DataLine 4]
                incr j
        }
                incr i
    	}
    }
    return [list 0 $File]
}


#----------------------------------------------------------------------

proc Debug_rLDF { MessageString } {

    set debug_rLDF 0

    if { $debug_rLDF == 1 } {
        puts -nonewline $MessageString
    }

    return

}



