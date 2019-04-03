#---------------------------------------------------------------------
#
#  Window to edit hv vh ribs
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wRIBDE_DataChanged
set     Lcl_wRIBDE_DataChanged    0

global  AllGlobalVars_wRIBDE
set     AllGlobalVars_wRIBDE { numMiniRibs miniRibXSep miniRibYSep miniRib }

#----------------------------------------------------------------------
#  wingHV-VH-RibsDataEdit
#  Displays a window to edit the HV-VH ribs data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingHV-VH-RibsDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wRIBDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wRIBDE
    foreach {e} $AllGlobalVars_wRIBDE {
        global Lcl_$e
    }

    SetLclVars_wRIBDE

    toplevel .wRIBDE
    focus .wRIBDE

    wm protocol .wRIBDE WM_DELETE_WINDOW { CancelButtonPress_wRIBDE }

    wm title .wRIBDE [::msgcat::mc "HV VH ribs configuration"]

    #-------------
    # Frames and grids
    ttk::frame      .wRIBDE.dataTop
    ttk::frame      .wRIBDE.dataMid
    ttk::frame      .wRIBDE.dataBot
    ttk::labelframe .wRIBDE.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wRIBDE.btn

    #-------------
    # Place frames
    grid .wRIBDE.dataTop         -row 0 -column 0 -sticky w
    grid .wRIBDE.dataMid         -row 1 -column 0 -sticky w
    grid .wRIBDE.dataBot         -row 2 -column 0 -sticky nesw
    grid .wRIBDE.help            -row 3 -column 0 -sticky e
    grid .wRIBDE.btn             -row 4 -column 0 -sticky e

    grid columnconfigure .wRIBDE 0 -weight 1
    grid rowconfigure .wRIBDE 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wRIBDE.dataBot.scroll  -width 1000 -height 300 -yscrollcommand ".wRIBDE.dataBot.yscroll set"
    ttk::scrollbar .wRIBDE.dataBot.yscroll -command ".wRIBDE.dataBot.scroll yview"

    grid .wRIBDE.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wRIBDE.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wRIBDE.dataBot 0 -weight 1
    grid columnconfigure .wRIBDE.dataBot 1 -weight 0
    grid rowconfigure .wRIBDE.dataBot 0 -weight 1

    ttk::frame .wRIBDE.dataBot.scroll.widgets -borderwidth 1 -relief solid
    grid .wRIBDE.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wRIBDE

    ResizeScrollFrame_wRIBDE

    #-------------
    # explanations
    label .wRIBDE.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wRIBDE
    grid  .wRIBDE.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wRIBDE.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wRIBDE
    button .wRIBDE.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wRIBDE
    button .wRIBDE.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wRIBDE
    button .wRIBDE.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wRIBDE

    grid .wRIBDE.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wRIBDE.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wRIBDE.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wRIBDE.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wRIBDE
}

#----------------------------------------------------------------------
#  SetLclVars_wRIBDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wRIBDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wRIBDE
    foreach {e} $AllGlobalVars_wRIBDE {
        global Lcl_$e
    }
    set Lcl_numMiniRibs    $numMiniRibs
    set Lcl_miniRibXSep    $miniRibXSep
    set Lcl_miniRibYSep    $miniRibYSep

    for {set i 1} {$i <= $numMiniRibs} {incr i} {
        for {set j 1} {$j <= 10} {incr j} {
            set Lcl_miniRib($i,$j)   $miniRib($i,$j)
        }

        if {$miniRib($i,2) == 6} {
            set Lcl_miniRib($i,11)   $miniRib($i,11)
            set Lcl_miniRib($i,12)   $miniRib($i,12)
        }
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wRIBDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wRIBDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wRIBDE
    foreach {e} $AllGlobalVars_wRIBDE {
        global Lcl_$e
    }

    set numMiniRibs    $Lcl_numMiniRibs
    set miniRibXSep    $Lcl_miniRibXSep
    set miniRibYSep    $Lcl_miniRibYSep

    for {set i 1} {$i <= $numMiniRibs} {incr i} {
        # make sure number is in
        set miniRib($i,1)   $i

        for {set j 2} {$j <= 10} {incr j} {
            set miniRib($i,$j)   $Lcl_miniRib($i,$j)
        }

        if {$miniRib($i,2) == 6} {
            set miniRib($i,11)   $Lcl_miniRib($i,11)
            set miniRib($i,12)   $Lcl_miniRib($i,12)
        }
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wRIBDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wRIBDE {} {
    global g_WingDataChanged
    global Lcl_wRIBDE_DataChanged

    if { $Lcl_wRIBDE_DataChanged == 1 } {
        ExportLclVars_wRIBDE

        set g_WingDataChanged       1
        set Lcl_wRIBDE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wRIBDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wRIBDE {} {
    global .wRIBDE
    global g_WingDataChanged
    global Lcl_wRIBDE_DataChanged

    if { $Lcl_wRIBDE_DataChanged == 1 } {
        ExportLclVars_wRIBDE
        set g_WingDataChanged       1
        set Lcl_wRIBDE_DataChanged    0
    }

    UnsetLclVarTrace_wRIBDE
    destroy .wRIBDE
}

#----------------------------------------------------------------------
#  CancelButtonPress_wRIBDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wRIBDE {} {
    global .wRIBDE
    global g_WingDataChanged
    global Lcl_wRIBDE_DataChanged

    if { $Lcl_wRIBDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wRIBDE
            return 0
        }
    }

    set Lcl_wRIBDE_DataChanged 0
    UnsetLclVarTrace_wRIBDE
    destroy .wRIBDE

}

#----------------------------------------------------------------------
#  HelpButtonPress_wRIBDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wRIBDE {} {
    source "userHelp.tcl"

    displayHelpfile "hv-vh-ribs-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wRIBDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wRIBDE {} {

    global AllGlobalVars_wRIBDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wRIBDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wRIBDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wRIBDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wRIBDE {} {

    global AllGlobalVars_wRIBDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wRIBDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wRIBDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wRIBDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wRIBDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wRIBDE_DataChanged

    set Lcl_wRIBDE_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wRIBDE
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wRIBDE {} {
    global .wRIBDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wRIBDE
    foreach {e} $AllGlobalVars_wRIBDE {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    label       .wRIBDE.dataTop.spacer00 -width 5 -text ""
    grid        .wRIBDE.dataTop.spacer00 -row 0 -column 0

    label       .wRIBDE.dataTop.lbl1 -width 10 -text [::msgcat::mc "Spacing"]
    grid        .wRIBDE.dataTop.lbl1 -row 1 -column 1 -sticky e

    label       .wRIBDE.dataTop.p1 -width 10 -text [::msgcat::mc "X-Spacing"]
    grid        .wRIBDE.dataTop.p1 -row 2 -column 2 -sticky e
    ttk::entry  .wRIBDE.dataTop.e_p1 -width 10 -textvariable Lcl_miniRibXSep
    SetHelpBind .wRIBDE.dataTop.e_p1 miniRibXSep   HelpText_wRIBDE
    grid        .wRIBDE.dataTop.e_p1 -row 2 -column 3 -sticky e -pady 1

    label       .wRIBDE.dataTop.p2 -width 10 -text [::msgcat::mc "Y-Spacing"]
    grid        .wRIBDE.dataTop.p2 -row 2 -column 4 -sticky e
    ttk::entry  .wRIBDE.dataTop.e_p2 -width 10 -textvariable Lcl_miniRibYSep
    SetHelpBind .wRIBDE.dataTop.e_p2 miniRibYSep   HelpText_wRIBDE
    grid        .wRIBDE.dataTop.e_p2 -row 2 -column 5 -sticky e -pady 1

    #-------------
    # Config num of items
    label       .wRIBDE.dataMid.spacer00 -width 5 -text ""
    grid        .wRIBDE.dataMid.spacer00 -row 0 -column 0

    button      .wRIBDE.dataMid.b_decItems -width 10 -text [::msgcat::mc "dec Ribs"] -command DecItemLines_wRIBDE -state disabled
    grid        .wRIBDE.dataMid.b_decItems -row 1 -column 1 -sticky e -padx 3 -pady 3

    button      .wRIBDE.dataMid.b_incItems -width 10 -text [::msgcat::mc "inc Ribs"]  -command IncItemLines_wRIBDE
    grid        .wRIBDE.dataMid.b_incItems -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wRIBDE.dataMid.spacer20 -width 5 -text ""
    grid        .wRIBDE.dataMid.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines
    label       .wRIBDE.dataBot.scroll.widgets.n -width 10 -text "Num"
    grid        .wRIBDE.dataBot.scroll.widgets.n -row 0 -column 1 -sticky e

    label       .wRIBDE.dataBot.scroll.widgets.p2 -width 10 -text [::msgcat::mc "Type"]
    grid        .wRIBDE.dataBot.scroll.widgets.p2 -row 0 -column 2 -sticky e

    for {set i 3} {$i <=12} {incr i} {
        label .wRIBDE.dataBot.scroll.widgets.p$i -width 10 -text [::msgcat::mc "P$i"]
        grid  .wRIBDE.dataBot.scroll.widgets.p$i -row 0 -column $i -sticky e
    }


    #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numMiniRibs } { incr i } {
        AddItemLine_wRIBDE $i
    }

    UpdateItemLineButtons_wRIBDE
}

#----------------------------------------------------------------------
#  DecItemLines_wRIBDE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wRIBDE {} {
    global .wRIBDE
    global Lcl_numMiniRibs

    destroy .wRIBDE.dataBot.scroll.widgets.n$Lcl_numMiniRibs
    for { set i 2 } {$i <= 12 } {incr i} {
        destroy .wRIBDE.dataBot.scroll.widgets.e_p$i$Lcl_numMiniRibs
    }

    incr Lcl_numMiniRibs -1

    UpdateItemLineButtons_wRIBDE

    ResizeScrollFrame_wRIBDE
}

#----------------------------------------------------------------------
#  IncItemLines_wRIBDE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wRIBDE {} {
    global .wRIBDE
    global Lcl_numMiniRibs

    incr Lcl_numMiniRibs

    UpdateItemLineButtons_wRIBDE

    # init additional variables
    CreateInitialItemLineVars_wRIBDE

    AddItemLine_wRIBDE $Lcl_numMiniRibs

    ResizeScrollFrame_wRIBDE
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wRIBDE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wRIBDE {} {
    global .wRIBDE
    global Lcl_numMiniRibs
    global Lcl_miniRib

    # init additional variables
    foreach i { 1 2 3 4 5 6 7 8 9 10 11 12 } {
        set Lcl_miniRib($Lcl_numMiniRibs,$i) 0
    }
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wRIBDE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wRIBDE { } {
    global .wRIBDE
    global Lcl_numMiniRibs

    if {$Lcl_numMiniRibs > 1} {
        .wRIBDE.dataMid.b_decItems configure -state normal
    } else {
        .wRIBDE.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wRIBDE
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wRIBDE { lineNum } {
    global .wRIBDE
    global Lcl_miniRib

    label       .wRIBDE.dataBot.scroll.widgets.n$lineNum -width 15 -text "$lineNum"
    grid        .wRIBDE.dataBot.scroll.widgets.n$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e

    for { set i 2 } {$i <=12 } {incr i} {
        ttk::entry  .wRIBDE.dataBot.scroll.widgets.e_p$i$lineNum -width 10 -textvariable Lcl_miniRib($lineNum,$i)
        SetHelpBind .wRIBDE.dataBot.scroll.widgets.e_p$i$lineNum miniRib_P$i   HelpText_wRIBDE
        grid        .wRIBDE.dataBot.scroll.widgets.e_p$i$lineNum -row [expr (4-1 + $lineNum)] -column $i -sticky e -pady 1
    }

}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wRIBDE
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wRIBDE { } {
    global .wRIBDE

    set framesize [grid size .wRIBDE.dataBot.scroll.widgets]

    .wRIBDE.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wRIBDE.dataBot.scroll create window 0 0 -anchor nw -window .wRIBDE.dataBot.scroll.widgets
    .wRIBDE.dataBot.scroll configure -scrollregion [.wRIBDE.dataBot.scroll bbox all]
}
