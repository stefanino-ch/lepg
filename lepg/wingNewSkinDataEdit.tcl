#---------------------------------------------------------------------
#
#  Window to edit the new skin tension (section 31)
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wNESK_DataChanged
set     Lcl_wNESK_DataChanged    0

global  AllGlobalVars_wNESK
set     AllGlobalVars_wNESK { k_section31 numGroupsNS numNewSkin lineNeSk }

#----------------------------------------------------------------------
#  wingSuspensionLinesDataEdit
#  Displays a window to edit the suspension lines data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingNewSkinDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wNESK

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wNESK
    foreach {e} $AllGlobalVars_wNESK {
        global Lcl_$e
    }

    SetLclVars_wNESK

    toplevel .wNESK
    focus .wNESK

    wm protocol .wNESK WM_DELETE_WINDOW { CancelButtonPress_wNESK }

    wm title .wNESK [::msgcat::mc "Section 31: New skin tension configuration"]

    #-------------
    # Frames and grids
    ttk::frame      .wNESK.dataTop
    ttk::frame      .wNESK.dataBot
    ttk::labelframe .wNESK.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wNESK.btn
    #
    grid .wNESK.dataTop         -row 0 -column 0 -sticky w
    grid .wNESK.dataBot         -row 1 -column 0 -sticky w
    grid .wNESK.help            -row 2 -column 0 -sticky e
    grid .wNESK.btn             -row 3 -column 0 -sticky e
    #
    #-------------
    # Spacer for line 1
    label       .wNESK.dataTop.spacer00 -width 5 -text ""
    grid        .wNESK.dataTop.spacer00 -row 1 -column 0

    #-------------
    # Control parameter, entry
    label       .wNESK.dataTop.ctrl1 -width 16 -text [::msgcat::mc "Configuration"]
    grid        .wNESK.dataTop.ctrl1 -row 2 -column 0 -sticky e
    ttk::entry  .wNESK.dataTop.e_ctrl1 -width 10 -textvariable Lcl_k_section31
    SetHelpBind .wNESK.dataTop.e_ctrl1 [::msgcat::mc "section 31 configuration"]   HelpText_wNESK
    grid        .wNESK.dataTop.e_ctrl1 -row 2 -column 1 -sticky w -pady 1


    # Case k_section31 is not 0
    if { $Lcl_k_section31 != 0 } {

    #-------------
    # Control parameter, entry
    label       .wNESK.dataTop.ctrl2 -width 16 -text [::msgcat::mc "Groups"]
    grid        .wNESK.dataTop.ctrl2 -row 3 -column 0 -sticky e
    ttk::entry  .wNESK.dataTop.e_ctrl2 -width 10 -textvariable Lcl_numGroupsNS
    SetHelpBind .wNESK.dataTop.e_ctrl2 [::msgcat::mc "section 31 groups"]   HelpText_wNESK
    grid        .wNESK.dataTop.e_ctrl2 -row 3 -column 1 -sticky w -pady 1


    #-------------
    # Spacer for line 3
#    label       .wNESK.dataTop.spacer10 -width 5 -text ""
#    grid        .wNESK.dataTop.spacer10 -row 4 -column 0

    #-------------
    # Config of configs
    button      .wNESK.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Groups"] -command DecConfigTabs_wNESK -state disabled
    grid        .wNESK.dataTop.b_dec    -row 4 -column 0 -sticky e -padx 3 -pady 3

    button      .wNESK.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Groups"]  -command IncConfigTabs_wNESK
    grid        .wNESK.dataTop.b_inc    -row 4 -column 1 -sticky e -padx 3 -pady 3

    ttk::notebook .wNESK.dataBot.ntebk
    pack .wNESK.dataBot.ntebk -fill both -expand 1
    for { set i 1 } { $i <= $Lcl_numGroupsNS } { incr i } {
        addEditTab_wNESK $i
    }
    UpdateConfigButtons_wNESK

    # Case not 0
    }

    #-------------
    # explanations
    label .wNESK.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wNESK
    grid  .wNESK.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wNESK.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wNESK
    button .wNESK.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wNESK
    button .wNESK.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wNESK
    button .wNESK.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wNESK

    grid .wNESK.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wNESK.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wNESK.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wNESK.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wNESK
}

#----------------------------------------------------------------------
#  SetLclVars_wNESK
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wNESK {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wNESK
    foreach {e} $AllGlobalVars_wNESK {
        global Lcl_$e
    }

    set Lcl_k_section31  $k_section31

    set Lcl_numGroupsNS  $numGroupsNS

    # iterate across all new skin groups
    for { set i 1 } { $i <= $numGroupsNS } { incr i } {
        set Lcl_numNewSkin($i,1)  $numNewSkin($i,1)
        set Lcl_numNewSkin($i,2)  $numNewSkin($i,2)
        set Lcl_numNewSkin($i,3)  $numNewSkin($i,3)
        set Lcl_numNewSkin($i,4)  $numNewSkin($i,4)
        set Lcl_numNewSkin($i,5)  $numNewSkin($i,5)
    } 

    # iterate across all new skin groups
    for { set i 1 } { $i <= $numGroupsNS } { incr i } {
    # iterate across all points of new skin tension
    	for { set j 1 } { $j <= $numNewSkin($i,4) } { incr j } {
        	set Lcl_lineNeSk($i,$j,1)   $lineNeSk($i,$j,1)
        	set Lcl_lineNeSk($i,$j,2)   $lineNeSk($i,$j,2)
        	set Lcl_lineNeSk($i,$j,3)   $lineNeSk($i,$j,3)
        	set Lcl_lineNeSk($i,$j,4)   $lineNeSk($i,$j,4)
        	set Lcl_lineNeSk($i,$j,5)   $lineNeSk($i,$j,5)
       	    }
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wNESK
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wNESK {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wNESK
    foreach {e} $AllGlobalVars_wNESK {
        global Lcl_$e
    }

    set k_section31  $Lcl_k_section31

    set numGroupsNS  $Lcl_numGroupsNS

    # iterate across all new skin groups
    for { set i 1 } { $i <= $Lcl_numGroupsNS } { incr i } {
        set numNewSkin($i,1)  $Lcl_numNewSkin($i,1)
        set numNewSkin($i,2)  $Lcl_numNewSkin($i,2)
        set numNewSkin($i,3)  $Lcl_numNewSkin($i,3)
        set numNewSkin($i,4)  $Lcl_numNewSkin($i,4)
        set numNewSkin($i,5)  $Lcl_numNewSkin($i,5)
        }
    # iterate across all new skin groups
    for { set i 1 } { $i <= $Lcl_numGroupsNS } { incr i } {
        # iterate across all line paths
        for { set j 1 } { $j <= $Lcl_numNewSkin($i,4) } { incr j } {
            # set num of branches and branching level numbers 0
            foreach k {1 2 3 4 5} {
                set lineNeSk($i,$j,$k) $Lcl_lineNeSk($i,$j,$k) 
            }
        }
     }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wNESK
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wNESK {} {
    global g_WingDataChanged
    global Lcl_wNESK_DataChanged

    if { $Lcl_wNESK_DataChanged == 1 } {
        ExportLclVars_wNESK

        set g_WingDataChanged       1
        set Lcl_wNESK_DataChanged    0
    }

    destroy .wNESK
    wingNewSkinDataEdit
}

#----------------------------------------------------------------------
#  OkButtonPress_wNESK
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wNESK {} {
    global .wNESK
    global g_WingDataChanged
    global Lcl_wNESK_DataChanged

    if { $Lcl_wNESK_DataChanged == 1 } {
        ExportLclVars_wNESK
        set g_WingDataChanged       1
        set Lcl_wNESK_DataChanged    0
    }

    UnsetLclVarTrace_wNESK
    destroy .wNESK
}

#----------------------------------------------------------------------
#  CancelButtonPress_wNESK
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wNESK {} {
    global .wNESK
    global g_WingDataChanged
    global Lcl_wNESK_DataChanged

    if { $Lcl_wNESK_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wNESK
            return 0
        }
    }

    set Lcl_wNESK_DataChanged 0
    UnsetLclVarTrace_wNESK
    destroy .wNESK

}

#----------------------------------------------------------------------
#  HelpButtonPress_wNESK
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wNESK {} {
    source "userHelp.tcl"

    displayHelpfile "new-skin-tension-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wNESK
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wNESK {} {

    global AllGlobalVars_wNESK

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wNESK {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wNESK }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wNESK
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wNESK {} {

    global AllGlobalVars_wNESK

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wNESK {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wNESK }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wNESK
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wNESK { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wNESK_DataChanged

    set Lcl_wNESK_DataChanged 1
}

#----------------------------------------------------------------------
#  DecConfigTabs_wNESK
#  Decreases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecConfigTabs_wNESK {} {
    global .wNESK
    global Lcl_numGroupsNS

    destroy .wNESK.dataBot.ntebk.config$Lcl_numGroupsNS

    incr Lcl_numGroupsNS -1

    UpdateConfigButtons_wNESK
}

#----------------------------------------------------------------------
#  IncConfigTabs_wNESK
#  Increases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncConfigTabs_wNESK {} {
    global .wNESK
    global Lcl_numGroupsNS

    incr Lcl_numGroupsNS

    UpdateConfigButtons_wNESK

    # new tab means we must initialize the variables
    CreateInitialConfigVars_wNESK $Lcl_numGroupsNS

    addEditTab_wNESK $Lcl_numGroupsNS
}

#----------------------------------------------------------------------
#  CreateInitialConfigVars_wNESK
#  Creates an initial set of initial variable to display an empty
#  configuration tab
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialConfigVars_wNESK { tabNum_wNESK } {
    global Lcl_numNewSkin

    foreach k {1 2 3 4 5} {
    set Lcl_numNewSkin($tabNum_wNESK,$k) 1
    }

    CreateInitialItemLineVars_wNESK $tabNum_wNESK
}

#----------------------------------------------------------------------
#  UpdateConfigButtons_wNESK
#  Updates the status of the config buttons depending on the number of
#  configs.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateConfigButtons_wNESK {} {
    global .wNESK
    global Lcl_numGroupsNS

    if {$Lcl_numGroupsNS > 1} {
        .wNESK.dataTop.b_dec configure -state normal
    } else {
        .wNESK.dataTop.b_dec configure -state disabled
    }
}

#----------------------------------------------------------------------
#  addEditTab_wNESK
#  Adds all the edit elements needed for one config tab
#
#  IN:      Number of the new tab to be created (1..)
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEditTab_wNESK {tabNum_wNESK} {
    global .wNESK

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wNESK
    foreach {e} $AllGlobalVars_wNESK {
        global Lcl_$e
    }

    # create GUI
    ttk::frame .wNESK.dataBot.ntebk.config$tabNum_wNESK
    .wNESK.dataBot.ntebk add .wNESK.dataBot.ntebk.config$tabNum_wNESK -text [::msgcat::mc "Gr $tabNum_wNESK"]

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.spacer00 -width 5 -text ""
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.spacer00 -row 0 -column 0

    #-------------
    # Config of items
    button      .wNESK.dataBot.ntebk.config$tabNum_wNESK.b_decItems     -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wNESK -state disabled
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.b_decItems    -row 1 -column 1 -sticky e -padx 3 -pady 3

    button      .wNESK.dataBot.ntebk.config$tabNum_wNESK.b_incItems     -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.b_incItems    -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.spacer20 -width 5 -text ""
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.spacer20 -row 2 -column 0


    #-------------
    # header for the for the group configuration

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq1 -width 10 -text [::msgcat::mc "Group"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq1 -row 6 -column 1 -sticky e

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq2 -width 10 -text [::msgcat::mc "Rib ini"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq2 -row 6 -column 2 -sticky e

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq3 -width 10 -text [::msgcat::mc "Rib fin"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq3 -row 6 -column 3 -sticky e

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq4 -width 10 -text [::msgcat::mc "Points"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq4 -row 6 -column 4 -sticky e

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq5 -width 10 -text [::msgcat::mc "Type"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.pq5 -row 6 -column 5 -sticky e

    #-------------
    # entrys for the group configuration
    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq1 -width 10 -textvariable Lcl_numNewSkin($tabNum_wNESK,1)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq1 [::msgcat::mc "lineNeSk_L1"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq1 -row 7 -column 1 -sticky e -pady 1

    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq2 -width 10 -textvariable Lcl_numNewSkin($tabNum_wNESK,2)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq2 [::msgcat::mc "lineNeSk_L2"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq2 -row 7 -column 2 -sticky e -pady 1

    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq3 -width 10 -textvariable Lcl_numNewSkin($tabNum_wNESK,3)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq3 [::msgcat::mc "lineNeSk_L3"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq3 -row 7 -column 3 -sticky e -pady 1

    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq4 -width 10 -textvariable Lcl_numNewSkin($tabNum_wNESK,4)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq4 [::msgcat::mc "lineNeSk_L4"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq4 -row 7 -column 4 -sticky e -pady 1

    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq5 -width 10 -textvariable Lcl_numNewSkin($tabNum_wNESK,5)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq5 [::msgcat::mc "lineNeSk_L5"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.e_pq5 -row 7 -column 5 -sticky e -pady 1


    #-------------
    # header for the item points of skin tension
    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.p1 -width 10 -text [::msgcat::mc "Point"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.p1 -row 9 -column 1 -sticky e

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.p2 -width 10 -text [::msgcat::mc "Pos ext"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.p2 -row 9 -column 2 -sticky e

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.p3 -width 10 -text [::msgcat::mc "Value"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.p3 -row 9 -column 3 -sticky e

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.p4 -width 10 -text [::msgcat::mc "Pos int"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.p4 -row 9 -column 4 -sticky e

    label       .wNESK.dataBot.ntebk.config$tabNum_wNESK.p5 -width 10 -text [::msgcat::mc "Value"]
    grid        .wNESK.dataBot.ntebk.config$tabNum_wNESK.p5 -row 9 -column 5 -sticky e

    for { set i 1 } { $i <= $Lcl_numNewSkin($tabNum_wNESK,4) } { incr i } {
        AddItemLine_wNESK $tabNum_wNESK $i
    }

    UpdateItemLineButtons_wNESK $tabNum_wNESK
}

#----------------------------------------------------------------------
#  DecItemLines_wNESK
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wNESK {} {
    global .wNESK
    global Lcl_numNewSkin

    set currentTab [eval .wNESK.dataBot.ntebk index current]
    incr currentTab

    destroy .wNESK.dataBot.ntebk.config$currentTab.e_p1$Lcl_numNewSkin($currentTab,4)
    destroy .wNESK.dataBot.ntebk.config$currentTab.e_p2$Lcl_numNewSkin($currentTab,4)
    destroy .wNESK.dataBot.ntebk.config$currentTab.e_p3$Lcl_numNewSkin($currentTab,4)
    destroy .wNESK.dataBot.ntebk.config$currentTab.e_p4$Lcl_numNewSkin($currentTab,4)
    destroy .wNESK.dataBot.ntebk.config$currentTab.e_p5$Lcl_numNewSkin($currentTab,4)
    incr Lcl_numNewSkin($currentTab,4) -1

    UpdateItemLineButtons_wNESK 0
}

#----------------------------------------------------------------------
#  IncItemLines_wNESK
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wNESK {} {
    global .wNESK
    global Lcl_numNewSkin

    set currentTab [eval .wNESK.dataBot.ntebk index current]
    incr currentTab

    incr Lcl_numNewSkin($currentTab,4)

    UpdateItemLineButtons_wNESK 0

    # init additional variables
    CreateInitialItemLineVars_wNESK $currentTab

    AddItemLine_wNESK $currentTab $Lcl_numNewSkin($currentTab,4)
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wNESK
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wNESK { tabNum_wNESK } {
    global .wNESK
    global Lcl_numNewSkin
    global Lcl_lineNeSk

    # init additional variables
    foreach i {2 3 4 5} {
        set Lcl_lineNeSk($tabNum_wNESK,$Lcl_numNewSkin($tabNum_wNESK,4),$i) 0.
    }
        set Lcl_lineNeSk($tabNum_wNESK,$Lcl_numNewSkin($tabNum_wNESK,4),1) $Lcl_numNewSkin($tabNum_wNESK,4)
}

#----------------------------------------------------------------------
#  UpdateItemLineButtons_wNESK
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wNESK { tabNum } {
    global .wNESK
    global Lcl_numNewSkin

    if { $tabNum == 0 } {
        set currentTab [eval .wNESK.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    if {$Lcl_numNewSkin($currentTab,4) > 1} {
        .wNESK.dataBot.ntebk.config$currentTab.b_decItems configure -state normal
    } else {
        .wNESK.dataBot.ntebk.config$currentTab.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wNESK
#  Adds an additional Item Line to a tab
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wNESK { tabNum lineNum} {
    global .wNESK
    global Lcl_lineNeSk

    if { $tabNum == 0 } {
        set currentTab [eval .wNESK.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum.e_p1$lineNum -width 10 -textvariable Lcl_lineNeSk($currentTab,$lineNum,1)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum.e_p1$lineNum [::msgcat::mc "lineNeSk_L1"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum.e_p1$lineNum -row [expr (10-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum.e_p2$lineNum -width 10 -textvariable Lcl_lineNeSk($currentTab,$lineNum,2)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum.e_p2$lineNum [::msgcat::mc "lineNeSk_L2"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum.e_p2$lineNum -row [expr (10-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum.e_p3$lineNum -width 10 -textvariable Lcl_lineNeSk($currentTab,$lineNum,3)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum.e_p3$lineNum [::msgcat::mc "lineNeSk_L3"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum.e_p3$lineNum -row [expr (10-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum.e_p4$lineNum -width 10 -textvariable Lcl_lineNeSk($currentTab,$lineNum,4)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum.e_p4$lineNum [::msgcat::mc "lineNeSk_L4"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum.e_p4$lineNum -row [expr (10-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wNESK.dataBot.ntebk.config$tabNum.e_p5$lineNum -width 10 -textvariable Lcl_lineNeSk($currentTab,$lineNum,5)
    SetHelpBind .wNESK.dataBot.ntebk.config$tabNum.e_p5$lineNum [::msgcat::mc "lineNeSk_L5"]   HelpText_wNESK
    grid        .wNESK.dataBot.ntebk.config$tabNum.e_p5$lineNum -row [expr (10-1 + $lineNum)] -column 5 -sticky e -pady 1

}
