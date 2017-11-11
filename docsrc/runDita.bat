REM @echo off

REM Set "lepgRootDir=D:\Dokumente\computer\sw-entw\lepg"

Set CurrWorkDir=%~dp0


dita ^
--input=%CurrWorkDir%/lepg.ditamap ^
--output=%CurrWorkDir%/../doc ^
--format=html5 ^
--propertyfile=%CurrWorkDir%/properties/lepg-html.properties ^
--args.input.dir=%CurrWorkDir%