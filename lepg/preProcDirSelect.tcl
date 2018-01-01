#-------
# Globals
global .ppds

global lcl_PreProcPathName
global lcl_PreProcBatchPathName

set g_LclPreProcDirDataChanged 0

set g_LclPreProcDirDataNotApplied 0


#----------------------------------------------------------------------
#  PreProcDirSelect
#  Displays the current configuration, allows to setup a new path if needed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc PreProcDirSelect {} {
    global lcl_PreProcPathName
    global lcl_PreProcBatchPathName

    SetLclVars

    toplevel .ppds
    focus .ppds

    wm protocol .ppds WM_DELETE_WINDOW { CancelButtonPress }

    wm title .ppds [::msgcat::mc "Setup Geometry Processor"]

    #-------------
    # Frames and grids
    ttk::labelframe .ppds.name -text [::msgcat::mc "Geometry Processor"]
    ttk::frame .ppds.btn

    grid .ppds.name         -row 0 -column 0 -sticky e
    grid .ppds.btn          -row 2 -column 0 -sticky e

    grid columnconfigure .ppds 0    -weight 0
    grid rowconfigure .ppds 0       -weight 0
    grid rowconfigure .ppds 1       -weight 0
    grid rowconfigure .ppds 2       -weight 0

    #-------------
    # Geometry Processor setup
    ttk::label .ppds.name.name -text [::msgcat::mc "Geometry Processor"] -width 20
    ttk::entry .ppds.name.e_name -width 60 -textvariable lcl_PreProcPathName
    ttk::entry .ppds.name.b_name -width 60 -textvariable lcl_PreProcBatchPathName

    button .ppds.name.change -width 10 -text [::msgcat::mc "Change..."] -command ChangeButtonPress

    grid .ppds.name.name -row 0 -column 0 -sticky e
    grid .ppds.name.e_name -row 0 -column 1 -sticky w -padx 10 -pady 0

    grid .ppds.name.change -row 0 -column 2 -sticky w
    grid .ppds.name.b_name -row 1 -column 1 -sticky w -padx 10 -pady 10

    #-------------
    # buttons
    button .ppds.btn.apply -width 10 -text "Apply" -command ApplyButtonPress
    button .ppds.btn.ok -width 10 -text "OK" -command OkButtonPress
    button .ppds.btn.cancel -width 10 -text "Cancel" -command CancelButtonPress
    button .ppds.btn.help -width 10  -text "Help" -command HelpButtonPress

    grid .ppds.btn.apply -row 0 -column 0 -sticky e -padx 10 -pady 0
    grid .ppds.btn.ok -row 0 -column 1 -sticky e -padx 10 -pady 0
    grid .ppds.btn.cancel -row 0 -column 2 -sticky e -padx 10 -pady 0
    grid .ppds.btn.help -row 1 -column 2 -sticky e -padx 10 -pady 20
}

#----------------------------------------------------------------------
#  SetLclVars
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars {} {
    global lcl_PreProcPathName
    global lcl_PreProcBatchPathName

    global g_LclPreProcDirDataChanged
    global g_LclPreProcDirDataNotApplied

    set lcl_PreProcPathName         [dict get $::GlobalConfig PreProcPathName]
    set lcl_PreProcBatchPathName    [dict get $::GlobalConfig PreProcBatchPathName]

    set g_LclPreProcDirDataChanged     0
    set g_LclPreProcDirDataNotApplied  0
}

#----------------------------------------------------------------------
#  ExportLclVars
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars {} {
    global lcl_PreProcPathName
    global lcl_PreProcBatchPathName

    global g_LclPreProcDirDataChanged
    global g_LclPreProcDirDataNotApplied

    dict set ::GlobalConfig PreProcPathName $lcl_PreProcPathName
    dict set ::GlobalConfig PreProcBatchPathName $lcl_PreProcBatchPathName

    set g_LclPreProcDirDataChanged     0
    set g_LclPreProcDirDataNotApplied  0
}

#----------------------------------------------------------------------
#  ApplyButtonPress
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress {} {
    global g_LclPreProcDirDataNotApplied

    ExportLclVars
    set g_LclPreProcDirDataNotApplied 0
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
    global .ppds

    global g_LclPreProcDirDataChanged
    global g_LclPreProcDirDataNotApplied

    ExportLclVars

    set g_LclPreProcDirDataChanged     0
    set g_LclPreProcDirDataNotApplied  0

    destroy .ppds
}

#----------------------------------------------------------------------
#  CancelButtonPress
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress {} {

    global .ppds

    global g_LclPreProcDirDataChanged
    global g_LclPreProcDirDataNotApplied

    if { $g_LclPreProcDirDataNotApplied == 1} {
        # there is changed data

        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "yes" } {
            set g_LclPreProcDirDataChanged     0
            set g_LclPreProcDirDataNotApplied  0
        } else {
            focus .ppds
            return 0
        }
    }

    destroy .ppds
    return 0
}

#----------------------------------------------------------------------
#  ChangeButtonPress
#  All action after the Change button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ChangeButtonPress {} {
    global .ppds

    global lcl_PreProcPathName
    global lcl_PreProcBatchPathName

    global g_LclPreProcDirDataChanged
    global g_LclPreProcDirDataNotApplied

    # here in we need some platform specific code

    #----------------------------------------------------------------------
    # windows
    if { $::tcl_platform(platform) == "windows" } {

    }

    switch $::tcl_platform(platform) {
        windows {
            set g_PreProcFileType {
                {{PreProc}   {.exe}}
            }

            set PathFileName [tk_getOpenFile -filetypes $g_PreProcFileType]
            if { $PathFileName != "" } {
                # a new value was set
                # now we need to create a .bat file to start the PreProc

                set BatchPathName [file dirname $PathFileName]

                append BatchPathName "/runPre.bat"

                if {[catch {set File [open $BatchPathName w]}] == 0} {

                    puts $File "cd %~dp0"
                    puts $File [file tail $PathFileName]
                    flush $File
                    close $File

                } else {
                    # puts "Could not open file."
                    return -1
                }

                # and now the .bat name needs to be put into the configuration

                set lcl_PreProcPathName $PathFileName
                set lcl_PreProcBatchPathName $BatchPathName
            }

            if {$lcl_PreProcPathName != ""} {
                set g_LclPreProcDirDataChanged     1
                set g_LclPreProcDirDataNotApplied  1
            }

        }
        default {
            tk_messageBox -title [::msgcat::mc "Sorry"] -message [::msgcat::mc "Sorry, but there is some platform specific code missing."] -icon info -type ok -default ok
        }
    }






    focus .ppds

}

#----------------------------------------------------------------------
#  HelpButtonPress
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress {} {
    source "userHelp.tcl"

    displayHelpfile "geometry-window"
}
