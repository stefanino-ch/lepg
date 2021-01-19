#---------------------------------------------------------------------
#
#  All code to import an output file of the preprocessor containing
#  the wing geometry.
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# Constant values
#---------------------------------------------------------------------

#----------------------------------------------------------------------
#  importPreProcOutFile
#  Method to be called to import a preproc output file
#
#  IN:      FilePathName    Full path and name of the file to import
#  OUT:     N/A
#  Returns: 0               If import was successful
#           -1              Upon a problem
#----------------------------------------------------------------------
proc importPreProcOutFile {FilePathName} {

#    puts "Filename $FilePathName"

    source "preProcOutFileConstants.tcl"
    source "fileReadHelpers.tcl"

    set ReturnValue -1

    # Check what file version to be read
    set FileVersion [DetectFileVersion_pPOFI $FilePathName]

    puts "FileV $FileVersion"

    # open data file
    # as we know the version number=> file is there and readable=> we don't need to do error handling anymore
    set File [open $FilePathName r+]

    # setup the suffix
    if { $FileVersion == 1.6 } {
        set Suffix "Lbl"
        set Offset 1
    } else {
        # unknown file version received
        return -1
    }

    #---------
    # Main Geometry
    lassign [jumpToSection [set c_MainGeometrySect_pPOFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadMainGeometrySectV1_4 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #---------
    # Matrix of Geometry
    lassign [jumpToSection [set c_GeometrySect_pPOFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadGeometrySectV1_4 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

#    WARNIG: No initialize other variables!!!
#    InitializeOtherWingVars

    return 0
}

#----------------------------------------------------------------------
#  DetectFileVersion_pPOFI
#  Tries to detect the version of the preprocessor who has created the file
#
#  IN:      FilePathName    Full path and name of the file to import
#  OUT:     N/A
#  Returns: File version    If detcted
#           -1              Upon problems
#----------------------------------------------------------------------
proc DetectFileVersion_pPOFI {FilePathName} {

    if {[catch {set file [open $FilePathName]}] == 0} {
        # puts "All cool file is open"
    } else {
        # puts "Could not open file."
        return -1
    }

    # check first for the 1.4 data file
    set i 1
    while {$i <= 10} {
        #set DataLine [gets $file]
        # The default 1.4 file has a version indicator in the header
        #if { [string first "1.4" $DataLine] >= 0 } {
        #    close $file
        #    return "1.4"
        #}
        incr i
    }

    # check for the 1.5 data file
    set i 1
    while {$i <= 10} {
        #set DataLine [gets $file]
        # The default 1.4 file has a version indicator in the header
        #if { [string first "1.5" $DataLine] >= 0 } {
        #    close $file
        #    return "1.5"
        #}
        incr i
    }

    # check for the 1.6 data file
    # Number 40??? WARNING BECAUSE SOME GEOMETRIES WILL BE NOT OPEN!!!
    set i 1
    while {$i <= 40} {
        set DataLine [gets $file]
        # The default 1.6 file has a version indicator in the header
        if { [string first "1.6" $DataLine] >= 0 } {
            close $file
            return "1.6"
        }
        incr i
    }


    # no valid file version found
    return -1
}

#----------------------------------------------------------------------
#  ReadGeometrySectV1_4
#  Reads the Geometry section of a preprocessor output file
#  Applicable versions 1.4 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadGeometrySectV1_4 {File} {
    source "globalWingVars.tcl"

    global numRibsHalf

    # Read the column titles
    set DataLine [gets $File]

    # NumRibsHalf
    set numRibsHalf [expr ceil($numRibsTot/2)]
    # Erase ".0" at the end of string
    set l [string length $numRibsHalf]
    # NumberRibs
    set numRibsHalf [string range $numRibsHalf 0 [expr $l-3]]

    puts "NumRibsHalf $numRibsHalf"

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

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  ReadMainGeometrySectV1_4
#  Reads the Main Geometry section of a preprocessor output file
#  Applicable versions 1.4 ...
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadMainGeometrySectV1_4  {File} {

    source "globalWingVars.tcl"

    # parameter necessary to set new default global values
    set numRibsHalfPrev $numRibsHalf

    # NumCells
    set DataLine  [gets $File]
    set numCells  [lindex $DataLine 1]

    # detect if there is an even or odd number of cells
    set DataLine  [gets $File]
    set EvenOdd   [lindex $DataLine 0]

    # New procedure (2021-01-11)
    set numRibsTot [expr ($numCells +1)]

    if { $EvenOdd == 0 } {
    # Even number of cells
    set numRibsHalfNew [expr ($numCells / 2)]
    }

    if { $EvenOdd == 1 } {
    # Even number of cells
    set numRibsHalfNew [expr (($numCells + 1) / 2)]
    }

    # Initialize new variables
    if { $numRibsHalfPrev < $numRibsHalfNew } {

       source "InitializeNewVarsNewCells.tcl"
       InitializeNVNC

    }

    set numRibsHalf $numRibsHalfPrev


    return [list 0 $File]
}

#----------------------------------------------------------------------
#  InitializeOtherWingVars
#  Initializes all Wing variables not yet set by the import, but after
#  wards needed to further define the wing.
#
#  IN:  n/a
#  OUT: n/a
#----------------------------------------------------------------------
proc InitializeOtherWingVars {} {

    global numRibsHalf
    global airfoilName
    global ribConfig
    global airfConfigNum
    global strainMiniRibs
    global numStrainPoints
    global strainCoef
    global lineMode
    global numLinePlan
    global numBrakeLinePath
    global brakeDistr
    global lineLength
    global ramLength
    global numMiniRibs
    global miniRibXSep
    global miniRibYSep
    global numLeCol
    global numTeCol
    global numAddRipPo
    global numDXFLayNa
    global loadDistr
    global loadDeform

    # Airfoils
    source "globalWingVars.tcl"

    global Lcl_ribConfig
    global Lcl_airfoilName

    for {set i 1} {$i <= $numRibsHalf} {incr i} {
        # Airfoil filenames
        set airfoilName($i) ""

        foreach j {1 11 12 14 15 16 17 18 19 20 21 50 22 56} {
            set ribConfig($i,$j) 0
        }
    }

    # Airfoil holes
    set airfConfigNum 0

    # Skin tension
    set strainMiniRibs 0.0114
    set numStrainPoints 1000
    set strainCoef 1.0

    # Suspension lines
    set lineMode 0
    set numLinePlan 0

    # Brake lines
    set numBrakeLinePath 0
    for {set i 1} {$i <= 2} {incr i} {
        for {set j 1} {$j <= 5} {incr j} {
            set brakeDistr($i,$j) 0
        }
    }

    # Ramification lengths
    set ramLength(3,1) 0
    set ramLength(3,3) 0
    set ramLength(4,1) 0
    set ramLength(4,3) 0
    set ramLength(4,4) 0
    set ramLength(5,1) 0
    set ramLength(5,3) 0
    set ramLength(6,1) 0
    set ramLength(6,3) 0
    set ramLength(6,4) 0

    # HV- VH Ribs
    set numMiniRibs 0
    set miniRibXSep 80
    set miniRibYSep 150

    # Leading edge Colors
    set numLeCol 0

    # Trailing edge Colors
    set numTeCol 0

    # Additional rib points
    set numAddRipPo 0

    # Elastic lines correction
    set loadDistr(1,1) 0
    set loadDistr(1,2) 0
    set loadDistr(2,1) 0
    set loadDistr(2,2) 0
    set loadDistr(2,3) 0
    set loadDistr(3,1) 0
    set loadDistr(3,2) 0
    set loadDistr(3,3) 0
    set loadDistr(3,4) 0
    set loadDistr(4,1) 0
    set loadDistr(4,2) 0
    set loadDistr(4,3) 0
    set loadDistr(4,4) 0
    set loadDistr(4,5) 0

    for {set i 1} {$i <=5} {incr i} {
        set loadDeform($i,1) 0
        set loadDeform($i,2) 0
        set loadDeform($i,3) 0
        set loadDeform($i,4) 0
    }
}

    # DXF layer names
    set numDXFLayNa 0

