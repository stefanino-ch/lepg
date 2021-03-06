#---------------------------------------------------------------------
#
#  All code to run the preprocessor
#
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

    wm protocol .pprun WM_DELETE_WINDOW { OkButtonPress_pPR }

    wm title .pprun [::msgcat::mc "Run Geometry Processor"]

    #-------------
    #
    label  .pprun.status -width 80 -height 50 -background LightYellow  -justify left -textvariable Status
    button .pprun.ok -width 10 -text [::msgcat::mc "OK"] -command OkButtonPress_pPR

    grid .pprun.status -row 0 -column 0 -sticky nesw -padx 10 -pady 10
    grid .pprun.ok     -row 1 -column 0 -sticky e    -padx 10 -pady 10

    grid columnconfigure .pprun 0    -weight 1
    grid rowconfigure    .pprun 0    -weight 1
    grid rowconfigure    .pprun 1    -weight 0

    focus .pprun
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

    append Status [::msgcat::mc "txt_writeProcInputData"]
    append Status "\n"

    writePreProcDataFile "./process/pre-data.txt"

    append Status "...ok\n\n"
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

            set fid [open "|./process/runProc.bat $PreProcPathName" r+]

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

            append Status [::msgcat::mc "txt_findProcOutputFilesIn"]
        }
        unix {
            # PERE: in the line below runPre.bat must be exchanged with the name of a shell script
            # The shell script must be placed in the ./process Directory
            # If you look into rupPre.bat you will see what the shell script must do

            set fid [open "|./process/runPrelin.sh $PreProcPathName" r+]

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

            append Status [::msgcat::mc "txt_findProcOutputFilesIn"]
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
proc OkButtonPress_pPR {} {
    global .pprun
    destroy .pprun
    return 0
}
