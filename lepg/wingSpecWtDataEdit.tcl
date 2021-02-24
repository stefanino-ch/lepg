#---------------------------------------------------------------------
#
#  Window to edit special wingtip (section 27)
#
#  Stefan Feuz
#  Pere Casellas
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wSPECWT_DataChanged
set     Lcl_wSPECWT_DataChanged    0

global  AllGlobalVars_wSPECWT
set     AllGlobalVars_wSPECWT { k_section27 numSpecWt specWtA specWtB }

#----------------------------------------------------------------------
#  wingSpecWtDataEdit
#  Displays a window to edit the special wingtip data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingSpecWtDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global k_section27
    global numSpecWt 
    set numSpecWt 2
    global .wSPECWT

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wSPECWT
    foreach {e} $AllGlobalVars_wSPECWT {
        global Lcl_$e
    }

    SetLclVars_wSPECWT

    toplevel .wSPECWT
    focus .wSPECWT

    wm protocol .wSPECWT WM_DELETE_WINDOW { CancelButtonPress_wSPECWT }

    wm title .wSPECWT [::msgcat::mc "Section 27: Special wingtip options"]

    #-------------
    # Frames and grids
    ttk::frame      .wSPECWT.dataTop
    ttk::frame      .wSPECWT.dataBot
    ttk::labelframe .wSPECWT.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wSPECWT.btn
    #
    grid .wSPECWT.dataTop         -row 0 -column 0 -sticky w
    grid .wSPECWT.dataBot         -row 1 -column 0 -sticky w
    grid .wSPECWT.help            -row 2 -column 0 -sticky e
    grid .wSPECWT.btn             -row 3 -column 0 -sticky e

    addEdit_wSPECWT

    #-------------
    # explanations
    label .wSPECWT.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wSPECWT
    grid  .wSPECWT.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wSPECWT.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wSPECWT
    button .wSPECWT.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wSPECWT
    button .wSPECWT.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wSPECWT
    button .wSPECWT.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wSPECWT

    grid .wSPECWT.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wSPECWT.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wSPECWT.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wSPECWT.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wSPECWT



    
}

#----------------------------------------------------------------------
#  SetLclVars_wSPECWT
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wSPECWT {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wSPECWT
    foreach {e} $AllGlobalVars_wSPECWT {
        global Lcl_$e
    }
    set Lcl_k_section27   $k_section27
    set Lcl_numSpecWt     $numSpecWt

    if {$k_section27 == 0} {
    foreach i {1 2} {
    set specWtA($i) 0
    set specWtB($i) 0
    }
    }

    for {set i 1} {$i <= 2} {incr i} {
        set Lcl_specWtA($i)   $specWtA($i)
        set Lcl_specWtB($i)   $specWtB($i)
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wSPECWT
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wSPECWT {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wSPECWT
    foreach {e} $AllGlobalVars_wSPECWT {
        global Lcl_$e
    }

    set k_section27  $Lcl_k_section27
    set numSpecWt    $Lcl_numSpecWt

    for {set i 1} {$i <= $numSpecWt} {incr i} {
        set specWtA($i)   $Lcl_specWtA($i)
        set specWtB($i)   $Lcl_specWtB($i)
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wSPECWT
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wSPECWT {} {
    global g_WingDataChanged
    global Lcl_wSPECWT_DataChanged

    if { $Lcl_wSPECWT_DataChanged == 1 } {
        ExportLclVars_wSPECWT

        set g_WingDataChanged       1
        set Lcl_wSPECWT_DataChanged    0

    destroy .wSPECWT
    wingSpecWtDataEdit
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wSPECWT
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wSPECWT {} {
    global .wSPECWT
    global g_WingDataChanged
    global Lcl_wSPECWT_DataChanged

    if { $Lcl_wSPECWT_DataChanged == 1 } {
        ExportLclVars_wSPECWT
        set g_WingDataChanged       1
        set Lcl_wSPECWT_DataChanged    0
    }

    UnsetLclVarTrace_wSPECWT
    destroy .wSPECWT
}

#----------------------------------------------------------------------
#  CancelButtonPress_wSPECWT
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wSPECWT {} {
    global .wSPECWT
    global g_WingDataChanged
    global Lcl_wSPECWT_DataChanged

    if { $Lcl_wSPECWT_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wSPECWT
            return 0
        }
    }

    set Lcl_wSPECWT_DataChanged 0
    UnsetLclVarTrace_wSPECWT
    destroy .wSPECWT

}

#----------------------------------------------------------------------
#  HelpButtonPress_wSPECWT
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wSPECWT {} {
    source "userHelp.tcl"

    displayHelpfile "set-special-wingtip-options-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wSPECWT
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wSPECWT {} {

    global AllGlobalVars_wSPECWT

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSPECWT {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wSPECWT }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wSPECWT
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wSPECWT {} {

    global AllGlobalVars_wSPECWT

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSPECWT {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wSPECWT }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wSPECWT
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wSPECWT { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wSPECWT_DataChanged

    set Lcl_wSPECWT_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wSPECWT
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wSPECWT {} {
    global .wSPECWT

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wSPECWT
    foreach {e} $AllGlobalVars_wSPECWT {
        global Lcl_$e
    }

    # create GUI


    #-------------
    # Config of top data section
    label       .wSPECWT.dataTop.spacer00 -width 10 -text ""
    grid        .wSPECWT.dataTop.spacer00 -row 0 -column 0 -sticky e

    label       .wSPECWT.dataTop.p -width 20 -text [::msgcat::mc "Config type"]
    grid        .wSPECWT.dataTop.p -row 1 -column 0 -sticky e
    ttk::entry  .wSPECWT.dataTop.e_p -width 15 -textvariable Lcl_k_section27
    SetHelpBind .wSPECWT.dataTop.e_p "Configuration, type 0 and 1 available"   HelpText_wSPECWT
    grid        .wSPECWT.dataTop.e_p -row 1 -column 1 -sticky e -pady 1

    button      .wSPECWT.dataTop.ih  -width 10 -text [::msgcat::mc "Graphic"] -command PutHelpImage
    grid        .wSPECWT.dataTop.ih  -row 1 -column 3 -sticky e -pady 1

    label       .wSPECWT.dataTop.p11 -width 20 -text [::msgcat::mc "Angle LE"]
    grid        .wSPECWT.dataTop.p11 -row 2 -column 0 -sticky e

    label       .wSPECWT.dataTop.p12 -width 20 -text [::msgcat::mc "Angle TE"]
    grid        .wSPECWT.dataTop.p12 -row 3 -column 0 -sticky e

    #-------------
    # header for the item lines first blocs

#    label       .wSPECWT.dataTop.spacer01 -width 10 -text ""
#    grid        .wSPECWT.dataTop.spacer01 -row 0 -column 0 -sticky e

#    label       .wSPECWT.dataTop.n -width 10 -text "Angle"
#    grid        .wSPECWT.dataTop.n -row 2 -column 0 -sticky e

#    label       .wSPECWT.dataTop.p0 -width 20 -text [::msgcat::mc "Value"]
#    grid        .wSPECWT.dataTop.p0 -row 2 -column 1 -sticky e

    #-------------
    # Add line items only in case 1
    if { $Lcl_k_section27 == 1 } {
    for { set i 1 } { $i <= 2 } { incr i } {
        AddItemLine_wSPECWT $i
    }
    }

#    UpdateItemLineButtons_wSPECWT

}

#----------------------------------------------------------------------
# Call help image
#----------------------------------------------------------------------
proc PutHelpImage {} {

    source "openHelpImage.tcl"
    set imageName "img/S27.png"
    OpenHelpImage $imageName
}
#----------------------------------------------------------------------


#----------------------------------------------------------------------
#  DecItemLines_wSPECWT
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wSPECWT {} {
    global .wSPECWT
    global Lcl_numSpecWt

    destroy .wSPECWT.dataTop.n$Lcl_numSpecWt
    destroy .wSPECWT.dataTop.e_p1$Lcl_numSpecWt
    destroy .wSPECWT.dataTop.e_p2$Lcl_numSpecWt
    destroy .wSPECWT.dataTop.e_p3$Lcl_numSpecWt
    destroy .wSPECWT.dataTop.e_p4$Lcl_numSpecWt
    destroy .wSPECWT.dataTop.e_p5$Lcl_numSpecWt
    destroy .wSPECWT.dataTop.e_p6$Lcl_numSpecWt

    incr Lcl_numSpecWt -1

    UpdateItemLineButtons_wSPECWT
}

#----------------------------------------------------------------------
#  IncItemLines_wSPECWT
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wSPECWT {} {
    global .wSPECWT
    global Lcl_numSpecWt

    incr Lcl_numSpecWt

    UpdateItemLineButtons_wSPECWT

    # init additional variables
    CreateInitialItemLineVars_wSPECWT

    AddItemLine_wSPECWT $Lcl_numSpecWt
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wSPECWT
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wSPECWT {} {
    global .wSPECWT
    global Lcl_specWtA
    global Lcl_specWtB

    # init additional variables
    foreach i {1 2} {
        set Lcl_specWtA($i) 0
        set Lcl_specWtB($i) 0
    }
}

#----------------------------------------------------------------------
#  UpdateItemLineButtons_wSPECWT
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wSPECWT { } {
    global .wSPECWT
    global Lcl_numSpecWt

    if {$Lcl_numSpecWt > 1} {
        .wSPECWT.dataTop.b_decItems configure -state normal
    } else {
        .wSPECWT.dataTop.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wSPECWT (Top part)
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wSPECWT { lineNum } {
    global .wSPECWT
    global Lcl_specWtA
    global Lcl_specWtB

#    label       .wSPECWT.dataTop.n$lineNum -width 15 -text "$lineNum"
#    grid        .wSPECWT.dataTop.n$lineNum -row [expr (6-1 + $lineNum)] -column 0 -sticky e

    ttk::entry  .wSPECWT.dataTop.e_p1$lineNum -width 15 -textvariable Lcl_specWtA($lineNum)
    SetHelpBind .wSPECWT.dataTop.e_p1$lineNum [::msgcat::mc "Angle name"]   HelpText_wSPECWT
    grid        .wSPECWT.dataTop.e_p1$lineNum -row [expr (2-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wSPECWT.dataTop.e_p2$lineNum -width 10 -textvariable Lcl_specWtB($lineNum)
    SetHelpBind .wSPECWT.dataTop.e_p2$lineNum [::msgcat::mc "Angle degrees clockwise"]   HelpText_wSPECWT
    grid        .wSPECWT.dataTop.e_p2$lineNum -row [expr (2-1 + $lineNum)] -column 2 -sticky e -pady 1

    label       .wSPECWT.dataTop.lbl1$lineNum -width 15 -text [::msgcat::mc "deg"]
    grid        .wSPECWT.dataTop.lbl1$lineNum -row [expr (2-1 + $lineNum)] -column 3 -sticky w

}


