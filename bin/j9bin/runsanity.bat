rem looks like it wants to be run from the extracted testing directory

cd %TRTEST%

tools\run.pl scwin32.cfg mzsanity sanity.tl "-Xnoaot -Xjit:optLevel=warm,count=0"

echo off
rem rest of this from Ken Ma. Might be out of date.

rem tools\run.pl j9win32.cfg mzsanity testlists\sanity.tl "-Xnoaot -Xjit:optLevel=warm,count=0"

rem set J9_EXEC=c:\tr\bin
rem tools\run.pl j9win32.cfg Feb23Test2LatestExtractResults testlists\sanity.tl "-Xnoaot -Xjit:optLevel=warm,count=0"

rem This was cancelled last time
rem Run this again after, set J9_EXEC=d:\wrkCVS\j9build

rem sanity check gc for original 
rem set J9_EXEC=d:\wrk\R22.j9.win.x86-32.20040120
rem tools\run.pl j9win32.cfg Feb2NoChangeWarmGCCheckResults testlists\sanity.tl "-Xjit:optlevel=warm,gcOnResolve,rtResolve,count=0 -Xmn1k"

rem sanity check for one to check into CVS, has high PC, should pass sanity.
rem - yes, this passes
rem set J9_EXEC=d:\wrkCVS\j9build
rem tools\run.pl j9win32.cfg Feb2PassSanNoHighCVSWarmResults testlists\sanity.tl -Xjit:optlevel=warm,count=0

rem check with optLevel=highOpt, still need to try highOpt on NoChange!!!
rem set J9_EXEC=d:\wrk\j9buildPassSanMergeNoHighFillGap
rem tools\run.pl j9win32.cfg Feb3AddInlineDepthResults testlists\sanity.tl -Xjit:optLevel=warm,count=0

rem check debug no fill gap results, default
rem set J9_EXEC=d:\wrk\j9buildPassSanDebugFillGapGetInlinerMap
rem tools\run.pl j9win32.cfg Feb3DebugNoFillGapOldJswalkResults testlists\sanity.tl -Xjit:optLevel=warm,count=0

rem next check if set debug option TR_DisableMergeStackMaps
rem set J9_EXEC=d:\wrk\j9buildPassSanDebugFillGapGetInlinerMap
rem tools\run.pl j9win32.cfg Feb3DebugNoFillGapDisabledMergeStackMapsResults testlists\sanity.tl -Xjit:optLevel=warm,count=0,disableMergeStackMaps

rem set J9_EXEC=D:\tr\test2.dev\jre\bin
rem tools\run.pl j9win32.cfg Feb3OriginalJitDevResults testlists\sanity.tl -Xjit:optLevel=warm,count=0
rem tools\run.pl j9win32.cfg Feb3PassSanDebugFillGapGetInlinerMapResults testlists\sanity.tl -Xjit:optLevel=warm,count=0

rem set J9_EXEC=D:\wrk\j9buildOnlyJITChanges
rem tools\run.pl j9win32.cfg Feb5ChangeMetaDataToHaveContiguousInlineDataFSDResults testlists\sanity.tl -Xjit:optLevel=warm,count=0,forceFullSpeedDebug

rem set J9_EXEC=D:\wrk\R22.j9.win.x86-32.20040120
rem tools\run.pl j9win32.cfg Feb5NoChangeFSDResults testlists\sanity.tl -Xjit:optLevel=warm,count=0,forceFullSpeedDebug

rem set J9_EXEC=D:\tr\test3.dev\bin
rem tools\run.pl j9win32.cfg Feb5TestOnLatestBuildResults testlists\sanity.tl "-Xnoaot -Xjit:optLevel=warm,count=0"

rem set J9_EXEC=D:\wrk\j9buildOnlyJITChanges
rem tools\run.pl j9win32.cfg Feb6CheckNewJswalkIsStillGoodResults testlists\sanity.tl -Xjit:optLevel=warm,count=0

rem set J9_EXEC=D:\tr\test.dev\bin
rem tools\run.pl j9win32.cfg Feb23CleanupAndChangeMetaDataLayoutResults testlists\sanity.tl "-Xnoaot -Xjit:optLevel=warm,count=0"

