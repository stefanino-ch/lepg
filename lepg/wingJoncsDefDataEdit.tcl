#---------------------------------------------------------------------
#
#  Window to edit the joncs definition (section 21)
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
global  Lcl_wJONCSDEF_DataChanged
set     Lcl_wJONCSDEF_DataChanged    0

global  AllGlobalVars_wJONCSDEF
set     AllGlobalVars_wJONCSDEF { k_section21 numGroupsJDdb numGroupsJD numDataBlocJD \
                                  numJoncsDef lineJoncsDef1 lineJoncsDef2 }

#----------------------------------------------------------------------
#  wingSuspensionLinesDataEdit
#  Displays a window to edit the suspension lines data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingJoncsDefDataEdit {} {
    source "windowExplanationsHelper.tcl"

    global .wJONCSDEF

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wJONCSDEF
    foreach {e} $AllGlobalVars_wJONCSDEF {
        global Lcl_$e
    }

    SetLclVars_wJONCSDEF

    toplevel .wJONCSDEF
    focus .wJONCSDEF

    wm protocol .wJONCSDEF WM_DELETE_WINDOW { CancelButtonPress_wJONCSDEF }

    wm title .wJONCSDEF [::msgcat::mc "Section 21: Joncsdefinition configuration"]

    #-------------
    # Frames and grids
    ttk::frame      .wJONCSDEF.dataTop
    ttk::frame      .wJONCSDEF.dataBot
    ttk::labelframe .wJONCSDEF.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .wJONCSDEF.btn
    #
    grid .wJONCSDEF.dataTop         -row 0 -column 0 -sticky w
    grid .wJONCSDEF.dataBot         -row 1 -column 0 -sticky w
    grid .wJONCSDEF.help            -row 2 -column 0 -sticky e
    grid .wJONCSDEF.btn             -row 3 -column 0 -sticky e
    #
    #-------------
    # Spacer for line 1
    label       .wJONCSDEF.dataTop.spacer00 -width 5 -text ""
    grid        .wJONCSDEF.dataTop.spacer00 -row 1 -column 0
    
    #-------------
    # Control parameter, entry
    label       .wJONCSDEF.dataTop.ctrl1 -width 16 -text [::msgcat::mc "Scheme"]
    grid        .wJONCSDEF.dataTop.ctrl1 -row 2 -column 0 -sticky e
    ttk::entry  .wJONCSDEF.dataTop.e_ctrl1 -width 10 -textvariable Lcl_k_section21
    SetHelpBind .wJONCSDEF.dataTop.e_ctrl1 k_section21   HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataTop.e_ctrl1 -row 2 -column 1 -sticky w -pady 1

    if { $Lcl_k_section21 != 0 } {
    if { $Lcl_k_section21 == 1 } {
    #-------------
    # Data blocs parameter, entry
    label       .wJONCSDEF.dataTop.ctrl2 -width 16 -text [::msgcat::mc "Blocs"]
    grid        .wJONCSDEF.dataTop.ctrl2 -row 3 -column 0 -sticky e
    ttk::entry  .wJONCSDEF.dataTop.e_ctrl2 -width 10 -textvariable Lcl_numGroupsJDdb -state disabled
    SetHelpBind .wJONCSDEF.dataTop.e_ctrl2 numGroupsJDdb   HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataTop.e_ctrl2 -row 3 -column 1 -sticky w -pady 1
    }

    if { $Lcl_k_section21 == 2 } {
    #-------------
    # Data blocs parameter, entry
    label       .wJONCSDEF.dataTop.ctrl2 -width 16 -text [::msgcat::mc "Blocs"]
    grid        .wJONCSDEF.dataTop.ctrl2 -row 3 -column 0 -sticky e
    ttk::entry  .wJONCSDEF.dataTop.e_ctrl2 -width 10 -textvariable Lcl_numGroupsJDdb
    SetHelpBind .wJONCSDEF.dataTop.e_ctrl2 numGroupsJDdb   HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataTop.e_ctrl2 -row 3 -column 1 -sticky w -pady 1
    }
    # case k_section21 not 0
    }


    #-------------
    # Buttons dec inc
    if { $Lcl_k_section21 != 2 } {
    #-------------
    # Config of configs
    button      .wJONCSDEF.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Blocs"] -command DecConfigTabs_wJONCSDEF -state disabled
    grid        .wJONCSDEF.dataTop.b_dec    -row 4 -column 0 -sticky e -padx 3 -pady 3

    button      .wJONCSDEF.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Blocs"]  -command IncConfigTabs_wJONCSDEF -state disabled
    grid        .wJONCSDEF.dataTop.b_inc    -row 4 -column 1 -sticky e -padx 3 -pady 3
    # case not 2
    }
    if { $Lcl_k_section21 == 2 } {
    #-------------
    # Config of configs
    button      .wJONCSDEF.dataTop.b_dec     -width 20 -text [::msgcat::mc "dec Blocs"] -command DecConfigTabs_wJONCSDEF -state disabled
    grid        .wJONCSDEF.dataTop.b_dec    -row 4 -column 0 -sticky e -padx 3 -pady 3

    button      .wJONCSDEF.dataTop.b_inc     -width 20 -text [::msgcat::mc "inc Blocs"]  -command IncConfigTabs_wJONCSDEF
    grid        .wJONCSDEF.dataTop.b_inc    -row 4 -column 1 -sticky e -padx 3 -pady 3
    # case 2
    }

    ttk::notebook .wJONCSDEF.dataBot.ntebk
    pack .wJONCSDEF.dataBot.ntebk -fill both -expand 1
    for { set i 1 } { $i <= $Lcl_numGroupsJDdb } { incr i } {
        addEditTab_wJONCSDEF $i
    }
    UpdateConfigButtons_wJONCSDEF

    #-------------
    # explanations
    label .wJONCSDEF.help.e_help -width 80 -height 3 -background LightYellow -justify left -textvariable HelpText_wJONCSDEF
    grid  .wJONCSDEF.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .wJONCSDEF.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_wJONCSDEF
    button .wJONCSDEF.btn.ok     -width 10 -text "OK"        -command OkButtonPress_wJONCSDEF
    button .wJONCSDEF.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_wJONCSDEF
    button .wJONCSDEF.btn.help   -width 10 -text "Help"      -command HelpButtonPress_wJONCSDEF

    grid .wJONCSDEF.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .wJONCSDEF.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .wJONCSDEF.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .wJONCSDEF.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wJONCSDEF
}

#----------------------------------------------------------------------
#  SetLclVars_wJONCSDEF
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wJONCSDEF {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wJONCSDEF
    foreach {e} $AllGlobalVars_wJONCSDEF {
        global Lcl_$e
    }

    set Lcl_k_section21    $k_section21
    set Lcl_numGroupsJDdb  $numGroupsJDdb

    # iterate across all data blocs
    for { set db 1 } { $db <= $numGroupsJDdb } { incr db } {

       # groups in data bloc
       set Lcl_numGroupsJD($db)  $numGroupsJD($db)

       # data bloc numbers
       set Lcl_numDataBlocJD($db,1)  $numDataBlocJD($db,1)
       set Lcl_numDataBlocJD($db,2)  $numDataBlocJD($db,2)

       # numbers in group
       for { set gr 1 } { $gr <= $numGroupsJD($db) } { incr gr } {

       set Lcl_numJoncsDef($db,$gr,1)  $numJoncsDef($db,$gr,1)
       set Lcl_numJoncsDef($db,$gr,2)  $numJoncsDef($db,$gr,2)
       set Lcl_numJoncsDef($db,$gr,3)  $numJoncsDef($db,$gr,3)

       # case group type 1
       if { $numDataBlocJD($db,2) == 1 } {
              foreach i {1 2 3} {      
              foreach j {1 2 3 4} {
              set Lcl_lineJoncsDef1($db,$gr,$i,$j)  $lineJoncsDef1($db,$gr,$i,$j)     
              }
              }
       }
       # case group type 2
       if { $numDataBlocJD($db,2) == 2 } {
              foreach j {1 2 3 4 5} {      
              set Lcl_lineJoncsDef2($db,$gr,1,$j)  $lineJoncsDef2($db,$gr,1,$j)     
              }
              foreach j {1 2 3 4} {      
              set Lcl_lineJoncsDef2($db,$gr,2,$j)  $lineJoncsDef2($db,$gr,2,$j) 
              }
       }
       }
    } 
}

#----------------------------------------------------------------------
#  ExportLclVars_wJONCSDEF
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wJONCSDEF {} {
    source "globalWingVars.tcl"

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wJONCSDEF
    foreach {e} $AllGlobalVars_wJONCSDEF {
        global Lcl_$e
    }

    set k_section21  $Lcl_k_section21
    set numGroupsJDdb  $Lcl_numGroupsJDdb

    # iterate across all data blocs
    for { set db 1 } { $db <= $Lcl_numGroupsJDdb } { incr db } {

       # groups in data bloc
       set numGroupsJD($db)  $Lcl_numGroupsJD($db)

       # data bloc numbers
       set numDataBlocJD($db,1)  $Lcl_numDataBlocJD($db,1)
       set numDataBlocJD($db,2)  $Lcl_numDataBlocJD($db,2)

       # numbers in group
       for { set gr 1 } { $gr <= $numGroupsJD($db) } { incr gr } {

        set numJoncsDef($db,$gr,1)  $Lcl_numJoncsDef($db,$gr,1)
        set numJoncsDef($db,$gr,2)  $Lcl_numJoncsDef($db,$gr,2)
        set numJoncsDef($db,$gr,3)  $Lcl_numJoncsDef($db,$gr,3)
        
       # case group type 1
       if { $numDataBlocJD($db,2) == 1 } {
              foreach i {1 2 3} {      
              foreach j {1 2 3 4} {
              set lineJoncsDef1($db,$gr,$i,$j)  $Lcl_lineJoncsDef1($db,$gr,$i,$j)     
              }
              }
       }
       # case group type 2
       if { $numDataBlocJD($db,2) == 2 } {
              foreach j {1 2 3 4 5} {      
              set lineJoncsDef2($db,$gr,1,$j)  $Lcl_lineJoncsDef2($db,$gr,1,$j)     
              }
              foreach j {1 2 3 4} {      
              set lineJoncsDef2($db,$gr,2,$j)  $Lcl_lineJoncsDef2($db,$gr,2,$j) 
              }
       }
       }
   }
}

#----------------------------------------------------------------------
#  ApplyButtonPress_wJONCSDEF
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wJONCSDEF {} {
    global g_WingDataChanged
    global Lcl_wJONCSDEF_DataChanged

    if { $Lcl_wJONCSDEF_DataChanged == 1 } {
        ExportLclVars_wJONCSDEF

        set g_WingDataChanged       1
        set Lcl_wJONCSDEF_DataChanged    0
    }
#    destroy .wJONCSDEF
#    wingJoncsDefDataEdit 
}

#----------------------------------------------------------------------
#  OkButtonPress_wJONCSDEF
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wJONCSDEF {} {
    global .wJONCSDEF
    global g_WingDataChanged
    global Lcl_wJONCSDEF_DataChanged

    if { $Lcl_wJONCSDEF_DataChanged == 1 } {
        ExportLclVars_wJONCSDEF
        set g_WingDataChanged       1
        set Lcl_wJONCSDEF_DataChanged    0
    }

    UnsetLclVarTrace_wJONCSDEF
    destroy .wJONCSDEF
}

#----------------------------------------------------------------------
#  CancelButtonPress_wJONCSDEF
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wJONCSDEF {} {
    global .wJONCSDEF
    global g_WingDataChanged
    global Lcl_wJONCSDEF_DataChanged

    if { $Lcl_wJONCSDEF_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
                    -type yesno -icon warning \
                    -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .wJONCSDEF
            return 0
        }
    }

    set Lcl_wJONCSDEF_DataChanged 0
    UnsetLclVarTrace_wJONCSDEF
    destroy .wJONCSDEF

}

#----------------------------------------------------------------------
#  HelpButtonPress_wJONCSDEF
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wJONCSDEF {} {
    source "userHelp.tcl"

    displayHelpfile "F21-help"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wJONCSDEF
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wJONCSDEF {} {

    global AllGlobalVars_wJONCSDEF

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wJONCSDEF {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wJONCSDEF }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wJONCSDEF
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wJONCSDEF {} {

    global AllGlobalVars_wJONCSDEF

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wJONCSDEF {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wJONCSDEF }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wJONCSDEF
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wJONCSDEF { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wJONCSDEF_DataChanged

    set Lcl_wJONCSDEF_DataChanged 1
}

#----------------------------------------------------------------------
#  DecConfigTabs_wJONCSDEF
#  Decreases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecConfigTabs_wJONCSDEF {} {
    global .wJONCSDEF
    global Lcl_numGroupsJDdb

    destroy .wJONCSDEF.dataBot.ntebk.config$Lcl_numGroupsJDdb

    incr Lcl_numGroupsJDdb -1

    UpdateConfigButtons_wJONCSDEF
}

#----------------------------------------------------------------------
#  IncConfigTabs_wJONCSDEF
#  Increases the number of config tabs
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncConfigTabs_wJONCSDEF {} {
    global .wJONCSDEF
    global Lcl_numGroupsJDdb

    incr Lcl_numGroupsJDdb

    UpdateConfigButtons_wJONCSDEF

    # new tab means we must initialize the variables
    CreateInitialConfigVars_wJONCSDEF $Lcl_numGroupsJDdb

    addEditTab_wJONCSDEF $Lcl_numGroupsJDdb
}

#----------------------------------------------------------------------
#  CreateInitialConfigVars_wJONCSDEF
#  Creates an initial set of initial variable to display an empty
#  configuration tab
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialConfigVars_wJONCSDEF { tabNum_wJONCSDEF } {

    global k_section21
    global Lcl_numJoncsDef
    global Lcl_numGroupsJD
    global Lcl_numGroupsJDdb
    global Lcl_numDataBlocJD
    global Lcl_lineJoncsDef1
    global Lcl_lineJoncsDef2

#    set Lcl_k_section21 1

#    set Lcl_numGroupsJDdb 1

    set Lcl_numGroupsJD($tabNum_wJONCSDEF) 1
    set Lcl_numDataBlocJD($tabNum_wJONCSDEF,1) 1
    set Lcl_numDataBlocJD($tabNum_wJONCSDEF,2) 1
  
    foreach k {1 2 3} {
    set gr 1
    while { $gr <= 50 } {
    set Lcl_numJoncsDef($tabNum_wJONCSDEF,$gr,$k) 1
    incr gr
    }
    }

    foreach i {1 2 3} {
    foreach j {1 2 3 4} {
    set gr 1
    while { $gr <= 50 } {
    set Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,$i,$j) 1
    incr gr
    }
    }
    }

    set gr 1
    while { $gr <= 50 } {
    foreach j {1 2 3 4 5} {
    set Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,1,$j) 1
    }
    foreach j {1 2 3 4} {
    set Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,2,$j) 1
    }
    incr gr
    }

    CreateInitialItemLineVars_wJONCSDEF $tabNum_wJONCSDEF
}

#----------------------------------------------------------------------
#  UpdateConfigButtons_wJONCSDEF
#  Updates the status of the config buttons depending on the number of
#  configs.
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateConfigButtons_wJONCSDEF {} {
    global .wJONCSDEF
    global Lcl_numGroupsJDdb

    if {$Lcl_numGroupsJDdb > 1} {
        .wJONCSDEF.dataTop.b_dec configure -state normal
    } else {
        .wJONCSDEF.dataTop.b_dec configure -state disabled
    }
}

#----------------------------------------------------------------------
#  addEditTab_wJONCSDEF
#  Adds all the edit elements needed for one config tab
#
#  IN:      Number of the new tab to be created (1..)
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc addEditTab_wJONCSDEF {tabNum_wJONCSDEF} {
    global .wJONCSDEF

    # make sure Lcl_ variables are known
    global  AllGlobalVars_wJONCSDEF
    foreach {e} $AllGlobalVars_wJONCSDEF {
        global Lcl_$e
    }

    # create GUI
    ttk::frame .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF
    .wJONCSDEF.dataBot.ntebk add .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF -text [::msgcat::mc "Bl $tabNum_wJONCSDEF"]

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.spacer00 -width 5 -text ""
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.spacer00 -row 0 -column 0

    #-------------
    # Config of items
#    button      .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.b_decItems     -width 10 -text [::msgcat::mc "dec Points"] -command DecItemLines_wJONCSDEF -state disabled
#    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.b_decItems    -row 1 -column 1 -sticky e -padx 3 -pady 3

#    button      .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.b_incItems     -width 10 -text [::msgcat::mc "inc Points"]  -command IncItemLines_wJONCSDEF
#    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.b_incItems    -row 1 -column 2 -sticky e -padx 3 -pady 3

#    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.spacer20 -width 5 -text ""
#    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.spacer20 -row 2 -column 0

    #-------------
    # header for the for the group configuration

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.db1 -width 10 -text [::msgcat::mc "Bloc"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.db1 -row 1 -column 1 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.db2 -width 10 -text [::msgcat::mc "Type"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.db2 -row 1 -column 2 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.db3 -width 10 -text [::msgcat::mc "Groups"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.db3 -row 3 -column 0 -sticky e

    if { $Lcl_k_section21 == 0} {
    #-------------
    }

    if { $Lcl_k_section21 == 1} {
    #-------------
    # entrys for the data bloc configuration
    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db1 -width 10 -textvariable Lcl_numDataBlocJD($tabNum_wJONCSDEF,1) -state disabled
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db1 [::msgcat::mc "Data bloc number"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db1 -row 2 -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db2 -width 10 -textvariable Lcl_numDataBlocJD($tabNum_wJONCSDEF,2) -state disabled
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db2 [::msgcat::mc "Data bloc type"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db2 -row 2 -column 2 -sticky e -pady 1
    }

    if { $Lcl_k_section21 == 2} {
    #-------------
    # entrys for the data bloc configuration
    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db1 -width 10 -textvariable Lcl_numDataBlocJD($tabNum_wJONCSDEF,1)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db1 [::msgcat::mc "Data bloc number"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db1 -row 2 -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db2 -width 10 -textvariable Lcl_numDataBlocJD($tabNum_wJONCSDEF,2)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db2 [::msgcat::mc "Data bloc type"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db2 -row 2 -column 2 -sticky e -pady 1
    }

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db3 -width 10 -textvariable Lcl_numGroupsJD($tabNum_wJONCSDEF)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db3 [::msgcat::mc "Number of groups in data bloc"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_db3 -row 3 -column 1 -sticky e -pady 1


    #-------------
    # iterate in number of groups
    set gr 1
    while {$gr <= $Lcl_numGroupsJD($tabNum_wJONCSDEF)} {

    #-------------
    # Case group type 1
    if { $Lcl_numDataBlocJD($tabNum_wJONCSDEF,2) == 1 } {

    #-------------
    # header for the for the group configuration
    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq1$gr -width 10 -text [::msgcat::mc "Num"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq1$gr -row [expr (4 + 7*$gr)] -column 1 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq2$gr -width 10 -text [::msgcat::mc "Rib ini"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq2$gr -row [expr (4 + 7*$gr)] -column 2 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq3$gr -width 10 -text [::msgcat::mc "Rib fin"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq3$gr -row [expr (4 + 7*$gr)] -column 3 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq4$gr -width 12 -text [::msgcat::mc "Group"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq4$gr -row [expr (5 + 7*$gr)] -column 0 -sticky e

    #-------------
    # entrys for the group configuration
    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq1$gr -width 10 -textvariable Lcl_numJoncsDef($tabNum_wJONCSDEF,$gr,1)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq1$gr [::msgcat::mc "Group number"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq1$gr -row [expr (5 + 7*$gr)] -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq2$gr -width 10 -textvariable Lcl_numJoncsDef($tabNum_wJONCSDEF,$gr,2)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq2$gr [::msgcat::mc "Initial rib"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq2$gr -row [expr (5 + 7*$gr)] -column 2 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq3$gr -width 10 -textvariable Lcl_numJoncsDef($tabNum_wJONCSDEF,$gr,3)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq3$gr [::msgcat::mc "Final rib"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq3$gr -row [expr (5 + 7*$gr)] -column 3 -sticky e -pady 1

    #-------------
    # header for the item point
    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p1$gr -width 10 -text "xini"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p1$gr -row [expr (6 + 7*$gr)] -column 1 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p2$gr -width 10 -text "xfin"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p2$gr -row [expr (6 + 7*$gr)] -column 2 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p3$gr -width 10 -text "y"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p3$gr -row [expr (6 + 7*$gr)] -column 3 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p4$gr -width 10 -text "n"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p4$gr -row [expr (6 + 7*$gr)] -column 4 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p5$gr -width 10 -text "Upper"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p5$gr -row [expr (7 + 7*$gr)] -column 0 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p6$gr -width 10 -text "Lower"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p6$gr -row [expr (8 + 7*$gr)] -column 0 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p7$gr -width 10 -text "s1"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p7$gr -row [expr (9 + 7*$gr)] -column 1 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p8$gr -width 10 -text "s2"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p8$gr -row [expr (9 + 7*$gr)] -column 2 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p9$gr -width 10 -text "s3"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p9$gr -row [expr (9 + 7*$gr)] -column 3 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p10$gr -width 10 -text "s4"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p10$gr -row [expr (9 + 7*$gr)] -column 4 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p11$gr -width 10 -text "Pocket"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p11$gr -row [expr (10 + 7*$gr)] -column 0 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pes$gr -width 10 -text ""
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pes$gr -row [expr (10 + 7*$gr)] -column 5 -sticky e


    #-------------
    # entrys for upper lower joncs
    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt1$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,1,1)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt1$gr [::msgcat::mc "xini"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt1$gr -row [expr (7 + 7*$gr)] -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt2$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,1,2)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt2$gr [::msgcat::mc "xfin"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt2$gr -row [expr (7 + 7*$gr)] -column 2 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt3$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,1,3)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt3$gr [::msgcat::mc "vertical jonc deflection"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt3$gr -row [expr (7 + 7*$gr)] -column 3 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt4$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,1,4)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt4$gr [::msgcat::mc "exponent"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt4$gr -row [expr (7 + 7*$gr)] -column 4 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt5$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,2,1)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt5$gr [::msgcat::mc "xini"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt5$gr -row [expr (8 + 7*$gr)] -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq6$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,2,2)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq6$gr [::msgcat::mc "xfin"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq6$gr -row [expr (8 + 7*$gr)] -column 2 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq7$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,2,3)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq7$gr [::msgcat::mc "vertical jonc deflection"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq7$gr -row [expr (8 + 7*$gr)] -column 3 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq8$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,2,4)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq8$gr [::msgcat::mc "exponent"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq8$gr -row [expr (8 + 7*$gr)] -column 4 -sticky e -pady 1

    #-------------
    # entrys for the pockets parameters
    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p7$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,3,1)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p7$gr [::msgcat::mc "s1"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p7$gr -row [expr (10 + 7*$gr)] -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p8$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,3,2)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p8$gr [::msgcat::mc "s2"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p8$gr -row [expr (10 + 7*$gr)] -column 2 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p9$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,3,3)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p9$gr [::msgcat::mc "s3"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p9$gr -row [expr (10 + 7*$gr)] -column 3 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p10$gr -width 10 -textvariable Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$gr,3,4)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p10$gr [::msgcat::mc "s4"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p10$gr -row [expr (10 + 7*$gr)] -column 4 -sticky e -pady 1

    }
    # case group type 1


    #-------------
    # Case group type 2
    if { $Lcl_numDataBlocJD($tabNum_wJONCSDEF,2) == 2 } {

    #-------------
    # header for the for the group configuration
    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq1$gr -width 10 -text [::msgcat::mc "Num"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq1$gr -row [expr (4 + 7*$gr)] -column 1 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq2$gr -width 10 -text [::msgcat::mc "Rib ini"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq2$gr -row [expr (4 + 7*$gr)] -column 2 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq3$gr -width 10 -text [::msgcat::mc "Rib fin"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq3$gr -row [expr (4 + 7*$gr)] -column 3 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq4$gr -width 12 -text [::msgcat::mc "Group"]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pq4$gr -row [expr (5 + 7*$gr)] -column 0 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pesp$gr -width 10 -text [::msgcat::mc ""]
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.pesp$gr -row [expr (5 + 7*$gr)] -column 6 -sticky e

    #-------------
    # entrys for the group configuration
    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq1$gr -width 10 -textvariable Lcl_numJoncsDef($tabNum_wJONCSDEF,$gr,1)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq1$gr [::msgcat::mc "Group number"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq1$gr -row [expr (5 + 7*$gr)] -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq2$gr -width 10 -textvariable Lcl_numJoncsDef($tabNum_wJONCSDEF,$gr,2)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq2$gr [::msgcat::mc "Initial rib"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq2$gr -row [expr (5 + 7*$gr)] -column 2 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq3$gr -width 10 -textvariable Lcl_numJoncsDef($tabNum_wJONCSDEF,$gr,3)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq3$gr [::msgcat::mc "Final rib"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pq3$gr -row [expr (5 + 7*$gr)] -column 3 -sticky e -pady 1

    #-------------
    # header for the item point
    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p1$gr -width 10 -text "x1"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p1$gr -row [expr (6 + 7*$gr)] -column 1 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p2$gr -width 10 -text "y1"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p2$gr -row [expr (6 + 7*$gr)] -column 2 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p3$gr -width 10 -text "x2"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p3$gr -row [expr (6 + 7*$gr)] -column 3 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p4$gr -width 10 -text "y2"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p4$gr -row [expr (6 + 7*$gr)] -column 4 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p5$gr -width 10 -text "d"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p5$gr -row [expr (6 + 7*$gr)] -column 5 -sticky e

    #-------------
    # entrys for points 1, 2 and arc deflection
    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt1$gr -width 10 -textvariable Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,1,1)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt1$gr [::msgcat::mc "Initial point, coordinate x1"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt1$gr -row [expr (7 + 7*$gr)] -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt2$gr -width 10 -textvariable Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,1,2)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt2$gr [::msgcat::mc "Initial point, coordinate y1"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt2$gr -row [expr (7 + 7*$gr)] -column 2 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt3$gr -width 10 -textvariable Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,1,3)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt3$gr [::msgcat::mc "Final point, coordinate x2"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt3$gr -row [expr (7 + 7*$gr)] -column 3 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt4$gr -width 10 -textvariable Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,1,4)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt4$gr [::msgcat::mc "Final point, coordinate y2"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt4$gr -row [expr (7 + 7*$gr)] -column 4 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt5$gr -width 10 -textvariable Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,1,5)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt5$gr [::msgcat::mc "Arc deflection percent"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_pt5$gr -row [expr (7 + 7*$gr)] -column 5 -sticky e -pady 1

    #-------------
    # labels for pockets
    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p7$gr -width 10 -text "s1"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p7$gr -row [expr (8 + 7*$gr)] -column 1 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p8$gr -width 10 -text "s2"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p8$gr -row [expr (8 + 7*$gr)] -column 2 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p9$gr -width 10 -text "s3"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p9$gr -row [expr (8 + 7*$gr)] -column 3 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p10$gr -width 10 -text "s4"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p10$gr -row [expr (8 + 7*$gr)] -column 4 -sticky e

    label       .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p11$gr -width 10 -text "Pocket"
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.p11$gr -row [expr (9 + 7*$gr)] -column 0 -sticky e

    #-------------
    # entrys for the pockets parameters
    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p7$gr -width 10 -textvariable Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,2,1)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p7$gr [::msgcat::mc "s1"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p7$gr -row [expr (9 + 7*$gr)] -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p8$gr -width 10 -textvariable Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,2,2)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p8$gr [::msgcat::mc "s2"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p8$gr -row [expr (9 + 7*$gr)] -column 2 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p9$gr -width 10 -textvariable Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,2,3)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p9$gr [::msgcat::mc "s3"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p9$gr -row [expr (9 + 7*$gr)] -column 3 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p10$gr -width 10 -textvariable Lcl_lineJoncsDef2($tabNum_wJONCSDEF,$gr,2,4)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p10$gr [::msgcat::mc "s4"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum_wJONCSDEF.e_p10$gr -row [expr (9 + 7*$gr)] -column 4 -sticky e -pady 1

    }
    # case group type 2


    incr gr
    # end number of groups
    }


#    for { set i 1 } { $i <= $Lcl_numJoncsDef($tabNum_wJONCSDEF,4) } { incr i } {
#         AddItemLine_wJONCSDEF $tabNum_wJONCSDEF 1
#    }

#    UpdateItemLineButtons_wJONCSDEF $tabNum_wJONCSDEF
}

#----------------------------------------------------------------------
#  DecItemLines_wJONCSDEF
#  Decreases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DecItemLines_wJONCSDEF {} {
    global .wJONCSDEF
    global Lcl_numJoncsDef

    set currentTab [eval .wJONCSDEF.dataBot.ntebk index current]
    incr currentTab

    destroy .wJONCSDEF.dataBot.ntebk.config$currentTab.e_p1$Lcl_numJoncsDef($currentTab,4)
    destroy .wJONCSDEF.dataBot.ntebk.config$currentTab.e_p2$Lcl_numJoncsDef($currentTab,4)
    destroy .wJONCSDEF.dataBot.ntebk.config$currentTab.e_p3$Lcl_numJoncsDef($currentTab,4)
    destroy .wJONCSDEF.dataBot.ntebk.config$currentTab.e_p4$Lcl_numJoncsDef($currentTab,4)
    destroy .wJONCSDEF.dataBot.ntebk.config$currentTab.e_p5$Lcl_numJoncsDef($currentTab,4)
    incr Lcl_numJoncsDef($currentTab,4) -1

    UpdateItemLineButtons_wJONCSDEF 0
}

#----------------------------------------------------------------------
#  IncItemLines_wJONCSDEF
#  Increases the number of config item lines
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc IncItemLines_wJONCSDEF {} {
    global .wJONCSDEF
    global Lcl_numJoncsDef

    set currentTab [eval .wJONCSDEF.dataBot.ntebk index current]
    incr currentTab

    incr Lcl_numJoncsDef($currentTab,4)

    UpdateItemLineButtons_wJONCSDEF 0

    # init additional variables
    CreateInitialItemLineVars_wJONCSDEF $currentTab

    AddItemLine_wJONCSDEF $currentTab $Lcl_numJoncsDef($currentTab,4)
}

#----------------------------------------------------------------------
#  CreateInitialItemLineVars_wJONCSDEF
#  Create the initial vars to display an empty item line
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CreateInitialItemLineVars_wJONCSDEF { tabNum_wJONCSDEF } {
    global .wJONCSDEF
    global Lcl_numJoncsDef
    global Lcl_lineJoncsDef1

    # init additional variables
    foreach i {1 2 3 4 5 6} {
        set Lcl_lineJoncsDef1($tabNum_wJONCSDEF,$i) 0.
    }
}

#----------------------------------------------------------------------
#  UpdateItemLineButtons_wJONCSDEF
#  Updates the status of the config item buttons depending on the number of
#  lines.
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UpdateItemLineButtons_wJONCSDEF { tabNum } {
    global .wJONCSDEF
    global Lcl_numJoncsDef

    if { $tabNum == 0 } {
        set currentTab [eval .wJONCSDEF.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    if {$Lcl_numJoncsDef($currentTab,4) > 1} {
        .wJONCSDEF.dataBot.ntebk.config$currentTab.b_decItems configure -state normal
    } else {
        .wJONCSDEF.dataBot.ntebk.config$currentTab.b_decItems configure -state disabled
    }
}

#----------------------------------------------------------------------
#  AddItemLine_wJONCSDEF
#  Adds an additional Item Line to a tab
#
#  IN:      0:  update current taben
#           >9: number of the tab to be updated
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc AddItemLine_wJONCSDEF { tabNum lineNum} {
    global .wJONCSDEF
    global Lcl_lineJoncsDef1

    if { $tabNum == 0 } {
        set currentTab [eval .wJONCSDEF.dataBot.ntebk index current]
        incr currentTab
    } else {
        set currentTab $tabNum
    }

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p1$lineNum -width 10 -textvariable Lcl_lineJoncsDef1($currentTab,1)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p1$lineNum [::msgcat::mc "Scheme for A tab"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p1$lineNum -row [expr (10-1 + $lineNum)] -column 1 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p2$lineNum -width 10 -textvariable Lcl_lineJoncsDef1($currentTab,2)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p2$lineNum [::msgcat::mc "Scheme for B tab"]  HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p2$lineNum -row [expr (10-1 + $lineNum)] -column 2 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p3$lineNum -width 10 -textvariable Lcl_lineJoncsDef1($currentTab,3)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p3$lineNum [::msgcat::mc "Scheme for C tab"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p3$lineNum -row [expr (10-1 + $lineNum)] -column 3 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p4$lineNum -width 10 -textvariable Lcl_lineJoncsDef1($currentTab,4)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p4$lineNum [::msgcat::mc "Scheme for D tab"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p4$lineNum -row [expr (10-1 + $lineNum)] -column 4 -sticky e -pady 1

    ttk::entry  .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p5$lineNum -width 10 -textvariable Lcl_lineJoncsDef1($currentTab,5)
    SetHelpBind .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p5$lineNum [::msgcat::mc "Scheme for E tab"] HelpText_wJONCSDEF
    grid        .wJONCSDEF.dataBot.ntebk.config$tabNum.e_p5$lineNum -row [expr (10-1 + $lineNum)] -column 5 -sticky e -pady 1

}
