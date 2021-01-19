
#----------------------------------------------------------------------
#  DetectFileVersion
#  Determines version of the pre proc data file to be read
#  IN:      FilePathName    Full path and name of file
#  OUT:     -1 : file not available or not readable
#           x.y : version string
#----------------------------------------------------------------------
proc DetectFileVersion {FilePathName} {
    source "preProcFileConstants.tcl"

    if {[catch {set file [open $FilePathName]}] == 0} {
        # puts "All cool file is open"
    } else {
        # puts "Could not open file."
        return -1
    }

    # check first for the data files <= 1.4
    set i 1
    while {$i <= 10} {
        set DataLine [gets $file]
        # The default 1.3 file has a version indicator in the header
        if { [string first "1.3" $DataLine] >= 0 } {
            close $file
            return "1.3"
        }
        # The default 1.4 file has a version indicator in the header
        if { [string first "1.4" $DataLine] >= 0 } {
            close $file
            return "1.4"
        }
        # The default 1.5 file has a version indicator in the header
        if { [string first "1.5" $DataLine] >= 0 } {
            close $file
            return "1.5"
        }
        # The default 1.6 file has a version indicator in the header
        if { [string first "1.6" $DataLine] >= 0 } {
            close $file
            return "1.6"
        }

        incr i
    }

    # Check for data files >1.4
    # First ten lines are read, start from scratch
    seek $file 0 start

    set i 1
    while {$i <= 20} {
        set DataLine [gets $file]
        if { [string first $c_VersionSectId $DataLine] >= 0 } {
            # file version >1.4
            set DataLine [gets $file]
            set FileVersion [lindex $DataLine 1]
            close $file
            return $FileVersion
        }
        incr i
    }

    # If we arrive here something in the files is definitily wrong
    close $file
    return "-1"
}

#----------------------------------------------------------------------
#  readPreProcDataFile
#  Reads the Pre Processor data file
#
# IN:   FilePathName    Full path and name of file
# OUT:  -1 : file not available or unsupported version
#        0 : all cool file read, data should be available
#----------------------------------------------------------------------
proc readPreProcDataFile {FilePathName} {
    source "preProcFileConstants.tcl"
    source "fileReadHelpers.tcl"

    set ReturnValue -1

    # Check what file version to be read
    set FileVersion [DetectFileVersion $FilePathName]


    # open data file
    # as we know the version number=> file is there and readable=> we don't need to do error handling anymore
    set File [open $FilePathName r+]

    # setup the suffix
    if { $FileVersion <= 1.6 } {
        set Suffix "Lbl"
        set Offset 1
    } else {
        set Suffix "Id"
        set Offset 0
    }

    #---------
    # Wing name
    lassign [jumpToSection [set c_WingNameSect_pPFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadWingNameSect $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #---------
    # Leading edge parameters
    lassign [jumpToSection [set c_LeadingESect_pPFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadLeadingEdgeSect $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------
    # Trailing edge parameters
    lassign [jumpToSection [set c_TrailingESect_pPFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadTrailingEdgeSect $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------
    # Vault
    lassign [jumpToSection [set c_VaultSect_pPFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadVaultSect $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------
    # Cells distribution
    lassign [jumpToSection [set c_CellsDistrSect_pPFC_$Suffix] $Offset $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }
    lassign [ReadCellsDistribSect $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #----------
    # Well read
    close $File
    return 0
}

#----------------------------------------------------------------------
#  proc ReadWingNameSect
#  Reads the wing name a pre processor data file
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global pre processor variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadWingNameSect {File} {
    source "globalPreProcVars.tcl"

    set wingNamePreProc [gets $File]

    # DEBUG code
    if {$EnableDebugPreProc} {DebugVariable wingNamePreProc}
    # end DEBUG code

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadLeadingEdgeSect
#  Reads the leading edge section of a pre processor data file
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global pre processor variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadLeadingEdgeSect {File} {
    source "globalPreProcVars.tcl"

    set DataLine  [gets $File]
    set typeLE [lindex $DataLine 0]

    set DataLine  [gets $File]
    set a1LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set b1LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set x1LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set x2LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set xmLE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set c01LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set ex1LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set c02LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set ex2LE [lindex $DataLine 1]


    # DEBUG code
    if {$EnableDebugPreProc} {DebugVariable typeLE}
    if {$EnableDebugPreProc} {DebugVariable a1LE}
    if {$EnableDebugPreProc} {DebugVariable b1LE}
    if {$EnableDebugPreProc} {DebugVariable x1LE}
    if {$EnableDebugPreProc} {DebugVariable xmLE}
    if {$EnableDebugPreProc} {DebugVariable c01LE}
    if {$EnableDebugPreProc} {DebugVariable ex1LE}
    if {$EnableDebugPreProc} {DebugVariable c02LE}
    if {$EnableDebugPreProc} {DebugVariable ex2LE}
    # end DEBUG code

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadTrailingEdgeSect
#  Reads the trailing edge section of a pre processor data file
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global pre processor variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadTrailingEdgeSect {File} {
    source "globalPreProcVars.tcl"

    set DataLine  [gets $File]
    set typeTE [lindex $DataLine 0]

    set DataLine  [gets $File]
    set a1TE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set b1TE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set x1TE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set xmTE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set c0TE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set y0TE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set ex1TE [lindex $DataLine 1]

    # DEBUG code
    if {$EnableDebugPreProc} {DebugVariable typeTE}
    if {$EnableDebugPreProc} {DebugVariable a1TE}
    if {$EnableDebugPreProc} {DebugVariable b1TE}
    if {$EnableDebugPreProc} {DebugVariable x1TE}
    if {$EnableDebugPreProc} {DebugVariable xmTE}
    if {$EnableDebugPreProc} {DebugVariable c0TE}
    if {$EnableDebugPreProc} {DebugVariable y0TE}
    if {$EnableDebugPreProc} {DebugVariable ex1TE}
    # end DEBUG code

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadVaultSect
#  Reads the vault section of a pre processor data file
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global pre processor variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadVaultSect {File} {
    source "globalPreProcVars.tcl"

    # detect vault type used
    set vaultType  [gets $File]
    # DEBUG code
    if {$EnableDebugPreProc} {DebugVariable vaultType}
    # end DEBUG code

    if { $vaultType == 1 } {
        # Type 1 => read four single values
        set a1Vault  [gets $File]
        set b1Vault  [gets $File]
        set x1Vault  [gets $File]
        set c1Vault  [gets $File]

        # DEBUG code
        if {$EnableDebugPreProc} {DebugVariable a1Vault}
        if {$EnableDebugPreProc} {DebugVariable b1Vault}
        if {$EnableDebugPreProc} {DebugVariable x1Vault}
        if {$EnableDebugPreProc} {DebugVariable c1Vault}
        # end DEBUG code
    } else {
        # Type 2 => read four pairs raduis - angle

        set i 1
        while {$i <= 4} {
            set DataLine [gets $File]
            set radVault($i) [lindex $DataLine 0]
            set angVault($i) [lindex $DataLine 1]

            # DEBUG code
            if {$EnableDebugPreProc} {DebugVariable radVault($i)}
            if {$EnableDebugPreProc} {DebugVariable angVault($i)}
            # end DEBUG code

            incr i
        }
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc ReadCellsDistribSect
#  Reads the cells distribution section of a lep data file
#
#  IN:  File            Pointer to the first data line of the data section
#  OUT:                 Global Wing variables set with file values
#       ReturnValue1    0 : parameters loaded
#                       -1: problem during parameter loading
#       ReturnValue2    Pointer to the first data line after the data section
#----------------------------------------------------------------------
proc ReadCellsDistribSect {File} {
    source "globalPreProcVars.tcl"

    set cellDistrType [gets $File]

    # Case 1
    if { $cellDistrType == 1 } {
        set numCellsPreProc  [gets $File]
    }

    # Case 2
    if { $cellDistrType == 2 } {
        set cellDistrCoeff [gets $File]
        set numCellsPreProc  [gets $File]
    }

    # Case 3
    if { $cellDistrType == 3 } {
        set cellDistrCoeff [gets $File]
        set numCellsPreProc  [gets $File]
    }

    # Case 4
    if { $cellDistrType == 4 } { 
        set numRibsHalfPre  [gets $File]

        set semi_span 0.0
        set i 1
        while { $i <= $numRibsHalfPre } {
            set Dataline [gets $File]
            set cellsWidth($i,2) [lindex $Dataline 1]
            set semi_span [expr ($semi_span + $cellsWidth($i,2))]

#       puts "$i $cellsWidth($i,2)"

            incr i
        }
    # Normalize because semi_span != XM (!)
    }

    # DEBUG code
    if {$EnableDebugPreProc} {DebugVariable cellDistrType}
    if {$EnableDebugPreProc} {DebugVariable cellDistrCoeff}
    if {$EnableDebugPreProc} {DebugVariable numCellsPreProc}
    # end DEBUG code

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  proc
#
#  IN:
#  OUT:
#----------------------------------------------------------------------
proc DebugVariable { Variable } {
    source "globalPreProcVars.tcl"
    puts "$Variable\t:\t[set $Variable]"
}
