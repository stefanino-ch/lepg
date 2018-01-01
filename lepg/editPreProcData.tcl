#-------
# Globals

global VaultMode1
set VaultMode1 ""

global VaultMode2
set VaultMode2 ""

global CellMode3
set CellMode3 ""

#----------------------------------------------------------------------
#  toRad
#  Converts degrees to rad
#
#  IN:      Angle in degrees
#  OUT:     N/A
#  Returns: Angle in rad
#----------------------------------------------------------------------
proc toRad { Degrees } {
    # acos(-1) returns Pi
    set Pi acos(-1)

    return [expr $Degrees / 180. * $Pi]
}

#----------------------------------------------------------------------
#  EditPreProcData
#  Does the initial window creation
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc EditPreProcData {} {
    source "globalPreProcVars.tcl"

    global .epcw
    global .epcw.c_le
    global .epcw.c_te
    global .epcw.vault

    global VaultMode1
    global VaultMode2
    global HelpText

    global g_PreProcDataAvailable

    foreach {e} $AllPreProcVars {
        global lcl_$e
    }

    SetLclVars


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
    # Trailing edge
    ttk::label .epcw.te.a1TE -text [::msgcat::mc "a1 \[cm\]"] -width 20
    ttk::label .epcw.te.b1TE -text [::msgcat::mc "b1 \[cm\]"] -width 20
    ttk::label .epcw.te.x1TE -text [::msgcat::mc "x1 \[cm\]"] -width 20
    ttk::label .epcw.te.xmTE -text [::msgcat::mc "xm \[cm\]"] -width 20
    ttk::label .epcw.te.c0TE -text [::msgcat::mc "c0 \[cm\]"] -width 20
    ttk::label .epcw.te.y0TE -text [::msgcat::mc "y0 \[cm\]"] -width 20

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
    grid .epcw.te.y0TE -row 5 -column 0 -sticky e
    grid .epcw.te.e_y0TE -row 5 -column 1 -sticky w

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
    ttk::entry .epcw.vault.e_xmVault -width 8 -state $VaultMode1 -textvariable lcl_c1Vault

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
    button .epcw.btn.help -width 10  -text "Help" -command HelpButtonPress

    grid .epcw.btn.apply -row 0 -column 0 -sticky e -padx 10 -pady 0
    grid .epcw.btn.ok -row 0 -column 1 -sticky e -padx 10 -pady 0
    grid .epcw.btn.cancel -row 0 -column 2 -sticky e -padx 10 -pady 0
    grid .epcw.btn.help -row 1 -column 2 -sticky e -padx 10 -pady 20

    SetVaultType $vaultType
    SetCellType $cellDistrType

    SetLclVarTrace
    SetGlobalPreProcVarTrace

    # TODO: add code to draw
}

#----------------------------------------------------------------------
#  SetVaultType
#  Setup of vault radio box and connected labels and input fields
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetVaultType { Mode } {

    global VaultMode1
    global VaultMode2
    global lcl_vaultType

    if { $Mode == 1 } {
        # vault using ellipse and cosinus modification
        set VaultMode1 "enabled"
        set VaultMode2 "disabled"
        set lcl_vaultType 1

    } else {
        set VaultMode1 "disabled"
        set VaultMode2 "enabled"
        set lcl_vaultType 2
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

#----------------------------------------------------------------------
#  SetCellType
#  Setup of cell type radio box and connected labels and input fields
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetCellType { Mode } {
    global CellMode3
    global lcl_cellDistrType

    if { $Mode == 3 } {
        # proportional cell width
        set CellMode3 "enabled"
        set lcl_cellDistrType 3
    } else {
        set CellMode3 "disabled"
        set lcl_cellDistrType 4
    }

    .epcw.cells.cellDistrCoeff configure -state $CellMode3
    .epcw.cells.e_cellDistrCoeff configure -state $CellMode3
}

#----------------------------------------------------------------------
#  SetLclVars
#  Reads the global application values into the lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars {} {
    source "globalPreProcVars.tcl"
    global g_LclPreProcDataChanged
    global g_LclPreProcDataNotApplied

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

    set g_LclPreProcDataChanged     0
    set g_LclPreProcDataNotApplied  0
}

#----------------------------------------------------------------------
#  SetLclVarsAndDraw
#  Called if window is already open and a new data file is opened
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarsAndDraw { a e op } {
    SetLclVars
    DrawLeadingEdge
    DrawTrailingEdge
    DrawVault
}

#----------------------------------------------------------------------
#  ExportLclVars
#  Writes back values of lcl values into the global application ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars {} {
    source "globalPreProcVars.tcl"

    global g_GlobPreProcDataChanged

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

    set g_GlobPreProcDataChanged 1
}

#----------------------------------------------------------------------
#  SetLclVarTrace
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace {} {
    source "globalPreProcVars.tcl"

    # make sure lcl_ variables are known
    foreach {e} $AllPreProcVars {
        global lcl_$e
        trace variable lcl_$e w { SetLclChangeFlag }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace {} {
    source "globalPreProcVars.tcl"

    # make sure lcl_ variables are known
    foreach {e} $AllPreProcVars {
        global lcl_$e
        trace remove variable lcl_$e write { SetLclChangeFlag }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global g_LclPreProcDataChanged
    global g_LclPreProcDataNotApplied

    set g_LclPreProcDataChanged     1
    set g_LclPreProcDataNotApplied  1
}

#----------------------------------------------------------------------
#  SetGlobalVarTrace
#  Starts tracing changes in relevant global variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetGlobalPreProcVarTrace {} {
    global g_PreProcDataAvailable

    trace variable g_PreProcDataAvailable w { SetLclVarsAndDraw }
}

#----------------------------------------------------------------------
#  UnsetGlobalPreProcVarTrace
#  Stops tracing the changes of relevant global variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetGlobalPreProcVarTrace {} {
    global g_PreProcDataAvailable

    trace remove variable g_PreProcDataAvailable write { SetLclVarsAndDraw }
}



#----------------------------------------------------------------------
#  proc SetHelpBind
#  Initial setup of the bind functions for the input fields
#
#  IN:      Element for which the bind must be setup
#           VarName name of the field
#  OUT:     N/A
#----------------------------------------------------------------------
proc SetHelpBind { Element VarName } {
    bind $Element <Enter> [list SetHelpText 1 $VarName]
    bind $Element <Leave> [list SetHelpText 0 $VarName]
}

#----------------------------------------------------------------------
#  SetHelpText
#  Controls the help text display in the Explanations window
#
#  IN:      Focus   The value indicating if the field has currently the focus or note
#           Var     Name of the Field
#  OUT:     N/A
#----------------------------------------------------------------------
proc SetHelpText { Focus Var } {
    global HelpText

    if { $Focus == 1} {
        # display a help text
        set HelpText [::msgcat::mc $Var]
    } else {
        set HelpText ""
    }
}

#----------------------------------------------------------------------
#  CalcPreProcScaleFactor
#  Calculates the scale factor for drawing on the GUI based on wing params
#  and drawing canvas
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: Scale Factor
#----------------------------------------------------------------------
proc CalcPreProcScaleFactor { A1LE A1TE B1LE B1TE } {

    source "globalPreProcVars.tcl"
    # drawing canvas has always the same size!
    global .epcw.c_le
    # global .epcw.c_te
    # global .epcw.vault

    # Do scale factor calc for x axis
    # midX half the way on the x axis in the canvas
    set MidX [expr [winfo width .epcw.c_le] /2]

    set SpanVault [ GetSpanVault ]

    set Span [ ::tcl::mathfunc::max $A1LE $A1TE $SpanVault ]

    # scale factor
    set XSF [expr $MidX/ [::tcl::mathfunc::double $Span] ]

    # Do scale factor calc for y axis
    # midy half the way on the y axis in the canvas
    set MidY [expr [winfo height .epcw.c_le] /2]

    set HeightVault [ GetHeightVault ]

    set Height [ ::tcl::mathfunc::max $B1LE $B1TE $HeightVault ]

    # scale factor
    set YSF [expr ($MidY )/($Height)]
    set SF [ ::tcl::mathfunc::min $XSF $YSF ]

    # use only 90% of canvas
    set SF [expr $SF * 0.9]

    return $SF
}

#----------------------------------------------------------------------
#  proc CalcY-LE
#  Calculates the LE Y value
#
#  IN:      A   a1 parameter of the LE
#           B   b1 parameter of the LE
#           X   x value for which y must be calculated
#           X1  x1 parameter of the LE
#           XM  Xm wing half span
#           C0  c0 parameter of the LE
#  OUT:     N/A
#  Returns: Y value
#----------------------------------------------------------------------
proc CalcY-LE { A B X X1 XM C0 } {

    # first do the calculation for X < X1
    set YVal [expr $B* sqrt( 1-($X**2.)/($A**2.) ) ]

    # check if the advanced calc is needed
    if { $X > $X1 } {

        set XKVal [expr $C0/(($XM-$X1)**2.)]

        set YVal [expr $YVal-$XKVal* ( ($X-$X1)**2. )]
    }

    return $YVal
}

#----------------------------------------------------------------------
#  DrawLeadingEdge
#  Draws the Leading Edge
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DrawLeadingEdge {} {
    source "globalPreProcVars.tcl"
    global .epcw.c_le

    foreach e {a1LE a1TE b1LE b1TE x1LE xmLE c0LE a1TE } {
        global lcl_$e
    }

    .epcw.c_le delete "all"

    # midX half the way on the x coordinate in the canvas
    set MidX [expr [winfo width .epcw.c_le] /2]
    set MidY [expr [winfo height .epcw.c_le] /2]

    set SF [CalcPreProcScaleFactor $lcl_a1LE $lcl_a1TE $lcl_b1LE $lcl_b1TE ]

    # draw axes
    .epcw.c_le create line $MidX    $MidY 1                     $MidY               -fill red
    .epcw.c_le create line $MidX    $MidY [expr (2*$MidX)-1]    $MidY               -fill green
    .epcw.c_le create line $MidX    1     $MidX                 [expr (2*$MidY)-1]  -fill black

    # draw the LE
    set i 1
    while {$i <= $lcl_xmLE} {
        #           x       y
        set YVal [CalcY-LE $lcl_a1LE $lcl_b1LE  $i $lcl_x1LE $lcl_xmLE $lcl_c0LE]

        .epcw.c_le create line [expr $MidX + $SF*$i] [expr $MidY - $SF*$YVal] [expr $MidX + $SF*$i] [expr $MidY-1 - $SF*$YVal] -fill green
        .epcw.c_le create line [expr $MidX - $SF*$i] [expr $MidY - $SF*$YVal] [expr $MidX - $SF*$i] [expr $MidY-1 - $SF*$YVal] -fill red

        incr i
    }
}

#----------------------------------------------------------------------
#  proc CalcY-TE
#  Calculates the TE Y value
#
#  IN:      A   a1 parameter of the TE
#           B   b1 parameter of the TE
#           X   x value for which y must be calculated
#           X1  x1 parameter of the TE
#           XM  Xm wing half span
#           C0  c0 parameter of the TE
#           Y0  y0 parameter of the TE
#  OUT:     N/A
#  Returns: Y value
#----------------------------------------------------------------------
proc CalcY-TE { A B X X1 XM C0 Y0 } {

    # first do the calculation for X < X1
    set YVal [expr $Y0 - $B* sqrt( 1-($X**2.)/($A**2.) ) ]

    # check if the advanced calc is needed
    if { $X > $X1 } {

        set XKVal [expr $C0/(($XM-$X1)**2.)]

        set YVal [expr $YVal+$XKVal* ( ($X-$X1)**2. ) ]
    }

    return $YVal
}

#----------------------------------------------------------------------
#  DrawTrailingEdge
#  Draws the Trailing Edge
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc DrawTrailingEdge {} {
    source "globalPreProcVars.tcl"
    global .epcw.c_te

    foreach e { a1LE a1TE b1LE b1TE x1TE xmTE c0TE y0TE } {
        global lcl_$e
    }

    .epcw.c_te delete "all"

    # midX half the way on the x coordinate in the canvas
    set MidX [expr [winfo width .epcw.c_te] /2]
    set MidY [expr [winfo height .epcw.c_te] /2]

    set SF [CalcPreProcScaleFactor $lcl_a1LE $lcl_a1TE $lcl_b1LE $lcl_b1TE ]

    # draw axes
    .epcw.c_te create line $MidX    $MidY 1                     $MidY               -fill red
    .epcw.c_te create line $MidX    $MidY [expr (2*$MidX)-1]    $MidY               -fill green
    .epcw.c_te create line $MidX    1     $MidX                 [expr (2*$MidY)-1]  -fill black

    # draw the te
    set i 1
    while {$i <= $lcl_xmTE} {
        #           x       y
        set YVal [CalcY-TE $lcl_a1TE $lcl_b1TE  $i $lcl_x1TE $lcl_xmTE $lcl_c0TE $y0TE]

        .epcw.c_te create line [expr $MidX + $SF*$i] [expr $MidY - $SF*$YVal] [expr $MidX + $SF*$i] [expr $MidY-1 - $SF*$YVal] -fill green
        .epcw.c_te create line [expr $MidX - $SF*$i] [expr $MidY - $SF*$YVal] [expr $MidX - $SF*$i] [expr $MidY-1 - $SF*$YVal] -fill red

        incr i
    }
}

#----------------------------------------------------------------------
# CalcOxVault
# Returns the Origin x value for the given segment number.
# Calls iteslf recursively.
#
# IN:       Num Number of the segment for which the value is asked 1..4
# OUT:      N/A
# Returns:  Origin X value
#----------------------------------------------------------------------
proc CalcOxVault { Num } {
    global lcl_radVault
    global lcl_angVault
    global ScaleF

    set TotAngle 0

    if { $Num == 1 } {
        set OrigX 0
    } else {
        set i 1
        while {$i < $Num } {
            set TotAngle [expr $TotAngle + $lcl_angVault($i) ]
            incr i
        }
        set OrigX [ expr [CalcOxVault [expr $Num -1] ] + ($lcl_radVault([expr $Num -1]) - $lcl_radVault($Num) ) * sin([toRad $TotAngle]) ]
    }
    return $OrigX
}


#----------------------------------------------------------------------
# CalcOzVault
# Returns the Origin Z value for the given segment number.
# Calls iteslf recursively.
#
# IN:       Num Number of the segment for which the value is asked 1..4
# OUT:      N/A
# Returns:  Origin Z value
#----------------------------------------------------------------------
proc CalcOzVault { Num } {
    global lcl_radVault
    global lcl_angVault
    global ScaleF

    set TotAngle 0

    if { $Num == 1 } {
        set OrigZ $lcl_radVault(1)
    } else {
        set i 1
        while {$i < $Num } {
            set TotAngle [expr $TotAngle + $lcl_angVault($i) ]
            incr i
        }
        set OrigZ [ expr [CalcOzVault [expr $Num -1]] - ( $lcl_radVault([expr $Num -1]) - $lcl_radVault($Num) ) * cos([toRad $TotAngle]) ]
    }
    return $OrigZ
}

#----------------------------------------------------------------------
# CalcPxVault
# Returns the x value for the given point number
#
# IN:       Num Number of the point for which the value is asked 1..5
# OUT:      N/A
# Returns:  Point x value
#----------------------------------------------------------------------
proc CalcPxVault { Num } {
    global lcl_radVault
    global lcl_angVault

    set TotAngle 0

    if { $Num == 1 } {
        set Pointx 0.
    } else {
        set i 1
        while {$i < $Num } {
            set TotAngle [ expr $TotAngle + $lcl_angVault($i) ]
            incr i
        }
        set Pointx [ expr [CalcOxVault [expr $Num-1 ] ] + $lcl_radVault([expr $Num -1]) * sin([toRad $TotAngle]) ]
    }
    return $Pointx
}

#----------------------------------------------------------------------
# CalcPzVault
# Returns the z value for the given point number
#
# IN:       Num Number of the point for which the value is asked 1..5
# OUT:      N/A
# Returns:  Point z value
#----------------------------------------------------------------------
proc CalcPzVault { Num } {
    global lcl_radVault
    global lcl_angVault

    set TotAngle 0

    if { $Num == 1 } {
        set Pointz 0.
    } else {
        set i 1
        while {$i < $Num } {
            set TotAngle [ expr $TotAngle + $lcl_angVault($i) ]
            incr i
        }
        set Pointz [ expr [CalcOzVault [expr $Num-1 ] ] - $lcl_radVault([expr $Num -1]) * cos([toRad $TotAngle]) ]
    }
    return $Pointz
}

#----------------------------------------------------------------------
# GetHeightVault
# Returns the A1 Value of the Vault for the vault mode currently active
#
# IN:
# OUT:     N/A
# Returns: A1 vault (Height)
#----------------------------------------------------------------------
proc GetHeightVault {} {
    global lcl_vaultType
    global lcl_b1Vault

    global lcl_radVault
    global lcl_angVault

    if { $lcl_vaultType == 1 } {
        if {$lcl_b1Vault == "" } {
            set lcl_b1Vault 0
        }
        return $lcl_b1Vault
    } else {
        # do in here the rad vault calc
        return [expr abs( [CalcPzVault 5] )]
    }
}

#----------------------------------------------------------------------
#  GetSpanVault
#  Returns the Span of the Vault for the vault mode currently active
#
#  IN:
#  OUT:     N/A
#  Returns: Span vault (Height)
#----------------------------------------------------------------------
proc GetSpanVault {} {
    global lcl_vaultType
    global lcl_a1Vault

    if { $lcl_vaultType == 1 } {
        if {$lcl_a1Vault == "" } {
            set lcl_a1Vault 0
        }
        return $lcl_a1Vault
    } else {
        # the x value of point 5 is retured which is not in all cases a 100% correct
        # the real span might be slightly higher!
        return [ CalcPxVault 5 ]
    }
}

#----------------------------------------------------------------------
# CalcXVault
# Calculates the Vault X value
#
# IN:      A   a1 parameter of the TE
#          B   b1 parameter of the TE
#          X1  x1 parameter of the TE
#          C1  c0 parameter of the TE
#          Y   y value for which x must be calculated
# OUT:     N/A
# Returns: X value
#----------------------------------------------------------------------
proc CalcXVault { A B X1 C1 Y } {
    # first do the calc for the y treshold
    set Y1 [expr $B* sqrt( 1 - ($X1**2.) / ($A**2.) ) ]

    set XVal [expr $A * ( sqrt( 1 - ($Y**2.) / ($B**2.) )) ]

    if { $Y <= $Y1 } {
        # acos(-1) returns Pi
        set HalfPi [expr acos(-1)/2 ]

        set Rho [expr (1 - cos( ($Y1 - $Y)/$Y1 * $HalfPi ) ) * $C1 ]

        set XVal [expr $XVal + $Rho ]
    }
    return $XVal
}

#----------------------------------------------------------------------
# CalcDrawAngVault
# Transforms the angles given by geometry into drawing angles
# 12 o'clock = input angle 0
#  3 o'clock  = input angle 90
#
# IN:      Geometry angle
# OUT:     N/A
# Returns: Drawing angle to be used for the arc cmd
#----------------------------------------------------------------------
proc CalcDrawAngVault { GeomAngle } {
    set DrawAngle [expr 90 - $GeomAngle ]
    if { $DrawAngle < 0 } {
        set DrawAngle [expr 360 - abs($DrawAngle) ]
    }
    return $DrawAngle
}

#----------------------------------------------------------------------
# DrawVault
# Draws the vault
#
# IN:      N/A
# OUT:     N/A
# Returns: N/A
#----------------------------------------------------------------------
proc DrawVault {} {
    source "globalPreProcVars.tcl"
    global .epcw.c_vault

    foreach e { a1LE a1TE b1LE b1TE x1TE xmTE c0TE y0TE a1Vault b1Vault x1Vault c1Vault radVault angVault vaultType} {
        global lcl_$e
    }

    .epcw.c_vault delete "all"

    # midX half the way on the x coordinate in the canvas
    set MidX [expr [winfo width .epcw.c_vault] /2]
    set MidY [expr [winfo height .epcw.c_vault] /2]
    #
    set SF [CalcPreProcScaleFactor $lcl_a1LE $lcl_a1TE $lcl_b1LE $lcl_b1TE ]

    # draw axes
    .epcw.c_vault create line $MidX    $MidY 1                     $MidY               -fill red
    .epcw.c_vault create line $MidX    $MidY [expr (2*$MidX)-1]    $MidY               -fill green
    .epcw.c_vault create line $MidX    1     $MidX                 [expr (2*$MidY)-1]  -fill black

    if { $lcl_vaultType == 1 } {
        # draw the sin/ cos vault
        set i 1
        while {$i <= $lcl_b1Vault} {

            set XVal [CalcXVault $lcl_a1Vault $lcl_b1Vault $lcl_x1Vault $lcl_c1Vault $i ]
            #                          x                     y
            .epcw.c_vault create line [expr $MidX + $SF*$XVal] [expr $MidY - $SF*$i] \
                                      [expr $MidX + $SF*$XVal] [expr $MidY-1 - $SF*$i] -fill green

            .epcw.c_vault create line [expr $MidX - $SF*$XVal] [expr $MidY - $SF*$i] \
                                      [expr $MidX - $SF*$XVal] [expr $MidY-1 - $SF*$i] -fill red

            incr i
        }
    } else {
        # draw the rad/ angle vault
        set CorrY [expr abs( (2*$MidY - $SF*[GetHeightVault] ) /2 ) ]
        set i 1
        while {$i <= 4} {

            # calculate the angles
            set j 1
            set StartAngle 0
            while {$j <= $i} {
                set StartAngle [expr $StartAngle + $lcl_angVault($j)]
                incr j
            }

            set X1R [expr $MidX + ( $SF*[CalcOxVault $i] - $SF*$lcl_radVault($i) )]
            set X1L [expr $MidX - ( $SF*[CalcOxVault $i] - $SF*$lcl_radVault($i) )]
            set Y1 [expr $CorrY +( $SF*[CalcOzVault $i] - $SF*$lcl_radVault($i))]

            set X2R [expr $MidX + ( $SF*[CalcOxVault $i] + $SF*$lcl_radVault($i) )]
            set X2L [expr $MidX - ( $SF*[CalcOxVault $i] + $SF*$lcl_radVault($i) )]
            set Y2 [expr $CorrY + ($SF*[CalcOzVault $i] + $SF*$lcl_radVault($i))]

            # draw
            .epcw.c_vault create arc  $X1R $Y1 $X2R $Y2 \
                                        -start [ CalcDrawAngVault $StartAngle ] -extent $lcl_angVault($i) -width 1 -outline green -style arc
            .epcw.c_vault create arc  $X1L $Y1 $X2L $Y2 \
                                        -start [ CalcDrawAngVault [expr 360-$StartAngle+$lcl_angVault($i)] ] -extent $lcl_angVault($i) -width 1 -outline red -style arc
            incr i

        }

    }
}

#----------------------------------------------------------------------
#  ApplyButtonPress
#  All action after the Apply button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ApplyButtonPress {} {
    global g_LclPreProcDataNotApplied

    ExportLclVars
    set g_LclPreProcDataNotApplied 0

    DrawLeadingEdge
    DrawTrailingEdge
    DrawVault
}

#----------------------------------------------------------------------
#  OkButtonPress
#  All action after the Ok button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OkButtonPress {} {
    global .epcw

    global g_LclPreProcDataChanged
    global g_LclPreProcDataNotApplied

    ExportLclVars
    UnsetLclVarTrace
    UnsetGlobalPreProcVarTrace

    set g_LclPreProcDataChanged     0
    set g_LclPreProcDataNotApplied  0

    destroy .epcw
}

#----------------------------------------------------------------------
#  CancelButtonPress
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress {} {

    source "globalPreProcVars.tcl"
    global .epcw
    global g_LclPreProcDataChanged
    global g_LclPreProcDataNotApplied

    if { $g_LclPreProcDataNotApplied == 1} {
        # there is changed data

        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
            -type yesno -icon warning \
            -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "yes" } {
            UnsetLclVarTrace
            UnsetGlobalPreProcVarTrace
            set g_LclPreProcDataChanged     0
            set g_LclPreProcDataNotApplied  0

        } else {
            focus .epcw
            return 0
        }
    }
    destroy .epcw
    return 0
}

#----------------------------------------------------------------------
#  HelpButtonPress
#  Opens the helpfile for the current window
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc HelpButtonPress {} {
    source "userHelp.tcl"

    displayHelpfile "geometry-window"
}
