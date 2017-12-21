#! /usr/bin/tclsh8.6

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
set myAppFileName ""

# PreProcessor related values
set g_GlobPreProcDataChanged 0
                                    # set to 1 if PreProc data in main window
                                    # has been changed
set g_LclPreProcDataChanged 0
                                    # set to 1 if PreProc data in Edit PreProc
                                    # window has been changed
set g_LclPreProcDataNotApplied 0
                                    # set to 1 if PreProc data in Edit PreProc
                                    # window has been changed and not applied
set g_PreProcDataAvailable 0
                                    # set to 1 if data in main window is available

set g_LepDataChanged 0

set g_PreProcFileTypes {
    {{Geometry files}   {.txt}}
}
set g_DataFileTypes {
    {{Data files}   {.txt}}
}

set .topv.c_topv ""
set .tailv.c_tailv ""
set .sidev.c_sidev ""


set data_le(c0) 10.11

#---------------------------------------------------------------------
#
#  LEparagliding GUI
set LepVersioNumber "2.52"
set LepgNumber "V0.3.1"
set VersionDate   "2017-12-01"
#
#  Pere Casellas
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
        OpenLepFile [lindex $argv 0]
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
    global LepVersioNumber
    global LepgNumber
    source "EditPreProcData.tcl"
    source "userHelp.tcl"

    #-----------------------------------------------------------------
    # setup translation framework
    #-----------------------------------------------------------------
    ::msgcat::mclocale [dict get $::GlobalConfig Language]
    ::msgcat::mcload [file join [file dirname [info script]]]

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

    menu $base.menu.edit -tearoff 0
    menu $base.menu.planform -tearoff 0
    menu $base.menu.vault -tearoff 0
    menu $base.menu.airfoils -tearoff 0
    menu $base.menu.calage -tearoff 0
    menu $base.menu.skin -tearoff 0
    menu $base.menu.vhribs -tearoff 0
    menu $base.menu.lines -tearoff 0
    menu $base.menu.colors -tearoff 0
    menu $base.menu.parameters -tearoff 0
    menu $base.menu.dxf -tearoff 0
    menu $base.menu.txt -tearoff 0
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
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "New Geometry"] -state disabled
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Open Geometry..."] -command OpenPreProcFile
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Edit Geometry"] -command EditPreProcData
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Calc Geometry"] -state disabled
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Calc& read back Geometry"] -state disabled
    $base.menu.geometry add command -underline 0 -label [::msgcat::mc "Save Geometry"] -command SavePreProcFile

    $base.menu.geometry add command -underline 5 -label [::msgcat::mc "Save Geometry As"] -state disabled

    # Wing menu
    $base.menu add cascade -label [::msgcat::mc "Wing"] -underline 0 -menu $base.menu.wing
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "New Wing"] -command myAppFileNew -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "Import Geometry"] -state disabled
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "Open Wing..."] -command OpenLepFile
    $base.menu.wing add command -underline 0 -label [::msgcat::mc "Save Wing"] -command myAppFileSave -state disabled
    $base.menu.wing add command -underline 5 -label [::msgcat::mc "Save Wing As"] -command myAppFileSaveAs -state disabled

    # Edit menu
    $base.menu add cascade -label [::msgcat::mc "Edit"] -underline 0 -menu $base.menu.edit

    $base.menu.edit add command -underline 2 -label [::msgcat::mc "Cut"] -command myAppEditCut
    $base.menu.edit add command -underline 0 -label [::msgcat::mc "Copy"] -command myAppEditCopy
    $base.menu.edit add command -underline 0 -label [::msgcat::mc "Paste"] -command myAppEditPaste

    # Planform menu
    $base.menu add cascade -label [::msgcat::mc "Planform"] -underline 0 -menu $base.menu.planform

    $base.menu.planform add command -underline 2 -label [::msgcat::mc "Cells number and distribution"] -command myAppCells
    $base.menu.planform add command -underline 0 -label [::msgcat::mc "Geometry matrix inspection"] -command GeometryMatrixWindow

    # Vault menu
    $base.menu add cascade -label [::msgcat::mc "Vault"] -underline 0 -menu $base.menu.vault

    # Airfolils menu
    $base.menu add cascade -label [::msgcat::mc "Airfoils"] -underline 0 -menu $base.menu.airfolils

    # Calage menu
    $base.menu add cascade -label [::msgcat::mc "Calage"] -underline 0 -menu $base.menu.calage

    # Skin menu
    $base.menu add cascade -label [::msgcat::mc "Skin"] -underline 0 -menu $base.menu.skin

    # VH-ribs menu
    $base.menu add cascade -label [::msgcat::mc "VH-ribs"] -underline 0 -menu $base.menu.vhribs

    # Lines menu
    $base.menu add cascade -label [::msgcat::mc "Lines"] -underline 0 -menu $base.menu.lines

    $base.menu.lines add command -underline 0 -label [::msgcat::mc "Basic"]
    $base.menu.lines add command -underline 0 -label [::msgcat::mc "Lines A"]
    $base.menu.lines add command -underline 0 -label [::msgcat::mc "Lines B"]
    $base.menu.lines add command -underline 0 -label [::msgcat::mc "Lines C"]
    $base.menu.lines add command -underline 0 -label [::msgcat::mc "Lines D"]
    $base.menu.lines add command -underline 0 -label [::msgcat::mc "Lines E"]
    $base.menu.lines add command -underline 0 -label [::msgcat::mc "Brakes"]

    # Colors menu
    $base.menu add cascade -label [::msgcat::mc "Colors"] -underline 0 -menu $base.menu.colors

    # Parameters menu
    $base.menu add cascade -label [::msgcat::mc "Parameters"] -underline 0 -menu $base.menu.parameters

    # DXF menu
    $base.menu add cascade -label [::msgcat::mc "DXF"] -underline 0 -menu $base.menu.dxf

    # txt menu
    $base.menu add cascade -label [::msgcat::mc "txt"] -underline 0 -menu $base.menu.txt


    # Run menu
    $base.menu add cascade -label [::msgcat::mc "Run"] -underline 0 -menu $base.menu.run

    $base.menu.run add cascade -label [::msgcat::mc "pre-Processor"] -underline 0 -command {RunLep "0"}
    $base.menu.run add cascade -label [::msgcat::mc "lep"] -underline 0 -command {RunLep "1"}
    $base.menu.run add cascade -label [::msgcat::mc "Both"] -underline 0 -command {RunLep "2"}

    # Settings menu
    $base.menu add cascade -label [::msgcat::mc "Settings"] -underline 0 -menu $base.menu.settings

    $base.menu.settings add cascade -label [::msgcat::mc "Language"] -underline 0 -menu $base.menu.settings.language
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Catalan"] -command {SetLanguage "ca"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "English"] -command {SetLanguage "en"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "German"] -command {SetLanguage "de"}

    $base.menu.settings add cascade -label [::msgcat::mc "pre-Processor Directory"] -underline 0 -command PreProcDirSelect
    $base.menu.settings add cascade -label [::msgcat::mc "lep Directory"] -underline 0 -command LepDirSelect

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

    #-----------------------------------------------------------------
    #  insert code defining myApp main window
    #-----------------------------------------------------------------
    ### text .t
    ### bind .t <Key> {set g_LepDataChanged 1}
    ### pack .t
}

#    End InitGui

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
    ttk::labelframe .sidev -text [::msgcat::mc "Side view"]
    canvas .sidev.c_sidev -width 500 -height 300 -bg white
    pack .sidev.c_sidev -expand yes -fill both

    # Basic data
    ttk::labelframe .bd -text [::msgcat::mc "Basic data"]

    grid .tailv -row 0 -column 0 -sticky nesw
    grid .sidev -row 0 -column 1 -sticky nesw
    grid .topv -row 1 -column 0 -sticky nesw
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
    ttk::label .bd.numCells -text [::msgcat::mc "Number of Cells"]
    ttk::label .bd.numCellsV -textvariable numCells
    ttk::label .bd.numRibs -text [::msgcat::mc "Number of Ribs"]
    ttk::label .bd.numRibsV -textvariable numRibsTot

    grid .bd.brandName -row 0 -column 0 -sticky w
    grid .bd.brandNameV -row 0 -column 1 -sticky w
    grid .bd.wingName -row 1 -column 0 -sticky w
    grid .bd.wingNameV  -row 1 -column 1 -sticky w
    grid .bd.drawScale -row 2 -column 0 -sticky w
    grid .bd.drawScaleV  -row 2 -column 1 -sticky w
    grid .bd.wingScale -row 3 -column 0 -sticky w
    grid .bd.wingScaleV  -row 3 -column 1 -sticky w
    grid .bd.numCells -row 4 -column 0 -sticky w
    grid .bd.numCellsV  -row 4 -column 1 -sticky w
    grid .bd.numRibs -row 5 -column 0 -sticky w
    grid .bd.numRibsV  -row 5 -column 1 -sticky w

    #ToDo: add missing parameters
    # Surface
    # Span
    # AlphaCenter
    # AlphaWingTip
    # Wing type

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

    .sidev.c_sidev delete "all"

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

#   Print geometry matrix
    # set i 1
    # set xx 0
    # while {$i <= $numRibsHalf} {
    #     foreach j {1 2 3 4 6 7 9 10 51} {
    #         set xx [expr $xx+40]
    #         set yy [expr 10+20*($i-1)]
    #         .uno.c2 create text $xx $yy -text $ribConfig($i,$j) -tag texto4 -fill black -font {Courier 8}
    #     }
    #     set xx 0
    #     incr i
    # }





proc myAppFileNew { } {
    global myAppFileName
    global g_LepDataChanged
    if { $g_LepDataChanged } {
        PromptForWingSave
    }

    #-----------------------------------------------------------------
    # insert code for "new" operation
    #-----------------------------------------------------------------
    ### .t delete 1.0 end

    set myAppFileName ""
    set g_LepDataChanged 0
 }

proc OpenPreProcFile { {FilePathName ""} } {
    source "readPreProcDataFile.tcl"

    global g_GlobPreProcDataChanged
    global g_LclPreProcDataChanged
    global g_LclPreProcDataNotApplied

    global g_PreProcDataAvailable
    global g_PreProcFileTypes

    if { $g_GlobPreProcDataChanged   == 1 ||
         $g_LclPreProcDataChanged    == 1 ||
         $g_LclPreProcDataNotApplied == 1 } {

             set Answer [PromptForPreProcFileOpenCancel]

             if { $Answer == 1 } {
                 return 0
        }
    }

    if {$FilePathName == ""} {
        set FilePathName [tk_getOpenFile -filetypes $g_PreProcFileTypes]
    }

    if {$FilePathName != ""} {
        set ReturnValue [ readPreProcDataFile $FilePathName ]

        if { $ReturnValue != 0 } {
            error "Cannot Open File $FilePathName for Reading"
        }

        set g_GlobPreProcDataChanged    0
        set g_LclPreProcDataChanged     0
        set g_LclPreProcDataNotApplied  0
        set g_PreProcDataAvailable      1
    }
}

proc OpenLepFile { {FilePathName ""} } {
    # global myAppFileName
    global g_LepDataChanged
    global g_DataFileTypes

    if { $g_LepDataChanged } {
        PromptForWingSave
    }

    source "readLepDataFile.tcl"

    if {$FilePathName == ""} {
        set FilePathName [tk_getOpenFile -filetypes $g_DataFileTypes]
    }

    if {$FilePathName != ""} {
        set ReturnValue [ readLepDataFile $FilePathName ]

        if { $ReturnValue != 0 } {
            error "Cannot Open File $FilePathName for Reading"
        }

        set g_LepDataChanged 0
    }

    DrawTopView
    DrawTailView
    DrawSideView
}

proc SavePreProcFile { {filename ""} } {
   global myAppFileName
   global g_LepDataChanged #BMA
   if { $filename == "" } {
       set filename $myAppFileName
   }
   if { $filename != "" } {
       if { [catch {open $filename w} fp] } {
            error "Cannot write to $filename"
       }

        #-------------------------------------------------------------
        # insert code for "save" operation
        #-------------------------------------------------------------
        ###  -nonewline $fp [.t get 1.0 end] #BMA

        close $fp
        set myAppFileName $filename
        set g_LepDataChanged 0
   }
}


 proc myAppFileSave { {filename ""} } {
    global myAppFileName
    global g_LepDataChanged #BMA
    if { $filename == "" } {
        set filename $myAppFileName
    }
    if { $filename != "" } {
        if { [catch {open $filename w} fp] } {
             error "Cannot write to $filename"
        }

         #-------------------------------------------------------------
         # insert code for "save" operation
         #-------------------------------------------------------------
         ###  -nonewline $fp [.t get 1.0 end] #BMA

         close $fp
         set myAppFileName $filename
         set g_LepDataChanged 0
    }
}

proc PreProcFileSaveAs { } {
    global g_PreProcFileTypes

    set filename [tk_getSaveFile -filetypes $g_PreProcFileTypes]
    if { $filename != "" } {
        SavePreProcFile $filename
    }
}

proc myAppFileSaveAs { } {
    global myAppFileTypes
    set filename [tk_getSaveFile -filetypes $myAppFileTypes]
    if { $filename != "" } {
        myAppFileSave $filename
    }
}

#----------------------------------------------------------------------
#  PromptForPreProcFileOpenCancel
#  Asks the user if he really wants to loose all unsaved PreProc data
#
#  IN:      N/A
#  OUT:     N/A
#  Returns: 1   if user has selected yes => I wann loose the data
#           0   if user want to abort
#----------------------------------------------------------------------
proc PromptForPreProcFileOpenCancel { } {
    set answer [tk_messageBox -title "Geometry: you have unsaved data!" \
        -type yesno -icon question \
        -message "You have unsaved Geometry data. \n Do you want to continue and loose your data?"]
    if { $answer == "yes" } {
        return 0
    } else {
        return 1
    }
}

proc PromptForWingSave { } {
    set answer [tk_messageBox -title "myApp:  Do you want to save?" \
        -type yesno -icon question \
        -message "Do you want to save the changes?"]
    if { $answer == "yes" } {
        myAppFileSaveAs
    }
}

proc myAppExit { } {

    # make sure there's no unsaved data

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
    label .helplep.fr1.lb5 -text "Pere Casellas"
    label .helplep.fr1.lb6 -text "http://www.laboratoridenvol.com"

    pack .helplep.fr1.lb2 .helplep.fr1.lb3 .helplep.fr1.lb4 .helplep.fr1.lb5 \
    .helplep.fr1.lb6 -side top

    button .helplep.fr1.holaok -text " OK " -command {destroy .helplep}
    pack .helplep.fr1.holaok -padx 20 -pady 10

}

#----------------------------------------------------------------------
#   proc myAppCells
#
#   Set number of cells and its distribution along span
#----------------------------------------------------------------------
proc myAppCells { } {
#   Toplevel
    toplevel .numCellsdis

    wm geometry .numCellsdis +400+300
    wm title .numCellsdis "Number of cells and distribution"
    focus .numCellsdis

    frame .numCellsdis.fr1 -width 400 -height 300 -bd 2
    pack .numCellsdis.fr1 -side top -padx 2m -pady 2m -ipadx 2c -ipady 2c

}

#----------------------------------------------------------------------
#   proc GeometryMatrixWindow
#
#   Prints geometry matrix for inspect and edit
#----------------------------------------------------------------------
proc GeometryMatrixWindow { } {

    source "globalWingVars.tcl"

    #myApp_lep_r

    set w .text
    catch {destroy $w}
    toplevel $w
    focus $w
    wm title $w "Geometry matrix inspection and edit"
    wm geometry $w 600x300+50+50

    frame $w.f1 -width 600 -height 50 -bd 2 -relief groove
    frame $w.f2 -width 600 -height 300 -bd 2 -relief groove -bg yellow
    pack $w.f1 $w.f2 -side top

    text $w.f2.text -width 600 -height 400 -relief sunken -bd 2 -setgrid 1 -height 30
#    scrollbar $w.scroll -command $w.text yview
#    pack $w.scroll -side right -fill y
#    pack $w.f2.text -fill both

    pack $w.f2.text -side top

    # Se inserta el texto en el widget
    set i 1
    while {$i <= $numRibsHalf} {
    $w.f2.text insert $i.0 $ribGeomLine($i)\n
    incr i }

    button $w.ok -text " OK " -command {destroy .text}
    pack $w.ok -padx 20 -pady 10

}


#----------------------------------------------------------------------
#   proc myAppVault
#
#   Define an analytical leading edge
#----------------------------------------------------------------------
#    source "p_va.tcl"
#----------------------------------------------------------------------



#---------------------------------------------------------------------
#  Cut/Copy/Paste
#
#  These procedures generate events
#  for all Tk Widgets in the GUI
#---------------------------------------------------------------------
proc myAppEditCut { } {
    event generate [focus] <<Cut>>
}

proc myAppEditCopy { } {
    event generate [focus] <<Copy>>
}

proc myAppEditPaste { } {
    event generate [focus] <<Paste>>
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
	dict set ::GlobalConfig LepDirectory [tk_chooseDirectory -title [::msgcat::mc "title_SelectLepDirectory"] ]
}

#---------------------------------------------------------------------
#  pre-Processsor Directory selection
#---------------------------------------------------------------------
proc PreProcDirSelect {} {
	dict set ::GlobalConfig PreProcDirectory [tk_chooseDirectory -title [::msgcat::mc "title_SelectPreProcDirectory"] ]
}


proc RunLep {RunLevel} {

	# RunLevel 0: pre-Processor
	# RunLevel 1: lep
	# RunLevel 2: both

	puts "RunLep level $RunLevel"

}

proc SetGlobalVarTrace {} {
    global g_GlobPreProcDataChanged
    trace variable g_GlobPreProcDataChanged w { GlobalVarTrace }
    global g_LclPreProcDataChanged
    trace variable g_LclPreProcDataChanged w { GlobalVarTrace }
    global g_LclPreProcDataNotApplied
    trace variable g_LclPreProcDataNotApplied w { GlobalVarTrace }
    global g_PreProcDataAvailable
    trace variable g_PreProcDataAvailable w { GlobalVarTrace }
}

proc GlobalVarTrace {a e op } {
        # maybe helpful for debug
        puts "  a=$a e=$e op=$op ax=[info exists ::$a] ex=[info exists ::${a}($e)]"

        set systemTime [clock seconds]
        puts "***** [clock format $systemTime -format %H:%M:%S]"

        global g_GlobPreProcDataChanged
        global g_LclPreProcDataChanged
        global g_LclPreProcDataNotApplied
        global g_PreProcDataAvailable
        puts "g_GlobPreProcDataChanged    $g_GlobPreProcDataChanged"
        puts "g_LclPreProcDataChanged     $g_LclPreProcDataChanged"
        puts "g_LclPreProcDataNotApplied  $g_LclPreProcDataNotApplied"
        puts "g_PreProcDataAvailable      $g_PreProcDataAvailable"
}



#---------------------------------------------------------------------
#  Execute the main procedure
#---------------------------------------------------------------------

myAppMain $argc $argv
