ECHO OFF

REM Stefan Feuz
REM Pere Casellas
REM http://www.laboratoridenvol.com
REM General Public License GNU GPL 3.0

REM .bat file to execute the preprocessor
REM %0 is the program name as it was called,
REM %1 is the first command line parameter => full path and name of the preprocessor to be startet

REM cd into the working directory, where is the airfoil files, leparagliding.txt and exectable.
cd %~dp1

REM execute the pre processor full path and name is passed as the first command line parameter
%1
