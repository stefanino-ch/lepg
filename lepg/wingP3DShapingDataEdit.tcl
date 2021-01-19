#---------------------------------------------------------------------
#
#  Window to edit the 3D shaping data (section 29)
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
global  Lcl_w3DSHA_DataChanged
set     Lcl_w3DSHA_DataChanged    0

global  AllGlobalVars_w3DSHA
set     AllGlobalVars_w3DSHA { k_section29 k_section29b numGroups3DS num3DS \
                               line3DSu line3DSl line3DSpp }

#----------------------------------------------------------------------
#  wingSuspensionLinesDataEdit
#  Displays a window to edit the 3D shaping lines data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingP3DShapingDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .w3DSHA

    # make sure Lcl_ variables are known
    global  AllGlobalVars_w3DSHA
    foreach {e} $AllGlobalVars_w3DSHA {
        global Lcl_$e
    }

    SetLclVars_w3DSHA

    toplevel .w3DSHA
    focus .w3DSHA

    wm protocol .w3DSHA WM_DELETE_WINDOW { CancelButtonPress_w3DSHA }

    wm title .w3DSHA [::msgcat::mc "Section 29: 3D shaping configuration"]

    #-------------
    # Frames and grids
    ttk::frame      .w3DSHA.dataTop
    ttk::frame      .w3DSHA.dataBot
    ttk::frame      .w3DSHA.dataPrint
    ttk::labelframe .w3DSHA.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .w3DSHA.btn
    #
    grid .w3DSHA.dataTop         -row 0 -column 0 -sticky w
    grid .w3DSHA.dataBot         -row 1 -column 0 -sticky w
    grid .w3DSHA.dataPrint       -row 2 -column 0 -sticky w
    grid .w3DSHA.help            -row 3 -column 0 -sticky e
    grid .w3DSHA.btn             -row 4 -column 0 -sticky e
    #
    #-------------
    # Spacer for line 1
    label       .w3DSHA.dataTop.spacer00 -width 5 -text ""
    grid        .w3DSHA.dataTop.spacer00 -row 1 -column 0

    #-------------
    # Control parameter, entry
    label       .w3DSHA.dataTop.ctrl1 -width 16 -text [::msgcat::mc "Config 1"]
    grid        .w3DSHA.dataTop.ctrl1 -row 2 -column 0 -sticky e
    ttk::entry  .w3DSHA.dataTop.e_ctrl1 -width 10 -textvariable Lcl_k_section29
    SetHelpBind .w3DSHA.dataTop.e_ctrl1 [::msgcat::mc "Set to 0 or 1"] HelpText_w3DSHA
    grid        .w3DSHA.dataTop.e_ctrl1 -row 2 -column 1 -sticky w -pady 1

    #-------------
    # Control parameter, entry
    label       .w3DSHA.dataTop.ctrl2 -width 16 -text [::msgcat::mc "Config 2"]
    grid        .w3DSHA.dataTop.ctrl2 -row 3 -column 0 -sticky e
    ttk::entry  .w3DSHA.dataTop.e_ctrl2 -width 10 -textvariable Lcl_k_section29b
    SetHelpBind .w3DSHA.dataTop.e_ctrl2 [::msgcat::mc "Set to 1"] HelpText_w3DSHA
    grid        .w3DSHA.dataTop.e_ctrl2 -row 3 -column 1 -sticky w -pady 1

    #-------------
    # Control parameter, entry
    label       .w3DSHA.dataTop.ctrl3 -width 16 -text [::msgcat::mc "Groups"]
    grid        .w3DSHA.dataTop.ctrl3 -row 4 -column 0 -sticky e
    ttk::entry  .w3DSHA.dataTop.e_ctrl3 -width 10 -textvariable Lcl_numGroups3DS(1)
    SetHelpBind .w3DSHA.dataTop.e_ctrl3 [::msgcat::mc "Name"] HelpText_w3DSHA
    grid        .w3DSHA.dataTop.e_ctrl3 -row 4 -column 1 -sticky w -pady 1

    #-------------
    # Control parameter, entry
    ttk::entry  .w3DSHA.dataTop.e_ctrl4 -width 10 -textvariable Lcl_numGroups3DS(2)
    SetHelpBind .w3DSHA.dataTop.e_ctrl4 [::msgcat::mc "Number of groups"]  HelpText_w3DSHA
    grid        .w3DSHA.dataTop.e_ctrl4 -row 4 -column 2 -sticky w -pady 1


    #-------------
    # Frame data print
    #-------------
    # Spacer for line 1
    label       .w3DSHA.dataPrint.spacer00dp -width 5 -text ""
    grid        .w3DSHA.dataPrint.spacer00dp -row 1 -column 0

    if {$Lcl_k_section29 != 0} {
    #-------------
    # Control parameter, header
    label       .w3DSHA.dataPrint.dp1 -width 10 -text [::msgcat::mc "Action"]
    grid        .w3DSHA.dataPrint.dp1 -row 2 -column 2 -sticky e

    label       .w3DSHA.dataPrint.dp2 -width 10 -text [::msgcat::mc "1-0"]
    grid        .w3DSHA.dataPrint.dp2 -row 2 -column 3 -sticky e

    label       .w3DSHA.dataPrint.dp3 -width 10 -text [::msgcat::mc "Rib ini"]
    grid        .w3DSHA.dataPrint.dp3 -row 2 -column 4 -sticky e

    label       .w3DSHA.dataPrint.dp4 -width 10 -text [::msgcat::mc "Rib fin"]
    grid        .w3DSHA.dataPrint.dp4 -row 2 -column 5 -sticky e

    label       .w3DSHA.dataPrint.dp5 -width 10 -text [::msgcat::mc "Param."]
    grid        .w3DSHA.dataPrint.dp5 -row 2 -column 6 -sticky e

    #-------------
    # Control parameter, entrys
    foreach i {1 2 3 4 5} {
    ttk::entry  .w3DSHA.dataPrint.e_dp1$i -width 10 -textvariable Lcl_line3DSpp($i,1)
    SetHelpBind .w3DSHA.dataPrint.e_dp1$i [::msgcat::mc "Element"]  HelpText_w3DSHA
    grid        .w3DSHA.dataPrint.e_dp1$i -row [expr (3 - 1 + $i)] -column 2 -sticky w -pady 1
    ttk::entry  .w3DSHA.dataPrint.e_dp2$i -width 10 -textvariable Lcl_line3DSpp($i,2)
    SetHelpBind .w3DSHA.dataPrint.e_dp2$i [::msgcat::mc "1 active, 0 inactive"]  HelpText_w3DSHA
    grid        .w3DSHA.dataPrint.e_dp2$i -row [expr (3 - 1 + $i)] -column 3 -sticky w -pady 1
    ttk::entry  .w3DSHA.dataPrint.e_dp3$i -width 10 -textvariable Lcl_line3DSpp($i,3)
    SetHelpBind .w3DSHA.dataPrint.e_dp3$i [::msgcat::mc "Rib ini"]  HelpText_w3DSHA
    grid        .w3DSHA.dataPrint.e_dp3$i -row [expr (3 - 1 + $i)] -column 4 -sticky w -pady 1
    ttk::entry  .w3DSHA.dataPrint.e_dp4$i -width 10 -textvariable Lcl_line3DSpp($i,4)
    SetHelpBind .w3DSHA.dataPrint.e_dp4$i [::msgcat::mc "Rib fin"]  HelpText_w3DSHA
    grid        .w3DSHA.dataPrint.e_dp4$i -row [expr (3 - 1 + $i)] -column 5 -sticky w -pady 1
    ttk::entry  .w3DSHA.dataPrint.e_dp5$i -width 10 -textvariable Lcl_line3DSpp($i,5)
    SetHelpBind .w3DSHA.dataPrint.e_dp5$i [::msgcat::mc "Param."]  HelpText_w3DSHA
    grid        .w3DSHA.dataPrint.e_dp5$i -row [expr (3 - 1 + $i)] -column 6 -sticky w -pady 1
    }
    # end if
    }

    #-------------
    # Spacer for line 5
#    label       .w3DSHA.dataTop.spacer10 -width 5 -text ""
#    grid        .w3DSHA.dataTop.spacer10 -row 5 -column 0

    #-------------
    # Config of configs
    button      .w3DSHA.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Groups"] -command DecConfigTabs_w3DSHA -state disabled
    grid        .w3DSHA.dataTop.b_dec    -row 5 -column 0 -sticky e -padx 3 -pady 3

    button      .w3DSHA.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Groups"]  -command IncConfigTabs_w3DSHA
    grid        .w3DSHA.dataTop.b_inc    -row 5 -column 1 -sticky e -padx 3 -pady 3

    ttk::notebook .w3DSHA.dataBot.ntebk
    pack .w3DSHA.dataBot.ntebk -fill both -expand 1
    for { set i 1 } { $i <= $Lcl_numGroups3DS(2) } { incr i } {
        addEditTab_w3DSHA $i
    }
    UpdateConfigButtons_w3DSHA

    #-------------
    # explanations
    label .w3DSHA.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_w3DSHA
    grid  .w3DSHA.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .w3DSHA.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_w3DSHA
    button .w3DSHA.btn.ok     -width 10 -text "OK"        -command OkButtonPress_w3DSHA
    button .w3DSHA.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_w3DSHA
    button .w3DSHA.btn.help   -width 10 -text "Help"      -command HelpButtonPress_w3DSHA

    grid .w3DSHA.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .w3DSHA.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .w3DSHA.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .w3DSHA.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_w3DSHA
}

#----------------------------------------------------------------------
#  SetLclVars_w3DSHA
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_w3DSHA {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_w3DSHA
    foreach {e} $AllGlobalVars_w3DSHA {
        global Lcl_$e
    }

    set Lcl_k_section29  $k_section29
    set Lcl_k_section29b  $k_section29b

    for {set i 1 } { $i <= 2 } { incr i } {
    set Lcl_numGroups3DS($i)  $numGroups3DS($i)
    }

    # iterate across all 3DS numbers
    for { set i 1 } { $i <= $numGroups3DS(2) } { incr i } {
            foreach k {1 2 3 4 5 6 7 8 9 10} {
            set Lcl_num3DS($i,$k)  $num3DS($i,$k)
            }
    } 
    # iterate across all extrados data lines
    for { set i 1 } { $i <= $numGroups3DS(2) } { incr i } {
    for { set j 1 } { $j <= $num3DS($i,6) } { incr j } {
            foreach k {1 2 3 4} {
                set Lcl_line3DSu($i,$j,$k)   $line3DSu($i,$j,$k)
            }
        }
        }
    # iterate across all intrados data lines
    for { set i 1 } { $i <= $numGroups3DS(2) } { incr i } {
    for { set j 1 } { $j <= $num3DS($i,9) } { incr j } {
            foreach k {1 2 3 4} {
                set Lcl_line3DSl($i,$j,$k)   $line3DSl($i,$j,$k)
            }
        }
        }
    # iterate across all print parameters lines
    if {$Lcl_k_section29 != 0} {
    for { set i 1 } { $i <= 5 } { incr i } {
            foreach k {1 2 3 4 5} {
                set Lcl_line3DSpp($i,$k)   $line3DSpp($i,$k)
            }
        }
    }
}

#----------------------------------------------------------------------
#  ExportLclVars_w3DSHA
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_w3DSHA {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_w3DSHA
    foreach {e} $AllGlobalVars_w3DSHA {
        global Lcl_$e
    }

    set k_section29  $Lcl_k_section29
    set k_section29b  $Lcl_k_section29b

    for {set i 1 } { $i <= 2 } { incr i } {
    set numGroups3DS($i)  $Lcl_numGroups3DS($i)
    }

    # iterate across all 3DS numbers
    for { set i 1 } { $i <= $Lcl_numGroups3DS(2) } { incr i } {
            foreach k {1 2 3 4 5 6 7 8 9 10} {
                set num3DS($i,$k)  $Lcl_num3DS($i,$k)
            }
        }
    # iterate across all extrados data lines
    for { set i 1 } { $i <= $Lcl_numGroups3DS(2) } { incr i } {
    for { set j 1 } { $j <= $Lcl_num3DS($i,6) } { incr j } {
            foreach k {1 2 3 4} {
                set line3DSu($i,$j,$k) $Lcl_line3DSu($i,$j,$k) 
            }
        }
        }
    # iterate across all intrados data lines
    for { set i 1 } { $i <= $Lcl_numGroups3DS(2) } { incr i } {
    for { set j 1 } { $j <= $Lcl_num3DS($i,9) } { incr j } {
            foreach k {1 2 3 4} {
                set line3DSl($i,$j,$k) $Lcl_line3DSl($i,$j,$k) 
            }
        }
        }
    # iterate across all print parameters lines
    if {$Lcl_k_section29 != 0} {
    for { set i 1 } { $i <= 5 } { incr i } {
            foreach k {1 2 3 4 5} {
                set line3DSpp($i,$k)   $Lcl_line3DSpp($i,$k)
            }
        }
    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_w3DSHA
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_w3DSHA {} {
    global g_WingDataChanged
    global Lcl_w3DSHA_DataChanged

    if { $Lcl_w3DSHA_DataChanged == 1 } {
        ExportLclVars_w3DSHA

        set g_WingDataChanged       1
        set Lcl_w3DSHA_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_w3DSHA
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_w3DSHA {} {
    global .w3DSHA
    global g_WingDataChanged
    global Lcl_w3DSHA_DataChanged

    if { $Lcl_w3DSHA_DataChanged == 1 } {
        ExportLclVars_w3DSHA
        set g_WingDataChanged       1
        set Lcl_w3DSHA_DataChanged    0
    }

    UnsetLclVarTrace_w3DSHA
    destroy .w3DSHA
}

#----------------------------------------------------------------------
#  CancelButtonPress_w3DSHA
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_w3DSHA {} {
    global .w3DSHA
    global g_WingDataChanged
    global Lcl_w3DSHA_DataChanged

    if { $Lcl_w3DSHA_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .w3DSHA
            return 0
        }
    }

    set Lcl_w3DSHA_DataChanged 0
    UnsetLclVarTrace_w3DSHA
    destroy .w3DSHA

}

#----------------------------------------------------------------------
#  HelpButtonPress_w3DSHA
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_w3DSHA {} {
    source "userHelp.tcl"

    displayHelpfile "parapemeters-shaping-3D-data"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_w3DSHA
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_w3DSHA {} {

    global AllGlobalVars_w3DSHA

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_w3DSHA {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_w3DSHA }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_w3DSHA
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_w3DSHA {} {

    global AllGlobalVars_w3DSHA

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_w3DSHA {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_w3DSHA }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_w3DSHA
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_w3DSHA { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_w3DSHA_DataChanged

    set Lcl_w3DSHA_DataChanged 1
}

#----------------------------------------------------------------------
#  DecConfigTabs_w3DSHA
#  Decreases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecConfigTabs_w3DSHA {} {
    global .w3DSHA
    global Lcl_numGroups3DS

    destroy .w3DSHA.dataBot.ntebk.config$Lcl_numGroups3DS(2)

    incr Lcl_numGroups3DS(2) -1

    UpdateConfigButtons_w3DSHA
}

#----------------------------------------------------------------------
#  IncConfigTabs_w3DSHA
#  Increases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncConfigTabs_w3DSHA {} {
    global .w3DSHA
    global Lcl_numGroups3DS

    incr Lcl_numGroups3DS(2)

    UpdateConfigButtons_w3DSHA

    # new tab means we must initialize the variables
    CreateInitialConfigVars_w3DSHA $Lcl_numGroups3DS(2)

    addEditTab_w3DSHA $Lcl_numGroups3DS(2)
}

#----------------------------------------------------------------------
#  CreateInitialConfigVars_w3DSHA
#  Creates an initial set of initial variable to display an empty
#  configuration tab
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialConfigVars_w3DSHA { tabNum_w3DSHA } {
    global Lcl_num3DS
    global Lcl_line3DSu
    global Lcl_line3DSl

    foreach k {1 2 3 4 5 6 7 8 9 10} {
    set Lcl_num3DS($tabNum_w3DSHA,$k) 1
    }
    set Lcl_num3DS($tabNum_w3DSHA,1) group
    set Lcl_num3DS($tabNum_w3DSHA,5) upper
    set Lcl_num3DS($tabNum_w3DSHA,8) lower

    foreach k {1 2 3 4} {
    foreach l {1 2 3 4} {
    set Lcl_line3DSu($tabNum_w3DSHA,$l,$k) 1
    set Lcl_line3DSl($tabNum_w3DSHA,$l,$k) 1
    }
    }

    CreateInitialItemLineVars_w3DSHA $tabNum_w3DSHA
}

#----------------------------------------------------------------------
#  UpdateConfigButtons_w3DSHA
#  Updates the status of the config buttons depending on the number of
#  configs.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateConfigButtons_w3DSHA {} {
    global .w3DSHA
    global Lcl_numGroups3DS

    if {$Lcl_numGroups3DS(2) > 1} {
        .w3DSHA.dataTop.b_dec configure -state normal
    } else {
        .w3DSHA.dataTop.b_dec configure -state disabled
    }
}

#----------------------------------------------------------------------
#  addEditTab_w3DSHA
#  Adds all the edit elements needed for one config tab
#
#  IN:      Number of the new tab to be created (1..)
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEditTab_w3DSHA {tabNum_w3DSHA} {
    global .w3DSHA

    # make sure Lcl_ variables are known
    global  AllGlobalVars_w3DSHA
    foreach {e} $AllGlobalVars_w3DSHA {
        global Lcl_$e
    }

    # create GUI
    ttk::frame .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA
    .w3DSHA.dataBot.ntebk add .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA -text [::msgcat::mc "Gr $tabNum_w3DSHA"]

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.spacer00 -width 5 -text ""
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.spacer00 -row 0 -column 0

    #-------------
    # header for the for the group configuration

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pq1 -width 10 -text [::msgcat::mc "Name"]
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pq1 -row 6 -column 1 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pq2 -width 10 -text [::msgcat::mc "Number"]
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pq2 -row 6 -column 2 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pq3 -width 10 -text [::msgcat::mc "Rib ini"]
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pq3 -row 6 -column 3 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pq4 -width 10 -text [::msgcat::mc "Rib fin"]
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pq4 -row 6 -column 4 -sticky e

    #-------------
    # entrys for the group configuration
    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq1 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,1)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq1 [::msgcat::mc "Group name"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq1 -row 7 -column 1 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq2 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,2)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq2 [::msgcat::mc "Number"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq2 -row 7 -column 2 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq3 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,3)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq3 [::msgcat::mc "Initial rib"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq3 -row 7 -column 3 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq4 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,4)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq4 [::msgcat::mc "Final rib"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pq4 -row 7 -column 4 -sticky e -pady 1

    #-------------
    # header for the upper surface
    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pr1 -width 10 -text "Surface"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pr1 -row 8 -column 1 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pr2 -width 10 -text "Cuts"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pr2 -row 8 -column 2 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pr3 -width 10 -text "Type"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.pr3 -row 8 -column 3 -sticky e

    #-------------
    # entrys for the group configuration
    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pr1 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,5)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pr1 [::msgcat::mc "Upper surface definition"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pr1 -row 9 -column 1 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pr2 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,6)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pr2 [::msgcat::mc "Number ot transversal cuts"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pr2 -row 9 -column 2 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pr3 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,7)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pr3 [::msgcat::mc "Cut type"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_pr3 -row 9 -column 3 -sticky e -pady 1

    #-------------
    # header and entrys for upper surface
    if { $Lcl_num3DS($tabNum_w3DSHA,6) != 0 } {
    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p1 -width 10 -text "Cut"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p1 -row 10 -column 1 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p2 -width 10 -text "Point 1"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p2 -row 10 -column 2 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p3 -width 10 -text "Point 2"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p3 -row 10 -column 3 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p4 -width 10 -text "Depth"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p4 -row 10 -column 4 -sticky e
         # Add upper surface data lines
         for { set i 1 } { $i <= $Lcl_num3DS($tabNum_w3DSHA,6) } { incr i } {
             AddItemLine_w3DSHA $tabNum_w3DSHA $i
         }
    }

    # select next line
    if { $Lcl_num3DS($tabNum_w3DSHA,6) == 0 } {
    set sum 0
    }
    if { $Lcl_num3DS($tabNum_w3DSHA,6) == 1 } {
    set sum 2
    }
    if { $Lcl_num3DS($tabNum_w3DSHA,6) == 2 } {
    set sum 3
    }
    #-------------
    # header for the group configuration (lower surface)
    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.ps1 -width 10 -text "Surface"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.ps1 -row [expr (10 + $sum)] -column 1 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.ps2 -width 10 -text "Cuts"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.ps2 -row [expr (10 + $sum)] -column 2 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.ps3 -width 10 -text "Type"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.ps3 -row [expr (10 + $sum)] -column 3 -sticky e

    #-------------
    # entrys for the lower surface
    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_ps1 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,8)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_ps1 [::msgcat::mc "Lower surface definition"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_ps1 -row [expr (11 + $sum)] -column 1 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_ps2 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,9)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_ps2 [::msgcat::mc "Number ot transversal cuts"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_ps2 -row [expr (11 + $sum)] -column 2 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_ps3 -width 10 -textvariable Lcl_num3DS($tabNum_w3DSHA,10)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_ps3 [::msgcat::mc "Cut type"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.e_ps3 -row [expr (11 + $sum)] -column 3 -sticky e -pady 1

    #-------------
    # header and entrys for lower surface
    if { $Lcl_num3DS($tabNum_w3DSHA,9) != 0 } {
    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p5 -width 10 -text "Cut"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p5 -row [expr (12 + $sum)] -column 1 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p6 -width 10 -text "Point 1"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p6 -row [expr (12 + $sum)] -column 2 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p7 -width 10 -text "Point 2"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p7 -row [expr (12 + $sum)] -column 3 -sticky e

    label       .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p8 -width 10 -text "Depth"
    grid        .w3DSHA.dataBot.ntebk.config$tabNum_w3DSHA.p8 -row [expr (12 + $sum)] -column 4 -sticky e
         # Add lower surface data lines
         for { set i 1 } { $i <= $Lcl_num3DS($tabNum_w3DSHA,9) } { incr i } {
             AddItemLine_w3DSHA_l $tabNum_w3DSHA $i [expr (12 + $sum)]
         }
    }


#    UpdateItemLineButtons_w3DSHA $tabNum_w3DSHA
}

#----------------------------------------------------------------------
#  DecItemLines_w3DSHA
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_w3DSHA {} {
    global .w3DSHA
    global Lcl_num3DS

    set currentTab [eval .w3DSHA.dataBot.ntebk index current]
    incr currentTab

    destroy .w3DSHA.dataBot.ntebk.config$currentTab.e_p1$Lcl_num3DS($currentTab,4)
    destroy .w3DSHA.dataBot.ntebk.config$currentTab.e_p2$Lcl_num3DS($currentTab,4)
    destroy .w3DSHA.dataBot.ntebk.config$currentTab.e_p3$Lcl_num3DS($currentTab,4)
    destroy .w3DSHA.dataBot.ntebk.config$currentTab.e_p4$Lcl_num3DS($currentTab,4)
    destroy .w3DSHA.dataBot.ntebk.config$currentTab.e_p5$Lcl_num3DS($currentTab,4)
    incr Lcl_num3DS($currentTab,4) -1

    UpdateItemLineButtons_w3DSHA 0
}

#----------------------------------------------------------------------
#  IncItemLines_w3DSHA
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_w3DSHA {} {
    global .w3DSHA
    global Lcl_num3DS

    set currentTab [eval .w3DSHA.dataBot.ntebk index current]
    incr currentTab

    incr Lcl_num3DS($currentTab,4)

    UpdateItemLineButtons_w3DSHA 0

    # init additional variables
    CreateInitialItemLineVars_w3DSHA $currentTab

    AddItemLine_w3DSHA $currentTab $Lcl_num3DS($currentTab,4)
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_w3DSHA
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_w3DSHA { tabNum_w3DSHA } {
    global .w3DSHA
    global Lcl_num3DS
    global Lcl_line3DSu

    # init additional variables
    foreach i {1 2 3 4 5 6} {
        set Lcl_line3DSu($tabNum_w3DSHA,$i) 0.
    }
}

#----------------------------------------------------------------------
#  UpdateItemLineButtons_w3DSHA
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_w3DSHA { tabNum } {
    global .w3DSHA
    global Lcl_num3DS

    if { $tabNum == 0 } {
        set currentTab [eval .w3DSHA.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    if {$Lcl_num3DS($currentTab,4) > 1} {
        .w3DSHA.dataBot.ntebk.config$currentTab.b_decItems configure -state normal
    } else {
        .w3DSHA.dataBot.ntebk.config$currentTab.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_w3DSHA
#  Adds an additional Item Line to a tab
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_w3DSHA { tabNum lineNum} {
    global .w3DSHA
    global Lcl_line3DSu

    if { $tabNum == 0 } {
        set currentTab [eval .w3DSHA.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum.e_p1$lineNum -width 10 -textvariable Lcl_line3DSu($currentTab,$lineNum,1)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum.e_p1$lineNum [::msgcat::mc "Cut number"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum.e_p1$lineNum -row [expr (10 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum.e_p2$lineNum -width 10 -textvariable Lcl_line3DSu($currentTab,$lineNum,2)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum.e_p2$lineNum [::msgcat::mc "Point 1"]   HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum.e_p2$lineNum -row [expr (10 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum.e_p3$lineNum -width 10 -textvariable Lcl_line3DSu($currentTab,$lineNum,3)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum.e_p3$lineNum [::msgcat::mc "Point 2"]   HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum.e_p3$lineNum -row [expr (10 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum.e_p4$lineNum -width 10 -textvariable Lcl_line3DSu($currentTab,$lineNum,4)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum.e_p4$lineNum [::msgcat::mc "Depth of the 3D effect, use positive or negative value"]   HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum.e_p4$lineNum -row [expr (10 + $lineNum)] -column 4 -sticky e -pady 1

}


proc AddItemLine_w3DSHA_l { tabNum lineNum line_pointer} {
    global .w3DSHA
    global Lcl_line3DSl

    if { $tabNum == 0 } {
        set currentTab [eval .w3DSHA.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum.e_p5$lineNum -width 10 -textvariable Lcl_line3DSl($currentTab,$lineNum,1)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum.e_p5$lineNum [::msgcat::mc "Cut number"] HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum.e_p5$lineNum -row [expr ($line_pointer + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum.e_p6$lineNum -width 10 -textvariable Lcl_line3DSl($currentTab,$lineNum,2)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum.e_p6$lineNum [::msgcat::mc "Point 1"]   HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum.e_p6$lineNum -row [expr ($line_pointer + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum.e_p7$lineNum -width 10 -textvariable Lcl_line3DSl($currentTab,$lineNum,3)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum.e_p7$lineNum [::msgcat::mc "Point 2"]   HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum.e_p7$lineNum -row [expr ($line_pointer + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .w3DSHA.dataBot.ntebk.config$tabNum.e_p8$lineNum -width 10 -textvariable Lcl_line3DSl($currentTab,$lineNum,4)
    SetHelpBind .w3DSHA.dataBot.ntebk.config$tabNum.e_p8$lineNum [::msgcat::mc "Depth of the 3D effect, use positive or negative value"]   HelpText_w3DSHA
    grid        .w3DSHA.dataBot.ntebk.config$tabNum.e_p8$lineNum -row [expr ($line_pointer + $lineNum)] -column 4 -sticky e -pady 1

}
