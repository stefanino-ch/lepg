#---------------------------------------------------------------------
#
#  Window to edit the wing airfoils data
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
global .wade

global  Lcl_wADE_DataChanged
set     Lcl_wADE_DataChanged    0

global  AllGlobalVars_wADE
set     AllGlobalVars_wADE { airfoilName ribConfig }


#----------------------------------------------------------------------
#  wingAirfolilsDataEdit
#  Displays a window to edit the wing airfoils data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingAirfoilsDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wade

    global Lcl_ribConfig
    global numRibsHalf

    SetLclVars_wADE

    toplevel .wade
    focus .wade

    wm protocol .wade WM_DELETE_WINDOW { CancelButtonPress_wADE }

    wm title .wade [::msgcat::mc "Wing Airfoils Data"]

    #-------------
    # Frames and grids
    ttk::frame      .wade.data
    ttk::labelframe .wade.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wade.btn
    #
    grid .wade.data         -row 0 -column 0 -sticky e
    grid .wade.help         -row 1 -column 0 -sticky e
    grid .wade.btn          -row 2 -column 0 -sticky e
    #
    #-------------
    # Data fields setup

    # do the header
    ttk::label .wade.data.title1 -text [::msgcat::mc "Rib Num"] -width 10 -anchor e
    ttk::label .wade.data.title2 -text [::msgcat::mc "Airfoil name"] -width 20 -anchor w
    ttk::label .wade.data.title3 -text [::msgcat::mc "% cord inlet start"] -width 20 -anchor w
    ttk::label .wade.data.title4 -text [::msgcat::mc "% cord inlet stop"] -width 20 -anchor w
    ttk::label .wade.data.title5 -text [::msgcat::mc "Closed/ open cell"] -width 20 -anchor w
    ttk::label .wade.data.title6 -text [::msgcat::mc "Disp."] -width 20 -anchor w
    ttk::label .wade.data.title7 -text [::msgcat::mc "rweight"] -width 20 -anchor w
    ttk::label .wade.data.title8 -text [::msgcat::mc "Rot/ % Mini Rib"] -width 20 -anchor w
    # Add header fields to grid
    set i 1
    while {$i <= 8 } {
        grid .wade.data.title$i -row 0 -column [expr $i -1] -sticky e -padx 0 -pady 0
        incr i
    }

    # do a line for each rib
    set i 1
    while {$i <= $numRibsHalf} {

        ttk::label  .wade.data.numRib$i -text $i -width 20 -anchor e
        grid        .wade.data.numRib$i -row [expr $i] -column 0 -sticky e

        ttk::entry  .wade.data.e_airfoilName$i -width 20 -textvariable Lcl_airfoilName($i)
        SetHelpBind .wade.data.e_airfoilName$i airfoilName HelpText_wADE
        grid        .wade.data.e_airfoilName$i -row [expr $i] -column 1 -sticky e

        ttk::entry  .wade.data.e_inletStart$i -width 20 -textvariable Lcl_ribConfig($i,11)
        SetHelpBind .wade.data.e_inletStart$i inletStartPerc HelpText_wADE
        grid        .wade.data.e_inletStart$i -row [expr $i] -column 2 -sticky e

        ttk::entry  .wade.data.e_inletStop$i -width 20 -textvariable Lcl_ribConfig($i,12)
        SetHelpBind .wade.data.e_inletStop$i inletStopPerc HelpText_wADE
        grid        .wade.data.e_inletStop$i -row [expr $i] -column 3 -sticky e

        ttk::entry  .wade.data.e_closedOpen$i -width 20 -textvariable Lcl_ribConfig($i,14)
        SetHelpBind .wade.data.e_closedOpen$i closedOpenCell HelpText_wADE
        grid        .wade.data.e_closedOpen$i -row [expr $i] -column 4 -sticky e

        ttk::entry  .wade.data.e_disp$i -width 20 -textvariable Lcl_ribConfig($i,50)
        SetHelpBind .wade.data.e_disp$i ribDisplacement HelpText_wADE
        grid        .wade.data.e_disp$i -row [expr $i] -column 5 -sticky e

        ttk::entry  .wade.data.e_rweight$i -width 20 -textvariable Lcl_ribConfig($i,55)
        SetHelpBind .wade.data.e_rweight$i relWeightChord HelpText_wADE
        grid        .wade.data.e_rweight$i -row [expr $i] -column 6 -sticky e

        ttk::entry  .wade.data.e_rotMini$i -width 20 -textvariable Lcl_ribConfig($i,56)
        SetHelpBind .wade.data.e_rotMini$i rotMiniRIbPerc HelpText_wADE
        grid        .wade.data.e_rotMini$i -row [expr $i] -column 7 -sticky e

        ttk::label  .wade.data.spacer$i -text "" -width 5 -anchor e
        grid        .wade.data.spacer$i -row [expr $i] -column 8 -sticky e

        incr i
    }

    #-------------
    # explanations
    label .wade.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wADE
    grid  .wade.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wade.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wADE
    button .wade.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wADE
    button .wade.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wADE
    button .wade.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wADE

    grid .wade.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wade.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wade.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wade.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wADE
}

#----------------------------------------------------------------------
#  SetLclVars_wADE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wADE {} {
    source "globalWingVars.tcl"

    global Lcl_ribConfig
    global Lcl_airfoilName

    set i 1
    while {$i <= $numRibsHalf} {

        set Lcl_airfoilName($i) $airfoilName($i)

        set Lcl_ribConfig($i,11) $ribConfig($i,11)
        set Lcl_ribConfig($i,12) $ribConfig($i,12)
        set Lcl_ribConfig($i,14) $ribConfig($i,14)
        set Lcl_ribConfig($i,50) $ribConfig($i,50)
        set Lcl_ribConfig($i,55) $ribConfig($i,55)
        set Lcl_ribConfig($i,56) $ribConfig($i,56)

        incr i
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wADE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wADE {} {
    source "globalWingVars.tcl"

    global Lcl_ribConfig
    global Lcl_airfoilName

    set i 1
    while {$i <= $numRibsHalf} {

        set airfoilName($i) $Lcl_airfoilName($i)

        set ribConfig($i,11) $Lcl_ribConfig($i,11)
        set ribConfig($i,12) $Lcl_ribConfig($i,12)
        set ribConfig($i,14) $Lcl_ribConfig($i,14)
        set ribConfig($i,50) $Lcl_ribConfig($i,50)
        set ribConfig($i,55) $Lcl_ribConfig($i,55)
        set ribConfig($i,56) $Lcl_ribConfig($i,56)

        incr i
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wADE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wADE {} {
    global g_WingDataChanged
    global Lcl_wADE_DataChanged

    if { $Lcl_wADE_DataChanged == 1 } {
        ExportLclVars_wADE

        set g_WingDataChanged       1
        set Lcl_wADE_DataChanged    0
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
proc OkButtonPress_wADE {} {
    global .wade
    global g_WingDataChanged
    global Lcl_wADE_DataChanged

    if { $Lcl_wADE_DataChanged == 1 } {
        ExportLclVars_wADE
        set g_WingDataChanged       1
        set Lcl_wADE_DataChanged    0
    }

    UnsetLclVarTrace_wADE
    destroy .wade
}

#----------------------------------------------------------------------
#  CancelButtonPress_wADE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wADE {} {
    global .wade
    global g_WingDataChanged
    global Lcl_wADE_DataChanged

    if { $Lcl_wADE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wade
            return 0
        }
    }

    set Lcl_wADE_DataChanged 0
    UnsetLclVarTrace_wADE
    destroy .wade

}

#----------------------------------------------------------------------
#  HelpButtonPress_wADE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wADE {} {
    source "userHelp.tcl"

    displayHelpfile "airfoil-basic-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wADE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wADE {} {

    global AllGlobalVars_wADE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wADE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wADE }
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
proc UnsetLclVarTrace_wADE {} {

    global AllGlobalVars_wADE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wADE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wADE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wADE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wADE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wADE_DataChanged

    set Lcl_wADE_DataChanged 1
}
