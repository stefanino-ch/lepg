#---------------------------------------------------------------------
#
#  Window to edit glue vents (section 26)
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
global  Lcl_wGLUEVEN_DataChanged
set     Lcl_wGLUEVEN_DataChanged    0

global  AllGlobalVars_wGLUEVEN
set     AllGlobalVars_wGLUEVEN { k_section26 numRibsHalf glueVenA glueVenB }

#----------------------------------------------------------------------
#  wingMarksTypesDataEdit
#  Displays a window to edit the marks types
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingGlueVenDataEdit {} {
    source "windowExplanationsHelper.tcl"
    global numRibsHalf
    global k_section26

    global .wGLUEVEN

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGLUEVEN
    foreach {e} $AllGlobalVars_wGLUEVEN {
        global Lcl_$e
    }

    SetLclVars_wGLUEVEN

    toplevel .wGLUEVEN
    focus .wGLUEVEN

    wm protocol .wGLUEVEN WM_DELETE_WINDOW { CancelButtonPress_wGLUEVEN }

    wm title .wGLUEVEN [::msgcat::mc "Section 26: Glue vents"]

    #-------------
    # Frames and grids
    ttk::frame      .wGLUEVEN.dataTop
    ttk::frame      .wGLUEVEN.dataMid
    ttk::frame      .wGLUEVEN.dataBot
    ttk::frame      .wGLUEVEN.note
    ttk::labelframe .wGLUEVEN.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wGLUEVEN.btn

    #-------------
    # Place frames
    grid .wGLUEVEN.dataTop         -row 0 -column 0 -sticky w
    grid .wGLUEVEN.dataMid         -row 1 -column 0 -sticky w
    grid .wGLUEVEN.dataBot         -row 2 -column 0 -sticky nesw
    grid .wGLUEVEN.note            -row 3 -column 0 -sticky e
    grid .wGLUEVEN.help            -row 4 -column 0 -sticky e
    grid .wGLUEVEN.btn             -row 5 -column 0 -sticky e

    grid columnconfigure .wGLUEVEN 0 -weight 1
    grid rowconfigure .wGLUEVEN 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wGLUEVEN.dataBot.scroll  -width 500 -height 400 -yscrollcommand ".wGLUEVEN.dataBot.yscroll set"
    ttk::scrollbar .wGLUEVEN.dataBot.yscroll -command ".wGLUEVEN.dataBot.scroll yview"

#    grid .wGLUEVEN.dataTop.n1 -row 0 -column 0 -sticky nesw
#    grid .wGLUEVEN.dataTop.n2 -row 0 -column 1 -sticky nesw

    grid .wGLUEVEN.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wGLUEVEN.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wGLUEVEN.dataBot 0 -weight 1
    grid columnconfigure .wGLUEVEN.dataBot 1 -weight 0
    grid rowconfigure .wGLUEVEN.dataBot 0 -weight 1

    ttk::frame .wGLUEVEN.dataBot.scroll.widgets -borderwidth 1
    grid .wGLUEVEN.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wGLUEVEN

    ResizeScrollFrame_wGLUEVEN

    #-------------
    # explanations
    label .wGLUEVEN.help.e_help -width 80 -height 3 -background LightYellow -justify center -textvariable HelpText_wGLUEVEN
    grid  .wGLUEVEN.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wGLUEVEN.btn.apply  -width 10 -text [::msgcat::mc "Apply"]    -command ApplyButtonPress_wGLUEVEN
    button .wGLUEVEN.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wGLUEVEN
    button .wGLUEVEN.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wGLUEVEN
    button .wGLUEVEN.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wGLUEVEN

    grid .wGLUEVEN.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wGLUEVEN.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wGLUEVEN.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wGLUEVEN.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wGLUEVEN
}

#----------------------------------------------------------------------
#  SetLclVars_wGLUEVEN
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wGLUEVEN {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGLUEVEN
    foreach {e} $AllGlobalVars_wGLUEVEN {
        global Lcl_$e
    }
    set Lcl_numRibsHalf    $numRibsHalf
    set Lcl_k_section26  $k_section26

    for {set i 1} {$i <= $numRibsHalf} {incr i} {
        set Lcl_glueVenA($i)   $glueVenA($i)
        set Lcl_glueVenB($i)   $glueVenB($i)
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wGLUEVEN
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wGLUEVEN {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGLUEVEN
    foreach {e} $AllGlobalVars_wGLUEVEN {
        global Lcl_$e
    }

    set numRibsHalf    $Lcl_numRibsHalf
    set k_section26  $Lcl_k_section26

    for {set i 1} {$i <= $numRibsHalf} {incr i} {
        set glueVenA($i)   $Lcl_glueVenA($i)
        set glueVenB($i)   $Lcl_glueVenB($i)
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wGLUEVEN
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wGLUEVEN {} {
    global g_WingDataChanged
    global Lcl_wGLUEVEN_DataChanged

    if { $Lcl_wGLUEVEN_DataChanged == 1 } {
        ExportLclVars_wGLUEVEN

        set g_WingDataChanged       1
        set Lcl_wGLUEVEN_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wGLUEVEN
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wGLUEVEN {} {
    global .wGLUEVEN
    global g_WingDataChanged
    global Lcl_wGLUEVEN_DataChanged

    if { $Lcl_wGLUEVEN_DataChanged == 1 } {
        ExportLclVars_wGLUEVEN
        set g_WingDataChanged       1
        set Lcl_wGLUEVEN_DataChanged    0
    }

    UnsetLclVarTrace_wGLUEVEN
    destroy .wGLUEVEN
}

#----------------------------------------------------------------------
#  CancelButtonPress_wGLUEVEN
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wGLUEVEN {} {
    global .wGLUEVEN
    global g_WingDataChanged
    global Lcl_wGLUEVEN_DataChanged

    if { $Lcl_wGLUEVEN_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wGLUEVEN
            return 0
        }
    }

    set Lcl_wGLUEVEN_DataChanged 0
    UnsetLclVarTrace_wGLUEVEN
    destroy .wGLUEVEN

}

#----------------------------------------------------------------------
#  HelpButtonPress_wGLUEVEN
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wGLUEVEN {} {
    source "userHelp.tcl"

    displayHelpfile "set-glue-vent-options-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wGLUEVEN
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wGLUEVEN {} {

    global AllGlobalVars_wGLUEVEN

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGLUEVEN {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wGLUEVEN }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wGLUEVEN
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wGLUEVEN {} {

    global AllGlobalVars_wGLUEVEN

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGLUEVEN {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wGLUEVEN }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wGLUEVEN
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wGLUEVEN { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wGLUEVEN_DataChanged

    set Lcl_wGLUEVEN_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wGLUEVEN
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wGLUEVEN {} {
    global .wGLUEVEN

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGLUEVEN
    foreach {e} $AllGlobalVars_wGLUEVEN {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    label       .wGLUEVEN.dataTop.spacer00 -width 10 -text ""
    grid        .wGLUEVEN.dataTop.spacer00 -row 0 -column 0 -sticky e

    label       .wGLUEVEN.dataTop.p1 -width 15 -text [::msgcat::mc "Config type"]
    grid        .wGLUEVEN.dataTop.p1 -row 1 -column 0 -sticky e
    ttk::entry  .wGLUEVEN.dataTop.e_p1 -width 15 -textvariable Lcl_k_section26
    SetHelpBind .wGLUEVEN.dataTop.e_p1 "Configuration, only type 1 or 0 available"   HelpText_wGLUEVEN
    grid        .wGLUEVEN.dataTop.e_p1 -row 1 -column 1 -sticky e -pady 1

    #-------------
    # Config note
#    label       .wGLUEVEN.note.spacer00 -width 80 -text "This is an invariant section,"
#    grid        .wGLUEVEN.note.spacer00 -row 0 -column 0 -sticky s
#    label       .wGLUEVEN.note.spacer01 -width 80 -text "the default settings are generally appropriate.\n"
#    grid        .wGLUEVEN.note.spacer01 -row 1 -column 0

    #-------------
    # header for the item lines
    label       .wGLUEVEN.dataBot.scroll.widgets.n -width 15 -text "Num"
    grid        .wGLUEVEN.dataBot.scroll.widgets.n -row 0 -column 1 -sticky e

    label       .wGLUEVEN.dataBot.scroll.widgets.p0 -width 15 -text [::msgcat::mc "Type"]
    grid        .wGLUEVEN.dataBot.scroll.widgets.p0 -row 0 -column 2 -sticky e

    #-------------
    # item lines
    for { set i 1 } { $i <= $Lcl_numRibsHalf } { incr i } {
        AddItemLine_wGLUEVEN $i
    }

    UpdateItemLineButtons_wGLUEVEN
}

#----------------------------------------------------------------------
#  DecItemLines_wGLUEVEN
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wGLUEVEN {} {
    global .wGLUEVEN
    global Lcl_numRibsHalf

    destroy .wGLUEVEN.dataBot.scroll.widgets.n$Lcl_numRibsHalf
    destroy .wGLUEVEN.dataBot.scroll.widgets.e_p0$Lcl_numRibsHalf
    destroy .wGLUEVEN.dataBot.scroll.widgets.e_p1$Lcl_numRibsHalf
    destroy .wGLUEVEN.dataBot.scroll.widgets.e_p2$Lcl_numRibsHalf

    incr Lcl_numRibsHalf -1

    UpdateItemLineButtons_wGLUEVEN

    ResizeScrollFrame_wGLUEVEN
}

#----------------------------------------------------------------------
#  IncItemLines_wGLUEVEN
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wGLUEVEN {} {
    global .wGLUEVEN
    global Lcl_numRibsHalf

    incr Lcl_numRibsHalf

    UpdateItemLineButtons_wGLUEVEN

    # init additional variables
    CreateInitialItemLineVars_wGLUEVEN

    AddItemLine_wGLUEVEN $Lcl_numRibsHalf

    ResizeScrollFrame_wGLUEVEN
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wGLUEVEN
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wGLUEVEN {} {
    global .wGLUEVEN
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGLUEVEN
    foreach {e} $AllGlobalVars_wGLUEVEN {
        global Lcl_$e
    }

    set Lcl_glueVenA($Lcl_numRibsHalf) 0
    set Lcl_glueVenB($Lcl_numRibsHalf) 0
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wGLUEVEN
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wGLUEVEN { } {
    global .wGLUEVEN
    global Lcl_numRibsHalf

    if {$Lcl_numRibsHalf > 1} {
#        .wGLUEVEN.dataMid.b_decItems configure -state normal
    } else {
#        .wGLUEVEN.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wGLUEVEN
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wGLUEVEN { lineNum } {
    global .wGLUEVEN

    label       .wGLUEVEN.dataBot.scroll.widgets.n$lineNum -width 15 -text "$lineNum"
    grid        .wGLUEVEN.dataBot.scroll.widgets.n$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wGLUEVEN.dataBot.scroll.widgets.e_p0$lineNum -width 15 -textvariable Lcl_glueVenB($lineNum)
    SetHelpBind .wGLUEVEN.dataBot.scroll.widgets.e_p0$lineNum "Types of vent available: -2,-1,0,1,3"   HelpText_wGLUEVEN
    grid        .wGLUEVEN.dataBot.scroll.widgets.e_p0$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1
}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wGLUEVEN
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wGLUEVEN { } {
    global .wGLUEVEN

    set framesize [grid size .wGLUEVEN.dataBot.scroll.widgets]

    .wGLUEVEN.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wGLUEVEN.dataBot.scroll create window 0 0 -anchor nw -window .wGLUEVEN.dataBot.scroll.widgets
    .wGLUEVEN.dataBot.scroll configure -scrollregion [.wGLUEVEN.dataBot.scroll bbox all]
}
