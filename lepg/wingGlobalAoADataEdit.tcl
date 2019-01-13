#---------------------------------------------------------------------
#
#  Window to edit the global AoA data
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global .wgade

global  Lcl_wGADE_DataChanged
set     Lcl_wGADE_DataChanged    0

global  AllGlobalVars_wGADE
set     AllGlobalVars_wGADE { finesse posCop calage riserLength lineLength distTowP }

#----------------------------------------------------------------------
# wingGlobalAoADataEdit
#  Displays a window to edit the wing skin tension data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingGlobalAoADataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wgade

    global Lcl_skinTens
    global Lcl_strainMiniRibs
    global Lcl_numStrainPoints
    global Lcl_strainCoef

    SetLclVars_wGADE

    toplevel .wgade
    focus .wgade

    wm protocol .wgade WM_DELETE_WINDOW { CancelButtonPress_wGADE }

    wm title .wgade [::msgcat::mc "Global AoA estimation"]

    #-------------
    # Frames and grids
    ttk::frame      .wgade.data
    ttk::labelframe .wgade.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wgade.btn
    #
    grid .wgade.data         -row 0 -column 0 -sticky e
    grid .wgade.help         -row 1 -column 0 -sticky e
    grid .wgade.btn          -row 2 -column 0 -sticky e
    #
    #-------------
    # Data fields setup

    ttk::label  .wgade.data.spacer1_wGADE -text "" -width 20 -anchor e
    grid        .wgade.data.spacer1_wGADE -row 0 -column 0 -sticky e

    ttk::label  .wgade.data.finesse   -text "Finesse goal" -width 20 -anchor e
    grid        .wgade.data.finesse   -row 1 -column 1 -sticky e
    ttk::label  .wgade.data.u_finesse -text "\[deg\]" -width 10 -anchor e
    grid        .wgade.data.u_finesse -row 1 -column 2 -sticky e
    ttk::entry  .wgade.data.e_finesse -width 10 -textvariable Lcl_finesse
    SetHelpBind .wgade.data.e_finesse finesse  HelpText_wGADE
    grid        .wgade.data.e_finesse -row 1 -column 3 -sticky e

    ttk::label  .wgade.data.cop   -text "Center of pressure" -width 20 -anchor e
    grid        .wgade.data.cop   -row 2 -column 1 -sticky e
    ttk::label  .wgade.data.u_cop -text "\[% chord\]" -width 10 -anchor e
    grid        .wgade.data.u_cop -row 2 -column 2 -sticky e
    ttk::entry  .wgade.data.e_cop -width 10 -textvariable Lcl_posCop
    SetHelpBind .wgade.data.e_cop posCop  HelpText_wGADE
    grid        .wgade.data.e_cop -row 2 -column 3 -sticky e

    ttk::label  .wgade.data.calage   -text "Calage" -width 20 -anchor e
    grid        .wgade.data.calage   -row 3 -column 1 -sticky e
    ttk::label  .wgade.data.u_calage -text "\[% chord\]" -width 10 -anchor e
    grid        .wgade.data.u_calage -row 3 -column 2 -sticky e
    ttk::entry  .wgade.data.e_calage -width 10 -textvariable Lcl_calage
    SetHelpBind .wgade.data.e_calage calage HelpText_wGADE
    grid        .wgade.data.e_calage -row 3 -column 3 -sticky e

    ttk::label  .wgade.data.riser   -text "Riser length" -width 20 -anchor e
    grid        .wgade.data.riser   -row 4 -column 1 -sticky e
    ttk::label  .wgade.data.u_riser -text "\[cm\]" -width 10 -anchor e
    grid        .wgade.data.u_riser -row 4 -column 2 -sticky e
    ttk::entry  .wgade.data.e_riser -width 10 -textvariable Lcl_riserLength
    SetHelpBind .wgade.data.e_riser riserLength  HelpText_wGADE
    grid        .wgade.data.e_riser -row 4 -column 3 -sticky e

    ttk::label  .wgade.data.lines   -text "Length of lines" -width 20 -anchor e
    grid        .wgade.data.lines   -row 5 -column 1 -sticky e
    ttk::label  .wgade.data.u_lines -text "\[cm\]" -width 10 -anchor e
    grid        .wgade.data.u_lines -row 5 -column 2 -sticky e
    ttk::entry  .wgade.data.e_lines -width 10 -textvariable Lcl_lineLength
    SetHelpBind .wgade.data.e_lines lineLength  HelpText_wGADE
    grid        .wgade.data.e_lines -row 5 -column 3 -sticky e

    ttk::label  .wgade.data.carab   -text "Main carabiners distance" -width 20 -anchor e
    grid        .wgade.data.carab   -row 6 -column 1 -sticky e
    ttk::label  .wgade.data.u_carab -text "\[cm\]" -width 10 -anchor e
    grid        .wgade.data.u_carab -row 6 -column 2 -sticky e
    ttk::entry  .wgade.data.e_carab -width 10 -textvariable Lcl_distTowP
    SetHelpBind .wgade.data.e_carab distTowP HelpText_wGADE
    grid        .wgade.data.e_carab -row 6 -column 3 -sticky e

    ttk::label  .wgade.data.spacer2_wGADE -text "" -width 20 -anchor e
    grid        .wgade.data.spacer2_wGADE -row 6 -column 4 -sticky e

    #-------------
    # explanations
    label .wgade.help.e_help -width 40 -height 3 -background LightYellow -justify left -textvariable HelpText_wGADE
    grid  .wgade.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wgade.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wGADE
    button .wgade.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wGADE
    button .wgade.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wGADE
    button .wgade.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wGADE

    grid .wgade.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wgade.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wgade.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wgade.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wGADE
}

#----------------------------------------------------------------------
#  SetLclVars_wGADE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wGADE {} {
    source "globalWingVars.tcl"

    global  AllGlobalVars_wGADE
    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGADE {
        global Lcl_$e
    }

    set Lcl_finesse     $finesse
    set Lcl_posCop      $posCop
    set Lcl_calage      $calage
    set Lcl_riserLength $riserLength
    set Lcl_lineLength  $lineLength
    set Lcl_distTowP    $distTowP

}

#----------------------------------------------------------------------
#  ExportLclVars_wGADE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wGADE {} {
    source "globalWingVars.tcl"

    global  AllGlobalVars_wGADE
    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGADE {
        global Lcl_$e
    }

    set finesse     $Lcl_finesse
    set posCop      $Lcl_posCop
    set calage      $Lcl_calage
    set riserLength $Lcl_riserLength
    set lineLength  $Lcl_lineLength
    set distTowP    $Lcl_distTowP

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wGADE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wGADE {} {
    global g_WingDataChanged
    global Lcl_wGADE_DataChanged

    if { $Lcl_wGADE_DataChanged == 1 } {
        ExportLclVars_wGADE

        set g_WingDataChanged       1
        set Lcl_wGADE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wGADE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wGADE {} {
    global .wgade
    global g_WingDataChanged
    global Lcl_wGADE_DataChanged

    if { $Lcl_wGADE_DataChanged == 1 } {
        ExportLclVars_wGADE
        set g_WingDataChanged       1
        set Lcl_wGADE_DataChanged    0
    }

    UnsetLclVarTrace_wGADE
    destroy .wgade
}

#----------------------------------------------------------------------
#  CancelButtonPress_wGADE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wGADE {} {
    global .wgade
    global g_WingDataChanged
    global Lcl_wGADE_DataChanged

    if { $Lcl_wGADE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wgade
            return 0
        }
    }

    set Lcl_wGADE_DataChanged 0
    UnsetLclVarTrace_wGADE
    destroy .wgade

}

#----------------------------------------------------------------------
#  HelpButtonPress_wGADE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wGADE {} {
    source "userHelp.tcl"

    displayHelpfile "global-aoa-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wGADE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wGADE {} {

    global AllGlobalVars_wGADE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGADE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wGADE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wGADE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wGADE {} {

    global AllGlobalVars_wGADE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGADE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wGADE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wGADE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wGADE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wGADE_DataChanged

    set Lcl_wGADE_DataChanged 1
}
