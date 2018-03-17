#-------
# Globals
global .wbde

set g_Lcl_wbde_DataChanged 0

set g_Lcl_wbde_DataNotApplied 0


#----------------------------------------------------------------------
#  WingBasicDataEdit
#  Displays a window to edit the basic wing data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc PreProcDirSelect_pPDS {} {

################# go on here

    SetLclVars_pPDS

    toplevel .ppds
    focus .ppds

    wm protocol .ppds WM_DELETE_WINDOW { CancelButtonPress_pPDS }

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

    #-------------
    # Geometry Processor setup
    ttk::label .ppds.name.name -text [::msgcat::mc "Geometry Processor"] -width 20
    ttk::entry .ppds.name.e_name -width 60 -textvariable lcl_PreProcPathName

    button .ppds.name.change -width 10 -text [::msgcat::mc "Change..."] -command ChangeButtonPress_pPDS

    grid .ppds.name.name -row 0 -column 0 -sticky e
    grid .ppds.name.e_name -row 0 -column 1 -sticky w
    grid .ppds.name.change -row 0 -column 2 -sticky w -padx 10 -pady 10

    #-------------
    # buttons
    button .ppds.btn.apply -width 10 -text "Apply" -command ApplyButtonPress_pPDS
    button .ppds.btn.ok -width 10 -text "OK" -command OkButtonPress_pPDS
    button .ppds.btn.cancel -width 10 -text "Cancel" -command CancelButtonPress_pPDS
    button .ppds.btn.help -width 10  -text "Help" -command HelpButtonPress_pPDS

    grid .ppds.btn.apply -row 0 -column 0 -sticky e -padx 10 -pady 0
    grid .ppds.btn.ok -row 0 -column 1 -sticky e -padx 10 -pady 0
    grid .ppds.btn.cancel -row 0 -column 2 -sticky e -padx 10 -pady 0
    grid .ppds.btn.help -row 1 -column 2 -sticky e -padx 10 -pady 20


}

#----------------------------------------------------------------------
#  SetLclVars_pPDS
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_pPDS {} {
    global lcl_PreProcPathName

    global g_LclPreProcDirDataChanged
    global g_LclPreProcDirDataNotApplied

    set lcl_PreProcPathName [dict get $::GlobalConfig PreProcPathName]

    set g_LclPreProcDirDataChanged     0
    set g_LclPreProcDirDataNotApplied  0
}

#----------------------------------------------------------------------
#  ExportLclVars_pPDS
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_pPDS {} {
    global lcl_PreProcPathName

    global g_LclPreProcDirDataChanged
    global g_LclPreProcDirDataNotApplied

    dict set ::GlobalConfig PreProcPathName $lcl_PreProcPathName

    set g_LclPreProcDirDataChanged     0
    set g_LclPreProcDirDataNotApplied  0
}

#----------------------------------------------------------------------
#  ApplyButtonPress_pPDS
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_pPDS {} {
    global g_LclPreProcDirDataNotApplied

    ExportLclVars_pPDS
    set g_LclPreProcDirDataNotApplied 0
}

#----------------------------------------------------------------------
#  OkButtonPress_pPDS
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_pPDS {} {
    global .ppds

    global g_LclPreProcDirDataChanged
    global g_LclPreProcDirDataNotApplied

    ExportLclVars_pPDS

    set g_LclPreProcDirDataChanged     0
    set g_LclPreProcDirDataNotApplied  0

    destroy .ppds
}

#----------------------------------------------------------------------
#  CancelButtonPress_pPDS
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_pPDS {} {

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
#  ChangeButtonPress_pPDS
#  All action after the Change button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ChangeButtonPress_pPDS {} {
    global .ppds

    global lcl_PreProcPathName

    global g_LclPreProcDirDataChanged
    global g_LclPreProcDirDataNotApplied

    # here in we need some platform specific code
    switch $::tcl_platform(platform) {
        windows {
            set g_PreProcFileType {
                {{PreProc}   {.exe}}
            }

            set PathFileName [tk_getOpenFile -filetypes $g_PreProcFileType]
            if { $PathFileName != "" } {
                # a new value was set

                set lcl_PreProcPathName $PathFileName
            }

            if {$lcl_PreProcPathName != ""} {
                set g_LclPreProcDirDataChanged     1
                set g_LclPreProcDirDataNotApplied  1
            }

        }
        unix {
            set g_PreProcFileType {
                {{PreProc}   {.out}}
            }

            set PathFileName [tk_getOpenFile -filetypes $g_PreProcFileType]
            if { $PathFileName != "" } {
                # a new value was set

                set lcl_PreProcPathName $PathFileName
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
#  HelpButtonPress_pPDS
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_pPDS {} {
    source "userHelp.tcl"

    displayHelpfile "geometry-window"
}
