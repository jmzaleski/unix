#!/bin/bash


# -funcall matz-make-new-frame-on-display1
# -font '-*-fixed-bold-r-*-*-15-*-75-75-*-*-*-1' 
# -geometry 108x45
#	-funcall matz-wiki-TIME-IN \

# /sw/bin/emacs-22.3-carbon \

exec /Applications/Aquamacs.app/Contents/MacOS/Aquamacs \
   --geometry 180x48+0+0 \
    ~/muse/MatzWelcomePage.muse \
    -funcall plan 


