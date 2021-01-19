#---------------------------------------------------------------------
#
#  Window to edit airfoil thickness (section 30)
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
global  Lcl_wAIRTHICK_DataChanged
set     Lcl_wAIRTHICK_DataChanged    0

global  AllGlobalVars_wAIRTHICK
set     AllGlobalVars_wAIRTHICK { k_section30 numRibsHalf airThickA airThickB }

#----------------------------------------------------------------------
#  wingMarksTypesDataEdit
#  Displays a window to edit the marks types
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingAirThickDataEdit {} {
    source "windowExplanationsHelper.tcl"
    global numRibsHalf
    global k_section30

    global .wAIRTHICK

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wAIRTHICK
    foreach {e} $AllGlobalVars_wAIRTHICK {
        global Lcl_$e
    }

    SetLclVars_wAIRTHICK

    toplevel .wAIRTHICK
    focus .wAIRTHICK

    wm protocol .wAIRTHICK WM_DELETE_WINDOW { CancelButtonPress_wAIRTHICK }

    wm title .wAIRTHICK [::msgcat::mc "Section 30: Airfoil thickness"]

    #-------------
    # Frames and grids
    ttk::frame      .wAIRTHICK.dataTop
    ttk::frame      .wAIRTHICK.dataMid
    ttk::frame      .wAIRTHICK.dataBot
    ttk::frame      .wAIRTHICK.note
    ttk::labelframe .wAIRTHICK.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wAIRTHICK.btn

    #-------------
    # Place frames
    grid .wAIRTHICK.dataTop         -row 0 -column 0 -sticky w
    grid .wAIRTHICK.dataMid         -row 1 -column 0 -sticky w
    grid .wAIRTHICK.dataBot         -row 2 -column 0 -sticky nesw
    grid .wAIRTHICK.note            -row 3 -column 0 -sticky e
    grid .wAIRTHICK.help            -row 4 -column 0 -sticky e
    grid .wAIRTHICK.btn             -row 5 -column 0 -sticky e

    grid columnconfigure .wAIRTHICK 0 -weight 1
    grid rowconfigure .wAIRTHICK 2 -weight 1

    #-------------
    # Get a scrollable region
    canvas .wAIRTHICK.dataBot.scroll  -width 500 -height 400 -yscrollcommand ".wAIRTHICK.dataBot.yscroll set"
    ttk::scrollbar .wAIRTHICK.dataBot.yscroll -command ".wAIRTHICK.dataBot.scroll yview"

#    grid .wAIRTHICK.dataTop.n1 -row 0 -column 0 -sticky nesw
#    grid .wAIRTHICK.dataTop.n2 -row 0 -column 1 -sticky nesw

    grid .wAIRTHICK.dataBot.scroll -row 0 -column 0 -sticky nesw
    grid .wAIRTHICK.dataBot.yscroll -row 0 -column 1 -sticky nesw

    grid columnconfigure .wAIRTHICK.dataBot 0 -weight 1
    grid columnconfigure .wAIRTHICK.dataBot 1 -weight 0
    grid rowconfigure .wAIRTHICK.dataBot 0 -weight 1

    ttk::frame .wAIRTHICK.dataBot.scroll.widgets -borderwidth 1
    grid .wAIRTHICK.dataBot.scroll.widgets -row 0 -column 0

    addEdit_wAIRTHICK

    ResizeScrollFrame_wAIRTHICK

    #-------------
    # explanations
    label .wAIRTHICK.help.e_help -width 80 -height 3 -background LightYellow -justify center -textvariable HelpText_wAIRTHICK
    grid  .wAIRTHICK.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wAIRTHICK.btn.apply  -width 10 -text [::msgcat::mc "Apply"]    -command ApplyButtonPress_wAIRTHICK
    button .wAIRTHICK.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wAIRTHICK
    button .wAIRTHICK.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wAIRTHICK
    button .wAIRTHICK.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wAIRTHICK

    grid .wAIRTHICK.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wAIRTHICK.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wAIRTHICK.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wAIRTHICK.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wAIRTHICK
}

#----------------------------------------------------------------------
#  SetLclVars_wAIRTHICK
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wAIRTHICK {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wAIRTHICK
    foreach {e} $AllGlobalVars_wAIRTHICK {
        global Lcl_$e
    }
    set Lcl_numRibsHalf    $numRibsHalf
    set Lcl_k_section30  $k_section30

    for {set i 1} {$i <= $numRibsHalf} {incr i} {
        set Lcl_airThickA($i)   $airThickA($i)
        set Lcl_airThickB($i)   $airThickB($i)
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_wAIRTHICK
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wAIRTHICK {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wAIRTHICK
    foreach {e} $AllGlobalVars_wAIRTHICK {
        global Lcl_$e
    }

    set numRibsHalf    $Lcl_numRibsHalf
    set k_section30  $Lcl_k_section30

    for {set i 1} {$i <= $numRibsHalf} {incr i} {
        set airThickA($i)   $Lcl_airThickA($i)
        set airThickB($i)   $Lcl_airThickB($i)
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wAIRTHICK
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wAIRTHICK {} {
    global g_WingDataChanged
    global Lcl_wAIRTHICK_DataChanged

    if { $Lcl_wAIRTHICK_DataChanged == 1 } {
        ExportLclVars_wAIRTHICK

        set g_WingDataChanged       1
        set Lcl_wAIRTHICK_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wAIRTHICK
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wAIRTHICK {} {
    global .wAIRTHICK
    global g_WingDataChanged
    global Lcl_wAIRTHICK_DataChanged

    if { $Lcl_wAIRTHICK_DataChanged == 1 } {
        ExportLclVars_wAIRTHICK
        set g_WingDataChanged       1
        set Lcl_wAIRTHICK_DataChanged    0
    }

    UnsetLclVarTrace_wAIRTHICK
    destroy .wAIRTHICK
}

#----------------------------------------------------------------------
#  CancelButtonPress_wAIRTHICK
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wAIRTHICK {} {
    global .wAIRTHICK
    global g_WingDataChanged
    global Lcl_wAIRTHICK_DataChanged

    if { $Lcl_wAIRTHICK_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wAIRTHICK
            return 0
        }
    }

    set Lcl_wAIRTHICK_DataChanged 0
    UnsetLclVarTrace_wAIRTHICK
    destroy .wAIRTHICK

}

#----------------------------------------------------------------------
#  HelpButtonPress_wAIRTHICK
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wAIRTHICK {} {
    source "userHelp.tcl"

    displayHelpfile "set-air-thick-options-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wAIRTHICK
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wAIRTHICK {} {

    global AllGlobalVars_wAIRTHICK

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wAIRTHICK {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wAIRTHICK }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wAIRTHICK
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wAIRTHICK {} {

    global AllGlobalVars_wAIRTHICK

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wAIRTHICK {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wAIRTHICK }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wAIRTHICK
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wAIRTHICK { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wAIRTHICK_DataChanged

    set Lcl_wAIRTHICK_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wAIRTHICK
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wAIRTHICK {} {
    global .wAIRTHICK

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wAIRTHICK
    foreach {e} $AllGlobalVars_wAIRTHICK {
        global Lcl_$e
    }

    #-------------
    # Config of top data section
    label       .wAIRTHICK.dataTop.spacer00 -width 10 -text ""
    grid        .wAIRTHICK.dataTop.spacer00 -row 0 -column 0 -sticky e

    label       .wAIRTHICK.dataTop.p1 -width 15 -text [::msgcat::mc "Config type"]
    grid        .wAIRTHICK.dataTop.p1 -row 1 -column 0 -sticky e
    ttk::entry  .wAIRTHICK.dataTop.e_p1 -width 15 -textvariable Lcl_k_section30
    SetHelpBind .wAIRTHICK.dataTop.e_p1 "Configuration, only type 1 or 0 available"   HelpText_wAIRTHICK
    grid        .wAIRTHICK.dataTop.e_p1 -row 1 -column 1 -sticky e -pady 1

    #-------------
    # Config note
#    label       .wAIRTHICK.note.spacer00 -width 80 -text "This is an invariant section,"
#    grid        .wAIRTHICK.note.spacer00 -row 0 -column 0 -sticky s
#    label       .wAIRTHICK.note.spacer01 -width 80 -text "the default settings are generally appropriate.\n"
#    grid        .wAIRTHICK.note.spacer01 -row 1 -column 0

    #-------------
    # header for the item lines
    label       .wAIRTHICK.dataBot.scroll.widgets.n -width 15 -text "Num"
    grid        .wAIRTHICK.dataBot.scroll.widgets.n -row 0 -column 1 -sticky e

    label       .wAIRTHICK.dataBot.scroll.widgets.p0 -width 15 -text [::msgcat::mc "Thickness"]
    grid        .wAIRTHICK.dataBot.scroll.widgets.p0 -row 0 -column 2 -sticky e

    #-------------
    # item lines
    if {$Lcl_k_section30 == 1} {
    for { set i 1 } { $i <= $Lcl_numRibsHalf } { incr i } {
        AddItemLine_wAIRTHICK $i
    }
    }

    UpdateItemLineButtons_wAIRTHICK
}

#----------------------------------------------------------------------
#  DecItemLines_wAIRTHICK
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wAIRTHICK {} {
    global .wAIRTHICK
    global Lcl_numRibsHalf

    destroy .wAIRTHICK.dataBot.scroll.widgets.n$Lcl_numRibsHalf
    destroy .wAIRTHICK.dataBot.scroll.widgets.e_p0$Lcl_numRibsHalf
    destroy .wAIRTHICK.dataBot.scroll.widgets.e_p1$Lcl_numRibsHalf
    destroy .wAIRTHICK.dataBot.scroll.widgets.e_p2$Lcl_numRibsHalf

    incr Lcl_numRibsHalf -1

    UpdateItemLineButtons_wAIRTHICK

    ResizeScrollFrame_wAIRTHICK
}

#----------------------------------------------------------------------
#  IncItemLines_wAIRTHICK
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wAIRTHICK {} {
    global .wAIRTHICK
    global Lcl_numRibsHalf

    incr Lcl_numRibsHalf

    UpdateItemLineButtons_wAIRTHICK

    # init additional variables
    CreateInitialItemLineVars_wAIRTHICK

    AddItemLine_wAIRTHICK $Lcl_numRibsHalf

    ResizeScrollFrame_wAIRTHICK
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wAIRTHICK
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wAIRTHICK {} {
    global .wAIRTHICK
    # make sure Lcl_ variables are known
    global  AllGlobalVars_wAIRTHICK
    foreach {e} $AllGlobalVars_wAIRTHICK {
        global Lcl_$e
    }

    set Lcl_airThickA($Lcl_numRibsHalf) 0
    set Lcl_airThickB($Lcl_numRibsHalf) 0
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wAIRTHICK
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wAIRTHICK { } {
    global .wAIRTHICK
    global Lcl_numRibsHalf

    if {$Lcl_numRibsHalf > 1} {
#        .wAIRTHICK.dataMid.b_decItems configure -state normal
    } else {
#        .wAIRTHICK.dataMid.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wAIRTHICK
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wAIRTHICK { lineNum } {
    global .wAIRTHICK

    label       .wAIRTHICK.dataBot.scroll.widgets.n$lineNum -width 15 -text "$lineNum"
    grid        .wAIRTHICK.dataBot.scroll.widgets.n$lineNum -row [expr (4-1 + $lineNum)] -column 1 -sticky e

    ttk::entry  .wAIRTHICK.dataBot.scroll.widgets.e_p0$lineNum -width 15 -textvariable Lcl_airThickB($lineNum)
    SetHelpBind .wAIRTHICK.dataBot.scroll.widgets.e_p0$lineNum "Airfoil thickness coefficient 0.0 to 1.0 or greater"   HelpText_wAIRTHICK
    grid        .wAIRTHICK.dataBot.scroll.widgets.e_p0$lineNum -row [expr (4-1 + $lineNum)] -column 2 -sticky e -pady 1
}

#----------------------------------------------------------------------
#  ResizeScrollFrame_wAIRTHICK
#  Bandaid as the scroll pane will not resize correctly.
#  Call this if items where added or deleted.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ResizeScrollFrame_wAIRTHICK { } {
    global .wAIRTHICK

    set framesize [grid size .wAIRTHICK.dataBot.scroll.widgets]

    .wAIRTHICK.dataBot.scroll.widgets configure -height [expr [lindex $framesize 1] * 22]

    .wAIRTHICK.dataBot.scroll create window 0 0 -anchor nw -window .wAIRTHICK.dataBot.scroll.widgets
    .wAIRTHICK.dataBot.scroll configure -scrollregion [.wAIRTHICK.dataBot.scroll bbox all]
}
