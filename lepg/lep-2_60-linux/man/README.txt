Especial thanks to Scott Roberts and Fluid Wings for supporting the new versions 2016 of the program

IMPROVEMENTS INTRODUCED IN 2.60 VERSION "Les Escaules" (2016-12-12)
---------------------------------------------------------------------

1) Corrected some problems using an even number of cells

When we define paragliders using an even number of cells, the central profile has a coordinate x = 0.0 along span, and program use internally a "virtual centrall cell" with a zero thickness. 

This can cause some numerical errors when calculating angles or divisions by zero. The result is usually an unreadable DXF file. Now, if the central profile located at x = 0.0, the program adds internally +0.01 cm (a tenth of a millimeter) and it seems that there are no numerical errors. [Section 4.2 in source code file .f].

2) Lines labels

The labels of the lines now automatically written on the schematic drawing in the form of tree. This prevents errors, and had to The labels of the lines now automatically written on the schematic drawing in the form of tree. This prevents errors, and had to draw them manually.draw them manually. :) 

3) Added more geometric parameters in lep-out.txt report



LEparagliding 2.52++ version "Utah" (2016-08-27)
------------------------------------------------

1) Added new option in V-ribs "type-3", at request from Yuri.

Diagonal rib type 3, indicated by 10 numbers.
Previously, the columns 9 and 10, were not used. And set to "0".
Now (in version 2.52++ and following), if the column 9 is set to "1", this means that the radius 
defined in columns 7 "r-" and 8 "r+" , are now defined in % of the chord of the profile, not in cm.

This allows definition of the diagonals widths automatically, and proportional to the profile chord.
Thus, it is achieved a perfect match in the widths of the contiguous diagonals and chord proportionality.

2) Internal fortran subroutine "vredis" (vector redistribution) improved, because in some cases 
(when used very small widths in V-ribs) were errors in the forms of V-ribs. Now fixed.

3) Version 2.52++ packs version 1.4 of the pre-processor.


LEparagliding 2.52 version "Utah" (2016-08-18)
----------------------------------------------

Added new option. Set automatic washin angles from center airfoil to wingtip.
At request from Yuri (Crimea).
How to use: Below line 21 in leparagliding.txt data file:

* Alpha max and parameter
3.5   2  -1.0

- First number "3.5" is the angle of attack (degres) in wingtip airfoil
- Second number "2" is a control parameter that means case "2", ie, add new number indicating the angle of attack of the central airfoil
- Third number "-1.0" is the angle of attack (degres) of the central airfoil

The distribution angles of attack is made proportional to the wing chord (similar to case "1"). See "lep-out.txt" to view the result.

LEparagliding 2.51 version "Utah" (2016-06-05)
----------------------------------------------
WARNING: Update 2.50 to 2.51 beacuse version 2.50 may done some errors in the lines list (!)


LEparagliding 2.50 version "Utah" (2016-05-09)
----------------------------------------------

- MIDDLE UNLOADED RIBS: Added the possibility of using "middle unloaded ribs". Very easy to use: In section "2. AIRFOILS" at the last column use the parameter "100", means to place a complete unloaded rib in the middle of the panel, and the left corresponding rib. Similarly, as defined in the mini-ribs. But the parameter "100" activates a new specific programation. New plan numbered "1-6" with the new middle ribs numbered and marked. These ribs have been reformatted to achieve a perfect match with high precision, with the corresponding panels. In the center of the panels, are marked equidistant points in correspondence with the middle unloaded ribs. In addition, in the 2D-planform (plan "1-1"), also drawn in gray new ribs. Planned to draw in 3D (for reference) but not yet done. Important: To define holes in the ribs (elliptical or circles), add in section "4. AIRFOIL HOLES" a new hole type "11" that is defined exactly as the type "1" (hole type "1" and type "11" are exactly the same but the type "11" used exclusively by the middle unloaded ribs). In this case the initial rib number and end rib number with holes type "11" should be the same, and greater than the maximum number of ribs on one side, for example, use "50" . See the attached example "leparagliding.txt". All new programation in section 9.9 of the source code.

- "Mini-ribs" are redefined, and now in section "2. AIRFOILS" at the last column, if you use the parameter "15", means to place a 15% mini-rib in the middle of the panel, and at the LEFT of the corresponding rib. Previously, mini-rib it was placed on the RIGHT. But it is better set at the left, so you can specify a minirib the center of the wing (Mini-rib specified in the left first rib). And this is consistent with the new middle unloaded ribs.

- Applied little optional displacement (to the center of the wing) in the points marking the position of the miniribs. Third parameter in the line of section "7. MARKS" of the datafile. Before, this displacement was set to default to zero. 

- All 2D-plans renamed whit the notation "i-j" that means row "i" and column "j".

- (!) CRITICAL ERROR found :( and solved :) when using V-ribs "Type 3" and wing scale different from 1.0. Solved. Caution! because V-ribs "Type 3", defined in earlier versions may be incorrect.

- A strange line, which appeared in the wingtip rib if zero thickness airfoil and wing type "pc" erased! :)

- Please, see and test attached 2.50 example.




LEparagliding 2.49 version "Utah" (2016-04-24)
----------------------------------------------

- V-rib type 6 is fully functional. Type 6 is a general diagonal. It's very simple. A trapezoidal diagonal ranging from rib number i to rib number i+1. But the rib is totally configurable in size and position. It has been designed to develop competition paragliders CCC types, which need to jump between 4 and 5 cells without lines. But it can also serve to design simplest paragliders, and replacing some of the types of diagonals described above. It is also very useful to define transverse horizontal strips located in all parts of the wing (the tapes have not necessarily coincide  with the anchor points).

- In final report lep-out.txt, area and span, calculated also in ft2 and ft

- Improved location of decimal numbering of all V-ribs types.

- Read section 10 of the manual: (...) "i11" indicates rib number "i", where anchor the top line of the brakes. This number, usually an integer. Nevertheless, some versions ago was added an interesting and not documented feature. Is possible define a decimal which means the displacement of the anchoring point between the rib "i" and the rib and "i+1". For example, 8.4 means anchor the line in the trailing edge, between rib 8 and 9, and 40% from the rib 8. This effect is now visible in 2D and 3D


LEparagliding 2.48 version "Utah" (2016-04-17)
----------------------------------------------

- Internal Fortran code now using DOUBLE PRECISION real variables (real*8), double precision trigonometric functions: dcos, dsin, dtan,datan, dasin, dacos,...
- High accuracy implemented in extrados and intrados panels, including reformatting whith corrections in lenghts and distorsions (full report in the last section of lep-out.txt). 
- Lengths differences between ribs and panels < 0.02 mm, and distorsions in leading edge < 0.1 mm :) )
- Closed cells new graphical representation in 2D and 3D, using grey line
- New version of pre-procesor (1.3) allows define wings using odd or even number of cells


LEparagliding 2.47 version "Utah" (2016-03-28)
----------------------------------------------

- High accuracy: In last row of the section 5. SKIN TENSION, of the main data file leparagliding.txt, now is possible set the following parameters to achieve high accuracy: 
1000   1.0  
First number "1000" (integer) is only a convention than signifies force the program to use maximal precision, reformating panels to achieve accuraccy better than 0.1 mm (lengths differences beetween rib and panels at lesft and right).
Second number is a coefficient (real) between 0.0 and 1.0 that sets the intensity of the correction. If coefficient is set to "0.0" then is no correction. If the coefficient is set to "1.0" the accuracy is maximal, aprox < 0.1 mm.
In version 2.47 maximal accuracy still not implemented in intrados panels, but very easy to implement.

- If first parameter is set to integer < 1000 (tipically 15 or 20) then program uses the old "anticorrection" method, for reformatting inner side of the right side of extrados panels. It is not recommended (old feauture). But now is possible use xndif=0.0 (not correction).

- Leading edge shape of the last panels is improved (fixed an error in the calculation of angles). Now it is not necessari to correct manually! :)

- Calculus of center of gravity planform, cdgx, is corrected (code error), thanks to Larry (WY), for detect it reading the code.

- Resolved graphical inconsistencies when drawing open or closed cells found in 2D drawings, and in 3D model, found by Larry (WY), and now solved

- WARNING: In this version, is changed the meaning and interpretation of the boolean coefficients ("0" and "1"), used to define open or closed cells (in .txt data file SECTION 2, fifth column). In versions prior to 2.46 "1" means open cell next to the rib "i" and towards the wing tip. A the 2.46 version, open cell "1" or closed "0" are defined toward the center of the wing. It is very easy and practical to do a test, and see the result. This change allows to define the central cell and resolves some inconsistencies in the previous definition.

- Output file "lep-out.txt" improved with more clear and detailed information

- Brake lines moved to plan number 19, next the lines list.

- Lines "B" changed color from "yellow" (2) to "orange" (30), better for print

- Internal code: cleaned up some unused variables

- New GNU/Linux versions compiled using fort77 in Debian 8.3 "Jessie"

- Window versions compiled in 32-bit system, is verified that also work in 64-bit

- Versions not stopped. Working hard in more improvements...


Improvements version 2.41 "Omsk" (2015-09-19):
------------------------------------------------

- Attachements points marks in intrados panels
- Increased number of ribs with color marks, from 20 to 100 (per side)
- Now possible draw color marks also in intrados panels
- Now is possible define and draw trailing edge "miniribs" ("minicabs") in non "ss" paragliders: Simpli define minirib length (in %) in column number 8 of section "2. AIRFOILS". If column 8 values are "0" or "1", miniribs are not draw and these values used only in "ss" paragliders, according manual.

Improvements version 2.40 (2015-09-04) over version 2.35

- Equilibrium grafic calculus, now is OK (bug fixed, thanks to Yuri!)
- Equidistance beetwen points in rib intrados now OK (bug fixed, thnaks to Scott)
- V-ribs "type 3" now possible
- V-ribs "type 5" new type "full continous diagonal rib" includes parabolic and elliptical holes (very especial thanks to Scott for supporting leparagliding developement)
- In lep-out.txt output file added summary of ribs and panel lenghts differences

Preprocessor 1.2 version "Gurzuf"

- More info written in the output file (area, span)
