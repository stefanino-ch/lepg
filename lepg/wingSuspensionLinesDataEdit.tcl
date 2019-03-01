#---------------------------------------------------------------------
#
#  Window to edit the suspension lines
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wSLDE_DataChanged
set     Lcl_wSLDE_DataChanged    0

global  AllGlobalVars_wSLDE
set     AllGlobalVars_wSLDE { lineMode numLinePlan numLinePath linePath }

#----------------------------------------------------------------------
#  wingSuspensionLinesDataEdit
#  Displays a window to edit the suspension lines data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingSuspensionLinesDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wSLDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wSLDE
    foreach {e} $AllGlobalVars_wSLDE {
        global Lcl_$e
    }

    SetLclVars_wSLDE

    toplevel .wSLDE
    focus .wSLDE

    wm protocol .wSLDE WM_DELETE_WINDOW { CancelButtonPress_wSLDE }

    wm title .wSLDE [::msgcat::mc "Suspension lines configuration"]

    #-------------
    # Frames and grids
    ttk::frame      .wSLDE.dataTop
    ttk::frame      .wSLDE.dataBot
    ttk::labelframe .wSLDE.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wSLDE.btn
    #
    grid .wSLDE.dataTop         -row 0 -column 0 -sticky w
    grid .wSLDE.dataBot         -row 1 -column 0 -sticky w
    grid .wSLDE.help            -row 2 -column 0 -sticky e
    grid .wSLDE.btn             -row 3 -column 0 -sticky e
    #
    #-------------
    # Spacer for line 1
    label       .wSLDE.dataTop.spacer00 -width 5 -text ""
    grid        .wSLDE.dataTop.spacer00 -row 1 -column 0

    #-------------
    # Control parameter, just display no edit allowed
    label       .wSLDE.dataTop.ctrl -width 16 -text [::msgcat::mc "Control param"]
    grid        .wSLDE.dataTop.ctrl -row 2 -column 0 -sticky e
    ttk::entry  .wSLDE.dataTop.e_ctrl -width 10 -textvariable Lcl_lineMode -state disabled
    SetHelpBind .wSLDE.dataTop.e_ctrl lineMode   HelpText_wSLDE
    grid        .wSLDE.dataTop.e_ctrl -row 2 -column 1 -sticky w -pady 1

    #-------------
    # Spacer for line 3
    label       .wSLDE.dataTop.spacer10 -width 5 -text ""
    grid        .wSLDE.dataTop.spacer10 -row 3 -column 0

    #-------------
    # Config of configs
    button      .wSLDE.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Plans"] -command DecConfigTabs_wSLDE -state disabled
    grid        .wSLDE.dataTop.b_dec    -row 4 -column 0 -sticky e -padx 3 -pady 3

    button      .wSLDE.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Plans"]  -command IncConfigTabs_wSLDE
    grid        .wSLDE.dataTop.b_inc    -row 4 -column 1 -sticky e -padx 3 -pady 3

    ttk::notebook .wSLDE.dataBot.ntebk
    pack .wSLDE.dataBot.ntebk -fill both -expand 1
    for { set i 1 } { $i <= $Lcl_numLinePlan } { incr i } {
        addEditTab_wSLDE $i
    }
    UpdateConfigButtons_wSLDE

    #-------------
    # explanations
    label .wSLDE.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wSLDE
    grid  .wSLDE.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wSLDE.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wSLDE
    button .wSLDE.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wSLDE
    button .wSLDE.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wSLDE
    button .wSLDE.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wSLDE

    grid .wSLDE.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wSLDE.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wSLDE.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wSLDE.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wSLDE
}

#----------------------------------------------------------------------
#  SetLclVars_wSLDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wSLDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wSLDE
    foreach {e} $AllGlobalVars_wSLDE {
        global Lcl_$e
    }

    set Lcl_lineMode  $lineMode

    set Lcl_numLinePlan  $numLinePlan

    # iterate across all line plans
    for { set i 1 } { $i <= $numLinePlan } { incr i } {
        set Lcl_numLinePath($i)  $numLinePath($i)

        # iterate across all line paths
        for { set j 1 } { $j <= $numLinePath($i) } { incr j } {
            set Lcl_linePath($i,$j,1)   $linePath($i,$j,1)
            set Lcl_linePath($i,$j,2)   $linePath($i,$j,2)
            set Lcl_linePath($i,$j,3)   $linePath($i,$j,3)
            set Lcl_linePath($i,$j,4)   $linePath($i,$j,4)
            set Lcl_linePath($i,$j,5)   $linePath($i,$j,5)
            set Lcl_linePath($i,$j,6)   $linePath($i,$j,6)
            set Lcl_linePath($i,$j,7)   $linePath($i,$j,7)
            set Lcl_linePath($i,$j,8)   $linePath($i,$j,8)
            set Lcl_linePath($i,$j,9)   $linePath($i,$j,9)
            set Lcl_linePath($i,$j,14)  $linePath($i,$j,14)
            set Lcl_linePath($i,$j,15)  $linePath($i,$j,15)
        }
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wSLDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wSLDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wSLDE
    foreach {e} $AllGlobalVars_wSLDE {
        global Lcl_$e
    }

    set lineMode  $Lcl_lineMode

    set numLinePlan  $Lcl_numLinePlan

    # iterate across all line plans
    for { set i 1 } { $i <= $Lcl_numLinePlan } { incr i } {
        set numLinePath($i)  $Lcl_numLinePath($i)

        # iterate across all line paths
        for { set j 1 } { $j <= $Lcl_numLinePath($i) } { incr j } {

            # set num of branches and branching level numbers 0
            foreach k {1 2 3 4 5 6 7 8 9} {
                set linePath($i,$j,$k) 0
            }

            # count number of valid branches and set parameters
            set numBranches 0
            foreach k {3 5 7 9} {
                if {$Lcl_linePath($i,$j,$k) != 0} {
                    incr numBranches
                    # the level number itself
                    set linePath($i,$j,[expr ($k-1)]) $numBranches
                    # the value
                    set linePath($i,$j,$k) $Lcl_linePath($i,$j,$k)
                }
            }
            # first value on each line: number of branches
            set linePath($i,$j,1)   $numBranches

            set linePath($i,$j,14)  $Lcl_linePath($i,$j,14)
            set linePath($i,$j,15)  $Lcl_linePath($i,$j,15)
        }
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wSLDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wSLDE {} {
    global g_WingDataChanged
    global Lcl_wSLDE_DataChanged

    if { $Lcl_wSLDE_DataChanged == 1 } {
        ExportLclVars_wSLDE

        set g_WingDataChanged       1
        set Lcl_wSLDE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wSLDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wSLDE {} {
    global .wSLDE
    global g_WingDataChanged
    global Lcl_wSLDE_DataChanged

    if { $Lcl_wSLDE_DataChanged == 1 } {
        ExportLclVars_wSLDE
        set g_WingDataChanged       1
        set Lcl_wSLDE_DataChanged    0
    }

    UnsetLclVarTrace_wSLDE
    destroy .wSLDE
}

#----------------------------------------------------------------------
#  CancelButtonPress_wSLDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wSLDE {} {
    global .wSLDE
    global g_WingDataChanged
    global Lcl_wSLDE_DataChanged

    if { $Lcl_wSLDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wSLDE
            return 0
        }
    }

    set Lcl_wSLDE_DataChanged 0
    UnsetLclVarTrace_wSLDE
    destroy .wSLDE

}

#----------------------------------------------------------------------
#  HelpButtonPress_wSLDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wSLDE {} {
    source "userHelp.tcl"

    displayHelpfile "suspension-lines-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wSLDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wSLDE {} {

    global AllGlobalVars_wSLDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSLDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wSLDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wSLDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wSLDE {} {

    global AllGlobalVars_wSLDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wSLDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wSLDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wSLDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wSLDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wSLDE_DataChanged

    set Lcl_wSLDE_DataChanged 1
}

#----------------------------------------------------------------------
#  DecConfigTabs_wSLDE
#  Decreases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecConfigTabs_wSLDE {} {
    global .wSLDE
    global Lcl_numLinePlan

    destroy .wSLDE.dataBot.ntebk.config$Lcl_numLinePlan

    incr Lcl_numLinePlan -1

    UpdateConfigButtons_wSLDE
}

#----------------------------------------------------------------------
#  IncConfigTabs_wSLDE
#  Increases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncConfigTabs_wSLDE {} {
    global .wSLDE
    global Lcl_numLinePlan

    incr Lcl_numLinePlan

    UpdateConfigButtons_wSLDE

    # new tab means we must initialize the variables
    CreateInitialConfigVars_wSLDE $Lcl_numLinePlan

    addEditTab_wSLDE $Lcl_numLinePlan
}

#----------------------------------------------------------------------
#  CreateInitialConfigVars_wSLDE
#  Creates an initial set of initial variable to display an empty
#  configuration tab
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialConfigVars_wSLDE { tabNum_wSLDE } {
    global Lcl_numLinePath

    set Lcl_numLinePath($tabNum_wSLDE) 1

    CreateInitialItemLineVars_wSLDE $tabNum_wSLDE
}

#----------------------------------------------------------------------
#  UpdateConfigButtons_wSLDE
#  Updates the status of the config buttons depending on the number of
#  configs.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateConfigButtons_wSLDE {} {
    global .wSLDE
    global Lcl_numLinePlan

    if {$Lcl_numLinePlan > 1} {
        .wSLDE.dataTop.b_dec configure -state normal
    } else {
        .wSLDE.dataTop.b_dec configure -state disabled
    }
}

#----------------------------------------------------------------------
#  addEditTab_wSLDE
#  Adds all the edit elements needed for one config tab
#
#  IN:      Number of the new tab to be created (1..)
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEditTab_wSLDE {tabNum_wSLDE} {
    global .wSLDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wSLDE
    foreach {e} $AllGlobalVars_wSLDE {
        global Lcl_$e
    }

    # create GUI
    ttk::frame .wSLDE.dataBot.ntebk.config$tabNum_wSLDE
    .wSLDE.dataBot.ntebk add .wSLDE.dataBot.ntebk.config$tabNum_wSLDE -text [::msgcat::mc "Plan $tabNum_wSLDE"]

    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.spacer00 -width 5 -text ""
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.spacer00 -row 0 -column 0

    #-------------
    # Config of items
    button      .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.b_decItems     -width 10 -text [::msgcat::mc "dec Paths"] -command DecItemLines_wSLDE -state disabled
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.b_decItems    -row 1 -column 1 -sticky e -padx 3 -pady 3

    button      .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.b_incItems     -width 10 -text [::msgcat::mc "inc Paths"]  -command IncItemLines_wSLDE
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.b_incItems    -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.spacer20 -width 5 -text ""
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines
    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.n -width 10 -text "Num"
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.n -row 5 -column 1 -sticky e

    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p1 -width 10 -text [::msgcat::mc "Lvl 1"]
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p1 -row 5 -column 2 -sticky e

    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p2 -width 10 -text [::msgcat::mc "Lvl 2"]
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p2 -row 5 -column 3 -sticky e

    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p3 -width 10 -text [::msgcat::mc "Lvl 3"]
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p3 -row 5 -column 4 -sticky e

    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p4 -width 10 -text "Lvl 4"
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p4 -row 5 -column 5 -sticky e

    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p5 -width 10 -text "Anchor line"
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p5 -row 5 -column 6 -sticky e

    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p6 -width 10 -text "Rib num"
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.p6 -row 5 -column 7 -sticky e

    label       .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.spacer58 -width 5 -text ""
    grid        .wSLDE.dataBot.ntebk.config$tabNum_wSLDE.spacer58 -row 5 -column 8


    for { set i 1 } { $i <= $Lcl_numLinePath($tabNum_wSLDE) } { incr i } {
        AddItemLine_wSLDE $tabNum_wSLDE $i
    }

    UpdateItemLineButtons_wSLDE $tabNum_wSLDE
}

#----------------------------------------------------------------------
#  DecItemLines_wSLDE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wSLDE {} {
    global .wSLDE
    global Lcl_numLinePath

    set currentTab [eval .wSLDE.dataBot.ntebk index current]
    incr currentTab

    destroy .wSLDE.dataBot.ntebk.config$currentTab.n$Lcl_numLinePath($currentTab)
    destroy .wSLDE.dataBot.ntebk.config$currentTab.e_p1$Lcl_numLinePath($currentTab)
    destroy .wSLDE.dataBot.ntebk.config$currentTab.e_p2$Lcl_numLinePath($currentTab)
    destroy .wSLDE.dataBot.ntebk.config$currentTab.e_p3$Lcl_numLinePath($currentTab)
    destroy .wSLDE.dataBot.ntebk.config$currentTab.e_p4$Lcl_numLinePath($currentTab)
    destroy .wSLDE.dataBot.ntebk.config$currentTab.e_p5$Lcl_numLinePath($currentTab)
    destroy .wSLDE.dataBot.ntebk.config$currentTab.e_p6$Lcl_numLinePath($currentTab)

    incr Lcl_numLinePath($currentTab) -1

    UpdateItemLineButtons_wSLDE 0
}

#----------------------------------------------------------------------
#  IncItemLines_wSLDE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wSLDE {} {
    global .wSLDE
    global Lcl_numLinePath

    set currentTab [eval .wSLDE.dataBot.ntebk index current]
    incr currentTab

    incr Lcl_numLinePath($currentTab)

    UpdateItemLineButtons_wSLDE 0

    # init additional variables
    CreateInitialItemLineVars_wSLDE $currentTab

    AddItemLine_wSLDE $currentTab $Lcl_numLinePath($currentTab)
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wSLDE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wSLDE { tabNum_wSLDE } {
    global .wSLDE
    global Lcl_numLinePath
    global Lcl_linePath

    # init additional variables
    foreach i {1 2 3 4 5 6 7 8 9 14 15} {
        set Lcl_linePath($tabNum_wSLDE,$Lcl_numLinePath($tabNum_wSLDE),$i) 0.
    }
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wSLDE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wSLDE { tabNum } {
    global .wSLDE
    global Lcl_numLinePath

    if { $tabNum == 0 } {
        set currentTab [eval .wSLDE.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    if {$Lcl_numLinePath($currentTab) > 1} {
        .wSLDE.dataBot.ntebk.config$currentTab.b_decItems configure -state normal
    } else {
        .wSLDE.dataBot.ntebk.config$currentTab.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wSLDE
#  Adds an additional Item Line to a tab
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wSLDE { tabNum lineNum} {
    global .wSLDE
    global Lcl_linePath

    if { $tabNum == 0 } {
        set currentTab [eval .wSLDE.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    label       .wSLDE.dataBot.ntebk.config$tabNum.n$lineNum -width 15 -text "$lineNum"
    grid        .wSLDE.dataBot.ntebk.config$tabNum.n$lineNum -row [expr (6-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wSLDE.dataBot.ntebk.config$tabNum.e_p1$lineNum -width 10 -textvariable Lcl_linePath($currentTab,$lineNum,3)
    SetHelpBind .wSLDE.dataBot.ntebk.config$tabNum.e_p1$lineNum linePath_L1   HelpText_wSLDE
    grid        .wSLDE.dataBot.ntebk.config$tabNum.e_p1$lineNum -row [expr (6-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wSLDE.dataBot.ntebk.config$tabNum.e_p2$lineNum -width 10 -textvariable Lcl_linePath($currentTab,$lineNum,5)
    SetHelpBind .wSLDE.dataBot.ntebk.config$tabNum.e_p2$lineNum linePath_L2   HelpText_wSLDE
    grid        .wSLDE.dataBot.ntebk.config$tabNum.e_p2$lineNum -row [expr (6-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wSLDE.dataBot.ntebk.config$tabNum.e_p3$lineNum -width 10 -textvariable Lcl_linePath($currentTab,$lineNum,7)
    SetHelpBind .wSLDE.dataBot.ntebk.config$tabNum.e_p3$lineNum linePath_L3   HelpText_wSLDE
    grid        .wSLDE.dataBot.ntebk.config$tabNum.e_p3$lineNum -row [expr (6-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wSLDE.dataBot.ntebk.config$tabNum.e_p4$lineNum -width 10 -textvariable Lcl_linePath($currentTab,$lineNum,9)
    SetHelpBind .wSLDE.dataBot.ntebk.config$tabNum.e_p4$lineNum linePath_L4   HelpText_wSLDE
    grid        .wSLDE.dataBot.ntebk.config$tabNum.e_p4$lineNum -row [expr (6-1 + $lineNum)] -column 5 -sticky e -pady 1

    ttk::entry  .wSLDE.dataBot.ntebk.config$tabNum.e_p5$lineNum -width 10 -textvariable Lcl_linePath($currentTab,$lineNum,14)
    SetHelpBind .wSLDE.dataBot.ntebk.config$tabNum.e_p5$lineNum linePath_A1   HelpText_wSLDE
    grid        .wSLDE.dataBot.ntebk.config$tabNum.e_p5$lineNum -row [expr (6-1 + $lineNum)] -column 6 -sticky e -pady 1

    ttk::entry  .wSLDE.dataBot.ntebk.config$tabNum.e_p6$lineNum -width 10 -textvariable Lcl_linePath($currentTab,$lineNum,15)
    SetHelpBind .wSLDE.dataBot.ntebk.config$tabNum.e_p6$lineNum linePath_A2   HelpText_wSLDE
    grid        .wSLDE.dataBot.ntebk.config$tabNum.e_p6$lineNum -row [expr (6-1 + $lineNum)] -column 7 -sticky e -pady 1

}
