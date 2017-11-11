#-------
# Globals

global VaultMode1
set VaultMode1 ""

global VaultMode2
set VaultMode2 ""

global CellMode3
set CellMode3 ""

#----------------------------------------------------------------------
#  proc EditPreProcData
#  The window to edit the pre processor data
#
#  IN:
#  OUT:
#----------------------------------------------------------------------

proc EditPreProcData {} {
    source "globalPreProcVars.tcl"

    global .epcw
    global VaultMode1
    global VaultMode2
    global HelpText

    foreach {e} $AllPreProcVars {
        global lcl_$e
    }

    SetLclVars
    SetLclVarTrace

    toplevel .epcw
    focus .epcw

    wm protocol .epcw WM_DELETE_WINDOW { CancelButtonPress }

    wm title .epcw [::msgcat::mc "Edit Geometry data"]

    ttk::labelframe .epcw.name -text [::msgcat::mc "Wing name"]

    ttk::labelframe .epcw.le -text [::msgcat::mc "Leading edge"]
    canvas .epcw.c_le -width 300 -height 150 -bg white

    ttk::labelframe .epcw.te -text [::msgcat::mc "Trailing edge"]
    canvas .epcw.c_te -width 300 -height 150 -bg white

    ttk::labelframe .epcw.vault -text [::msgcat::mc "Vault"]
    canvas .epcw.c_vault -width 300 -height 150 -bg white

    ttk::labelframe .epcw.cells -text [::msgcat::mc "Cell distribution"]

    ttk::labelframe .epcw.help -text [::msgcat::mc "Explanations"]

    ttk::frame .epcw.btn

    grid .epcw.name         -row 0 -column 0 -sticky e
    grid .epcw.le           -row 1 -column 0 -sticky e
    grid .epcw.c_le         -row 1 -column 1 -sticky nesw
    grid .epcw.te           -row 2 -column 0 -sticky e
    grid .epcw.c_te         -row 2 -column 1 -sticky nesw
    grid .epcw.vault        -row 3 -column 0 -sticky e
    grid .epcw.c_vault      -row 3 -column 1 -sticky nesw
    grid .epcw.cells        -row 4 -column 0 -sticky e
    grid .epcw.help         -row 5 -column 0 -sticky nesw
    grid .epcw.btn          -row 5 -column 1 -sticky e

    grid columnconfigure .epcw 0    -weight 0
    grid columnconfigure .epcw 1    -weight 1
    grid rowconfigure .epcw 0       -weight 0
    grid rowconfigure .epcw 1       -weight 1
    grid rowconfigure .epcw 2       -weight 1
    grid rowconfigure .epcw 3       -weight 1
    grid rowconfigure .epcw 4       -weight 0
    grid rowconfigure .epcw 5       -weight 0

    #-------------
    # Wing name
    ttk::label .epcw.name.wname -text [::msgcat::mc "Wing name"] -width 12
    ttk::entry .epcw.name.e_wname -width 16 -textvariable lcl_wingNamePreProc

    SetHelpBind .epcw.name.e_wname wingNamePreProc

    grid .epcw.name.wname -row 0 -column 0 -sticky e
    grid .epcw.name.e_wname -row 0 -column 1 -sticky w

    #-------------
    # Leading edge
    ttk::label .epcw.le.a1LE -text [::msgcat::mc "a1 \[cm\]"] -width 20
    ttk::label .epcw.le.b1LE -text [::msgcat::mc "b1 \[cm\]"] -width 20
    ttk::label .epcw.le.x1LE -text [::msgcat::mc "x1 \[cm\]"] -width 20
    ttk::label .epcw.le.xmLE -text [::msgcat::mc "xm \[cm\]"] -width 20
    ttk::label .epcw.le.c0LE -text [::msgcat::mc "c0 \[cm\]"] -width 20

    ttk::entry .epcw.le.e_a1LE -width 8 -textvariable lcl_a1LE
    ttk::entry .epcw.le.e_b1LE -width 8 -textvariable lcl_b1LE
    ttk::entry .epcw.le.e_x1LE -width 8 -textvariable lcl_x1LE
    ttk::entry .epcw.le.e_xmLE -width 8 -textvariable lcl_xmLE
    ttk::entry .epcw.le.e_c0LE -width 8 -textvariable lcl_c0LE

    SetHelpBind .epcw.le.e_a1LE a1LE
    SetHelpBind .epcw.le.e_b1LE b1LE
    SetHelpBind .epcw.le.e_x1LE x1LE
    SetHelpBind .epcw.le.e_xmLE xmLE
    SetHelpBind .epcw.le.e_c0LE c0LE


    grid .epcw.le.a1LE -row 0 -column 0 -sticky e
    grid .epcw.le.e_a1LE -row 0 -column 1 -sticky w
    grid .epcw.le.b1LE -row 1 -column 0 -sticky e
    grid .epcw.le.e_b1LE -row 1 -column 1 -sticky w
    grid .epcw.le.x1LE -row 2 -column 0 -sticky e
    grid .epcw.le.e_x1LE -row 2 -column 1 -sticky w
    grid .epcw.le.xmLE -row 3 -column 0 -sticky e
    grid .epcw.le.e_xmLE -row 3 -column 1 -sticky w
    grid .epcw.le.c0LE -row 4 -column 0 -sticky e
    grid .epcw.le.e_c0LE -row 4 -column 1 -sticky w

    #-------------
    # Leading edge
    ttk::label .epcw.te.a1TE -text [::msgcat::mc "a1 \[cm\]"] -width 20
    ttk::label .epcw.te.b1TE -text [::msgcat::mc "b1 \[cm\]"] -width 20
    ttk::label .epcw.te.x1TE -text [::msgcat::mc "x1 \[cm\]"] -width 20
    ttk::label .epcw.te.xmTE -text [::msgcat::mc "xm \[cm\]"] -width 20
    ttk::label .epcw.te.c0TE -text [::msgcat::mc "c0 \[cm\]"] -width 20
    ttk::label .epcw.te.y0TE -text [::msgcat::mc "c0 \[cm\]"] -width 20

    ttk::entry .epcw.te.e_a1TE -width 8 -textvariable lcl_a1TE
    ttk::entry .epcw.te.e_b1TE -width 8 -textvariable lcl_b1TE
    ttk::entry .epcw.te.e_x1TE -width 8 -textvariable lcl_x1TE
    ttk::entry .epcw.te.e_xmTE -width 8 -textvariable lcl_xmTE
    ttk::entry .epcw.te.e_c0TE -width 8 -textvariable lcl_c0TE
    ttk::entry .epcw.te.e_y0TE -width 8 -textvariable lcl_y0TE

    SetHelpBind .epcw.te.e_a1TE a1TE
    SetHelpBind .epcw.te.e_b1TE b1TE
    SetHelpBind .epcw.te.e_x1TE x1TE
    SetHelpBind .epcw.te.e_xmTE xmTE
    SetHelpBind .epcw.te.e_c0TE c0TE
    SetHelpBind .epcw.te.e_y0TE y0TE

    grid .epcw.te.a1TE -row 0 -column 0 -sticky e
    grid .epcw.te.e_a1TE -row 0 -column 1 -sticky w
    grid .epcw.te.b1TE -row 1 -column 0 -sticky e
    grid .epcw.te.e_b1TE -row 1 -column 1 -sticky w
    grid .epcw.te.x1TE -row 2 -column 0 -sticky e
    grid .epcw.te.e_x1TE -row 2 -column 1 -sticky w
    grid .epcw.te.xmTE -row 3 -column 0 -sticky e
    grid .epcw.te.e_xmTE -row 3 -column 1 -sticky w
    grid .epcw.te.c0TE -row 4 -column 0 -sticky e
    grid .epcw.te.e_c0TE -row 4 -column 1 -sticky w
    grid .epcw.te.y0TE -row 4 -column 0 -sticky e
    grid .epcw.te.e_y0TE -row 4 -column 1 -sticky w

    #-------------
    # Vault
    ttk::radiobutton .epcw.vault.ra -variable vaultType -value 1 -text [::msgcat::mc "Sin-Cos modif"]
    ttk::radiobutton .epcw.vault.rb -variable vaultType -value 2 -text [::msgcat::mc "Radius/ Angle"]

    bind .epcw.vault.ra <ButtonPress> { SetVaultType 1 }
    bind .epcw.vault.rb <ButtonPress> { SetVaultType 2 }

    ttk::label .epcw.vault.a1Vault -text [::msgcat::mc "a1 \[cm\]"] -state $VaultMode1
    ttk::label .epcw.vault.b1Vault -text [::msgcat::mc "b1 \[cm\]"] -state $VaultMode1
    ttk::label .epcw.vault.x1Vault -text [::msgcat::mc "x1 \[cm\]"] -state $VaultMode1
    ttk::label .epcw.vault.xmVault -text [::msgcat::mc "c1 \[cm\]"] -state $VaultMode1

    ttk::entry .epcw.vault.e_a1Vault -width 8 -state $VaultMode1 -textvariable lcl_a1Vault
    ttk::entry .epcw.vault.e_b1Vault -width 8 -state $VaultMode1 -textvariable lcl_b1Vault
    ttk::entry .epcw.vault.e_x1Vault -width 8 -state $VaultMode1 -textvariable lcl_x1Vault
    ttk::entry .epcw.vault.e_xmVault -width 8 -state $VaultMode1 -textvariable lcl_xmVault

    SetHelpBind .epcw.vault.e_a1Vault a1Vault
    SetHelpBind .epcw.vault.e_b1Vault b1Vault
    SetHelpBind .epcw.vault.e_x1Vault x1Vault
    SetHelpBind .epcw.vault.e_xmVault xmVault

    foreach i {1 2 3 4} {
        # radius
        ttk::label .epcw.vault.rVault$i -text [::msgcat::mc "R$i \[cm\]"]  -state $VaultMode2
        ttk::entry .epcw.vault.e_rVault$i -width 8 -state $VaultMode2 -textvariable lcl_radVault($i)

        SetHelpBind .epcw.vault.e_rVault$i radVault

        # ang
        ttk::label .epcw.vault.angVault$i -text [::msgcat::mc "Angle$i \[deg\]"]   -state $VaultMode2
        ttk::entry .epcw.vault.e_angVault$i -width 8   -state $VaultMode2  -textvariable lcl_angVault($i)

        SetHelpBind .epcw.vault.e_angVault$i angVault


    }

    grid .epcw.vault.ra -row 0 -column 0 -columnspan 3 -sticky w
    grid .epcw.vault.rb -row 1 -column 0 -columnspan 3 -sticky w

    grid .epcw.vault.a1Vault    -row 2 -column 0 -sticky e
    grid .epcw.vault.e_a1Vault  -row 2 -column 1 -sticky e
    grid .epcw.vault.b1Vault    -row 3 -column 0 -sticky e
    grid .epcw.vault.e_b1Vault  -row 3 -column 1 -sticky e
    grid .epcw.vault.x1Vault    -row 4 -column 0 -sticky e
    grid .epcw.vault.e_x1Vault  -row 4 -column 1 -sticky e
    grid .epcw.vault.xmVault    -row 5 -column 0 -sticky e
    grid .epcw.vault.e_xmVault  -row 5 -column 1 -sticky e

    foreach i {1 2 3 4} {
        # radius
        grid .epcw.vault.rVault$i -row [expr $i +1] -column 2 -sticky e
        grid .epcw.vault.e_rVault$i -row [expr $i +1] -column 3 -sticky w

        # angle
        grid .epcw.vault.angVault$i -row [expr $i +1] -column 4 -sticky e
        grid .epcw.vault.e_angVault$i -row [expr $i +1] -column 5 -sticky e
    }


    #-------------
    # Cell distribution
    ttk::radiobutton .epcw.cells.ra -variable cellDistrType -value 3 -text [::msgcat::mc "Cell width proportional to chord"]
    ttk::radiobutton .epcw.cells.rb -variable cellDistrType -value 4 -text [::msgcat::mc "Explicit width of each cell"]

    bind .epcw.cells.ra <ButtonPress> { SetCellType 3 }
    bind .epcw.cells.rb <ButtonPress> { SetCellType 4 }

    ttk::label .epcw.cells.cellDistrCoeff -text [::msgcat::mc "Cell distribution coef"] -width 20
    ttk::label .epcw.cells.numCellsPreProc -text [::msgcat::mc "Number of cells"] -width 20

    ttk::entry .epcw.cells.e_cellDistrCoeff -width 8 -textvariable lcl_cellDistrCoeff
    ttk::entry .epcw.cells.e_numCellsPreProc -width 8 -textvariable lcl_numCellsPreProc

    SetHelpBind .epcw.cells.e_cellDistrCoeff cellDistrCoeff
    SetHelpBind .epcw.cells.e_numCellsPreProc numCellsPreProc

    grid .epcw.cells.ra -row 0 -column 0 -columnspan 2 -sticky w
    grid .epcw.cells.rb -row 1 -column 0 -columnspan 2 -sticky w

    grid .epcw.cells.cellDistrCoeff -row 2 -column 0 -sticky e
    grid .epcw.cells.e_cellDistrCoeff -row 2 -column 1 -sticky w
    grid .epcw.cells.numCellsPreProc -row 3 -column 0 -sticky e
    grid .epcw.cells.e_numCellsPreProc -row 3 -column 1 -sticky w

    #-------------
    # explanations
    label .epcw.help.e_help -width 40 -height 3 -background LightYellow -textvariable HelpText
    grid .epcw.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .epcw.btn.apply -width 10 -text "Apply" -command ApplyButtonPress
    button .epcw.btn.ok -width 10 -text "OK" -command OkButtonPress
    button .epcw.btn.cancel -width 10 -text "Cancel" -command CancelButtonPress
    button .epcw.btn.help -width 10  -text "Help" -command HelpButtonPress -state disabled

    grid .epcw.btn.apply -row 0 -column 0 -sticky e -padx 10 -pady 0
    grid .epcw.btn.ok -row 0 -column 1 -sticky e -padx 10 -pady 0
    grid .epcw.btn.cancel -row 0 -column 2 -sticky e -padx 10 -pady 0
    grid .epcw.btn.help -row 1 -column 2 -sticky e -padx 10 -pady 20

    SetVaultType $vaultType
    SetCellType $cellDistrType
}

proc SetVaultType { Mode } {

    global VaultMode1
    global VaultMode2

    if { $Mode == 1 } {
        # vault using ellipse and cosinus modification
        set VaultMode1 "enabled"
        set VaultMode2 "disabled"

    } else {
        set VaultMode1 "disabled"
        set VaultMode2 "enabled"
    }

    .epcw.vault.a1Vault configure -state $VaultMode1
    .epcw.vault.e_a1Vault configure -state $VaultMode1
    .epcw.vault.b1Vault configure -state $VaultMode1
    .epcw.vault.e_b1Vault configure -state $VaultMode1
    .epcw.vault.x1Vault configure -state $VaultMode1
    .epcw.vault.e_x1Vault configure -state $VaultMode1
    .epcw.vault.xmVault configure -state $VaultMode1
    .epcw.vault.e_xmVault configure -state $VaultMode1

    foreach i {1 2 3 4} {
        # radius
        .epcw.vault.rVault$i configure -state $VaultMode2
        .epcw.vault.e_rVault$i configure -state $VaultMode2

        # angle
        .epcw.vault.angVault$i configure -state $VaultMode2
        .epcw.vault.e_angVault$i configure -state $VaultMode2
    }
}

proc SetCellType { Mode } {
    global CellMode3

    if { $Mode == 3 } {
        # proportional cell width
        set CellMode3 "enabled"
    } else {
        set CellMode3 "disabled"
    }

    .epcw.cells.cellDistrCoeff configure -state $CellMode3
    .epcw.cells.e_cellDistrCoeff configure -state $CellMode3
}

proc SetLclVars {} {
    source "globalPreProcVars.tcl"

    # make sure lcl_ variables are known
    foreach {e} $AllPreProcVars {
        global lcl_$e
    }

    # genereate from every variable a copy with prefix lcl_
    foreach {e} $SinglePreProcVariables {
        set lcl_$e [set $e]
    }

    # do the same for both arrays
    foreach i { 1 2 3 4} {
        set lcl_radVault($i) $radVault($i)
        set lcl_angVault($i) $angVault($i)
    }

    set g_PreProcDataChanged 0
}

proc SetLclVarTrace {} {
    source "globalPreProcVars.tcl"

    # make sure lcl_ variables are known
    foreach {e} $AllPreProcVars {
        global lcl_$e
        trace variable lcl_$e w { SetLclChangeFlag }
    }
}

proc ExportLclVars {} {
    source "globalPreProcVars.tcl"

    foreach {e} $AllPreProcVars {
        global lcl_$e
    }

    # write back local variables into global ones
    foreach {e} $SinglePreProcVariables {
        set $e [set lcl_$e]
    }

    # do the same for both arrays
    foreach i { 1 2 3 4} {
        set radVault($i) $lcl_radVault($i)
        set angVault($i) $lcl_angVault($i)
    }
}

proc UnsetLclVarTrace {} {
    source "globalPreProcVars.tcl"

    # make sure lcl_ variables are known
    foreach {e} $AllPreProcVars {
        global lcl_$e
        trace remove variable lcl_$e write { SetLclChangeFlag }
    }
}

proc SetLclChangeFlag { a e op } {
    # maybe helpful for debug
    # puts "  a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global g_PreProcDataChanged
    set g_PreProcDataChanged 1
}

proc SetHelpBind { Element VarName } {
    bind $Element <Enter> [list SetHelpText 1 $VarName]
    bind $Element <Leave> [list SetHelpText 0 $VarName]
}

proc SetHelpText { Focus Var } {
    global HelpText

    if { $Focus == 1} {
        # display a help text
        set HelpText [::msgcat::mc $Var]
    } else {
        set HelpText ""
    }
}

proc ApplyButtonPress {} {
    global g_PreProcDataChanged

    ExportLclVars
    set g_PreProcDataChanged 0

    # todo draw the views
}

proc OkButtonPress {} {

    ExportLclVars
    UnsetLclVarTrace

    set g_PreProcDataChanged 0

    global .epcw
    destroy .epcw
}

proc CancelButtonPress {} {

    source "globalPreProcVars.tcl"
    global .epcw

    if { $g_PreProcDataChanged == 1} {
        # there is changed data

        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
            -type yesno -icon warning \
            -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "yes" } {

            UnsetLclVarTrace
            set g_PreProcDataChanged 0
        } else {
            focus .epcw
            return 0
        }
    }
    destroy .epcw
    return 0
}

proc HelpButtonPress {} {

}
