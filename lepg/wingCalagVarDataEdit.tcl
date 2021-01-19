#---------------------------------------------------------------------
#
#  Window to edit calage variation (section 28)
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
global  Lcl_wCALAGVAR_DataChanged
set     Lcl_wCALAGVAR_DataChanged    0

global  AllGlobalVars_wCALAGVAR
set     AllGlobalVars_wCALAGVAR { k_section28 numCalagVar numRisersC calagVarA calagVarB \
                                  calagVarA calagVarB calagVarC calagVarD calagVarE calagVarF \
                                  speedVarA speedVarB speedVarC speedVarD \
                                }

#----------------------------------------------------------------------
#  wingCalagVarDataEdit
#  Displays a window to edit the special wingtip data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingCalagVarDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global k_section28
    global numCalagVar 
    global numRisersC
    set numCalagVar 4
    global .wCALAGVAR

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wCALAGVAR
    foreach {e} $AllGlobalVars_wCALAGVAR {
        global Lcl_$e
    }

    SetLclVars_wCALAGVAR

    toplevel .wCALAGVAR
    focus .wCALAGVAR

    wm protocol .wCALAGVAR WM_DELETE_WINDOW { CancelButtonPress_wCALAGVAR }

    wm title .wCALAGVAR [::msgcat::mc "Section 28: Parameters for calage variation"]

    #-------------
    # Frames and grids
    ttk::frame      .wCALAGVAR.dataTop
    ttk::frame      .wCALAGVAR.dataBot
    ttk::labelframe .wCALAGVAR.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wCALAGVAR.btn
    #
    grid .wCALAGVAR.dataTop         -row 0 -column 0 -sticky w
    grid .wCALAGVAR.dataBot         -row 1 -column 0 -sticky w
    grid .wCALAGVAR.help            -row 2 -column 0 -sticky e
    grid .wCALAGVAR.btn             -row 3 -column 0 -sticky e

    addEdit_wCALAGVAR

    #-------------
    # explanations
    label .wCALAGVAR.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wCALAGVAR
    grid  .wCALAGVAR.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wCALAGVAR.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wCALAGVAR
    button .wCALAGVAR.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wCALAGVAR
    button .wCALAGVAR.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wCALAGVAR
    button .wCALAGVAR.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wCALAGVAR

    grid .wCALAGVAR.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wCALAGVAR.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wCALAGVAR.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wCALAGVAR.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wCALAGVAR
}

#----------------------------------------------------------------------
#  SetLclVars_wCALAGVAR
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wCALAGVAR {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wCALAGVAR
    foreach {e} $AllGlobalVars_wCALAGVAR {
        global Lcl_$e
    }
    set Lcl_k_section28   $k_section28
    set Lcl_numCalagVar   $numCalagVar
    set Lcl_numRisersC    $numRisersC


    for {set i 1} {$i <= 1} {incr i} {
        set Lcl_calagVarA($i)   $calagVarA($i)
        set Lcl_calagVarB($i)   $calagVarB($i)
        set Lcl_calagVarC($i)   $calagVarC($i)
        set Lcl_calagVarD($i)   $calagVarD($i)
        set Lcl_calagVarE($i)   $calagVarE($i)
        set Lcl_calagVarF($i)   $calagVarF($i)
        set Lcl_speedVarA($i)   $speedVarA($i)
        set Lcl_speedVarB($i)   $speedVarB($i)
        set Lcl_speedVarC($i)   $speedVarC($i)
        set Lcl_speedVarD($i)   $speedVarD($i)
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wCALAGVAR
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wCALAGVAR {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wCALAGVAR
    foreach {e} $AllGlobalVars_wCALAGVAR {
        global Lcl_$e
    }

    set k_section28    $Lcl_k_section28
    set numCalagVar    $Lcl_numCalagVar
    set numRisersC     $Lcl_numRisersC

    for {set i 1} {$i <= 1} {incr i} {
        set calagVarA($i)   $Lcl_calagVarA($i)
        set calagVarB($i)   $Lcl_calagVarB($i)
        set calagVarC($i)   $Lcl_calagVarC($i)
        set calagVarD($i)   $Lcl_calagVarD($i)        
        set calagVarE($i)   $Lcl_calagVarE($i)
        set calagVarF($i)   $Lcl_calagVarF($i)        
        set speedVarA($i)   $Lcl_speedVarA($i)
        set speedVarB($i)   $Lcl_speedVarB($i)        
        set speedVarC($i)   $Lcl_speedVarC($i)
        set speedVarD($i)   $Lcl_speedVarD($i)
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wCALAGVAR
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wCALAGVAR {} {
    global g_WingDataChanged
    global Lcl_wCALAGVAR_DataChanged

    if { $Lcl_wCALAGVAR_DataChanged == 1 } {
        ExportLclVars_wCALAGVAR

        set g_WingDataChanged       1
        set Lcl_wCALAGVAR_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wCALAGVAR
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wCALAGVAR {} {
    global .wCALAGVAR
    global g_WingDataChanged
    global Lcl_wCALAGVAR_DataChanged

    if { $Lcl_wCALAGVAR_DataChanged == 1 } {
        ExportLclVars_wCALAGVAR
        set g_WingDataChanged       1
        set Lcl_wCALAGVAR_DataChanged    0
    }

    UnsetLclVarTrace_wCALAGVAR
    destroy .wCALAGVAR
}

#----------------------------------------------------------------------
#  CancelButtonPress_wCALAGVAR
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wCALAGVAR {} {
    global .wCALAGVAR
    global g_WingDataChanged
    global Lcl_wCALAGVAR_DataChanged

    if { $Lcl_wCALAGVAR_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wCALAGVAR
            return 0
        }
    }

    set Lcl_wCALAGVAR_DataChanged 0
    UnsetLclVarTrace_wCALAGVAR
    destroy .wCALAGVAR

}

#----------------------------------------------------------------------
#  HelpButtonPress_wCALAGVAR
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wCALAGVAR {} {
    source "userHelp.tcl"

    displayHelpfile "set-calage-variation-options-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wCALAGVAR
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wCALAGVAR {} {

    global AllGlobalVars_wCALAGVAR

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wCALAGVAR {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wCALAGVAR }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wCALAGVAR
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wCALAGVAR {} {

    global AllGlobalVars_wCALAGVAR

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wCALAGVAR {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wCALAGVAR }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wCALAGVAR
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wCALAGVAR { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wCALAGVAR_DataChanged

    set Lcl_wCALAGVAR_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wCALAGVAR
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wCALAGVAR {} {
    global .wCALAGVAR

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wCALAGVAR
    foreach {e} $AllGlobalVars_wCALAGVAR {
        global Lcl_$e
    }

    # create GUI


    #-------------
    # Config of top data section
    label       .wCALAGVAR.dataTop.spacer00 -width 10 -text ""
    grid        .wCALAGVAR.dataTop.spacer00 -row 0 -column 0 -sticky e

    label       .wCALAGVAR.dataTop.p1 -width 20 -text [::msgcat::mc "Config type"]
    grid        .wCALAGVAR.dataTop.p1 -row 1 -column 0 -sticky e
    ttk::entry  .wCALAGVAR.dataTop.e_p1 -width 10 -textvariable Lcl_k_section28
    SetHelpBind .wCALAGVAR.dataTop.e_p1 "Configuration, type 0 and 1 available"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_p1 -row 1 -column 1 -sticky e -pady 1

    label       .wCALAGVAR.dataTop.p2 -width 20 -text [::msgcat::mc "Num risers"]
    grid        .wCALAGVAR.dataTop.p2 -row 2 -column 0 -sticky e
    ttk::entry  .wCALAGVAR.dataTop.e_p2 -width 10 -textvariable Lcl_numRisersC
    SetHelpBind .wCALAGVAR.dataTop.e_p2 "Number of riser used for calage"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_p2 -row 2 -column 1 -sticky e -pady 1

    #-------------
    # header for anchor points
    label       .wCALAGVAR.dataTop.spacer01 -width 10 -text ""
    grid        .wCALAGVAR.dataTop.spacer01 -row 3 -column 0 -sticky e
    label       .wCALAGVAR.dataTop.n1 -width 10 -text "A"
    grid        .wCALAGVAR.dataTop.n1 -row 4 -column 1 -sticky e
    label       .wCALAGVAR.dataTop.n2 -width 10 -text "B"
    grid        .wCALAGVAR.dataTop.n2 -row 4 -column 2 -sticky e
    label       .wCALAGVAR.dataTop.n3 -width 10 -text "C"
    grid        .wCALAGVAR.dataTop.n3 -row 4 -column 3 -sticky e
    label       .wCALAGVAR.dataTop.n4 -width 10 -text "D"
    grid        .wCALAGVAR.dataTop.n4 -row 4 -column 4 -sticky e
    label       .wCALAGVAR.dataTop.n5 -width 10 -text "E"
    grid        .wCALAGVAR.dataTop.n5 -row 4 -column 5 -sticky e
    label       .wCALAGVAR.dataTop.n6 -width 10 -text "F"
    grid        .wCALAGVAR.dataTop.n6 -row 4 -column 6 -sticky e
    label       .wCALAGVAR.dataTop.n60 -width 20 -text "Position %"
    grid        .wCALAGVAR.dataTop.n60 -row 5 -column 0 -sticky e

    #-------------
    # entrys for anchor points
    ttk::entry  .wCALAGVAR.dataTop.e_n1 -width 10 -textvariable Lcl_calagVarA(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n1 "A \% of chord"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n1 -row 5 -column 1 -sticky e -pady 1

    ttk::entry  .wCALAGVAR.dataTop.e_n2 -width 10 -textvariable Lcl_calagVarB(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n2 "B \% of chord"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n2 -row 5 -column 2 -sticky e -pady 1

    ttk::entry  .wCALAGVAR.dataTop.e_n3 -width 10 -textvariable Lcl_calagVarC(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n3 "C \% of chord"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n3 -row 5 -column 3 -sticky e -pady 1

    ttk::entry  .wCALAGVAR.dataTop.e_n4 -width 10 -textvariable Lcl_calagVarD(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n4 "D \% of chord"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n4 -row 5 -column 4 -sticky e -pady 1

    ttk::entry  .wCALAGVAR.dataTop.e_n5 -width 10 -textvariable Lcl_calagVarE(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n5 "E \% of chord"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n5 -row 5 -column 5 -sticky e -pady 1

    ttk::entry  .wCALAGVAR.dataTop.e_n6 -width 10 -textvariable Lcl_calagVarF(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n6 "F $% of chord"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n6 -row 5 -column 6 -sticky e -pady 1

    #-------------
    # header for speed and trim
    label       .wCALAGVAR.dataTop.spacer02 -width 10 -text ""
    grid        .wCALAGVAR.dataTop.spacer02 -row 6 -column 0 -sticky e
    label       .wCALAGVAR.dataTop.n7 -width 10 -text "speed deg"
    grid        .wCALAGVAR.dataTop.n7 -row 7 -column 1 -sticky e
    label       .wCALAGVAR.dataTop.n8 -width 10 -text "steps"
    grid        .wCALAGVAR.dataTop.n8 -row 7 -column 2 -sticky e
    label       .wCALAGVAR.dataTop.n9 -width 10 -text "trim deg"
    grid        .wCALAGVAR.dataTop.n9 -row 7 -column 3 -sticky e
    label       .wCALAGVAR.dataTop.n10 -width 10 -text "steps"
    grid        .wCALAGVAR.dataTop.n10 -row 7 -column 4 -sticky e
    label       .wCALAGVAR.dataTop.n11 -width 20 -text "Speed-Trim"
    grid        .wCALAGVAR.dataTop.n11 -row 8 -column 0 -sticky e
    label       .wCALAGVAR.dataTop.spacer03 -width 10 -text ""
    grid        .wCALAGVAR.dataTop.spacer03 -row 9 -column 0 -sticky e

    ttk::entry  .wCALAGVAR.dataTop.e_n7 -width 10 -textvariable Lcl_speedVarA(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n7 "Negative max angle for speed system (deg)"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n7 -row 8 -column 1 -sticky e -pady 1

    ttk::entry  .wCALAGVAR.dataTop.e_n8 -width 10 -textvariable Lcl_speedVarB(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n8 "Calculation steps for speed"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n8 -row 8 -column 2 -sticky e -pady 1

    ttk::entry  .wCALAGVAR.dataTop.e_n9 -width 10 -textvariable Lcl_speedVarC(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n9 "Positive max angle for trim system (deg)"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n9 -row 8 -column 3 -sticky e -pady 1

    ttk::entry  .wCALAGVAR.dataTop.e_n10 -width 10 -textvariable Lcl_speedVarD(1)
    SetHelpBind .wCALAGVAR.dataTop.e_n10 "Calculation steps for trim"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_n10 -row 8 -column 4 -sticky e -pady 1



#    UpdateItemLineButtons_wCALAGVAR

}

#----------------------------------------------------------------------
#  DecItemLines_wCALAGVAR
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wCALAGVAR {} {
    global .wCALAGVAR
    global Lcl_numCalagVar

    destroy .wCALAGVAR.dataTop.n$Lcl_numCalagVar
    destroy .wCALAGVAR.dataTop.e_p1$Lcl_numCalagVar
    destroy .wCALAGVAR.dataTop.e_p2$Lcl_numCalagVar
    destroy .wCALAGVAR.dataTop.e_p3$Lcl_numCalagVar
    destroy .wCALAGVAR.dataTop.e_p4$Lcl_numCalagVar
    destroy .wCALAGVAR.dataTop.e_p5$Lcl_numCalagVar
    destroy .wCALAGVAR.dataTop.e_p6$Lcl_numCalagVar

    incr Lcl_numCalagVar -1

    UpdateItemLineButtons_wCALAGVAR
}

#----------------------------------------------------------------------
#  IncItemLines_wCALAGVAR
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wCALAGVAR {} {
    global .wCALAGVAR
    global Lcl_numCalagVar

    incr Lcl_numCalagVar

    UpdateItemLineButtons_wCALAGVAR

    # init additional variables
    CreateInitialItemLineVars_wCALAGVAR

    AddItemLine_wCALAGVAR $Lcl_numCalagVar
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wCALAGVAR
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wCALAGVAR {} {
    global .wCALAGVAR
    global Lcl_calagVarA
    global Lcl_calagVarB

    # init additional variables
    foreach i {1} {
        set Lcl_calagVarA($i) 0
        set Lcl_calagVarB($i) 0

    }
}

#----------------------------------------------------------------------
#  UpdateItemLineButtons_wCALAGVAR
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wCALAGVAR { } {
    global .wCALAGVAR
    global Lcl_numCalagVar

    if {$Lcl_numCalagVar > 1} {
        .wCALAGVAR.dataTop.b_decItems configure -state normal
    } else {
        .wCALAGVAR.dataTop.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wCALAGVAR (Top part)
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wCALAGVAR { lineNum } {
    global .wCALAGVAR
    global Lcl_calagVarA
    global Lcl_calagVarB

#    label       .wCALAGVAR.dataTop.n$lineNum -width 15 -text "$lineNum"
#    grid        .wCALAGVAR.dataTop.n$lineNum -row [expr (6-1 + $lineNum)] -column 0 -sticky e

    ttk::entry  .wCALAGVAR.dataTop.e_p1$lineNum -width 15 -textvariable Lcl_calagVarA($lineNum)
    SetHelpBind .wCALAGVAR.dataTop.e_p1$lineNum "Angle name"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_p1$lineNum -row [expr (2-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wCALAGVAR.dataTop.e_p2$lineNum -width 10 -textvariable Lcl_calagVarB($lineNum)
    SetHelpBind .wCALAGVAR.dataTop.e_p2$lineNum "Angle degrees clockwise"   HelpText_wCALAGVAR
    grid        .wCALAGVAR.dataTop.e_p2$lineNum -row [expr (2-1 + $lineNum)] -column 2 -sticky e -pady 1

    label       .wCALAGVAR.dataTop.lbl1$lineNum -width 15 -text [::msgcat::mc "deg"]
    grid        .wCALAGVAR.dataTop.lbl1$lineNum -row [expr (2-1 + $lineNum)] -column 3 -sticky w

}


