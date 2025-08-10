echo off
setlocal
set root=%cd%
set srcd=%root%\src
set intd=%root%\build\int
set outd=%root%\build\bin

set in=-I inc
set cc=-c -Wmain -Wimplicit -Wparentheses -Wmissing-braces -Wformat -Wcomment       ^
          -Wchar-subscripts -Wsequence-point -Wreturn-type -Wunused -Wuninitialized ^
          -fPIC --std=c99
set ld=

if ["%1"]==["debug"] (
  goto :debug
)

if ["%1"]==["release"] (
  goto :release
)

goto :ship

:debug
  set intd=%intd%\debug
  set cc=%cc% -pg -gdwarf -fno-pie -O0
  set ld=%ld% -pg
  goto :build
:release
  set intd=%intd%\release
  set cc=%cc% -pg -gdwarf -fno-pie -O2
  set ld=%ld% -pg
  goto :build
:ship
  set intd=%intd%\ship
  set cc=%cc% -fno-pie -O2
  set ld=%ld%

:build
if not exist %outd% (
  mkdir %outd%
)

if not exist %intd% (
  mkdir %intd%
)

call gcc.exe %cc% %in% %srcd%\parson.c ^
                    -o %intd%\parson.o

call gcc.exe %ld% -o %outd%\json.dll %intd%\* ^
             -s -shared -Wl,--out-implib,%outd%\json.lib