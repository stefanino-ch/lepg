#---------------------------------------------------------------------
#
#  Subroutine to do some calculus: surface, span, aspect ratio
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

proc wingSomeCalculus {} {

    source "globalPreProcVars.tcl"

    global numRibsHalf
    global ribConfig
    global wingSurface
    global wingSpan
    global wingAR
    global wingScale

#-------------
# Wing area (m2)

    set wingSurface 0.0
    set wingSurface_cc 0.0
    set i 2
    while { $i <= $numRibsHalf } {

    set B1 [expr ($ribConfig($i,4) - $ribConfig($i,3))]
    set B2 [expr ($ribConfig([expr ($i - 1)],4) - $ribConfig([expr ($i - 1)],3))]
    set B3 [expr ($B1 + $B2)*0.5]
    set A0 [expr ($ribConfig($i,2) - $ribConfig([expr ($i - 1)],2))]
    set wingSurface [expr ($wingSurface + $A0*$B3)]

    incr i

#    puts "$i $B3 $A0"
    }

    set wingSurface_cc [expr ($ribConfig(1,2)*($ribConfig(1,4) - $ribConfig(1,3)))]
    set wingSurface [expr (2.*( $wingSurface + $wingSurface_cc )/10000.)]
    set wingSurface [expr $wingSurface*$wingScale*$wingScale]
    set wingSurface [format %0.2f $wingSurface]

#    puts "Area $wingSurface m2"

#-------------
# Wing span (m)
    set wingSpan [expr ((2.*$ribConfig($numRibsHalf,2))/100.)*$wingScale]
    set wingSpan [format %0.2f $wingSpan]

#    puts "Span $wingSpan m"

#-------------
# Wing aspect ration
    set wingAR [expr ($wingSpan*$wingSpan/$wingSurface)]
    set wingAR [format %0.2f $wingAR]

#    puts "Aspect ratio $wingAR"

}

