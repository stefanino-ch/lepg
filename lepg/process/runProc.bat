ECHO OFF

REM Stefan Feuz
REM http://www.laboratoridenvol.com
REM General Public License GNU GPL 3.0

REM .bat file to execute the preprocessor
REM %0 is the program name as it was called,
REM %1 is the first command line parameter => full path and name of the preprocessor to be startet

REM cd into the current directory, there where the .bat file is saved
cd %~dp0

REM execute the pre processor full path and name is passed as the first command line parameter
%1
