#---------------------------------------------------------------------
#
#  Window to edit the cells distribution type 4 (pre-processor)
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
global  Lcl_wCELLSD4DE_DataChanged
set     Lcl_wCELLSD4DE_DataChanged    0

global  AllGlobalVars_wCELLSD4DE
set     AllGlobalVars_wCELLSD4DE { numCellsPreProc numRibsHalfPre cellsWidth cellsOddEven }

#----------------------------------------------------------------------
#  wingAddRibPointsDataEdit
#  Displays a window to edit the cells distribution type 4
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc preCellsDis4DataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wCELLSD4DE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wCELLSD4DE
    foreach {e} $AllGlobalVars_wCELLSD4DE {
        global Lcl_$e
    }

#    global Lcl_cellsWidth

    SetLclVars_wCELLSD4DE

    toplevel .wCELLSD4DE
    focus .wCELLSD4DE

    wm protocol .wCELLSD4DE WM_DELETE_WINDOW { CancelButtonPress_wCELLSD4DE }

    wm title .wCELLSD4DE [::msgcat::mc "Set specific width for each cell"]

    #-------------
    # Frames and grids
    # ttk::frame      .wCELLSD4DE.dataTop
    ttk::frame      .wCELLSD4DE.dataMid
    ttk::frame      .wCELLSD4DE.dataBot
    ttk::labelframe .wCELLSD4DE.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wCELLSD4DE.btn

    #-------------
    # Place frames
    # grid .wCELLSD4DE.dataTop         -row 0 -column 0 -sticky w
    grid .wCELLSD4DE.dataMid         -row 1 -column 0 -sticky w
    grid .wCELLSD4DE.dataBot         -row 2 -column 0 -sticky nesw
    grid .wCELLSD4DE.help            -row 3 -column 0 -sticky e
    grid .wCELLSD4DE.btn             -row 4 -column 0 -sticky e

    grid columnconfigure .wCELLSD4DE 0 -weight 1
    grid rowconfigure .wCELLSD4DE 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wCELLSD4DE.dataBot.scroll  -width 300 -height 300 -yscrollcommand ".wCELLSD4DE.dataBot.yscroll set"
    ttk::scrollbar .wCELLSD4DE.dataBot.yscroll -command ".wCELLSD4DE.dataBot.scroll yview"

    grid .wCELLSD4DE.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wCELLSD4DE.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wCELLSD4DE.dataBot 0 -weight 1
    grid columnconfigure .wCELLSD4DE.dataBot 1 -weight 0
    grid rowconfigure .wCELLSD4DE.dataBot 0 -weight 1

    ttk::frame .wCELLSD4DE.dataBot.scroll.widgets -borderwidth 1
    grid .wCELLSD4DE.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wCELLSD4DE

    ResizeScrollFrame_wCELLSD4DE

    #-------------
    # explanations
    label .wCELLSD4DE.help.e_help -width 50 -height 3 -background LightYellow -justify left -textvariable HelpText_wCELLSD4DE
    grid  .wCELLSD4DE.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wCELLSD4DE.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wCELLSD4DE
    button .wCELLSD4DE.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wCELLSD4DE
    button .wCELLSD4DE.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wCELLSD4DE
    button .wCELLSD4DE.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wCELLSD4DE

    grid .wCELLSD4DE.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wCELLSD4DE.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wCELLSD4DE.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wCELLSD4DE.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wCELLSD4DE
}

#----------------------------------------------------------------------
#  SetLclVars_wCELLSD4DE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wCELLSD4DE {} {
    source "globalPreProcVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wCELLSD4DE
    foreach {e} $AllGlobalVars_wCELLSD4DE {
        global Lcl_$e
    }
    set Lcl_numRibsHalfPre    $numRibsHalfPre
    set Lcl_numCellsPreProc    $numCellsPreProc  

    for {set i 1} {$i <= $numRibsHalfPre} {incr i} {
        set Lcl_cellsWidth($i,1)   $cellsWidth($i,1)
        set Lcl_cellsWidth($i,2)   $cellsWidth($i,2)
    }

}

#----------------------------------------------------------------------
#  ExportLclVars_wCELLSD4DE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wCELLSD4DE {} {
    source "globalPreProcVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wCELLSD4DE
    foreach {e} $AllGlobalVars_wCELLSD4DE {
        global Lcl_$e
    }

    set numRibsHalfPre    $Lcl_numRibsHalfPre
    set numCellsPreProc    $Lcl_numCellsPreProc  

    for {set i 1} {$i <= $numRibsHalfPre} {incr i} {
        set cellsWidth($i,1)   $Lcl_cellsWidth($i,1)
        set cellsWidth($i,2)   $Lcl_cellsWidth($i,2)
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wCELLSD4DE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wCELLSD4DE {} {
    global g_WingDataChanged
    global Lcl_wCELLSD4DE_DataChanged

    if { $Lcl_wCELLSD4DE_DataChanged == 1 } {
        ExportLclVars_wCELLSD4DE

        set g_WingDataChanged       1
        set Lcl_wCELLSD4DE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wCELLSD4DE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wCELLSD4DE {} {
    global .wCELLSD4DE
    global g_WingDataChanged
    global Lcl_wCELLSD4DE_DataChanged

    if { $Lcl_wCELLSD4DE_DataChanged == 1 } {
        ExportLclVars_wCELLSD4DE
        set g_WingDataChanged       1
        set Lcl_wCELLSD4DE_DataChanged    0
    }

    UnsetLclVarTrace_wCELLSD4DE
    destroy .wCELLSD4DE
}

#----------------------------------------------------------------------
#  CancelButtonPress_wCELLSD4DE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wCELLSD4DE {} {
    global .wCELLSD4DE
    global g_WingDataChanged
    global Lcl_wCELLSD4DE_DataChanged

    if { $Lcl_wCELLSD4DE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wCELLSD4DE
            return 0
        }
    }

    set Lcl_wCELLSD4DE_DataChanged 0
    UnsetLclVarTrace_wCELLSD4DE
    destroy .wCELLSD4DE

}

#----------------------------------------------------------------------
#  HelpButtonPress_wCELLSD4DE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wCELLSD4DE {} {
    source "userHelp.tcl"

    displayHelpfile "pre-discells4-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wCELLSD4DE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wCELLSD4DE {} {

    global AllGlobalVars_wCELLSD4DE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wCELLSD4DE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wCELLSD4DE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wCELLSD4DE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wCELLSD4DE {} {

    global AllGlobalVars_wCELLSD4DE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wCELLSD4DE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wCELLSD4DE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wCELLSD4DE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wCELLSD4DE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wCELLSD4DE_DataChanged

    set Lcl_wCELLSD4DE_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wCELLSD4DE
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wCELLSD4DE {} {
    global .wCELLSD4DE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wCELLSD4DE
    foreach {e} $AllGlobalVars_wCELLSD4DE {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    # There's none

    #-------------
    # Config num of items
    label       .wCELLSD4DE.dataMid.spacer00 -width 5 -text ""
    grid        .wCELLSD4DE.dataMid.spacer00 -row 0 -column 0

    button      .wCELLSD4DE.dataMid.b_decItems -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wCELLSD4DE -state disabled
    grid        .wCELLSD4DE.dataMid.b_decItems -row 1 -column 1 -sticky e -padx 3 -pady 3

    button      .wCELLSD4DE.dataMid.b_incItems -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wCELLSD4DE
    grid        .wCELLSD4DE.dataMid.b_incItems -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wCELLSD4DE.dataMid.spacer20 -width 5 -text ""
    grid        .wCELLSD4DE.dataMid.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines
    label       .wCELLSD4DE.dataBot.scroll.widgets.n -width 10 -text [::msgcat::mc "Num"]
    grid        .wCELLSD4DE.dataBot.scroll.widgets.n -row 0 -column 1 -sticky e

    label       .wCELLSD4DE.dataBot.scroll.widgets.pY -width 10 -text [::msgcat::mc "Width"]
    grid        .wCELLSD4DE.dataBot.scroll.widgets.pY -row 0 -column 2 -sticky e

        #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numRibsHalfPre } { incr i } {
        AddItemLine_wCELLSD4DE $i
    }

    # REVISAR................................!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Set x-coordinates
    set Lcl_cellsWidth(1,1) [expr ($Lcl_cellsWidth(1,2) / 2.)]

    set i 2
    while { $i <= $Lcl_numRibsHalfPre } {
    set Lcl_cellsWidth($i,1) [expr ($Lcl_cellsWidth([expr ($i -1)],1) + $Lcl_cellsWidth($i,2))]
    incr i
    }
  
    # Set more parameters
    if { $Lcl_cellsWidth(1,1) != 0.0 } {
    set Lcl_cellsOddEven 1
    } else {
    set Lcl_cellsOddEven 0
    }

    # Set numCellsPreProc
    if { $Lcl_cellsOddEven == 0 } {
    set Lcl_numCellsPreProc [expr (($Lcl_numRibsHalfPre -1)*2.0)]
    } else {
    set Lcl_numCellsPreProc [expr (($Lcl_numRibsHalfPre*2.0) -1)]
    }

    # Normalize widths


    UpdateItemLineButtons_wCELLSD4DE
}

#----------------------------------------------------------------------
#  DecItemLines_wCELLSD4DE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wCELLSD4DE {} {
    global .wCELLSD4DE
    global Lcl_numRibsHalfPre

    destroy .wCELLSD4DE.dataBot.scroll.widgets.n$Lcl_numRibsHalfPre
    destroy .wCELLSD4DE.dataBot.scroll.widgets.e_pX$Lcl_numRibsHalfPre
    destroy .wCELLSD4DE.dataBot.scroll.widgets.e_pY$Lcl_numRibsHalfPre

    incr Lcl_numRibsHalfPre -1

    UpdateItemLineButtons_wCELLSD4DE

    ResizeScrollFrame_wCELLSD4DE
}

#----------------------------------------------------------------------
#  IncItemLines_wCELLSD4DE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wCELLSD4DE {} {
    global .wCELLSD4DE
    global Lcl_numRibsHalfPre

    incr Lcl_numRibsHalfPre

    UpdateItemLineButtons_wCELLSD4DE

    # init additional variables
    CreateInitialItemLineVars_wCELLSD4DE

    AddItemLine_wCELLSD4DE $Lcl_numRibsHalfPre

    ResizeScrollFrame_wCELLSD4DE
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wCELLSD4DE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wCELLSD4DE {} {
    global .wCELLSD4DE
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wCELLSD4DE
    foreach {e} $AllGlobalVars_wCELLSD4DE {
        global Lcl_$e
    }

    set Lcl_cellsWidth($Lcl_numRibsHalfPre) 0
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wCELLSD4DE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wCELLSD4DE { } {
    global .wCELLSD4DE
    global Lcl_numRibsHalfPre

    if {$Lcl_numRibsHalfPre > 1} {
        .wCELLSD4DE.dataMid.b_decItems configure -state normal
    } else {
        .wCELLSD4DE.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wCELLSD4DE
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wCELLSD4DE { lineNum } {
    global .wCELLSD4DE
    global Lcl_numRibsHalfPre

    label       .wCELLSD4DE.dataBot.scroll.widgets.n$lineNum -width 15 -text "$lineNum"
    grid        .wCELLSD4DE.dataBot.scroll.widgets.n$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wCELLSD4DE.dataBot.scroll.widgets.e_pY$lineNum -width 20 -textvariable Lcl_cellsWidth($lineNum,2)
    SetHelpBind .wCELLSD4DE.dataBot.scroll.widgets.e_pY$lineNum cellsWidth   HelpText_wCELLSD4DE
    grid        .wCELLSD4DE.dataBot.scroll.widgets.e_pY$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1
}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wCELLSD4DE
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wCELLSD4DE { } {
    global .wCELLSD4DE

    set framesize [grid size .wCELLSD4DE.dataBot.scroll.widgets]

    .wCELLSD4DE.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wCELLSD4DE.dataBot.scroll create window 0 0 -anchor nw -window .wCELLSD4DE.dataBot.scroll.widgets
    .wCELLSD4DE.dataBot.scroll configure -scrollregion [.wCELLSD4DE.dataBot.scroll bbox all]
}
