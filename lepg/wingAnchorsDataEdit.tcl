#---------------------------------------------------------------------
#
#  Window to edit the wing anchors data
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
global  Lcl_wANDE_DataChanged
set     Lcl_wANDE_DataChanged    0

global  AllGlobalVars_wANDE
set     AllGlobalVars_wANDE { numRibsHalf ribConfig }

#----------------------------------------------------------------------
#  wingAnchorsDataEdit
#  Displays a window to edit the anchor data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingAnchorsDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wANDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wANDE
    foreach {e} $AllGlobalVars_wANDE {
        global Lcl_$e
    }

    SetLclVars_wANDE

    toplevel .wANDE
    focus .wANDE

    wm protocol .wANDE WM_DELETE_WINDOW { CancelButtonPress_wANDE }

    wm title .wANDE [::msgcat::mc "Section 3: Wing Anchors Data"]

    #-------------
    # Frames and grids
    # ttk::frame      .wANDE.dataTop
    ttk::frame      .wANDE.dataMid
    ttk::frame      .wANDE.dataBot
    ttk::labelframe .wANDE.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wANDE.btn

    #-------------
    # Place frames
    # grid .wANDE.dataTop         -row 0 -column 0 -sticky w
    grid .wANDE.dataMid         -row 1 -column 0 -sticky w
    grid .wANDE.dataBot         -row 2 -column 0 -sticky nesw
    grid .wANDE.help            -row 3 -column 0 -sticky e
    grid .wANDE.btn             -row 4 -column 0 -sticky e

    grid columnconfigure .wANDE 0 -weight 1
    grid rowconfigure .wANDE 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wANDE.dataBot.scroll  -width 700 -height 400 -yscrollcommand ".wANDE.dataBot.yscroll set"
    ttk::scrollbar .wANDE.dataBot.yscroll -command ".wANDE.dataBot.scroll yview"

    grid .wANDE.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wANDE.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wANDE.dataBot 0 -weight 1
    grid columnconfigure .wANDE.dataBot 1 -weight 0
    grid rowconfigure .wANDE.dataBot 0 -weight 1

    ttk::frame .wANDE.dataBot.scroll.widgets -borderwidth 1
    grid .wANDE.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wANDE

    ResizeScrollFrame_wANDE

    #-------------
    # explanations
    label .wANDE.help.e_help -width 100 -height 3 -background LightYellow -justify left -textvariable HelpText_wANDE
    grid  .wANDE.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wANDE.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wANDE
    button .wANDE.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wANDE
    button .wANDE.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wANDE
    button .wANDE.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wANDE

    grid .wANDE.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wANDE.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wANDE.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wANDE.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10



    #-------------
    # Config num of items
    label       .wANDE.dataMid.spacer00 -width 5 -text ""
    grid        .wANDE.dataMid.spacer00 -row 0 -column 0

    button      .wANDE.dataMid.b_decItems -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wANDE -state disabled
    grid        .wANDE.dataMid.b_decItems -row 1 -column 1 -sticky e -padx 3 -pady 3

    button      .wANDE.dataMid.b_incItems -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wANDE
    grid        .wANDE.dataMid.b_incItems -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wANDE.dataMid.spacer20 -width 5 -text "    "
    grid        .wANDE.dataMid.spacer20 -row 2 -column 0



    SetLclVarTrace_wANDE
}

#----------------------------------------------------------------------
#  SetLclVars_wANDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wANDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wANDE
    foreach {e} $AllGlobalVars_wANDE {
        global Lcl_$e
    }
    set Lcl_numRibsHalf    $numRibsHalf

    for {set i 1} {$i <= $numRibsHalf} {incr i} {
        foreach k {1 15 16 17 18 19 20 21} {
        set Lcl_ribConfig($i,$k)   $ribConfig($i,$k)
        }
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wANDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wANDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wANDE
    foreach {e} $AllGlobalVars_wANDE {
        global Lcl_$e
    }

    set numRibsHalf    $Lcl_numRibsHalf

    for {set i 1} {$i <= $numRibsHalf} {incr i} {
        foreach k {1 15 16 17 18 19 20 21} {
        set ribConfig($i,$k)   $Lcl_ribConfig($i,$k)
        }
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wANDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wANDE {} {
    global g_WingDataChanged
    global Lcl_wANDE_DataChanged

    if { $Lcl_wANDE_DataChanged == 1 } {
        ExportLclVars_wANDE

        set g_WingDataChanged       1
        set Lcl_wANDE_DataChanged    0
    }
    
    # Redraw top view
    #DrawTopView 
    #DrawTailView
}

#----------------------------------------------------------------------
#  OkButtonPress_wANDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wANDE {} {
    global .wANDE
    global g_WingDataChanged
    global Lcl_wANDE_DataChanged

    if { $Lcl_wANDE_DataChanged == 1 } {
        ExportLclVars_wANDE
        set g_WingDataChanged       1
        set Lcl_wANDE_DataChanged    0
    }

    # Redraw top view
    #DrawTopView 
    #DrawTailView

    UnsetLclVarTrace_wANDE
    destroy .wANDE
}

#----------------------------------------------------------------------
#  CancelButtonPress_wANDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wANDE {} {
    global .wANDE
    global g_WingDataChanged
    global Lcl_wANDE_DataChanged

    if { $Lcl_wANDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wANDE
            return 0
        }
    }

    set Lcl_wANDE_DataChanged 0
    UnsetLclVarTrace_wANDE
    destroy .wANDE

}

#----------------------------------------------------------------------
#  HelpButtonPress_wANDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wANDE {} {
    source "userHelp.tcl"

    displayHelpfile "geometry-matrix-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wANDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wANDE {} {

    global AllGlobalVars_wANDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wANDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wANDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wANDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wANDE {} {

    global AllGlobalVars_wANDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wANDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wANDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wANDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wANDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wANDE_DataChanged

    set Lcl_wANDE_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wANDE
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wANDE {} {
    global .wANDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wANDE
    foreach {e} $AllGlobalVars_wANDE {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    # There's none

    #-------------
    # header for the item lines

#    label       .wANDE.dataMid.spacerr -width 10 -text ""
#    grid        .wANDE.dataMid.spacerr -row 3 -column 0 -sticky e

    label       .wANDE.dataMid.n1 -width 10 -text [::msgcat::mc "Num"]
    grid        .wANDE.dataMid.n1 -row 3 -column 0 -sticky e -pady 1

    label       .wANDE.dataMid.n2 -width 13 -text [::msgcat::mc "A"]
    grid        .wANDE.dataMid.n2 -row 3 -column 1 -sticky e -pady 1

    label       .wANDE.dataMid.n3 -width 13 -text [::msgcat::mc "B"]
    grid        .wANDE.dataMid.n3 -row 3 -column 2 -sticky e -pady 1

    label       .wANDE.dataMid.n4 -width 10 -text [::msgcat::mc "C"]
    grid        .wANDE.dataMid.n4 -row 3 -column 3 -sticky e -pady 1

    label       .wANDE.dataMid.n5 -width 10 -text [::msgcat::mc "D"]
    grid        .wANDE.dataMid.n5 -row 3 -column 4 -sticky e -pady 1

    label       .wANDE.dataMid.n6 -width 10 -text [::msgcat::mc "E"]
    grid        .wANDE.dataMid.n6 -row 3 -column 5 -sticky e -pady 1

    label       .wANDE.dataMid.n7 -width 15 -text [::msgcat::mc "Brakes"]
    grid        .wANDE.dataMid.n7 -row 3 -column 6 -sticky e -pady 1

    #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numRibsHalf } { incr i } {
        AddItemLine_wANDE $i
    }

#    UpdateItemLineButtons_wANDE
}

#----------------------------------------------------------------------
#  DecItemLines_wANDE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wANDE {} {
    global .wANDE
    global Lcl_numRibsHalf

    destroy .wANDE.dataBot.scroll.widgets.e_n1$Lcl_numRibsHalf
    destroy .wANDE.dataBot.scroll.widgets.e_n2$Lcl_numRibsHalf
    destroy .wANDE.dataBot.scroll.widgets.e_n3$Lcl_numRibsHalf
    destroy .wANDE.dataBot.scroll.widgets.e_n4$Lcl_numRibsHalf
    destroy .wANDE.dataBot.scroll.widgets.e_n5$Lcl_numRibsHalf
    destroy .wANDE.dataBot.scroll.widgets.e_n6$Lcl_numRibsHalf
    destroy .wANDE.dataBot.scroll.widgets.e_n7$Lcl_numRibsHalf

    incr Lcl_numRibsHalf -1

    UpdateItemLineButtons_wANDE

    ResizeScrollFrame_wANDE
}

#----------------------------------------------------------------------
#  IncItemLines_wANDE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wANDE {} {
    global .wANDE
    global Lcl_numRibsHalf

    incr Lcl_numRibsHalf

    UpdateItemLineButtons_wANDE

    # init additional variables
    CreateInitialItemLineVars_wANDE

    AddItemLine_wANDE $Lcl_numRibsHalf

    ResizeScrollFrame_wANDE
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wANDE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wANDE {} {
    global .wANDE
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wANDE
    foreach {e} $AllGlobalVars_wANDE {
        global Lcl_$e
    }

    foreach k {1 15 16 17 18 19 20 21} {
    set Lcl_ribConfig($Lcl_numRibsHalf,$k) 0
    }
    set Lcl_ribConfig($Lcl_numRibsHalf,1) $Lcl_numRibsHalf
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wANDE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wANDE { } {
    global .wANDE
    global Lcl_numRibsHalf

    if {$Lcl_numRibsHalf > 1} {
        .wANDE.dataMid.b_decItems configure -state normal
    } else {
        .wANDE.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wANDE
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wANDE { lineNum } {
    global .wANDE
    global Lcl_numRibsHalf

    ttk::entry  .wANDE.dataBot.scroll.widgets.e_n1$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,1)
    SetHelpBind .wANDE.dataBot.scroll.widgets.e_n1$lineNum [::msgcat::mc "Rib number"] HelpText_wANDE
    grid        .wANDE.dataBot.scroll.widgets.e_n1$lineNum -row [expr (4-1 + $lineNum)] -column 0 -sticky e -pady 1

    ttk::entry  .wANDE.dataBot.scroll.widgets.e_n2$lineNum -width 13 -textvariable Lcl_ribConfig($lineNum,16)
    SetHelpBind .wANDE.dataBot.scroll.widgets.e_n2$lineNum [::msgcat::mc "A anchor position %%"] HelpText_wANDE
    grid        .wANDE.dataBot.scroll.widgets.e_n2$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wANDE.dataBot.scroll.widgets.e_n3$lineNum -width 13 -textvariable Lcl_ribConfig($lineNum,17)
    SetHelpBind .wANDE.dataBot.scroll.widgets.e_n3$lineNum [::msgcat::mc "B anchor position %%"] HelpText_wANDE
    grid        .wANDE.dataBot.scroll.widgets.e_n3$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wANDE.dataBot.scroll.widgets.e_n4$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,18)
    SetHelpBind .wANDE.dataBot.scroll.widgets.e_n4$lineNum [::msgcat::mc "C anchor position %%"] HelpText_wANDE
    grid        .wANDE.dataBot.scroll.widgets.e_n4$lineNum -row [expr (4-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wANDE.dataBot.scroll.widgets.e_n5$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,19)
    SetHelpBind .wANDE.dataBot.scroll.widgets.e_n5$lineNum [::msgcat::mc "D anchor position %%"] HelpText_wANDE
    grid        .wANDE.dataBot.scroll.widgets.e_n5$lineNum -row [expr (4-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wANDE.dataBot.scroll.widgets.e_n6$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,20)
    SetHelpBind .wANDE.dataBot.scroll.widgets.e_n6$lineNum [::msgcat::mc "E anchor position %%"] HelpText_wANDE
    grid        .wANDE.dataBot.scroll.widgets.e_n6$lineNum -row [expr (4-1 + $lineNum)] -column 5 -sticky e -pady 1

    ttk::entry  .wANDE.dataBot.scroll.widgets.e_n7$lineNum -width 15 -textvariable Lcl_ribConfig($lineNum,21)
    SetHelpBind .wANDE.dataBot.scroll.widgets.e_n7$lineNum [::msgcat::mc "Brakes"] HelpText_wANDE
    grid        .wANDE.dataBot.scroll.widgets.e_n7$lineNum -row [expr (4-1 + $lineNum)] -column 6 -sticky e -pady 1

}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wANDE
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wANDE { } {
    global .wANDE

    set framesize [grid size .wANDE.dataBot.scroll.widgets]

    .wANDE.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wANDE.dataBot.scroll create window 0 0 -anchor nw -window .wANDE.dataBot.scroll.widgets
    .wANDE.dataBot.scroll configure -scrollregion [.wANDE.dataBot.scroll bbox all]
}
