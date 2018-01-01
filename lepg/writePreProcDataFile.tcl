
global Separator
set Separator "**********************************"

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
proc WriteFileHeader {File} {
    source "preProcFileConstants.tcl"
    global Separator

    puts $File $Separator
    puts $File "LEPARAGLIDING"
    puts -nonewline $File  $c_WingNameSectLbl
    puts $File "     v1.4"
    puts $File $Separator

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteWingName
#  Writes the wing name
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteWingName {File} {
    source "globalPreProcVars.tcl"

    puts $File $wingNamePreProc

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteLeadingEdge
#  Writes the leading edge section
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteLeadingEdge {File} {
    source "preProcFileConstants.tcl"
    source "globalPreProcVars.tcl"
    global Separator

    puts $File $Separator
    puts $File $c_LeadingESectLbl
    puts $File $Separator

    puts -nonewline $File "a1= "
    puts $File $a1LE

    puts -nonewline $File "b1= "
    puts $File $b1LE

    puts -nonewline $File "x1= "
    puts $File $x1LE

    puts -nonewline $File "xm= "
    puts $File $xmLE

    puts -nonewline $File "c0= "
    puts $File $c0LE

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteVault
#  Writes the vault section
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteVault {File} {
    source "preProcFileConstants.tcl"
    source "globalPreProcVars.tcl"
    global Separator

    puts $File $Separator
    puts $File $c_VaultSectLbl
    puts $File $Separator

    puts $File $vaultType

    if {$vaultType == 1} {
        # vault using ellipse and cosinus modification
        puts -nonewline $File "a1= "
        puts $File $a1Vault

        puts -nonewline $File "b1= "
        puts $File $b1Vault

        puts -nonewline $File "x1= "
        puts $File $x1Vault

        puts -nonewline $File "c1= "
        puts $File $c1Vault

    } else {
        # vault using four tangent circles
        foreach i {1 2 3 4} {
            puts -nonewline $File $radVault($i)
            puts -nonewline $File "\t"
            puts $File $angVault($i)
        }
    }
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteTrailingEdge
#  Writes the Trailling edge section
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteTrailingEdge {File} {
    source "preProcFileConstants.tcl"
    source "globalPreProcVars.tcl"
    global Separator

    puts $File $Separator
    puts $File $c_TrailingESectLbl
    puts $File $Separator

    puts -nonewline $File "a1= "
    puts $File $a1TE

    puts -nonewline $File "b1= "
    puts $File $b1TE

    puts -nonewline $File "x1= "
    puts $File $x1TE

    puts -nonewline $File "xm= "
    puts $File $xmTE

    puts -nonewline $File "c0= "
    puts $File $c0TE

    puts -nonewline $File "y0= "
    puts $File $y0TE

    return [list 0 $File]
}


#----------------------------------------------------------------------
#  WriteCellsDistrib
#  Writes the cells distribution section
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteCellsDistrib {File} {
    source "preProcFileConstants.tcl"
    source "globalPreProcVars.tcl"
    global Separator

    puts $File $Separator
    puts $File $c_CellsDistrSectLbl
    puts $File $Separator

    puts $File $cellDistrType
    puts $File $cellDistrCoeff
    puts $File $numCellsPreProc

    return [list 0 $File]
}



#----------------------------------------------------------------------
#  writePreProcDataFile
#  Writes the Pre Processor data file
#
# IN:   FilePathName    Full path and name of file
# OUT:  -1 : file not writeable
#        0 : all cool file read, data should be available
#----------------------------------------------------------------------
proc writePreProcDataFile {FilePathName} {
    set ReturnValue -1

    if {[catch {set File [open $FilePathName w]}] == 0} {
        # puts "All cool file is open"
    } else {
        # puts "Could not open file."
        return -1
    }

    # File header
    lassign [WriteFileHeader $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    # Wing name
    lassign [WriteWingName $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    # Leading edge
    lassign [WriteLeadingEdge $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    # Trailing Edge
    lassign [WriteTrailingEdge $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    # vault
    lassign [WriteVault $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    # CellsDistrib
    lassign [WriteCellsDistrib $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }


    flush $File
    close $File

    set ReturnValue 0
    return $ReturnValue
}
