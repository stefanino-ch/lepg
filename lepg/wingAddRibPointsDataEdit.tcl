#---------------------------------------------------------------------
#
#  Window to edit the additional rib points
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wARPDE_DataChanged
set     Lcl_wARPDE_DataChanged    0

global  AllGlobalVars_wARPDE
set     AllGlobalVars_wARPDE { numAddRipPo addRipPoX addRipPoY }

#----------------------------------------------------------------------
#  wingAddRibPointsDataEdit
#  Displays a window to edit the additional rib points
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingAddRibPointsDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wARPDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wARPDE
    foreach {e} $AllGlobalVars_wARPDE {
        global Lcl_$e
    }

    SetLclVars_wARPDE

    toplevel .wARPDE
    focus .wARPDE

    wm protocol .wARPDE WM_DELETE_WINDOW { CancelButtonPress_wARPDE }

    wm title .wARPDE [::msgcat::mc "Additional rib points configuration"]

    #-------------
    # Frames and grids
    # ttk::frame      .wARPDE.dataTop
    ttk::frame      .wARPDE.dataMid
    ttk::frame      .wARPDE.dataBot
    ttk::labelframe .wARPDE.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wARPDE.btn

    #-------------
    # Place frames
    # grid .wARPDE.dataTop         -row 0 -column 0 -sticky w
    grid .wARPDE.dataMid         -row 1 -column 0 -sticky w
    grid .wARPDE.dataBot         -row 2 -column 0 -sticky nesw
    grid .wARPDE.help            -row 3 -column 0 -sticky e
    grid .wARPDE.btn             -row 4 -column 0 -sticky e

    grid columnconfigure .wARPDE 0 -weight 1
    grid rowconfigure .wARPDE 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wARPDE.dataBot.scroll  -width 300 -height 300 -yscrollcommand ".wARPDE.dataBot.yscroll set"
    ttk::scrollbar .wARPDE.dataBot.yscroll -command ".wARPDE.dataBot.scroll yview"

    grid .wARPDE.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wARPDE.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wARPDE.dataBot 0 -weight 1
    grid columnconfigure .wARPDE.dataBot 1 -weight 0
    grid rowconfigure .wARPDE.dataBot 0 -weight 1

    ttk::frame .wARPDE.dataBot.scroll.widgets -borderwidth 1
    grid .wARPDE.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wARPDE

    ResizeScrollFrame_wARPDE

    #-------------
    # explanations
    label .wARPDE.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wARPDE
    grid  .wARPDE.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wARPDE.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wARPDE
    button .wARPDE.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wARPDE
    button .wARPDE.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wARPDE
    button .wARPDE.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wARPDE

    grid .wARPDE.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wARPDE.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wARPDE.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wARPDE.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wARPDE
}

#----------------------------------------------------------------------
#  SetLclVars_wARPDE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wARPDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wARPDE
    foreach {e} $AllGlobalVars_wARPDE {
        global Lcl_$e
    }
    set Lcl_numAddRipPo    $numAddRipPo

    for {set i 1} {$i <= $numAddRipPo} {incr i} {
        set Lcl_addRipPoX($i)   $addRipPoX($i)
        set Lcl_addRipPoY($i)   $addRipPoY($i)
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wARPDE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wARPDE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wARPDE
    foreach {e} $AllGlobalVars_wARPDE {
        global Lcl_$e
    }

    set numAddRipPo    $Lcl_numAddRipPo

    for {set i 1} {$i <= $numAddRipPo} {incr i} {
        set addRipPoX($i)   $Lcl_addRipPoX($i)
        set addRipPoY($i)   $Lcl_addRipPoY($i)
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wARPDE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wARPDE {} {
    global g_WingDataChanged
    global Lcl_wARPDE_DataChanged

    if { $Lcl_wARPDE_DataChanged == 1 } {
        ExportLclVars_wARPDE

        set g_WingDataChanged       1
        set Lcl_wARPDE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wARPDE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wARPDE {} {
    global .wARPDE
    global g_WingDataChanged
    global Lcl_wARPDE_DataChanged

    if { $Lcl_wARPDE_DataChanged == 1 } {
        ExportLclVars_wARPDE
        set g_WingDataChanged       1
        set Lcl_wARPDE_DataChanged    0
    }

    UnsetLclVarTrace_wARPDE
    destroy .wARPDE
}

#----------------------------------------------------------------------
#  CancelButtonPress_wARPDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wARPDE {} {
    global .wARPDE
    global g_WingDataChanged
    global Lcl_wARPDE_DataChanged

    if { $Lcl_wARPDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wARPDE
            return 0
        }
    }

    set Lcl_wARPDE_DataChanged 0
    UnsetLclVarTrace_wARPDE
    destroy .wARPDE

}

#----------------------------------------------------------------------
#  HelpButtonPress_wARPDE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wARPDE {} {
    source "userHelp.tcl"

    displayHelpfile "add-rib-points-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wARPDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wARPDE {} {

    global AllGlobalVars_wARPDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wARPDE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wARPDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wARPDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wARPDE {} {

    global AllGlobalVars_wARPDE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wARPDE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wARPDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wARPDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wARPDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wARPDE_DataChanged

    set Lcl_wARPDE_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wARPDE
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wARPDE {} {
    global .wARPDE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wARPDE
    foreach {e} $AllGlobalVars_wARPDE {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    # There's none

    #-------------
    # Config num of items
    label       .wARPDE.dataMid.spacer00 -width 5 -text ""
    grid        .wARPDE.dataMid.spacer00 -row 0 -column 0

    button      .wARPDE.dataMid.b_decItems -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wARPDE -state disabled
    grid        .wARPDE.dataMid.b_decItems -row 1 -column 1 -sticky e -padx 3 -pady 3

    button      .wARPDE.dataMid.b_incItems -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wARPDE
    grid        .wARPDE.dataMid.b_incItems -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wARPDE.dataMid.spacer20 -width 5 -text ""
    grid        .wARPDE.dataMid.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines
    label       .wARPDE.dataBot.scroll.widgets.n -width 10 -text [::msgcat::mc "Num"]
    grid        .wARPDE.dataBot.scroll.widgets.n -row 0 -column 1 -sticky e

    label       .wARPDE.dataBot.scroll.widgets.pX -width 10 -text [::msgcat::mc "X Coord"]
    grid        .wARPDE.dataBot.scroll.widgets.pX -row 0 -column 2 -sticky e

    label       .wARPDE.dataBot.scroll.widgets.pY -width 10 -text [::msgcat::mc "Y Coord"]
    grid        .wARPDE.dataBot.scroll.widgets.pY -row 0 -column 3 -sticky e

        #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numAddRipPo } { incr i } {
        AddItemLine_wARPDE $i
    }

    UpdateItemLineButtons_wARPDE
}

#----------------------------------------------------------------------
#  DecItemLines_wARPDE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wARPDE {} {
    global .wARPDE
    global Lcl_numAddRipPo

    destroy .wARPDE.dataBot.scroll.widgets.n$Lcl_numAddRipPo
    destroy .wARPDE.dataBot.scroll.widgets.e_pX$Lcl_numAddRipPo
    destroy .wARPDE.dataBot.scroll.widgets.e_pY$Lcl_numAddRipPo

    incr Lcl_numAddRipPo -1

    UpdateItemLineButtons_wARPDE

    ResizeScrollFrame_wARPDE
}

#----------------------------------------------------------------------
#  IncItemLines_wARPDE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wARPDE {} {
    global .wARPDE
    global Lcl_numAddRipPo

    incr Lcl_numAddRipPo

    UpdateItemLineButtons_wARPDE

    # init additional variables
    CreateInitialItemLineVars_wARPDE

    AddItemLine_wARPDE $Lcl_numAddRipPo

    ResizeScrollFrame_wARPDE
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wARPDE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wARPDE {} {
    global .wARPDE
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wARPDE
    foreach {e} $AllGlobalVars_wARPDE {
        global Lcl_$e
    }

    set Lcl_addRipPoX($Lcl_numAddRipPo) 0
    set Lcl_addRipPoY($Lcl_numAddRipPo) 0
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wARPDE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wARPDE { } {
    global .wARPDE
    global Lcl_numAddRipPo

    if {$Lcl_numAddRipPo > 1} {
        .wARPDE.dataMid.b_decItems configure -state normal
    } else {
        .wARPDE.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wARPDE
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wARPDE { lineNum } {
    global .wARPDE
    global Lcl_numAddRipPo

    label       .wARPDE.dataBot.scroll.widgets.n$lineNum -width 15 -text "$lineNum"
    grid        .wARPDE.dataBot.scroll.widgets.n$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wARPDE.dataBot.scroll.widgets.e_pX$lineNum -width 10 -textvariable Lcl_addRipPoX($lineNum)
    SetHelpBind .wARPDE.dataBot.scroll.widgets.e_pX$lineNum [::msgcat::mc "Additional point x-coordinate"]   HelpText_wARPDE
    grid        .wARPDE.dataBot.scroll.widgets.e_pX$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wARPDE.dataBot.scroll.widgets.e_pY$lineNum -width 10 -textvariable Lcl_addRipPoY($lineNum)
    SetHelpBind .wARPDE.dataBot.scroll.widgets.e_pY$lineNum [::msgcat::mc "Additional point y-coordinate"]   HelpText_wARPDE
    grid        .wARPDE.dataBot.scroll.widgets.e_pY$lineNum -row [expr (4-1 + $lineNum)] -column 3 -sticky e -pady 1
}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wARPDE
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wARPDE { } {
    global .wARPDE

    set framesize [grid size .wARPDE.dataBot.scroll.widgets]

    .wARPDE.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wARPDE.dataBot.scroll create window 0 0 -anchor nw -window .wARPDE.dataBot.scroll.widgets
    .wARPDE.dataBot.scroll configure -scrollregion [.wARPDE.dataBot.scroll bbox all]
}
