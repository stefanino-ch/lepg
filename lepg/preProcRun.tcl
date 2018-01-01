#-------
# Globals
global .pprun

global lcl_PreProcBatchPathName

set Status ""

#----------------------------------------------------------------------
#  PreProcRun
#  Runs the PreProc and displays the output data
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc PreProcRun {} {
    global lcl_PreProcBatchPathName
    global Status

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

    run
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

proc run {} {
    global Status
    set Status ""
    set PreProc [dict get $::GlobalConfig PreProcBatchPathName]

    set fid [open "|$PreProc" r+]

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
