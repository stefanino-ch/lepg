#---------------------------------------------------------------------
#
#  Window to edit the marks types (section 20)
#
#  Pere Casellas
#  Stefan Feutz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wMARTY_DataChanged
set     Lcl_wMARTY_DataChanged    0

global  AllGlobalVars_wMARTY
set     AllGlobalVars_wMARTY { numMarksTy marksType0 marksType1 marksType2 marksType3 marksType4 marksType5 marksType6 }

#----------------------------------------------------------------------
#  wingMarksTypesDataEdit
#  Displays a window to edit the marks types
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingMarksTypesDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wMARTY

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMARTY
    foreach {e} $AllGlobalVars_wMARTY {
        global Lcl_$e
    }

    SetLclVars_wMARTY

    toplevel .wMARTY
    focus .wMARTY

    wm protocol .wMARTY WM_DELETE_WINDOW { CancelButtonPress_wMARTY }

    wm title .wMARTY [::msgcat::mc "Section 20: Marks types definition"]

    #-------------
    # Frames and grids
    # ttk::frame      .wMARTY.dataTop
    ttk::frame      .wMARTY.dataMid
    ttk::frame      .wMARTY.dataBot
    ttk::labelframe .wMARTY.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wMARTY.btn

    #-------------
    # Place frames
    # grid .wMARTY.dataTop         -row 0 -column 0 -sticky w
    grid .wMARTY.dataMid         -row 1 -column 0 -sticky w
    grid .wMARTY.dataBot         -row 2 -column 0 -sticky nesw
    grid .wMARTY.help            -row 3 -column 0 -sticky e
    grid .wMARTY.btn             -row 4 -column 0 -sticky e

    grid columnconfigure .wMARTY 0 -weight 1
    grid rowconfigure .wMARTY 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wMARTY.dataBot.scroll  -width 820 -height 300 -yscrollcommand ".wMARTY.dataBot.yscroll set"
    ttk::scrollbar .wMARTY.dataBot.yscroll -command ".wMARTY.dataBot.scroll yview"

    grid .wMARTY.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wMARTY.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wMARTY.dataBot 0 -weight 1
    grid columnconfigure .wMARTY.dataBot 1 -weight 0
    grid rowconfigure .wMARTY.dataBot 0 -weight 1

    ttk::frame .wMARTY.dataBot.scroll.widgets -borderwidth 1
    grid .wMARTY.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wMARTY

    ResizeScrollFrame_wMARTY

    #-------------
    # explanations
    label .wMARTY.help.e_help -width 80 -height 3 -background LightYellow -justify center -textvariable HelpText_wMARTY
    grid  .wMARTY.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wMARTY.btn.apply  -width 10 -text [::msgcat::mc "Apply"]    -command ApplyButtonPress_wMARTY
    button .wMARTY.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wMARTY
    button .wMARTY.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wMARTY
    button .wMARTY.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wMARTY

    grid .wMARTY.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wMARTY.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wMARTY.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wMARTY.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wMARTY
}

#----------------------------------------------------------------------
#  SetLclVars_wMARTY
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wMARTY {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMARTY
    foreach {e} $AllGlobalVars_wMARTY {
        global Lcl_$e
    }
    set Lcl_numMarksTy    $numMarksTy

    for {set i 1} {$i <= $numMarksTy} {incr i} {
        set Lcl_marksType0($i)   $marksType0($i)
        set Lcl_marksType1($i)   $marksType1($i)
        set Lcl_marksType2($i)   $marksType2($i)
        set Lcl_marksType3($i)   $marksType3($i)
        set Lcl_marksType4($i)   $marksType4($i)
        set Lcl_marksType5($i)   $marksType5($i)
        set Lcl_marksType6($i)   $marksType6($i)
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wMARTY
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wMARTY {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMARTY
    foreach {e} $AllGlobalVars_wMARTY {
        global Lcl_$e
    }

    set numMarksTy    $Lcl_numMarksTy

    for {set i 1} {$i <= $numMarksTy} {incr i} {
        set marksType0($i)   $Lcl_marksType0($i)
        set marksType1($i)   $Lcl_marksType1($i)
        set marksType2($i)   $Lcl_marksType2($i)
        set marksType3($i)   $Lcl_marksType3($i)
        set marksType4($i)   $Lcl_marksType4($i)
        set marksType5($i)   $Lcl_marksType5($i)
        set marksType6($i)   $Lcl_marksType6($i)
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wMARTY
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wMARTY {} {
    global g_WingDataChanged
    global Lcl_wMARTY_DataChanged

    if { $Lcl_wMARTY_DataChanged == 1 } {
        ExportLclVars_wMARTY

        set g_WingDataChanged       1
        set Lcl_wMARTY_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wMARTY
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wMARTY {} {
    global .wMARTY
    global g_WingDataChanged
    global Lcl_wMARTY_DataChanged

    if { $Lcl_wMARTY_DataChanged == 1 } {
        ExportLclVars_wMARTY
        set g_WingDataChanged       1
        set Lcl_wMARTY_DataChanged    0
    }

    UnsetLclVarTrace_wMARTY
    destroy .wMARTY
}

#----------------------------------------------------------------------
#  CancelButtonPress_wMARTY
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wMARTY {} {
    global .wMARTY
    global g_WingDataChanged
    global Lcl_wMARTY_DataChanged

    if { $Lcl_wMARTY_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wMARTY
            return 0
        }
    }

    set Lcl_wMARTY_DataChanged 0
    UnsetLclVarTrace_wMARTY
    destroy .wMARTY

}

#----------------------------------------------------------------------
#  HelpButtonPress_wMARTY
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wMARTY {} {
    source "userHelp.tcl"

    displayHelpfile "add-marks-type-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wMARTY
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wMARTY {} {

    global AllGlobalVars_wMARTY

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wMARTY {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wMARTY }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wMARTY
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wMARTY {} {

    global AllGlobalVars_wMARTY

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wMARTY {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wMARTY }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wMARTY
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wMARTY { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wMARTY_DataChanged

    set Lcl_wMARTY_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wMARTY
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wMARTY {} {
    global .wMARTY

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMARTY
    foreach {e} $AllGlobalVars_wMARTY {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    # There's none

    #-------------
    # Config num of items
    label       .wMARTY.dataMid.spacer00 -width 5 -text ""
    grid        .wMARTY.dataMid.spacer00 -row 0 -column 0

#   Fixed number of points to 10 in version 3.14
#    button      .wMARTY.dataMid.b_decItems -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wMARTY -state disabled
#    grid        .wMARTY.dataMid.b_decItems -row 1 -column 1 -sticky e -padx 3 -pady 3

#    button      .wMARTY.dataMid.b_incItems -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wMARTY
#    grid        .wMARTY.dataMid.b_incItems -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wMARTY.dataMid.spacer20 -width 5 -text ""
    grid        .wMARTY.dataMid.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines
    label       .wMARTY.dataBot.scroll.widgets.n -width 10 -text [::msgcat::mc "Num"]
    grid        .wMARTY.dataBot.scroll.widgets.n -row 0 -column 1 -sticky e

    label       .wMARTY.dataBot.scroll.widgets.p0 -width 15 -text [::msgcat::mc "Name"]
    grid        .wMARTY.dataBot.scroll.widgets.p0 -row 0 -column 2 -sticky e

    label       .wMARTY.dataBot.scroll.widgets.p1 -width 10 -text [::msgcat::mc "Value 1"]
    grid        .wMARTY.dataBot.scroll.widgets.p1 -row 0 -column 3 -sticky e

    label       .wMARTY.dataBot.scroll.widgets.p2 -width 10 -text [::msgcat::mc "Value 2"]
    grid        .wMARTY.dataBot.scroll.widgets.p2 -row 0 -column 4 -sticky e

    label       .wMARTY.dataBot.scroll.widgets.p3 -width 10 -text [::msgcat::mc "Value 3"]
    grid        .wMARTY.dataBot.scroll.widgets.p3 -row 0 -column 5 -sticky e

    label       .wMARTY.dataBot.scroll.widgets.p4 -width 10 -text [::msgcat::mc "Value 4"]
    grid        .wMARTY.dataBot.scroll.widgets.p4 -row 0 -column 6 -sticky e

    label       .wMARTY.dataBot.scroll.widgets.p5 -width 10 -text [::msgcat::mc "Value 5"]
    grid        .wMARTY.dataBot.scroll.widgets.p5 -row 0 -column 7 -sticky e

    label       .wMARTY.dataBot.scroll.widgets.p6 -width 10 -text [::msgcat::mc "Value 6"]
    grid        .wMARTY.dataBot.scroll.widgets.p6 -row 0 -column 8 -sticky e

    #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numMarksTy } { incr i } {
        AddItemLine_wMARTY $i
    }

    UpdateItemLineButtons_wMARTY
}

#----------------------------------------------------------------------
#  DecItemLines_wMARTY
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wMARTY {} {
    global .wMARTY
    global Lcl_numMarksTy

    destroy .wMARTY.dataBot.scroll.widgets.n$Lcl_numMarksTy
    destroy .wMARTY.dataBot.scroll.widgets.e_p0$Lcl_numMarksTy
    destroy .wMARTY.dataBot.scroll.widgets.e_p1$Lcl_numMarksTy
    destroy .wMARTY.dataBot.scroll.widgets.e_p2$Lcl_numMarksTy
    destroy .wMARTY.dataBot.scroll.widgets.e_p3$Lcl_numMarksTy
    destroy .wMARTY.dataBot.scroll.widgets.e_p4$Lcl_numMarksTy
    destroy .wMARTY.dataBot.scroll.widgets.e_p5$Lcl_numMarksTy
    destroy .wMARTY.dataBot.scroll.widgets.e_p6$Lcl_numMarksTy

    incr Lcl_numMarksTy -1

    UpdateItemLineButtons_wMARTY

    ResizeScrollFrame_wMARTY
}

#----------------------------------------------------------------------
#  IncItemLines_wMARTY
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wMARTY {} {
    global .wMARTY
    global Lcl_numMarksTy

    incr Lcl_numMarksTy

    UpdateItemLineButtons_wMARTY

    # init additional variables
    CreateInitialItemLineVars_wMARTY

    AddItemLine_wMARTY $Lcl_numMarksTy

    ResizeScrollFrame_wMARTY
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wMARTY
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wMARTY {} {
    global .wMARTY
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMARTY
    foreach {e} $AllGlobalVars_wMARTY {
        global Lcl_$e
    }

    set Lcl_marksType0($Lcl_numMarksTy) 0
    set Lcl_marksType1($Lcl_numMarksTy) 0
    set Lcl_marksType2($Lcl_numMarksTy) 0
    set Lcl_marksType3($Lcl_numMarksTy) 0
    set Lcl_marksType4($Lcl_numMarksTy) 0
    set Lcl_marksType5($Lcl_numMarksTy) 0
    set Lcl_marksType6($Lcl_numMarksTy) 0
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wMARTY
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wMARTY { } {
    global .wMARTY
    global Lcl_numMarksTy

    if {$Lcl_numMarksTy > 1} {
#        .wMARTY.dataMid.b_decItems configure -state normal
    } else {
#        .wMARTY.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wMARTY
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wMARTY { lineNum } {
    global .wMARTY
    global Lcl_numMarksTy

    label       .wMARTY.dataBot.scroll.widgets.n$lineNum -width 15 -text "$lineNum"
    grid        .wMARTY.dataBot.scroll.widgets.n$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wMARTY.dataBot.scroll.widgets.e_p0$lineNum -width 15 -textvariable Lcl_marksType0($lineNum)
    SetHelpBind .wMARTY.dataBot.scroll.widgets.e_p0$lineNum [::msgcat::mc "Mark name"]   HelpText_wMARTY
    grid        .wMARTY.dataBot.scroll.widgets.e_p0$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wMARTY.dataBot.scroll.widgets.e_p1$lineNum -width 10 -textvariable Lcl_marksType1($lineNum)
    SetHelpBind .wMARTY.dataBot.scroll.widgets.e_p1$lineNum [::msgcat::mc "marksType1"]   HelpText_wMARTY
    grid        .wMARTY.dataBot.scroll.widgets.e_p1$lineNum -row [expr (4-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wMARTY.dataBot.scroll.widgets.e_p2$lineNum -width 10 -textvariable Lcl_marksType2($lineNum)
    SetHelpBind .wMARTY.dataBot.scroll.widgets.e_p2$lineNum [::msgcat::mc "marksType2"]   HelpText_wMARTY
    grid        .wMARTY.dataBot.scroll.widgets.e_p2$lineNum -row [expr (4-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wMARTY.dataBot.scroll.widgets.e_p3$lineNum -width 10 -textvariable Lcl_marksType3($lineNum)
    SetHelpBind .wMARTY.dataBot.scroll.widgets.e_p3$lineNum [::msgcat::mc "marksType3"]   HelpText_wMARTY
    grid        .wMARTY.dataBot.scroll.widgets.e_p3$lineNum -row [expr (4-1 + $lineNum)] -column 5 -sticky e -pady 1

    ttk::entry  .wMARTY.dataBot.scroll.widgets.e_p4$lineNum -width 10 -textvariable Lcl_marksType4($lineNum)
    SetHelpBind .wMARTY.dataBot.scroll.widgets.e_p4$lineNum [::msgcat::mc "marksType4"]   HelpText_wMARTY
    grid        .wMARTY.dataBot.scroll.widgets.e_p4$lineNum -row [expr (4-1 + $lineNum)] -column 6 -sticky e -pady 1

    ttk::entry  .wMARTY.dataBot.scroll.widgets.e_p5$lineNum -width 10 -textvariable Lcl_marksType5($lineNum)
    SetHelpBind .wMARTY.dataBot.scroll.widgets.e_p5$lineNum [::msgcat::mc "marksType5"]   HelpText_wMARTY
    grid        .wMARTY.dataBot.scroll.widgets.e_p5$lineNum -row [expr (4-1 + $lineNum)] -column 7 -sticky e -pady 1

    ttk::entry  .wMARTY.dataBot.scroll.widgets.e_p6$lineNum -width 10 -textvariable Lcl_marksType6($lineNum)
    SetHelpBind .wMARTY.dataBot.scroll.widgets.e_p6$lineNum [::msgcat::mc "marksType6"]   HelpText_wMARTY
    grid        .wMARTY.dataBot.scroll.widgets.e_p6$lineNum -row [expr (4-1 + $lineNum)] -column 8 -sticky e -pady 1

}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wMARTY
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wMARTY { } {
    global .wMARTY

    set framesize [grid size .wMARTY.dataBot.scroll.widgets]

    .wMARTY.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wMARTY.dataBot.scroll create window 0 0 -anchor nw -window .wMARTY.dataBot.scroll.widgets
    .wMARTY.dataBot.scroll configure -scrollregion [.wMARTY.dataBot.scroll bbox all]
}
