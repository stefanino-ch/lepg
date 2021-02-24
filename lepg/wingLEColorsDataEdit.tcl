#---------------------------------------------------------------------
#
#  Window to edit the intrados color settings
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wLECDE_DataChanged
set     Lcl_wLECDE_DataChanged    0

global  AllGlobalVars_wLECDE
set     AllGlobalVars_wLECDE { numLeCol leColRibNum numLeColMarks leColMarkNum leColMarkYDist leColMarkXDist  }

#----------------------------------------------------------------------
#  wingLeadingEdgeColorsDataEdit
#  Displays a window to edit the wing leading edge color settings
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingLeadingEdgeColorsDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wlecde

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wLECDE
    foreach {e} $AllGlobalVars_wLECDE {
        global Lcl_$e
    }

    SetLclVars_wLECDE

    toplevel .wlecde
    focus .wlecde

    wm protocol .wlecde WM_DELETE_WINDOW { CancelButtonPress_wLECDE }

    wm title .wlecde [::msgcat::mc "Section 16. Lower surface color marks"]

    #-------------
    # Frames and grids
    ttk::frame      .wlecde.dataTop
    ttk::frame      .wlecde.dataBot
    ttk::labelframe .wlecde.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wlecde.btn
    #
    grid .wlecde.dataTop         -row 0 -column 0 -sticky w
    grid .wlecde.dataBot         -row 1 -column 0 -sticky w
    grid .wlecde.help         -row 2 -column 0 -sticky e
    grid .wlecde.btn          -row 3 -column 0 -sticky e
    #

    label       .wlecde.dataTop.numc -width 20 -text [::msgcat::mc "Configuration"]
    grid        .wlecde.dataTop.numc -row 0 -column 1
    ttk::entry  .wlecde.dataTop.e_numc -width 20 -textvariable Lcl_numLeCol
    SetHelpBind .wlecde.dataTop.e_numc [::msgcat::mc "Configuration"] HelpText_wTECDE
    grid        .wlecde.dataTop.e_numc -row 0 -column 2 -sticky e -pady 1


    # Print data only if number of configurations is not 0
    if { $Lcl_numLeCol != 0 } {

    #-------------
    # Config of configs
    button      .wlecde.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Configs"] -command DecConfigTabs_wLECDE -state disabled
    grid        .wlecde.dataTop.b_dec    -row 1 -column 0 -sticky e -padx 3 -pady 3

    button      .wlecde.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Configs"]  -command IncConfigTabs_wLECDE
    grid        .wlecde.dataTop.b_inc    -row 1 -column 1 -sticky e -padx 3 -pady 3

    ttk::notebook .wlecde.dataBot.ntebk
    pack .wlecde.dataBot.ntebk -fill both -expand 1
    for { set i 1 } { $i <= $Lcl_numLeCol } { incr i } {
        addEditTab_wLECDE $i
    }
    UpdateConfigButtons_wLECDE

    # End case not 0
    }

    #-------------
    # explanations
    label .wlecde.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wLECDE
    grid  .wlecde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wlecde.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wLECDE
    button .wlecde.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wLECDE
    button .wlecde.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wLECDE
    button .wlecde.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wLECDE

    grid .wlecde.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wlecde.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wlecde.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wlecde.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wLECDE
}

#----------------------------------------------------------------------
#  SetLclVars_wLECDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wLECDE {} {
    source "globalWingVars.tcl"

    #

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wLECDE
    foreach {e} $AllGlobalVars_wLECDE {
        global Lcl_$e
    }

    set Lcl_numLeCol  $numLeCol

    for { set i 1 } { $i <= $numLeCol } { incr i } {
        set Lcl_leColRibNum($i) $leColRibNum($i)
        set Lcl_numLeColMarks($i) $numLeColMarks($i)
    }

    for { set i 1 } { $i <= $numLeCol } { incr i } {
        for { set j 1 } { $j <= $numLeColMarks($i) } { incr j } {
            set Lcl_leColMarkNum($i,$j)     $leColMarkNum($i,$j)
            set Lcl_leColMarkYDist($i,$j)   $leColMarkYDist($i,$j)
            set Lcl_leColMarkXDist($i,$j)   $leColMarkXDist($i,$j)
        }
    }

}

#----------------------------------------------------------------------
#  ExportLclVars_wLECDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wLECDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wLECDE
    foreach {e} $AllGlobalVars_wLECDE {
        global Lcl_$e
    }

    set numLeCol  $Lcl_numLeCol

    for { set i 1 } { $i <= $Lcl_numLeCol } { incr i } {
        set leColRibNum($i) $Lcl_leColRibNum($i)
        set numLeColMarks($i) $Lcl_numLeColMarks($i)
    }

    for { set i 1 } { $i <= $Lcl_numLeCol } { incr i } {
        for { set j 1 } { $j <= $Lcl_numLeColMarks($i) } { incr j } {
            set leColMarkNum($i,$j)     $Lcl_leColMarkNum($i,$j)
            set leColMarkYDist($i,$j)   $Lcl_leColMarkYDist($i,$j)
            set leColMarkXDist($i,$j)   $Lcl_leColMarkXDist($i,$j)
        }
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wLECDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wLECDE {} {
    global g_WingDataChanged
    global Lcl_wLECDE_DataChanged

    if { $Lcl_wLECDE_DataChanged == 1 } {
        ExportLclVars_wLECDE

        set g_WingDataChanged       1
        set Lcl_wLECDE_DataChanged    0
    }

    # Destroy and edir again
    destroy .wlecde
    wingLeadingEdgeColorsDataEdit
}

#----------------------------------------------------------------------
#  OkButtonPress_wLECDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wLECDE {} {
    global .wlecde
    global g_WingDataChanged
    global Lcl_wLECDE_DataChanged

    if { $Lcl_wLECDE_DataChanged == 1 } {
        ExportLclVars_wLECDE
        set g_WingDataChanged       1
        set Lcl_wLECDE_DataChanged    0
    }

    UnsetLclVarTrace_wLECDE
    destroy .wlecde
}

#----------------------------------------------------------------------
#  CancelButtonPress_wLECDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wLECDE {} {
    global .wlecde
    global g_WingDataChanged
    global Lcl_wLECDE_DataChanged

    if { $Lcl_wLECDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wlecde
            return 0
        }
    }

    set Lcl_wLECDE_DataChanged 0
    UnsetLclVarTrace_wLECDE
    destroy .wlecde

}

#----------------------------------------------------------------------
#  HelpButtonPress_wLECDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wLECDE {} {
    source "userHelp.tcl"

    displayHelpfile "le-colors-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wLECDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wLECDE {} {

    global AllGlobalVars_wLECDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wLECDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wLECDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wLECDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wLECDE {} {

    global AllGlobalVars_wLECDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wLECDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wLECDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wLECDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wLECDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wLECDE_DataChanged

    set Lcl_wLECDE_DataChanged 1
}

#----------------------------------------------------------------------
#  DecConfigTabs_wLECDE
#  Decreases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecConfigTabs_wLECDE {} {
    global .wlecde
    global Lcl_numLeCol

    destroy .wlecde.dataBot.ntebk.config$Lcl_numLeCol

    incr Lcl_numLeCol -1

    UpdateConfigButtons_wLECDE
}

#----------------------------------------------------------------------
#  IncConfigTabs_wLECDE
#  Increases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncConfigTabs_wLECDE {} {
    global .wlecde
    global Lcl_numLeCol

    incr Lcl_numLeCol

    UpdateConfigButtons_wLECDE

    # new tab means we must initialize the variables
    CreateInitialConfigVars_wLECDE $Lcl_numLeCol

    addEditTab_wLECDE $Lcl_numLeCol
}

#----------------------------------------------------------------------
#  CreateInitialConfigVars_wLECDE
#  Creates an initial set of initial variable to display an empty
#  configuration tab
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialConfigVars_wLECDE { tabNum_wLECDE } {
    global Lcl_leColRibNum
    global Lcl_numLeColMarks

    # new tab means we must initialize the variables
    set Lcl_leColRibNum($tabNum_wLECDE) "1"
    set Lcl_numLeColMarks($tabNum_wLECDE) 1

    CreateInitialItemLineVars_wLECDE $tabNum_wLECDE
}

#----------------------------------------------------------------------
#  UpdateConfigButtons_wLECDE
#  Updates the status of the config buttons depending on the number of
#  configs.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateConfigButtons_wLECDE {} {
    global .wlecde
    global Lcl_numLeCol

    if {$Lcl_numLeCol > 1} {
        .wlecde.dataTop.b_dec configure -state normal
    } else {
        .wlecde.dataTop.b_dec configure -state disabled
    }
}

#----------------------------------------------------------------------
#  addEditTab_wLECDE
#  Adds all the edit elements needed for one config tab
#
#  IN:      Number of the new tab to be created (1..)
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEditTab_wLECDE {tabNum_wLECDE} {
    global .wlecde

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wLECDE
    foreach {e} $AllGlobalVars_wLECDE {
        global Lcl_$e
    }

    # create GUI
    ttk::frame .wlecde.dataBot.ntebk.config$tabNum_wLECDE
    .wlecde.dataBot.ntebk add .wlecde.dataBot.ntebk.config$tabNum_wLECDE -text [::msgcat::mc "Config $tabNum_wLECDE"]

    label       .wlecde.dataBot.ntebk.config$tabNum_wLECDE.spacer1 -width 5 -text ""
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.spacer1 -row 0 -column 0

    label       .wlecde.dataBot.ntebk.config$tabNum_wLECDE.firstRib -width 16 -text [::msgcat::mc "Rib for config"]
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.firstRib -row 0 -column 1
    ttk::entry  .wlecde.dataBot.ntebk.config$tabNum_wLECDE.e_firstRib -width 10 -textvariable Lcl_leColRibNum($tabNum_wLECDE)
    SetHelpBind .wlecde.dataBot.ntebk.config$tabNum_wLECDE.e_firstRib [::msgcat::mc "inColRibNum"]   HelpText_wLECDE
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.e_firstRib -row 0 -column 2 -sticky e -pady 1

    label       .wlecde.dataBot.ntebk.config$tabNum_wLECDE.spacer2 -width 5 -text ""
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.spacer2 -row 1 -column 0

    #-------------
    # Config of items
    button      .wlecde.dataBot.ntebk.config$tabNum_wLECDE.b_decItems     -width 10 -text [::msgcat::mc "dec Items"] -command DecItemLines_wLECDE -state disabled
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.b_decItems    -row 2 -column 1 -sticky e -padx 3 -pady 3

    button      .wlecde.dataBot.ntebk.config$tabNum_wLECDE.b_incItems     -width 10 -text [::msgcat::mc "inc Items"]  -command IncItemLines_wLECDE
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.b_incItems    -row 2 -column 2 -sticky e -padx 3 -pady 3

    label       .wlecde.dataBot.ntebk.config$tabNum_wLECDE.spacer3 -width 5 -text ""
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.spacer3 -row 3 -column 0

    #-------------
    # header for the item lines
    label       .wlecde.dataBot.ntebk.config$tabNum_wLECDE.n -width 10 -text [::msgcat::mc "Num"]
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.n -row 4 -column 1 -sticky e

    label       .wlecde.dataBot.ntebk.config$tabNum_wLECDE.p2 -width 10 -text [::msgcat::mc "hor dist"]
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.p2 -row 4 -column 2 -sticky e

    label       .wlecde.dataBot.ntebk.config$tabNum_wLECDE.p3 -width 10 -text [::msgcat::mc "ver dist"]
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.p3 -row 4 -column 3 -sticky e

    label       .wlecde.dataBot.ntebk.config$tabNum_wLECDE.spacer4 -width 5 -text ""
    grid        .wlecde.dataBot.ntebk.config$tabNum_wLECDE.spacer4 -row 4 -column 4

    for { set i 1 } { $i <= $Lcl_numLeColMarks($tabNum_wLECDE) } { incr i } {
        AddItemLine_wLECDE $tabNum_wLECDE $i
    }

    UpdateItemLineButtons_wLECDE $tabNum_wLECDE
}

#----------------------------------------------------------------------
#  DecItemLines_wLECDE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wLECDE {} {
    global .wlecde
    global Lcl_numLeColMarks

    set currentTab [eval .wlecde.dataBot.ntebk index current]
    incr currentTab

    destroy .wlecde.dataBot.ntebk.config$currentTab.n$Lcl_numLeColMarks($currentTab)
    destroy .wlecde.dataBot.ntebk.config$currentTab.e_p1$Lcl_numLeColMarks($currentTab)
    destroy .wlecde.dataBot.ntebk.config$currentTab.e_p2$Lcl_numLeColMarks($currentTab)

    incr Lcl_numLeColMarks($currentTab) -1

    UpdateItemLineButtons_wLECDE 0
}

#----------------------------------------------------------------------
#  IncItemLines_wLECDE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wLECDE {} {
    global .wlecde
    global Lcl_numLeColMarks

    set currentTab [eval .wlecde.dataBot.ntebk index current]
    incr currentTab

    incr Lcl_numLeColMarks($currentTab)

    UpdateItemLineButtons_wLECDE 0

    # init additional variables
    CreateInitialItemLineVars_wLECDE $currentTab

    AddItemLine_wLECDE $currentTab $Lcl_numLeColMarks($currentTab)
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wLECDE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wLECDE { tabNum_wLECDE } {
    global .wlecde
    global Lcl_numLeColMarks
    global Lcl_leColMarkNum
    global Lcl_leColMarkXDist
    global Lcl_leColMarkYDist

    set Lcl_leColMarkNum($tabNum_wLECDE,$Lcl_numLeColMarks($tabNum_wLECDE)) $Lcl_numLeColMarks($tabNum_wLECDE)
    set Lcl_leColMarkXDist($tabNum_wLECDE,$Lcl_numLeColMarks($tabNum_wLECDE)) 0.
    set Lcl_leColMarkYDist($tabNum_wLECDE,$Lcl_numLeColMarks($tabNum_wLECDE)) 0.
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wLECDE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wLECDE { tabNum } {
    global .wlecde
    global Lcl_numLeColMarks

    if { $tabNum == 0 } {
        set currentTab [eval .wlecde.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    if {$Lcl_numLeColMarks($currentTab) > 1} {
        .wlecde.dataBot.ntebk.config$currentTab.b_decItems configure -state normal
    } else {
        .wlecde.dataBot.ntebk.config$currentTab.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wLECDE
#  Adds an additional Item Line to a tab
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wLECDE { tabNum lineNum} {
    global .wlecde
    global Lcl_leColMarkXDist
    global Lcl_leColMarkYDist

    if { $tabNum == 0 } {
        set currentTab [eval .wlecde.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    set startLine 5

    label       .wlecde.dataBot.ntebk.config$tabNum.n$lineNum -width 15 -text "$lineNum"
    grid        .wlecde.dataBot.ntebk.config$tabNum.n$lineNum -row [expr ($startLine-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wlecde.dataBot.ntebk.config$tabNum.e_p1$lineNum -width 10 -textvariable Lcl_leColMarkXDist($currentTab,$lineNum)
    SetHelpBind .wlecde.dataBot.ntebk.config$tabNum.e_p1$lineNum [::msgcat::mc "inColMarkXDist"]   HelpText_wLECDE
    grid        .wlecde.dataBot.ntebk.config$tabNum.e_p1$lineNum -row [expr ($startLine-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wlecde.dataBot.ntebk.config$tabNum.e_p2$lineNum -width 10 -textvariable Lcl_leColMarkYDist($currentTab,$lineNum)
    SetHelpBind .wlecde.dataBot.ntebk.config$tabNum.e_p2$lineNum [::msgcat::mc "inColMarkYDist"]   HelpText_wLECDE
    grid        .wlecde.dataBot.ntebk.config$tabNum.e_p2$lineNum -row [expr ($startLine-1 + $lineNum)] -column 3 -sticky e -pady 1
}
