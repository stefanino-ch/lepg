#---------------------------------------------------------------------
#
#  All code to run the lep processor
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global Status_lPR


global AirfoilDefinitionsReady


#----------------------------------------------------------------------
#  lepProcRun
#  Runs the PreProc and displays the output data
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc lepProcRun {} {
    global Status_lPR
    global AirfoilDefinitionsReady

    set Status_lPR ""
    set AirfoilDefinitionsReady 0

    CreateLepProcRunWindow

    if { $AirfoilDefinitionsReady == 1 } {
        PrepareLepProcData

        DoLepProcRun
    }
}

#----------------------------------------------------------------------
#  CreateLepProcRunWindow
#  Creates the window in which the processing messages are displayed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateLepProcRunWindow {} {
    global Status_lPR
    global AirfoilDefinitionsReady

    toplevel .lPR
    focus .lPR

    wm protocol .lPR WM_DELETE_WINDOW { OkButtonPress_lPR }

    wm title .lPR [::msgcat::mc "Run lep Processor"]

    #-------------
    #
    label  .lPR.status_lPR -width 80 -height 50 -background LightYellow  -justify left -textvariable Status_lPR
    button .lPR.ok -width 10 -text [::msgcat::mc "OK"] -command OkButtonPress_lPR

    grid .lPR.status_lPR -row 0 -column 0 -sticky nesw -padx 10 -pady 10
    grid .lPR.ok     -row 1 -column 0 -sticky e    -padx 10 -pady 10

    grid columnconfigure .lPR 0    -weight 1
    grid rowconfigure    .lPR 0    -weight 1
    grid rowconfigure    .lPR 1    -weight 0

 #   set answer [tk_messageBox -title [::msgcat::mc "Copy data"] \
                -type okcancel -icon warning \
                -message [::msgcat::mc "txt_copyAirfoilFiles" ] ]
   # if { $answer == "cancel" } {
    #    focus .lPR
     #   append Status_lPR [::msgcat::mc "Calculation aborted.\n"]
      #  return 0
    #}

    set AirfoilDefinitionsReady 1
    focus .lPR
}

#----------------------------------------------------------------------
#  PrepareLepProcData
#  Writest the lep data file into the /process directory
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc PrepareLepProcData {} {
    global Status_lPR

    source "writeWingDataFile.tcl"

    append Status_lPR [::msgcat::mc "txt_writeProcInputData"]
    append Status_lPR "\n"

    writeWingDataFile "./process/leparagliding.txt"

    append Status_lPR "...ok\n\n"
}

#----------------------------------------------------------------------
#  DoLepProcRun
#  Executes the lep processor
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DoLepProcRun {} {
    global Status_lPR
    set LepPathName [dict get $::GlobalConfig LepPathName]

    # here we need some platform specific code
    switch $::tcl_platform(platform) {
        windows {

            set fid [open "|./process/runProc.bat $LepPathName" r+]

            fconfigure $fid -buffering line
            while {[gets $fid line] != -1} {
                # gets returns -1 if it encounters the end of output from the program.
                # If it returns > -1, then we've read a line of output and the characters
                # are stored in the variable "line".

                # Process the line read as desired...
                append Status_lPR $line
                append Status_lPR "\n"
            }
            # Close our side of the pipe when we're done
            close $fid

            append Status_lPR [::msgcat::mc "txt_findProcOutputFilesIn"]
        }
        unix {
            # PERE: in the line below runPre.bat must be exchanged with the name of a shell script
            # The shell script must be placed in the ./process Directory
            # If you look into rupPre.bat you will see what the shell script must do

            set fid [open "|./process/runPrelin.sh $LepPathName" r+]

            fconfigure $fid -buffering line
            while {[gets $fid line] != -1} {
                # gets returns -1 if it encounters the end of output from the program.
                # If it returns > -1, then we've read a line of output and the characters
                # are stored in the variable "line".

                # Process the line read as desired...
                append Status_lPR $line
                append Status_lPR "\n"
            }
            # Close our side of the pipe when we're done
            close $fid

            append Status_lPR [::msgcat::mc "txt_findProcOutputFilesIn"]
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
proc OkButtonPress_lPR {} {
    global .lPR
    destroy .lPR
    return 0
}
