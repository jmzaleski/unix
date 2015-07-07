#!/bin/bash
#set up cygwin to run J9 DOS nmake build files.
#works on windows only.

if test -z "$HOMEDRIVE"
then
	echo HOMEDRIVE not set. Are you really on DOS?
	exit 2
fi

J9="$HOMEDRIVE$HOMEPATH\j9"

#windoze build environment for j9 JVM
VCINSTALLDIR="/cygdrive/c/Program Files/Microsoft Visual Studio .NET 2003"
MSVCDir=$VCINSTALLDIR/VC7

#
#run the script that comes with studio .NET to set up VC7 standalone..
#

"$VCINSTALLDIR/Common7/Tools/vsvars32.bat"

#stuff added to path is for bash to use. Hence use bash syntax
#come to think of it, nmake will actually use the same path, so bash
#will have to do something funky yet..
# Perhaps could simply use DOS syntax here.

VC7_ADDPATH="$VCINSTALLDIR/Common7/IDE:\
$MSVCDir/BIN:\
$VCINSTALLDIR/Common7/Tools:\
$VCINSTALLDIR/Common7/Tools/prerelease:\
$VCINSTALLDIR/Common7/Tools/bin:\
$VCINSTALLDIR/SDK/v1.1/bin:\
C:\WINDOWS\Microsoft.NET\Framework\v1.1.4322:"


PATH="$VC7_ADDPATH:$PATH"

VCINSTALLDIR="c:\Program Files\Microsoft Visual Studio .NET 2003"
MSVCDir="$VCINSTALLDIR\VC7"

#
#too hard to add include paths into makefiles, or perhaps this is standard
#build procedure for microsoft tools. INCLUDE path set externally.
#
ADD_INCLUDE="\
$MSVCDir\ATLMFC\INCLUDE\;\
$MSVCDir\INCLUDE\;\
$MSVCDir\PlatformSDK\include\;\
$J9\98ddk\inc\win98;\
"

INCLUDE="$ADD_INCLUDE;$INCLUDE;"

####skip$$%FrameworkSDKDir%/include;%INCLUDE%

#
#LIBS too, set externally from Makefile. This I hate.
#this must be in environment or linker won't find libs build needs.
#
ADD_LIBS="\
$MSVCDir\ATLMFC\LIB;\
$MSVCDir\LIB;\
$MSVCDir\PlatformSDK\lib\prerelease;\
$MSVCDir\PlatformSDK\lib\
"

#$VCINSTALLDIR\SDK\v1.1\Lib\

LIB="$ADD_LIBS;$LIB;"

###skip##%FrameworkSDKDir%\lib;%LIB%

