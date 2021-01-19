#---------------------------------------------------------------------
#
#  Window to edit the cells number
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

global  Lcl_wCELLSN_DataChanged
set     Lcl_wCELLSN_DataChanged    0

global  AllGlobalVars_wCELLSN
set     AllGlobalVars_wCELLSN { numCells numRibsTot numRibsHalf ribConfig }

set setUPType 1
set SetUpdateType 1

#----------------------------------------------------------------------
#  wingBasicDataEdit
#  Displays a window to edit the basic wing data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingCellsNumberDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wbde

    global Lcl_numCells
    global Lcl_numRibsTot
    global Lcl_numRibsHalf
    global Lcl_ribConfig

    SetLclVars_wCELLSN

#    source "wingSomeCalculus.tcl"
#    wingSomeCalculus $Lcl_numRibsHalf $Lcl_ribConfig

    toplevel .wbde
    focus .wbde

    wm protocol .wbde WM_DELETE_WINDOW { CancelButtonPress_wCELLSN }

    wm title .wbde [::msgcat::mc "01D. Set number of cells"]

    #-------------
    # Frames and grids
    ttk::labelframe .wbde.warn -text [::msgcat::mc "Warning!"]
    ttk::frame      .wbde.data
    ttk::labelframe .wbde.acti -text [::msgcat::mc "Actions"]
    ttk::labelframe .wbde.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wbde.btn
    #
    grid .wbde.warn         -row 0 -column 0 -sticky e
    grid .wbde.data         -row 1 -column 0 -sticky e
    grid .wbde.acti        -row 2 -column 0 -sticky e
    grid .wbde.help         -row 3 -column 0 -sticky e
    grid .wbde.btn          -row 4 -column 0 -sticky e

    #-------------
    # Data fields setup

    ttk::label .wbde.data.spacer00 -text "" -width 10
    grid .wbde.data.spacer00   -row 0 -column 2 -sticky e -padx 10 -pady 3

    # Number of cells
    ttk::label .wbde.data.wtw -text [::msgcat::mc "Cells number"] -width 20
    grid .wbde.data.wtw   -row 0 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry .wbde.data.e_wtw -width 30 -textvariable Lcl_numCells
    SetHelpBind .wbde.data.e_wtw [::msgcat::mc "Set total cells number"] HelpText_wCELLSN
    grid .wbde.data.e_wtw -row 0 -column 1 -sticky w -padx 10 -pady 3

    # Number of ribs
    ttk::label .wbde.data.wam -text [::msgcat::mc "Ribs number"] -width 20
    grid .wbde.data.wam    -row 1 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry .wbde.data.e_wam -width 30 -textvariable Lcl_numRibsTot
    SetHelpBind .wbde.data.e_wam  [::msgcat::mc "Total ribs number = total cells number + 1"] HelpText_wCELLSN
    grid .wbde.data.e_wam  -row 1 -column 1 -sticky w -padx 10 -pady 3

    # Center washin
    ttk::label .wbde.data.wce -text [::msgcat::mc "Ribs half"] -width 20
    grid .wbde.data.wce   -row 2 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry .wbde.data.e_wce -width 30 -textvariable Lcl_numRibsHalf
    SetHelpBind .wbde.data.e_wce [::msgcat::mc "Ribs per one wing side\nIf total number of ribs is even, then RibsHalf = RibsTot / 2\nIf total number of ribs is odd, then RibsHalf = (RibsTot + 1) / 2"] HelpText_wCELLSN
    grid .wbde.data.e_wce -row 2 -column 1 -sticky w -padx 10 -pady 3



    #-------------
    # Actions for automatic update after setting cell number
#    ttk::radiobutton .wdbe.acti.ra -variable setUPType -value 1 -text [::msgcat::mc "Update all sections affected by the number of ribs manually"]
#    ttk::radiobutton .wdbe.acti.rb -variable setUPType -value 2 -text [::msgcat::mc "Try to update sections automatically, but review after"]

#    bind .wdbe.acti.ra <ButtonPress> { SetUpdateType 1 }
#    bind .wdbe.acti.rb <ButtonPress> { SetUpdateType 2 }
#    grid .wdbe.acti.ra -row 0 -column 0 -columnspan 2 -sticky w
#    grid .wdbe.acti.rb -row 1 -column 0 -columnspan 2 -sticky w


    #-------------
    # warning
    label .wbde.warn.e_warn -width 100 -height 3 -background Yellow -text "Changing the number of cells affects most sections!\nYou have the option to update all sections manually (recommended),\nor allow the program to attempt an automatic adaptation."
    grid  .wbde.warn.e_warn -row 0 -column 0 -sticky nesw -padx 10 -pady 10
 
    #-------------
    # explanations
    label .wbde.help.e_help -width 100 -height 3 -background LightYellow -textvariable HelpText_wCELLSN
    grid  .wbde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wbde.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wCELLSN
    button .wbde.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wCELLSN
    button .wbde.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wCELLSN
    button .wbde.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wCELLSN

    grid .wbde.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wbde.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wbde.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wbde.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wCELLSN
}

#----------------------------------------------------------------------
#  SetLclVars_wCELLSN
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wCELLSN {} {

    source "globalWingVars.tcl"
    global Lcl_numCells
    global Lcl_numRibsTot
    global Lcl_numRibsHalf
    global Lcl_ribConfig

    set Lcl_numCells       $numCells
    set Lcl_numRibsTot     $numRibsTot
    set Lcl_numRibsHalf    $numRibsHalf

#    set i 1
#    while { $i <= $numRibsHalf } {
#    foreach k {1 2 3 4 6 7 9 10 51} {
#    set Lcl_ribConfig($i,$k)  $ribConfig($i,$k)
#    }
#    }

}

#----------------------------------------------------------------------
#  ExportLclVars_wCELLSN
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wCELLSN {} {
    source "globalWingVars.tcl"
    global Lcl_numCells
    global Lcl_numRibsTot
    global Lcl_numRibsHalf
    global Lcl_ribConfig

    set numCells       $Lcl_numCells
    set numRibsTot     $Lcl_numRibsTot
    set numRibsHalf    $Lcl_numRibsHalf

#    set i 1
#    while { $i <= $numRibsHalf } {
#    foreach k {1 2 3 4 6 7 9 10 51} {
#    set ribConfig($i,$k)  $_Lcl_ribConfig($i,$k)
#    }
#    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wCELLSN
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wCELLSN {} {
    global g_WingDataChanged
    global Lcl_wCELLSN_DataChanged

    if { $Lcl_wCELLSN_DataChanged == 1 } {
        ExportLclVars_wCELLSN

        set g_WingDataChanged       1
        set Lcl_wCELLSN_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wCELLSN
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wCELLSN {} {
    global .wbde
    global g_WingDataChanged
    global Lcl_wCELLSN_DataChanged

    if { $Lcl_wCELLSN_DataChanged == 1 } {
        ExportLclVars_wCELLSN
        set g_WingDataChanged       1
        set Lcl_wCELLSN_DataChanged    0
    }

    UnsetLclVarTrace_wCELLSN
    destroy .wbde
}

#----------------------------------------------------------------------
#  CancelButtonPress_wCELLSN
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wCELLSN {} {
    global .wbde
    global g_WingDataChanged
    global Lcl_wCELLSN_DataChanged

    if { $Lcl_wCELLSN_DataChanged == 1} {
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

    set Lcl_wCELLSN_DataChanged 0
    UnsetLclVarTrace_wCELLSN
    destroy .wbde

}

#----------------------------------------------------------------------
#  HelpButtonPress_wCELLSN
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wCELLSN {} {
    source "userHelp.tcl"

    displayHelpfile "wing-washin-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wCELLSN
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wCELLSN {} {

    global AllGlobalVars_wCELLSN

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wCELLSN {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wCELLSN }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wCELLSN
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wCELLSN {} {

    global AllGlobalVars_wCELLSN

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wCELLSN {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wCELLSN }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wCELLSN
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wCELLSN { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wCELLSN_DataChanged

    set Lcl_wCELLSN_DataChanged 1
}
