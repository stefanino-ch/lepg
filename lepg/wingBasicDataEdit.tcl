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
global .wbde

global  Lcl_wBDE_DataChanged
set     Lcl_wBDE_DataChanged    0

global  AllGlobalVars_wBDE
set     AllGlobalVars_wBDE {brandName wingName drawScale wingScale}


#----------------------------------------------------------------------
#  wingBasicDataEdit
#  Displays a window to edit the basic wing data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingBasicDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wbde

    global Lcl_brandName
    global Lcl_wingName
    global Lcl_drawScale
    global Lcl_wingScale

    SetLclVars_wBDE

    toplevel .wbde
    focus .wbde

    wm protocol .wbde WM_DELETE_WINDOW { CancelButtonPress_wBDE }

    wm title .wbde [::msgcat::mc "Wing Basic Data"]

    #-------------
    # Frames and grids
    ttk::frame      .wbde.data
    ttk::labelframe .wbde.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wbde.btn
    #
    grid .wbde.data         -row 0 -column 0 -sticky e
    grid .wbde.help         -row 1 -column 0 -sticky e
    grid .wbde.btn          -row 2 -column 0 -sticky e
    #
    #-------------
    # Data fields setup
    ttk::label .wbde.data.brandName -text [::msgcat::mc "Brand Name"] -width 20
    ttk::entry .wbde.data.e_brandName -width 30 -textvariable Lcl_brandName
    ttk::label .wbde.data.wingName -text [::msgcat::mc "Wing Name"] -width 20
    ttk::entry .wbde.data.e_wingName -width 30 -textvariable Lcl_wingName
    ttk::label .wbde.data.drawScale -text [::msgcat::mc "Draw Scale"] -width 20
    ttk::entry .wbde.data.e_drawScale -width 30 -textvariable Lcl_drawScale
    ttk::label .wbde.data.wingScale -text [::msgcat::mc "Wing Scale"] -width 20
    ttk::entry .wbde.data.e_wingScale -width 30 -textvariable Lcl_wingScale

    SetHelpBind .wbde.data.e_brandName brandName HelpText_wBDE
    SetHelpBind .wbde.data.e_wingName  wingName  HelpText_wBDE
    SetHelpBind .wbde.data.e_drawScale drawScale HelpText_wBDE
    SetHelpBind .wbde.data.e_wingScale wingScale HelpText_wBDE

    #-------------
    # Add data fields to grid
    grid .wbde.data.brandName   -row 0 -column 0 -sticky e -padx 10 -pady 3
    grid .wbde.data.e_brandName -row 0 -column 1 -sticky w -padx 10 -pady 3
    grid .wbde.data.wingName    -row 1 -column 0 -sticky e -padx 10 -pady 3
    grid .wbde.data.e_wingName  -row 1 -column 1 -sticky w -padx 10 -pady 3
    grid .wbde.data.drawScale   -row 2 -column 0 -sticky e -padx 10 -pady 3
    grid .wbde.data.e_drawScale -row 2 -column 1 -sticky w -padx 10 -pady 3
    grid .wbde.data.wingScale   -row 3 -column 0 -sticky e -padx 10 -pady 3
    grid .wbde.data.e_wingScale -row 3 -column 1 -sticky w -padx 10 -pady 3

    #-------------
    # explanations
    label .wbde.help.e_help -width 40 -height 3 -background LightYellow -textvariable HelpText_wBDE
    grid  .wbde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wbde.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wBDE
    button .wbde.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wBDE
    button .wbde.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wBDE
    button .wbde.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wBDE

    grid .wbde.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wbde.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wbde.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wbde.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wBDE
}

#----------------------------------------------------------------------
#  SetLclVars_wBDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wBDE {} {

    source "globalWingVars.tcl"
    global Lcl_brandName
    global Lcl_wingName
    global Lcl_drawScale
    global Lcl_wingScale

    set Lcl_brandName   $brandName
    set Lcl_wingName    $wingName
    set Lcl_drawScale   $drawScale
    set Lcl_wingScale   $wingScale

}

#----------------------------------------------------------------------
#  ExportLclVars_wBDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wBDE {} {
    source "globalWingVars.tcl"
    global Lcl_brandName
    global Lcl_wingName
    global Lcl_drawScale
    global Lcl_wingScale

    set brandName   $Lcl_brandName
    set wingName    $Lcl_wingName
    set drawScale   $Lcl_drawScale
    set wingScale   $Lcl_wingScale
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wBDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wBDE {} {
    global g_WingDataChanged
    global Lcl_wBDE_DataChanged

    if { $Lcl_wBDE_DataChanged == 1 } {
        ExportLclVars_wBDE

        set g_WingDataChanged       1
        set Lcl_wBDE_DataChanged    0
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
proc OkButtonPress_wBDE {} {
    global .wbde
    global g_WingDataChanged
    global Lcl_wBDE_DataChanged

    if { $Lcl_wBDE_DataChanged == 1 } {
        ExportLclVars_wBDE
        set g_WingDataChanged       1
        set Lcl_wBDE_DataChanged    0
    }

    UnsetLclVarTrace_wBDE
    destroy .wbde
}

#----------------------------------------------------------------------
#  CancelButtonPress_wBDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wBDE {} {
    global .wbde
    global g_WingDataChanged
    global Lcl_wBDE_DataChanged

    if { $Lcl_wBDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wbde
            return 0
        }
    }

    set Lcl_wBDE_DataChanged 0
    UnsetLclVarTrace_wBDE
    destroy .wbde

}

#----------------------------------------------------------------------
#  HelpButtonPress_wBDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wBDE {} {
    source "userHelp.tcl"

    displayHelpfile "wing-basic-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wBDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wBDE {} {

    global AllGlobalVars_wBDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wBDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wBDE }
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
proc UnsetLclVarTrace_wBDE {} {

    global AllGlobalVars_wBDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wBDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wBDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wBDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wBDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wBDE_DataChanged

    set Lcl_wBDE_DataChanged 1
}
