#---------------------------------------------------------------------
#
#  Window to edit the matrix og geometry
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wMATRIXGE_DataChanged
set     Lcl_wMATRIXGE_DataChanged    0

global  AllGlobalVars_wMATRIXGE
set     AllGlobalVars_wMATRIXGE { numRibsHalf ribConfig }

#----------------------------------------------------------------------
#  wingAddRibPointsDataEdit
#  Displays a window to edit the additional rib points
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingMatrixGeoDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wMATRIXGE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMATRIXGE
    foreach {e} $AllGlobalVars_wMATRIXGE {
        global Lcl_$e
    }

    SetLclVars_wMATRIXGE

    toplevel .wMATRIXGE
    focus .wMATRIXGE

    wm protocol .wMATRIXGE WM_DELETE_WINDOW { CancelButtonPress_wMATRIXGE }

    wm title .wMATRIXGE [::msgcat::mc "01C. Matrix of geometry edit"]

    #-------------
    # Frames and grids
    # ttk::frame      .wMATRIXGE.dataTop
    ttk::frame      .wMATRIXGE.dataMid
    ttk::frame      .wMATRIXGE.dataBot
    ttk::labelframe .wMATRIXGE.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wMATRIXGE.btn

    #-------------
    # Place frames
    # grid .wMATRIXGE.dataTop         -row 0 -column 0 -sticky w
    grid .wMATRIXGE.dataMid         -row 1 -column 0 -sticky w
    grid .wMATRIXGE.dataBot         -row 2 -column 0 -sticky nesw
    grid .wMATRIXGE.help            -row 3 -column 0 -sticky e
    grid .wMATRIXGE.btn             -row 4 -column 0 -sticky e

    grid columnconfigure .wMATRIXGE 0 -weight 1
    grid rowconfigure .wMATRIXGE 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wMATRIXGE.dataBot.scroll  -width 400 -height 400 -yscrollcommand ".wMATRIXGE.dataBot.yscroll set"
    ttk::scrollbar .wMATRIXGE.dataBot.yscroll -command ".wMATRIXGE.dataBot.scroll yview"

    grid .wMATRIXGE.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wMATRIXGE.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wMATRIXGE.dataBot 0 -weight 1
    grid columnconfigure .wMATRIXGE.dataBot 1 -weight 0
    grid rowconfigure .wMATRIXGE.dataBot 0 -weight 1

    ttk::frame .wMATRIXGE.dataBot.scroll.widgets -borderwidth 1
    grid .wMATRIXGE.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wMATRIXGE

    ResizeScrollFrame_wMATRIXGE

    #-------------
    # explanations
    label .wMATRIXGE.help.e_help -width 100 -height 3 -background LightYellow -justify left -textvariable HelpText_wMATRIXGE
    grid  .wMATRIXGE.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wMATRIXGE.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wMATRIXGE
    button .wMATRIXGE.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wMATRIXGE
    button .wMATRIXGE.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wMATRIXGE
    button .wMATRIXGE.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wMATRIXGE

    grid .wMATRIXGE.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wMATRIXGE.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wMATRIXGE.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wMATRIXGE.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wMATRIXGE
}

#----------------------------------------------------------------------
#  SetLclVars_wMATRIXGE
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wMATRIXGE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMATRIXGE
    foreach {e} $AllGlobalVars_wMATRIXGE {
        global Lcl_$e
    }
    set Lcl_numRibsHalf    $numRibsHalf

    for {set i 1} {$i <= $numRibsHalf} {incr i} {
        foreach k {1 2 3 4 6 7 9 10 51} {
        set Lcl_ribConfig($i,$k)   $ribConfig($i,$k)
        }
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wMATRIXGE
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wMATRIXGE {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMATRIXGE
    foreach {e} $AllGlobalVars_wMATRIXGE {
        global Lcl_$e
    }

    set numRibsHalf    $Lcl_numRibsHalf

    for {set i 1} {$i <= $numRibsHalf} {incr i} {
        foreach k {1 2 3 4 6 7 9 10 51} {
        set ribConfig($i,$k)   $Lcl_ribConfig($i,$k)
        }
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wMATRIXGE
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wMATRIXGE {} {
    global g_WingDataChanged
    global Lcl_wMATRIXGE_DataChanged

    if { $Lcl_wMATRIXGE_DataChanged == 1 } {
        ExportLclVars_wMATRIXGE

        set g_WingDataChanged       1
        set Lcl_wMATRIXGE_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wMATRIXGE
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wMATRIXGE {} {
    global .wMATRIXGE
    global g_WingDataChanged
    global Lcl_wMATRIXGE_DataChanged

    if { $Lcl_wMATRIXGE_DataChanged == 1 } {
        ExportLclVars_wMATRIXGE
        set g_WingDataChanged       1
        set Lcl_wMATRIXGE_DataChanged    0
    }

    UnsetLclVarTrace_wMATRIXGE
    destroy .wMATRIXGE
}

#----------------------------------------------------------------------
#  CancelButtonPress_wMATRIXGE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wMATRIXGE {} {
    global .wMATRIXGE
    global g_WingDataChanged
    global Lcl_wMATRIXGE_DataChanged

    if { $Lcl_wMATRIXGE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wMATRIXGE
            return 0
        }
    }

    set Lcl_wMATRIXGE_DataChanged 0
    UnsetLclVarTrace_wMATRIXGE
    destroy .wMATRIXGE

}

#----------------------------------------------------------------------
#  HelpButtonPress_wMATRIXGE
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wMATRIXGE {} {
    source "userHelp.tcl"

    displayHelpfile "geometry-matrix-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wMATRIXGE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wMATRIXGE {} {

    global AllGlobalVars_wMATRIXGE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wMATRIXGE {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wMATRIXGE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wMATRIXGE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wMATRIXGE {} {

    global AllGlobalVars_wMATRIXGE

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wMATRIXGE {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wMATRIXGE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wMATRIXGE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wMATRIXGE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wMATRIXGE_DataChanged

    set Lcl_wMATRIXGE_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wMATRIXGE
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wMATRIXGE {} {
    global .wMATRIXGE

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMATRIXGE
    foreach {e} $AllGlobalVars_wMATRIXGE {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    # There's none

    #-------------
    # Config num of items
    label       .wMATRIXGE.dataMid.spacer00 -width 5 -text ""
    grid        .wMATRIXGE.dataMid.spacer00 -row 0 -column 0

#    button      .wMATRIXGE.dataMid.b_decItems -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wMATRIXGE -state disabled
#    grid        .wMATRIXGE.dataMid.b_decItems -row 1 -column 1 -sticky e -padx 3 -pady 3

#    button      .wMATRIXGE.dataMid.b_incItems -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wMATRIXGE
#    grid        .wMATRIXGE.dataMid.b_incItems -row 1 -column 2 -sticky e -padx 3 -pady 3

#    label       .wMATRIXGE.dataMid.spacer20 -width 5 -text ""
#    grid        .wMATRIXGE.dataMid.spacer20 -row 2 -column 0

    #-------------
    # header for the item lines

    label       .wMATRIXGE.dataMid.spacerr -width 10 -text ""
    grid        .wMATRIXGE.dataMid.spacerr -row 3 -column 9 -sticky e

    label       .wMATRIXGE.dataMid.n1 -width 10 -text "Num"
    grid        .wMATRIXGE.dataMid.n1 -row 3 -column 0 -sticky e

    label       .wMATRIXGE.dataMid.n2 -width 10 -text [::msgcat::mc "x-rib"]
    grid        .wMATRIXGE.dataMid.n2 -row 3 -column 1 -sticky e

    label       .wMATRIXGE.dataMid.n3 -width 10 -text [::msgcat::mc "y-LE"]
    grid        .wMATRIXGE.dataMid.n3 -row 3 -column 2 -sticky e

    label       .wMATRIXGE.dataMid.n4 -width 10 -text [::msgcat::mc "y-TE"]
    grid        .wMATRIXGE.dataMid.n4 -row 3 -column 3 -sticky e 

    label       .wMATRIXGE.dataMid.n5 -width 10 -text [::msgcat::mc "xp"]
    grid        .wMATRIXGE.dataMid.n5 -row 3 -column 4 -sticky e

    label       .wMATRIXGE.dataMid.n6 -width 10 -text [::msgcat::mc "z"]
    grid        .wMATRIXGE.dataMid.n6 -row 3 -column 5 -sticky e

    label       .wMATRIXGE.dataMid.n7 -width 10 -text [::msgcat::mc "beta"]
    grid        .wMATRIXGE.dataMid.n7 -row 3 -column 6 -sticky e

    label       .wMATRIXGE.dataMid.n8 -width 10 -text [::msgcat::mc "RP"]
    grid        .wMATRIXGE.dataMid.n8 -row 3 -column 7 -sticky e

    label       .wMATRIXGE.dataMid.n9 -width 10 -text [::msgcat::mc "washin"]
    grid        .wMATRIXGE.dataMid.n9 -row 3 -column 8 -sticky e


        #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numRibsHalf } { incr i } {
        AddItemLine_wMATRIXGE $i
    }

#    UpdateItemLineButtons_wMATRIXGE
}

#----------------------------------------------------------------------
#  DecItemLines_wMATRIXGE
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wMATRIXGE {} {
    global .wMATRIXGE
    global Lcl_numRibsHalf

    destroy .wMATRIXGE.dataBot.scroll.widgets.e_n1$Lcl_numRibsHalf
    destroy .wMATRIXGE.dataBot.scroll.widgets.e_n2$Lcl_numRibsHalf
    destroy .wMATRIXGE.dataBot.scroll.widgets.e_n3$Lcl_numRibsHalf
    destroy .wMATRIXGE.dataBot.scroll.widgets.e_n4$Lcl_numRibsHalf
    destroy .wMATRIXGE.dataBot.scroll.widgets.e_n5$Lcl_numRibsHalf
    destroy .wMATRIXGE.dataBot.scroll.widgets.e_n6$Lcl_numRibsHalf
    destroy .wMATRIXGE.dataBot.scroll.widgets.e_n7$Lcl_numRibsHalf
    destroy .wMATRIXGE.dataBot.scroll.widgets.e_n8$Lcl_numRibsHalf
    destroy .wMATRIXGE.dataBot.scroll.widgets.e_n9$Lcl_numRibsHalf

    incr Lcl_numRibsHalf -1

    UpdateItemLineButtons_wMATRIXGE

    ResizeScrollFrame_wMATRIXGE
}

#----------------------------------------------------------------------
#  IncItemLines_wMATRIXGE
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wMATRIXGE {} {
    global .wMATRIXGE
    global Lcl_numRibsHalf

    incr Lcl_numRibsHalf

    UpdateItemLineButtons_wMATRIXGE

    # init additional variables
    CreateInitialItemLineVars_wMATRIXGE

    AddItemLine_wMATRIXGE $Lcl_numRibsHalf

    ResizeScrollFrame_wMATRIXGE
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wMATRIXGE
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wMATRIXGE {} {
    global .wMATRIXGE
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wMATRIXGE
    foreach {e} $AllGlobalVars_wMATRIXGE {
        global Lcl_$e
    }

    foreach k {2 3 4 6 7 9 10 51} {
    set Lcl_ribConfig($Lcl_numRibsHalf,$k) 0
    }
    set Lcl_ribConfig($Lcl_numRibsHalf,1) $Lcl_numRibsHalf
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wMATRIXGE
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wMATRIXGE { } {
    global .wMATRIXGE
    global Lcl_numRibsHalf

    if {$Lcl_numRibsHalf > 1} {
        .wMATRIXGE.dataMid.b_decItems configure -state normal
    } else {
        .wMATRIXGE.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wMATRIXGE
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wMATRIXGE { lineNum } {
    global .wMATRIXGE
    global Lcl_numRibsHalf

    ttk::entry  .wMATRIXGE.dataBot.scroll.widgets.e_n1$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,1)
    SetHelpBind .wMATRIXGE.dataBot.scroll.widgets.e_n1$lineNum [::msgcat::mc "Rib number"] HelpText_wMATRIXGE
    grid        .wMATRIXGE.dataBot.scroll.widgets.e_n1$lineNum -row [expr (4-1 + $lineNum)] -column 0 -sticky e -pady 1

    ttk::entry  .wMATRIXGE.dataBot.scroll.widgets.e_n2$lineNum -width 13 -textvariable Lcl_ribConfig($lineNum,2)
    SetHelpBind .wMATRIXGE.dataBot.scroll.widgets.e_n2$lineNum [::msgcat::mc "Rib x-coordinate (cm)"] HelpText_wMATRIXGE
    grid        .wMATRIXGE.dataBot.scroll.widgets.e_n2$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wMATRIXGE.dataBot.scroll.widgets.e_n3$lineNum -width 13 -textvariable Lcl_ribConfig($lineNum,3)
    SetHelpBind .wMATRIXGE.dataBot.scroll.widgets.e_n3$lineNum [::msgcat::mc "Rib leading edge y-coordinate (cm)"] HelpText_wMATRIXGE
    grid        .wMATRIXGE.dataBot.scroll.widgets.e_n3$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wMATRIXGE.dataBot.scroll.widgets.e_n4$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,4)
    SetHelpBind .wMATRIXGE.dataBot.scroll.widgets.e_n4$lineNum [::msgcat::mc "Rib trailing edge coordinate (cm)"] HelpText_wMATRIXGE
    grid        .wMATRIXGE.dataBot.scroll.widgets.e_n4$lineNum -row [expr (4-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wMATRIXGE.dataBot.scroll.widgets.e_n5$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,6)
    SetHelpBind .wMATRIXGE.dataBot.scroll.widgets.e_n5$lineNum [::msgcat::mc "Rib x-coordinate in space (xp < x) (cm)"] HelpText_wMATRIXGE
    grid        .wMATRIXGE.dataBot.scroll.widgets.e_n5$lineNum -row [expr (4-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wMATRIXGE.dataBot.scroll.widgets.e_n6$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,7)
    SetHelpBind .wMATRIXGE.dataBot.scroll.widgets.e_n6$lineNum [::msgcat::mc "Rib z-coordinate (cm)"] HelpText_wMATRIXGE
    grid        .wMATRIXGE.dataBot.scroll.widgets.e_n6$lineNum -row [expr (4-1 + $lineNum)] -column 5 -sticky e -pady 1

    ttk::entry  .wMATRIXGE.dataBot.scroll.widgets.e_n7$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,9)
    SetHelpBind .wMATRIXGE.dataBot.scroll.widgets.e_n7$lineNum [::msgcat::mc "Inclination of the rib plane respect to the vertical (deg)"] HelpText_wMATRIXGE
    grid        .wMATRIXGE.dataBot.scroll.widgets.e_n7$lineNum -row [expr (4-1 + $lineNum)] -column 6 -sticky e -pady 1

    ttk::entry  .wMATRIXGE.dataBot.scroll.widgets.e_n8$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,10)
    SetHelpBind .wMATRIXGE.dataBot.scroll.widgets.e_n8$lineNum [::msgcat::mc "Washin rotation point along chord (percent)"] HelpText_wMATRIXGE
    grid        .wMATRIXGE.dataBot.scroll.widgets.e_n8$lineNum -row [expr (4-1 + $lineNum)] -column 7 -sticky e -pady 1

    ttk::entry  .wMATRIXGE.dataBot.scroll.widgets.e_n9$lineNum -width 10 -textvariable Lcl_ribConfig($lineNum,51)
    SetHelpBind .wMATRIXGE.dataBot.scroll.widgets.e_n9$lineNum [::msgcat::mc "Washin angle (deg)"]  HelpText_wMATRIXGE
    grid        .wMATRIXGE.dataBot.scroll.widgets.e_n9$lineNum -row [expr (4-1 + $lineNum)] -column 8 -sticky e -pady 1



}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wMATRIXGE
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wMATRIXGE { } {
    global .wMATRIXGE

    set framesize [grid size .wMATRIXGE.dataBot.scroll.widgets]

    .wMATRIXGE.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wMATRIXGE.dataBot.scroll create window 0 0 -anchor nw -window .wMATRIXGE.dataBot.scroll.widgets
    .wMATRIXGE.dataBot.scroll configure -scrollregion [.wMATRIXGE.dataBot.scroll bbox all]
}
