#---------------------------------------------------------------------
#
#  Window to edit the preprocessor data
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
global .ppde

global g_GlobPreProcDataChanged

global  Lcl_pPDE_DataChanged
set     Lcl_pPDE_DataChanged    0

global VaultMode1
set VaultMode1 ""

global VaultMode2
set VaultMode2 ""

global CellMode3
set CellMode3 ""

#----------------------------------------------------------------------
#  ToRad
#  Converts degrees to rad
#
#  IN:      Angle in degrees
#  OUT:     N/A
#  Returns: Angle in rad
#----------------------------------------------------------------------
proc ToRad { Degrees } {
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
proc editPreProcData {} {
    source "globalPreProcVars.tcl"
    source "windowExplanationsHelper.tcl"

    global .ppde
    global .ppde.c_le
    global .ppde.c_te
    global .ppde.vault

    global VaultMode1
    global VaultMode2
    global HelpText_pPDE

    global g_PreProcDataAvailable

    foreach {e} $AllPreProcVars {
        global Lcl_$e
    }

    SetLclVars_pPDE

    toplevel .ppde
    focus .ppde

    wm protocol .ppde WM_DELETE_WINDOW { CancelButtonPress_pPDE_pPDE }

    wm title .ppde [::msgcat::mc "Edit Geometry data"]

    ttk::labelframe .ppde.name -text [::msgcat::mc "Wing name"]

    ttk::labelframe .ppde.le -text [::msgcat::mc "Leading edge"]
    canvas .ppde.c_le -width 300 -height 150 -bg white

    ttk::labelframe .ppde.te -text [::msgcat::mc "Trailing edge"]
    canvas .ppde.c_te -width 300 -height 150 -bg white

    ttk::labelframe .ppde.vault -text [::msgcat::mc "Vault"]
    canvas .ppde.c_vault -width 300 -height 150 -bg white

    ttk::labelframe .ppde.cells -text [::msgcat::mc "Cell distribution"]

    ttk::labelframe .ppde.help -text [::msgcat::mc "Explanations"]

    ttk::frame .ppde.btn

    grid .ppde.name         -row 0 -column 0 -sticky e
    grid .ppde.le           -row 1 -column 0 -sticky e
    grid .ppde.c_le         -row 1 -column 1 -sticky nesw
    grid .ppde.te           -row 2 -column 0 -sticky e
    grid .ppde.c_te         -row 2 -column 1 -sticky nesw
    grid .ppde.vault        -row 3 -column 0 -sticky e
    grid .ppde.c_vault      -row 3 -column 1 -sticky nesw
    grid .ppde.cells        -row 4 -column 0 -sticky e
    grid .ppde.help         -row 5 -column 0 -sticky nesw
    grid .ppde.btn          -row 5 -column 1 -sticky e

    grid columnconfigure .ppde 0    -weight 0
    grid columnconfigure .ppde 1    -weight 1
    grid rowconfigure .ppde 0       -weight 0
    grid rowconfigure .ppde 1       -weight 1
    grid rowconfigure .ppde 2       -weight 1
    grid rowconfigure .ppde 3       -weight 1
    grid rowconfigure .ppde 4       -weight 0
    grid rowconfigure .ppde 5       -weight 0

    #-------------
    # Wing name
    ttk::label .ppde.name.wname -text [::msgcat::mc "Wing name"] -width 12
    ttk::entry .ppde.name.e_wname -width 16 -textvariable Lcl_wingNamePreProc

    SetHelpBind .ppde.name.e_wname wingNamePreProc HelpText_pPDE

    grid .ppde.name.wname -row 0 -column 0 -sticky e
    grid .ppde.name.e_wname -row 0 -column 1 -sticky w

    #-------------
    # Leading edge
    ttk::label .ppde.le.a1LE -text [::msgcat::mc "a1 \[cm\]"] -width 20
    ttk::label .ppde.le.b1LE -text [::msgcat::mc "b1 \[cm\]"] -width 20
    ttk::label .ppde.le.x1LE -text [::msgcat::mc "x1 \[cm\]"] -width 20
    ttk::label .ppde.le.xmLE -text [::msgcat::mc "xm \[cm\]"] -width 20
    ttk::label .ppde.le.c0LE -text [::msgcat::mc "c0 \[cm\]"] -width 20

    ttk::entry .ppde.le.e_a1LE -width 8 -textvariable Lcl_a1LE
    ttk::entry .ppde.le.e_b1LE -width 8 -textvariable Lcl_b1LE
    ttk::entry .ppde.le.e_x1LE -width 8 -textvariable Lcl_x1LE
    ttk::entry .ppde.le.e_xmLE -width 8 -textvariable Lcl_xmLE
    ttk::entry .ppde.le.e_c0LE -width 8 -textvariable Lcl_c0LE

    SetHelpBind .ppde.le.e_a1LE a1LE HelpText_pPDE
    SetHelpBind .ppde.le.e_b1LE b1LE HelpText_pPDE
    SetHelpBind .ppde.le.e_x1LE x1LE HelpText_pPDE
    SetHelpBind .ppde.le.e_xmLE xmLE HelpText_pPDE
    SetHelpBind .ppde.le.e_c0LE c0LE HelpText_pPDE


    grid .ppde.le.a1LE -row 0 -column 0 -sticky e
    grid .ppde.le.e_a1LE -row 0 -column 1 -sticky w
    grid .ppde.le.b1LE -row 1 -column 0 -sticky e
    grid .ppde.le.e_b1LE -row 1 -column 1 -sticky w
    grid .ppde.le.x1LE -row 2 -column 0 -sticky e
    grid .ppde.le.e_x1LE -row 2 -column 1 -sticky w
    grid .ppde.le.xmLE -row 3 -column 0 -sticky e
    grid .ppde.le.e_xmLE -row 3 -column 1 -sticky w
    grid .ppde.le.c0LE -row 4 -column 0 -sticky e
    grid .ppde.le.e_c0LE -row 4 -column 1 -sticky w

    #-------------
    # Trailing edge
    ttk::label .ppde.te.a1TE -text [::msgcat::mc "a1 \[cm\]"] -width 20
    ttk::label .ppde.te.b1TE -text [::msgcat::mc "b1 \[cm\]"] -width 20
    ttk::label .ppde.te.x1TE -text [::msgcat::mc "x1 \[cm\]"] -width 20
    ttk::label .ppde.te.xmTE -text [::msgcat::mc "xm \[cm\]"] -width 20
    ttk::label .ppde.te.c0TE -text [::msgcat::mc "c0 \[cm\]"] -width 20
    ttk::label .ppde.te.y0TE -text [::msgcat::mc "y0 \[cm\]"] -width 20

    ttk::entry .ppde.te.e_a1TE -width 8 -textvariable Lcl_a1TE
    ttk::entry .ppde.te.e_b1TE -width 8 -textvariable Lcl_b1TE
    ttk::entry .ppde.te.e_x1TE -width 8 -textvariable Lcl_x1TE
    ttk::entry .ppde.te.e_xmTE -width 8 -textvariable Lcl_xmTE
    ttk::entry .ppde.te.e_c0TE -width 8 -textvariable Lcl_c0TE
    ttk::entry .ppde.te.e_y0TE -width 8 -textvariable Lcl_y0TE

    SetHelpBind .ppde.te.e_a1TE a1TE HelpText_pPDE
    SetHelpBind .ppde.te.e_b1TE b1TE HelpText_pPDE
    SetHelpBind .ppde.te.e_x1TE x1TE HelpText_pPDE
    SetHelpBind .ppde.te.e_xmTE xmTE HelpText_pPDE
    SetHelpBind .ppde.te.e_c0TE c0TE HelpText_pPDE
    SetHelpBind .ppde.te.e_y0TE y0TE HelpText_pPDE

    grid .ppde.te.a1TE -row 0 -column 0 -sticky e
    grid .ppde.te.e_a1TE -row 0 -column 1 -sticky w
    grid .ppde.te.b1TE -row 1 -column 0 -sticky e
    grid .ppde.te.e_b1TE -row 1 -column 1 -sticky w
    grid .ppde.te.x1TE -row 2 -column 0 -sticky e
    grid .ppde.te.e_x1TE -row 2 -column 1 -sticky w
    grid .ppde.te.xmTE -row 3 -column 0 -sticky e
    grid .ppde.te.e_xmTE -row 3 -column 1 -sticky w
    grid .ppde.te.c0TE -row 4 -column 0 -sticky e
    grid .ppde.te.e_c0TE -row 4 -column 1 -sticky w
    grid .ppde.te.y0TE -row 5 -column 0 -sticky e
    grid .ppde.te.e_y0TE -row 5 -column 1 -sticky w

    #-------------
    # Vault
    ttk::radiobutton .ppde.vault.ra -variable vaultType -value 1 -text [::msgcat::mc "Sin-Cos modif"]
    ttk::radiobutton .ppde.vault.rb -variable vaultType -value 2 -text [::msgcat::mc "Radius/ Angle"]

    bind .ppde.vault.ra <ButtonPress> { SetVaultType 1 }
    bind .ppde.vault.rb <ButtonPress> { SetVaultType 2 }

    ttk::label .ppde.vault.a1Vault -text [::msgcat::mc "a1 \[cm\]"] -state $VaultMode1
    ttk::label .ppde.vault.b1Vault -text [::msgcat::mc "b1 \[cm\]"] -state $VaultMode1
    ttk::label .ppde.vault.x1Vault -text [::msgcat::mc "x1 \[cm\]"] -state $VaultMode1
    ttk::label .ppde.vault.xmVault -text [::msgcat::mc "c1 \[cm\]"] -state $VaultMode1

    ttk::entry .ppde.vault.e_a1Vault -width 8 -state $VaultMode1 -textvariable Lcl_a1Vault
    ttk::entry .ppde.vault.e_b1Vault -width 8 -state $VaultMode1 -textvariable Lcl_b1Vault
    ttk::entry .ppde.vault.e_x1Vault -width 8 -state $VaultMode1 -textvariable Lcl_x1Vault
    ttk::entry .ppde.vault.e_xmVault -width 8 -state $VaultMode1 -textvariable Lcl_c1Vault

    SetHelpBind .ppde.vault.e_a1Vault a1Vault HelpText_pPDE
    SetHelpBind .ppde.vault.e_b1Vault b1Vault HelpText_pPDE
    SetHelpBind .ppde.vault.e_x1Vault x1Vault HelpText_pPDE
    SetHelpBind .ppde.vault.e_xmVault xmVault HelpText_pPDE

    foreach i {1 2 3 4} {
        # radius
        ttk::label .ppde.vault.rVault$i -text [::msgcat::mc "R$i \[cm\]"]  -state $VaultMode2
        ttk::entry .ppde.vault.e_rVault$i -width 8 -state $VaultMode2 -textvariable Lcl_radVault($i)

        SetHelpBind .ppde.vault.e_rVault$i radVault HelpText_pPDE

        # ang
        ttk::label .ppde.vault.angVault$i -text [::msgcat::mc "Angle$i \[deg\]"]   -state $VaultMode2
        ttk::entry .ppde.vault.e_angVault$i -width 8   -state $VaultMode2  -textvariable Lcl_angVault($i)

        SetHelpBind .ppde.vault.e_angVault$i angVault HelpText_pPDE
    }

    grid .ppde.vault.ra -row 0 -column 0 -columnspan 3 -sticky w
    grid .ppde.vault.rb -row 1 -column 0 -columnspan 3 -sticky w

    grid .ppde.vault.a1Vault    -row 2 -column 0 -sticky e
    grid .ppde.vault.e_a1Vault  -row 2 -column 1 -sticky e
    grid .ppde.vault.b1Vault    -row 3 -column 0 -sticky e
    grid .ppde.vault.e_b1Vault  -row 3 -column 1 -sticky e
    grid .ppde.vault.x1Vault    -row 4 -column 0 -sticky e
    grid .ppde.vault.e_x1Vault  -row 4 -column 1 -sticky e
    grid .ppde.vault.xmVault    -row 5 -column 0 -sticky e
    grid .ppde.vault.e_xmVault  -row 5 -column 1 -sticky e

    foreach i {1 2 3 4} {
        # radius
        grid .ppde.vault.rVault$i -row [expr $i +1] -column 2 -sticky e
        grid .ppde.vault.e_rVault$i -row [expr $i +1] -column 3 -sticky w

        # angle
        grid .ppde.vault.angVault$i -row [expr $i +1] -column 4 -sticky e
        grid .ppde.vault.e_angVault$i -row [expr $i +1] -column 5 -sticky e
    }


    #-------------
    # Cell distribution
    ttk::radiobutton .ppde.cells.ra -variable cellDistrType -value 3 -text [::msgcat::mc "Cell width proportional to chord"]
    ttk::radiobutton .ppde.cells.rb -variable cellDistrType -value 4 -text [::msgcat::mc "Explicit width of each cell"]

    bind .ppde.cells.ra <ButtonPress> { SetCellType 3 }
    bind .ppde.cells.rb <ButtonPress> { SetCellType 4 }

    ttk::label .ppde.cells.cellDistrCoeff -text [::msgcat::mc "Cell distribution coef"] -width 20
    ttk::label .ppde.cells.numCellsPreProc -text [::msgcat::mc "Number of cells"] -width 20

    ttk::entry .ppde.cells.e_cellDistrCoeff -width 8 -textvariable Lcl_cellDistrCoeff
    ttk::entry .ppde.cells.e_numCellsPreProc -width 8 -textvariable Lcl_numCellsPreProc

    SetHelpBind .ppde.cells.e_cellDistrCoeff cellDistrCoeff HelpText_pPDE
    SetHelpBind .ppde.cells.e_numCellsPreProc numCellsPreProc HelpText_pPDE

    grid .ppde.cells.ra -row 0 -column 0 -columnspan 2 -sticky w
    grid .ppde.cells.rb -row 1 -column 0 -columnspan 2 -sticky w

    grid .ppde.cells.cellDistrCoeff -row 2 -column 0 -sticky e
    grid .ppde.cells.e_cellDistrCoeff -row 2 -column 1 -sticky w
    grid .ppde.cells.numCellsPreProc -row 3 -column 0 -sticky e
    grid .ppde.cells.e_numCellsPreProc -row 3 -column 1 -sticky w

    #-------------
    # explanations
    label .ppde.help.e_help -width 40 -height 3 -background LightYellow -textvariable HelpText_pPDE
    grid .ppde.help.e_help -row 0 -column 0 -sticky nesw -padx 10 -pady 10

    #-------------
    # buttons
    button .ppde.btn.apply  -width 10 -text "Apply"     -command ApplyButtonPress_pPDE
    button .ppde.btn.ok     -width 10 -text "OK"        -command OkButtonPress_pPDE
    button .ppde.btn.cancel -width 10 -text "Cancel"    -command CancelButtonPress_pPDE_pPDE
    button .ppde.btn.help   -width 10 -text "Help"      -command HelpButtonPress_pPDE

    grid .ppde.btn.apply -row 0 -column 0 -sticky e -padx 10 -pady 0
    grid .ppde.btn.ok -row 0 -column 1 -sticky e -padx 10 -pady 0
    grid .ppde.btn.cancel -row 0 -column 2 -sticky e -padx 10 -pady 0
    grid .ppde.btn.help -row 1 -column 2 -sticky e -padx 10 -pady 20

    SetVaultType $vaultType
    SetCellType $cellDistrType

    SetLclVarTrace_pPDE
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
    global Lcl_vaultType

    if { $Mode == 1 } {
        # vault using ellipse and cosinus modification
        set VaultMode1 "enabled"
        set VaultMode2 "disabled"
        set Lcl_vaultType 1

    } else {
        set VaultMode1 "disabled"
        set VaultMode2 "enabled"
        set Lcl_vaultType 2
    }

    .ppde.vault.a1Vault configure -state $VaultMode1
    .ppde.vault.e_a1Vault configure -state $VaultMode1
    .ppde.vault.b1Vault configure -state $VaultMode1
    .ppde.vault.e_b1Vault configure -state $VaultMode1
    .ppde.vault.x1Vault configure -state $VaultMode1
    .ppde.vault.e_x1Vault configure -state $VaultMode1
    .ppde.vault.xmVault configure -state $VaultMode1
    .ppde.vault.e_xmVault configure -state $VaultMode1

    foreach i {1 2 3 4} {
        # radius
        .ppde.vault.rVault$i configure -state $VaultMode2
        .ppde.vault.e_rVault$i configure -state $VaultMode2

        # angle
        .ppde.vault.angVault$i configure -state $VaultMode2
        .ppde.vault.e_angVault$i configure -state $VaultMode2
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
    global Lcl_cellDistrType

    if { $Mode == 3 } {
        # proportional cell width
        set CellMode3 "enabled"
        set Lcl_cellDistrType 3
    } else {
        set CellMode3 "disabled"
        set Lcl_cellDistrType 4
    }

    .ppde.cells.cellDistrCoeff configure -state $CellMode3
    .ppde.cells.e_cellDistrCoeff configure -state $CellMode3
}

#----------------------------------------------------------------------
#  SetLclVars_pPDE
#  Reads the global application values into the Lcl ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVars_pPDE {} {
    source "globalPreProcVars.tcl"
    global g_LclPreProcDataChanged
    global g_LclPreProcDataNotApplied

    # make sure Lcl_ variables are known
    foreach {e} $AllPreProcVars {
        global Lcl_$e
    }

    # genereate from every variable a copy with prefix Lcl_
    foreach {e} $SinglePreProcVariables {
        set Lcl_$e [set $e]
    }

    # do the same for both arrays
    foreach i { 1 2 3 4} {
        set Lcl_radVault($i) $radVault($i)
        set Lcl_angVault($i) $angVault($i)
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
    SetLclVars_pPDE
    DrawLeadingEdge
    DrawTrailingEdge
    DrawVault
}

#----------------------------------------------------------------------
#  ExportLclVars_pPDE
#  Writes back values of Lcl values into the global application ones
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ExportLclVars_pPDE {} {
    source "globalPreProcVars.tcl"

    global g_GlobPreProcDataChanged

    foreach {e} $AllPreProcVars {
        global Lcl_$e
    }

    # write back local variables into global ones
    foreach {e} $SinglePreProcVariables {
        set $e [set Lcl_$e]
    }

    # do the same for both arrays
    foreach i { 1 2 3 4} {
        set radVault($i) $Lcl_radVault($i)
        set angVault($i) $Lcl_angVault($i)
    }

    set g_GlobPreProcDataChanged 1
}

#----------------------------------------------------------------------
#  SetLclVarTrace_pPDE
#  Starts tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclVarTrace_pPDE {} {
    source "globalPreProcVars.tcl"

    # make sure Lcl_ variables are known
    foreach {e} $AllPreProcVars {
        global Lcl_$e
        trace variable Lcl_$e w { SetLclChangeFlag_pPDE }
    }
}

#----------------------------------------------------------------------
#  UnsetLclVarTrace_pPDE
#  Stops tracing the changes of relevant local variables
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc UnsetLclVarTrace_pPDE {} {
    source "globalPreProcVars.tcl"

    # make sure Lcl_ variables are known
    foreach {e} $AllPreProcVars {
        global Lcl_$e
        trace remove variable Lcl_$e write { SetLclChangeFlag_pPDE }
    }
}

#----------------------------------------------------------------------
#  SetLclChangeFlag_pPDE
#  Setup local change flags upon edit
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SetLclChangeFlag_pPDE { a e op } {
    # maybe helpful for debug
    # puts "SetLclChangeFlag_pPDE: a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

    global Lcl_pPDE_DataChanged

    set Lcl_pPDE_DataChanged 1
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
    global .ppde.c_le
    # global .ppde.c_te
    # global .ppde.vault

    # Do scale factor calc for x axis
    # midX half the way on the x axis in the canvas
    set MidX [expr [winfo width .ppde.c_le] /2]

    set SpanVault [ GetSpanVault ]

    set Span [ ::tcl::mathfunc::max $A1LE $A1TE $SpanVault ]

    # scale factor
    set XSF [expr $MidX/ [::tcl::mathfunc::double $Span] ]

    # Do scale factor calc for y axis
    # midy half the way on the y axis in the canvas
    set MidY [expr [winfo height .ppde.c_le] /2]

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
    global .ppde.c_le

    foreach e {a1LE a1TE b1LE b1TE x1LE xmLE c0LE a1TE } {
        global Lcl_$e
    }

    .ppde.c_le delete "all"

    # midX half the way on the x coordinate in the canvas
    set MidX [expr [winfo width .ppde.c_le] /2]
    set MidY [expr [winfo height .ppde.c_le] /2]

    set SF [CalcPreProcScaleFactor $Lcl_a1LE $Lcl_a1TE $Lcl_b1LE $Lcl_b1TE ]

    # draw axes
    .ppde.c_le create line $MidX    $MidY 1                     $MidY               -fill red
    .ppde.c_le create line $MidX    $MidY [expr (2*$MidX)-1]    $MidY               -fill green
    .ppde.c_le create line $MidX    1     $MidX                 [expr (2*$MidY)-1]  -fill black

    # draw the LE
    set i 1
    while {$i <= $Lcl_xmLE} {
        #           x       y
        set YVal [CalcY-LE $Lcl_a1LE $Lcl_b1LE  $i $Lcl_x1LE $Lcl_xmLE $Lcl_c0LE]

        .ppde.c_le create line [expr $MidX + $SF*$i] [expr $MidY - $SF*$YVal] [expr $MidX + $SF*$i] [expr $MidY-1 - $SF*$YVal] -fill green
        .ppde.c_le create line [expr $MidX - $SF*$i] [expr $MidY - $SF*$YVal] [expr $MidX - $SF*$i] [expr $MidY-1 - $SF*$YVal] -fill red

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
    global .ppde.c_te

    foreach e { a1LE a1TE b1LE b1TE x1TE xmTE c0TE y0TE } {
        global Lcl_$e
    }

    .ppde.c_te delete "all"

    # midX half the way on the x coordinate in the canvas
    set MidX [expr [winfo width .ppde.c_te] /2]
    set MidY [expr [winfo height .ppde.c_te] /2]

    set SF [CalcPreProcScaleFactor $Lcl_a1LE $Lcl_a1TE $Lcl_b1LE $Lcl_b1TE ]

    # draw axes
    .ppde.c_te create line $MidX    $MidY 1                     $MidY               -fill red
    .ppde.c_te create line $MidX    $MidY [expr (2*$MidX)-1]    $MidY               -fill green
    .ppde.c_te create line $MidX    1     $MidX                 [expr (2*$MidY)-1]  -fill black

    # draw the te
    set i 1
    while {$i <= $Lcl_xmTE} {
        #           x       y
        set YVal [CalcY-TE $Lcl_a1TE $Lcl_b1TE  $i $Lcl_x1TE $Lcl_xmTE $Lcl_c0TE $y0TE]

        .ppde.c_te create line [expr $MidX + $SF*$i] [expr $MidY - $SF*$YVal] [expr $MidX + $SF*$i] [expr $MidY-1 - $SF*$YVal] -fill green
        .ppde.c_te create line [expr $MidX - $SF*$i] [expr $MidY - $SF*$YVal] [expr $MidX - $SF*$i] [expr $MidY-1 - $SF*$YVal] -fill red

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
    global Lcl_radVault
    global Lcl_angVault
    global ScaleF

    set TotAngle 0

    if { $Num == 1 } {
        set OrigX 0
    } else {
        set i 1
        while {$i < $Num } {
            set TotAngle [expr $TotAngle + $Lcl_angVault($i) ]
            incr i
        }
        set OrigX [ expr [CalcOxVault [expr $Num -1] ] + ($Lcl_radVault([expr $Num -1]) - $Lcl_radVault($Num) ) * sin([ToRad $TotAngle]) ]
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
    global Lcl_radVault
    global Lcl_angVault
    global ScaleF

    set TotAngle 0

    if { $Num == 1 } {
        set OrigZ $Lcl_radVault(1)
    } else {
        set i 1
        while {$i < $Num } {
            set TotAngle [expr $TotAngle + $Lcl_angVault($i) ]
            incr i
        }
        set OrigZ [ expr [CalcOzVault [expr $Num -1]] - ( $Lcl_radVault([expr $Num -1]) - $Lcl_radVault($Num) ) * cos([ToRad $TotAngle]) ]
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
    global Lcl_radVault
    global Lcl_angVault

    set TotAngle 0

    if { $Num == 1 } {
        set Pointx 0.
    } else {
        set i 1
        while {$i < $Num } {
            set TotAngle [ expr $TotAngle + $Lcl_angVault($i) ]
            incr i
        }
        set Pointx [ expr [CalcOxVault [expr $Num-1 ] ] + $Lcl_radVault([expr $Num -1]) * sin([ToRad $TotAngle]) ]
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
    global Lcl_radVault
    global Lcl_angVault

    set TotAngle 0

    if { $Num == 1 } {
        set Pointz 0.
    } else {
        set i 1
        while {$i < $Num } {
            set TotAngle [ expr $TotAngle + $Lcl_angVault($i) ]
            incr i
        }
        set Pointz [ expr [CalcOzVault [expr $Num-1 ] ] - $Lcl_radVault([expr $Num -1]) * cos([ToRad $TotAngle]) ]
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
    global Lcl_vaultType
    global Lcl_b1Vault

    global Lcl_radVault
    global Lcl_angVault

    if { $Lcl_vaultType == 1 } {
        if {$Lcl_b1Vault == "" } {
            set Lcl_b1Vault 0
        }
        return $Lcl_b1Vault
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
    global Lcl_vaultType
    global Lcl_a1Vault

    if { $Lcl_vaultType == 1 } {
        if {$Lcl_a1Vault == "" } {
            set Lcl_a1Vault 0
        }
        return $Lcl_a1Vault
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
    global .ppde.c_vault

    foreach e { a1LE a1TE b1LE b1TE x1TE xmTE c0TE y0TE a1Vault b1Vault x1Vault c1Vault radVault angVault vaultType} {
        global Lcl_$e
    }

    .ppde.c_vault delete "all"

    # midX half the way on the x coordinate in the canvas
    set MidX [expr [winfo width .ppde.c_vault] /2]
    set MidY [expr [winfo height .ppde.c_vault] /2]
    #
    set SF [CalcPreProcScaleFactor $Lcl_a1LE $Lcl_a1TE $Lcl_b1LE $Lcl_b1TE ]

    # draw axes
    .ppde.c_vault create line $MidX    $MidY 1                     $MidY               -fill red
    .ppde.c_vault create line $MidX    $MidY [expr (2*$MidX)-1]    $MidY               -fill green
    .ppde.c_vault create line $MidX    1     $MidX                 [expr (2*$MidY)-1]  -fill black

    if { $Lcl_vaultType == 1 } {
        # draw the sin/ cos vault
        set i 1
        while {$i <= $Lcl_b1Vault} {

            set XVal [CalcXVault $Lcl_a1Vault $Lcl_b1Vault $Lcl_x1Vault $Lcl_c1Vault $i ]
            #                          x                     y
            .ppde.c_vault create line [expr $MidX + $SF*$XVal] [expr $MidY - $SF*$i] \
                                      [expr $MidX + $SF*$XVal] [expr $MidY-1 - $SF*$i] -fill green

            .ppde.c_vault create line [expr $MidX - $SF*$XVal] [expr $MidY - $SF*$i] \
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
                set StartAngle [expr $StartAngle + $Lcl_angVault($j)]
                incr j
            }

            set X1R [expr $MidX + ( $SF*[CalcOxVault $i] - $SF*$Lcl_radVault($i) )]
            set X1L [expr $MidX - ( $SF*[CalcOxVault $i] - $SF*$Lcl_radVault($i) )]
            set Y1 [expr $CorrY +( $SF*[CalcOzVault $i] - $SF*$Lcl_radVault($i))]

            set X2R [expr $MidX + ( $SF*[CalcOxVault $i] + $SF*$Lcl_radVault($i) )]
            set X2L [expr $MidX - ( $SF*[CalcOxVault $i] + $SF*$Lcl_radVault($i) )]
            set Y2 [expr $CorrY + ($SF*[CalcOzVault $i] + $SF*$Lcl_radVault($i))]

            # draw
            .ppde.c_vault create arc  $X1R $Y1 $X2R $Y2 \
                                        -start [ CalcDrawAngVault $StartAngle ] -extent $Lcl_angVault($i) -width 1 -outline green -style arc
            .ppde.c_vault create arc  $X1L $Y1 $X2L $Y2 \
                                        -start [ CalcDrawAngVault [expr 360-$StartAngle+$Lcl_angVault($i)] ] -extent $Lcl_angVault($i) -width 1 -outline red -style arc
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
proc ApplyButtonPress_pPDE {} {
    global g_PreProcDataChanged
    global Lcl_pPDE_DataChanged

    if { $Lcl_pPDE_DataChanged == 1 } {
        ExportLclVars_pPDE

        set g_PreProcDataChanged 1
        set Lcl_pPDE_DataChanged 0
    }

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
proc OkButtonPress_pPDE {} {
    global .ppde
    global g_PreProcDataChanged
    global Lcl_pPDE_DataChanged

    if { $Lcl_pPDE_DataChanged == 1 } {
        ExportLclVars_pPDE

        set g_PreProcDataChanged 1
        set Lcl_pPDE_DataChanged 0
    }

    UnsetLclVarTrace_pPDE
    UnsetGlobalPreProcVarTrace
    destroy .ppde
}

#----------------------------------------------------------------------
#  CancelButtonPress_pPDE
#  All action after the Cancel button was pressed
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc CancelButtonPress_pPDE_pPDE {} {
    global .ppde
    global g_PreProcDataChanged
    global Lcl_pPDE_DataChanged

    if { $Lcl_pPDE_DataChanged == 1} {
        # there is changed data
        # do warning dialog
        set answer [tk_messageBox -title "Cancel" \
            -type yesno -icon warning \
            -message "All changed data will be lost.\nDo you really want to close the window"]
        if { $answer == "no" } {
            focus .ppde
            return 0
        }
    }
    global Lcl_pPDE_DataChanged 0
    UnsetLclVarTrace_pPDE
    UnsetGlobalPreProcVarTrace
    destroy .ppde
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
proc HelpButtonPress_pPDE {} {
    source "userHelp.tcl"

    displayHelpfile "geometry-window"
}
