
echo must first call c:\documents and settings\matz\j9\bin\trenv.bat

rem squirrel away a few tidbits.
set MYTR="c:\Documents and Settings\matz\tr"
set MYTRTOOLS=%MYTR%\bldtoolhacks

cd %TRHOME%

mkdir %J9_EXEC%
mkdir %TRBLD_DIR%
mkdir %TRTEST%

rem these just go to bldtools by CMVC magic so long as -top is given
File -extract textract.pl -top %TRHOME%
File -extract scriptUtils.pl -top %TRHOME%
File -extract makeConfig.pl  -top %TRHOME%

rem echo for the third menu "None" is the dependency thingy you want to select..
bldtools\makeConfig.pl

rem extract all the tools
bldtools\textract.pl -extract: tools

rem extract all the tests
bldtools\textract.pl -e: tests

rem get JIT sources
rem -e extract sources
rem -n NO BUILD 
rem -d debug
rem --j2se jit/vm to use j2se libs (jcl?)

%TRBLD_DIR%\trbuild.pl -en --j2se --ftp -U j9white -P j9wh1te

rem  run.pl tries to set a handler for HUP, which doesn't exist on DOS (line 20)
patch %TRTEST%\tools\run.pl %MYTRTOOLS%\patches\run.pl.patch

rem copy a driver into testing. Should figure out how to FTP this using perl Testarossa.pm
mkdir %TRTEST%driver
xcopy %MYTRTOOLS%\driver\* %TRTEST%driver

XOPT="-Xnoaot -Xjit:optLevel=warm,count=0"
FFSDXOPT="-Xnoaot -Xjit:optLevel=warm,count=0,fasterFullSpeedDebug"

cd %TRTEST%

rem sanity from the box..
%TRTEST%\tools\run.pl scwin32.cfg extractresults testlists\sanity.tl %XOPT

rem rebuild
%TRBLD_DIR%\trbuild.pl -d --j2se 

rem sanity after a clean rebuild
%TRTEST%\tools\run.pl scwin32.cfg buildresults testlists\sanity.tl %XOPT%

rem sanity after a clean rebuild with full speed debug
%TRTEST%\tools\run.pl scwin32.cfg ffsdbuildresults testlists\sanity.tl "-Xnoaot -Xjit:optLevel=warm,count=0,fasterFullSpeedDebug"

