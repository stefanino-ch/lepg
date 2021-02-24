#---------------------------------------------------------------------
#
#  Window to edit the washin parameters
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

global  Lcl_wWASHIN_DataChanged
set     Lcl_wWASHIN_DataChanged    0

global  AllGlobalVars_wWASHIN
set     AllGlobalVars_wWASHIN { alphaMax washinMode alphaCenter }
      

#----------------------------------------------------------------------
#  wingBasicDataEdit
#  Displays a window to edit the basic wing data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingWashinDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wbde

    global Lcl_alphaMax
    global Lcl_washinMode
    global Lcl_alphaCenter

    SetLclVars_wWASHIN

    toplevel .wbde
    focus .wbde

    wm protocol .wbde WM_DELETE_WINDOW { CancelButtonPress_wWASHIN }

    wm title .wbde [::msgcat::mc "Section 1B: Wing washin parameters"]

    #-------------
    # Frames and grids
    ttk::frame      .wbde.data
    ttk::labelframe .wbde.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wbde.btn
    #
    grid .wbde.data         -row 0 -column 0 -sticky e
    grid .wbde.help         -row 1 -column 0 -sticky e
    grid .wbde.btn          -row 2 -column 0 -sticky e

    #-------------
    # Data fields setup

    ttk::label .wbde.data.spacer00 -text "" -width 10
    grid .wbde.data.spacer00   -row 0 -column 2 -sticky e -padx 10 -pady 3

    # Wingtip washin
    ttk::label .wbde.data.wtw -text [::msgcat::mc "Wingtip washin"] -width 20
    grid .wbde.data.wtw   -row 0 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry .wbde.data.e_wtw -width 30 -textvariable Lcl_alphaMax
    SetHelpBind .wbde.data.e_wtw [::msgcat::mc "wingtip washin angle (deg)"] HelpText_wWASHIN
    grid .wbde.data.e_wtw -row 0 -column 1 -sticky w -padx 10 -pady 3

    # Washin mode
    ttk::label .wbde.data.wam -text [::msgcat::mc "Parameter"] -width 20
    grid .wbde.data.wam    -row 1 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry .wbde.data.e_wam -width 30 -textvariable Lcl_washinMode
    SetHelpBind .wbde.data.e_wam  [::msgcat::mc "0 means washin will be set manually in the matrix of geometry\n1 means washin will be set automatically proportional to chord\n2 means automatic washin including angle set at center airfoil"] HelpText_wWASHIN
    grid .wbde.data.e_wam  -row 1 -column 1 -sticky w -padx 10 -pady 3

    # Center washin
    ttk::label .wbde.data.wce -text [::msgcat::mc "Center washin"] -width 20
    grid .wbde.data.wce   -row 2 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry .wbde.data.e_wce -width 30 -textvariable Lcl_alphaCenter
    SetHelpBind .wbde.data.e_wce [::msgcat::mc "center airfoil washin angle (deg)\nusually set to 0.0"] HelpText_wWASHIN
    grid .wbde.data.e_wce -row 2 -column 1 -sticky w -padx 10 -pady 3

   
    #-------------
    # explanations
    label .wbde.help.e_help -width 100 -height 3 -background LightYellow -textvariable HelpText_wWASHIN
    grid  .wbde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wbde.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wWASHIN
    button .wbde.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wWASHIN
    button .wbde.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wWASHIN
    button .wbde.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wWASHIN

    grid .wbde.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wbde.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wbde.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wbde.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wWASHIN
}

#----------------------------------------------------------------------
#  SetLclVars_wWASHIN
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wWASHIN {} {

    source "globalWingVars.tcl"
    global Lcl_alphaMax
    global Lcl_washinMode
    global Lcl_alphaCenter

    set Lcl_alphaMax       $alphaMax
    set Lcl_washinMode     $washinMode
    set Lcl_alphaCenter    $alphaCenter

}

#----------------------------------------------------------------------
#  ExportLclVars_wWASHIN
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wWASHIN {} {
    source "globalWingVars.tcl"
    global Lcl_alphaMax
    global Lcl_washinMode
    global Lcl_alphaCenter

    set alphaMax       $Lcl_alphaMax
    set washinMode     $Lcl_washinMode
    set alphaCenter    $Lcl_alphaCenter
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wWASHIN
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wWASHIN {} {
    global g_WingDataChanged
    global Lcl_wWASHIN_DataChanged

    if { $Lcl_wWASHIN_DataChanged == 1 } {
        ExportLclVars_wWASHIN

        set g_WingDataChanged       1
        set Lcl_wWASHIN_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wWASHIN
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wWASHIN {} {
    global .wbde
    global g_WingDataChanged
    global Lcl_wWASHIN_DataChanged

    if { $Lcl_wWASHIN_DataChanged == 1 } {
        ExportLclVars_wWASHIN
        set g_WingDataChanged       1
        set Lcl_wWASHIN_DataChanged    0
    }

    UnsetLclVarTrace_wWASHIN
    destroy .wbde
}

#----------------------------------------------------------------------
#  CancelButtonPress_wWASHIN
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wWASHIN {} {
    global .wbde
    global g_WingDataChanged
    global Lcl_wWASHIN_DataChanged

    if { $Lcl_wWASHIN_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wbde
            return 0
        }
    }

    set Lcl_wWASHIN_DataChanged 0
    UnsetLclVarTrace_wWASHIN
    destroy .wbde

}

#----------------------------------------------------------------------
#  HelpButtonPress_wWASHIN
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wWASHIN {} {
    source "userHelp.tcl"

    displayHelpfile "wing-washin-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wWASHIN
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wWASHIN {} {

    global AllGlobalVars_wWASHIN

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wWASHIN {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wWASHIN }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wWASHIN
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wWASHIN {} {

    global AllGlobalVars_wWASHIN

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wWASHIN {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wWASHIN }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wWASHIN
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wWASHIN { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wWASHIN_DataChanged

    set Lcl_wWASHIN_DataChanged 1
}
