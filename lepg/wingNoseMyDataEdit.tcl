#---------------------------------------------------------------------
#
#  Window to edit the nose mylars (section 22)
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
global  Lcl_wNOSEMY_DataChanged
set     Lcl_wNOSEMY_DataChanged    0

global  AllGlobalVars_wNOSEMY
set     AllGlobalVars_wNOSEMY { k_section22 numGroupsMY numNoseMy lineNoseMy }

#----------------------------------------------------------------------
#  wingSuspensionLinesDataEdit
#  Displays a window to edit the suspension lines data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingNoseMyDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wNOSEMY

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wNOSEMY
    foreach {e} $AllGlobalVars_wNOSEMY {
        global Lcl_$e
    }

    SetLclVars_wNOSEMY

    toplevel .wNOSEMY
    focus .wNOSEMY

    wm protocol .wNOSEMY WM_DELETE_WINDOW { CancelButtonPress_wNOSEMY }

    wm title .wNOSEMY [::msgcat::mc "Section 22: Nose mylars configuration"]

    #-------------
    # Frames and grids
    ttk::frame      .wNOSEMY.dataTop
    ttk::frame      .wNOSEMY.dataBot
    ttk::labelframe .wNOSEMY.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wNOSEMY.btn
    #
    grid .wNOSEMY.dataTop         -row 0 -column 0 -sticky w
    grid .wNOSEMY.dataBot         -row 1 -column 0 -sticky w
    grid .wNOSEMY.help            -row 2 -column 0 -sticky e
    grid .wNOSEMY.btn             -row 3 -column 0 -sticky e
    #
    #-------------
    # Spacer for line 1
    label       .wNOSEMY.dataTop.spacer00 -width 5 -text ""
    grid        .wNOSEMY.dataTop.spacer00 -row 1 -column 0

    #-------------
    # Control parameter, entry
    label       .wNOSEMY.dataTop.ctrl1 -width 16 -text [::msgcat::mc "Configuration"]
    grid        .wNOSEMY.dataTop.ctrl1 -row 2 -column 0 -sticky e
    ttk::entry  .wNOSEMY.dataTop.e_ctrl1 -width 10 -textvariable Lcl_k_section22
    SetHelpBind .wNOSEMY.dataTop.e_ctrl1 k_section22   HelpText_wNOSEMY
    grid        .wNOSEMY.dataTop.e_ctrl1 -row 2 -column 1 -sticky w -pady 1

    #-------------
    # Verify not 0
    if { $Lcl_k_section22 != 0 } {
    #-------------
    # Control parameter, entry
    label       .wNOSEMY.dataTop.ctrl2 -width 16 -text [::msgcat::mc "Groups"]
    grid        .wNOSEMY.dataTop.ctrl2 -row 3 -column 0 -sticky e
    ttk::entry  .wNOSEMY.dataTop.e_ctrl2 -width 10 -textvariable Lcl_numGroupsMY
    SetHelpBind .wNOSEMY.dataTop.e_ctrl2 k_section22   HelpText_wNOSEMY
    grid        .wNOSEMY.dataTop.e_ctrl2 -row 3 -column 1 -sticky w -pady 1
    }

    #-------------
    # Spacer for line 3
#    label       .wNOSEMY.dataTop.spacer10 -width 5 -text ""
#    grid        .wNOSEMY.dataTop.spacer10 -row 4 -column 0

    #-------------
    # Config of configs
    button      .wNOSEMY.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Groups"] -command DecConfigTabs_wNOSEMY -state disabled
    grid        .wNOSEMY.dataTop.b_dec    -row 4 -column 0 -sticky e -padx 3 -pady 3

    button      .wNOSEMY.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Groups"]  -command IncConfigTabs_wNOSEMY
    grid        .wNOSEMY.dataTop.b_inc    -row 4 -column 1 -sticky e -padx 3 -pady 3

    ttk::notebook .wNOSEMY.dataBot.ntebk
    pack .wNOSEMY.dataBot.ntebk -fill both -expand 1
    for { set i 1 } { $i <= $Lcl_numGroupsMY } { incr i } {
        addEditTab_wNOSEMY $i
    }
    UpdateConfigButtons_wNOSEMY

    #-------------
    # explanations
    label .wNOSEMY.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wNOSEMY
    grid  .wNOSEMY.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wNOSEMY.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wNOSEMY
    button .wNOSEMY.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wNOSEMY
    button .wNOSEMY.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wNOSEMY
    button .wNOSEMY.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wNOSEMY

    grid .wNOSEMY.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wNOSEMY.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wNOSEMY.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wNOSEMY.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wNOSEMY
}

#----------------------------------------------------------------------
#  SetLclVars_wNOSEMY
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wNOSEMY {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wNOSEMY
    foreach {e} $AllGlobalVars_wNOSEMY {
        global Lcl_$e
    }

    set Lcl_k_section22  $k_section22

    set Lcl_numGroupsMY  $numGroupsMY

    # iterate across all new skin groups
    for { set i 1 } { $i <= $numGroupsMY } { incr i } {
        set Lcl_numNoseMy($i,1)  $numNoseMy($i,1)
        set Lcl_numNoseMy($i,2)  $numNoseMy($i,2)
        set Lcl_numNoseMy($i,3)  $numNoseMy($i,3)
    } 

    # iterate across all new skin groups
    for { set i 1 } { $i <= $numGroupsMY } { incr i } {
    # iterate across all points of new skin tension
        	set Lcl_lineNoseMy($i,1)   $lineNoseMy($i,1)
        	set Lcl_lineNoseMy($i,2)   $lineNoseMy($i,2)
        	set Lcl_lineNoseMy($i,3)   $lineNoseMy($i,3)
        	set Lcl_lineNoseMy($i,4)   $lineNoseMy($i,4)
        	set Lcl_lineNoseMy($i,5)   $lineNoseMy($i,5)
        	set Lcl_lineNoseMy($i,6)   $lineNoseMy($i,6)
       	    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wNOSEMY
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wNOSEMY {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wNOSEMY
    foreach {e} $AllGlobalVars_wNOSEMY {
        global Lcl_$e
    }

    set k_section22  $Lcl_k_section22

    set numGroupsMY  $Lcl_numGroupsMY

    # iterate across all new skin groups
    for { set i 1 } { $i <= $Lcl_numGroupsMY } { incr i } {
        set numNoseMy($i,1)  $Lcl_numNoseMy($i,1)
        set numNoseMy($i,2)  $Lcl_numNoseMy($i,2)
        set numNoseMy($i,3)  $Lcl_numNoseMy($i,3)
        }
    # iterate across all new skin groups
    for { set i 1 } { $i <= $Lcl_numGroupsMY } { incr i } {
            foreach k {1 2 3 4 5 6} {
                set lineNoseMy($i,$k) $Lcl_lineNoseMy($i,$k) 
            }
        }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wNOSEMY
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wNOSEMY {} {
    global g_WingDataChanged
    global Lcl_wNOSEMY_DataChanged

    if { $Lcl_wNOSEMY_DataChanged == 1 } {
        ExportLclVars_wNOSEMY

        set g_WingDataChanged       1
        set Lcl_wNOSEMY_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wNOSEMY
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wNOSEMY {} {
    global .wNOSEMY
    global g_WingDataChanged
    global Lcl_wNOSEMY_DataChanged

    if { $Lcl_wNOSEMY_DataChanged == 1 } {
        ExportLclVars_wNOSEMY
        set g_WingDataChanged       1
        set Lcl_wNOSEMY_DataChanged    0
    }

    UnsetLclVarTrace_wNOSEMY
    destroy .wNOSEMY
}

#----------------------------------------------------------------------
#  CancelButtonPress_wNOSEMY
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wNOSEMY {} {
    global .wNOSEMY
    global g_WingDataChanged
    global Lcl_wNOSEMY_DataChanged

    if { $Lcl_wNOSEMY_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wNOSEMY
            return 0
        }
    }

    set Lcl_wNOSEMY_DataChanged 0
    UnsetLclVarTrace_wNOSEMY
    destroy .wNOSEMY

}

#----------------------------------------------------------------------
#  HelpButtonPress_wNOSEMY
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wNOSEMY {} {
    source "userHelp.tcl"

    displayHelpfile "nose-mylars-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wNOSEMY
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wNOSEMY {} {

    global AllGlobalVars_wNOSEMY

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wNOSEMY {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wNOSEMY }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wNOSEMY
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wNOSEMY {} {

    global AllGlobalVars_wNOSEMY

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wNOSEMY {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wNOSEMY }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wNOSEMY
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wNOSEMY { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wNOSEMY_DataChanged

    set Lcl_wNOSEMY_DataChanged 1
}

#----------------------------------------------------------------------
#  DecConfigTabs_wNOSEMY
#  Decreases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecConfigTabs_wNOSEMY {} {
    global .wNOSEMY
    global Lcl_numGroupsMY

    destroy .wNOSEMY.dataBot.ntebk.config$Lcl_numGroupsMY

    incr Lcl_numGroupsMY -1

    UpdateConfigButtons_wNOSEMY
}

#----------------------------------------------------------------------
#  IncConfigTabs_wNOSEMY
#  Increases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncConfigTabs_wNOSEMY {} {
    global .wNOSEMY
    global Lcl_numGroupsMY

    incr Lcl_numGroupsMY

    UpdateConfigButtons_wNOSEMY

    # new tab means we must initialize the variables
    CreateInitialConfigVars_wNOSEMY $Lcl_numGroupsMY

    addEditTab_wNOSEMY $Lcl_numGroupsMY
}

#----------------------------------------------------------------------
#  CreateInitialConfigVars_wNOSEMY
#  Creates an initial set of initial variable to display an empty
#  configuration tab
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialConfigVars_wNOSEMY { tabNum_wNOSEMY } {
    global Lcl_numNoseMy

    foreach k {1 2 3 4 5} {
    set Lcl_numNoseMy($tabNum_wNOSEMY,$k) 1
    }

    CreateInitialItemLineVars_wNOSEMY $tabNum_wNOSEMY
}

#----------------------------------------------------------------------
#  UpdateConfigButtons_wNOSEMY
#  Updates the status of the config buttons depending on the number of
#  configs.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateConfigButtons_wNOSEMY {} {
    global .wNOSEMY
    global Lcl_numGroupsMY

    if {$Lcl_numGroupsMY > 1} {
        .wNOSEMY.dataTop.b_dec configure -state normal
    } else {
        .wNOSEMY.dataTop.b_dec configure -state disabled
    }
}

#----------------------------------------------------------------------
#  addEditTab_wNOSEMY
#  Adds all the edit elements needed for one config tab
#
#  IN:      Number of the new tab to be created (1..)
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEditTab_wNOSEMY {tabNum_wNOSEMY} {
    global .wNOSEMY

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wNOSEMY
    foreach {e} $AllGlobalVars_wNOSEMY {
        global Lcl_$e
    }

    # create GUI
    ttk::frame .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY
    .wNOSEMY.dataBot.ntebk add .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY -text [::msgcat::mc "Gr $tabNum_wNOSEMY"]

    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.spacer00 -width 5 -text ""
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.spacer00 -row 0 -column 0

    #-------------
    # Config of items
#    button      .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.b_decItems     -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wNOSEMY -state disabled
#    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.b_decItems    -row 1 -column 1 -sticky e -padx 3 -pady 3

#    button      .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.b_incItems     -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wNOSEMY
#    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.b_incItems    -row 1 -column 2 -sticky e -padx 3 -pady 3

#    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.spacer20 -width 5 -text ""
#    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.spacer20 -row 2 -column 0

    #-------------
    # Verify not 0
    if { $Lcl_k_section22 != 0 } {

    #-------------
    # header for the for the group configuration

    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.pq1 -width 10 -text [::msgcat::mc "Group"]
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.pq1 -row 6 -column 1 -sticky e

    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.pq2 -width 10 -text [::msgcat::mc "Rib ini"]
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.pq2 -row 6 -column 2 -sticky e

    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.pq3 -width 10 -text [::msgcat::mc "Rib fin"]
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.pq3 -row 6 -column 3 -sticky e

    #-------------
    # entrys for the group configuration
    ttk::entry  .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.e_pq1 -width 10 -textvariable Lcl_numNoseMy($tabNum_wNOSEMY,1)
    SetHelpBind .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.e_pq1 [::msgcat::mc "Group number"] HelpText_wNOSEMY
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.e_pq1 -row 7 -column 1 -sticky e -pady 1

    ttk::entry  .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.e_pq2 -width 10 -textvariable Lcl_numNoseMy($tabNum_wNOSEMY,2)
    SetHelpBind .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.e_pq2 [::msgcat::mc "Initial rib"] HelpText_wNOSEMY
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.e_pq2 -row 7 -column 2 -sticky e -pady 1

    ttk::entry  .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.e_pq3 -width 10 -textvariable Lcl_numNoseMy($tabNum_wNOSEMY,3)
    SetHelpBind .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.e_pq3 [::msgcat::mc "Final rib"] HelpText_wNOSEMY
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.e_pq3 -row 7 -column 3 -sticky e -pady 1

    #-------------
    # header for the item points of mylars
    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p1 -width 10 -text "x1"
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p1 -row 9 -column 1 -sticky e

    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p2 -width 10 -text "u1"
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p2 -row 9 -column 2 -sticky e

    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p3 -width 10 -text "u2"
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p3 -row 9 -column 3 -sticky e

    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p4 -width 10 -text "x2"
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p4 -row 9 -column 4 -sticky e

    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p5 -width 10 -text "v1"
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p5 -row 9 -column 5 -sticky e

    label       .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p6 -width 10 -text "v2"
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum_wNOSEMY.p6 -row 9 -column 6 -sticky e


#    for { set i 1 } { $i <= $Lcl_numNoseMy($tabNum_wNOSEMY,4) } { incr i } {
         AddItemLine_wNOSEMY $tabNum_wNOSEMY 1
#    }

#    UpdateItemLineButtons_wNOSEMY $tabNum_wNOSEMY

     # end verification not zero
     }

}

#----------------------------------------------------------------------
#  DecItemLines_wNOSEMY
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wNOSEMY {} {
    global .wNOSEMY
    global Lcl_numNoseMy

    set currentTab [eval .wNOSEMY.dataBot.ntebk index current]
    incr currentTab

    destroy .wNOSEMY.dataBot.ntebk.config$currentTab.e_p1$Lcl_numNoseMy($currentTab,4)
    destroy .wNOSEMY.dataBot.ntebk.config$currentTab.e_p2$Lcl_numNoseMy($currentTab,4)
    destroy .wNOSEMY.dataBot.ntebk.config$currentTab.e_p3$Lcl_numNoseMy($currentTab,4)
    destroy .wNOSEMY.dataBot.ntebk.config$currentTab.e_p4$Lcl_numNoseMy($currentTab,4)
    destroy .wNOSEMY.dataBot.ntebk.config$currentTab.e_p5$Lcl_numNoseMy($currentTab,4)
    incr Lcl_numNoseMy($currentTab,4) -1

    UpdateItemLineButtons_wNOSEMY 0
}

#----------------------------------------------------------------------
#  IncItemLines_wNOSEMY
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wNOSEMY {} {
    global .wNOSEMY
    global Lcl_numNoseMy

    set currentTab [eval .wNOSEMY.dataBot.ntebk index current]
    incr currentTab

    incr Lcl_numNoseMy($currentTab,4)

    UpdateItemLineButtons_wNOSEMY 0

    # init additional variables
    CreateInitialItemLineVars_wNOSEMY $currentTab

    AddItemLine_wNOSEMY $currentTab $Lcl_numNoseMy($currentTab,4)
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wNOSEMY
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wNOSEMY { tabNum_wNOSEMY } {
    global .wNOSEMY
    global Lcl_numNoseMy
    global Lcl_lineNoseMy

    # init additional variables
    foreach i {1 2 3 4 5 6} {
        set Lcl_lineNoseMy($tabNum_wNOSEMY,$i) 0.
    }
}

#----------------------------------------------------------------------
#  UpdateItemLineButtons_wNOSEMY
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wNOSEMY { tabNum } {
    global .wNOSEMY
    global Lcl_numNoseMy

    if { $tabNum == 0 } {
        set currentTab [eval .wNOSEMY.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    if {$Lcl_numNoseMy($currentTab,4) > 1} {
        .wNOSEMY.dataBot.ntebk.config$currentTab.b_decItems configure -state normal
    } else {
        .wNOSEMY.dataBot.ntebk.config$currentTab.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wNOSEMY
#  Adds an additional Item Line to a tab
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wNOSEMY { tabNum lineNum} {
    global .wNOSEMY
    global Lcl_lineNoseMy

    if { $tabNum == 0 } {
        set currentTab [eval .wNOSEMY.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    ttk::entry  .wNOSEMY.dataBot.ntebk.config$tabNum.e_p1$lineNum -width 10 -textvariable Lcl_lineNoseMy($currentTab,1)
    SetHelpBind .wNOSEMY.dataBot.ntebk.config$tabNum.e_p1$lineNum parameter_x1   HelpText_wNOSEMY
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum.e_p1$lineNum -row [expr (10-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wNOSEMY.dataBot.ntebk.config$tabNum.e_p2$lineNum -width 10 -textvariable Lcl_lineNoseMy($currentTab,2)
    SetHelpBind .wNOSEMY.dataBot.ntebk.config$tabNum.e_p2$lineNum parameter_u1   HelpText_wNOSEMY
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum.e_p2$lineNum -row [expr (10-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wNOSEMY.dataBot.ntebk.config$tabNum.e_p3$lineNum -width 10 -textvariable Lcl_lineNoseMy($currentTab,3)
    SetHelpBind .wNOSEMY.dataBot.ntebk.config$tabNum.e_p3$lineNum parameter_u2   HelpText_wNOSEMY
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum.e_p3$lineNum -row [expr (10-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wNOSEMY.dataBot.ntebk.config$tabNum.e_p4$lineNum -width 10 -textvariable Lcl_lineNoseMy($currentTab,4)
    SetHelpBind .wNOSEMY.dataBot.ntebk.config$tabNum.e_p4$lineNum parameter_x2   HelpText_wNOSEMY
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum.e_p4$lineNum -row [expr (10-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wNOSEMY.dataBot.ntebk.config$tabNum.e_p5$lineNum -width 10 -textvariable Lcl_lineNoseMy($currentTab,5)
    SetHelpBind .wNOSEMY.dataBot.ntebk.config$tabNum.e_p5$lineNum parameter_v1   HelpText_wNOSEMY
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum.e_p5$lineNum -row [expr (10-1 + $lineNum)] -column 5 -sticky e -pady 1

    ttk::entry  .wNOSEMY.dataBot.ntebk.config$tabNum.e_p6$lineNum -width 10 -textvariable Lcl_lineNoseMy($currentTab,6)
    SetHelpBind .wNOSEMY.dataBot.ntebk.config$tabNum.e_p6$lineNum parameter_v2   HelpText_wNOSEMY
    grid        .wNOSEMY.dataBot.ntebk.config$tabNum.e_p6$lineNum -row [expr (10-1 + $lineNum)] -column 6 -sticky e -pady 1

}
