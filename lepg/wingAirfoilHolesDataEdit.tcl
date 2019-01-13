#---------------------------------------------------------------------
#
#  Window to edit the airfoil holes for each rib
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
global  Lcl_wAHDE_DataChanged
set     Lcl_wAHDE_DataChanged    0

global  AllGlobalVars_wAHDE
set     AllGlobalVars_wAHDE { airfConfigNum holeRibNum1 holeRibNum2 numHoles holeConfig }

#----------------------------------------------------------------------
#  wingSkinTensionDataEdit
#  Displays a window to edit the wing skin tension data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingAirfoilHolesDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wahde

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wAHDE
    foreach {e} $AllGlobalVars_wAHDE {
        global Lcl_$e
    }

    SetLclVars_wAHDE

    toplevel .wahde
    focus .wahde

    wm protocol .wahde WM_DELETE_WINDOW { CancelButtonPress_wAHDE }

    wm title .wahde [::msgcat::mc "Airfoil holes configuration"]

    #-------------
    # Frames and grids
    ttk::frame      .wahde.dataTop
    ttk::frame      .wahde.dataBot
    ttk::labelframe .wahde.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wahde.btn
    #
    grid .wahde.dataTop         -row 0 -column 0 -sticky w
    grid .wahde.dataBot         -row 1 -column 0 -sticky w
    grid .wahde.help         -row 2 -column 0 -sticky e
    grid .wahde.btn          -row 3 -column 0 -sticky e
    #
    #-------------
    # Config of configs
    button      .wahde.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Configs"] -command DecConfigTabs_wAHDE -state disabled
    grid        .wahde.dataTop.b_dec    -row 0 -column 0 -sticky e -padx 3 -pady 3

    button      .wahde.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Configs"]  -command IncConfigTabs_wAHDE
    grid        .wahde.dataTop.b_inc    -row 0 -column 1 -sticky e -padx 3 -pady 3

    ttk::notebook .wahde.dataBot.ntebk
    pack .wahde.dataBot.ntebk -fill both -expand 1
    for { set i 1 } { $i <= $Lcl_airfConfigNum } { incr i } {
        addEditTab_wAHDE $i
    }
    UpdateConfigButtons_wAHDE

    #-------------
    # explanations
    label .wahde.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wAHDE
    grid  .wahde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wahde.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wAHDE
    button .wahde.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wAHDE
    button .wahde.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wAHDE
    button .wahde.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wAHDE

    grid .wahde.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wahde.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wahde.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wahde.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wAHDE
}

#----------------------------------------------------------------------
#  SetLclVars_wAHDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wAHDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wAHDE
    foreach {e} $AllGlobalVars_wAHDE {
        global Lcl_$e
    }

    set Lcl_airfConfigNum  $airfConfigNum

    for { set i 1 } { $i <= $airfConfigNum } { incr i } {
        set Lcl_holeRibNum1($i) $holeRibNum1($i)
        set Lcl_holeRibNum2($i) $holeRibNum2($i)
        set Lcl_numHoles($i)    $numHoles($i)
    }

    for { set i 1 } { $i <= $airfConfigNum } { incr i } {
        set initialRib $holeRibNum1($i)

        for { set j 1 } { $j <= $numHoles($i) } { incr j } {
            set Lcl_holeConfig($initialRib,$j,9)  $holeConfig($initialRib,$j,9)
            set Lcl_holeConfig($initialRib,$j,2)  $holeConfig($initialRib,$j,2)
            set Lcl_holeConfig($initialRib,$j,3)  $holeConfig($initialRib,$j,3)
            set Lcl_holeConfig($initialRib,$j,4)  $holeConfig($initialRib,$j,4)
            set Lcl_holeConfig($initialRib,$j,5)  $holeConfig($initialRib,$j,5)
            set Lcl_holeConfig($initialRib,$j,6)  $holeConfig($initialRib,$j,6)
            set Lcl_holeConfig($initialRib,$j,7)  $holeConfig($initialRib,$j,7)
            set Lcl_holeConfig($initialRib,$j,8)  $holeConfig($initialRib,$j,8)
        }
    }

}

#----------------------------------------------------------------------
#  ExportLclVars_wAHDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wAHDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wAHDE
    foreach {e} $AllGlobalVars_wAHDE {
        global Lcl_$e
    }

    set airfConfigNum  $Lcl_airfConfigNum

    for { set i 1 } { $i <= $Lcl_airfConfigNum } { incr i } {
        set holeRibNum1($i) $Lcl_holeRibNum1($i)
        set holeRibNum2($i) $Lcl_holeRibNum2($i)
        set numHoles($i)    $Lcl_numHoles($i)
    }

    for { set i 1 } { $i <= $Lcl_airfConfigNum } { incr i } {
        set initialRib $holeRibNum1($i)

        for { set j 1 } { $j <= $Lcl_numHoles($i) } { incr j } {
            set holeConfig($initialRib,$j,9)  $Lcl_holeConfig($i,$j,9)
            set holeConfig($initialRib,$j,2)  $Lcl_holeConfig($i,$j,2)
            set holeConfig($initialRib,$j,3)  $Lcl_holeConfig($i,$j,3)
            set holeConfig($initialRib,$j,4)  $Lcl_holeConfig($i,$j,4)
            set holeConfig($initialRib,$j,5)  $Lcl_holeConfig($i,$j,5)
            set holeConfig($initialRib,$j,6)  $Lcl_holeConfig($i,$j,6)
            set holeConfig($initialRib,$j,7)  $Lcl_holeConfig($i,$j,7)
            set holeConfig($initialRib,$j,8)  $Lcl_holeConfig($i,$j,8)
        }
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wAHDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wAHDE {} {
    global g_WingDataChanged
    global Lcl_wAHDE_DataChanged

    if { $Lcl_wAHDE_DataChanged == 1 } {
        ExportLclVars_wAHDE

        set g_WingDataChanged       1
        set Lcl_wAHDE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wAHDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wAHDE {} {
    global .wahde
    global g_WingDataChanged
    global Lcl_wAHDE_DataChanged

    if { $Lcl_wAHDE_DataChanged == 1 } {
        ExportLclVars_wAHDE
        set g_WingDataChanged       1
        set Lcl_wAHDE_DataChanged    0
    }

    UnsetLclVarTrace_wAHDE
    destroy .wahde
}

#----------------------------------------------------------------------
#  CancelButtonPress_wAHDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wAHDE {} {
    global .wahde
    global g_WingDataChanged
    global Lcl_wAHDE_DataChanged

    if { $Lcl_wAHDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wahde
            return 0
        }
    }

    set Lcl_wAHDE_DataChanged 0
    UnsetLclVarTrace_wAHDE
    destroy .wahde

}

#----------------------------------------------------------------------
#  HelpButtonPress_wAHDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wAHDE {} {
    source "userHelp.tcl"

    displayHelpfile "airfoil-holes-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wAHDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wAHDE {} {

    global AllGlobalVars_wAHDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wAHDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wAHDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wAHDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wAHDE {} {

    global AllGlobalVars_wAHDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wAHDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wAHDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wAHDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wAHDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wAHDE_DataChanged

    set Lcl_wAHDE_DataChanged 1
}

#----------------------------------------------------------------------
#  DecConfigTabs_wAHDE
#  Decreases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecConfigTabs_wAHDE {} {
    global .wahde
    global Lcl_airfConfigNum

    destroy .wahde.dataBot.ntebk.config$Lcl_airfConfigNum

    incr Lcl_airfConfigNum -1

    UpdateConfigButtons_wAHDE
}

#----------------------------------------------------------------------
#  IncConfigTabs_wAHDE
#  Increases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncConfigTabs_wAHDE {} {
    global .wahde
    global Lcl_airfConfigNum

    incr Lcl_airfConfigNum

    UpdateConfigButtons_wAHDE

    # new tab means we must initialize the variables
    CreateInitialConfigVars_wAHDE $Lcl_airfConfigNum

    addEditTab_wAHDE $Lcl_airfConfigNum
}

#----------------------------------------------------------------------
#  CreateInitialConfigVars_wAHDE
#  Creates an initial set of initial variable to display an empty
#  configuration tab
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialConfigVars_wAHDE { tabNum_wAHDE } {
    global Lcl_holeRibNum1
    global Lcl_holeRibNum2
    global Lcl_numHoles

    # new tab means we must initialize the variables
    set Lcl_holeRibNum1($tabNum_wAHDE) "1"
    set Lcl_holeRibNum2($tabNum_wAHDE) ""
    set Lcl_numHoles($tabNum_wAHDE) 1

    CreateInitialItemLineVars_wAHDE $tabNum_wAHDE
}

#----------------------------------------------------------------------
#  UpdateConfigButtons_wAHDE
#  Updates the status of the config buttons depending on the number of
#  configs.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateConfigButtons_wAHDE {} {
    global .wahde
    global Lcl_airfConfigNum

    if {$Lcl_airfConfigNum > 1} {
        .wahde.dataTop.b_dec configure -state normal
    } else {
        .wahde.dataTop.b_dec configure -state disabled
    }
}

#----------------------------------------------------------------------
#  addEditTab_wAHDE
#  Adds all the edit elements needed for one config tab
#
#  IN:      Number of the new tab to be created (1..)
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEditTab_wAHDE {tabNum_wAHDE} {
    global .wahde

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wAHDE
    foreach {e} $AllGlobalVars_wAHDE {
        global Lcl_$e
    }

    # create GUI
    ttk::frame .wahde.dataBot.ntebk.config$tabNum_wAHDE
    .wahde.dataBot.ntebk add .wahde.dataBot.ntebk.config$tabNum_wAHDE -text [::msgcat::mc "Config $tabNum_wAHDE"]

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.spacer1 -width 5 -text "X"
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.spacer1 -row 0 -column 0

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.firstRib -width 16 -text [::msgcat::mc "Initial Rib for config"]
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.firstRib -row 0 -column 1
    ttk::entry  .wahde.dataBot.ntebk.config$tabNum_wAHDE.e_firstRib -width 10 -textvariable Lcl_holeRibNum1($tabNum_wAHDE)
    SetHelpBind .wahde.dataBot.ntebk.config$tabNum_wAHDE.e_firstRib holeRibNum1   HelpText_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.e_firstRib -row 0 -column 2 -sticky e -pady 1

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.lastRib -width 16 -text [::msgcat::mc "Last Rib for config"]
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.lastRib -row 1 -column 1
    ttk::entry  .wahde.dataBot.ntebk.config$tabNum_wAHDE.e_lastRib -width 10 -textvariable Lcl_holeRibNum2($tabNum_wAHDE)
    SetHelpBind .wahde.dataBot.ntebk.config$tabNum_wAHDE.e_lastRib holeRibNum2   HelpText_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.e_lastRib -row 1 -column 2 -sticky e -pady 1

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.spacer2 -width 5 -text "X"
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.spacer2 -row 2 -column 0

    #-------------
    # Config of items
    button      .wahde.dataBot.ntebk.config$tabNum_wAHDE.b_decItems     -width 10 -text [::msgcat::mc "dec Items"] -command DecItemLines_wAHDE -state disabled
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.b_decItems    -row 3 -column 1 -sticky e -padx 3 -pady 3

    button      .wahde.dataBot.ntebk.config$tabNum_wAHDE.b_incItems     -width 10 -text [::msgcat::mc "inc Items"]  -command IncItemLines_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.b_incItems    -row 3 -column 2 -sticky e -padx 3 -pady 3

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.spacer3 -width 5 -text "X"
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.spacer3 -row 4 -column 0

    #-------------
    # header for the item lines
    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.n -width 10 -text "Num"
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.n -row 5 -column 1 -sticky e

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.p1 -width 10 -text [::msgcat::mc "P1: Type"]
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.p1 -row 5 -column 2 -sticky e

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.p2 -width 10 -text [::msgcat::mc "P2: hor dist"]
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.p2 -row 5 -column 3 -sticky e

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.p3 -width 10 -text [::msgcat::mc "P3: vert dist"]
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.p3 -row 5 -column 4 -sticky e

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.p4 -width 10 -text "P4"
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.p4 -row 5 -column 5 -sticky e

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.p5 -width 10 -text "P5"
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.p5 -row 5 -column 6 -sticky e

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.p6 -width 10 -text "P6"
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.p6 -row 5 -column 7 -sticky e

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.p7 -width 10 -text "P7"
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.p7 -row 5 -column 8 -sticky e

    label       .wahde.dataBot.ntebk.config$tabNum_wAHDE.spacer4 -width 5 -text "X"
    grid        .wahde.dataBot.ntebk.config$tabNum_wAHDE.spacer4 -row 5 -column 9

    for { set i 1 } { $i <= $Lcl_numHoles($tabNum_wAHDE) } { incr i } {
        AddItemLine_wAHDE $tabNum_wAHDE $i
    }

    UpdateItemLineButtons_wAHDE $tabNum_wAHDE
}

#----------------------------------------------------------------------
#  DecItemLines_wAHDE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wAHDE {} {
    global .wahde
    global Lcl_numHoles

    set currentTab [eval .wahde.dataBot.ntebk index current]
    incr currentTab

    destroy .wahde.dataBot.ntebk.config$currentTab.n$Lcl_numHoles($currentTab)
    destroy .wahde.dataBot.ntebk.config$currentTab.e_p1$Lcl_numHoles($currentTab)
    destroy .wahde.dataBot.ntebk.config$currentTab.e_p2$Lcl_numHoles($currentTab)
    destroy .wahde.dataBot.ntebk.config$currentTab.e_p3$Lcl_numHoles($currentTab)
    destroy .wahde.dataBot.ntebk.config$currentTab.e_p4$Lcl_numHoles($currentTab)
    destroy .wahde.dataBot.ntebk.config$currentTab.e_p5$Lcl_numHoles($currentTab)
    destroy .wahde.dataBot.ntebk.config$currentTab.e_p6$Lcl_numHoles($currentTab)
    destroy .wahde.dataBot.ntebk.config$currentTab.e_p7$Lcl_numHoles($currentTab)

    incr Lcl_numHoles($currentTab) -1

    UpdateItemLineButtons_wAHDE 0
}

#----------------------------------------------------------------------
#  IncItemLines_wAHDE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wAHDE {} {
    global .wahde
    global Lcl_numHoles

    set currentTab [eval .wahde.dataBot.ntebk index current]
    incr currentTab

    incr Lcl_numHoles($currentTab)

    UpdateItemLineButtons_wAHDE 0

    # init additional variables
    CreateInitialItemLineVars_wAHDE $currentTab

    AddItemLine_wAHDE $currentTab $Lcl_numHoles($currentTab)
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wAHDE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wAHDE { tabNum_wAHDE } {
    global .wahde
    global Lcl_numHoles
    global Lcl_holeConfig

    # init additional variables
    for { set i 2} { $i <= 9 } {incr i} {
        set Lcl_holeConfig($tabNum_wAHDE,$Lcl_numHoles($tabNum_wAHDE),$i) 0.
    }
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wAHDE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wAHDE { tabNum } {
    global .wahde
    global Lcl_numHoles

    if { $tabNum == 0 } {
        set currentTab [eval .wahde.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    if {$Lcl_numHoles($currentTab) > 1} {
        .wahde.dataBot.ntebk.config$currentTab.b_decItems configure -state normal
    } else {
        .wahde.dataBot.ntebk.config$currentTab.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wAHDE
#  Adds an additional Item Line to a tab
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wAHDE { tabNum lineNum} {
    global .wahde
    global Lcl_holeConfig

    if { $tabNum == 0 } {
        set currentTab [eval .wahde.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    label       .wahde.dataBot.ntebk.config$tabNum.n$lineNum -width 15 -text "$lineNum"
    grid        .wahde.dataBot.ntebk.config$tabNum.n$lineNum -row [expr (6-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wahde.dataBot.ntebk.config$tabNum.e_p1$lineNum -width 10 -textvariable Lcl_holeConfig($currentTab,$lineNum,9)
    SetHelpBind .wahde.dataBot.ntebk.config$tabNum.e_p1$lineNum holeconfig_P1   HelpText_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum.e_p1$lineNum -row [expr (6-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wahde.dataBot.ntebk.config$tabNum.e_p2$lineNum -width 10 -textvariable Lcl_holeConfig($currentTab,$lineNum,2)
    SetHelpBind .wahde.dataBot.ntebk.config$tabNum.e_p2$lineNum holeconfig_P2   HelpText_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum.e_p2$lineNum -row [expr (6-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wahde.dataBot.ntebk.config$tabNum.e_p3$lineNum -width 10 -textvariable Lcl_holeConfig($currentTab,$lineNum,3)
    SetHelpBind .wahde.dataBot.ntebk.config$tabNum.e_p3$lineNum holeconfig_P3   HelpText_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum.e_p3$lineNum -row [expr (6-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wahde.dataBot.ntebk.config$tabNum.e_p4$lineNum -width 10 -textvariable Lcl_holeConfig($currentTab,$lineNum,4)
    SetHelpBind .wahde.dataBot.ntebk.config$tabNum.e_p4$lineNum holeconfig_P4   HelpText_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum.e_p4$lineNum -row [expr (6-1 + $lineNum)] -column 5 -sticky e -pady 1

    ttk::entry  .wahde.dataBot.ntebk.config$tabNum.e_p5$lineNum -width 10 -textvariable Lcl_holeConfig($currentTab,$lineNum,5)
    SetHelpBind .wahde.dataBot.ntebk.config$tabNum.e_p5$lineNum holeconfig_P5   HelpText_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum.e_p5$lineNum -row [expr (6-1 + $lineNum)] -column 6 -sticky e -pady 1

    ttk::entry  .wahde.dataBot.ntebk.config$tabNum.e_p6$lineNum -width 10 -textvariable Lcl_holeConfig($currentTab,$lineNum,6)
    SetHelpBind .wahde.dataBot.ntebk.config$tabNum.e_p6$lineNum holeconfig_P6   HelpText_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum.e_p6$lineNum -row [expr (6-1 + $lineNum)] -column 7 -sticky e -pady 1

    ttk::entry  .wahde.dataBot.ntebk.config$tabNum.e_p7$lineNum -width 10 -textvariable Lcl_holeConfig($currentTab,$lineNum,7)
    SetHelpBind .wahde.dataBot.ntebk.config$tabNum.e_p7$lineNum holeconfig_P7   HelpText_wAHDE
    grid        .wahde.dataBot.ntebk.config$tabNum.e_p7$lineNum -row [expr (6-1 + $lineNum)] -column 8 -sticky e -pady 1

}
