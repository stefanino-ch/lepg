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

#   old names       new name
global bname        # brandName
global wname        # wingName
global xkf          # drawScale
global xwf          # wingScale
global ncells       # numCells
global nribst       # NumRibsTot
global nribss       # NumRibsHalf
global alpham       # alphaMax
global kbbb         # washinMode
                    # 0: the washin will be done manually
                    # 1: then washin will be done proportinal to the chord,
                    #    being maximun and positive at the tip, using only the first real of the line
                    # 2: automatic washin angles are set from center airfoil to wingtip.
                    #    The first real is the washin in wingtip, then set "2", and the last real
                    #    is the washin in the central airfoil
global alphac       # alphaCenter
global atp          # paraType
global kaaa         # rotLeTriang - Rotate Leading Edge triangle
global ribg         # ribGeomLine - Rib Geometry Line
global rib          # ribConfig
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
global nomair       # airfoilName
global ndis         # airfConfigNum
global hol          # holeConfig
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
global nrib1        # holeRibNum1
global nrib2        # holeRibNum2
global nhols        # numHoles
global skin         # skinTension
                    #    ConfigLine     ParamNum    Desc
                    #    1...6          1           Distance in% of chord on the leading edge of extrados
                    #                   2           Extrados over-wide corresponding in % of chord
                    #                   3           Distance in% of chord on trailing edge
                    #                   4           Intrados over-wide corresponding in% of chord
global htens        # strainMiniRibs    # 0.0114
global ndif         # numStrainPoints
global xndif        # strainCoef        # Coeficient 0.0 to 1.0
                                        # Strain: dt Belastung
global xupp         # seamUp
global xupple       # seamUpLe
global xuppte       # seamUpTe
global xlow         # seamLo
global xlowle       # seamLoLe
global xlowte       # seamLoTe
global xrib         # seamRib
global xvrib        # seamVRib
global xmark        # markSpace
global xcir         # markRad
global xdes         # markDisp
global finesse      # finesse           # Finesse goal, according to the general proportions of the wing
global cpress       # posCOP            # Position of the wing center of pressure estimated as % of central cord
global calage       # calage            # Calage in% (distance from the leading edge point to the perpendicular to the central chord from the pilot position)
global clengr       # riserLength       # Riser basic length in cm
global clengl       # lineLength        # Basic length of lines (maillons - sail) in cm
global clengk       # distTowP          # Separation between main carabiners in cm
global zcontrol     # lineMode          # 0 = lower branches lined only by geometric mean of the anchor points
                                        # 1 = lower branches lined by weighting type 1 (not fully implemented yet)
                                        # 2 = lower branches lined by weighting type 2 (not fully implemented yet)
global slp          # numLinePlan       # Number of line plans
global cam          # numLinePath       # Paths number for plan
global mc           # linePath
global clengb       # brakeLength
global bd           # brakeDistr
global brake        # brake
global raml         # ramLength
global nhvr         # numMiniRibs
global xrsep        # miniRibXSep
global yrsep        # miniRibYSep
global hvr          # miniRib

global npce         # numTeCol          # number of ribs with marks
global npc1e        # teColRibNum
global npc2e        # numTeColMarks     #
global npc3e        # teColMarkNum
global xpc1e        # teColMarkYDist
global xpc2e        # teColMarkXDist

global npci         # numLeCol
global npc1i        # leColRibNum
global npc2i        # numleColMarks     #
global npc3i        # leColMarkNum
global xpc1i        # leColMarkYDist
global xpc2i        # leColMarkXDist

global narp         # numAddRipPo
global xarp         # addRipPoX
global yarp         # addRipPoY

global csusl        # loadTot
global cdis         # loadDistr
# global missingName  # loadDeform

proc createGlobalWingVars {} {
puts "create global wing vars"
    source "lep_GlobalWingVars.tcl"
    set nribss ""
    set rib(0,0) ""
}
