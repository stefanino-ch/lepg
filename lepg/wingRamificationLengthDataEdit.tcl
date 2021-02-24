#---------------------------------------------------------------------
#
#  Window to edit the ramification length data
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global .wrlde

global  Lcl_wRLDE_DataChanged
set     Lcl_wRLDE_DataChanged    0

global  AllGlobalVars_wRLDE
set     AllGlobalVars_wRLDE { lineLength ramLength }

#----------------------------------------------------------------------
# wingRamificationLengthDataEdit
#  Displays a window to edit the ramification length data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingRamificationLengthDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wrlde

    global  AllGlobalVars_wRLDE
    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wRLDE {
        global Lcl_$e
    }

    SetLclVars_wRLDE

    toplevel .wrlde
    focus .wrlde

    wm protocol .wrlde WM_DELETE_WINDOW { CancelButtonPress_wRLDE }

    wm title .wrlde [::msgcat::mc "Section 11: Ramification lengths"]

    #-------------
    # Frames and grids
    ttk::frame      .wrlde.data
    ttk::labelframe .wrlde.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wrlde.btn
    #
    grid .wrlde.data         -row 0 -column 0 -sticky e
    grid .wrlde.help         -row 1 -column 0 -sticky e
    grid .wrlde.btn          -row 2 -column 0 -sticky e
    #
    #-------------
    # Data fields setup

    ttk::label  .wrlde.data.spacer1_wRLDE -text "" -width 5 -anchor e
    grid        .wrlde.data.spacer1_wRLDE -row 0 -column 0 -sticky e

    ttk::label  .wrlde.data.spacer2_wRLDE -text "" -width 5 -anchor e
    grid        .wrlde.data.spacer2_wRLDE -row 0 -column 5 -sticky e

    ttk::label  .wrlde.data.spacer3_wRLDE -text "" -width 5 -anchor e
    grid        .wrlde.data.spacer3_wRLDE -row 0 -column 8 -sticky e

    ttk::label  .wrlde.data.lvl_label1_wRLDE -text [::msgcat::mc "3 line levels"] -width 10 -anchor e
    grid        .wrlde.data.lvl_label1_wRLDE -row 1 -column 4 -sticky e

    ttk::label  .wrlde.data.lvl_label2_wRLDE -text [::msgcat::mc "4 line levels"] -width 10 -anchor e
    grid        .wrlde.data.lvl_label2_wRLDE -row 1 -column 7 -sticky e

    ttk::label  .wrlde.data.lines_label1   -text [::msgcat::mc "Lines"] -width 20 -anchor e
    grid        .wrlde.data.lines_label1   -row 2 -column 1 -sticky e

    ttk::label  .wrlde.data.lines_label2   -text [::msgcat::mc "Brakes"] -width 20 -anchor e
    grid        .wrlde.data.lines_label2   -row 5 -column 1 -sticky e

    ttk::label  .wrlde.data.lines_3_t   -text [::msgcat::mc "Dist Ramification 1 to wing"] -width 35 -anchor e
    grid        .wrlde.data.lines_3_t   -row 2 -column 2 -sticky e
    ttk::label  .wrlde.data.u_lines_3_t -text [::msgcat::mc "\[cm\]"] -width 5 -anchor e
    grid        .wrlde.data.u_lines_3_t -row 2 -column 3 -sticky e
    ttk::entry  .wrlde.data.e_lines_3_t -width 10 -textvariable Lcl_ramLength(3,3)
    SetHelpBind .wrlde.data.e_lines_3_t [::msgcat::mc "lines_t"]  HelpText_wRLDE
    grid        .wrlde.data.e_lines_3_t -row 2 -column 4 -sticky e
    # --
    ttk::label  .wrlde.data.u_lines_4_t -text [::msgcat::mc "\[cm\]"] -width 5 -anchor e
    grid        .wrlde.data.u_lines_4_t -row 2 -column 6 -sticky e
    ttk::entry  .wrlde.data.e_lines_4_t -width 10 -textvariable Lcl_ramLength(4,4)
    SetHelpBind .wrlde.data.e_lines_4_t [::msgcat::mc "lines_t"]  HelpText_wRLDE
    grid        .wrlde.data.e_lines_4_t -row 2 -column 7 -sticky e

    ttk::label  .wrlde.data.lines_4_m   -text [::msgcat::mc "Dist Ramification 2 to wing"] -width 35 -anchor e
    grid        .wrlde.data.lines_4_m   -row 3 -column 2 -sticky e
    ttk::label  .wrlde.data.u_lines_4_m -text [::msgcat::mc "\[cm\]"] -width 5 -anchor e
    grid        .wrlde.data.u_lines_4_m -row 3 -column 6 -sticky e
    ttk::entry  .wrlde.data.e_lines_4_m -width 10 -textvariable Lcl_ramLength(4,3)
    SetHelpBind .wrlde.data.e_lines_4_m [::msgcat::mc "lines_4_m"]  HelpText_wRLDE
    grid        .wrlde.data.e_lines_4_m -row 3 -column 7 -sticky e

    ttk::label  .wrlde.data.spacer4_wRLDE -text "" -width 5 -anchor e
    grid        .wrlde.data.spacer4_wRLDE -row 4 -column 0 -sticky e

    ttk::label  .wrlde.data.breakl_3_t   -text [::msgcat::mc "Dist Ramification 1 to wing"] -width 35 -anchor e
    grid        .wrlde.data.breakl_3_t   -row 5 -column 2 -sticky e
    ttk::label  .wrlde.data.u_breakl_3_t -text [::msgcat::mc "\[cm\]"] -width 5 -anchor e
    grid        .wrlde.data.u_breakl_3_t -row 5 -column 3 -sticky e
    ttk::entry  .wrlde.data.e_breakl_3_t -width 10 -textvariable Lcl_ramLength(5,3)
    SetHelpBind .wrlde.data.e_breakl_3_t [::msgcat::mc "breakl_t"]  HelpText_wRLDE
    grid        .wrlde.data.e_breakl_3_t -row 5 -column 4 -sticky e
    # --
    ttk::label  .wrlde.data.u_breakl_4_t -text "\[cm\]" -width 5 -anchor e
    grid        .wrlde.data.u_breakl_4_t -row 5 -column 6 -sticky e
    ttk::entry  .wrlde.data.e_breakl_4_t -width 10 -textvariable Lcl_ramLength(6,4)
    SetHelpBind .wrlde.data.e_breakl_4_t [::msgcat::mc "breakl_t"]  HelpText_wRLDE
    grid        .wrlde.data.e_breakl_4_t -row 5 -column 7 -sticky e

    ttk::label  .wrlde.data.breakl_4_m   -text [::msgcat::mc "Dist Ramification 2 to wing"] -width 35 -anchor e
    grid        .wrlde.data.breakl_4_m   -row 6 -column 2 -sticky e
    ttk::label  .wrlde.data.u_breakl_4_m -text [::msgcat::mc "\[cm\]"] -width 5 -anchor e
    grid        .wrlde.data.u_breakl_4_m -row 6 -column 6 -sticky e
    ttk::entry  .wrlde.data.e_breakl_4_m -width 10 -textvariable Lcl_ramLength(6,3)
    SetHelpBind .wrlde.data.e_breakl_4_m [::msgcat::mc "breakl_4_m"]  HelpText_wRLDE
    grid        .wrlde.data.e_breakl_4_m -row 6 -column 7 -sticky e

    ttk::label  .wrlde.data.spacer5_wRLDE -text "" -width 5 -anchor e
    grid        .wrlde.data.spacer5_wRLDE -row 7 -column 0 -sticky e

    #-------------
    # explanations
    label .wrlde.help.e_help -width 40 -height 3 -background LightYellow -justify left -textvariable HelpText_wRLDE
    grid  .wrlde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wrlde.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wRLDE
    button .wrlde.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wRLDE
    button .wrlde.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wRLDE
    button .wrlde.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wRLDE

    grid .wrlde.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wrlde.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wrlde.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wrlde.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wRLDE
}

#----------------------------------------------------------------------
#  SetLclVars_wRLDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wRLDE {} {
    source "globalWingVars.tcl"

    global  AllGlobalVars_wRLDE
    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wRLDE {
        global Lcl_$e
    }

    set Lcl_lineLength  $lineLength

    set Lcl_ramLength(3,1) $ramLength(3,1)
    set Lcl_ramLength(3,3) $ramLength(3,3)

    set Lcl_ramLength(4,1) $ramLength(4,1)
    set Lcl_ramLength(4,3) $ramLength(4,3)
    set Lcl_ramLength(4,4) $ramLength(4,4)

    set Lcl_ramLength(5,1) $ramLength(5,1)
    set Lcl_ramLength(5,3) $ramLength(5,3)

    set Lcl_ramLength(6,1) $ramLength(6,1)
    set Lcl_ramLength(6,3) $ramLength(6,3)
    set Lcl_ramLength(6,4) $ramLength(6,4)

}

#----------------------------------------------------------------------
#  ExportLclVars_wRLDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wRLDE {} {
    source "globalWingVars.tcl"

    global  AllGlobalVars_wRLDE
    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wRLDE {
        global Lcl_$e
    }

    set lineLength  $Lcl_lineLength

    set ramLength(3,1) $Lcl_ramLength(3,1)
    set ramLength(3,3) $Lcl_ramLength(3,3)

    set ramLength(4,1) $Lcl_ramLength(4,1)
    set ramLength(4,3) $Lcl_ramLength(4,3)
    set ramLength(4,4) $Lcl_ramLength(4,4)

    set ramLength(5,1) $Lcl_ramLength(5,1)
    set ramLength(5,3) $Lcl_ramLength(5,3)

    set ramLength(6,1) $Lcl_ramLength(6,1)
    set ramLength(6,3) $Lcl_ramLength(6,3)
    set ramLength(6,4) $Lcl_ramLength(6,4)

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wRLDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wRLDE {} {
    global g_WingDataChanged
    global Lcl_wRLDE_DataChanged

    if { $Lcl_wRLDE_DataChanged == 1 } {
        ExportLclVars_wRLDE

        set g_WingDataChanged       1
        set Lcl_wRLDE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wRLDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wRLDE {} {
    global .wrlde
    global g_WingDataChanged
    global Lcl_wRLDE_DataChanged

    if { $Lcl_wRLDE_DataChanged == 1 } {
        ExportLclVars_wRLDE
        set g_WingDataChanged       1
        set Lcl_wRLDE_DataChanged    0
    }

    UnsetLclVarTrace_wRLDE
    destroy .wrlde
}

#----------------------------------------------------------------------
#  CancelButtonPress_wRLDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wRLDE {} {
    global .wrlde
    global g_WingDataChanged
    global Lcl_wRLDE_DataChanged

    if { $Lcl_wRLDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wrlde
            return 0
        }
    }

    set Lcl_wRLDE_DataChanged 0
    UnsetLclVarTrace_wRLDE
    destroy .wrlde

}

#----------------------------------------------------------------------
#  HelpButtonPress_wRLDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wRLDE {} {
    source "userHelp.tcl"

    displayHelpfile "ramification-length-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wRLDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wRLDE {} {

    global AllGlobalVars_wRLDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wRLDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wRLDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wRLDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wRLDE {} {

    global AllGlobalVars_wRLDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wRLDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wRLDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wRLDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wRLDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wRLDE_DataChanged

    set Lcl_wRLDE_DataChanged 1
}
