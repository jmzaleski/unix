#!/bin/bash

. ~/.bashrc
. ~/.kenv

xemacs ~/Wiki/MatzWelcomePage ~/Wiki/Notes -geometry 110x44

w# xset fp default
# -funcall make-new-frame-on-left

#strace -c doesn't seem to do the trick. maybe prints just sys time.

#nohup strace  -T xemacs -geometry 90x70+0+10 ~/.INSTALL_IBM_LINUX ~/NOTES $* > /tmp/xemacs.strace.$$ &
#tail -f /tmp/xemacs.strace.$$

#strace  -T xemacs -geometry 90x70+0+10 ~/.INSTALL_IBM_LINUX ~/MEETINGS ~/NOTES $*

