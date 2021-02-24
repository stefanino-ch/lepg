#---------------------------------------------------------------------
#
#  Dialog window to select and image
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------
# Globals
global .pids

global  Lcl_pIDS_DataChanged
set     Lcl_pIDS_DataChanged    0

global  AllGlobalVars_pIDS
set     AllGlobalVars_pIDS { PreImagePathName }


#----------------------------------------------------------------------
#  MainwIS_pIDS
#  Displays the current configuration, allows to setup a new path if needed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc MainwIS_pIDS {} {
    global Lcl_PreImagePathName

    SetLclVars_pIDS

    toplevel .pids
    focus .pids

    wm protocol .pids WM_DELETE_WINDOW { CancelButtonPress_pIDS }

    wm title .pids [::msgcat::mc "Setup main window image"]

    #-------------
    # Frames and grids
    ttk::labelframe .pids.name -text [::msgcat::mc "Select main window image (.gif .png format, max width about 500 px)"]
    ttk::frame .pids.btn

    grid .pids.name         -row 0 -column 0 -sticky e
    grid .pids.btn          -row 2 -column 0 -sticky e

    grid columnconfigure .pids 0    -weight 0
    grid rowconfigure .pids 0       -weight 0
    grid rowconfigure .pids 1       -weight 0

    #-------------
    # Geometry Processor setup
    ttk::label .pids.name.name -text [::msgcat::mc " Image"] -width 15
    ttk::entry .pids.name.e_name -width 60 -textvariable Lcl_PreImagePathName

    button .pids.name.change -width 10 -text [::msgcat::mc "Change..."] -command ChangeButtonPress_pIDS

    grid .pids.name.name -row 0 -column 0 -sticky e
    grid .pids.name.e_name -row 0 -column 1 -sticky w
    grid .pids.name.change -row 0 -column 2 -sticky w -padx 10 -pady 10

    #-------------
    # buttons
    button .pids.btn.apply -width 10 -text [::msgcat::mc "Apply"] -command ApplyButtonPress_pIDS
    button .pids.btn.ok -width 10 -text [::msgcat::mc "OK"] -command OkButtonPress_pIDS
    button .pids.btn.cancel -width 10 -text [::msgcat::mc "Cancel"] -command CancelButtonPress_pIDS
    button .pids.btn.help -width 10  -text [::msgcat::mc "Help"] -command HelpButtonPress_pIDS

    grid .pids.btn.apply -row 0 -column 0 -sticky e -padx 10 -pady 0
    grid .pids.btn.ok -row 0 -column 1 -sticky e -padx 10 -pady 0
    grid .pids.btn.cancel -row 0 -column 2 -sticky e -padx 10 -pady 0
    grid .pids.btn.help -row 1 -column 2 -sticky e -padx 10 -pady 20

    SetLclVarTrace_pIDS
}

#----------------------------------------------------------------------
#  SetLclVars_pIDS
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_pIDS {} {
    global Lcl_PreImagePathName

    set Lcl_PreImagePathName [dict get $::GlobalConfig PreImagePathName]
}

#----------------------------------------------------------------------
#  ExportLclVars_pIDS
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_pIDS {} {
    global Lcl_PreImagePathName

    dict set ::GlobalConfig PreImagePathName $Lcl_PreImagePathName
}

#----------------------------------------------------------------------
#  ApplyButtonPress_pIDS
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_pIDS {} {
    global Lcl_pIDS_DataChanged

 
    if { $Lcl_pIDS_DataChanged == 1 } {
        ExportLclVars_pIDS
        set Lcl_pIDS_DataChanged 0
    }
    destroy .sidev
    CreateOnlyImage

}

#----------------------------------------------------------------------
#  OkButtonPress_pIDS
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_pIDS {} {
    global .pids
    global Lcl_pIDS_DataChanged

    if { $Lcl_pIDS_DataChanged == 1 } {
        ExportLclVars_pIDS
        set Lcl_pIDS_DataChanged 0
    }
 
    destroy .sidev
    CreateOnlyImage

    UnsetLclVarTrace_pIDS
    destroy .pids

}

#----------------------------------------------------------------------
#  CancelButtonPress_pIDS
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_pIDS {} {
    global .pids
    global Lcl_pIDS_DataChanged

    if { $Lcl_pIDS_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .pids
            return 0
        }
    }

    set Lcl_pIDS_DataChanged 0
    UnsetLclVarTrace_pIDS
    destroy .pids
}

#----------------------------------------------------------------------
#  ChangeButtonPress_pIDS
#  All action after the Change button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ChangeButtonPress_pIDS {} {
    global .pids
    global Lcl_pIDS_DataChanged

    global Lcl_PreImagePathName

    # here in we need some platform specific code
    switch $::tcl_platform(platform) {
        windows {
            set g_PreImagFileType {
                {{Image files} {.gif .png}}
            }

            set PathFileName [tk_getOpenFile -filetypes $g_PreImagFileType]
            if { $PathFileName != "" } {
                # a new value was set
                set Lcl_PreImagePathName $PathFileName
            }

            if {$Lcl_PreImagePathName != ""} {
                # a new value was set
                set Lcl_PreImagePathName $PathFileName
            }

        }
        unix {
            set g_PreImagFileType {
                {{Image files}   {.gif .png}}
            }

            set PathFileName [tk_getOpenFile -filetypes $g_PreImagFileType]
            if { $PathFileName != "" } {
                # a new value was set
                set Lcl_PreImagePathName $PathFileName
            }

            if {$Lcl_PreImagePathName != ""} {
                # a new value was set
                set Lcl_PreImagePathName $PathFileName
            }
        }
        default {
            tk_messageBox -title [::msgcat::mc "Sorry"] -message [::msgcat::mc "Sorry, but there is some platform specific code missing."] -icon info -type ok -default ok
        }
    }

    focus .pids

#   puts "Here $Lcl_PreImagePathName"



}

#----------------------------------------------------------------------
#  HelpButtonPress_pIDS
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_pIDS {} {
    source "userHelp.tcl"

    displayHelpfile "pre-proc-dir-select"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_pIDS
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_pIDS {} {

    global AllGlobalVars_pIDS

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_pIDS {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_pIDS }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_pIDS
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_pIDS {} {

    global AllGlobalVars_pIDS

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_pIDS {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_pIDS }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_pIDS
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_pIDS { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"
    global Lcl_pIDS_DataChanged

    set Lcl_pIDS_DataChanged 1
}
