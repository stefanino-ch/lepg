#---------------------------------------------------------------------
#
#  Window to edit the extrados color settings
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
global  Lcl_wTECDE_DataChanged
set     Lcl_wTECDE_DataChanged    0

global  AllGlobalVars_wTECDE
set     AllGlobalVars_wTECDE { numTeCol teColRibNum numTeColMarks teColMarkNum teColMarkYDist teColMarkXDist  }

#----------------------------------------------------------------------
#  wingTrailingEdgeColorsDataEdit
#  Displays a window to edit the wing trailing edge color settings
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingTrailingEdgeColorsDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wtecde

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wTECDE
    foreach {e} $AllGlobalVars_wTECDE {
        global Lcl_$e
    }

    SetLclVars_wTECDE

    toplevel .wtecde
    focus .wtecde

    wm protocol .wtecde WM_DELETE_WINDOW { CancelButtonPress_wTECDE }

    wm title .wtecde [::msgcat::mc "Section 15: Upper surface color marks"]

    #-------------
    # Frames and grids
    ttk::frame      .wtecde.dataTop
    ttk::frame      .wtecde.dataBot
    ttk::labelframe .wtecde.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wtecde.btn
    #
    grid .wtecde.dataTop         -row 0 -column 0 -sticky w
    grid .wtecde.dataBot         -row 1 -column 0 -sticky w
    grid .wtecde.help         -row 2 -column 0 -sticky e
    grid .wtecde.btn          -row 3 -column 0 -sticky e
    #

    label       .wtecde.dataTop.numc -width 20 -text [::msgcat::mc "Configuration"]
    grid        .wtecde.dataTop.numc -row 0 -column 1
    ttk::entry  .wtecde.dataTop.e_numc -width 20 -textvariable Lcl_numTeCol
    SetHelpBind .wtecde.dataTop.e_numc [::msgcat::mc "Configuration"] HelpText_wTECDE
    grid        .wtecde.dataTop.e_numc -row 0 -column 2 -sticky e -pady 1


    # Print data only if number of configurations is not 0
    if { $Lcl_numTeCol != 0 } {

    #-------------
    # Config of configs
    button      .wtecde.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Configs"] -command DecConfigTabs_wTECDE -state disabled
    grid        .wtecde.dataTop.b_dec    -row 1 -column 0 -sticky e -padx 3 -pady 3

    button      .wtecde.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Configs"]  -command IncConfigTabs_wTECDE
    grid        .wtecde.dataTop.b_inc    -row 1 -column 1 -sticky e -padx 3 -pady 3

    ttk::notebook .wtecde.dataBot.ntebk
    pack .wtecde.dataBot.ntebk -fill both -expand 1
    for { set i 1 } { $i <= $Lcl_numTeCol } { incr i } {
        addEditTab_wTECDE $i
    }
    UpdateConfigButtons_wTECDE

    # End case not 0
    }


    #-------------
    # explanations
    label .wtecde.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wTECDE
    grid  .wtecde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wtecde.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wTECDE
    button .wtecde.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wTECDE
    button .wtecde.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wTECDE
    button .wtecde.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wTECDE

    grid .wtecde.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wtecde.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wtecde.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wtecde.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wTECDE
}

#----------------------------------------------------------------------
#  SetLclVars_wTECDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wTECDE {} {
    source "globalWingVars.tcl"

    #

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wTECDE
    foreach {e} $AllGlobalVars_wTECDE {
        global Lcl_$e
    }

    set Lcl_numTeCol  $numTeCol

    for { set i 1 } { $i <= $numTeCol } { incr i } {
        set Lcl_teColRibNum($i) $teColRibNum($i)
        set Lcl_numTeColMarks($i) $numTeColMarks($i)
    }

    for { set i 1 } { $i <= $numTeCol } { incr i } {
        for { set j 1 } { $j <= $numTeColMarks($i) } { incr j } {
            set Lcl_teColMarkNum($i,$j)     $teColMarkNum($i,$j)
            set Lcl_teColMarkYDist($i,$j)   $teColMarkYDist($i,$j)
            set Lcl_teColMarkXDist($i,$j)   $teColMarkXDist($i,$j)
        }
    }

}

#----------------------------------------------------------------------
#  ExportLclVars_wTECDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wTECDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wTECDE
    foreach {e} $AllGlobalVars_wTECDE {
        global Lcl_$e
    }

    set numTeCol  $Lcl_numTeCol

    for { set i 1 } { $i <= $Lcl_numTeCol } { incr i } {
        set teColRibNum($i) $Lcl_teColRibNum($i)
        set numTeColMarks($i) $Lcl_numTeColMarks($i)
    }

    for { set i 1 } { $i <= $Lcl_numTeCol } { incr i } {
        for { set j 1 } { $j <= $Lcl_numTeColMarks($i) } { incr j } {
            set teColMarkNum($i,$j)     $Lcl_teColMarkNum($i,$j)
            set teColMarkYDist($i,$j)   $Lcl_teColMarkYDist($i,$j)
            set teColMarkXDist($i,$j)   $Lcl_teColMarkXDist($i,$j)
        }
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wTECDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wTECDE {} {
    global g_WingDataChanged
    global Lcl_wTECDE_DataChanged

    if { $Lcl_wTECDE_DataChanged == 1 } {
        ExportLclVars_wTECDE

        set g_WingDataChanged       1
        set Lcl_wTECDE_DataChanged    0
    }

    # Update configurations erasing main window
    destroy .wtecde
    wingTrailingEdgeColorsDataEdit
}

#----------------------------------------------------------------------
#  OkButtonPress_wTECDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wTECDE {} {
    global .wtecde
    global g_WingDataChanged
    global Lcl_wTECDE_DataChanged

    if { $Lcl_wTECDE_DataChanged == 1 } {
        ExportLclVars_wTECDE
        set g_WingDataChanged       1
        set Lcl_wTECDE_DataChanged    0
    }

    UnsetLclVarTrace_wTECDE
    destroy .wtecde
}

#----------------------------------------------------------------------
#  CancelButtonPress_wTECDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wTECDE {} {
    global .wtecde
    global g_WingDataChanged
    global Lcl_wTECDE_DataChanged

    if { $Lcl_wTECDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wtecde
            return 0
        }
    }

    set Lcl_wTECDE_DataChanged 0
    UnsetLclVarTrace_wTECDE
    destroy .wtecde

}

#----------------------------------------------------------------------
#  HelpButtonPress_wTECDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wTECDE {} {
    source "userHelp.tcl"

    displayHelpfile "te-colors-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wTECDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wTECDE {} {

    global AllGlobalVars_wTECDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wTECDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wTECDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wTECDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wTECDE {} {

    global AllGlobalVars_wTECDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wTECDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wTECDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wTECDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wTECDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wTECDE_DataChanged

    set Lcl_wTECDE_DataChanged 1
}

#----------------------------------------------------------------------
#  DecConfigTabs_wTECDE
#  Decreases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecConfigTabs_wTECDE {} {
    global .wtecde
    global Lcl_numTeCol

    destroy .wtecde.dataBot.ntebk.config$Lcl_numTeCol

    incr Lcl_numTeCol -1

    UpdateConfigButtons_wTECDE
}

#----------------------------------------------------------------------
#  IncConfigTabs_wTECDE
#  Increases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncConfigTabs_wTECDE {} {
    global .wtecde
    global Lcl_numTeCol

    incr Lcl_numTeCol

    UpdateConfigButtons_wTECDE

    # new tab means we must initialize the variables
    CreateInitialConfigVars_wTECDE $Lcl_numTeCol

    addEditTab_wTECDE $Lcl_numTeCol
}

#----------------------------------------------------------------------
#  CreateInitialConfigVars_wTECDE
#  Creates an initial set of initial variable to display an empty
#  configuration tab
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialConfigVars_wTECDE { tabNum_wTECDE } {
    global Lcl_teColRibNum
    global Lcl_numTeColMarks

    # new tab means we must initialize the variables
    set Lcl_teColRibNum($tabNum_wTECDE) "1"
    set Lcl_numTeColMarks($tabNum_wTECDE) 1

    CreateInitialItemLineVars_wTECDE $tabNum_wTECDE
}

#----------------------------------------------------------------------
#  UpdateConfigButtons_wTECDE
#  Updates the status of the config buttons depending on the number of
#  configs.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateConfigButtons_wTECDE {} {
    global .wtecde
    global Lcl_numTeCol

    if {$Lcl_numTeCol > 1} {
        .wtecde.dataTop.b_dec configure -state normal
    } else {
        .wtecde.dataTop.b_dec configure -state disabled
    }
}

#----------------------------------------------------------------------
#  addEditTab_wTECDE
#  Adds all the edit elements needed for one config tab
#
#  IN:      Number of the new tab to be created (1..)
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEditTab_wTECDE {tabNum_wTECDE} {
    global .wtecde

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wTECDE
    foreach {e} $AllGlobalVars_wTECDE {
        global Lcl_$e
    }

    # create GUI
    ttk::frame .wtecde.dataBot.ntebk.config$tabNum_wTECDE
    .wtecde.dataBot.ntebk add .wtecde.dataBot.ntebk.config$tabNum_wTECDE -text [::msgcat::mc "Config $tabNum_wTECDE"]

    label       .wtecde.dataBot.ntebk.config$tabNum_wTECDE.spacer1 -width 5 -text ""
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.spacer1 -row 0 -column 0

    label       .wtecde.dataBot.ntebk.config$tabNum_wTECDE.firstRib -width 16 -text [::msgcat::mc "Rib for config"]
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.firstRib -row 0 -column 1
    ttk::entry  .wtecde.dataBot.ntebk.config$tabNum_wTECDE.e_firstRib -width 10 -textvariable Lcl_teColRibNum($tabNum_wTECDE)
    SetHelpBind .wtecde.dataBot.ntebk.config$tabNum_wTECDE.e_firstRib [::msgcat::mc "exColRibNum"]   HelpText_wTECDE
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.e_firstRib -row 0 -column 2 -sticky e -pady 1

    label       .wtecde.dataBot.ntebk.config$tabNum_wTECDE.spacer2 -width 5 -text ""
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.spacer2 -row 1 -column 0

    #-------------
    # Config of items
    button      .wtecde.dataBot.ntebk.config$tabNum_wTECDE.b_decItems     -width 10 -text [::msgcat::mc "dec Items"] -command DecItemLines_wTECDE -state disabled
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.b_decItems    -row 2 -column 1 -sticky e -padx 3 -pady 3

    button      .wtecde.dataBot.ntebk.config$tabNum_wTECDE.b_incItems     -width 10 -text [::msgcat::mc "inc Items"]  -command IncItemLines_wTECDE
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.b_incItems    -row 2 -column 2 -sticky e -padx 3 -pady 3

    label       .wtecde.dataBot.ntebk.config$tabNum_wTECDE.spacer3 -width 5 -text ""
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.spacer3 -row 3 -column 0

    #-------------
    # header for the item lines
    label       .wtecde.dataBot.ntebk.config$tabNum_wTECDE.n -width 10 -text [::msgcat::mc "Num"]
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.n -row 4 -column 1 -sticky e

    label       .wtecde.dataBot.ntebk.config$tabNum_wTECDE.p2 -width 10 -text [::msgcat::mc "hor dist"]
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.p2 -row 4 -column 2 -sticky e

    label       .wtecde.dataBot.ntebk.config$tabNum_wTECDE.p3 -width 10 -text [::msgcat::mc "ver dist"]
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.p3 -row 4 -column 3 -sticky e

    label       .wtecde.dataBot.ntebk.config$tabNum_wTECDE.spacer4 -width 5 -text ""
    grid        .wtecde.dataBot.ntebk.config$tabNum_wTECDE.spacer4 -row 4 -column 4

    for { set i 1 } { $i <= $Lcl_numTeColMarks($tabNum_wTECDE) } { incr i } {
        AddItemLine_wTECDE $tabNum_wTECDE $i
    }

    UpdateItemLineButtons_wTECDE $tabNum_wTECDE
}

#----------------------------------------------------------------------
#  DecItemLines_wTECDE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wTECDE {} {
    global .wtecde
    global Lcl_numTeColMarks

    set currentTab [eval .wtecde.dataBot.ntebk index current]
    incr currentTab

    destroy .wtecde.dataBot.ntebk.config$currentTab.n$Lcl_numTeColMarks($currentTab)
    destroy .wtecde.dataBot.ntebk.config$currentTab.e_p1$Lcl_numTeColMarks($currentTab)
    destroy .wtecde.dataBot.ntebk.config$currentTab.e_p2$Lcl_numTeColMarks($currentTab)

    incr Lcl_numTeColMarks($currentTab) -1

    UpdateItemLineButtons_wTECDE 0
}

#----------------------------------------------------------------------
#  IncItemLines_wTECDE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wTECDE {} {
    global .wtecde
    global Lcl_numTeColMarks

    set currentTab [eval .wtecde.dataBot.ntebk index current]
    incr currentTab

    incr Lcl_numTeColMarks($currentTab)

    UpdateItemLineButtons_wTECDE 0

    # init additional variables
    CreateInitialItemLineVars_wTECDE $currentTab

    AddItemLine_wTECDE $currentTab $Lcl_numTeColMarks($currentTab)
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wTECDE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wTECDE { tabNum_wTECDE } {
    global .wtecde
    global Lcl_numTeColMarks
    global Lcl_teColMarkNum
    global Lcl_teColMarkXDist
    global Lcl_teColMarkYDist

    set Lcl_teColMarkNum($tabNum_wTECDE,$Lcl_numTeColMarks($tabNum_wTECDE)) $Lcl_numTeColMarks($tabNum_wTECDE)
    set Lcl_teColMarkXDist($tabNum_wTECDE,$Lcl_numTeColMarks($tabNum_wTECDE)) 0.
    set Lcl_teColMarkYDist($tabNum_wTECDE,$Lcl_numTeColMarks($tabNum_wTECDE)) 0.
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wTECDE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wTECDE { tabNum } {
    global .wtecde
    global Lcl_numTeColMarks

    if { $tabNum == 0 } {
        set currentTab [eval .wtecde.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    if {$Lcl_numTeColMarks($currentTab) > 1} {
        .wtecde.dataBot.ntebk.config$currentTab.b_decItems configure -state normal
    } else {
        .wtecde.dataBot.ntebk.config$currentTab.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wTECDE
#  Adds an additional Item Line to a tab
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wTECDE { tabNum lineNum} {
    global .wtecde
    global Lcl_teColMarkXDist
    global Lcl_teColMarkYDist

    if { $tabNum == 0 } {
        set currentTab [eval .wtecde.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    set startLine 5

    label       .wtecde.dataBot.ntebk.config$tabNum.n$lineNum -width 15 -text "$lineNum"
    grid        .wtecde.dataBot.ntebk.config$tabNum.n$lineNum -row [expr ($startLine-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wtecde.dataBot.ntebk.config$tabNum.e_p1$lineNum -width 10 -textvariable Lcl_teColMarkXDist($currentTab,$lineNum)
    SetHelpBind .wtecde.dataBot.ntebk.config$tabNum.e_p1$lineNum [::msgcat::mc "exColMarkXDist"]   HelpText_wTECDE
    grid        .wtecde.dataBot.ntebk.config$tabNum.e_p1$lineNum -row [expr ($startLine-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wtecde.dataBot.ntebk.config$tabNum.e_p2$lineNum -width 10 -textvariable Lcl_teColMarkYDist($currentTab,$lineNum)
    SetHelpBind .wtecde.dataBot.ntebk.config$tabNum.e_p2$lineNum [::msgcat::mc "exColMarkYDist"]   HelpText_wTECDE
    grid        .wtecde.dataBot.ntebk.config$tabNum.e_p2$lineNum -row [expr ($startLine-1 + $lineNum)] -column 3 -sticky e -pady 1
}
