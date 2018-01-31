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

    source "preProcOutFileConstants.tcl"
    source "fileReadHelpers.tcl"

    set ReturnValue -1

    # Check what file version to be read
    set FileVersion [DetectFileVersion_pPOFI $FilePathName]

    # open data file
    # as we know the version number=> file is there and readable=> we don't need to do error handling anymore
    set File [open $FilePathName r+]

    # setup the suffix
    if { $FileVersion == 1.4 } {
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
        set DataLine [gets $file]
        # The default 1.4 file has a version indicator in the header
        if { [string first "1.4" $DataLine] >= 0 } {
            close $file
            return "1.4"
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

    # Read the column titles
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

    # NumCells
    set DataLine  [gets $File]
    set numCells  [lindex $DataLine 1]

    # in between line
    set DataLine  [gets $File]

    # number of ribs
    set DataLine  [gets $File]
    set numRibsTot [lindex $DataLine 3]
    set numRibsTot [expr $numRibsTot * 2]

    return [list 0 $File]
}
