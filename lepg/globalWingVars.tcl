#---------------------------------------------------------------------
#
#  Global Wing variables used across lep and lepg including explanations
#
#  Pere Casellas
#  Stefan Feuz
#  http://www.laboratoridenvol.com
#
#  General Public License GNU GPL 3.0
#
#---------------------------------------------------------------------

global SingleWingVariables
set SingleWingVariables { brandName wingName drawScale wingScale \
                        numCells numRibsTot numRibsHalf alphaMax \
                        washinMode alphaCenter paraType rotLeTriang \
                        airfConfigNum  \
                         strainMiniRibs numStrainPoints \
                        strainCoef seamUp seamUpLe seamUpTe seamLo seamLoLe \
                        seamLoTe seamRib seamVRib markSpace markRad markDisp \
                        finesse posCop calage riserLength lineLength distTowP \
                        lineMode numLinePlan brakeLength brakeDistr \
                          numMiniRibs miniRibXSep miniRibYSep \
                         numTeCol    \
                         numLeCol \
                        numAddRipPo  loadTot
                    }

# Complex wing variables to handle differently
#                       airfoilName holeRibNum1 holeRibNum2 numHoles numLinePath
#                       brake ribGeomLine ramLength
#                       miniRib ribConfig teColRibNum numTeColMarks teColMarkNum
#                       teColMarkYDist teColMarkXDist  leColRibNum
#                       numleColMarks leColMarkNum leColMarkYDist leColMarkXDist
#                       addRipPoX addRipPoY holeConfig skinTens

#   old names       new name            old name
global              brandName           # bname
global              wingName            # wname
global              drawScale           # xkf
global              wingScale           # xwf
global              numCells            # ncells
global              numRibsTot          # nribst
global              numRibsHalf         # nribss
global              alphaMax            # alpham
global              washinMode          # kbbb
                    # 0: the washin will be done manually
                    # 1: then washin will be done proportinal to the chord,
                    #    being maximun and positive at the tip, using only the first real of the line
                    # 2: automatic washin angles are set from center airfoil to wingtip.
                    #    The first real is the washin in wingtip, then set "2", and the last real
                    #    is the washin in the central airfoil
global              alphaCenter         # alphac
global              paraType            # atp
global              rotLeTriang         #
                    # Rotate Leading Edge triangle
global              ribGeomLine         # ribg
                    # Rib Geometry Line
global              ribConfig           # rib
                    # Rib Num Param Desc
                    #     n   1     Rib number
                    #     n   2     rib X coordinate
                    #     n   3     Y coordinate of the leading edge
                    #     n   4     Y coordinate of the trailing edge
                    #     n   6     X' coordinate of the rib in its final position in space
                    #     n   7     Z coordinate of the rib in its final position in space
                    #     n   9     the angle "beta" of the rib to the vertical (degres)
                    #     n   10    RP percentage of chord to be held on the relative torsion of the airfoils
# What does "RP" mean?
                    #     n   11    Percentage of chord start of the air inlet
                    #     n   12    Percentage of chord end of the air  inlet
                    #     n   14    Value 1 or 0 to create closed cells, at the left of rib ("0" indicates closed-cell, "1" open)
                    #     n   15    Number of anchors in the rib
                    #     n   16    Anchor position A as% of rib
                    #     n   17    Anchor position B as% of rib
                    #     n   18    Anchor position C as% of rib
                    #     n   19    Anchor position D as% of rib
                    #     n   20    Anchor position E as% of rib
                    #     n   21    Anchor position F as% of rib-> brake lines
                    #     n   50    Displacement in cm of the rib perpendicular to the chord, and in the plane of the rib itself
                    #     n   51    washin in degrees defined manually (if parameter is set to "0")
                    #     n   55    Relative weight of the chord, in relation to the load. Value is usually 1
                    #     n   56    "0" or "1", only used in single skin paragliders
                    #               "0" means that the triangles are not rotated, but they are set according to the angle "beta" specified in Section 1
                    #               Real value "1" (or "1.") means that the triangles are rotated automatically in the corresponding profile.
                    #               Greater than 1.0 is posRibGeomle define and draw trailing edge "miniribs" ("minicabs") in non "ss" paragliders:
                    #               The value, simply define the minirib length (in %).
                    #               "100" activates a new specific programation. Middle unloaded ribs. New plan numbered "1-6"
global              airfoilName         # nomair
global              airfConfigNum       # ndis
global              holeConfig          # hol
                    #    InitialRib  HoleNum     ParamValue  Desc
                    #       n           x           9           Hole type
                    #                                           1: Ellipse
                    #                                           2: ellipse or circle with central strip
                    #                                           3: triangle
                    #       n           x           2           T1: Distance from LE to hole center in% chord
                    #                                           T2: Distance from LE to hole center in% chord
                    #                                           T3: Distance from LE to triangle in% chord
                    #       n           x           3           T1: Distance from the center of hole to the chord line in% of chord
                    #                                           T2: Distance from the center of hole to the chord line in% of chord
                    #                                           T3: Distance from the center of the triangle corner to the chord line in% of chord
                    #       n           x           4           T1: Horizontal axis of the ellipse as% of chord
                    #                                           T2: Horizontal axis of the ellipse as% of chord
                    #                                           T3: Traingle base as% of chord
                    #       n           x           5           T1: Ellipse vertical axis as% of chord
                    #                                           T2: Ellipse vertical axis as% of chord
                    #                                           T3: Triangle heigth as% of chord
                    #       n           x           6           T1: Rotation angle of the ellipse
                    #                                           T2: Rotation angle of the ellipse
                    #                                           T3: Rotation angle of the base
                    #       n           x           7           T1: 0. (not used)
                    #                                           T2: central strip width
                    #                                           T3: Radius of the smoothed corners
                    #       n           x           8           T1: 0. (not used)
                    #                                           T2: 0. (not used)
                    #                                           T3: 0. (not used)
                    # The 9th value on each config line is not read and saved, for all hole configuration it is not used
global              holeRibNum1         # nrib1
global              holeRibNum2         # nrib2
global              numHoles            # nhols
global              skinTens            # skin
                    #    ConfigLine     ParamNum    Desc
                    #    1...6          1           Distance in% of chord on the leading edge of extrados
                    #                   2           Extrados over-wide corresponding in % of chord
                    #                   3           Distance in% of chord on trailing edge
                    #                   4           Intrados over-wide corresponding in% of chord
global              strainMiniRibs      # htens
                    # 0.0114
global              numStrainPoints     # ndif
global              strainCoef          # xndif
                    # Coeficient 0.0 to 1.0
                    # Strain: dt Belastung
global              seamUp              # xupp
global              seamUpLe            # xupple
global              seamUpTe            # xuppte
global              seamLo              # xlow
global              seamLoLe            # xlowle
global              seamLoTe            # xlowte
global              seamRib             # xrib
global              seamVRib            # xvrib
global              markSpace           # xmark
global              markRad             # xcir
global              markDisp            # xdes
global              finesse             # finesse
                    # Finesse goal, according to the general proportions of the wing
global              posCop              # cpress
                    # Position of the wing center of pressure estimated as % of central cord
global              calage              # calage
                    # Calage in% (distance from the leading edge point to the perpendicular to the central chord from the pilot position)
global              riserLength         # clengr
                    # Riser basic length in cm
global              lineLength          # clengl
                    # Basic length of lines (maillons - sail) in cm
global              distTowP            # clengk
                    # Separation between main carabiners in cm
global              lineMode            # zcontrol
                    # 0 = lower branches lined only by geometric mean of the anchor points
                    # 1 = lower branches lined by weighting type 1 (not fully implemented yet)
                    # 2 = lower branches lined by weighting type 2 (not fully implemented yet)
global              numLinePlan         # slp
                    # Number of line plans
global              numLinePath         # cam
                    # Paths number for plan
global              linePath            # mc
        # really used somewhere?
global              brakeLength         # clengb
global              brakeDistr          # bd
        # really used somewhere?
global              brake               # brake
global              ramLength           # raml
global              numMiniRibs         # nhvr
global              miniRibXSep         # xrsep
global              miniRibYSep         # yrsep
global              miniRib             # hvr

global              numTeCol            # npce
                    # number of ribs with marks
global              teColRibNum         # npc1e
global              numTeColMarks       # npc2e
global              teColMarkNum        # npc3e
global              teColMarkYDist      # xpc1e
global              teColMarkXDist      # xpc2e

global              numLeCol            # npci
global              leColRibNum         # npc1i
global              numleColMarks       # npc2i
global              leColMarkNum        # npc3i
global              leColMarkYDist      # xpc1i
global              leColMarkXDist      # xpc2i

global              numAddRipPo         # narp
global              addRipPoX           # xarp
global              addRipPoY           # yarp

global              loadTot             # csusl
global              loadDistr           # cdis
global              loadDeform

proc initGlobalWingVars {} {

    global g_GlobLepDataAvailable
    set g_GlobLepDataAvailable 0

    global g_GlobLepDataChanged
    set g_GlobLepDataChanged 0

    global SingleWingVariables

    foreach {e} $SingleWingVariables {
        global $e
        set $e ""
    }

    set airfoilName(0) 0

    set i 1
    while {$i <= 9} {
        set ribGeomLine($i) 0
        incr i
    }

    set holeRibNum1(0) 0
    set holeRibNum2(0) 0
    set numHoles(0) 0

    global ribConfig
    foreach i {1 2 3 4 6 7 9 10 11 12 14 15 16 17 18 19 20 21 50 51 55 56} {
      # RibGeom
      set ribconfig(0,$i) 0
    }

    global holeConfig
    set holeConfig(0,0) 0

    set numLinePath(0) 0

    set brake(0,3) 0

    set ramLength(0,0) 0

    set miniRib(0,0) 0

    set numTeColMarks(0) 0
    set teColRibNum(0) 0
    set teColMarkNum(0,0,) 0
    set teColMarkYDist(0,0,) 0
    set teColMarkXDist(0,0,) 0

    set numLeColMarks(0) 0
    set leColRibNum(0) 0
    set leColMarkNum(0,0,) 0
    set leColMarkYDist(0,0,) 0
    set leColMarkXDist(0,0,) 0

    set addRipPoX(0) 0
    set addRipPoY(0) 0

    global skinTens
    set i 1
    while {$i <= 6} {
        foreach j {1 2 3 4} {
            set skinTens($i,$j) 0
        }
        incr i
    }

    set loadDistr(0,0) 0
}
