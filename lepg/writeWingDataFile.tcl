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
    # source "preProcFileConstants.tcl"
    global Separator

    puts $File $Separator
    puts $File "LEPARAGLIDING"
    # puts -nonewline $File  $c_WingNameSect_pPFC_Lbl
    puts $File "     v1.4"
    puts $File $Separator

    return [list 0 $File]
}

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
    lassign [WriteFileHeader $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    flush $File
    close $File

    set ReturnValue 0
    return $ReturnValue
}
