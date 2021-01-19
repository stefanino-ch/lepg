#---------------------------------------------------------------------
#
#  Initializes all Wing variables not yet set when increasing cells numbers
#  in an intelligent form, facilitating the work to the user
#  Used when importing new geometries, or changing number of cells
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

#----------------------------------------------------------------------
#  InitializeOtherWingVars
#  Initializes all Wing variables not yet set when increasing cells numbers
#  Tryes to set the "better values"...
#  From rib numRibsHalfPrev to numRibsHalfNew
#  Excepted main geometry
#
#  IN:  n/a
#  OUT: n/a
#----------------------------------------------------------------------

proc InitializeNVNC {} {

    source "globalWingVars.tcl"


    # Section 2
    # Set new values for airfoils
        # select index for medium rib
        set i_tipic [expr int($numRibsHalfPrev * 0.5)] 
        # set tipic airfoil
        set tipicAirfoil $airfoilName($i_tipic)

        set i $numRibsHalfPrev
        while { $i <= $numRibsHalfNew } {
        # set airfoil number 
        set ribConfig($i,1) $i
        # set airfoil names
        set airfoilName($i) $tipicAirfoil
        # other parameters
        foreach k { 11 12 14 50 55 56 } {
        set ribConfig($i,$k) $ribConfig([expr ($numRibsHalfPrev - 1)],$k)
        }
        incr i
        }
        # set last airfoil name
        set airfoilName($numRibsHalfNew) $airfoilName($numRibsHalfPrev)
#        puts $airfoilName($numRibsHalfNew)

    # Section 3
    # Set new values for anchor points
        # select index for medium rib
        set i_tipic [expr int($numRibsHalfPrev * 0.5)] 
        # set values
        set i [expr $numRibsHalfPrev]
        while { $i <= $numRibsHalfNew } {
        # set ribs numbers
        set ribConfig($i,1) $i
        foreach k { 15 16 17 18 19 20 21 } {
        set ribConfig($i,$k) $ribConfig($i_tipic,$k)
        }
        incr i
        }

        # set last line
        foreach k { 15 16 17 18 19 20 21 } {
        set ribConfig($numRibsHalfNew,$k) $ribConfig($numRibsHalfPrev,$k)
        }

    # Section 26
    # Set new values for glue vents
        # set values open all vents
        set i $numRibsHalfPrev
        while { $i <= $numRibsHalfNew } {
        set glueVenA($i) $i
        set glueVenB($i) 0
        incr i
        }
        # close last cell
        set glueVenA($numRibsHalfNew) $numRibsHalfNew
        set glueVenB($numRibsHalfNew) -1

    # Section 30
    # Set new values for airfoil thickness
        # set normal values to 1
        set i $numRibsHalfPrev
        while { $i <= $numRibsHalfNew } {
        set airThickA($i) $i
        set airThickB($i) 1.0
        incr i
        }
        # set last rib to 0
        set airThickA($numRibsHalfNew) $numRibsHalfNew
        set airThickB($numRibsHalfNew) 0.0


#   NOTES:
#   Do the same for decrements in cells numbers, but not stricly necessary
#   Review other sections for better numbers coherence!!!!

}

