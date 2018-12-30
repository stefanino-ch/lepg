#---------------------------------------------------------------------
#
#  Window to edit the marks data
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
global .wmde

global  Lcl_wMDE_DataChanged
set     Lcl_wMDE_DataChanged    0

global  AllGlobalVars_wMDE
set     AllGlobalVars_wMDE { markSpace markRad markDisp }

#----------------------------------------------------------------------
#  wingMarksEdit
#  Displays a window to edit the basic wing data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingMarksEdit {} {
    source "globalWingVars.tcl"
    global AllGlobalVars_wMDE

    source "windowExplanationsHelper.tcl"

    global .wmde

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wMDE {
        global Lcl_$e
    }

    SetLclVars_wMDE

    toplevel .wmde
    focus .wmde

    wm protocol .wmde WM_DELETE_WINDOW { CancelButtonPress_wMDE }

    wm title .wmde [::msgcat::mc "Wing Marks setup"]

    #-------------
    # Frames and grids
    ttk::frame      .wmde.data
    ttk::labelframe .wmde.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wmde.btn
    #
    grid .wmde.data         -row 0 -column 0 -sticky e
    grid .wmde.help         -row 1 -column 0 -sticky e
    grid .wmde.btn          -row 2 -column 0 -sticky e
    #
    #-------------
    # Data fields setup
    ttk::label .wmde.data.spacing -text [::msgcat::mc "Marks spacing"] -width 20
    grid       .wmde.data.spacing -row 0 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry  .wmde.data.e_spacing -width 10 -textvariable Lcl_markSpace
    SetHelpBind .wmde.data.e_spacing markSpace   HelpText_wMDE
    grid        .wmde.data.e_spacing -row 0 -column 1 -sticky e -padx 10 -pady 3

    ttk::label .wmde.data.radius -text [::msgcat::mc "Point radius"] -width 20
    grid       .wmde.data.radius -row 1 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry  .wmde.data.e_radius -width 10 -textvariable Lcl_markRad
    SetHelpBind .wmde.data.e_radius   markRad   HelpText_wMDE
    grid        .wmde.data.e_radius -row 1 -column 1 -sticky e -padx 10 -pady 3

    ttk::label .wmde.data.displacement -text [::msgcat::mc "Point displacement"] -width 20
    grid       .wmde.data.displacement -row 2 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry  .wmde.data.e_displacement -width 10 -textvariable Lcl_markDisp
    SetHelpBind .wmde.data.e_displacement markDisp   HelpText_wMDE
    grid        .wmde.data.e_displacement -row 2 -column 1 -sticky e -padx 10 -pady 3

    ttk::label .wmde.data.spacer -text [::msgcat::mc " "] -width 10
    grid       .wmde.data.spacer -row 0 -column 2 -sticky e -padx 10 -pady 3

    #-------------
    # explanations
    label .wmde.help.e_help -width 40 -height 3 -background LightYellow -textvariable HelpText_wMDE
    grid  .wmde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wmde.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wMDE
    button .wmde.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wMDE
    button .wmde.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wMDE
    button .wmde.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wMDE

    grid .wmde.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wmde.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wmde.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wmde.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wMDE
}

#----------------------------------------------------------------------
#  SetLclVars_wMDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wMDE {} {

    source "globalWingVars.tcl"
    global AllGlobalVars_wMDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wMDE {
        global Lcl_$e
    }

    set Lcl_markSpace   $markSpace
    set Lcl_markRad     $markRad
    set Lcl_markDisp    $markDisp
}

#----------------------------------------------------------------------
#  ExportLclVars_wMDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wMDE {} {
    source "globalWingVars.tcl"
    global AllGlobalVars_wMDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wMDE {
        global Lcl_$e
    }

    set markSpace   $Lcl_markSpace
    set markRad     $Lcl_markRad
    set markDisp    $Lcl_markDisp
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wMDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wMDE {} {
    global g_WingDataChanged
    global Lcl_wMDE_DataChanged

    if { $Lcl_wMDE_DataChanged == 1 } {
        ExportLclVars_wMDE

        set g_WingDataChanged       1
        set Lcl_wMDE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wMDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wMDE {} {
    global .wmde
    global g_WingDataChanged
    global Lcl_wMDE_DataChanged

    if { $Lcl_wMDE_DataChanged == 1 } {
        ExportLclVars_wMDE
        set g_WingDataChanged       1
        set Lcl_wMDE_DataChanged    0
    }

    UnsetLclVarTrace_wMDE
    destroy .wmde
}

#----------------------------------------------------------------------
#  CancelButtonPress_wMDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wMDE {} {
    global .wmde
    global g_WingDataChanged
    global Lcl_wMDE_DataChanged

    if { $Lcl_wMDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wmde
            return 0
        }
    }

    set Lcl_wMDE_DataChanged 0
    UnsetLclVarTrace_wMDE
    destroy .wmde

}

#----------------------------------------------------------------------
#  HelpButtonPress_wMDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wMDE {} {
    source "userHelp.tcl"

    displayHelpfile "wing-marks-edit"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wMDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wMDE {} {

    global AllGlobalVars_wMDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wMDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wMDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wMDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wMDE {} {

    global AllGlobalVars_wMDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wMDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wMDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wMDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wMDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wMDE_DataChanged

    set Lcl_wMDE_DataChanged 1
}
