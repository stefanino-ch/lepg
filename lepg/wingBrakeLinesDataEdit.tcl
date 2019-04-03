#---------------------------------------------------------------------
#
#  Window to edit the brake lines
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wBLDE_DataChanged
set     Lcl_wBLDE_DataChanged    0

global  AllGlobalVars_wBLDE
set     AllGlobalVars_wBLDE { brakeLength numBrakeLinePath brakeLinePath brakeDistr }

#----------------------------------------------------------------------
#  wingBrakeLinesDataEdit
#  Displays a window to edit the brake lines data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingBrakeLinesDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wBLDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wBLDE
    foreach {e} $AllGlobalVars_wBLDE {
        global Lcl_$e
    }

    SetLclVars_wBLDE

    toplevel .wBLDE
    focus .wBLDE

    wm protocol .wBLDE WM_DELETE_WINDOW { CancelButtonPress_wBLDE }

    wm title .wBLDE [::msgcat::mc "Brake lines configuration"]

    #-------------
    # Frames and grids
    ttk::frame      .wBLDE.dataTop
    ttk::frame      .wBLDE.dataBot
    ttk::labelframe .wBLDE.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wBLDE.btn
    #
    grid .wBLDE.dataTop         -row 0 -column 0 -sticky w
    grid .wBLDE.dataBot         -row 1 -column 0 -sticky w
    grid .wBLDE.help            -row 2 -column 0 -sticky e
    grid .wBLDE.btn             -row 3 -column 0 -sticky e

    addEdit_wBLDE

    #-------------
    # explanations
    label .wBLDE.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wBLDE
    grid  .wBLDE.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wBLDE.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wBLDE
    button .wBLDE.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wBLDE
    button .wBLDE.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wBLDE
    button .wBLDE.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wBLDE

    grid .wBLDE.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wBLDE.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wBLDE.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wBLDE.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wBLDE
}

#----------------------------------------------------------------------
#  SetLclVars_wBLDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wBLDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wBLDE
    foreach {e} $AllGlobalVars_wBLDE {
        global Lcl_$e
    }
    set Lcl_brakeLength         $brakeLength
    set Lcl_numBrakeLinePath    $numBrakeLinePath

    for {set i 1} {$i <= $numBrakeLinePath} {incr i} {
        foreach j {1 2 3 4 5 6 7 8 9 14 15} {
            set Lcl_brakeLinePath($i,$j)   $brakeLinePath($i,$j)
        }
    }

    # brake distribution
    for {set i 1} {$i <= 2} {incr i} {
        for {set j 1} {$j <= 5} {incr j} {
            set Lcl_brakeDistr($i,$j) $brakeDistr($i,$j)
        }
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wBLDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wBLDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wBLDE
    foreach {e} $AllGlobalVars_wBLDE {
        global Lcl_$e
    }

    set brakeLength         $Lcl_brakeLength
    set numBrakeLinePath    $Lcl_numBrakeLinePath

    # iterate across all line paths
    for { set j 1 } { $j <= $Lcl_numBrakeLinePath } { incr j } {

        # set num of branches and branching level numbers 0
        foreach k {1 2 3 4 5 6 7 8 9} {
            set brakeLinePath($j,$k) 0
        }

        # count number of valid branches and set parameters
        set numBranches 0
        foreach k {3 5 7 9} {
            if {$Lcl_brakeLinePath($j,$k) != 0} {
                incr numBranches
                # the level number itself
                set brakeLinePath($j,[expr ($k-1)]) $numBranches
                # the value
                set brakeLinePath($j,$k) $Lcl_brakeLinePath($j,$k)
            }
        }
        # first value on each line: number of branches
        set brakeLinePath($j,1)   $numBranches

        set brakeLinePath($j,14)  $Lcl_brakeLinePath($j,14)
        set brakeLinePath($j,15)  $Lcl_brakeLinePath($j,15)
    }

    # brake distribution
    for {set i 1} {$i <= 2} {incr i} {
        for {set j 1} {$j <= 5} {incr j} {
            set brakeDistr($i,$j) $Lcl_brakeDistr($i,$j)
        }
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wBLDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wBLDE {} {
    global g_WingDataChanged
    global Lcl_wBLDE_DataChanged

    if { $Lcl_wBLDE_DataChanged == 1 } {
        ExportLclVars_wBLDE

        set g_WingDataChanged       1
        set Lcl_wBLDE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wBLDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wBLDE {} {
    global .wBLDE
    global g_WingDataChanged
    global Lcl_wBLDE_DataChanged

    if { $Lcl_wBLDE_DataChanged == 1 } {
        ExportLclVars_wBLDE
        set g_WingDataChanged       1
        set Lcl_wBLDE_DataChanged    0
    }

    UnsetLclVarTrace_wBLDE
    destroy .wBLDE
}

#----------------------------------------------------------------------
#  CancelButtonPress_wBLDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wBLDE {} {
    global .wBLDE
    global g_WingDataChanged
    global Lcl_wBLDE_DataChanged

    if { $Lcl_wBLDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wBLDE
            return 0
        }
    }

    set Lcl_wBLDE_DataChanged 0
    UnsetLclVarTrace_wBLDE
    destroy .wBLDE

}

#----------------------------------------------------------------------
#  HelpButtonPress_wBLDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wBLDE {} {
    source "userHelp.tcl"

    displayHelpfile "brake-lines-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wBLDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wBLDE {} {

    global AllGlobalVars_wBLDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wBLDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wBLDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wBLDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wBLDE {} {

    global AllGlobalVars_wBLDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wBLDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wBLDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wBLDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wBLDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wBLDE_DataChanged

    set Lcl_wBLDE_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wBLDE
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wBLDE {} {
    global .wBLDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wBLDE
    foreach {e} $AllGlobalVars_wBLDE {
        global Lcl_$e
    }

    # create GUI
    label       .wBLDE.dataTop.spacer00 -width 5 -text ""
    grid        .wBLDE.dataTop.spacer00 -row 0 -column 0

    #-------------
    # Config of items
    button      .wBLDE.dataTop.b_decItems     -width 10 -text [::msgcat::mc "dec Paths"] -command DecItemLines_wBLDE -state disabled
    grid        .wBLDE.dataTop.b_decItems    -row 1 -column 1 -sticky e -padx 3 -pady 3

    button      .wBLDE.dataTop.b_incItems     -width 10 -text [::msgcat::mc "inc Paths"]  -command IncItemLines_wBLDE
    grid        .wBLDE.dataTop.b_incItems    -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wBLDE.dataTop.spacer20 -width 5 -text ""
    grid        .wBLDE.dataTop.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines
    label       .wBLDE.dataTop.n -width 10 -text "Num"
    grid        .wBLDE.dataTop.n -row 5 -column 1 -sticky e

    label       .wBLDE.dataTop.p1 -width 10 -text [::msgcat::mc "Lvl 1"]
    grid        .wBLDE.dataTop.p1 -row 5 -column 2 -sticky e

    label       .wBLDE.dataTop.p2 -width 10 -text [::msgcat::mc "Lvl 2"]
    grid        .wBLDE.dataTop.p2 -row 5 -column 3 -sticky e

    label       .wBLDE.dataTop.p3 -width 10 -text [::msgcat::mc "Lvl 3"]
    grid        .wBLDE.dataTop.p3 -row 5 -column 4 -sticky e

    label       .wBLDE.dataTop.p4 -width 10 -text "Lvl 4"
    grid        .wBLDE.dataTop.p4 -row 5 -column 5 -sticky e

    label       .wBLDE.dataTop.p5 -width 10 -text "Anchor line"
    grid        .wBLDE.dataTop.p5 -row 5 -column 6 -sticky e

    label       .wBLDE.dataTop.p6 -width 10 -text "Rib num"
    grid        .wBLDE.dataTop.p6 -row 5 -column 7 -sticky e

    label       .wBLDE.dataTop.spacer58 -width 5 -text ""
    grid        .wBLDE.dataTop.spacer58 -row 5 -column 8

    for { set i 1 } { $i <= $Lcl_numBrakeLinePath } { incr i } {
        AddItemLine_wBLDE $i
    }

    UpdateItemLineButtons_wBLDE

    #-------------
    # brake distribution, labels
    label       .wBLDE.dataBot.spacer00 -width 5 -text ""
    grid        .wBLDE.dataBot.spacer00 -row 0 -column 0 -sticky e

    label       .wBLDE.dataBot.t1 -width 15 -text "Distribution"
    grid        .wBLDE.dataBot.t1 -row 1 -column 1 -sticky e

    label       .wBLDE.dataBot.p1 -width 10 -text [::msgcat::mc "Point 1"]
    grid        .wBLDE.dataBot.p1 -row 2 -column 2 -sticky e

    label       .wBLDE.dataBot.p2 -width 10 -text [::msgcat::mc "Point 2"]
    grid        .wBLDE.dataBot.p2 -row 2 -column 3 -sticky e

    label       .wBLDE.dataBot.p3 -width 10 -text [::msgcat::mc "Point 3"]
    grid        .wBLDE.dataBot.p3 -row 2 -column 4 -sticky e

    label       .wBLDE.dataBot.p4 -width 10 -text "Point 4"
    grid        .wBLDE.dataBot.p4 -row 2 -column 5 -sticky e

    label       .wBLDE.dataBot.p5 -width 10 -text "Point 5"
    grid        .wBLDE.dataBot.p5 -row 2 -column 6 -sticky e

    label       .wBLDE.dataBot.l1 -width 10 -text "S \[%\]"
    grid        .wBLDE.dataBot.l1 -row 3 -column 1 -sticky e

    label       .wBLDE.dataBot.l2 -width 10 -text "delta L"
    grid        .wBLDE.dataBot.l2 -row 4 -column 1 -sticky e

    #-------------
    # brake distribution, data line 1
    for {set i 1} {$i <= 5 } {incr i} {
        ttk::entry  .wBLDE.dataBot.e_p1$i -width 10 -textvariable Lcl_brakeDistr(1,$i)
        SetHelpBind .wBLDE.dataBot.e_p1$i brakeLinedistr_S   HelpText_wBLDE
        grid        .wBLDE.dataBot.e_p1$i -row 3 -column [expr (1 + $i)] -sticky e -pady 1
    }

    #-------------
    # brake distribution, data line 2
    for {set i 1} {$i <= 5 } {incr i} {
        ttk::entry  .wBLDE.dataBot.e_p2$i -width 10 -textvariable Lcl_brakeDistr(2,$i)
        SetHelpBind .wBLDE.dataBot.e_p2$i brakeLinedistr_L   HelpText_wBLDE
        grid        .wBLDE.dataBot.e_p2$i -row 4 -column [expr (1 + $i)] -sticky e -pady 1
    }

}

#----------------------------------------------------------------------
#  DecItemLines_wBLDE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wBLDE {} {
    global .wBLDE
    global Lcl_numBrakeLinePath

    destroy .wBLDE.dataTop.n$Lcl_numBrakeLinePath
    destroy .wBLDE.dataTop.e_p1$Lcl_numBrakeLinePath
    destroy .wBLDE.dataTop.e_p2$Lcl_numBrakeLinePath
    destroy .wBLDE.dataTop.e_p3$Lcl_numBrakeLinePath
    destroy .wBLDE.dataTop.e_p4$Lcl_numBrakeLinePath
    destroy .wBLDE.dataTop.e_p5$Lcl_numBrakeLinePath
    destroy .wBLDE.dataTop.e_p6$Lcl_numBrakeLinePath

    incr Lcl_numBrakeLinePath -1

    UpdateItemLineButtons_wBLDE
}

#----------------------------------------------------------------------
#  IncItemLines_wBLDE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wBLDE {} {
    global .wBLDE
    global Lcl_numBrakeLinePath

    incr Lcl_numBrakeLinePath

    UpdateItemLineButtons_wBLDE

    # init additional variables
    CreateInitialItemLineVars_wBLDE

    AddItemLine_wBLDE $Lcl_numBrakeLinePath
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wBLDE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wBLDE {} {
    global .wBLDE
    global Lcl_numBrakeLinePath
    global Lcl_brakeLinePath

    # init additional variables
    foreach i {1 2 3 4 5 6 7 8 9 14 15} {
        set Lcl_brakeLinePath($Lcl_numBrakeLinePath,$i) 0
    }
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wBLDE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wBLDE { } {
    global .wBLDE
    global Lcl_numBrakeLinePath

    if {$Lcl_numBrakeLinePath > 1} {
        .wBLDE.dataTop.b_decItems configure -state normal
    } else {
        .wBLDE.dataTop.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wBLDE
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wBLDE { lineNum } {
    global .wBLDE
    global Lcl_brakeLinePath

    label       .wBLDE.dataTop.n$lineNum -width 15 -text "$lineNum"
    grid        .wBLDE.dataTop.n$lineNum -row [expr (6-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wBLDE.dataTop.e_p1$lineNum -width 10 -textvariable Lcl_brakeLinePath($lineNum,3)
    SetHelpBind .wBLDE.dataTop.e_p1$lineNum brakeLinePath_L1   HelpText_wBLDE
    grid        .wBLDE.dataTop.e_p1$lineNum -row [expr (6-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wBLDE.dataTop.e_p2$lineNum -width 10 -textvariable Lcl_brakeLinePath($lineNum,5)
    SetHelpBind .wBLDE.dataTop.e_p2$lineNum brakeLinePath_L2   HelpText_wBLDE
    grid        .wBLDE.dataTop.e_p2$lineNum -row [expr (6-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wBLDE.dataTop.e_p3$lineNum -width 10 -textvariable Lcl_brakeLinePath($lineNum,7)
    SetHelpBind .wBLDE.dataTop.e_p3$lineNum brakeLinePath_L3   HelpText_wBLDE
    grid        .wBLDE.dataTop.e_p3$lineNum -row [expr (6-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wBLDE.dataTop.e_p4$lineNum -width 10 -textvariable Lcl_brakeLinePath($lineNum,9)
    SetHelpBind .wBLDE.dataTop.e_p4$lineNum brakeLinePath_L4   HelpText_wBLDE
    grid        .wBLDE.dataTop.e_p4$lineNum -row [expr (6-1 + $lineNum)] -column 5 -sticky e -pady 1

    ttk::entry  .wBLDE.dataTop.e_p5$lineNum -width 10 -textvariable Lcl_brakeLinePath($lineNum,14)
    SetHelpBind .wBLDE.dataTop.e_p5$lineNum brakeLinePath_A1   HelpText_wBLDE
    grid        .wBLDE.dataTop.e_p5$lineNum -row [expr (6-1 + $lineNum)] -column 6 -sticky e -pady 1

    ttk::entry  .wBLDE.dataTop.e_p6$lineNum -width 10 -textvariable Lcl_brakeLinePath($lineNum,15)
    SetHelpBind .wBLDE.dataTop.e_p6$lineNum brakeLinePath_A2   HelpText_wBLDE
    grid        .wBLDE.dataTop.e_p6$lineNum -row [expr (6-1 + $lineNum)] -column 7 -sticky e -pady 1

}
