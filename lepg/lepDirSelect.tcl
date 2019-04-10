#---------------------------------------------------------------------
#
#  Dialog window to configure where the lep Processor is installed.
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------
# Globals
global .lDS

global  Lcl_lDS_DataChanged
set     Lcl_lDS_DataChanged    0

global  AllGlobalVars_lDS
set     AllGlobalVars_lDS { LepPathName }


#----------------------------------------------------------------------
#  lepDirSelect_lDS
#  Displays the current configuration, allows to setup a new path if needed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc lepDirSelect_lDS {} {
    global Lcl_LepPathName

    SetLclVars_lDS

    toplevel .lDS
    focus .lDS

    wm protocol .lDS WM_DELETE_WINDOW { CancelButtonPress_lDS }

    wm title .lDS [::msgcat::mc "Setup lep Processor"]

    #-------------
    # Frames and grids
    ttk::labelframe .lDS.name -text [::msgcat::mc "lep Processor"]
    ttk::frame .lDS.btn

    grid .lDS.name         -row 0 -column 0 -sticky e
    grid .lDS.btn          -row 2 -column 0 -sticky e

    grid columnconfigure .lDS 0    -weight 0
    grid rowconfigure .lDS 0       -weight 0
    grid rowconfigure .lDS 1       -weight 0

    #-------------
    # lep Processor setup
    ttk::label .lDS.name.name -text [::msgcat::mc "lep Processor"] -width 20
    ttk::entry .lDS.name.e_name -width 60 -textvariable Lcl_LepPathName

    button .lDS.name.change -width 10 -text [::msgcat::mc "Change..."] -command ChangeButtonPress_lDS

    grid .lDS.name.name -row 0 -column 0 -sticky e
    grid .lDS.name.e_name -row 0 -column 1 -sticky w
    grid .lDS.name.change -row 0 -column 2 -sticky w -padx 10 -pady 10

    #-------------
    # buttons
    button .lDS.btn.apply -width 10 -text "Apply" -command ApplyButtonPress_lDS
    button .lDS.btn.ok -width 10 -text "OK" -command OkButtonPress_lDS
    button .lDS.btn.cancel -width 10 -text "Cancel" -command CancelButtonPress_lDS
    button .lDS.btn.help -width 10  -text "Help" -command HelpButtonPress_lDS

    grid .lDS.btn.apply -row 0 -column 0 -sticky e -padx 10 -pady 0
    grid .lDS.btn.ok -row 0 -column 1 -sticky e -padx 10 -pady 0
    grid .lDS.btn.cancel -row 0 -column 2 -sticky e -padx 10 -pady 0
    grid .lDS.btn.help -row 1 -column 2 -sticky e -padx 10 -pady 20

    SetLclVarTrace_lDS
}

#----------------------------------------------------------------------
#  SetLclVars_lDS
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_lDS {} {
    global Lcl_LepPathName

    set Lcl_LepPathName [dict get $::GlobalConfig LepPathName]
}

#----------------------------------------------------------------------
#  ExportLclVars_lDS
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_lDS {} {
    global Lcl_LepPathName

    dict set ::GlobalConfig LepPathName $Lcl_LepPathName
}

#----------------------------------------------------------------------
#  ApplyButtonPress_lDS
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_lDS {} {
    global Lcl_lDS_DataChanged

    if { $Lcl_lDS_DataChanged == 1 } {
        ExportLclVars_lDS
        set Lcl_lDS_DataChanged 0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_lDS
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_lDS {} {
    global .lDS
    global Lcl_lDS_DataChanged

    if { $Lcl_lDS_DataChanged == 1 } {
        ExportLclVars_lDS
        set Lcl_lDS_DataChanged 0
    }

    UnsetLclVarTrace_lDS
    destroy .lDS
}

#----------------------------------------------------------------------
#  CancelButtonPress_lDS
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_lDS {} {
    global .lDS
    global Lcl_lDS_DataChanged

    if { $Lcl_lDS_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .lDS
            return 0
        }
    }

    set Lcl_lDS_DataChanged 0
    UnsetLclVarTrace_lDS
    destroy .lDS
}

#----------------------------------------------------------------------
#  ChangeButtonPress_lDS
#  All action after the Change button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ChangeButtonPress_lDS {} {
    global .lDS
    global Lcl_lDS_DataChanged

    global Lcl_LepPathName

    # here in we need some platform specific code
    switch $::tcl_platform(platform) {
        windows {
            set g_lepFileType {
                {{PreProc}   {.exe}}
            }

            set PathFileName [tk_getOpenFile -filetypes $g_lepFileType]
            if { $PathFileName != "" } {
                # a new value was set
                set Lcl_LepPathName $PathFileName
            }

            if {$Lcl_LepPathName != ""} {
                # a new value was set
                set Lcl_LepPathName $PathFileName
            }

        }
        unix {
            set g_lepFileType {
                {{PreProc}   {.out}}
            }

            set PathFileName [tk_getOpenFile -filetypes $g_lepFileType]
            if { $PathFileName != "" } {
                # a new value was set
                set Lcl_LepPathName $PathFileName
            }

            if {$Lcl_LepPathName != ""} {
                # a new value was set
                set Lcl_LepPathName $PathFileName
            }
        }
        default {
            tk_messageBox -title [::msgcat::mc "Sorry"] -message [::msgcat::mc "Sorry, but there is some platform specific code missing."] -icon info -type ok -default ok
        }
    }

    focus .lDS
}

#----------------------------------------------------------------------
#  HelpButtonPress_lDS
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_lDS {} {
    source "userHelp.tcl"

    displayHelpfile "lep-dir-select"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_lDS
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_lDS {} {

    global AllGlobalVars_lDS

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_lDS {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_lDS }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_lDS
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_lDS {} {

    global AllGlobalVars_lDS

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_lDS {
        global Lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_lDS }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_lDS
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_lDS { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"
    global Lcl_lDS_DataChanged

    set Lcl_lDS_DataChanged 1
}
