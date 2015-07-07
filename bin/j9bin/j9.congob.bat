set J9_EXEC="e:\matz\j9\j9build\"

@rem this is where you unzip j9jit_testing_R22_20030227_1042.zip to
set j9_HOME="e:\matz\j9\j9_home"

@rem no debugger just yet. Leave DRUN unset
@rem no fancy options. leave JRUN unset 

@rem this line coped from J.BAT as documented by getting started with TRJIT document.
@rem except that I removed the -cp option and the JRUN variable.  Just use %1 for this..

%DRUN% %J9_EXEC%j9 %JRUN% -Xbootclasspath:%J9_HOME%\testing\classlib\ive\lib\jclmax\classes.zip  %1 %2 %3 %4 %5 %6 %7 %8 %9

@REM as was
@REM %DRUN% %J9_EXEC%j9 %JRUN% -Xbootclasspath:%J9_HOME%\j9\testing\classlib\ive\lib\jclmax\classes.zip  -cp %JARS% %1 %2 %3 %4 %5 %6 %7 %8 %9
