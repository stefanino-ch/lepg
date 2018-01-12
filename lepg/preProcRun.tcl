#---------------------------------------------------------------------
#
#  All code to run the preprocessor
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global .pprun
set Status ""

#----------------------------------------------------------------------
#  PreProcRun
#  Runs the PreProc and displays the output data
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc preProcRun {} {
    global Status
    set Status ""

    CreatePreProcRunWindow

    PreparePreProcData

    DoPreProcRun
}

#----------------------------------------------------------------------
#  CreatePreProcRunWindow
#  Creates the window in which the processing messages are displayed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreatePreProcRunWindow {} {
    toplevel .pprun
    focus .pprun

    wm protocol .pprun WM_DELETE_WINDOW { OkButtonPress }

    wm title .pprun [::msgcat::mc "Run Geometry Processor"]

    #-------------
    #
    label  .pprun.status -width 80 -height 40 -background LightYellow  -justify left -textvariable Status
    button .pprun.ok -width 10 -text "OK" -command OkButtonPress

    grid .pprun.status -row 0 -column 0 -sticky nesw -padx 10 -pady 10
    grid .pprun.ok     -row 1 -column 0 -sticky e    -padx 10 -pady 10

    grid columnconfigure .pprun 0    -weight 1
    grid rowconfigure    .pprun 0    -weight 1
    grid rowconfigure    .pprun 1    -weight 0
}

#----------------------------------------------------------------------
#  PreparePreProcData
#  Writest the preprocessor data file into the /process directory
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc PreparePreProcData {} {
    global Status

    source "writePreProcDataFile.tcl"

    append Status "Writing input data for processor...\n"

    writePreProcDataFile "./process/pre-data.txt"

    append Status "...done\n\n"
}

#----------------------------------------------------------------------
#  DoPreProcRun
#  Executes the preprocessor
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DoPreProcRun {} {
    global Status
    set PreProcPathName [dict get $::GlobalConfig PreProcPathName]

    # here we need some platform specific code
    switch $::tcl_platform(platform) {
        windows {

            set fid [open "|./process/runPre.bat $PreProcPathName" r+]

            fconfigure $fid -buffering line
            while {[gets $fid line] != -1} {
                # gets returns -1 if it encounters the end of output from the program.
                # If it returns > -1, then we've read a line of output and the characters
                # are stored in the variable "line".

                # Process the line read as desired...
                append Status $line
                append Status "\n"
            }
            # Close our side of the pipe when we're done
            close $fid
        }
        default {
            tk_messageBox -title [::msgcat::mc "Sorry"] -message [::msgcat::mc "Sorry, but there is some platform specific code missing."] -icon info -type ok -default ok
        }
    }


}

#----------------------------------------------------------------------
#  OkButtonPress
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress {} {
    global .pprun
    destroy .pprun
    return 0
}
