
#----------------------------------------------------------------------
#  proc DetectFileVersion
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
#  proc JumpToSection
#  Moves file pointer to a specific line
#
#  IN:  SectionId   Section id string to point to
#       Offset      0: for file versions >1.4
#                   1: for file versions <= 1.4
#       File        File pointer
#  OUT: File        File pointer
#----------------------------------------------------------------------
proc JumpToSection {SectionId Offset File} {

    set IterationNum 1

    # Seek from the current position until file end. If data file is read in
    # sequencially only a fer reads should be needed

    while {$IterationNum <= 2} {
        while { [gets $File DataLine] >= 0 } {
            if { [string first $SectionId $DataLine] >= 0 } {
                # section id found and read
                # file pointer stays on first data line

                if {$Offset == 1} {
                    # read an additional data line in old files
                    gets $File DataLine
                }

                return [list 0 $File]
            }
        }

        # If we arrive here File is potentially not read in the regular
        # sequence. Reset file pointer and read again from start

        # Set file pointer to the start of the file
        seek $File 0 start
        inc IterationNum
    }

    # SectionId not found
    return [list -1 $File]
}

#----------------------------------------------------------------------
#  proc readPreProcDataFile
#  Reads the Pre Processor data file
#
# IN:   FilePathName    Full path and name of file
# OUT:  -1 : file not available or unsupported version
#        0 : all cool file read, data should be available
#----------------------------------------------------------------------
proc readPreProcDataFile {FilePathName} {

    set ReturnValue -1

    # Check what file version to be read
    set FileVersion [DetectFileVersion $FilePathName]

    source "preProcFileConstants.tcl"
    # open data file
    # as we know the version number=> file is there and readable=> we don't need to do error handling anymore
    set File [open $FilePathName r+]

    # setup the suffix
    if { $FileVersion <= 1.4 } {
        set Suffix "Lbl"
        set Offset 1
    } else {
        set Suffix "Id"
        set Offset 0
    }

    #---------
    # Wing name
    lassign [JumpToSection [set c_WingNameSect$Suffix] $Offset $File] ReturnValue File
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
    lassign [JumpToSection [set c_LeadingESect$Suffix] $Offset $File] ReturnValue File
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
    lassign [JumpToSection [set c_TrailingESect$Suffix] $Offset $File] ReturnValue File
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
    lassign [JumpToSection [set c_VaultSect$Suffix] $Offset $File] ReturnValue File
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
    lassign [JumpToSection [set c_CellsDistrSect$Suffix] $Offset $File] ReturnValue File
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
    set a1LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set b1LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set x1LE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set xmLE [lindex $DataLine 1]

    set DataLine  [gets $File]
    set c0LE [lindex $DataLine 1]

    # DEBUG code
    if {$EnableDebugPreProc} {DebugVariable a1LE}
    if {$EnableDebugPreProc} {DebugVariable b1LE}
    if {$EnableDebugPreProc} {DebugVariable x1LE}
    if {$EnableDebugPreProc} {DebugVariable xmLE}
    if {$EnableDebugPreProc} {DebugVariable c0LE}
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

    # DEBUG code
    if {$EnableDebugPreProc} {DebugVariable a1TE}
    if {$EnableDebugPreProc} {DebugVariable b1TE}
    if {$EnableDebugPreProc} {DebugVariable x1TE}
    if {$EnableDebugPreProc} {DebugVariable xmTE}
    if {$EnableDebugPreProc} {DebugVariable c0TE}
    if {$EnableDebugPreProc} {DebugVariable y0TE}
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
    set cellDistrCoeff [gets $File]
    set numCellsPreProc  [gets $File]

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
