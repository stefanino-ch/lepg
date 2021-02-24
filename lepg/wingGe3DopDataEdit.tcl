#---------------------------------------------------------------------
#
#  Window to edit general 3D DXF options (section 25)
#
#  Stefan Feuz
#  Pere Casellas
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global  Lcl_wGE3DOP_DataChanged
set     Lcl_wGE3DOP_DataChanged    0

global  AllGlobalVars_wGE3DOP
set     AllGlobalVars_wGE3DOP { k_section25 numGe3Dop numGe3Dopm \
        dxf3DopA dxf3DopB dxf3DopC dxf3DopD }

#----------------------------------------------------------------------
#  wingGe3DopDataEdit
#  Displays a window to edit the brake lines data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingGe3DopDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global k_section25
    global numGe3Dop
    global numGe3Dopm
    global .wGE3DOP

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGE3DOP
    foreach {e} $AllGlobalVars_wGE3DOP {
        global Lcl_$e
    }

    SetLclVars_wGE3DOP

    toplevel .wGE3DOP
    focus .wGE3DOP

    wm protocol .wGE3DOP WM_DELETE_WINDOW { CancelButtonPress_wGE3DOP }

    wm title .wGE3DOP [::msgcat::mc "Section 25: General 3D DXF options"]

    #-------------
    # Frames and grids
    ttk::frame      .wGE3DOP.dataTop
    ttk::frame      .wGE3DOP.dataBot
    ttk::labelframe .wGE3DOP.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wGE3DOP.btn
    #
    grid .wGE3DOP.dataTop         -row 0 -column 0 -sticky w
    grid .wGE3DOP.dataBot         -row 1 -column 0 -sticky w
    grid .wGE3DOP.help            -row 2 -column 0 -sticky e
    grid .wGE3DOP.btn             -row 3 -column 0 -sticky e

    addEdit_wGE3DOP

    #-------------
    # explanations
    label .wGE3DOP.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wGE3DOP
    grid  .wGE3DOP.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wGE3DOP.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wGE3DOP
    button .wGE3DOP.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wGE3DOP
    button .wGE3DOP.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wGE3DOP
    button .wGE3DOP.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wGE3DOP

    grid .wGE3DOP.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wGE3DOP.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wGE3DOP.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wGE3DOP.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wGE3DOP
}

#----------------------------------------------------------------------
#  SetLclVars_wGE3DOP
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wGE3DOP {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGE3DOP
    foreach {e} $AllGlobalVars_wGE3DOP {
        global Lcl_$e
    }
    set Lcl_k_section25   $k_section25
    set Lcl_numGe3Dop     $numGe3Dop
    set Lcl_numGe3Dopm    $numGe3Dopm

    for {set i 1} {$i <= $numGe3Dop} {incr i} {
        set Lcl_dxf3DopA($i)   $dxf3DopA($i)
        set Lcl_dxf3DopB($i)   $dxf3DopB($i)
        set Lcl_dxf3DopC($i)   $dxf3DopC($i)
    }

    for {set i [expr $numGe3Dop +1]} {$i <= [expr $numGe3Dop + $numGe3Dopm]} {incr i} {
        set Lcl_dxf3DopA($i)   $dxf3DopA($i)
        set Lcl_dxf3DopB($i)   $dxf3DopB($i)
        set Lcl_dxf3DopC($i)   $dxf3DopC($i)
        set Lcl_dxf3DopD($i)   $dxf3DopD($i)
    }

}

#----------------------------------------------------------------------
#  ExportLclVars_wGE3DOP
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wGE3DOP {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGE3DOP
    foreach {e} $AllGlobalVars_wGE3DOP {
        global Lcl_$e
    }

    set k_section25  $Lcl_k_section25
    set numGe3Dop    $Lcl_numGe3Dop
    set numGe3Dopm   $Lcl_numGe3Dopm

    for {set i 1} {$i <= $numGe3Dop} {incr i} {
        set dxf3DopA($i)   $Lcl_dxf3DopA($i)
        set dxf3DopB($i)   $Lcl_dxf3DopB($i)
        set dxf3DopC($i)   $Lcl_dxf3DopC($i)
    }

    for {set i [expr $numGe3Dop +1]} {$i <= [expr $numGe3Dop + $numGe3Dopm]} {incr i} {
        set dxf3DopA($i)   $Lcl_dxf3DopA($i)
        set dxf3DopB($i)   $Lcl_dxf3DopB($i)
        set dxf3DopC($i)   $Lcl_dxf3DopC($i)
        set dxf3DopD($i)   $Lcl_dxf3DopD($i)
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wGE3DOP
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wGE3DOP {} {
    global g_WingDataChanged
    global Lcl_wGE3DOP_DataChanged

    if { $Lcl_wGE3DOP_DataChanged == 1 } {
        ExportLclVars_wGE3DOP

        set g_WingDataChanged       1
        set Lcl_wGE3DOP_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wGE3DOP
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wGE3DOP {} {
    global .wGE3DOP
    global g_WingDataChanged
    global Lcl_wGE3DOP_DataChanged

    if { $Lcl_wGE3DOP_DataChanged == 1 } {
        ExportLclVars_wGE3DOP
        set g_WingDataChanged       1
        set Lcl_wGE3DOP_DataChanged    0
    }

    UnsetLclVarTrace_wGE3DOP
    destroy .wGE3DOP
}

#----------------------------------------------------------------------
#  CancelButtonPress_wGE3DOP
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wGE3DOP {} {
    global .wGE3DOP
    global g_WingDataChanged
    global Lcl_wGE3DOP_DataChanged

    if { $Lcl_wGE3DOP_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .wGE3DOP
            return 0
        }
    }

    set Lcl_wGE3DOP_DataChanged 0
    UnsetLclVarTrace_wGE3DOP
    destroy .wGE3DOP

}

#----------------------------------------------------------------------
#  HelpButtonPress_wGE3DOP
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wGE3DOP {} {
    source "userHelp.tcl"

    displayHelpfile "set-3D-DXF-options-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wGE3DOP
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wGE3DOP {} {

    global AllGlobalVars_wGE3DOP

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGE3DOP {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wGE3DOP }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wGE3DOP
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wGE3DOP {} {

    global AllGlobalVars_wGE3DOP

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wGE3DOP {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wGE3DOP }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wGE3DOP
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wGE3DOP { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wGE3DOP_DataChanged

    set Lcl_wGE3DOP_DataChanged 1
}

#----------------------------------------------------------------------
#  addEdit_wGE3DOP
#  Adds all the edit elements needed for the config
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEdit_wGE3DOP {} {
    global .wGE3DOP

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wGE3DOP
    foreach {e} $AllGlobalVars_wGE3DOP {
        global Lcl_$e
    }

    # create GUI


    #-------------
    # Config of top data section
    label       .wGE3DOP.dataTop.spacer00 -width 10 -text ""
    grid        .wGE3DOP.dataTop.spacer00 -row 0 -column 0 -sticky e

    label       .wGE3DOP.dataTop.p -width 15 -text [::msgcat::mc "Config type"]
    grid        .wGE3DOP.dataTop.p -row 1 -column 0 -sticky e
    ttk::entry  .wGE3DOP.dataTop.e_p -width 20 -textvariable Lcl_k_section25
    SetHelpBind .wGE3DOP.dataTop.e_p [::msgcat::mc "Configuration, only type 1 available"]   HelpText_wGE3DOP
    grid        .wGE3DOP.dataTop.e_p -row 1 -column 1 -sticky e -pady 1

    #-------------
    # header for the item lines first blocs

    label       .wGE3DOP.dataTop.spacer01 -width 10 -text ""
    grid        .wGE3DOP.dataTop.spacer01 -row 0 -column 0 -sticky e

    label       .wGE3DOP.dataTop.n -width 10 -text [::msgcat::mc "Num"]
    grid        .wGE3DOP.dataTop.n -row 2 -column 0 -sticky e

    label       .wGE3DOP.dataTop.p0 -width 20 -text [::msgcat::mc "Element"]
    grid        .wGE3DOP.dataTop.p0 -row 2 -column 1 -sticky e

    label       .wGE3DOP.dataTop.p1 -width 10 -text [::msgcat::mc "CAD color"]
    grid        .wGE3DOP.dataTop.p1 -row 2 -column 2 -sticky e

    label       .wGE3DOP.dataTop.p2 -width 15 -text [::msgcat::mc "Color"]
    grid        .wGE3DOP.dataTop.p2 -row 2 -column 3 -sticky e

    #-------------
    # Add line items
    for { set i 1 } { $i <= $Lcl_numGe3Dop } { incr i } {
        AddItemLine_wGE3DOP $i
    }

#    UpdateItemLineButtons_wGE3DOP

    #-------------
    # header for the item lines second bloc
    label       .wGE3DOP.dataBot.n -width 10 -text [::msgcat::mc "Num"]
    grid        .wGE3DOP.dataBot.n -row 1 -column 0 -sticky e

    label       .wGE3DOP.dataBot.p0 -width 20 -text [::msgcat::mc "Element"]
    grid        .wGE3DOP.dataBot.p0 -row 1 -column 1 -sticky e

    label       .wGE3DOP.dataBot.p1 -width 10 -text [::msgcat::mc "Display"]
    grid        .wGE3DOP.dataBot.p1 -row 1 -column 2 -sticky e

    label       .wGE3DOP.dataBot.p2 -width 10 -text [::msgcat::mc "CAD color"]
    grid        .wGE3DOP.dataBot.p2 -row 1 -column 3 -sticky e

    label       .wGE3DOP.dataBot.p3 -width 15 -text [::msgcat::mc "Color"]
    grid        .wGE3DOP.dataBot.p3 -row 1 -column 4 -sticky e

    #-------------
    # Add line items
    for { set i [expr $Lcl_numGe3Dop + 1] } { $i <= [expr $Lcl_numGe3Dop + $Lcl_numGe3Dopm] } { incr i } {
        AddItemLine_wGE3DOPm $i
    }

    label       .wGE3DOP.dataBot.m -width 10 -text ""
    grid        .wGE3DOP.dataBot.m -row [expr $Lcl_numGe3Dop + $Lcl_numGe3Dopm + 6] -column 0 -sticky e

#    UpdateItemLineButtons_wGE3DOP

}

#----------------------------------------------------------------------
#  DecItemLines_wGE3DOP
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wGE3DOP {} {
    global .wGE3DOP
    global Lcl_numGe3Dop

    destroy .wGE3DOP.dataTop.n$Lcl_numGe3Dop
    destroy .wGE3DOP.dataTop.e_p1$Lcl_numGe3Dop
    destroy .wGE3DOP.dataTop.e_p2$Lcl_numGe3Dop
    destroy .wGE3DOP.dataTop.e_p3$Lcl_numGe3Dop
    destroy .wGE3DOP.dataTop.e_p4$Lcl_numGe3Dop
    destroy .wGE3DOP.dataTop.e_p5$Lcl_numGe3Dop
    destroy .wGE3DOP.dataTop.e_p6$Lcl_numGe3Dop

    incr Lcl_numGe3Dop -1

    UpdateItemLineButtons_wGE3DOP
}

#----------------------------------------------------------------------
#  IncItemLines_wGE3DOP
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wGE3DOP {} {
    global .wGE3DOP
    global Lcl_numGe3Dop

    incr Lcl_numGe3Dop

    UpdateItemLineButtons_wGE3DOP

    # init additional variables
    CreateInitialItemLineVars_wGE3DOP

    AddItemLine_wGE3DOP $Lcl_numGe3Dop
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wGE3DOP
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wGE3DOP {} {
    global .wGE3DOP
    global Lcl_numGe3Dop
    global Lcl_dxf3DopA
    global Lcl_dxf3DopB
    global Lcl_dxf3DopC
    global Lcl_dxf3DopD

    # init additional variables
    foreach i {1 2 3 4 5 6 7 8 9} {
        set Lcl_dxf3DopA($i) 0
        set Lcl_dxf3DopB($i) 0
        set Lcl_dxf3DopC($i) 0
        set Lcl_dxf3DopD($i) 0
    }
}


#----------------------------------------------------------------------
#  UpdateItemLineButtons_wGE3DOP
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wGE3DOP { } {
    global .wGE3DOP
    global Lcl_numGe3Dop

    if {$Lcl_numGe3Dop > 1} {
        .wGE3DOP.dataTop.b_decItems configure -state normal
    } else {
        .wGE3DOP.dataTop.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wGE3DOP (Top part)
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wGE3DOP { lineNum } {
    global .wGE3DOP
    global Lcl_dxf3DopA
    global Lcl_dxf3DopB
    global Lcl_dxf3DopC

    label       .wGE3DOP.dataTop.n$lineNum -width 15 -text "$lineNum"
    grid        .wGE3DOP.dataTop.n$lineNum -row [expr (6-1 + $lineNum)] -column 0 -sticky e

    ttk::entry  .wGE3DOP.dataTop.e_p1$lineNum -width 20 -textvariable Lcl_dxf3DopA($lineNum)
    SetHelpBind .wGE3DOP.dataTop.e_p1$lineNum [::msgcat::mc "Element of the 3D DXF drawing"]   HelpText_wGE3DOP
    grid        .wGE3DOP.dataTop.e_p1$lineNum -row [expr (6-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wGE3DOP.dataTop.e_p2$lineNum -width 10 -textvariable Lcl_dxf3DopB($lineNum)
    SetHelpBind .wGE3DOP.dataTop.e_p2$lineNum [::msgcat::mc "CAD color"]   HelpText_wGE3DOP
    grid        .wGE3DOP.dataTop.e_p2$lineNum -row [expr (6-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wGE3DOP.dataTop.e_p3$lineNum -width 15 -textvariable Lcl_dxf3DopC($lineNum)
    SetHelpBind .wGE3DOP.dataTop.e_p3$lineNum [::msgcat::mc "Color"]   HelpText_wGE3DOP
    grid        .wGE3DOP.dataTop.e_p3$lineNum -row [expr (6-1 + $lineNum)] -column 3 -sticky e -pady 1

}

#----------------------------------------------------------------------
#  AddItemLine_wGE3DOPm (Bottom part)
#  Adds an additional Item Line to a tab
#
#  IN:      Line number to be added
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wGE3DOPm { lineNum } {
    global .wGE3DOP
    global Lcl_dxf3DopA
    global Lcl_dxf3DopB
    global Lcl_dxf3DopC
    global Lcl_dxf3DopD

    label       .wGE3DOP.dataBot.n$lineNum -width 15 -text "$lineNum"
    grid        .wGE3DOP.dataBot.n$lineNum -row [expr (6-1 + $lineNum)] -column 0 -sticky e

    ttk::entry  .wGE3DOP.dataBot.e_p1$lineNum -width 20 -textvariable Lcl_dxf3DopA($lineNum)
    SetHelpBind .wGE3DOP.dataBot.e_p1$lineNum [::msgcat::mc "Element of the 3D DXF drawing"]   HelpText_wGE3DOP
    grid        .wGE3DOP.dataBot.e_p1$lineNum -row [expr (6-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wGE3DOP.dataBot.e_p2$lineNum -width 10 -textvariable Lcl_dxf3DopB($lineNum)
    SetHelpBind .wGE3DOP.dataBot.e_p2$lineNum [::msgcat::mc "Active"]   HelpText_wGE3DOP
    grid        .wGE3DOP.dataBot.e_p2$lineNum -row [expr (6-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wGE3DOP.dataBot.e_p3$lineNum -width 10 -textvariable Lcl_dxf3DopC($lineNum)
    SetHelpBind .wGE3DOP.dataBot.e_p3$lineNum [::msgcat::mc "CAD color"]   HelpText_wGE3DOP
    grid        .wGE3DOP.dataBot.e_p3$lineNum -row [expr (6-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wGE3DOP.dataBot.e_p4$lineNum -width 15 -textvariable Lcl_dxf3DopD($lineNum)
    SetHelpBind .wGE3DOP.dataBot.e_p4$lineNum [::msgcat::mc "Color"]   HelpText_wGE3DOP
    grid        .wGE3DOP.dataBot.e_p4$lineNum -row [expr (6-1 + $lineNum)] -column 4 -sticky e -pady 1

}
