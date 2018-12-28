#---------------------------------------------------------------------
#
#  Writes the data file for the wing file
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

global Separator
set Separator "**********************************"

#----------------------------------------------------------------------
#  writeWingDataFile
#  Writes the Wing data file
#
# IN:   FilePathName    Full path and name of file
# OUT:  -1 : file not writeable
#        0 : all cool file read, data should be available
#----------------------------------------------------------------------
proc writeWingDataFile {FilePathName} {
    set ReturnValue -1

    if {[catch {set File [open $FilePathName w]}] == 0} {
        # puts "All cool file is open"
    } else {
        # puts "Could not open file."
        return -1
    }

    # File header
    lassign [WriteFileHeaderV2_6 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #---------
    # Geometry
    lassign [WriteGeometrySectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------
    # Airfoil
    lassign [WriteAirfoilSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }


    #--------------
    # Anchor points
    lassign [WriteAnchorsSectV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #--------------
    # Airfoil holes

    #-------------
    # Skin tension

    #------------------
    # Sewing allowances
    lassign [WriteSewingAllowancesV2_52 $File] ReturnValue File
    if {$ReturnValue < 0} {
        close $File
        return $ReturnValue
    }

    #------
    # Marks

    #-----------------------
    # Global angle of attack

    #-----------------
    # Suspension lines

    #-------
    # Brakes

    #---------------------
    # Ramification lengths

    #----------------
    # H V and VH ribs => miniRib

    #----------------------
    # Trailing edge  colors

    #--------------------
    # Leading edge colors

    #----------------------
    # Additional rib points

    #--------------------------
    # Elastig lines corrections

    #--------------------------
    # DXF

    flush $File
    close $File

    set ReturnValue 0
    return $ReturnValue
}




#----------------------------------------------------------------------
#  WriteFileHeader
#  Writes the initial file header
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteFileHeaderV2_6 {File} {
    source "lepFileConstants.tcl"
    global Separator

    puts $File $Separator
    puts $File "* LABORATORI D'ENVOL PARAGLIDING DESIGN"
    puts $File "* lep input data file        v2.6"
    puts $File $Separator
    puts $File "*"
    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteGeometrySectV2_52
#  Writes the Geometry section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteGeometrySectV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_GeometrySect_lFC_Lbl"
    puts $File $Separator

    puts $File "* Brand name"
    puts $File "\"$brandName\""

    puts $File "* Wing name"
    puts $File "\"$wingName\""

    puts $File "* Drawing scale"
    puts $File "$drawScale"

    puts $File "* Wing scale"
    puts $File "$wingScale"

    puts $File "* Number of cells"
    puts $File "\t$numCells"

    puts $File "* Number of ribs"
    puts $File "\t$numRibsTot"

    puts $File "* Alpha wingtip, parameter, (alpha center)"
    puts $File "\t$alphaMax     $washinMode     $alphaCenter"

    puts $File "* Paraglider type and parameter"
    puts $File "\"$paraType\" $rotLeTriang"

    puts $File "* Rib geometric parameters"
    puts $File "* Rib    x-rib       y-LE       y-TE         xp         z     beta      RP        Washin"
    # Write matrix of geometry
    set i 1
    while {$i <= $numRibsHalf} {

        puts -nonewline $File "$ribConfig($i,1)"
        puts -nonewline $File "     $ribConfig($i,2)"
        puts -nonewline $File "     $ribConfig($i,3)"
        puts -nonewline $File "     $ribConfig($i,4)"
        puts -nonewline $File "     $ribConfig($i,6)"
        puts -nonewline $File "     $ribConfig($i,7)"
        puts -nonewline $File "     $ribConfig($i,9)"
        puts -nonewline $File "     $ribConfig($i,10)"
        puts            $File "     $ribConfig($i,51)"
        incr i
    }


    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteAirfoilSectV2_52
#  Writes the Airfoils section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteAirfoilSectV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_AirfoilSect_lFC_Lbl"
    puts $File $Separator
    puts $File "* Airfoil name. intake in. intake out. open. disp   rweight"

    set i 1
    while {$i <= $numRibsHalf} {

        puts -nonewline $File "$ribConfig($i,1)"
        puts -nonewline $File "     $airfoilName($i)"
        puts -nonewline $File "     $ribConfig($i,11)"
        puts -nonewline $File "     $ribConfig($i,12)"
        puts -nonewline $File "     $ribConfig($i,14)"
        puts -nonewline $File "     $ribConfig($i,50)"
        puts -nonewline $File "     $ribConfig($i,55)"
        puts            $File "     $ribConfig($i,56)"

        incr i
    }


    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteAnchorsSectV2_52
#  Writes the Anchors section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteAnchorsSectV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_AnchorPoSect_lFC_Lbl"
    puts $File $Separator
    puts $File "* Airf	Anch	A	B	C	D	E	F"

    set i 1
    while {$i <= $numRibsHalf} {

        puts -nonewline $File "$ribConfig($i,1)"
        puts -nonewline $File "\t$ribConfig($i,15)"
        puts -nonewline $File "\t$ribConfig($i,16)"
        puts -nonewline $File "\t$ribConfig($i,17)"
        puts -nonewline $File "\t$ribConfig($i,18)"
        puts -nonewline $File "\t$ribConfig($i,19)"
        puts -nonewline $File "\t$ribConfig($i,20)"
        puts            $File "\t$ribConfig($i,21)"

        incr i
    }

    return [list 0 $File]
}

#----------------------------------------------------------------------
#  WriteSewingAllowancesV2_52
#  Writes the Sewing Allowances section in the V2.52 format
#
#  IN:  File            Pointer to the line to write
#  OUT:
#       ReturnValue1    0 : written
#                       -1: problem during write
#       ReturnValue2    Pointer to the next empty data line
#----------------------------------------------------------------------
proc WriteSewingAllowancesV2_52  {File} {
    source "lepFileConstants.tcl"
    source "globalWingVars.tcl"
    global Separator

    puts $File $Separator
    puts $File "* $c_SewingSect_lFC_Lbl"
    puts $File $Separator

    puts $File "$seamUp\t$seamUpLe\t$seamUpTe\tupper panels (mm)"

    puts $File "$seamLo\t$seamLoLe\t$seamLoTe\tlower panels (mm)"

    puts $File "$seamRib\tribs (mm)"

    puts $File "$seamVRib\tvribs (mm)"

    return [list 0 $File]
}
