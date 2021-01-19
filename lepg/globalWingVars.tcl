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
                        wingSurface wingSurface_p wingSpan wingSpan_p wingAR wingAR_p \
                        numCells numRibsTot numRibsHalf alphaMax \
                        numRibsHalfPrev \
                        numRibsGeo \
                        washinMode alphaCenter paraType rotLeTriang \
                        airfConfigNum  \
                         strainMiniRibs numStrainPoints \
                        strainCoef seamUp seamUpLe seamUpTe seamLo seamLoLe \
                        seamLoTe seamRib seamVRib markSpace markRad markDisp \
                        finesse posCop calage riserLength lineLength distTowP \
                        lineMode numLinePlan brakeLength \
                          numMiniRibs miniRibXSep miniRibYSep \
                         numTeCol    \
                         numLeCol \
                        numAddRipPo numDXFLayNa loadTot \
                        numMarksTy \
                        k_section23 numGroupsTR \
                        k_section24 numGe2Dop \
                        k_section25 numGe3Dop numG3Dopm \
                        k_section26 \
                        k_section27 numSpecWt \
                        k_section28 numCalagVar numRisersC \
                        k_section29 k_section29b \
                        k_section30 \
                        k_section31 numGroupsNS \
                        k_section21 numGroupsJDdb \
                        k_section22 numGroupsMY 
                        }

# Variables mogudes:
#                        dxf2DopA dxf2DopB dxf2DopC \
#                        dxf3DopA dxf3DopB dxf3DopC dxf3DopD \
# glueVenA glueVenB \
# calagVarA calagVarB calagVarC calagVarD calagVarE calagVarF \
#                         speedVarA speedVarB speedVarC speedVarD \
# numGroups3DS num3DS line3DSu line3DSl line3DSpp \
# airThickA airThickB \
# numNewSkin lineNeSk \
# numGroupsJD numDataBlocJD \
#                         numJoncsDef lineJoncsDef1 lineJoncsDef2 \
# numNoseMy lineNoseMy 
# numTabReinf lineTabReinf schemesTR \
# specWtA specWtB \







# Complex wing variables to handle differently
#                       airfoilName holeRibNum1 holeRibNum2 numHoles numLinePath
#                       brake ribGeomLine ramLength
#                       miniRib ribConfig teColRibNum numTeColMarks teColMarkNum
#                       teColMarkYDist teColMarkXDist  leColRibNum
#                       numleColMarks leColMarkNum leColMarkYDist leColMarkXDist
#                       addRipPoX addRipPoY holeConfig skinTens brakeDistr

#   old names       new name            old name
global              brandName           # bname
global              wingName            # wname
global              drawScale           # xkf
global              wingScale           # xwf

global              wingSurface
global              wingSurface_p 
global              wingSpan 
global              wingSpan_p 
global              wingAR 
global              wingAR_p

global              numCells            # ncells
global              numRibsTot          # nribst
global              numRibsHalf         # nribss
global              numRibsHalfPrev
global              numRibsHalfNew
global              numRibsGeo
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
                    # detailed description of the line path

global              brakeLength         # clengb
                    # Lenth of brake lines
global              numBrakeLinePath
                    # Number of brake paths
global              brakeLinePath
                    # detailed description of the brake line path
global              brakeDistr          # bd
                    # brake distribution

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
global              numLeColMarks       # npc2i
global              leColMarkNum        # npc3i
global              leColMarkYDist      # xpc1i
global              leColMarkXDist      # xpc2i

global              numAddRipPo         # narp
global              addRipPoX           # xarp
global              addRipPoY           # yarp

global              loadTot             # csusl
global              loadDistr           # cdis
global              loadDeform

# Section 19
global              numDXFLayNa         # ndxfln
global              dxfLayNaX           # xdxfln
global              dxfLayNaY           # ydxfln

# Section 20
global              numMarksTy
global              marksType0          # typm0
global              marksType1
global              marksType2
global              marksType3
global              marksType4
global              marksType5
global              marksType6

# Section 21
global              k_section21
global              numGroupsJDdb
global              numGroupsJD
global              numDataBlocJD
global              numJoncsDef
global              lineJoncsDef1
global              lineJoncsDef2

# Section 22
global              k_section22
global              numGroupsMY 
global              numNoseMy
global              lineNoseMy

# Section 23
global              k_section23
global              numGroupsTR 
global              numTabReinf
global              lineTabReinf
global              schemesTR

# Section 24
global              k_section24
global              numGe2Dop
global              dxf2DopA
global              dxf2DopB
global              dxf2DopC

# Section 25
global              k_section25
global              numGe3Dop
global              numGe3Dopm
global              dxf3DopA
global              dxf3DopB
global              dxf3DopC
global              dxf3DopD

# Section 26
global              k_section26
global              glueVenA
global              glueVenB

# Section 27
global              k_section27
global              numSpecWt
global              specWtA
global              specWtB

# Section 28
global	            k_section28 
global	            numCalagVar 
global              numRisersC
global              calagVarA
global	            calagVarB
global	            calagVarC
global	            calagVarD
global	            calagVarE
global	            calagVarF
global	            speedVarA
global	            speedVarB
global	            speedVarC
global	            speedVarD

# Section 29
global              k_section29
global              k_section29b
global              numGroups3DS
global              num3DS
global              line3DSu
global              line3DSl
global              line3DSpp

# Section 30
global              k_section30
global              airThickA
global              airThickB

# Section 31
global              k_section31 
global              numGroupsNS 
global              numNewSkin 
global              lineNeSk

# Section1
global              numRibsGeo

#--------------------------------------------------------
# Init global wing values
#--------------------------------------------------------
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

    set dxfLayNaX(0) 0
    set dxfLayNaY(0) 0

# Section 20
    set marksType0(0) 0
    set marksType1(0) 0
    set marksType2(0) 0
    set marksType3(0) 0
    set marksType4(0) 0
    set marksType5(0) 0
    set marksType6(0) 0

# Section 21
    set k_section21 0
    set numGroupsJDdb 0
    set numGroupsJD(0) 0
    set numDataBlocJD(0,0) 0
    set numJoncsDef(0,0,0) 0
    set lineJoncsDef1(0,0,0,0) 0
    set lineJoncsDef2(0,0,0,0) 0

# Section 22
    set k_section22 0
    set numGroupsMY 0
    set numNoseMy(0,0) 0
    set lineNoseMy(0,0) 0

# Section 23
    set k_section23 0
    set numGroupsTR 0
    set numTabReinf(0,0) 0
    set lineTabReinf(0,0) 0
    set schemesTR(0,0) 0

# Section 24
    set k_section24 0
    set numGe2Dop 6
    foreach i {1 2 3 4 5 6} {
    set dxf2DopA($i) 0
    set dxf2DopB($i) 0
    set dxf2DopC($i) 0
    }

# Section 25
    set k_section25 0
    set numGe3Dop 6
    set numGe3Dopm 3
    set dxf3DopA(0) 0
    set dxf3DopB(0) 0
    set dxf3DopC(0) 0
    set dxf3DopD(0) 0

# Section 26
    set k_section26 0
    set glueVenA(0) 0
    set glueVenB(0) 0

# Section 27
    set k_section27 0
    set numSpecWt 0
    set specWtA(0) 0
    set specWtB(0) 0

# Section 29
    set k_section29 0
    set k_section29b 0
    set numGroups3DS(0) 0
    set num3DS(0,0) 0
    set line3DSu(0,0,0) 0
    set line3DSl(0,0,0) 0
    set line3DSpp(0,0) 0

# Section 28
    set k_section28 0
    set numCalagVar 0
    set numRisersC 0
    set calagVarA(0) 0
    set calagVarB(0) 0
    set calagVarC(0) 0
    set calagVarD(0) 0
    set calagVarE(0) 0
    set calagVarF(0) 0
    set speedVarA(0) 0
    set speedVarB(0) 0
    set speedVarC(0) 0
    set speedVarD(0) 0

# Section 30
    set k_section30 0
    set airThickA(0) 0
    set airThickB(0) 0

# Section 31
    set k_section31 0
    set numGroupsNS 0
    set numNewSkin(0,0) 0
    set lineNeSk(0,0,0) 0

# Section 1
    set numRibsGeo 0
    set numCells 0

# Classic skinTens
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
