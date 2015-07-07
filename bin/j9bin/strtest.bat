set TRHOME=d:\tr\test.dev
set TRBLD_DIR=d:\tr\test.dev\bldtools
set J9_EXEC=d:\tr\test.dev\bin
set J9_HOME=%TRHOME%\bin
set PATH=%PATH%;%J9_EXEC%;%TRBLD_DIR%
set PERLLIB=d:\tr\test.dev\bldtools\perllib
set BUILDDIR=d:\tr\test.dev

cmvclog -in kenma
net use I: \\iguana\j9white /user:j9white j9wh1te /persistent:no
vcvars32
