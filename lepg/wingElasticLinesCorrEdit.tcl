#---------------------------------------------------------------------
#
#  Window to edit the elastic lines correction
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#-------
# Globals
global .welc

global  Lcl_wELC_DataChanged
set     Lcl_wELC_DataChanged    0

global  AllGlobalVars_wELC
set     AllGlobalVars_wELC { loadTot loadDistr loadDeform }

#----------------------------------------------------------------------
#  wingElasticLinesCorrEdit
#  Displays a window to edit the basic wing data
#
#  IN:      N/A
#  OUT:     N/A

#  Returns: N/A
#----------------------------------------------------------------------
proc wingElasticLinesCorrEdit {} {
    source "globalWingVars.tcl"
    global AllGlobalVars_wELC

    source "windowExplanationsHelper.tcl"

    global .welc

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wELC {
        global Lcl_$e
    }

    SetLclVars_wELC

    toplevel .welc
    focus .welc

    wm protocol .welc WM_DELETE_WINDOW { CancelButtonPress_wELC }

    wm title .welc [::msgcat::mc "Section 18: Elastic lines correction"]

    #-------------
    # Frames and grids
    ttk::frame      .welc.data
    ttk::labelframe .welc.help -text [::msgcat::mc "Explanations"]
    ttk::frame      .welc.btn
    #
    grid .welc.data         -row 0 -column 0 -sticky e
    grid .welc.help         -row 1 -column 0 -sticky e
    grid .welc.btn          -row 2 -column 0 -sticky e
    #
    #-------------
    # Data fields setup

    # load in flight
    ttk::labelframe .welc.data.lF_inFlightWeight -text [::msgcat::mc "In flight weight"]
    grid            .welc.data.lF_inFlightWeight -row 0 -column 0 -sticky w -padx 10 -pady 3

    ttk::label      .welc.data.lF_inFlightWeight.inFlightWeigth -text [::msgcat::mc "In flight weight \[kg\]"] -width 20
    grid            .welc.data.lF_inFlightWeight.inFlightWeigth -row 0 -column 0 -sticky e -padx 10 -pady 3

    ttk::entry      .welc.data.lF_inFlightWeight.e_inFlightWeigth -width 10 -textvariable Lcl_loadTot
    SetHelpBind     .welc.data.lF_inFlightWeight.e_inFlightWeigth [::msgcat::mc "Total weight in flight (kg)"]   HelpText_wELC
    grid            .welc.data.lF_inFlightWeight.e_inFlightWeigth -row 0 -column 1 -sticky e -padx 10 -pady 3


    # Load distribution across Ribs
    ttk::labelframe .welc.data.lF_loadDistrRibs -text [::msgcat::mc "Load distribution across ribs"]
    grid            .welc.data.lF_loadDistrRibs -row 1 -column 0 -sticky e -padx 10 -pady 3

    # header
    for {set i 1} {$i <=5} {incr i} {
        ttk::label      .welc.data.lF_loadDistrRibs.perc$i -text [::msgcat::mc "%"] -width 15
        grid            .welc.data.lF_loadDistrRibs.perc$i -row 0 -column [expr $i] -sticky e
    }
    # first data line
    ttk::label          .welc.data.lF_loadDistrRibs.weight1 -text [::msgcat::mc "Load distribution in 2 lines rib \[%\]"] -width 30
    grid                .welc.data.lF_loadDistrRibs.weight1 -row 1 -column 0 -sticky e
    for {set i 1} {$i <=2} {incr i} {
        ttk::entry      .welc.data.lF_loadDistrRibs.weight1$i -width 14 -textvariable Lcl_loadDistr(1,$i)
        SetHelpBind     .welc.data.lF_loadDistrRibs.weight1$i loadDistr   HelpText_wELC
        grid            .welc.data.lF_loadDistrRibs.weight1$i -row 1 -column [expr $i] -sticky e -pady 1
    }
    # second data line
    ttk::label          .welc.data.lF_loadDistrRibs.weight2 -text [::msgcat::mc "Load distribution in 3 lines rib \[%\]"] -width 30
    grid                .welc.data.lF_loadDistrRibs.weight2 -row 2 -column 0 -sticky e
    for {set i 1} {$i <=3} {incr i} {
        ttk::entry      .welc.data.lF_loadDistrRibs.weight2$i -width 14 -textvariable Lcl_loadDistr(2,$i)
        SetHelpBind     .welc.data.lF_loadDistrRibs.weight2$i [::msgcat::mc "loadDistr"]   HelpText_wELC
        grid            .welc.data.lF_loadDistrRibs.weight2$i -row 2 -column [expr $i] -sticky e -pady 1
    }
    # third data line
    ttk::label          .welc.data.lF_loadDistrRibs.weight3 -text [::msgcat::mc "Load distribution in 4 lines rib \[%\]"] -width 30
    grid                .welc.data.lF_loadDistrRibs.weight3 -row 3 -column 0 -sticky e
    for {set i 1} {$i <=4} {incr i} {
        ttk::entry      .welc.data.lF_loadDistrRibs.weight3$i -width 14 -textvariable Lcl_loadDistr(3,$i)
        SetHelpBind     .welc.data.lF_loadDistrRibs.weight3$i [::msgcat::mc "loadDistr"]  HelpText_wELC
        grid            .welc.data.lF_loadDistrRibs.weight3$i -row 3 -column [expr $i] -sticky e -pady 1
    }
    # fourth data line
    ttk::label          .welc.data.lF_loadDistrRibs.weight4 -text [::msgcat::mc "Load distribution in 5 lines rib \[%\]"] -width 30
    grid                .welc.data.lF_loadDistrRibs.weight4 -row 4 -column 0 -sticky e
    for {set i 1} {$i <=5} {incr i} {
        ttk::entry      .welc.data.lF_loadDistrRibs.weight4$i -width 14 -textvariable Lcl_loadDistr(4,$i)
        SetHelpBind     .welc.data.lF_loadDistrRibs.weight4$i [::msgcat::mc "loadDistr"]  HelpText_wELC
        grid            .welc.data.lF_loadDistrRibs.weight4$i -row 4 -column [expr $i] -sticky e -pady 1
    }

    # Load distribution across line levels
    ttk::labelframe .welc.data.lF_loadDistrLev -text [::msgcat::mc "Load distribution across levels"]
    grid            .welc.data.lF_loadDistrLev -row 2 -column 0 -sticky w -padx 10 -pady 3

    ttk::label      .welc.data.lF_loadDistrLev.col0 -text [::msgcat::mc "Num of lines per rib"] -width 30
    grid            .welc.data.lF_loadDistrLev.col0 -row 0 -column 0 -sticky e
    ttk::label      .welc.data.lF_loadDistrLev.col1 -text [::msgcat::mc "Deform. in lower level"] -width 25
    grid            .welc.data.lF_loadDistrLev.col1 -row 0 -column 1 -sticky e
    ttk::label      .welc.data.lF_loadDistrLev.col2 -text [::msgcat::mc "Deform. in medium level"] -width 25
    grid            .welc.data.lF_loadDistrLev.col2 -row 0 -column 2 -sticky e
    ttk::label      .welc.data.lF_loadDistrLev.col3 -text [::msgcat::mc "Deform. in high level"] -width 25
    grid            .welc.data.lF_loadDistrLev.col3 -row 0 -column 3 -sticky e

    for {set i 1} {$i <=5} {incr i} {
        ttk::label      .welc.data.lF_loadDistrLev.data1$i -text $Lcl_loadDeform($i,1) -width 30
        grid            .welc.data.lF_loadDistrLev.data1$i -row [expr $i] -column 0 -sticky e

        ttk::entry      .welc.data.lF_loadDistrLev.data2$i -width 25 -textvariable Lcl_loadDeform($i,2)
        SetHelpBind     .welc.data.lF_loadDistrLev.data2$i [::msgcat::mc "loadDeform"]   HelpText_wELC
        grid            .welc.data.lF_loadDistrLev.data2$i -row [expr $i] -column 1 -sticky e -pady 1

        ttk::entry      .welc.data.lF_loadDistrLev.data3$i -width 25 -textvariable Lcl_loadDeform($i,3)
        SetHelpBind     .welc.data.lF_loadDistrLev.data3$i [::msgcat::mc "loadDeform"]   HelpText_wELC
        grid            .welc.data.lF_loadDistrLev.data3$i -row [expr $i] -column 2 -sticky e -pady 1

        ttk::entry      .welc.data.lF_loadDistrLev.data4$i -width 25 -textvariable Lcl_loadDeform($i,4)
        SetHelpBind     .welc.data.lF_loadDistrLev.data4$i [::msgcat::mc "loadDeform"]   HelpText_wELC
        grid            .welc.data.lF_loadDistrLev.data4$i -row [expr $i] -column 3 -sticky e -pady 1
    }

    #-------------
    # explanations
    label .welc.help.e_help -width 40 -height 3 -background LightYellow -textvariable HelpText_wELC
    grid  .welc.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .welc.btn.apply  -width 10 -text [::msgcat::mc "Apply"]     -command ApplyButtonPress_wELC
    button .welc.btn.ok     -width 10 -text [::msgcat::mc "OK"]        -command OkButtonPress_wELC
    button .welc.btn.cancel -width 10 -text [::msgcat::mc "Cancel"]    -command CancelButtonPress_wELC
    button .welc.btn.help   -width 10 -text [::msgcat::mc "Help"]      -command HelpButtonPress_wELC

    grid .welc.btn.apply     -row 0 -column 1 -sticky e -padx 10 -pady 10
    grid .welc.btn.ok        -row 0 -column 2 -sticky e -padx 10 -pady 10
    grid .welc.btn.cancel    -row 0 -column 3 -sticky e -padx 10 -pady 10
    grid .welc.btn.help      -row 1 -column 3 -sticky e -padx 10 -pady 10

    SetLclVarTrace_wELC
}

#----------------------------------------------------------------------
#  SetLclVars_wELC
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_wELC {} {

    source "globalWingVars.tcl"
    global AllGlobalVars_wELC

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wELC {
        global Lcl_$e
    }

    set Lcl_loadTot   $loadTot

    for {set i 1} {$i <=2} {incr i} {
        set Lcl_loadDistr(1,$i) $loadDistr(1,$i)
    }

    for {set i 1} {$i <=3} {incr i} {
        set Lcl_loadDistr(2,$i) $loadDistr(2,$i)
    }

    for {set i 1} {$i <=4} {incr i} {
        set Lcl_loadDistr(3,$i) $loadDistr(3,$i)
    }

    for {set i 1} {$i <=5} {incr i} {
        set Lcl_loadDistr(4,$i) $loadDistr(4,$i)
    }

    for {set i 1} {$i <=5} {incr i} {
        for {set j 1} {$j <=4} {incr j} {
            set Lcl_loadDeform($i,$j) $loadDeform($i,$j)
        }
    }

}

#----------------------------------------------------------------------
#  ExportLclVars_wELC
#  Exports the local vars back into the global ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_wELC {} {
    source "globalWingVars.tcl"
    global AllGlobalVars_wELC

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wELC {
        global Lcl_$e
    }

    set loadTot   $Lcl_loadTot

    for {set i 1} {$i <=2} {incr i} {
        set loadDistr(1,$i) $Lcl_loadDistr(1,$i)
    }

    for {set i 1} {$i <=3} {incr i} {
        set loadDistr(2,$i) $Lcl_loadDistr(2,$i)
    }

    for {set i 1} {$i <=4} {incr i} {
        set loadDistr(3,$i) $Lcl_loadDistr(3,$i)
    }

    for {set i 1} {$i <=5} {incr i} {
        set loadDistr(4,$i) $Lcl_loadDistr(4,$i)
    }

    for {set i 1} {$i <=5} {incr i} {
        for {set j 1} {$j <=4} {incr j} {
            set loadDeform($i,$j) $Lcl_loadDeform($i,$j)
        }
    }

}

#----------------------------------------------------------------------
#  ApplyButtonPress_wELC
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress_wELC {} {
    global g_WingDataChanged
    global Lcl_wELC_DataChanged

    if { $Lcl_wELC_DataChanged == 1 } {
        ExportLclVars_wELC

        set g_WingDataChanged       1
        set Lcl_wELC_DataChanged    0
    }
}

#----------------------------------------------------------------------
#  OkButtonPress_wELC
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress_wELC {} {
    global .welc
    global g_WingDataChanged
    global Lcl_wELC_DataChanged

    if { $Lcl_wELC_DataChanged == 1 } {
        ExportLclVars_wELC
        set g_WingDataChanged       1
        set Lcl_wELC_DataChanged    0
    }

    UnsetLclVarTrace_wELC
    destroy .welc
}

#----------------------------------------------------------------------
#  CancelButtonPress_wELC
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_wELC {} {
    global .welc
    global g_WingDataChanged
    global Lcl_wELC_DataChanged

    if { $Lcl_wELC_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title [::msgcat::mc "Cancel"] \
                    -type yesno -icon warning \
                    -message [::msgcat::mc "All changed data will be lost.\nDo you really want to close the window?"]]
        if { $answer == "no" } {
            focus .welc
            return 0
        }
    }

    set Lcl_wELC_DataChanged 0
    UnsetLclVarTrace_wELC
    destroy .welc

}

#----------------------------------------------------------------------
#  HelpButtonPress_wELC
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress_wELC {} {
    source "userHelp.tcl"

    displayHelpfile "elastic-lines-correction"
}

#----------------------------------------------------------------------
#  SetLclVarTrace_wELC
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_wELC {} {

    global AllGlobalVars_wELC

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wELC {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_wELC }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_wELC
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_wELC {} {

    global AllGlobalVars_wELC

    # make sure Lcl_ variables are known
    foreach {e} $AllGlobalVars_wELC {
        global lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_wELC }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_wELC
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_wELC { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_wELC_DataChanged

    set Lcl_wELC_DataChanged 1
}
