#! /usr/bin/tclsh8.6

#---------------------------------------------------------------------
#
#  lepg main file
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

package require Tk
package require msgcat

# Derive current directory and append it to the package path
variable myLocation [file normalize [info script]]
lappend ::auto_path [file dirname $myLocation]

# Load local packages
package require lepConfigFile

#---------------------------------------------------------------------
#  Globals
#---------------------------------------------------------------------


# PreProcessor related values
set g_PreProcDataAvailable 0
                                    # set to 1 if data in main window is available

set g_PreProcDataChanged 0
                                    # set to 1 if PreProc data in main window
                                    # has been changed

set g_PreProcFileTypes {
    {{Geometry files pre-data.txt}   {.txt}}
}

set g_PreProcFilePathName ""
                                    # path and name of the file with the geometry data in

set g_PreImagePathName ""
                                    # path and name of the image


set g_WingDataAvailable 0
                                    # set to 1 if wing data is available for edit

set g_WingDataChanged 0
                                    # set to 1 if there is unsaved wing data

set g_WingFileTypes {
    {{Data files leparagliding.txt}  {.txt}}
}

set g_WingFilePathName ""
                                    # path and name of the wing file

set .topv.c_topv ""
set .tailv.c_tailv ""
set .sidev.c_sidev ""

set data_le(c0) 10.11

#---------------------------------------------------------------------
#
#  LEparagliding GUI
set LepVersioNumber "3.15"
set LepgNumber      "V0.99.7 test2"
set VersionDate     "2021-01-31"
#
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
#
#  1. myAppMain
#
#  Performs basic initialization of myApp.
#
#---------------------------------------------------------------------
proc myAppMain { argc argv } {

    # If you want to see the global vars changing uncomment the line below
    # SetGlobalVarTrace

    #-----------------------------------------------------------------
    #  Global program configuration
    #-----------------------------------------------------------------
    # First setup hardcoded defaults
    # Make sure all config file values are listed here.
    dict set ::GlobalConfig Language "en"
    dict set ::GlobalConfig PreProcDirectory ""
    dict set ::GlobalConfig LepDirectory ""
    dict set ::GlobalConfig PreProcPathName ""
    dict set ::GlobalConfig PreImagePathName ""


    # Hardcoded defaults will be overwritten by config file values
    set ::GlobalConfig [::lepConfigFile::loadFile $::GlobalConfig]

    # make sure preproc and wing vars exist
    source "globalPreProcVars.tcl"
    initGlobalPreProcVars

    source "globalWingVars.tcl"
    #initGlobalWingVars

    #-----------------------------------------------------------------
    #  Construct the UI
    #-----------------------------------------------------------------
    InitGui .

    #myAppWriteMain
    CreateMainWindow

    #------------------------------------------------------------
    #  If we have an argument, then open the file
    #-----------------------------------------------------------------
    if { [llength $argv] > 0 } {
        OpenWingFile [lindex $argv 0]
    }
}
#----------------------------------------------------------------------

#---------------------------------------------------------------------
#
#  2. InitGui
#
#  Construct and initialize UI
#
#---------------------------------------------------------------------
proc InitGui { root } {
    global base

    global LepVersioNumber
    global LepgNumber
    global g_PreProcDataAvailable
    global g_WingDataAvailable

    source "preProcDataEdit.tcl"
    source "preProcRun.tcl"
    source "lepProcRun.tcl"

    source "userHelp.tcl"

    #-----------------------------------------------------------------
    # setup translation framework
    #-----------------------------------------------------------------
    ::msgcat::mclocale [dict get $::GlobalConfig Language]
    ::msgcat::mcload [file join [file dirname [info script]]]

    trace variable g_PreProcDataAvailable w { SetPreProcBtnStatus }
    trace variable g_WingDataAvailable    w { SetWingBtnStatus }

    #-----------------------------------------------------------------
    #  treat root window "." as a special case
    #-----------------------------------------------------------------
    if {$root == "."} {
        set base ""
    } else {
        set base $root
    }

    #-----------------------------------------------------------------
    #  Define the menu bar
    #-----------------------------------------------------------------
    menu $base.menu
    menu $base.menu.file -tearoff 0
    menu $base.menu.geometry -tearoff 0
    menu $base.menu.wing -tearoff 0
    menu $base.menu.wingplan -tearoff 0
    menu $base.menu.draw -tearoff 0
    menu $base.menu.run -tearoff 0
    menu $base.menu.settings -tearoff 0
    menu $base.menu.settings.language -tearoff 0
    menu $base.menu.help -tearoff 0

    $root config -menu $base.menu

    # File menu
    $base.menu add cascade -label [::msgcat::mc "File"] -underline 0 -menu $base.menu.file
    $base.menu.file add command -underline 1 -label [::msgcat::mc "Exit"] -command myAppExit

    # Geometry menu
    $base.menu add cascade -label [::msgcat::mc "Geometry"] -underline 0 -menu $base.menu.geometry
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "New Geometry..."]    -command NewGeometry
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Open Geometry file..."]   -command OpenPreProcFile
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Save Geometry"]      -command SavePreProcFile    -state disabled
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Save Geometry As"]   -command SavePreProcFileAs  -state disabled
    $base.menu.geometry add separator
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Edit Geometry"]      -command editPreProcData    -state disabled
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Calc Geometry"]      -command preProcRun         -state disabled


    # Wing menu
    $base.menu add cascade -label [::msgcat::mc "Wing"] -underline 0 -menu $base.menu.wing
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "Import Matrix Geometry"]   -command ImportWingGeometry
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "Open data file..."]           -command OpenWingFile
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "Save data"]              -command SaveWingFile -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "Save data As"]           -command SaveWingFileAs -state disabled
    $base.menu.wing add separator
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "01A. Basic Data"]            -command OpenWingBasicDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "01B. Washin"]                -command OpenWingWashinDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "01C. Geometry edit"]         -command OpenWingGeoEditDataEdit -state disabled
    #$base.menu.wing add command -underline 0 -label [::msgcat::mc "01D. Cells number"]          -command OpenWingCellsNumberDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "02. Airfoils"]               -command OpenWingAirfoilsDataEdit  -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "03. Anchor Points"]          -command OpenWingAnchorsDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "04. Airfoil Holes"]          -command OpenWingAirfoilHolesDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "05. Skin Tension"]           -command OpenWingSkinTensionDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "08. Global AoA"]             -command OpenGlobalAoADataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "09. Suspension lines"]       -command OpenSuspensionLinesDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "10. Brake lines"]            -command OpenBrakeLinesDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "11. Ramification lengths"]   -command OpenRamificationLengthDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "12. HV-VH Ribs"]             -command OpenHV-VH-RibsDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "15. Extrados Colors"]        -command OpenWingTEColorDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "16. Intrados Colors"]        -command OpenWingLEColorDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "17. Additional rib points"]  -command OpenWingAddRibPointsDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "18. Elastic lines corr"]     -command OpenElasticLinesCorrEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "21. Joncs definition"]       -command OpenWingJoncsDefDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "22. Nose mylars"]            -command OpenWingNoseMyDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "23. Tab reinforcements"]     -command OpenWingTabReinfDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "26. Glue vents"]             -command OpenWingGlueVenDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "27. Special wingtip"]        -command OpenWingSpecWtDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "28. Calage variation"]       -command OpenWingCalagVarDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "29. 3D shaping"]             -command OpenShaping3DDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "30. Airfoil thickness"]      -command OpenWingAirThickDataEdit -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "31. New skin tension"]       -command OpenWingNewSkinDataEdit -state disabled
    $base.menu.wing add separator
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "Calc Wing"]              -command lepProcRun -state disabled

    # Wing plan menu
    $base.menu add cascade -label [::msgcat::mc "Wing plan"] -underline 0 -menu $base.menu.wingplan
    $base.menu.wingplan add command -underline 5 -label [::msgcat::mc "06. Sewing Allowances"]  -command OpenWingSewingAllowancesEdit -state disabled
    $base.menu.wingplan add command -underline 5 -label [::msgcat::mc "07. Marks"]              -command OpenWingMarksEdit -state disabled
    $base.menu.wingplan add command -underline 0 -label [::msgcat::mc "19. DXF layer names"]  -command OpenWingDXFLayNamesDataEdit -state disabled
    $base.menu.wingplan add command -underline 0 -label [::msgcat::mc "20. Marks types"]  -command OpenWingMarksTypesDataEdit -state disabled
    $base.menu.wingplan add command -underline 9 -label [::msgcat::mc "24. General 2D DXF options"]  -command OpenWingGe2DopDataEdit -state disabled
    $base.menu.wingplan add command -underline 9 -label [::msgcat::mc "25. General 3D DXF options"]  -command OpenWingGe3DopDataEdit -state disabled
    #$base.menu.wingplan add command -underline 5 -label [::msgcat::mc "DXF"]             -command xxx -state disabled

    # Draw menu
    $base.menu add cascade -label [::msgcat::mc "Draw"] -underline 0 -menu $base.menu.draw
    $base.menu.draw add command -underline 6 -label [::msgcat::mc "Redraw"] -command DrawTopViewAndVault

    # Run menu
    $base.menu add cascade -label [::msgcat::mc "Run"] -underline 0 -menu $base.menu.run
    $base.menu.run add command -underline 6 -label [::msgcat::mc "Check coherence"] -state disabled
    $base.menu.run add command -underline 4 -label [::msgcat::mc "Run LEparagliding"]  -command lepProcRun -state disabled

    # Settings menu
    $base.menu add cascade -label [::msgcat::mc "Settings"] -underline 0 -menu $base.menu.settings
    $base.menu.settings add cascade -label [::msgcat::mc "Language"] -underline 0 -menu $base.menu.settings.language
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Catalan"] -command {SetLanguage "ca"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Dutch"] -command {SetLanguage "nl"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "English"] -command {SetLanguage "en"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "German"]  -command {SetLanguage "de"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "French"]  -command {SetLanguage "fr"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Italian"]  -command {SetLanguage "it"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Polish"]  -command {SetLanguage "pl"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Portuguese"]  -command {SetLanguage "pt"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Spanish"]  -command {SetLanguage "es"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Russian"] -command {SetLanguage "ru"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Ukrainian"] -command {SetLanguage "ua"}
    $base.menu.settings add separator
    $base.menu.settings add command -underline 0 -label [::msgcat::mc "Geometry-Processor"] -command PreProcDirSelect_lepg
    $base.menu.settings add command -underline 0 -label [::msgcat::mc "Wing-Processor"] -command LepDirSelect
    $base.menu.settings add separator
    $base.menu.settings add command -underline 0 -label [::msgcat::mc "Main window image"] -command MainwImageSelect


    # Help menu
    $base.menu add cascade -label [::msgcat::mc "Help"] -underline 0 -menu $base.menu.help

    $base.menu.help add command -underline 0 -label [::msgcat::mc "User Manual"] -command {displayHelpfile "index"}
    $base.menu.help add command -underline 0 -label [::msgcat::mc "About"] -command HelpAbout

    # Test if focus returns a valid window before calling
    # append pCmd "myAppConfigEditMenu $Edit " {{if {[focus] != {}} {[bindtags [focus]]}}}
    # $Edit configure -postcommand $pCmd

    #-----------------------------------------------------------------
    #  Set window manager properties for myApp
    #-----------------------------------------------------------------
    wm protocol $root WM_DELETE_WINDOW { myAppExit }
    wm geometry . +100+100
    wm title $root "Laboratori d'envol Paragliding Design Program $LepVersioNumber GUI-$LepgNumber "
}

#    End InitGui


#----------------------------------------------------------------------
# Create only image window
#----------------------------------------------------------------------

proc CreateOnlyImage {} {

    source "globalWingVars.tcl"

    global .sidev.c_sidev

    # Side view
    ttk::labelframe .sidev -text [::msgcat::mc "Project image"]
#    canvas .sidev.c_sidev -width 500 -height 300 -bg white
#    pack .sidev.c_sidev -expand yes -fill both

#   Image selected from your path
    global Status_lPR
    set PreImagePathName [dict get $::GlobalConfig PreImagePathName]
#    set img [image create photo -file img/dissphc.gif]
    set img [image create photo -file $PreImagePathName] 
    label .sidev.c_sidev -image $img
    pack  .sidev.c_sidev -expand yes -fill both
#    puts "WWWW $PreImagePathName"

    grid .sidev -row 0 -column 1 -sticky nesw


}

#----------------------------------------------------------------------
# Create Main Window
#----------------------------------------------------------------------

proc CreateMainWindow {} {

    source "globalWingVars.tcl"

    global .topv.c_topv
    global .tailv.c_tailv
    global .sidev.c_sidev

    # create the four quadrants
    # Top view
    ttk::labelframe .topv -text [::msgcat::mc "Top view"]
    canvas .topv.c_topv -width 500 -height 300 -bg white
    pack .topv.c_topv -expand yes -fill both

    # Tail view
    ttk::labelframe .tailv -text [::msgcat::mc "Tail view"]
    canvas .tailv.c_tailv -width 500 -height 300 -bg white
    pack .tailv.c_tailv -expand yes -fill both

    # Side view
    ttk::labelframe .sidev -text [::msgcat::mc "Project image"]
#    canvas .sidev.c_sidev -width 500 -height 300 -bg white
#    pack .sidev.c_sidev -expand yes -fill both

#   Image selected from your path
    global Status_lPR
    set PreImagePathName [dict get $::GlobalConfig PreImagePathName]
#    set img [image create photo -file img/dissphc.gif]
    set img [image create photo -file $PreImagePathName] 
#    set img [image create photo -file $PreImagePathName -width 500] 
    label .sidev.c_sidev -image $img
    pack  .sidev.c_sidev -expand yes -fill both
#    puts "WWWW $PreImagePathName"

    # Basic data
    ttk::labelframe .bd -text [::msgcat::mc "Basic wing data"]

    grid .tailv -row 1 -column 0 -sticky nesw
    grid .sidev -row 0 -column 1 -sticky nesw
    grid .topv -row 0 -column 0 -sticky nesw
    grid .bd -row 1 -column 1 -sticky new

    grid columnconfigure . 0 -weight 1
    grid columnconfigure . 1 -weight 1
    grid rowconfigure . 0 -weight 1
    grid rowconfigure . 1 -weight 1

    # put labels in basicData
    ttk::label .bd.brandName -text [::msgcat::mc "Brand Name"]
    ttk::label .bd.brandNameV -textvariable brandName
    ttk::label .bd.wingName -text [::msgcat::mc "Wing Name"]
    ttk::label .bd.wingNameV -textvariable wingName
    ttk::label .bd.drawScale -text [::msgcat::mc "Draw Scale"]
    ttk::label .bd.drawScaleV -textvariable drawScale
    ttk::label .bd.wingScale -text [::msgcat::mc "Wing scale"]
    ttk::label .bd.wingScaleV -textvariable wingScale

    ttk::label .bd.wingSurface -text [::msgcat::mc "Wing surface (m2)"]
    ttk::label .bd.wingSurfaceV -textvariable wingSurface
    ttk::label .bd.wingSpan -text [::msgcat::mc "Wing span (m)"]
    ttk::label .bd.wingSpanV -textvariable wingSpan
    ttk::label .bd.wingAR -text [::msgcat::mc "Wing aspect ratio"]
    ttk::label .bd.wingARV -textvariable wingAR

    ttk::label .bd.numCells -text [::msgcat::mc "Number of Cells"]
    ttk::label .bd.numCellsV -textvariable numCells
    ttk::label .bd.numRibs -text [::msgcat::mc "Number of Ribs"]
    ttk::label .bd.numRibsV -textvariable numRibsTot
    ttk::label .bd.paraType -text [::msgcat::mc "Wing type"]
    ttk::label .bd.paraTypeV -textvariable paraType

    grid .bd.brandName -row 0 -column 0 -sticky w
    grid .bd.brandNameV -row 0 -column 1 -sticky w
    grid .bd.wingName -row 1 -column 0 -sticky w
    grid .bd.wingNameV  -row 1 -column 1 -sticky w
    grid .bd.drawScale -row 2 -column 0 -sticky w
    grid .bd.drawScaleV  -row 2 -column 1 -sticky w
    grid .bd.wingScale -row 3 -column 0 -sticky w
    grid .bd.wingScaleV  -row 3 -column 1 -sticky w
    grid .bd.wingSurface -row 4 -column 0 -sticky w
    grid .bd.wingSurfaceV  -row 4 -column 1 -sticky w
    grid .bd.wingSpan -row 5 -column 0 -sticky w
    grid .bd.wingSpanV  -row 5 -column 1 -sticky w
    grid .bd.wingAR -row 6 -column 0 -sticky w
    grid .bd.wingARV  -row 6 -column 1 -sticky w
    grid .bd.numCells -row 7 -column 0 -sticky w
    grid .bd.numCellsV  -row 7 -column 1 -sticky w
    grid .bd.numRibs -row 8 -column 0 -sticky w
    grid .bd.numRibsV  -row 8 -column 1 -sticky w
    grid .bd.paraType -row 9 -column 0 -sticky w
    grid .bd.paraTypeV  -row 9 -column 1 -sticky w

    #ToDo: add missing parameters
    # Surface
    # Span
    # AlphaCenter
    # AlphaWingTip

    # DrawTopView .tc.c_topv
}

#----------------------------------------------------------------------
#  proc CalcScaleFactor
#  Calculates the scale factor for drawing on the GUI based on Span
#  and width of Top View canvas
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: Scale Factor
#----------------------------------------------------------------------
proc CalcScaleFactor {} {

    source "globalWingVars.tcl"
    global .topv.c_topv

    # midX half the way on the x coordinate in the canvas
    set MidX [expr [winfo width .topv.c_topv] /2]
    set Span [expr 2*$ribConfig($numRibsHalf,6)]

    # scale factor
    set SF [expr (2* $MidX )/($Span)]
    # use only 90% of canvas
    set SF [expr $SF * 0.9]

    return $SF
}

proc DrawTopViewAndVault {} {

    # Redraw top and tail view
    DrawTopView 
    DrawTailView

}

proc DrawTopView {} {
    source "globalWingVars.tcl"
    global .topv.c_topv

    .topv.c_topv delete "all"

    # midX half the way on the x coordinate in the canvas
    set MidX [expr [winfo width .topv.c_topv] /2]

    set SF [CalcScaleFactor]

    set Chord [expr $ribConfig(1,4) - $ribConfig(1,3)]
    set MaxY [winfo height .topv.c_topv]
    set DeltaY [expr ($MaxY - ( $Chord * $SF )) /2 ]
    set StartY [expr ($MaxY /2) - $DeltaY]

    set i 1
    while {$i <= $numRibsHalf} {
        #                                     X                              Y Le                              X                              Y Te
        # right
        .topv.c_topv create line [expr $MidX+$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,3)] [expr $MidX+$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,4)] -tag linea2 -fill green
        # left
        .topv.c_topv create line [expr $MidX-$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,3)] [expr $MidX-$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,4)] -tag linea2 -fill red
        incr i
    }

    set i 1
    while {$i <= [expr $numRibsHalf-1]} {
        .topv.c_topv create line [expr $MidX+$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,3)] [expr $MidX+$SF*$ribConfig([expr $i+1],6)] [expr $StartY+$SF*$ribConfig([expr $i+1],3)] -tag linea2 -fill green
        .topv.c_topv create line [expr $MidX-$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,3)] [expr $MidX-$SF*$ribConfig([expr $i+1],6)] [expr $StartY+$SF*$ribConfig([expr $i+1],3)] -tag linea2 -fill red
        .topv.c_topv create line [expr $MidX+$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,4)] [expr $MidX+$SF*$ribConfig([expr $i+1],6)] [expr $StartY+$SF*$ribConfig([expr $i+1],4)] -tag linea2 -fill green
        .topv.c_topv create line [expr $MidX-$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,4)] [expr $MidX-$SF*$ribConfig([expr $i+1],6)] [expr $StartY+$SF*$ribConfig([expr $i+1],4)] -tag linea2 -fill red
        incr i
    }

    .topv.c_topv create line [expr $MidX+$SF*$ribConfig(1,6)] [expr $StartY+$SF*$ribConfig(1,3)] [expr $MidX-$SF*$ribConfig(1,6)] [expr $StartY+$SF*$ribConfig(1,3)] -tag linea2 -fill blue
    .topv.c_topv create line [expr $MidX+$SF*$ribConfig(1,6)] [expr $StartY+$SF*$ribConfig(1,4)] [expr $MidX-$SF*$ribConfig(1,6)] [expr $StartY+$SF*$ribConfig(1,4)] -tag linea2 -fill blue
}

proc DrawTailView {} {
    source "globalWingVars.tcl"
    global .tailv.c_tailv

    .tailv.c_tailv delete "all"

    set SF [CalcScaleFactor]

    # Derive X coordinate to start the drawing
    set MaxX [winfo width .tailv.c_tailv]
    set MidX [expr $MaxX /2]

    # Derive y coordinate to start the draw
    set MaxY [winfo height .tailv.c_tailv]
    set Height [expr $ribConfig($numRibsHalf,7) - $ribConfig(1,7)]
    set StartY [expr ($MaxY - ( $Height * $SF )) /2 ]

    set i 1
    while {$i <= [expr $numRibsHalf-1]} {
        .tailv.c_tailv create line [expr $MidX+$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,7)] [expr $MidX+$SF*$ribConfig([expr $i+1],6)] [expr $StartY+$SF*$ribConfig([expr $i+1],7)] -tag linea2 -fill green
        .tailv.c_tailv create line [expr $MidX-$SF*$ribConfig($i,6)] [expr $StartY+$SF*$ribConfig($i,7)] [expr $MidX-$SF*$ribConfig([expr $i+1],6)] [expr $StartY+$SF*$ribConfig([expr $i+1],7)] -tag linea2 -fill red
        incr i
    }
    .tailv.c_tailv create line [expr $MidX+$SF*$ribConfig(1,6)] [expr $StartY+$SF*$ribConfig(1,7)] [expr $MidX-$SF*$ribConfig(1,6)] [expr $StartY+$SF*$ribConfig(1,7)] -tag linea2 -fill blue
}

proc DrawSideView {} {
    source "globalWingVars.tcl"
    global .sidev.c_sidev

#    .sidev.c_sidev delete "all"

    set SF [CalcScaleFactor]

    # Derive X coordinate to start the drawing
    set MaxX [winfo width .sidev.c_sidev]

    set Chord [expr $ribConfig(1,4) - $ribConfig(1,3)]
    set StartX  [expr ($MaxX - ( $Chord * $SF )) /2 ]

    # Derive y coordinate to start the draw
    set MaxY [winfo height .sidev.c_sidev]
    set Height [expr $ribConfig($numRibsHalf,7) - $ribConfig(1,7)]
    set StartY [expr ($MaxY - ( $Height * $SF )) /2 ]

    set i 1
    while {$i <= [expr $numRibsHalf]} {
        .sidev.c_sidev create line [expr $StartX+$SF*$ribConfig($i,3)] [expr $StartY+$SF*$ribConfig($i,7)] [expr $StartX+$SF*$ribConfig($i,4)] [expr $StartY+$SF*$ribConfig($i,7)] -fill red
        incr i
    }

    set i 1
    while {$i <= [expr $numRibsHalf-1]} {
        .sidev.c_sidev create line [expr $StartX+$SF*$ribConfig($i,3)] [expr $StartY+$SF*$ribConfig($i,7)] [expr $StartX+$SF*$ribConfig([expr $i+1],3)] [expr $StartY+$SF*$ribConfig([expr $i+1],7)] -fill red
        .sidev.c_sidev create line [expr $StartX+$SF*$ribConfig($i,4)] [expr $StartY+$SF*$ribConfig($i,7)] [expr $StartX+$SF*$ribConfig([expr $i+1],4)] [expr $StartY+$SF*$ribConfig([expr $i+1],7)] -fill red
        incr i
    }
}

#----------------------------------------------------------------------
#  NewGeometry
#  Resets all global preproc values
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc NewGeometry {} {
    source "globalPreProcVars.tcl"
    global g_WingFilePathName
    global g_PreProcDataChanged
    global g_PreProcDataAvailable

    if { $g_PreProcDataChanged } {
        PromptForGeometrySave
    }

    initGlobalPreProcVars

    set g_PreProcFilePathName ""
    set g_PreDataChanged 0
    set g_PreProcDataAvailable 1

    global .topv.c_topv
    .topv.c_topv delete "all"

    global .tailv.c_tailv
    .tailv.c_tailv delete "all"

    global .sidev.c_sidev
#    .sidev.c_sidev delete "all"
}


proc OpenPreProcFile { {FilePathName ""} } {
    source "readPreProcDataFile.tcl"

    global g_PreProcDataChanged

    global g_PreProcDataAvailable
    global g_PreProcFileTypes

    global g_PreProcFilePathName

    if { $g_PreProcDataChanged   == 1 } {
            PromptForGeometrySave
    }

    if {$FilePathName == ""} {
        set FilePathName [tk_getOpenFile -filetypes $g_PreProcFileTypes]
    }

    if {$FilePathName != ""} {

        set ReturnValue [ readPreProcDataFile $FilePathName ]

        if { $ReturnValue != 0 } {
           # error [::msgcat::mc "Cannot Open File"] $FilePathName "for Reading"
        error "Cannot Open File $FilePathName for Reading"

        }

        set g_PreProcDataChanged    0
        set g_PreProcDataAvailable      1
        set g_PreProcFilePathName $FilePathName
    }
}

#----------------------------------------------------------------------
#  SavePreProcFile
#  Saves the PreProc File
#
#  IN:      Filename: if set the procedure will not ask for a filenam
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SavePreProcFile { {FilePathName ""} } {
    source "writePreProcDataFile.tcl"
    global g_PreProcDataChanged
    global g_PreProcFilePathName
    global g_PreProcFileTypes

    # if proc is called from save $FilePathName is not empty
    if { $FilePathName == "" } {
        # check if there was a filename passed
        if { $g_PreProcFilePathName != "" } {
            # yep there's an open file
            set FilePathName $g_PreProcFilePathName
        } else {
            # there's no FilePathName, therefore we ask for one
            set FilePathName [tk_getSaveFile -filetypes $g_PreProcFileTypes]
        }
    }

    # let's check for the file extension
    set Extension [file extension $FilePathName]
    if {$Extension != ".txt" } {
        # we need to add the extension
        append FilePathName ".txt"
    }

    if {$FilePathName != ""} {
        set ReturnValue [ writePreProcDataFile $FilePathName ]

        if { $ReturnValue != 0 } {
            error "Cannot write file $FilePathName"
            return
        }

        set g_PreProcDataChanged    0
        set g_PreProcDataAvailable  1
        set g_PreProcFilePathName $FilePathName
    }
}


#----------------------------------------------------------------------
#  SavePreProcFileAs
#  Saves the PreProc File under a new name
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SavePreProcFileAs { } {
    global g_PreProcFileTypes

    set FilePathName [tk_getSaveFile -filetypes $g_PreProcFileTypes]
    if { $FilePathName != "" } {
        SavePreProcFile $FilePathName
    }
}

#----------------------------------------------------------------------
#  ImportWingGeometry
#  Is called upon selection of Wing->Import Wing menu
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc ImportWingGeometry {} {
    source "globalWingVars.tcl"
    source "preProcOutFileImport.tcl"

    global g_WingDataChanged
    global g_WingDataAvailable
    global g_WingFileTypes

    if { $g_WingDataChanged } {
        PromptForWingSave
    }

    # WARNING!!!! get rid of old values
#    initGlobalWingVars

    set FilePathName [tk_getOpenFile -filetypes $g_WingFileTypes]

#    puts "here $FilePathName"

    if {$FilePathName != ""} {
        set ReturnValue [ importPreProcOutFile $FilePathName ]

        if { $ReturnValue != 0 } {
             error "Cannot open file $FilePathName for reading"]

        }

        set g_WingDataChanged 0
    }

    set g_WingDataAvailable 1


    DrawTopView
    DrawTailView
#    Not draw side view
#    DrawSideView
}

#----------------------------------------------------------------------
#  OpenWingFile
#  Checks for unsaved data. Asks in case if current data should be saved.
#  Opens a new wing file.
#
#  IN:      FilePathName    optional the name of the file to open
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc OpenWingFile { {FilePathName ""} } {

    global g_WingDataChanged
    global g_WingFileTypes
    global g_WingDataAvailable

#   TEMPORARY ---------------------------------------------------------
#   Set direct path #### temporary code during development, to open fast
#    set FilePathName "/home/pere/Documents/LEP/GUI-Tcl/lepg-3.15/lep/lep-3.15/lep/leparagliding.txt"
#   TEMPORARY ---------------------------------------------------------


    if { $g_WingDataChanged } {
        PromptForWingSave
    }

    source "readLepDataFile.tcl"


    if {$FilePathName == ""} {
        set FilePathName [tk_getOpenFile -filetypes $g_WingFileTypes]
    }

    if {$FilePathName != ""} {
        set ReturnValue [ readLepDataFile $FilePathName ]

        if { $ReturnValue != 0 } {
            error "Cannot open file $FilePathName for reading"
        }

        set g_WingDataChanged 0
    }

    set g_WingDataAvailable 1

    DrawTopView
    DrawTailView
#   TEMPORARY: REMOVE SIDE VIEW AND CHANGE BY PHOTO
#    DrawSideView

    ##### temporary code below
    set g_WingDataChanged 1

#    puts $FilePathName

#   Calcule surface, span, aspect ratio
    source "wingSomeCalculus.tcl"
    wingSomeCalculus

}

#----------------------------------------------------------------------
#  SaveWingFile
#  Saves the wing file
#
#  IN:      Filename: if set the procedure will not ask for a filenam
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
 proc SaveWingFile { {FilePathName ""} } {
    source "writeWingDataFile.tcl"
    global g_WingDataChanged
    global g_WingFilePathName
    global g_WingFileTypes

    # if proc is called from save $FilePathName is not empty
    if { $FilePathName == "" } {
        # check if there was a filename passed
        if { $g_WingFilePathName != "" } {
            # yep there's an open file
            set FilePathName $g_WingFilePathName
        } else {
            # there's no FilePathName, therefore we ask for one
            set FilePathName [tk_getSaveFile -filetypes $g_WingFileTypes]
        }

    }

    # let's check for the file extension
    set Extension [file extension $FilePathName]
    if {$Extension != ".txt" } {
        # we need to add the extension
        append FilePathName ".txt"
    }

    if {$FilePathName != ""} {
        set ReturnValue [ writeWingDataFile $FilePathName ]

        if { $ReturnValue != 0 } {
            error "Cannot write file $FilePathName"
            return
        }

        set g_WingDataChanged    0
        set g_WingDataAvailable  1
        set g_WingFilePathName $FilePathName
    }
}

#----------------------------------------------------------------------
#  SaveWingFileAs
#  Saves the wing file under a new name
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: N/A
#----------------------------------------------------------------------
proc SaveWingFileAs { } {
    global g_WingFileTypes

    set FilePathName [tk_getSaveFile -filetypes $g_WingFileTypes]
    if { $FilePathName != "" } {
        SaveWingFile $FilePathName
    }
}

#----------------------------------------------------------------------
#  PromptForGeometrySave
#  Asks the user if he really wants to loose all unsaved PreProc data
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: 1   if user has selected yes => I wann loose the data
#           0   if user want to abort
#----------------------------------------------------------------------
proc PromptForGeometrySave { } {
    set answer [tk_messageBox -title [::msgcat::mc "Geometry: you have unsaved data!"] \
        -type yesno -icon question \
        -message [::msgcat::mc "You have unsaved Geometry data. \n Do you want to save the changes?"]]
    if { $answer == "yes" } {
        SavePreProcFileAs
    }
}

proc PromptForWingSave { } {
    set answer [tk_messageBox -title [::msgcat::mc "Wing: you have unsaved data!"] \
        -type yesno -icon question \
        -message [::msgcat::mc "You have unsaved Wing data. \n Do you want to save the changes?"]]
    if { $answer == "yes" } {
        SaveWingFileAs
    }
}

proc OpenWingBasicDataEdit { } {
    source "wingBasicDataEdit.tcl"

    wingBasicDataEdit
}

proc OpenWingWashinDataEdit { } {

    source "wingWashinDataEdit.tcl"

    wingWashinDataEdit
}

proc OpenWingGeoEditDataEdit { } {

    source "wingMatrixGeoDataEdit.tcl"

    wingMatrixGeoDataEdit 
}

proc OpenWingCellsNumberDataEdit { } {

    source "wingCellsNumberDataEdit.tcl"

    wingCellsNumberDataEdit 
}

proc OpenWingAirfoilsDataEdit { } {
    source "wingAirfoilsDataEdit.tcl"

    wingAirfoilsDataEdit
}

proc OpenWingAnchorsDataEdit { } {
    source "wingAnchorsDataEdit.tcl"

    wingAnchorsDataEdit
}

proc OpenWingAirfoilHolesDataEdit { } {
    source "wingAirfoilHolesDataEdit.tcl"

    wingAirfoilHolesDataEdit
}

proc OpenWingSkinTensionDataEdit { } {
    source "wingSkinTensionDataEdit.tcl"

    wingSkinTensionDataEdit
}

proc OpenGlobalAoADataEdit { } {
    source "wingGlobalAoADataEdit.tcl"

    wingGlobalAoADataEdit
}

proc OpenSuspensionLinesDataEdit { } {
    source "wingSuspensionLinesDataEdit.tcl"

    wingSuspensionLinesDataEdit
}

proc OpenBrakeLinesDataEdit { } {
    source "wingBrakeLinesDataEdit.tcl"

    wingBrakeLinesDataEdit
}

proc OpenRamificationLengthDataEdit { } {
    source "wingRamificationLengthDataEdit.tcl"

    wingRamificationLengthDataEdit
}

proc OpenHV-VH-RibsDataEdit { } {
    source "wing-hv-vh-ribs-DataEdit.tcl"

    wingHV-VH-RibsDataEdit
}

proc OpenWingTEColorDataEdit { } {
    source "wingTEColorsDataEdit.tcl"

    wingTrailingEdgeColorsDataEdit
}

proc OpenWingLEColorDataEdit { } {
    source "wingLEColorsDataEdit.tcl"

    wingLeadingEdgeColorsDataEdit
}

proc OpenWingAddRibPointsDataEdit { } {
    source "wingAddRibPointsDataEdit.tcl"

    wingAddRibPointsDataEdit
}

proc OpenWingSewingAllowancesEdit { } {
    source "wingSewingAllowancesEdit.tcl"

    wingSewingAllowancesEdit
}

proc OpenWingMarksEdit { } {
    source "wingMarksDataEdit.tcl"

    wingMarksEdit
}

proc OpenElasticLinesCorrEdit { } {
    source "wingElasticLinesCorrEdit.tcl"

    wingElasticLinesCorrEdit
}

proc OpenWingDXFLayNamesDataEdit { } {
    source "wingDXFLayNamesDataEdit.tcl"

    wingDXFLayNamesDataEdit
}

proc OpenWingMarksTypesDataEdit { } {
    source "wingMarksTypesDataEdit.tcl"

    wingMarksTypesDataEdit
}

proc OpenWingJoncsDefDataEdit { } {
    source "wingJoncsDefDataEdit.tcl"

    wingJoncsDefDataEdit
}

proc OpenWingNoseMyDataEdit { } {
    source "wingNoseMyDataEdit.tcl"

    wingNoseMyDataEdit
}

proc OpenWingTabReinfDataEdit { } {
    source "wingTabReinfDataEdit.tcl"

    wingTabReinfDataEdit
}

proc OpenWingGe2DopDataEdit { } {
    source "wingGe2DopDataEdit.tcl"

    wingGe2DopDataEdit
}

proc OpenWingGe3DopDataEdit { } {
    source "wingGe3DopDataEdit.tcl"

    wingGe3DopDataEdit
}

proc OpenWingGlueVenDataEdit { } {
    source "wingGlueVenDataEdit.tcl"

    wingGlueVenDataEdit
}

proc OpenWingSpecWtDataEdit { } {
    source "wingSpecWtDataEdit.tcl"

    wingSpecWtDataEdit
}

proc OpenWingCalagVarDataEdit { } {
    source "wingCalagVarDataEdit.tcl"

    wingCalagVarDataEdit
}

proc OpenWingAirThickDataEdit { } {
    source "wingAirThickDataEdit.tcl"

    wingAirThickDataEdit
}

proc OpenShaping3DDataEdit { } {
     source "wingP3DShapingDataEdit.tcl"

     wingP3DShapingDataEdit
}

proc OpenWingNewSkinDataEdit { } {
    source "wingNewSkinDataEdit.tcl"

    wingNewSkinDataEdit
}




# Add more sections HERE:



proc myAppExit { } {
    global g_PreProcDataChanged
    global g_WingDataChanged

    # make sure there's no unsaved data
    if { $g_PreProcDataChanged == 1 } {
        PromptForGeometrySave
    }

    if { $g_WingDataChanged == 1} {
        PromptForWingSave
    }

    ::lepConfigFile::saveFile $::GlobalConfig
    exit
}

#----------------------------------------------------------------------
#   proc HelpAbout
#
#   Displays version and license note
#----------------------------------------------------------------------
proc HelpAbout { } {
    global LepVersioNumber
    global LepgNumber
    global VersionDate
#   Toplevel

    toplevel .helplep

    wm geometry .helplep 500x260+200+200
    wm title .helplep "LEparagliding"
    focus .helplep

    frame .helplep.fr1 -width 500 -height 200 -bd 2
    pack  .helplep.fr1 -side top -padx 2m -pady 2m -ipadx 2c -ipady 2c

    set img [image create photo -file img/le-ge.png]
    label .helplep.fr1.lb1 -image $img
    pack  .helplep.fr1.lb1 -side  top

    label .helplep.fr1.lb2 -text " "
    label .helplep.fr1.lb3 -text "LEparagliding $LepVersioNumber GUI-$LepgNumber ($VersionDate)"
    label .helplep.fr1.lb4 -text "General Public License GNU GPL3.0"
    label .helplep.fr1.lb5 -text "Pere Casellas, Stefan Feuz"
    label .helplep.fr1.lb6 -text "http://www.laboratoridenvol.com"

    pack .helplep.fr1.lb2 .helplep.fr1.lb3 .helplep.fr1.lb4 .helplep.fr1.lb5 \
    .helplep.fr1.lb6 -side top

    button .helplep.fr1.holaok -text [::msgcat::mc " OK "] -command {destroy .helplep}
    pack .helplep.fr1.holaok -padx 20 -pady 10

}

proc myAppSearchBindingsAndEval {event bindtags script} {
    foreach tag $bindtags {
        foreach sequence [bind $tag] {
            if {[string first $event $sequence] == 0} {
                return [uplevel $script]
            }
        }
    }
}
proc myAppConfigEditMenu {menu bindtags} {
    foreach {event index} {<<Cut>>   0
                           <<Copy>>  1
                           <<Paste>> 2
    } {
        $menu entryconfigure $index -state disabled
        myAppSearchBindingsAndEval $event $bindtags {
            $menu entryconfigure $index -state normal
        }
    }
}

#---------------------------------------------------------------------
#  Configuration operations
#---------------------------------------------------------------------

proc SetLanguage {Lang} {
    dict set ::GlobalConfig Language $Lang
    tk_messageBox -title [::msgcat::mc "lbl_LangChanged"] -message [::msgcat::mc "txt_PlsRestart"] -icon info -type ok -default ok
}

#---------------------------------------------------------------------
#  Lep Directory selection
#---------------------------------------------------------------------
proc LepDirSelect {} {
    source "lepDirSelect.tcl"

    lepDirSelect_lDS
}

#---------------------------------------------------------------------
#  pre-Processsor Directory selection
#---------------------------------------------------------------------
proc PreProcDirSelect_lepg {} {
    source "preProcDirSelect.tcl"

    PreProcDirSelect_pPDS

    # CreateMainWindow 
}

#---------------------------------------------------------------------
#  Main window image selection
#---------------------------------------------------------------------
proc MainwImageSelect {} {
    source "mainwImageSelect.tcl"

    MainwIS_pIDS

# Refresh main window not here
#    .sidev.c_sidev delete "all"   
#    CreateMainWindow
}



proc SetGlobalVarTrace {} {
    global g_PreProcDataChanged
    trace variable g_PreProcDataChanged w { GlobalVarTrace }
    global g_PreProcDataAvailable
    trace variable g_PreProcDataAvailable w { GlobalVarTrace }
}

proc GlobalVarTrace {a e op } {
        # maybe helpful for debug
        puts "  a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

        set systemTime [clock seconds]
        puts "***** [clock format $systemTime -format %H:%M:%S]"

        global g_PreProcDataChanged
        global g_PreProcDataAvailable
        puts "g_PreProcDataChanged        $g_PreProcDataChanged"
        puts "g_PreProcDataAvailable      $g_PreProcDataAvailable"
}

proc SetPreProcBtnStatus { a e op } {

    global base
    global g_PreProcDataAvailable

    if {$g_PreProcDataAvailable == 0} {
        $base.menu.geometry entryconfigure [::msgcat::mc "Save Geometry"]    -state disabled
        $base.menu.geometry entryconfigure [::msgcat::mc "Save Geometry As"] -state disabled
        $base.menu.geometry entryconfigure [::msgcat::mc "Edit Geometry"]    -state disabled
        $base.menu.geometry entryconfigure [::msgcat::mc "Calc Geometry"]    -state disabled

    } else {
        $base.menu.geometry entryconfigure [::msgcat::mc "Save Geometry"]    -state active
        $base.menu.geometry entryconfigure [::msgcat::mc "Save Geometry As"] -state active
        $base.menu.geometry entryconfigure [::msgcat::mc "Edit Geometry"]    -state active
        $base.menu.geometry entryconfigure [::msgcat::mc "Calc Geometry"]    -state active

    }
}

proc SetWingBtnStatus { a e op } {

    global base
    global g_WingDataAvailable

    if {$g_WingDataAvailable == 0} {
        $base.menu.wing entryconfigure [::msgcat::mc "Save Wing"]    -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "Save Wing As"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "01A. Basic Data"]   -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "01B. Washin"]   -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "01C. Geometry edit"]   -state disabled
       # $base.menu.wing entryconfigure [::msgcat::mc "01D. Cells number"]   -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "02. Airfoils"]     -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "03. Anchor Points"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "04. Airfoil Holes"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "05. Skin Tension"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "08. Global AoA"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "09. Suspension lines"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "11. Ramification lengths"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "12. HV-VH Ribs"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "10. Brake lines"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "15. Extrados Colors"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "16. Intrados Colors"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "17. Additional rib points"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "18. Elastic lines corr"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "21. Joncs definitions"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "22. Nose mylars"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "23. Tab reinforcements"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "26. Glue vents"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "27. Special wingtip"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "28. Calage variation"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "29. 3D shaping"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "30. Airfoil thickness"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "31. New skin tension"] -state disabled
        $base.menu.wing entryconfigure [::msgcat::mc "Calc Wing"] -state disabled

        $base.menu.wingplan entryconfigure [::msgcat::mc "06. Sewing Allowances"] -state disabled
        $base.menu.wingplan entryconfigure [::msgcat::mc "07. Marks"] -state disabled
        $base.menu.wingplan entryconfigure [::msgcat::mc "19. DXF layer names"] -state disabled
        $base.menu.wingplan entryconfigure [::msgcat::mc "20. Marks types"] -state disabled
        $base.menu.wingplan entryconfigure [::msgcat::mc "24. General 2D DXF options"] -state disabled
        $base.menu.wingplan entryconfigure [::msgcat::mc "25. General 3D DXF options"] -state disabled

        $base.menu.run entryconfigure [::msgcat::mc "Check coherence"] -state disabled
        $base.menu.run entryconfigure [::msgcat::mc "Run LEparagliding"] -state disabled
    } else {
        $base.menu.wing entryconfigure [::msgcat::mc "Save data"]    -state active
        $base.menu.wing entryconfigure [::msgcat::mc "Save data As"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "01A. Basic Data"]   -state active
        $base.menu.wing entryconfigure [::msgcat::mc "01B. Washin"]   -state active
        $base.menu.wing entryconfigure [::msgcat::mc "01C. Geometry edit"]   -state active
       # $base.menu.wing entryconfigure [::msgcat::mc "01D. Cells number"]   -state active
        $base.menu.wing entryconfigure [::msgcat::mc "02. Airfoils"]     -state active
        $base.menu.wing entryconfigure [::msgcat::mc "03. Anchor Points"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "04. Airfoil Holes"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "05. Skin Tension"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "08. Global AoA"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "09. Suspension lines"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "10. Brake lines"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "11. Ramification lengths"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "12. HV-VH Ribs"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "15. Extrados Colors"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "16. Intrados Colors"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "17. Additional rib points"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "18. Elastic lines corr"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "21. Joncs definition"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "22. Nose mylars"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "23. Tab reinforcements"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "26. Glue vents"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "27. Special wingtip"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "28. Calage variation"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "29. 3D shaping"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "30. Airfoil thickness"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "31. New skin tension"] -state active
        $base.menu.wing entryconfigure [::msgcat::mc "Calc Wing"] -state active

        $base.menu.wingplan entryconfigure [::msgcat::mc "06. Sewing Allowances"] -state active
        $base.menu.wingplan entryconfigure [::msgcat::mc "07. Marks"] -state active
        $base.menu.wingplan entryconfigure [::msgcat::mc "19. DXF layer names"] -state active
        $base.menu.wingplan entryconfigure [::msgcat::mc "20. Marks types"] -state active
        $base.menu.wingplan entryconfigure [::msgcat::mc "24. General 2D DXF options"] -state active
        $base.menu.wingplan entryconfigure [::msgcat::mc "25. General 3D DXF options"] -state active

        $base.menu.run entryconfigure [::msgcat::mc "Run LEparagliding"] -state active
    }
}



#---------------------------------------------------------------------
#  Execute the main procedure
#---------------------------------------------------------------------

myAppMain $argc $argv
