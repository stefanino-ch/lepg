#---------------------------------------------------------------------
#
#  Some helpers used for file import
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#----------------------------------------------------------------------
#  proc jumpToSection
#  Moves file pointer to a specific line
#
#  IN:  SectionId   Section id string to point to
#       Offset      0: for new style file version
#                   1: for old style file versions
#       File        File pointer
#  OUT: File        File pointer
#----------------------------------------------------------------------
proc jumpToSection {SectionId Offset File} {

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
        incr IterationNum
    }

    # SectionId not found
    return [list -1 $File]
}
