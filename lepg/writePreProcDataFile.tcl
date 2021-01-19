#---------------------------------------------------------------------
#
#  Writes the data file for the preprocessor
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
    puts -nonewline $File  $c_WingNameSect_pPFC_Lbl
    puts $File "     v1.6"
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
    puts $File $c_LeadingESect_pPFC_Lbl
    puts $File $Separator

    puts $File $typeLE

    puts -nonewline $File "a1= "
    puts $File $a1LE

    puts -nonewline $File "b1= "
    puts $File $b1LE

    puts -nonewline $File "x1= "
    puts $File $x1LE

    puts -nonewline $File "x2= "
    puts $File $x2LE

    puts -nonewline $File "xm= "
    puts $File $xmLE

    puts -nonewline $File "c01= "
    puts $File $c01LE

    puts -nonewline $File "ex1= "
    puts $File $ex1LE

    puts -nonewline $File "c02= "
    puts $File $c02LE

    puts -nonewline $File "ex2= "
    puts $File $ex2LE

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
    puts $File $c_VaultSect_pPFC_Lbl
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
    puts $File $c_TrailingESect_pPFC_Lbl
    puts $File $Separator

    puts $File $typeTE

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

    puts -nonewline $File "ex1= "
    puts $File $ex1TE


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
    puts $File $c_CellsDistrSect_pPFC_Lbl
    puts $File $Separator

    puts $File $cellDistrType

    # Case 1
    if { $cellDistrType == 1 } {
    puts $File $numCellsPreProc
    }

    # Case 2
    if { $cellDistrType == 2 } {
    puts $File $cellDistrCoeff
    puts $File $numCellsPreProc
    }

    # Case 3
    if { $cellDistrType == 3 } {
    puts $File $cellDistrCoeff
    puts $File $numCellsPreProc
    }

    # Case 4
    if { $cellDistrType == 4 } {
    puts $File $numRibsHalfPre
    set i 1
    while { $i <= $numRibsHalfPre  } {
    puts -nonewline $File $i
    puts            $File $cellsWidth($i,2)
    incr i
    }
    }

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
