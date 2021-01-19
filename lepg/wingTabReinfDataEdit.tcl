#---------------------------------------------------------------------
#
#  Window to edit the tab reinforcements (section 23)
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
global  Lcl_wTABREINF_DataChanged
set     Lcl_wTABREINF_DataChanged    0

global  AllGlobalVars_wTABREINF
set     AllGlobalVars_wTABREINF { k_section23 numGroupsTR numTabReinf lineTabReinf schemesTR}

#----------------------------------------------------------------------
#  wingSuspensionLinesDataEdit
#  Displays a window to edit the suspension lines data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingTabReinfDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wTABREINF

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wTABREINF
    foreach {e} $AllGlobalVars_wTABREINF {
        global Lcl_$e
    }

    SetLclVars_wTABREINF

    toplevel .wTABREINF
    focus .wTABREINF

    wm protocol .wTABREINF WM_DELETE_WINDOW { CancelButtonPress_wTABREINF }

    wm title .wTABREINF [::msgcat::mc "Section 23: Tab reinforcements configuration"]

    #-------------
    # Frames and grids
    ttk::frame      .wTABREINF.dataTop
    ttk::frame      .wTABREINF.dataBot
    ttk::frame      .wTABREINF.dataInf
    ttk::labelframe .wTABREINF.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wTABREINF.btn
    #
    grid .wTABREINF.dataTop         -row 0 -column 0 -sticky w
    grid .wTABREINF.dataBot         -row 1 -column 0 -sticky w
    grid .wTABREINF.dataInf         -row 2 -column 0 -sticky w
    grid .wTABREINF.help            -row 3 -column 0 -sticky e
    grid .wTABREINF.btn             -row 4 -column 0 -sticky e
    #
    #-------------
    # Spacer for line 1
    label       .wTABREINF.dataTop.spacer00 -width 5 -text ""
    grid        .wTABREINF.dataTop.spacer00 -row 1 -column 0

    #-------------
    # Control parameter, entry
    label       .wTABREINF.dataTop.ctrl1 -width 16 -text [::msgcat::mc "Configuration"]
    grid        .wTABREINF.dataTop.ctrl1 -row 2 -column 0 -sticky e
    ttk::entry  .wTABREINF.dataTop.e_ctrl1 -width 10 -textvariable Lcl_k_section23
    SetHelpBind .wTABREINF.dataTop.e_ctrl1 k_section23   HelpText_wTABREINF
    grid        .wTABREINF.dataTop.e_ctrl1 -row 2 -column 1 -sticky w -pady 1

    #-------------
    # Control parameter, entry
    label       .wTABREINF.dataTop.ctrl2 -width 16 -text [::msgcat::mc "Groups"]
    grid        .wTABREINF.dataTop.ctrl2 -row 3 -column 0 -sticky e
    ttk::entry  .wTABREINF.dataTop.e_ctrl2 -width 10 -textvariable Lcl_numGroupsTR
    SetHelpBind .wTABREINF.dataTop.e_ctrl2 k_section23   HelpText_wTABREINF
    grid        .wTABREINF.dataTop.e_ctrl2 -row 3 -column 1 -sticky w -pady 1

    #-------------
    # Schemes .wTABREINF.dataSchemes

    #-------------
    # Spacer for line 6
    label       .wTABREINF.dataInf.spacer03 -width 5 -text ""
    grid        .wTABREINF.dataInf.spacer03 -row 6 -column 0

    #-------------
    # Schemes header
    label       .wTABREINF.dataInf.u1 -width 10 -text [::msgcat::mc "Schemes"]
    grid        .wTABREINF.dataInf.u1 -row 7 -column 1 -sticky e

    label       .wTABREINF.dataInf.u2 -width 10 -text [::msgcat::mc "0/1"]
    grid        .wTABREINF.dataInf.u2 -row 7 -column 2 -sticky e

    label       .wTABREINF.dataInf.u3 -width 10 -text [::msgcat::mc "p1"]
    grid        .wTABREINF.dataInf.u3 -row 7 -column 3 -sticky e

    label       .wTABREINF.dataInf.u4 -width 10 -text [::msgcat::mc "p2"]
    grid        .wTABREINF.dataInf.u4 -row 7 -column 4 -sticky e

    label       .wTABREINF.dataInf.u5 -width 10 -text [::msgcat::mc "p3"]
    grid        .wTABREINF.dataInf.u5 -row 7 -column 5 -sticky e

    label       .wTABREINF.dataInf.u6 -width 10 -text [::msgcat::mc "p4"]
    grid        .wTABREINF.dataInf.u6 -row 7 -column 6 -sticky e

    label       .wTABREINF.dataInf.u7 -width 10 -text [::msgcat::mc "p5"]
    grid        .wTABREINF.dataInf.u7 -row 7 -column 7 -sticky e

    #-------------
    # Schemes data
    foreach i { 1 2 3 4 5 } {
    ttk::entry  .wTABREINF.dataInf.e_u1$i -width 10 -textvariable Lcl_schemesTR($i,1)
    SetHelpBind .wTABREINF.dataInf.e_u1$i [::msgcat::mc "Scheme type"] HelpText_wTABREINF
    grid        .wTABREINF.dataInf.e_u1$i -row [expr (8-1 + $i)] -column 1 -sticky w -pady 1

    ttk::entry  .wTABREINF.dataInf.e_u2$i -width 10 -textvariable Lcl_schemesTR($i,2)
    SetHelpBind .wTABREINF.dataInf.e_u2$i [::msgcat::mc "parameter 0 means use units in percent of chord \nparameter 1 means use absolute units in cm"] HelpText_wTABREINF
    grid        .wTABREINF.dataInf.e_u2$i -row [expr (8-1 + $i)] -column 2 -sticky w -pady 1

    ttk::entry  .wTABREINF.dataInf.e_u3$i -width 10 -textvariable Lcl_schemesTR($i,3)
    SetHelpBind .wTABREINF.dataInf.e_u3$i [::msgcat::mc "Geometric parameter according to scheme"] HelpText_wTABREINF
    grid        .wTABREINF.dataInf.e_u3$i -row [expr (8-1 + $i)] -column 3 -sticky w -pady 1

    ttk::entry  .wTABREINF.dataInf.e_u4$i -width 10 -textvariable Lcl_schemesTR($i,4)
    SetHelpBind .wTABREINF.dataInf.e_u4$i [::msgcat::mc "Geometric parameter according to scheme"] HelpText_wTABREINF
    grid        .wTABREINF.dataInf.e_u4$i -row [expr (8-1 + $i)] -column 4 -sticky w -pady 1

    ttk::entry  .wTABREINF.dataInf.e_u5$i -width 10 -textvariable Lcl_schemesTR($i,5)
    SetHelpBind .wTABREINF.dataInf.e_u5$i [::msgcat::mc "Geometric parameter according to scheme"] HelpText_wTABREINF
    grid        .wTABREINF.dataInf.e_u5$i -row [expr (8-1 + $i)] -column 5 -sticky w -pady 1

    ttk::entry  .wTABREINF.dataInf.e_u6$i -width 10 -textvariable Lcl_schemesTR($i,6)
    SetHelpBind .wTABREINF.dataInf.e_u6$i [::msgcat::mc "Geometric parameter according to scheme"] HelpText_wTABREINF
    grid        .wTABREINF.dataInf.e_u6$i -row [expr (8-1 + $i)] -column 6 -sticky w -pady 1

    ttk::entry  .wTABREINF.dataInf.e_u7$i -width 10 -textvariable Lcl_schemesTR($i,7)
    SetHelpBind .wTABREINF.dataInf.e_u7$i [::msgcat::mc "Geometric parameter according to scheme"] HelpText_wTABREINF
    grid        .wTABREINF.dataInf.e_u7$i -row [expr (8-1 + $i)] -column 7 -sticky w -pady 1

    }

    #-------------
    # Spacer for line 3
#    label       .wTABREINF.dataTop.spacer10 -width 5 -text ""
#    grid        .wTABREINF.dataTop.spacer10 -row 4 -column 0

    #-------------
    # Config of configs
    button      .wTABREINF.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Groups"] -command DecConfigTabs_wTABREINF -state disabled
    grid        .wTABREINF.dataTop.b_dec    -row 4 -column 0 -sticky e -padx 3 -pady 3

    button      .wTABREINF.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Groups"]  -command IncConfigTabs_wTABREINF
    grid        .wTABREINF.dataTop.b_inc    -row 4 -column 1 -sticky e -padx 3 -pady 3

    ttk::notebook .wTABREINF.dataBot.ntebk
    pack .wTABREINF.dataBot.ntebk -fill both -expand 1
    for { set i 1 } { $i <= $Lcl_numGroupsTR } { incr i } {
        addEditTab_wTABREINF $i
    }
    UpdateConfigButtons_wTABREINF

    #-------------
    # explanations
    label .wTABREINF.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wTABREINF
    grid  .wTABREINF.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wTABREINF.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wTABREINF
    button .wTABREINF.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wTABREINF
    button .wTABREINF.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wTABREINF
    button .wTABREINF.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wTABREINF

    grid .wTABREINF.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wTABREINF.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wTABREINF.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wTABREINF.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wTABREINF
}

#----------------------------------------------------------------------
#  SetLclVars_wTABREINF
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wTABREINF {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wTABREINF
    foreach {e} $AllGlobalVars_wTABREINF {
        global Lcl_$e
    }

    set Lcl_k_section23  $k_section23

    set Lcl_numGroupsTR  $numGroupsTR

    # iterate across all new skin groups
    for { set i 1 } { $i <= $numGroupsTR } { incr i } {
        set Lcl_numTabReinf($i,1)  $numTabReinf($i,1)
        set Lcl_numTabReinf($i,2)  $numTabReinf($i,2)
        set Lcl_numTabReinf($i,3)  $numTabReinf($i,3)
    } 

    # iterate across all new skin groups
    for { set i 1 } { $i <= $numGroupsTR } { incr i } {
    # iterate across all points of new skin tension
        	set Lcl_lineTabReinf($i,1)   $lineTabReinf($i,1)
        	set Lcl_lineTabReinf($i,2)   $lineTabReinf($i,2)
        	set Lcl_lineTabReinf($i,3)   $lineTabReinf($i,3)
        	set Lcl_lineTabReinf($i,4)   $lineTabReinf($i,4)
        	set Lcl_lineTabReinf($i,5)   $lineTabReinf($i,5)
       	    }

     # schemes TR
     foreach i {1 2 3 4 5} {
     foreach j {1 2 3 4 5 6 7} {
     set Lcl_schemesTR($i,$j) $schemesTR($i,$j)
     }
     }
}

#----------------------------------------------------------------------
#  ExportLclVars_wTABREINF
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wTABREINF {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wTABREINF
    foreach {e} $AllGlobalVars_wTABREINF {
        global Lcl_$e
    }

    set k_section23  $Lcl_k_section23

    set numGroupsTR  $Lcl_numGroupsTR

    # iterate across all new skin groups
    for { set i 1 } { $i <= $Lcl_numGroupsTR } { incr i } {
        set numTabReinf($i,1)  $Lcl_numTabReinf($i,1)
        set numTabReinf($i,2)  $Lcl_numTabReinf($i,2)
        set numTabReinf($i,3)  $Lcl_numTabReinf($i,3)
        }
    # iterate across all new skin groups
    for { set i 1 } { $i <= $Lcl_numGroupsTR } { incr i } {
            foreach k {1 2 3 4 5} {
                set lineTabReinf($i,$k) $Lcl_lineTabReinf($i,$k) 
            }
        }

     # schemes TR
     foreach i {1 2 3 4 5} {
     foreach j {1 2 3 4 5 6 7} {
     set schemesTR($i,$j) $Lcl_schemesTR($i,$j)
     }
     }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wTABREINF
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wTABREINF {} {
    global g_WingDataChanged
    global Lcl_wTABREINF_DataChanged

    if { $Lcl_wTABREINF_DataChanged == 1 } {
        ExportLclVars_wTABREINF

        set g_WingDataChanged       1
        set Lcl_wTABREINF_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wTABREINF
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wTABREINF {} {
    global .wTABREINF
    global g_WingDataChanged
    global Lcl_wTABREINF_DataChanged

    if { $Lcl_wTABREINF_DataChanged == 1 } {
        ExportLclVars_wTABREINF
        set g_WingDataChanged       1
        set Lcl_wTABREINF_DataChanged    0
    }

    UnsetLclVarTrace_wTABREINF
    destroy .wTABREINF
}

#----------------------------------------------------------------------
#  CancelButtonPress_wTABREINF
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wTABREINF {} {
    global .wTABREINF
    global g_WingDataChanged
    global Lcl_wTABREINF_DataChanged

    if { $Lcl_wTABREINF_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wTABREINF
            return 0
        }
    }

    set Lcl_wTABREINF_DataChanged 0
    UnsetLclVarTrace_wTABREINF
    destroy .wTABREINF

}

#----------------------------------------------------------------------
#  HelpButtonPress_wTABREINF
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wTABREINF {} {
    source "userHelp.tcl"

    displayHelpfile "F23-help"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wTABREINF
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wTABREINF {} {

    global AllGlobalVars_wTABREINF

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wTABREINF {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wTABREINF }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wTABREINF
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wTABREINF {} {

    global AllGlobalVars_wTABREINF

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wTABREINF {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wTABREINF }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wTABREINF
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wTABREINF { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wTABREINF_DataChanged

    set Lcl_wTABREINF_DataChanged 1
}

#----------------------------------------------------------------------
#  DecConfigTabs_wTABREINF
#  Decreases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecConfigTabs_wTABREINF {} {
    global .wTABREINF
    global Lcl_numGroupsTR

    destroy .wTABREINF.dataBot.ntebk.config$Lcl_numGroupsTR

    incr Lcl_numGroupsTR -1

    UpdateConfigButtons_wTABREINF
}

#----------------------------------------------------------------------
#  IncConfigTabs_wTABREINF
#  Increases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncConfigTabs_wTABREINF {} {
    global .wTABREINF
    global Lcl_numGroupsTR

    incr Lcl_numGroupsTR

    UpdateConfigButtons_wTABREINF

    # new tab means we must initialize the variables
    CreateInitialConfigVars_wTABREINF $Lcl_numGroupsTR

    addEditTab_wTABREINF $Lcl_numGroupsTR
}

#----------------------------------------------------------------------
#  CreateInitialConfigVars_wTABREINF
#  Creates an initial set of initial variable to display an empty
#  configuration tab
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialConfigVars_wTABREINF { tabNum_wTABREINF } {
    global Lcl_numTabReinf

    foreach k {1 2 3 4 5} {
    set Lcl_numTabReinf($tabNum_wTABREINF,$k) 1
    }

    CreateInitialItemLineVars_wTABREINF $tabNum_wTABREINF
}

#----------------------------------------------------------------------
#  UpdateConfigButtons_wTABREINF
#  Updates the status of the config buttons depending on the number of
#  configs.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateConfigButtons_wTABREINF {} {
    global .wTABREINF
    global Lcl_numGroupsTR

    if {$Lcl_numGroupsTR > 1} {
        .wTABREINF.dataTop.b_dec configure -state normal
    } else {
        .wTABREINF.dataTop.b_dec configure -state disabled
    }
}

#----------------------------------------------------------------------
#  addEditTab_wTABREINF
#  Adds all the edit elements needed for one config tab
#
#  IN:      Number of the new tab to be created (1..)
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEditTab_wTABREINF {tabNum_wTABREINF} {
    global .wTABREINF

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wTABREINF
    foreach {e} $AllGlobalVars_wTABREINF {
        global Lcl_$e
    }

    # create GUI
    ttk::frame .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF
    .wTABREINF.dataBot.ntebk add .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF -text [::msgcat::mc "Gr $tabNum_wTABREINF"]

    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.spacer00 -width 5 -text ""
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.spacer00 -row 0 -column 0

    #-------------
    # Config of items
#    button      .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.b_decItems     -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wTABREINF -state disabled
#    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.b_decItems    -row 1 -column 1 -sticky e -padx 3 -pady 3

#    button      .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.b_incItems     -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wTABREINF
#    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.b_incItems    -row 1 -column 2 -sticky e -padx 3 -pady 3

#    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.spacer20 -width 5 -text ""
#    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.spacer20 -row 2 -column 0


    #-------------
    # header for the for the group configuration

    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.pq1 -width 10 -text [::msgcat::mc "Group"]
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.pq1 -row 6 -column 1 -sticky e

    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.pq2 -width 10 -text [::msgcat::mc "Rib ini"]
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.pq2 -row 6 -column 2 -sticky e

    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.pq3 -width 10 -text [::msgcat::mc "Rib fin"]
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.pq3 -row 6 -column 3 -sticky e

    #-------------
    # entrys for the group configuration
    ttk::entry  .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.e_pq1 -width 10 -textvariable Lcl_numTabReinf($tabNum_wTABREINF,1)
    SetHelpBind .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.e_pq1 [::msgcat::mc "Group number"] HelpText_wTABREINF
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.e_pq1 -row 7 -column 1 -sticky e -pady 1

    ttk::entry  .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.e_pq2 -width 10 -textvariable Lcl_numTabReinf($tabNum_wTABREINF,2)
    SetHelpBind .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.e_pq2 [::msgcat::mc "Initial rib"] HelpText_wTABREINF
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.e_pq2 -row 7 -column 2 -sticky e -pady 1

    ttk::entry  .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.e_pq3 -width 10 -textvariable Lcl_numTabReinf($tabNum_wTABREINF,3)
    SetHelpBind .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.e_pq3 [::msgcat::mc "Final rib"] HelpText_wTABREINF
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.e_pq3 -row 7 -column 3 -sticky e -pady 1

    #-------------
    # header for the item points of tab reinforcements
    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p1 -width 10 -text "A"
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p1 -row 9 -column 1 -sticky e

    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p2 -width 10 -text "B"
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p2 -row 9 -column 2 -sticky e

    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p3 -width 10 -text "C"
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p3 -row 9 -column 3 -sticky e

    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p4 -width 10 -text "D"
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p4 -row 9 -column 4 -sticky e

    label       .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p5 -width 10 -text "E"
    grid        .wTABREINF.dataBot.ntebk.config$tabNum_wTABREINF.p5 -row 9 -column 5 -sticky e


#    for { set i 1 } { $i <= $Lcl_numTabReinf($tabNum_wTABREINF,4) } { incr i } {
         AddItemLine_wTABREINF $tabNum_wTABREINF 1
#    }

#    UpdateItemLineButtons_wTABREINF $tabNum_wTABREINF
}

#----------------------------------------------------------------------
#  DecItemLines_wTABREINF
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wTABREINF {} {
    global .wTABREINF
    global Lcl_numTabReinf

    set currentTab [eval .wTABREINF.dataBot.ntebk index current]
    incr currentTab

    destroy .wTABREINF.dataBot.ntebk.config$currentTab.e_p1$Lcl_numTabReinf($currentTab,4)
    destroy .wTABREINF.dataBot.ntebk.config$currentTab.e_p2$Lcl_numTabReinf($currentTab,4)
    destroy .wTABREINF.dataBot.ntebk.config$currentTab.e_p3$Lcl_numTabReinf($currentTab,4)
    destroy .wTABREINF.dataBot.ntebk.config$currentTab.e_p4$Lcl_numTabReinf($currentTab,4)
    destroy .wTABREINF.dataBot.ntebk.config$currentTab.e_p5$Lcl_numTabReinf($currentTab,4)
    incr Lcl_numTabReinf($currentTab,4) -1

    UpdateItemLineButtons_wTABREINF 0
}

#----------------------------------------------------------------------
#  IncItemLines_wTABREINF
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wTABREINF {} {
    global .wTABREINF
    global Lcl_numTabReinf

    set currentTab [eval .wTABREINF.dataBot.ntebk index current]
    incr currentTab

    incr Lcl_numTabReinf($currentTab,4)

    UpdateItemLineButtons_wTABREINF 0

    # init additional variables
    CreateInitialItemLineVars_wTABREINF $currentTab

    AddItemLine_wTABREINF $currentTab $Lcl_numTabReinf($currentTab,4)
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wTABREINF
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wTABREINF { tabNum_wTABREINF } {
    global .wTABREINF
    global Lcl_numTabReinf
    global Lcl_lineTabReinf

    # init additional variables
    foreach i {1 2 3 4 5 6} {
        set Lcl_lineTabReinf($tabNum_wTABREINF,$i) 0.
    }
}

#----------------------------------------------------------------------
#  UpdateItemLineButtons_wTABREINF
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wTABREINF { tabNum } {
    global .wTABREINF
    global Lcl_numTabReinf

    if { $tabNum == 0 } {
        set currentTab [eval .wTABREINF.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    if {$Lcl_numTabReinf($currentTab,4) > 1} {
        .wTABREINF.dataBot.ntebk.config$currentTab.b_decItems configure -state normal
    } else {
        .wTABREINF.dataBot.ntebk.config$currentTab.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wTABREINF
#  Adds an additional Item Line to a tab
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wTABREINF { tabNum lineNum} {
    global .wTABREINF
    global Lcl_lineTabReinf

    if { $tabNum == 0 } {
        set currentTab [eval .wTABREINF.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    ttk::entry  .wTABREINF.dataBot.ntebk.config$tabNum.e_p1$lineNum -width 10 -textvariable Lcl_lineTabReinf($currentTab,1)
    SetHelpBind .wTABREINF.dataBot.ntebk.config$tabNum.e_p1$lineNum [::msgcat::mc "Scheme for A tab"] HelpText_wTABREINF
    grid        .wTABREINF.dataBot.ntebk.config$tabNum.e_p1$lineNum -row [expr (10-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wTABREINF.dataBot.ntebk.config$tabNum.e_p2$lineNum -width 10 -textvariable Lcl_lineTabReinf($currentTab,2)
    SetHelpBind .wTABREINF.dataBot.ntebk.config$tabNum.e_p2$lineNum [::msgcat::mc "Scheme for B tab"]  HelpText_wTABREINF
    grid        .wTABREINF.dataBot.ntebk.config$tabNum.e_p2$lineNum -row [expr (10-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wTABREINF.dataBot.ntebk.config$tabNum.e_p3$lineNum -width 10 -textvariable Lcl_lineTabReinf($currentTab,3)
    SetHelpBind .wTABREINF.dataBot.ntebk.config$tabNum.e_p3$lineNum [::msgcat::mc "Scheme for C tab"] HelpText_wTABREINF
    grid        .wTABREINF.dataBot.ntebk.config$tabNum.e_p3$lineNum -row [expr (10-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wTABREINF.dataBot.ntebk.config$tabNum.e_p4$lineNum -width 10 -textvariable Lcl_lineTabReinf($currentTab,4)
    SetHelpBind .wTABREINF.dataBot.ntebk.config$tabNum.e_p4$lineNum [::msgcat::mc "Scheme for D tab"] HelpText_wTABREINF
    grid        .wTABREINF.dataBot.ntebk.config$tabNum.e_p4$lineNum -row [expr (10-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wTABREINF.dataBot.ntebk.config$tabNum.e_p5$lineNum -width 10 -textvariable Lcl_lineTabReinf($currentTab,5)
    SetHelpBind .wTABREINF.dataBot.ntebk.config$tabNum.e_p5$lineNum [::msgcat::mc "Scheme for E tab"] HelpText_wTABREINF
    grid        .wTABREINF.dataBot.ntebk.config$tabNum.e_p5$lineNum -row [expr (10-1 + $lineNum)] -column 5 -sticky e -pady 1

}
