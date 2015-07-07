#!/bin/bash
#touch xsessionRan
exec > .quartz-log 2>&1 
date
echo running ~/.xinitrc

set -x

export PATH=/Users/jonathan/bin/powerpc-apple-macos:/Users/jonathan/bin:/usr/local/bin:/sw/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/X11R6/bin:/usr/local/X11/bin

xrdb -merge $HOME/.X11defaults
#xmodmap $HOME/.xmodmap-`uname -n`

#for apple keyboard
xmodmap $HOME/.xmodmap-m0

#xhost `cat $HOME/.xhosts`

#mouse accel, threshold
#xset m 3 5

#bell %max volume, pitch (Hz), duration mSec
#xset b 70 1000 100

#energy star. This would standby in 30min, suspend in an hour.
#xset dpms 1800 3600 0

#font path
#xset fp /usr/X11R6/lib/X11/fonts/misc/:unscaled,/usr/X11R6/lib/X11/fonts/75dpi/:unscaled,/usr/X11R6/lib/X11/fonts/Type1/,/usr/X11R6/lib/X11/fonts/Speedo/
#xset fp+ unix/:-1

#panther X caused some kind of font confusion. resetting font path did it.
xset fp default

printenv

#salvation? Apple's X window manager
#nb. this depends on .MacOSX/environment.plist setting a location for SSH_AUTH_SOCK

#which the agent picks up by -a 
#
if ssh-add -l
then
	echo agent already running so do not start another
else
	ssh-agent -a $SSH_AUTH_SOCK
fi

SSH_ASKPASS=/usr/libexec/x11-ssh-askpass 
ssh-add ~/.ssh/id_dsa_cslab ~/.ssh/id_dsa_m1 < /dev/null
ssh-add -l

xterm -ls -geometry 80x45+10+10 &

#start up "wrk" tools..
~/bin/matzbashwrapper.sh xwrk &

exec /usr/X11R6/bin/quartz-wm 

