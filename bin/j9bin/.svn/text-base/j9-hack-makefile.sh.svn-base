#!/bin/bash

#depends on a buch of stuff. 
#xemacs.
#cygwin symlinks from /apps to wherever xemacs is installed.

echo about to hack out a bunch of targets from:

cd j9
ls -ld -i j9build/makefile
cp -i ~/j9/j9build/makefile ~/j9/j9build/makefile.orig

##workaround depends on init.el to load-file h9-hack-makefile.el
#
/apps/XEmacs/XEmacs-21.4.11/i586-pc-win32/xemacs.exe \
	j9build/makefile \
	-f j9-hack-makefile\
	-f save-buffers-kill-emacs

#this doesn't seem to want to load the .el file either. 
# /apps/XEmacs/XEmacs-21.4.11/i586-pc-win32/xemacs.exe \
# 	j9build/makefile \
# 	j9-hack-makefile.el \
# 	-f j9-hack-makefile\
# 	-f save-buffers-kill-emacs

ls -ld -i j9build/makefile j9build/makefile.orig

#	-load ./j9-hack-makefile.elc \
 

#doesn't work because xemacs cannot open filenames like //cydgriv/c
#/apps/XEmacs/XEmacs-21.4.11/i586-pc-win32/xemacs.exe ~/j9/j9-hack-makefile.el ~/j9/j9build/makefile -f j9-hack-makefile -f save-buffers

