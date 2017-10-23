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
set g_DataChangedFlag 0
set g_DataFileTypes {
    {{Data files}   {.txt}}
}


set data_le(c0) 10.11

#---------------------------------------------------------------------
#
#  LEparagliding GUI
set VersionNumber "V0.2.1"
set VersionDate   "2016-08-20"
#
#  Pere Casellas
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
puts "myAppMain"
    #-----------------------------------------------------------------
    #  Global program configuration
    #-----------------------------------------------------------------
    #First setup hardcoded defaults
    dict set ::GlobalConfig Language "en"
    # Hardcoded defaults will be overwritten by config file values
    set ::GlobalConfig [::lepConfigFile::loadFile $::GlobalConfig]

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
puts "InitGui"
	global VersionNumber

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
    menu $base.menu.settings -tearoff 0
    menu $base.menu.settings.language -tearoff 0
    menu $base.menu.help -tearoff 0

    $root config -menu $base.menu

    # File menu
    $base.menu add cascade -label [::msgcat::mc "File"] -underline 0 -menu $base.menu.file

    $base.menu.file add command -underline 0 -label [::msgcat::mc "New"] -command myAppFileNew
    $base.menu.file add command -underline 0 -label [::msgcat::mc "Open..."] -command OpenLepFile
    $base.menu.file add command -underline 0 -label [::msgcat::mc "Close"] -command myAppFileClose
    $base.menu.file add separator
    $base.menu.file add command -underline 0 -label [::msgcat::mc "Save"] -command myAppFileSave
    $base.menu.file add command -underline 5 -label [::msgcat::mc "Save As"] -command myAppFileSaveAs
    $base.menu.file add separator
    $base.menu.file add command -underline 1 -label [::msgcat::mc "Exit"] -command myAppExit

    # Edit menu
    $base.menu add cascade -label [::msgcat::mc "Edit"] -underline 0 -menu $base.menu.edit

    $base.menu.edit add command -underline 2 -label [::msgcat::mc "Cut"] -command myAppEditCut
    $base.menu.edit add command -underline 0 -label [::msgcat::mc "Copy"] -command myAppEditCopy
    $base.menu.edit add command -underline 0 -label [::msgcat::mc "Paste"] -command myAppEditPaste

    # Planform menu
    $base.menu add cascade -label [::msgcat::mc "Planform"] -underline 0 -menu $base.menu.planform

    $base.menu.planform add command -underline 0 -label [::msgcat::mc "Leading edge"] -command myAppLeadingEdge
    $base.menu.planform add command -underline 1 -label [::msgcat::mc "Trailing edge"]
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

    # Settings menu
    $base.menu add cascade -label [::msgcat::mc "Settings"] -underline 0 -menu $base.menu.settings

    $base.menu.settings add cascade -label [::msgcat::mc "Language"] -underline 0 -menu $base.menu.settings.language
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "Catalan"] -command {SetLanguage "ca"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "English"] -command {SetLanguage "en"}
    $base.menu.settings.language add command -underline 0 -label [::msgcat::mc "German"] -command {SetLanguage "de"}


    # Help menu
    $base.menu add cascade -label [::msgcat::mc "Help"] -underline 0 -menu $base.menu.help

    $base.menu.help add command -underline 0 -label [::msgcat::mc "Version"] -command VersionInfo
    $base.menu.help add command -underline 0 -label [::msgcat::mc "About"] -command HelpAbout

    # Test if focus returns a valid window before calling
    # append pCmd "myAppConfigEditMenu $Edit " {{if {[focus] != {}} {[bindtags [focus]]}}}
    # $Edit configure -postcommand $pCmd

    #-----------------------------------------------------------------
    #  Set window manager properties for myApp
    #-----------------------------------------------------------------
    wm protocol $root WM_DELETE_WINDOW { myAppExit }
    wm geometry . +100+100
    wm title $root "Laboratori d'envol Paragliding Design Program 2.52 gui-$VersionNumber "

    #-----------------------------------------------------------------
    #  insert code defining myApp main window
    #-----------------------------------------------------------------
    ### text .t
    ### bind .t <Key> {set g_DataChangedFlag 1}
    ### pack .t
}

#    End InitGui


#----------------------------------------------------------------------
#    Procedures for read and write data files
#---------------------------------------------------------------------
#    proc myApp_lep_r
#    source "d_lep_r.tcl"

#    proc myAp_lep_w
    #source "d_lep_w.tcl"



proc CreateMainWindow {} {

    source "lep_GlobalWingVars.tcl"

    # create the four quadrants
    # Top view
    ttk::labelframe .tv -text "Top view" -width 400 -height 300
    # Front view
    ttk::labelframe .fw -text "Front view" -width 400 -height 300
    # Side view
    ttk::labelframe .sv -text "Side view" -width 400 -height 300
    # Basic data
    ttk::labelframe .bd -text "Basic data" -width 400 -height 300

    grid .fw -row 0 -column 0
    grid .sv -row 0 -column 1
    grid .tv -row 1 -column 0
    grid .bd -row 1 -column 1 -sticky nw

    # put labels in basicData
    ttk::label .bd.brandName -text "Brand Name"
    ttk::label .bd.brandNameV -textvariable bname
    ttk::label .bd.wingName -text "Wing Name"
    ttk::label .bd.wingNameV -textvariable wname
    ttk::label .bd.drawScale -text "Draw Scale"
    ttk::label .bd.drawScaleV -textvariable xkf
    ttk::label .bd.wingScale -text "Wing scale"
    ttk::label .bd.wingScaleV -textvariable xwf
    ttk::label .bd.numCells -text "Number of Cells"
    ttk::label .bd.numCellsV -textvariable ncells
    ttk::label .bd.numRibs -text "Number of Ribs"
    ttk::label .bd.numRibsV -textvariable nribst

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
}

#----------------------------------------------------------------------
#    proc main window
#----------------------------------------------------------------------
proc myAppWriteMain { } {

puts "myAppWriteMain"

    # source "lep_GlobalWingVars.tcl"
    # createGlobalWingVars

    global data_le

#   Read lep data file
#    myApp_lep_r

#   Write lep data
#    myApp_lep_w

#    set area 1.0

#    set span [expr 0.01*2*$rib($nribss,2)]

#----------------------------------------------------------------------
#
#   4. Adding some widgets, data, and schemes in main frame "."
#
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#   Create frames
#----------------------------------------------------------------------

    frame .uno -width 400 -height 800 -bd 2 -relief groove
    frame .dos -width 400 -height 800  -bd 2 -relief groove
    frame .tres -width 10 -height 800  -bd 2 -relief groove
    pack .uno .dos -side left

#----------------------------------------------------------------------
#   Main canvas
#----------------------------------------------------------------------
    canvas .uno.c1 -width 400 -height 400
    canvas .uno.c2 -width 400 -height 400
    pack .uno.c1 .uno.c2 -side top

    canvas .dos.c1 -width 600 -height 200 -bg white
    canvas .dos.c2 -width 600 -height 400 -bg white
    canvas .dos.c3 -width 600 -height 200 -bg white

    pack .dos.c1 .dos.c2 .dos.c3 -side top

    canvas .tres.c1 -width 100 -height 800 -bg white
    pack .tres.c1 -side right

#   Print basic data

    .uno.c1 create text 20 10 -tag texto -fill black -anchor w -text "Brand:"
#    .uno.c1 create text 150 10 -text $bname -tag texto2 -fill red -anchor w
    .uno.c1 create text 20 30 -text "Model:" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 30 -text $wname -tag texto4 -fill blue -anchor w
    .uno.c1 create text 20 50 -tag texto3 -fill black -anchor w -text "Cells:"
#    .uno.c1 create text 150 50 -text $ncells -tag texto4 -fill blue -anchor w
    .uno.c1 create text 20 70 -text "Draw scale:" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 70 -text $xkf -tag texto4 -fill blue -anchor w
    .uno.c1 create text 20 90 -text "Wing scale:" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 90 -text $xwf -tag texto4 -fill blue -anchor w
    .uno.c1 create text 20 110 -text "Surface (m2):" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 110 -text $area -tag texto4 -fill blue -anchor w
    .uno.c1 create text 20 130 -text "Span (m):" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 130 -text $span -tag texto4 -fill blue -anchor w

    .uno.c1 create text 20 150 -text "Ribs:" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 150 -text $nribst -tag texto4 -fill blue -anchor w
    .uno.c1 create text 20 170 -text "Ribs/2:" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 170 -text $nribss -tag texto4 -fill blue -anchor w

    .uno.c1 create text 20 190 -text "Washin method:" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 190 -text $kbbb -tag texto4 -fill blue -anchor w
    .uno.c1 create text 20 210 -text "Alpha center (deg):" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 210 -text $alphac -tag texto4 -fill blue -anchor w
    .uno.c1 create text 20 230 -text "Alpha wingtip (deg):" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 230 -text $alpham -tag texto4 -fill blue -anchor w

    .uno.c1 create text 20 250 -text "Wing type:" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 250 -text $atp -tag texto4 -fill blue -anchor w

    .uno.c1 create text 20 270 -text "c0_LE:" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 270 -text $data_le(c0) -tag texto4 -fill blue -anchor w

    .uno.c1 create text 20 290 -text "xdes:" -tag texto3 -fill black -anchor w
#    .uno.c1 create text 150 290 -text $xdes -tag texto4 -fill blue -anchor w



#   Print geometry matrix
    # set i 1
    # set xx 0
    # while {$i <= $nribss} {
    #     foreach j {1 2 3 4 6 7 9 10 51} {
    #         set xx [expr $xx+40]
    #         set yy [expr 10+20*($i-1)]
    #         .uno.c2 create text $xx $yy -text $rib($i,$j) -tag texto4 -fill black -font {Courier 8}
    #     }
    #     set xx 0
    #     incr i
    # }

#   Set some canvas and scale parameters
#   Canvas planform 600x200    .dos.c1
#   Canvas front view 600x400  .dos.c2
#   Canvas airfoil 600x200     .dos.c3
#    set c_c 300
#    set sf [expr 2*(300*0.9)/(100*$span)]

#----------------------------------------------------------------------
#   Draw basic planform
# Grundriss
#----------------------------------------------------------------------

    .dos.c1 create text 40 10 -text "Planform:" -tag texto -fill black -justify left
    # set i 1
    # while {$i <= $nribss} {
    #     .dos.c1 create line [expr $c_c+$sf*$rib($i,2)] [expr 20+$sf*$rib($i,3)] \
    #     [expr $c_c+$sf*$rib($i,2)] [expr 20+$sf*$rib($i,4)] -tag linea2 -fill green
    #     .dos.c1 create line [expr $c_c-$sf*$rib($i,2)] [expr 20+$sf*$rib($i,3)] \
    #     [expr $c_c-$sf*$rib($i,2)] [expr 20+$sf*$rib($i,4)] -tag linea2 -fill red
    #     incr i
    # }

    # set i 1
    # while {$i <= [expr $nribss-1]} {
    #     .dos.c1 create line [expr $c_c+$sf*$rib($i,2)] [expr 20+$sf*$rib($i,3)] \
    #     [expr $c_c+$sf*$rib([expr $i+1],2)] [expr 20+$sf*$rib([expr $i+1],3)] -tag linea2 -fill green
    #     .dos.c1 create line [expr $c_c-$sf*$rib($i,2)] [expr 20+$sf*$rib($i,3)] \
    #     [expr $c_c-$sf*$rib([expr $i+1],2)] [expr 20+$sf*$rib([expr $i+1],3)] -tag linea2 -fill red
    #     .dos.c1 create line [expr $c_c+$sf*$rib($i,2)] [expr 20+$sf*$rib($i,4)] \
    #     [expr $c_c+$sf*$rib([expr $i+1],2)] [expr 20+$sf*$rib([expr $i+1],4)] -tag linea2 -fill green
    #     .dos.c1 create line [expr $c_c-$sf*$rib($i,2)] [expr 20+$sf*$rib($i,4)] \
    #     [expr $c_c-$sf*$rib([expr $i+1],2)] [expr 20+$sf*$rib([expr $i+1],4)] -tag linea2 -fill red
    #     incr i
    # }

    # .dos.c1 create line [expr $c_c+$sf*$rib(1,2)] [expr 20+$sf*$rib(1,3)] \
    # [expr $c_c-$sf*$rib(1,2)] [expr 20+$sf*$rib(1,3)] -tag linea2 -fill blue
    # .dos.c1 create line [expr $c_c+$sf*$rib(1,2)] [expr 20+$sf*$rib(1,4)] \
    # [expr $c_c-$sf*$rib(1,2)] [expr 20+$sf*$rib(1,4)] -tag linea2 -fill blue


#----------------------------------------------------------------------
#   Draw basic front view
# Aufriss
#----------------------------------------------------------------------

    .dos.c2 create text 40 10 -text "Front view:" -tag texto -fill black -justify left
    # set i 1
    # while {$i <= [expr $nribss-1]} {
    #     .dos.c2 create line [expr $c_c+$sf*$rib($i,6)] [expr 20+$sf*$rib($i,7)] \
    #     [expr $c_c+$sf*$rib([expr $i+1],6)] [expr 20+$sf*$rib([expr $i+1],7)] -tag linea2 -fill green
    #     .dos.c2 create line [expr $c_c-$sf*$rib($i,6)] [expr 20+$sf*$rib($i,7)] \
    #     [expr $c_c-$sf*$rib([expr $i+1],6)] [expr 20+$sf*$rib([expr $i+1],7)] -tag linea2 -fill red
    #     incr i
    # }
    # .dos.c2 create line [expr $c_c+$sf*$rib(1,6)] [expr 20+$sf*$rib(1,7)] \
    # [expr $c_c-$sf*$rib(1,6)] [expr 20+$sf*$rib(1,7)] -tag linea2 -fill blue

#   Draw basic calage

    .tres.c1 create text 40 10 -text "Calage:" -tag texto -fill black -justify left


}
#   End of myAppWriteMain






proc myAppFileNew { } {
    global myAppFileName
    global g_DataChangedFlag
    if { $g_DataChangedFlag } {
        myAppPromptForSave
    }

    #-----------------------------------------------------------------
    # insert code for "new" operation
    #-----------------------------------------------------------------
    ### .t delete 1.0 end

    set myAppFileName ""
    set g_DataChangedFlag 0
 }

proc OpenLepFile { {FilePathName ""} } {
    # global myAppFileName
    global g_DataChangedFlag
    global g_DataFileTypes

    if { $g_DataChangedFlag } {
        myAppPromptForSave
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


        # if { [catch {open $filename r} fp] } {
        #     error "Cannot Open File $filename for Reading"
        # }

        #-------------------------------------------------------------
        # insert code for "open" operation
        #-------------------------------------------------------------
        ### .t insert end [read $fp [file size $filename]]

        # close $fp
        # set myAppFileName $filename
        set g_DataChangedFlag 0
    }
}

proc myAppFileClose { } {
    global myAppFileName
    global g_DataChangedFlag
    if { $g_DataChangedFlag } {
        myAppPromptForSave
    }

    #-----------------------------------------------------------------
    # insert code for "close" operation
    #-----------------------------------------------------------------
    ### .t delete 1.0 end

    set myAppFileName ""
    set g_DataChangedFlag 0
 }

 proc myAppFileSave { {filename ""} } {
    global myAppFileName
    global g_DataChangedFlag #BMA
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
         ### puts -nonewline $fp [.t get 1.0 end] #BMA

         close $fp
         set myAppFileName $filename
         set g_DataChangedFlag 0
    }
}

proc myAppFileSaveAs { } {
    global myAppFileTypes
    set filename [tk_getSaveFile -filetypes $myAppFileTypes]
    if { $filename != "" } {
        myAppFileSave $filename
    }
}

proc myAppPromptForSave { } {
    set answer [tk_messageBox -title "myApp:  Do you want to save?" \
        -type yesno -icon question \
        -message "Do you want to save the changes?"]
    if { $answer == "yes" } {
        myAppFileSaveAs
    }
}

proc myAppExit { } {
    myAppFileClose
    ::lepConfigFile::saveFile $::GlobalConfig
    exit
}


#----------------------------------------------------------------------
#   proc VersionInfo
#
#   Set version and license note
#----------------------------------------------------------------------
proc VersionInfo { } {
	global VersionNumber
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
    label .helplep.fr1.lb3 -text "LEparagliding 2.52 gui-$VersionNumber ($VersionDate)"
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
    toplevel .ncellsdis

    wm geometry .ncellsdis +400+300
    wm title .ncellsdis "Number of cells and distribution"
    focus .ncellsdis

    frame .ncellsdis.fr1 -width 400 -height 300 -bd 2
    pack .ncellsdis.fr1 -side top -padx 2m -pady 2m -ipadx 2c -ipady 2c

}

#----------------------------------------------------------------------
#   proc GeometryMatrixWindow
#
#   Prints geometry matrix for inspect and edit
#----------------------------------------------------------------------
proc GeometryMatrixWindow { } {

    source "lep_GlobalWingVars.tcl"

    myApp_lep_r

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
    while {$i <= $nribss} {
    $w.f2.text insert $i.0 $ribg($i)\n
    incr i }

    button $w.ok -text " OK " -command {destroy .text}
    pack $w.ok -padx 20 -pady 10

}


#----------------------------------------------------------------------
#   proc myAppLeadingEdge
#
#   Define an analytical leading edge
#----------------------------------------------------------------------
    source "p_le.tcl"
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#   proc myAppTrailingEdge
#
#   Define an analytical leading edge
#----------------------------------------------------------------------
#    source "p_te.tcl"
#----------------------------------------------------------------------

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
#  Help Operations
#---------------------------------------------------------------------

proc HelpAbout { } {
	global VersionNumber
    tk_messageBox -message "LE Paragliding GUI $VersionNumber"
}

#---------------------------------------------------------------------
#  Configuration operations
#---------------------------------------------------------------------

proc SetLanguage {Lang} {
    dict set ::GlobalConfig Language $Lang
    tk_messageBox -title [::msgcat::mc "lbl_LangChanged"] -message [::msgcat::mc "txt_PlsRestart"] -icon info -type ok -default ok
}

#---------------------------------------------------------------------
#  Execute the main procedure
#---------------------------------------------------------------------

myAppMain $argc $argv
