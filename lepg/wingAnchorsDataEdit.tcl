#---------------------------------------------------------------------
#
#  Window to edit the wing anchors data
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global .wande

global  Lcl_wAnDE_DataChanged
set     Lcl_wAnDE_DataChanged    0

global  AllGlobalVars_wAnDE
set     AllGlobalVars_wAnDE { ribConfig numRibsHalf }


#----------------------------------------------------------------------
#  wingAnchorsDataEdit
#  Displays a window to edit the anchor data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingAnchorsDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wande

    global Lcl_ribConfig
    global numRibsHalf

    SetLclVars_wAnDE

    toplevel .wande
    focus .wande

    wm protocol .wande WM_DELETE_WINDOW { CancelButtonPress_wAnDE }

    wm title .wande [::msgcat::mc "Wing Anchors Data"]

    #-------------
    # Frames and grids
    ttk::frame      .wande.data
    ttk::labelframe .wande.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wande.btn
    #
    grid .wande.data         -row 0 -column 0 -sticky e
    grid .wande.help         -row 1 -column 0 -sticky e
    grid .wande.btn          -row 2 -column 0 -sticky e
    #
    #-------------
    # Data fields setup

    # do the header
    ttk::label .wande.data.title1 -text [::msgcat::mc "Rib Num"] -width 10 -anchor e
    ttk::label .wande.data.title2 -text [::msgcat::mc "A"] -width 20 -anchor w
    ttk::label .wande.data.title3 -text [::msgcat::mc "B"] -width 20 -anchor w
    ttk::label .wande.data.title4 -text [::msgcat::mc "C"] -width 20 -anchor w
    ttk::label .wande.data.title5 -text [::msgcat::mc "D"] -width 20 -anchor w
    ttk::label .wande.data.title6 -text [::msgcat::mc "E"] -width 20 -anchor w
    ttk::label .wande.data.title7 -text [::msgcat::mc "Brakes"] -width 20 -anchor w

    # Add header fields to grid
    set i 1
    while {$i <= 7 } {
        grid .wande.data.title$i -row 0 -column [expr $i -1] -sticky e -padx 0 -pady 0
        incr i
    }

    # do a line for each rib
    set i 1
    while {$i <= $numRibsHalf} {

        ttk::label  .wande.data.numRib$i -text $i -width 20 -anchor e
        grid        .wande.data.numRib$i -row [expr $i] -column 0 -sticky e

        ttk::entry  .wande.data.e_A$i -width 20 -textvariable Lcl_ribConfig($i,16)
        SetHelpBind .wande.data.e_A$i anchorPosA HelpText_wAnDE
        grid        .wande.data.e_A$i -row [expr $i] -column 1 -sticky e

        ttk::entry  .wande.data.e_B$i -width 20 -textvariable Lcl_ribConfig($i,17)
        SetHelpBind .wande.data.e_B$i anchorPosB HelpText_wAnDE
        grid        .wande.data.e_B$i -row [expr $i] -column 2 -sticky e

        ttk::entry  .wande.data.e_C$i -width 20 -textvariable Lcl_ribConfig($i,18)
        SetHelpBind .wande.data.e_C$i anchorPosC HelpText_wAnDE
        grid        .wande.data.e_C$i -row [expr $i] -column 3 -sticky e

        ttk::entry  .wande.data.e_D$i -width 20 -textvariable Lcl_ribConfig($i,19)
        SetHelpBind .wande.data.e_D$i anchorPosD HelpText_wAnDE
        grid        .wande.data.e_D$i -row [expr $i] -column 4 -sticky e

        ttk::entry  .wande.data.e_E$i -width 20 -textvariable Lcl_ribConfig($i,20)
        SetHelpBind .wande.data.e_E$i anchorPosE HelpText_wAnDE
        grid        .wande.data.e_E$i -row [expr $i] -column 5 -sticky e

        ttk::entry  .wande.data.e_F$i -width 20 -textvariable Lcl_ribConfig($i,21)
        SetHelpBind .wande.data.e_F$i anchorPosF HelpText_wAnDE
        grid        .wande.data.e_F$i -row [expr $i] -column 6 -sticky e

        ttk::label  .wande.data.spacer$i -text "" -width 5 -anchor e
        grid        .wande.data.spacer$i -row [expr $i] -column 7 -sticky e

        incr i
    }

    #-------------
    # explanations
    label .wande.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wAnDE
    grid  .wande.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wande.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wAnDE
    button .wande.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wAnDE
    button .wande.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wAnDE
    button .wande.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wAnDE

    grid .wande.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wande.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wande.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wande.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wAnDE
}

#----------------------------------------------------------------------
#  SetLclVars_wAnDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wAnDE {} {
    source "globalWingVars.tcl"

    global Lcl_ribConfig

    set i 1
    while {$i <= $numRibsHalf} {

        set Lcl_ribConfig($i,1) $ribConfig($i,1)
        set Lcl_ribConfig($i,15) $ribConfig($i,15)
        set Lcl_ribConfig($i,16) $ribConfig($i,16)
        set Lcl_ribConfig($i,17) $ribConfig($i,17)
        set Lcl_ribConfig($i,18) $ribConfig($i,18)
        set Lcl_ribConfig($i,19) $ribConfig($i,19)
        set Lcl_ribConfig($i,20) $ribConfig($i,20)
        set Lcl_ribConfig($i,21) $ribConfig($i,21)

        incr i
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wAnDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wAnDE {} {
    source "globalWingVars.tcl"

    global Lcl_ribConfig

    set i 1
    while {$i <= $numRibsHalf} {

        set ribConfig($i,1) $Lcl_ribConfig($i,1)
        # set ribConfig($i,15) $Lcl_ribConfig($i,15)
        set ribConfig($i,16) $Lcl_ribConfig($i,16)
        set ribConfig($i,17) $Lcl_ribConfig($i,17)
        set ribConfig($i,18) $Lcl_ribConfig($i,18)
        set ribConfig($i,19) $Lcl_ribConfig($i,19)
        set ribConfig($i,20) $Lcl_ribConfig($i,20)
        set ribConfig($i,21) $Lcl_ribConfig($i,21)

        # set num of anchors to 0
        set ribConfig($i,15) 0
        foreach j {16 17 18 19 20} {
            if { [string is double $Lcl_ribConfig($i,$j)] } {
                # yes we have a double value
                if { $Lcl_ribConfig($i,$j) > 0 } {
                    # valid, increment number of anchors
                    incr ribConfig($i,15)
                }
                if { $Lcl_ribConfig($i,$j) == 0 } {
                    # end of line (value = 0) reached
                    break
                }
            } else {
                # there's not a double value
                break
            }
        }
        incr i
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wAnDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wAnDE {} {
    global g_WingDataChanged
    global Lcl_wAnDE_DataChanged

    if { $Lcl_wAnDE_DataChanged == 1 } {
        ExportLclVars_wAnDE

        set g_WingDataChanged       1
        set Lcl_wAnDE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wBDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wAnDE {} {
    global .wande
    global g_WingDataChanged
    global Lcl_wAnDE_DataChanged

    if { $Lcl_wAnDE_DataChanged == 1 } {
        ExportLclVars_wAnDE
        set g_WingDataChanged       1
        set Lcl_wAnDE_DataChanged    0
    }

    UnsetLclVarTrace_wAnDE
    destroy .wande
}

#----------------------------------------------------------------------
#  CancelButtonPress_wAnDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wAnDE {} {
    global .wande
    global g_WingDataChanged
    global Lcl_wAnDE_DataChanged

    if { $Lcl_wAnDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wande
            return 0
        }
    }

    set Lcl_wAnDE_DataChanged 0
    UnsetLclVarTrace_wAnDE
    destroy .wande

}

#----------------------------------------------------------------------
#  HelpButtonPress_wAnDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wAnDE {} {
    source "userHelp.tcl"

    displayHelpfile "anchors-basic-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wAnDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wAnDE {} {

    global AllGlobalVars_wAnDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wAnDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wAnDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wBDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wAnDE {} {

    global AllGlobalVars_wAnDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wAnDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wAnDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wAnDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wAnDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wAnDE_DataChanged

    set Lcl_wAnDE_DataChanged 1
}
