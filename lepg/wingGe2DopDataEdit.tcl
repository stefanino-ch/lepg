#---------------------------------------------------------------------
#
#  Window to edit the 2D DXF types (section 24)
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
global  Lcl_wGE2DOP_DataChanged
set     Lcl_wGE2DOP_DataChanged    0

global  AllGlobalVars_wGE2DOP
set     AllGlobalVars_wGE2DOP { k_section24 numGe2Dop dxf2DopA dxf2DopB dxf2DopC }

#----------------------------------------------------------------------
#  wingMarksTypesDataEdit
#  Displays a window to edit the marks types
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingGe2DopDataEdit {} {
    source "windowExplanationsHelper.tcl"
    global numGe2Dop
#    set numGe2Dop 6
    global k_section24
#    set k_section24 1

    global .wGE2DOP

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGE2DOP
    foreach {e} $AllGlobalVars_wGE2DOP {
        global Lcl_$e
    }

    SetLclVars_wGE2DOP

    toplevel .wGE2DOP
    focus .wGE2DOP

    wm protocol .wGE2DOP WM_DELETE_WINDOW { CancelButtonPress_wGE2DOP }

    wm title .wGE2DOP [::msgcat::mc "Section 24: General 2D DXF options"]

    #-------------
    # Frames and grids
    ttk::frame      .wGE2DOP.dataTop
    ttk::frame      .wGE2DOP.dataMid
    ttk::frame      .wGE2DOP.dataBot
    ttk::frame      .wGE2DOP.note
    ttk::labelframe .wGE2DOP.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wGE2DOP.btn

    #-------------
    # Place frames
    grid .wGE2DOP.dataTop         -row 0 -column 0 -sticky w
    grid .wGE2DOP.dataMid         -row 1 -column 0 -sticky w
    grid .wGE2DOP.dataBot         -row 2 -column 0 -sticky nesw
    grid .wGE2DOP.note            -row 3 -column 0 -sticky e
    grid .wGE2DOP.help            -row 4 -column 0 -sticky e
    grid .wGE2DOP.btn             -row 5 -column 0 -sticky e

    grid columnconfigure .wGE2DOP 0 -weight 1
    grid rowconfigure .wGE2DOP 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wGE2DOP.dataBot.scroll  -width 500 -height 200 -yscrollcommand ".wGE2DOP.dataBot.yscroll set"
    ttk::scrollbar .wGE2DOP.dataBot.yscroll -command ".wGE2DOP.dataBot.scroll yview"

#    grid .wGE2DOP.dataTop.n1 -row 0 -column 0 -sticky nesw
#    grid .wGE2DOP.dataTop.n2 -row 0 -column 1 -sticky nesw

    grid .wGE2DOP.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wGE2DOP.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wGE2DOP.dataBot 0 -weight 1
    grid columnconfigure .wGE2DOP.dataBot 1 -weight 0
    grid rowconfigure .wGE2DOP.dataBot 0 -weight 1

    ttk::frame .wGE2DOP.dataBot.scroll.widgets -borderwidth 1
    grid .wGE2DOP.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wGE2DOP

    ResizeScrollFrame_wGE2DOP

    #-------------
    # explanations
    label .wGE2DOP.help.e_help -width 80 -height 3 -background LightYellow -justify center -textvariable HelpText_wGE2DOP
    grid  .wGE2DOP.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wGE2DOP.btn.apply  -width 10 -text [::msgcat::mc "Apply"]    -command ApplyButtonPress_wGE2DOP
    button .wGE2DOP.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wGE2DOP
    button .wGE2DOP.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wGE2DOP
    button .wGE2DOP.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wGE2DOP

    grid .wGE2DOP.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wGE2DOP.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wGE2DOP.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wGE2DOP.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wGE2DOP
}

#----------------------------------------------------------------------
#  SetLclVars_wGE2DOP
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wGE2DOP {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGE2DOP
    foreach {e} $AllGlobalVars_wGE2DOP {
        global Lcl_$e
    }
    set Lcl_numGe2Dop    $numGe2Dop
    set Lcl_k_section24  $k_section24

    for {set i 1} {$i <= $numGe2Dop} {incr i} {
        set Lcl_dxf2DopA($i)   $dxf2DopA($i)
        set Lcl_dxf2DopB($i)   $dxf2DopB($i)
        set Lcl_dxf2DopC($i)   $dxf2DopC($i)
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wGE2DOP
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wGE2DOP {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGE2DOP
    foreach {e} $AllGlobalVars_wGE2DOP {
        global Lcl_$e
    }

    set numGe2Dop    $Lcl_numGe2Dop
    set k_section24  $Lcl_k_section24

    for {set i 1} {$i <= $numGe2Dop} {incr i} {
        set dxf2DopA($i)   $Lcl_dxf2DopA($i)
        set dxf2DopB($i)   $Lcl_dxf2DopB($i)
        set dxf2DopC($i)   $Lcl_dxf2DopC($i)
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wGE2DOP
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wGE2DOP {} {
    global g_WingDataChanged
    global Lcl_wGE2DOP_DataChanged

    if { $Lcl_wGE2DOP_DataChanged == 1 } {
        ExportLclVars_wGE2DOP

        set g_WingDataChanged       1
        set Lcl_wGE2DOP_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wGE2DOP
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wGE2DOP {} {
    global .wGE2DOP
    global g_WingDataChanged
    global Lcl_wGE2DOP_DataChanged

    if { $Lcl_wGE2DOP_DataChanged == 1 } {
        ExportLclVars_wGE2DOP
        set g_WingDataChanged       1
        set Lcl_wGE2DOP_DataChanged    0
    }

    UnsetLclVarTrace_wGE2DOP
    destroy .wGE2DOP
}

#----------------------------------------------------------------------
#  CancelButtonPress_wGE2DOP
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wGE2DOP {} {
    global .wGE2DOP
    global g_WingDataChanged
    global Lcl_wGE2DOP_DataChanged

    if { $Lcl_wGE2DOP_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wGE2DOP
            return 0
        }
    }

    set Lcl_wGE2DOP_DataChanged 0
    UnsetLclVarTrace_wGE2DOP
    destroy .wGE2DOP

}

#----------------------------------------------------------------------
#  HelpButtonPress_wGE2DOP
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wGE2DOP {} {
    source "userHelp.tcl"

    displayHelpfile "set-2D-DXF-options-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wGE2DOP
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wGE2DOP {} {

    global AllGlobalVars_wGE2DOP

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGE2DOP {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wGE2DOP }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wGE2DOP
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wGE2DOP {} {

    global AllGlobalVars_wGE2DOP

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGE2DOP {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wGE2DOP }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wGE2DOP
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wGE2DOP { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wGE2DOP_DataChanged

    set Lcl_wGE2DOP_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wGE2DOP
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wGE2DOP {} {
    global .wGE2DOP

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGE2DOP
    foreach {e} $AllGlobalVars_wGE2DOP {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    label       .wGE2DOP.dataTop.spacer00 -width 10 -text ""
    grid        .wGE2DOP.dataTop.spacer00 -row 0 -column 0 -sticky e

    label       .wGE2DOP.dataTop.p1 -width 15 -text [::msgcat::mc "Config type"]
    grid        .wGE2DOP.dataTop.p1 -row 1 -column 0 -sticky e
    ttk::entry  .wGE2DOP.dataTop.e_p1 -width 5 -textvariable Lcl_k_section24
    SetHelpBind .wGE2DOP.dataTop.e_p1 "Configuration, only type 1 available"   HelpText_wGE2DOP
    grid        .wGE2DOP.dataTop.e_p1 -row 1 -column 1 -sticky e -pady 1

    #-------------
    # Config note
    label       .wGE2DOP.note.spacer00 -width 80 -text "This is an invariant section,"
    grid        .wGE2DOP.note.spacer00 -row 0 -column 0 -sticky s
    label       .wGE2DOP.note.spacer01 -width 80 -text "the default settings are generally appropriate.\n"
    grid        .wGE2DOP.note.spacer01 -row 1 -column 0

#   Fixed number of points to 10 in version 3.14
#    button      .wGE2DOP.dataMid.b_decItems -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wGE2DOP -state disabled
#    grid        .wGE2DOP.dataMid.b_decItems -row 1 -column 1 -sticky e -padx 3 -pady 3

#    button      .wGE2DOP.dataMid.b_incItems -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wGE2DOP
#    grid        .wGE2DOP.dataMid.b_incItems -row 1 -column 2 -sticky e -padx 3 -pady 3

#    label       .wGE2DOP.dataMid.spacer20 -width 5 -text ""
#    grid        .wGE2DOP.dataMid.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines
    label       .wGE2DOP.dataBot.scroll.widgets.n -width 10 -text "Num"
    grid        .wGE2DOP.dataBot.scroll.widgets.n -row 0 -column 1 -sticky e

    label       .wGE2DOP.dataBot.scroll.widgets.p0 -width 20 -text [::msgcat::mc "Name"]
    grid        .wGE2DOP.dataBot.scroll.widgets.p0 -row 0 -column 2 -sticky e

    label       .wGE2DOP.dataBot.scroll.widgets.p1 -width 10 -text [::msgcat::mc "CAD color"]
    grid        .wGE2DOP.dataBot.scroll.widgets.p1 -row 0 -column 3 -sticky e

    label       .wGE2DOP.dataBot.scroll.widgets.p2 -width 15 -text [::msgcat::mc "Color"]
    grid        .wGE2DOP.dataBot.scroll.widgets.p2 -row 0 -column 4 -sticky e

    #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numGe2Dop } { incr i } {
        AddItemLine_wGE2DOP $i
    }

    UpdateItemLineButtons_wGE2DOP
}

#----------------------------------------------------------------------
#  DecItemLines_wGE2DOP
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wGE2DOP {} {
    global .wGE2DOP
    global Lcl_numGe2Dop

    destroy .wGE2DOP.dataBot.scroll.widgets.n$Lcl_numGe2Dop
    destroy .wGE2DOP.dataBot.scroll.widgets.e_p0$Lcl_numGe2Dop
    destroy .wGE2DOP.dataBot.scroll.widgets.e_p1$Lcl_numGe2Dop
    destroy .wGE2DOP.dataBot.scroll.widgets.e_p2$Lcl_numGe2Dop

    incr Lcl_numGe2Dop -1

    UpdateItemLineButtons_wGE2DOP

    ResizeScrollFrame_wGE2DOP
}

#----------------------------------------------------------------------
#  IncItemLines_wGE2DOP
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wGE2DOP {} {
    global .wGE2DOP
    global Lcl_numGe2Dop

    incr Lcl_numGe2Dop

    UpdateItemLineButtons_wGE2DOP

    # init additional variables
    CreateInitialItemLineVars_wGE2DOP

    AddItemLine_wGE2DOP $Lcl_numGe2Dop

    ResizeScrollFrame_wGE2DOP
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wGE2DOP
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wGE2DOP {} {
    global .wGE2DOP
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGE2DOP
    foreach {e} $AllGlobalVars_wGE2DOP {
        global Lcl_$e
    }

    set Lcl_dxf2DopA($Lcl_numGe2Dop) 0
    set Lcl_dxf2DopB($Lcl_numGe2Dop) 0
    set Lcl_dxf2DopC($Lcl_numGe2Dop) 0
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wGE2DOP
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wGE2DOP { } {
    global .wGE2DOP
    global Lcl_numGe2Dop

    if {$Lcl_numGe2Dop > 1} {
#        .wGE2DOP.dataMid.b_decItems configure -state normal
    } else {
#        .wGE2DOP.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wGE2DOP
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wGE2DOP { lineNum } {
    global .wGE2DOP

    label       .wGE2DOP.dataBot.scroll.widgets.n$lineNum -width 15 -text "$lineNum"
    grid        .wGE2DOP.dataBot.scroll.widgets.n$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wGE2DOP.dataBot.scroll.widgets.e_p0$lineNum -width 20 -textvariable Lcl_dxf2DopA($lineNum)
    SetHelpBind .wGE2DOP.dataBot.scroll.widgets.e_p0$lineNum "Element"   HelpText_wGE2DOP
    grid        .wGE2DOP.dataBot.scroll.widgets.e_p0$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wGE2DOP.dataBot.scroll.widgets.e_p1$lineNum -width 10 -textvariable Lcl_dxf2DopB($lineNum)
    SetHelpBind .wGE2DOP.dataBot.scroll.widgets.e_p1$lineNum "CAD color"   HelpText_wGE2DOP
    grid        .wGE2DOP.dataBot.scroll.widgets.e_p1$lineNum -row [expr (4-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wGE2DOP.dataBot.scroll.widgets.e_p2$lineNum -width 15 -textvariable Lcl_dxf2DopC($lineNum)
    SetHelpBind .wGE2DOP.dataBot.scroll.widgets.e_p2$lineNum "Color"   HelpText_wGE2DOP
    grid        .wGE2DOP.dataBot.scroll.widgets.e_p2$lineNum -row [expr (4-1 + $lineNum)] -column 4 -sticky e -pady 1
}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wGE2DOP
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wGE2DOP { } {
    global .wGE2DOP

    set framesize [grid size .wGE2DOP.dataBot.scroll.widgets]

    .wGE2DOP.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wGE2DOP.dataBot.scroll create window 0 0 -anchor nw -window .wGE2DOP.dataBot.scroll.widgets
    .wGE2DOP.dataBot.scroll configure -scrollregion [.wGE2DOP.dataBot.scroll bbox all]
}
