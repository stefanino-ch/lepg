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

# set this to 1 if you want to see values read from file
global  EnableDebugPreProc
set     EnableDebugPreProc 0

global  g_PreProcDataAv
global  g_PreProcDataChanged

global  AllPreProcVars
set     AllPreProcVars {wingNamePreProc \
                        typeLE a1LE b1LE x1LE x2LE xmLE c01LE ex1LE c02LE ex2LE \
                        typeTE a1TE b1TE x1TE xmTE c0TE y0TE ex1TE \
                        vaultType a1Vault b1Vault x1Vault c1Vault radVault angVault \
                        cellDistrType cellDistrCoeff numCellsPreProc cellsOddEven \
                        numRibsHalfPre }

global SinglePreProcVariables
set SinglePreProcVariables {   wingNamePreProc \
                        typeLE a1LE b1LE x1LE x2LE xmLE c01LE ex1LE c02LE ex2LE \
                        typeTE a1TE b1TE x1TE xmTE c0TE y0TE ex1TE \
                        vaultType a1Vault b1Vault x1Vault c1Vault \
                        cellDistrType cellDistrCoeff numCellsPreProc cellsOddEven \
                        numRibsHalfPre }

#--------------
# Wing name
global              wingNamePreProc

#--------------
# Leading edge
global              typeLE
                    # integer
global              a1LE
                    # [cm]
global              b1LE
                    # [cm]
global              x1LE
                    # [cm]
global              x2LE
                    # [cm]
global              xmLE
                    # [cm]
global              c01LE
                    # [cm]
global              ex1LE
                    # [coeff]
global              c02LE
                    # [cm]
global              ex2LE
                    # [coeff]

#--------------
# Trailing edge
global              typeTE
                    # integer
global              a1TE
                    # [cm]
global              b1TE
                    # [cm]
global              x1TE
                    # [cm]
global              xmTE
                    # [cm]
global              c0TE
                    # [cm]
global              y0TE
                    # [cm]
global              ex1TE
                    # [coeff]

#--------------
# Vault edge
global vaultType
# "1": vault using ellipse and cosinus modification, indicate parameters a1, b1,
# "2": vault using four tangent circles. In four rows indicate radious and angle (deg).
# Type 1 params
global              a1Vault
                    # [cm]
global              b1Vault
                    # [cm]
global              x1Vault
                    # [cm]
global              c1Vault
                    # [cm]
# Type 2 params
global              radVault
                    # array 1..4 with vault radius
                    # cm
global              angVault
                    # array 1..4 with vault angle
                    # [ degree 0..360]

#--------------
# Cells distribution
global              cellDistrType
# "3": indicates cell width proportional to chord
# "4": use explicit width of each cell with automatic adjustement, if the sum not match the span

global              cellDistrCoeff
# Coefficient between "0.0" and "1.0". Use intermediate values as you need.
# "0":      cell width is estrictly proportional to the chord, using iterative calculus
# "1.0": then cell width is uniform

global              numCellsPreProc
# Total cell number
global              cellsWidth
# Cells width
global              cellsOddEven
# Num ribs half
global              numRibsHalfPre

#----------------------------------------------------------------------
#  proc initGlobalPreProcVars
#  Creates and intializes all globally used variables related to the preprocessor
#  IN:      n/a
#  OUT:     n/a
#----------------------------------------------------------------------
proc initGlobalPreProcVars {} {
    global g_PreProcDataAvailable
    set g_PreProcDataAvailable 0

    global g_PreProcDataChanged
    set g_PreProcDataChanged 0

    global SinglePreProcVariables

    foreach {e} $SinglePreProcVariables {
        global $e
        set $e ""
    }

    # lists
    global radVault
    global angVault

    foreach i { 1 2 3 4} {
        set radVault($i) ""
        set angVault($i) ""
    }

    # special init
    set vaultType 1
    set cellDistrType 3

    # cells width
    set cellsWidth(0,0) 30

    # numRibsHalfPre
    set numRibsHalfPre 1
}
