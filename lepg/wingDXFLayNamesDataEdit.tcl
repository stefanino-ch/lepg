#---------------------------------------------------------------------
#
#  Window to edit the dxf layer names
#
#  Pere Casellas
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wDXFLN_DataChanged
set     Lcl_wDXFLN_DataChanged    0

global  AllGlobalVars_wDXFLN
set     AllGlobalVars_wDXFLN { numDXFLayNa dxfLayNaX dxfLayNaY }

#----------------------------------------------------------------------
#  wingDXFLayNamesDataEdit
#  Displays a window to edit the additional rib points
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingDXFLayNamesDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wDXFLN

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wDXFLN
    foreach {e} $AllGlobalVars_wDXFLN {
        global Lcl_$e
    }

    SetLclVars_wDXFLN

    toplevel .wDXFLN
    focus .wDXFLN

    wm protocol .wDXFLN WM_DELETE_WINDOW { CancelButtonPress_wDXFLN }

    wm title .wDXFLN [::msgcat::mc "Section 19: DXF layer names configuration"]

    #-------------
    # Frames and grids
    # ttk::frame      .wDXFLN.dataTop
    ttk::frame      .wDXFLN.dataMid
    ttk::frame      .wDXFLN.dataBot
    ttk::labelframe .wDXFLN.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wDXFLN.btn

    #-------------
    # Place frames
    # grid .wDXFLN.dataTop         -row 0 -column 0 -sticky w
    grid .wDXFLN.dataMid         -row 1 -column 0 -sticky w
    grid .wDXFLN.dataBot         -row 2 -column 0 -sticky nesw
    grid .wDXFLN.help            -row 3 -column 0 -sticky e
    grid .wDXFLN.btn             -row 4 -column 0 -sticky e

    grid columnconfigure .wDXFLN 0 -weight 1
    grid rowconfigure .wDXFLN 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wDXFLN.dataBot.scroll  -width 300 -height 300 -yscrollcommand ".wDXFLN.dataBot.yscroll set"
    ttk::scrollbar .wDXFLN.dataBot.yscroll -command ".wDXFLN.dataBot.scroll yview"

    grid .wDXFLN.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wDXFLN.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wDXFLN.dataBot 0 -weight 1
    grid columnconfigure .wDXFLN.dataBot 1 -weight 0
    grid rowconfigure .wDXFLN.dataBot 0 -weight 1

    ttk::frame .wDXFLN.dataBot.scroll.widgets -borderwidth 1
    grid .wDXFLN.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wDXFLN

    ResizeScrollFrame_wDXFLN

    #-------------
    # explanations
    label .wDXFLN.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wDXFLN
    grid  .wDXFLN.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wDXFLN.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wDXFLN
    button .wDXFLN.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wDXFLN
    button .wDXFLN.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wDXFLN
    button .wDXFLN.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wDXFLN

    grid .wDXFLN.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wDXFLN.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wDXFLN.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wDXFLN.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wDXFLN
}

#----------------------------------------------------------------------
#  SetLclVars_wDXFLN
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wDXFLN {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wDXFLN
    foreach {e} $AllGlobalVars_wDXFLN {
        global Lcl_$e
    }
    set Lcl_numDXFLayNa    $numDXFLayNa

    for {set i 1} {$i <= $numDXFLayNa} {incr i} {
        set Lcl_dxfLayNaX($i)   $dxfLayNaX($i)
        set Lcl_dxfLayNaY($i)   $dxfLayNaY($i)
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wDXFLN
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wDXFLN {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wDXFLN
    foreach {e} $AllGlobalVars_wDXFLN {
        global Lcl_$e
    }

    set numDXFLayNa    $Lcl_numDXFLayNa

    for {set i 1} {$i <= $numDXFLayNa} {incr i} {
        set dxfLayNaX($i)   $Lcl_dxfLayNaX($i)
        set dxfLayNaY($i)   $Lcl_dxfLayNaY($i)
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wDXFLN
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wDXFLN {} {
    global g_WingDataChanged
    global Lcl_wDXFLN_DataChanged

    if { $Lcl_wDXFLN_DataChanged == 1 } {
        ExportLclVars_wDXFLN

        set g_WingDataChanged       1
        set Lcl_wDXFLN_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wDXFLN
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wDXFLN {} {
    global .wDXFLN
    global g_WingDataChanged
    global Lcl_wDXFLN_DataChanged

    if { $Lcl_wDXFLN_DataChanged == 1 } {
        ExportLclVars_wDXFLN
        set g_WingDataChanged       1
        set Lcl_wDXFLN_DataChanged    0
    }

    UnsetLclVarTrace_wDXFLN
    destroy .wDXFLN
}

#----------------------------------------------------------------------
#  CancelButtonPress_wDXFLN
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wDXFLN {} {
    global .wDXFLN
    global g_WingDataChanged
    global Lcl_wDXFLN_DataChanged

    if { $Lcl_wDXFLN_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wDXFLN
            return 0
        }
    }

    set Lcl_wDXFLN_DataChanged 0
    UnsetLclVarTrace_wDXFLN
    destroy .wDXFLN

}

#----------------------------------------------------------------------
#  HelpButtonPress_wDXFLN
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wDXFLN {} {
    source "userHelp.tcl"

    displayHelpfile "add-layer-names-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wDXFLN
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wDXFLN {} {

    global AllGlobalVars_wDXFLN

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wDXFLN {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wDXFLN }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wDXFLN
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wDXFLN {} {

    global AllGlobalVars_wDXFLN

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wDXFLN {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wDXFLN }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wDXFLN
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wDXFLN { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wDXFLN_DataChanged

    set Lcl_wDXFLN_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wDXFLN
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wDXFLN {} {
    global .wDXFLN

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wDXFLN
    foreach {e} $AllGlobalVars_wDXFLN {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    # There's none

    #-------------
    # Config num of items
    label       .wDXFLN.dataMid.spacer00 -width 5 -text ""
    grid        .wDXFLN.dataMid.spacer00 -row 0 -column 0

    button      .wDXFLN.dataMid.b_decItems -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wDXFLN -state disabled
    grid        .wDXFLN.dataMid.b_decItems -row 1 -column 1 -sticky e -padx 3 -pady 3

    button      .wDXFLN.dataMid.b_incItems -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wDXFLN
    grid        .wDXFLN.dataMid.b_incItems -row 1 -column 2 -sticky e -padx 3 -pady 3

    label       .wDXFLN.dataMid.spacer20 -width 5 -text ""
    grid        .wDXFLN.dataMid.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines
    label       .wDXFLN.dataBot.scroll.widgets.n -width 10 -text "Num"
    grid        .wDXFLN.dataBot.scroll.widgets.n -row 0 -column 1 -sticky e

    label       .wDXFLN.dataBot.scroll.widgets.pX -width 20 -text [::msgcat::mc "Drawn object"]
    grid        .wDXFLN.dataBot.scroll.widgets.pX -row 0 -column 2 -sticky e

    label       .wDXFLN.dataBot.scroll.widgets.pY -width 20 -text [::msgcat::mc "Layer name"]
    grid        .wDXFLN.dataBot.scroll.widgets.pY -row 0 -column 3 -sticky e

        #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numDXFLayNa } { incr i } {
        AddItemLine_wDXFLN $i
    }

    UpdateItemLineButtons_wDXFLN
}

#----------------------------------------------------------------------
#  DecItemLines_wDXFLN
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wDXFLN {} {
    global .wDXFLN
    global Lcl_numDXFLayNa

    destroy .wDXFLN.dataBot.scroll.widgets.n$Lcl_numDXFLayNa
    destroy .wDXFLN.dataBot.scroll.widgets.e_pX$Lcl_numDXFLayNa
    destroy .wDXFLN.dataBot.scroll.widgets.e_pY$Lcl_numDXFLayNa

    incr Lcl_numDXFLayNa -1

    UpdateItemLineButtons_wDXFLN

    ResizeScrollFrame_wDXFLN
}

#----------------------------------------------------------------------
#  IncItemLines_wDXFLN
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wDXFLN {} {
    global .wDXFLN
    global Lcl_numDXFLayNa

    incr Lcl_numDXFLayNa

    UpdateItemLineButtons_wDXFLN

    # init additional variables
    CreateInitialItemLineVars_wDXFLN

    AddItemLine_wDXFLN $Lcl_numDXFLayNa

    ResizeScrollFrame_wDXFLN
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wDXFLN
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wDXFLN {} {
    global .wDXFLN
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wDXFLN
    foreach {e} $AllGlobalVars_wDXFLN {
        global Lcl_$e
    }

    set Lcl_dxfLayNaX($Lcl_numDXFLayNa) 0
    set Lcl_dxfLayNaY($Lcl_numDXFLayNa) 0
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wDXFLN
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wDXFLN { } {
    global .wDXFLN
    global Lcl_numDXFLayNa

    if {$Lcl_numDXFLayNa > 1} {
        .wDXFLN.dataMid.b_decItems configure -state normal
    } else {
        .wDXFLN.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wDXFLN
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wDXFLN { lineNum } {
    global .wDXFLN
    global Lcl_numDXFLayNa

    label       .wDXFLN.dataBot.scroll.widgets.n$lineNum -width 15 -text "$lineNum"
    grid        .wDXFLN.dataBot.scroll.widgets.n$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wDXFLN.dataBot.scroll.widgets.e_pX$lineNum -width 20 -textvariable Lcl_dxfLayNaX($lineNum)
    SetHelpBind .wDXFLN.dataBot.scroll.widgets.e_pX$lineNum dxfLayNaX   HelpText_wDXFLN
    grid        .wDXFLN.dataBot.scroll.widgets.e_pX$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wDXFLN.dataBot.scroll.widgets.e_pY$lineNum -width 20 -textvariable Lcl_dxfLayNaY($lineNum)
    SetHelpBind .wDXFLN.dataBot.scroll.widgets.e_pY$lineNum dxfLayNaY   HelpText_wDXFLN
    grid        .wDXFLN.dataBot.scroll.widgets.e_pY$lineNum -row [expr (4-1 + $lineNum)] -column 3 -sticky e -pady 1
}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wDXFLN
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wDXFLN { } {
    global .wDXFLN

    set framesize [grid size .wDXFLN.dataBot.scroll.widgets]

    .wDXFLN.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wDXFLN.dataBot.scroll create window 0 0 -anchor nw -window .wDXFLN.dataBot.scroll.widgets
    .wDXFLN.dataBot.scroll configure -scrollregion [.wDXFLN.dataBot.scroll bbox all]
}
