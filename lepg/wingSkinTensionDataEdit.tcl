#---------------------------------------------------------------------
#
#  Window to edit the wing skin tension data
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global .wstde

global  Lcl_wSTDE_DataChanged
set     Lcl_wSTDE_DataChanged    0

global  AllGlobalVars_wSTDE
set     AllGlobalVars_wSTDE { skinTens strainMiniRibs numStrainPoints strainCoef }

#----------------------------------------------------------------------
#  wingSkinTensionDataEdit
#  Displays a window to edit the wing skin tension data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingSkinTensionDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wstde

    global Lcl_skinTens
    global Lcl_strainMiniRibs
    global Lcl_numStrainPoints
    global Lcl_strainCoef

    SetLclVars_wSTDE

    toplevel .wstde
    focus .wstde

    wm protocol .wstde WM_DELETE_WINDOW { CancelButtonPress_wSTDE }

    wm title .wstde [::msgcat::mc "Skin Tension Data"]

    #-------------
    # Frames and grids
    ttk::frame      .wstde.data
    ttk::labelframe .wstde.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wstde.btn
    #
    grid .wstde.data         -row 0 -column 0 -sticky e
    grid .wstde.help         -row 1 -column 0 -sticky e
    grid .wstde.btn          -row 2 -column 0 -sticky e
    #
    #-------------
    # Data fields setup

    # do the header
    ttk::label .wstde.data.title1 -text [::msgcat::mc "Num"] -width 10 -anchor e
    ttk::label .wstde.data.title2 -text [::msgcat::mc "Top panel % chord"] -width 20 -anchor w
    ttk::label .wstde.data.title3 -text [::msgcat::mc "Top panel over wide %"] -width 20 -anchor w
    ttk::label .wstde.data.title4 -text [::msgcat::mc "Lower panel % chord"] -width 20 -anchor w
    ttk::label .wstde.data.title5 -text [::msgcat::mc "Lower panel over wide %"] -width 20 -anchor w

    # Add header fields to grid
    set i 1
    while {$i <= 5 } {
        grid .wstde.data.title$i -row 0 -column [expr $i -1] -sticky e -padx 0 -pady 0
        incr i
    }

    # do the 6 data lines
    for {set i 1} {$i <= 6} {incr i} {

        ttk::label  .wstde.data.numRib$i -text $i -width 20 -anchor e
        grid        .wstde.data.numRib$i -row [expr $i] -column 0 -sticky e

        ttk::entry  .wstde.data.e_topPanChord$i -width 20 -textvariable Lcl_skinTens($i,1)
        SetHelpBind .wstde.data.e_topPanChord$i topPanelChordPerc HelpText_wSTDE
        grid        .wstde.data.e_topPanChord$i -row [expr $i] -column 1 -sticky e

        ttk::entry  .wstde.data.e_topPanOW$i -width 20 -textvariable Lcl_skinTens($i,2)
        SetHelpBind .wstde.data.e_topPanOW$i topPanelOverWide HelpText_wSTDE
        grid        .wstde.data.e_topPanOW$i -row [expr $i] -column 2 -sticky e

        ttk::entry  .wstde.data.e_lowPanChord$i -width 20 -textvariable Lcl_skinTens($i,3)
        SetHelpBind .wstde.data.e_lowPanChord$i lowPanelChordPerc HelpText_wSTDE
        grid        .wstde.data.e_lowPanChord$i -row [expr $i] -column 3 -sticky e

        ttk::entry  .wstde.data.e_lowPanOW$i -width 20 -textvariable Lcl_skinTens($i,4)
        SetHelpBind .wstde.data.e_lowPanOW$i lowPanelOverWide HelpText_wSTDE
        grid        .wstde.data.e_lowPanOW$i -row [expr $i] -column 4 -sticky e

        ttk::label  .wstde.data.spacer$i -text "" -width 5 -anchor e
        grid        .wstde.data.spacer$i -row [expr $i] -column 5 -sticky e
    }

    # add the additional params
    ttk::label  .wstde.data.spacer1_wSTDE     -text "" -width 20 -anchor e
    grid        .wstde.data.spacer1_wSTDE     -row 7 -column 0 -sticky e

    ttk::label  .wstde.data.strain   -text "Strain in mini-ribs" -width 20 -anchor e
    grid        .wstde.data.strain   -row 8 -column 0 -sticky e
    ttk::entry  .wstde.data.e_strain -width 20 -textvariable Lcl_strainMiniRibs
    SetHelpBind .wstde.data.e_strain  strainMiniRibs  HelpText_wSTDE
    grid        .wstde.data.e_strain -row 8 -column 1 -sticky e

    ttk::label  .wstde.data.numPoi  -text "Num of points" -width 20 -anchor e
    grid        .wstde.data.numPoi  -row 9 -column 0 -sticky e
    ttk::entry  .wstde.data.e_numPoi    -width 20 -textvariable Lcl_numStrainPoints
    SetHelpBind .wstde.data.e_numPoi  numStrainPoints  HelpText_wSTDE
    grid        .wstde.data.e_numPoi  -row 9 -column 1 -sticky e

    ttk::label  .wstde.data.coeff   -text "Coefficient" -width 20 -anchor e
    grid        .wstde.data.coeff   -row 10 -column 0 -sticky e
    ttk::entry  .wstde.data.e_coeff -width 20 -textvariable Lcl_strainCoef
    SetHelpBind .wstde.data.e_coeff strainCoef HelpText_wSTDE
    grid        .wstde.data.e_coeff   -row 10 -column 1 -sticky e

    ttk::label  .wstde.data.spacer2_wSTDE     -text "" -width 20 -anchor e
    grid        .wstde.data.spacer2_wSTDE     -row 11 -column 0 -sticky e

    #-------------
    # explanations
    label .wstde.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wSTDE
    grid  .wstde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wstde.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wSTDE
    button .wstde.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wSTDE
    button .wstde.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wSTDE
    button .wstde.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wSTDE

    grid .wstde.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wstde.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wstde.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wstde.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wSTDE
}

#----------------------------------------------------------------------
#  SetLclVars_wSTDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wSTDE {} {
    source "globalWingVars.tcl"

    global Lcl_skinTens
    global Lcl_strainMiniRibs
    global Lcl_numStrainPoints
    global Lcl_strainCoef

    for {set i 1} {$i <= 6} {incr i} {
        for {set j 1} {$j <= 4} {incr j} {
            set Lcl_skinTens($i,$j) $skinTens($i,$j)
        }
    }

    set Lcl_strainMiniRibs  $strainMiniRibs
    set Lcl_numStrainPoints $numStrainPoints
    set Lcl_strainCoef      $strainCoef

}

#----------------------------------------------------------------------
#  ExportLclVars_wSTDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wSTDE {} {
    source "globalWingVars.tcl"

    global Lcl_skinTens
    global Lcl_strainMiniRibs
    global Lcl_numStrainPoints
    global Lcl_strainCoef

    for {set i 1} {$i <= 6} {incr i} {
        for {set j 1} {$j <= 4} {incr j} {
            set skinTens($i,$j) $Lcl_skinTens($i,$j)
        }
    }

    set strainMiniRibs  $Lcl_strainMiniRibs
    set numStrainPoints $Lcl_numStrainPoints
    set strainCoef      $Lcl_strainCoef
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wSTDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wSTDE {} {
    global g_WingDataChanged
    global Lcl_wSTDE_DataChanged

    if { $Lcl_wSTDE_DataChanged == 1 } {
        ExportLclVars_wSTDE

        set g_WingDataChanged       1
        set Lcl_wSTDE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wSTDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wSTDE {} {
    global .wstde
    global g_WingDataChanged
    global Lcl_wSTDE_DataChanged

    if { $Lcl_wSTDE_DataChanged == 1 } {
        ExportLclVars_wSTDE
        set g_WingDataChanged       1
        set Lcl_wSTDE_DataChanged    0
    }

    UnsetLclVarTrace_wSTDE
    destroy .wstde
}

#----------------------------------------------------------------------
#  CancelButtonPress_wSTDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wSTDE {} {
    global .wstde
    global g_WingDataChanged
    global Lcl_wSTDE_DataChanged

    if { $Lcl_wSTDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wstde
            return 0
        }
    }

    set Lcl_wSTDE_DataChanged 0
    UnsetLclVarTrace_wSTDE
    destroy .wstde

}

#----------------------------------------------------------------------
#  HelpButtonPress_wSTDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wSTDE {} {
    source "userHelp.tcl"

    displayHelpfile "skin-tension-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wSTDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wSTDE {} {

    global AllGlobalVars_wSTDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSTDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wSTDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wSTDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wSTDE {} {

    global AllGlobalVars_wSTDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSTDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wSTDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wSTDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wSTDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wSTDE_DataChanged

    set Lcl_wSTDE_DataChanged 1
}
