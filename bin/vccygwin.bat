@echo off

set PATH=%PATH%;c:\cygwin\bin;
set HOME=%HOMEDRIVE%%HOMEPATH%
set J9=%HOME%\j9

@rem echo %HOME%

pwd

ls -ld "%J9%"

"%J9%\j9vc7env.bat"

echo back again..

bash -b
