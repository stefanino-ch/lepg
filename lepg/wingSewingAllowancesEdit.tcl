#---------------------------------------------------------------------
#
#  Window to edit the basic wing data
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
global .wsae

global  Lcl_wSAE_DataChanged
set     Lcl_wSAE_DataChanged    0

global  AllGlobalVars_wSAE
set     AllGlobalVars_wSAE {seamUp seamUpLe seamUpTe seamLo seamLoLe seamLoTe seamRib seamVRib}

#----------------------------------------------------------------------
#  wingSewingAllowancesEdit
#  Displays a window to edit the basic wing data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingSewingAllowancesEdit {} {
    source "globalWingVars.tcl"
    global AllGlobalVars_wSAE

    source "windowExplanationsHelper.tcl"

    global .wsae

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSAE {
        global Lcl_$e
    }

    SetLclVars_wSAE

    toplevel .wsae
    focus .wsae

    wm protocol .wsae WM_DELETE_WINDOW { CancelButtonPress_wSAE }

    wm title .wsae [::msgcat::mc "Wing Sewing Allowances"]

    #-------------
    # Frames and grids
    ttk::frame      .wsae.data
    ttk::labelframe .wsae.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wsae.btn
    #
    grid .wsae.data         -row 0 -column 0 -sticky e
    grid .wsae.help         -row 1 -column 0 -sticky e
    grid .wsae.btn          -row 2 -column 0 -sticky e
    #
    #-------------
    # Data fields setup
    ttk::label .wsae.data.edge -text [::msgcat::mc "Edge"] -width 15
    ttk::label .wsae.data.le -text [::msgcat::mc "Leading Edge"] -width 15
    ttk::label .wsae.data.te -text [::msgcat::mc "Trailing Edge"] -width 15

    ttk::label .wsae.data.upperPanel -text [::msgcat::mc "Upper Panel \[mm\]"] -width 18
    ttk::entry .wsae.data.e_seamUp -width 10 -textvariable Lcl_seamUp
    ttk::entry .wsae.data.e_seamUpLe -width 10 -textvariable Lcl_seamUpLe
    ttk::entry .wsae.data.e_seamUpTe -width 10 -textvariable Lcl_seamUpTe

    ttk::label .wsae.data.lowerPanel -text [::msgcat::mc "Lower Panel \[mm\]"] -width 18
    ttk::entry .wsae.data.e_seamLo -width 10 -textvariable Lcl_seamLo
    ttk::entry .wsae.data.e_seamLoLe -width 10 -textvariable Lcl_seamLoLe
    ttk::entry .wsae.data.e_seamLoTe -width 10 -textvariable Lcl_seamLoTe

    ttk::label .wsae.data.seamRib -text [::msgcat::mc "Ribs \[mm\]"] -width 18
    ttk::entry .wsae.data.e_seamRib -width 10 -textvariable Lcl_seamRib

    ttk::label .wsae.data.seamVRib -text [::msgcat::mc "V-Ribs \[mm\]"] -width 18
    ttk::entry .wsae.data.e_seamVRib -width 10 -textvariable Lcl_seamVRib

    SetHelpBind .wsae.data.e_seamUp   seamUp   HelpText_wSAE
    SetHelpBind .wsae.data.e_seamUpLe seamUpLe HelpText_wSAE
    SetHelpBind .wsae.data.e_seamUpTe seamUpTe HelpText_wSAE

    SetHelpBind .wsae.data.e_seamLo   seamLo   HelpText_wSAE
    SetHelpBind .wsae.data.e_seamLoLe seamLoLe HelpText_wSAE
    SetHelpBind .wsae.data.e_seamLoTe seamLoTe HelpText_wSAE

    SetHelpBind .wsae.data.e_seamRib  seamRib   HelpText_wSAE
    SetHelpBind .wsae.data.e_seamVRib seamVRib  HelpText_wSAE

    #-------------
    # Add data fields to grid
    grid .wsae.data.edge        -row 0 -column 1 -sticky e -padx 10 -pady 3
    grid .wsae.data.le          -row 0 -column 2 -sticky e -padx 10 -pady 3
    grid .wsae.data.te          -row 0 -column 3 -sticky e -padx 10 -pady 3

    grid .wsae.data.upperPanel  -row 1 -column 0 -sticky e -padx 10 -pady 3
    grid .wsae.data.e_seamUp    -row 1 -column 1 -sticky w -padx 10 -pady 3
    grid .wsae.data.e_seamUpLe  -row 1 -column 2 -sticky w -padx 10 -pady 3
    grid .wsae.data.e_seamUpTe  -row 1 -column 3 -sticky w -padx 10 -pady 3

    grid .wsae.data.lowerPanel  -row 2 -column 0 -sticky e -padx 10 -pady 3
    grid .wsae.data.e_seamLo    -row 2 -column 1 -sticky w -padx 10 -pady 3
    grid .wsae.data.e_seamLoLe  -row 2 -column 2 -sticky w -padx 10 -pady 3
    grid .wsae.data.e_seamLoTe  -row 2 -column 3 -sticky w -padx 10 -pady 3

    grid .wsae.data.seamRib     -row 3 -column 0 -sticky e -padx 10 -pady 3
    grid .wsae.data.e_seamRib   -row 3 -column 1 -sticky w -padx 10 -pady 3

    grid .wsae.data.seamVRib   -row 4 -column 0 -sticky e -padx 10 -pady 3
    grid .wsae.data.e_seamVRib -row 4 -column 1 -sticky w -padx 10 -pady 3

    #-------------
    # explanations
    label .wsae.help.e_help -width 40 -height 3 -background LightYellow -textvariable HelpText_wSAE
    grid  .wsae.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wsae.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wSAE
    button .wsae.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wSAE
    button .wsae.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wSAE
    button .wsae.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wSAE

    grid .wsae.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wsae.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wsae.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wsae.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wSAE
}

#----------------------------------------------------------------------
#  SetLclVars_wSAE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wSAE {} {

    source "globalWingVars.tcl"
    global AllGlobalVars_wSAE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSAE {
        global Lcl_$e
    }

    set Lcl_seamUp      $seamUp
    set Lcl_seamUpLe    $seamUpLe
    set Lcl_seamUpTe    $seamUpTe
    set Lcl_seamLo      $seamLo
    set Lcl_seamLoLe    $seamLoLe
    set Lcl_seamLoTe    $seamLoTe
    set Lcl_seamRib     $seamRib
    set Lcl_seamVRib    $seamVRib
}

#----------------------------------------------------------------------
#  ExportLclVars_wSAE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wSAE {} {
    source "globalWingVars.tcl"
    global AllGlobalVars_wSAE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSAE {
        global Lcl_$e
    }

    set seamUp      $Lcl_seamUp
    set seamUpLe    $Lcl_seamUpLe
    set seamUpTe    $Lcl_seamUpTe
    set seamLo      $Lcl_seamLo
    set seamLoLe    $Lcl_seamLoLe
    set seamLoTe    $Lcl_seamLoTe
    set seamRib     $Lcl_seamRib
    set seamVRib    $Lcl_seamVRib    
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wSAE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wSAE {} {
    global g_WingDataChanged
    global Lcl_wSAE_DataChanged

    if { $Lcl_wSAE_DataChanged == 1 } {
        ExportLclVars_wSAE

        set g_WingDataChanged       1
        set Lcl_wSAE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wSAE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wSAE {} {
    global .wsae
    global g_WingDataChanged
    global Lcl_wSAE_DataChanged

    if { $Lcl_wSAE_DataChanged == 1 } {
        ExportLclVars_wSAE
        set g_WingDataChanged       1
        set Lcl_wSAE_DataChanged    0
    }

    UnsetLclVarTrace_wSAE
    destroy .wsae
}

#----------------------------------------------------------------------
#  CancelButtonPress_wSAE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wSAE {} {
    global .wsae
    global g_WingDataChanged
    global Lcl_wSAE_DataChanged

    if { $Lcl_wSAE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wsae
            return 0
        }
    }

    set Lcl_wSAE_DataChanged 0
    UnsetLclVarTrace_wSAE
    destroy .wsae

}

#----------------------------------------------------------------------
#  HelpButtonPress_wSAE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wSAE {} {
    source "userHelp.tcl"

    displayHelpfile "wing-sewing-allowances"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wSAE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wSAE {} {

    global AllGlobalVars_wSAE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSAE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wSAE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wSAE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wSAE {} {

    global AllGlobalVars_wSAE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSAE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wSAE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wSAE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wSAE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wSAE_DataChanged

    set Lcl_wSAE_DataChanged 1
}
