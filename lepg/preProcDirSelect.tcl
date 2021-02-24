#---------------------------------------------------------------------
#
#  Dialog window to configure where the PreProcessor is installed.
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------
# Globals
global .ppds

global  Lcl_pPDS_DataChanged
set     Lcl_pPDS_DataChanged    0

global  AllGlobalVars_pPDS
set     AllGlobalVars_pPDS { PreProcPathName }


#----------------------------------------------------------------------
#  PreProcDirSelect_pPDS
#  Displays the current configuration, allows to setup a new path if needed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc PreProcDirSelect_pPDS {} {
    global Lcl_PreProcPathName

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
    ttk::entry .ppds.name.e_name -width 60 -textvariable Lcl_PreProcPathName

    button .ppds.name.change -width 10 -text [::msgcat::mc "Change..."] -command ChangeButtonPress_pPDS

    grid .ppds.name.name -row 0 -column 0 -sticky e
    grid .ppds.name.e_name -row 0 -column 1 -sticky w
    grid .ppds.name.change -row 0 -column 2 -sticky w -padx 10 -pady 10

    #-------------
    # buttons
    button .ppds.btn.apply -width 10 -text [::msgcat::mc "Apply"] -command ApplyButtonPress_pPDS
    button .ppds.btn.ok -width 10 -text [::msgcat::mc "OK"] -command OkButtonPress_pPDS
    button .ppds.btn.cancel -width 10 -text [::msgcat::mc "Cancel"] -command CancelButtonPress_pPDS
    button .ppds.btn.help -width 10  -text [::msgcat::mc "Help"] -command HelpButtonPress_pPDS

    grid .ppds.btn.apply -row 0 -column 0 -sticky e -padx 10 -pady 0
    grid .ppds.btn.ok -row 0 -column 1 -sticky e -padx 10 -pady 0
    grid .ppds.btn.cancel -row 0 -column 2 -sticky e -padx 10 -pady 0
    grid .ppds.btn.help -row 1 -column 2 -sticky e -padx 10 -pady 20

    SetLclVarTrace_pPDS

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
    global Lcl_PreProcPathName

    set Lcl_PreProcPathName [dict get $::GlobalConfig PreProcPathName]
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
    global Lcl_PreProcPathName

    dict set ::GlobalConfig PreProcPathName $Lcl_PreProcPathName
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
    global Lcl_pPDS_DataChanged

    if { $Lcl_pPDS_DataChanged == 1 } {
        ExportLclVars_pPDS
        set Lcl_pPDS_DataChanged 0
    }
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
    global Lcl_pPDS_DataChanged

    if { $Lcl_pPDS_DataChanged == 1 } {
        ExportLclVars_pPDS
        set Lcl_pPDS_DataChanged 0
    }

    UnsetLclVarTrace_pPDS
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
    global Lcl_pPDS_DataChanged

    if { $Lcl_pPDS_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .ppds
            return 0
        }
    }

    set Lcl_pPDS_DataChanged 0
    UnsetLclVarTrace_pPDS
    destroy .ppds
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
    global Lcl_pPDS_DataChanged

    global Lcl_PreProcPathName

    # here in we need some platform specific code
    switch $::tcl_platform(platform) {
        windows {
            set g_PreProcFileType {
                {{PreProc}   {.exe}}
            }

            set PathFileName [tk_getOpenFile -filetypes $g_PreProcFileType]
            if { $PathFileName != "" } {
                # a new value was set
                set Lcl_PreProcPathName $PathFileName
            }

            if {$Lcl_PreProcPathName != ""} {
                # a new value was set
                set Lcl_PreProcPathName $PathFileName
            }

        }
        unix {
            set g_PreProcFileType {
                {{PreProc}   {.out}}
            }

            set PathFileName [tk_getOpenFile -filetypes $g_PreProcFileType]
            if { $PathFileName != "" } {
                # a new value was set
                set Lcl_PreProcPathName $PathFileName
            }

            if {$Lcl_PreProcPathName != ""} {
                # a new value was set
                set Lcl_PreProcPathName $PathFileName
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

    displayHelpfile "pre-proc-dir-select"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_pPDS
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_pPDS {} {

    global AllGlobalVars_pPDS

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_pPDS {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_pPDS }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_pPDS
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_pPDS {} {

    global AllGlobalVars_pPDS

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_pPDS {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_pPDS }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_pPDS
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_pPDS { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"
    global Lcl_pPDS_DataChanged

    set Lcl_pPDS_DataChanged 1
}
