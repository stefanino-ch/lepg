#---------------------------------------------------------------------
#
#  Window to edit the matrix og geometry
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
global  Lcl_wADE_DataChanged
set     Lcl_wADE_DataChanged    0

global  AllGlobalVars_wADE
set     AllGlobalVars_wADE { numRibsHalf airfoilName ribConfig }

#----------------------------------------------------------------------
#  wingAddRibPointsDataEdit
#  Displays a window to edit the additional rib points
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingAirfoilsDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wADE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wADE
    foreach {e} $AllGlobalVars_wADE {
        global Lcl_$e
    }

    SetLclVars_wADE

    toplevel .wADE
    focus .wADE

    wm protocol .wADE WM_DELETE_WINDOW { CancelButtonPress_wADE }

    wm title .wADE [::msgcat::mc "Section 2: Wing Airfoils Data"]

    #-------------
    # Frames and grids
    # ttk::frame      .wADE.dataTop
    ttk::frame      .wADE.dataMid
    ttk::frame      .wADE.dataBot
    ttk::labelframe .wADE.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wADE.btn

    #-------------
    # Place frames
    # grid .wADE.dataTop         -row 0 -column 0 -sticky w
    grid .wADE.dataMid         -row 1 -column 0 -sticky w
    grid .wADE.dataBot         -row 2 -column 0 -sticky nesw
    grid .wADE.help            -row 3 -column 0 -sticky e
    grid .wADE.btn             -row 4 -column 0 -sticky e

    grid columnconfigure .wADE 0 -weight 1
    grid rowconfigure .wADE 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wADE.dataBot.scroll  -width 1200 -height 400 -yscrollcommand ".wADE.dataBot.yscroll set"
    ttk::scrollbar .wADE.dataBot.yscroll -command ".wADE.dataBot.scroll yview"

    grid .wADE.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wADE.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wADE.dataBot 0 -weight 1
    grid columnconfigure .wADE.dataBot 1 -weight 0
    grid rowconfigure .wADE.dataBot 0 -weight 1

    ttk::frame .wADE.dataBot.scroll.widgets -borderwidth 1
    grid .wADE.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wADE

    ResizeScrollFrame_wADE

    #-------------
    # explanations
    label .wADE.help.e_help -width 100 -height 3 -background LightYellow -justify left -textvariable HelpText_wADE
    grid  .wADE.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wADE.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wADE
    button .wADE.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wADE
    button .wADE.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wADE
    button .wADE.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wADE

    grid .wADE.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wADE.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wADE.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wADE.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wADE
}

#----------------------------------------------------------------------
#  SetLclVars_wADE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wADE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wADE
    foreach {e} $AllGlobalVars_wADE {
        global Lcl_$e
    }
    set Lcl_numRibsHalf    $numRibsHalf

    for {set i 1} {$i <= $numRibsHalf} {incr i} {

        set Lcl_airfoilName($i) $airfoilName($i)

        foreach k {1 11 12 14 50 55 56} {
        set Lcl_ribConfig($i,$k)   $ribConfig($i,$k)
        }
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wADE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wADE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wADE
    foreach {e} $AllGlobalVars_wADE {
        global Lcl_$e
    }

    set numRibsHalf    $Lcl_numRibsHalf

    for {set i 1} {$i <= $numRibsHalf} {incr i} {

        set airfoilName($i) $Lcl_airfoilName($i)

        foreach k {1 11 12 14 50 55 56} {
        set ribConfig($i,$k)   $Lcl_ribConfig($i,$k)
        }
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wADE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wADE {} {
    global g_WingDataChanged
    global Lcl_wADE_DataChanged

    if { $Lcl_wADE_DataChanged == 1 } {
        ExportLclVars_wADE

        set g_WingDataChanged       1
        set Lcl_wADE_DataChanged    0
    }
    
    # Redraw top view
    #DrawTopView 
    #DrawTailView
}

#----------------------------------------------------------------------
#  OkButtonPress_wADE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wADE {} {
    global .wADE
    global g_WingDataChanged
    global Lcl_wADE_DataChanged

    if { $Lcl_wADE_DataChanged == 1 } {
        ExportLclVars_wADE
        set g_WingDataChanged       1
        set Lcl_wADE_DataChanged    0
    }

    # Redraw top view
    #DrawTopView 
    #DrawTailView

    UnsetLclVarTrace_wADE
    destroy .wADE
}

#----------------------------------------------------------------------
#  CancelButtonPress_wADE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wADE {} {
    global .wADE
    global g_WingDataChanged
    global Lcl_wADE_DataChanged

    if { $Lcl_wADE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wADE
            return 0
        }
    }

    set Lcl_wADE_DataChanged 0
    UnsetLclVarTrace_wADE
    destroy .wADE

}

#----------------------------------------------------------------------
#  HelpButtonPress_wADE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wADE {} {
    source "userHelp.tcl"

    displayHelpfile "geometry-matrix-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wADE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wADE {} {

    global AllGlobalVars_wADE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wADE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wADE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wADE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wADE {} {

    global AllGlobalVars_wADE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wADE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wADE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wADE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wADE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wADE_DataChanged

    set Lcl_wADE_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wADE
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wADE {} {
    global .wADE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wADE
    foreach {e} $AllGlobalVars_wADE {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    # There's none

    #-------------
    # Config num of items
    label       .wADE.dataMid.spacer00 -width 5 -text ""
    grid        .wADE.dataMid.spacer00 -row 0 -column 0

    button      .wADE.dataMid.b_decItems -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wADE -state disabled
    grid        .wADE.dataMid.b_decItems -row 1 -column 1 -sticky e -padx 3 -pady 3

    button      .wADE.dataMid.b_incItems -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wADE
    grid        .wADE.dataMid.b_incItems -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wADE.dataMid.spacer20 -width 5 -text ""
    grid        .wADE.dataMid.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines

    label       .wADE.dataMid.spacerr -width 10 -text ""
    grid        .wADE.dataMid.spacerr -row 3 -column 8 -sticky e

    label       .wADE.dataMid.n1 -width 10 -text [::msgcat::mc "Num"]
    grid        .wADE.dataMid.n1 -row 3 -column 0 -sticky e

    label       .wADE.dataMid.n2 -width 20 -text [::msgcat::mc "Airfoil name"]
    grid        .wADE.dataMid.n2 -row 3 -column 1 -sticky e

    label       .wADE.dataMid.n3 -width 20 -text [::msgcat::mc "% cord inlet start"]
    grid        .wADE.dataMid.n3 -row 3 -column 2 -sticky e

    label       .wADE.dataMid.n4 -width 20 -text [::msgcat::mc "% cord inlet stop"]
    grid        .wADE.dataMid.n4 -row 3 -column 3 -sticky e 

    label       .wADE.dataMid.n5 -width 20 -text [::msgcat::mc "Closed/ open cell"]
    grid        .wADE.dataMid.n5 -row 3 -column 4 -sticky e

    label       .wADE.dataMid.n6 -width 20 -text [::msgcat::mc "Disp."]
    grid        .wADE.dataMid.n6 -row 3 -column 5 -sticky e

    label       .wADE.dataMid.n7 -width 20 -text [::msgcat::mc "rweight"]
    grid        .wADE.dataMid.n7 -row 3 -column 6 -sticky e

    label       .wADE.dataMid.n8 -width 20 -text [::msgcat::mc "Rot/ % Mini Rib"]
    grid        .wADE.dataMid.n8 -row 3 -column 7 -sticky e

        #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numRibsHalf } { incr i } {
        AddItemLine_wADE $i
    }

#    UpdateItemLineButtons_wADE
}

#----------------------------------------------------------------------
#  DecItemLines_wADE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wADE {} {
    global .wADE
    global Lcl_numRibsHalf

    destroy .wADE.dataBot.scroll.widgets.e_n1$Lcl_numRibsHalf
    destroy .wADE.dataBot.scroll.widgets.e_n2$Lcl_numRibsHalf
    destroy .wADE.dataBot.scroll.widgets.e_n3$Lcl_numRibsHalf
    destroy .wADE.dataBot.scroll.widgets.e_n4$Lcl_numRibsHalf
    destroy .wADE.dataBot.scroll.widgets.e_n5$Lcl_numRibsHalf
    destroy .wADE.dataBot.scroll.widgets.e_n6$Lcl_numRibsHalf
    destroy .wADE.dataBot.scroll.widgets.e_n7$Lcl_numRibsHalf
    destroy .wADE.dataBot.scroll.widgets.e_n8$Lcl_numRibsHalf

    incr Lcl_numRibsHalf -1

    UpdateItemLineButtons_wADE

    ResizeScrollFrame_wADE
}

#----------------------------------------------------------------------
#  IncItemLines_wADE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wADE {} {
    global .wADE
    global Lcl_numRibsHalf

    incr Lcl_numRibsHalf

    UpdateItemLineButtons_wADE

    # init additional variables
    CreateInitialItemLineVars_wADE

    AddItemLine_wADE $Lcl_numRibsHalf

    ResizeScrollFrame_wADE
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wADE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wADE {} {
    global .wADE
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wADE
    foreach {e} $AllGlobalVars_wADE {
        global Lcl_$e

    }

    # New airfoil name (!)
    set Lcl_airfoilName($Lcl_numRibsHalf) "AirfoilName"

    foreach k {1 11 12 14 50 55 56} {
    set Lcl_ribConfig($Lcl_numRibsHalf,$k) 0
    }
    set Lcl_ribConfig($Lcl_numRibsHalf,1) $Lcl_numRibsHalf
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wADE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wADE { } {
    global .wADE
    global Lcl_numRibsHalf

    if {$Lcl_numRibsHalf > 1} {
        .wADE.dataMid.b_decItems configure -state normal
    } else {
        .wADE.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wADE
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wADE { lineNum } {
    global .wADE
    global Lcl_numRibsHalf

    ttk::entry  .wADE.dataBot.scroll.widgets.e_n1$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,1)
    SetHelpBind .wADE.dataBot.scroll.widgets.e_n1$lineNum [::msgcat::mc "Rib number"] HelpText_wADE
    grid        .wADE.dataBot.scroll.widgets.e_n1$lineNum -row [expr (4-1 + $lineNum)] -column 0 -sticky e -pady 1

    ttk::entry  .wADE.dataBot.scroll.widgets.e_n2$lineNum -width 20 -textvariable Lcl_airfoilName($lineNum)
    SetHelpBind .wADE.dataBot.scroll.widgets.e_n2$lineNum [::msgcat::mc "Airfoil name\nPut all airfoils in the working directory"] HelpText_wADE
    grid        .wADE.dataBot.scroll.widgets.e_n2$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wADE.dataBot.scroll.widgets.e_n3$lineNum -width 20 -textvariable Lcl_ribConfig($lineNum,11)
    SetHelpBind .wADE.dataBot.scroll.widgets.e_n3$lineNum [::msgcat::mc "%% cord inlet start\nWARNING! Must be consistent with the txt airfoil points definition"] HelpText_wADE
    grid        .wADE.dataBot.scroll.widgets.e_n3$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wADE.dataBot.scroll.widgets.e_n4$lineNum -width 20 -textvariable Lcl_ribConfig($lineNum,12)
    SetHelpBind .wADE.dataBot.scroll.widgets.e_n4$lineNum [::msgcat::mc "%% cord inlet stop\nWARNING! Must be consistent with the txt airfoil points definition"] HelpText_wADE
    grid        .wADE.dataBot.scroll.widgets.e_n4$lineNum -row [expr (4-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wADE.dataBot.scroll.widgets.e_n5$lineNum -width 20 -textvariable Lcl_ribConfig($lineNum,14)
    SetHelpBind .wADE.dataBot.scroll.widgets.e_n5$lineNum [::msgcat::mc "Closed/ open cell\nTip: use section 26 for better control"] HelpText_wADE
    grid        .wADE.dataBot.scroll.widgets.e_n5$lineNum -row [expr (4-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wADE.dataBot.scroll.widgets.e_n6$lineNum -width 20 -textvariable Lcl_ribConfig($lineNum,50)
    SetHelpBind .wADE.dataBot.scroll.widgets.e_n6$lineNum [::msgcat::mc "Vertical displacement"] HelpText_wADE
    grid        .wADE.dataBot.scroll.widgets.e_n6$lineNum -row [expr (4-1 + $lineNum)] -column 5 -sticky e -pady 1

    ttk::entry  .wADE.dataBot.scroll.widgets.e_n7$lineNum -width 20 -textvariable Lcl_ribConfig($lineNum,55)
    SetHelpBind .wADE.dataBot.scroll.widgets.e_n7$lineNum [::msgcat::mc "Relative rib weight"] HelpText_wADE
    grid        .wADE.dataBot.scroll.widgets.e_n7$lineNum -row [expr (4-1 + $lineNum)] -column 6 -sticky e -pady 1

    ttk::entry  .wADE.dataBot.scroll.widgets.e_n8$lineNum -width 20 -textvariable Lcl_ribConfig($lineNum,56)
    SetHelpBind .wADE.dataBot.scroll.widgets.e_n8$lineNum [::msgcat::mc "Set free rotation in ss or %% Mini Rib in ds"] HelpText_wADE
    grid        .wADE.dataBot.scroll.widgets.e_n8$lineNum -row [expr (4-1 + $lineNum)] -column 7 -sticky e -pady 1


}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wADE
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wADE { } {
    global .wADE

    set framesize [grid size .wADE.dataBot.scroll.widgets]

    .wADE.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wADE.dataBot.scroll create window 0 0 -anchor nw -window .wADE.dataBot.scroll.widgets
    .wADE.dataBot.scroll configure -scrollregion [.wADE.dataBot.scroll bbox all]
}
