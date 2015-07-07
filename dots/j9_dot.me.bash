# -*-shell-script-*-

##################################### cygwin only ###################

xdiffwin32(){
	set -x
	prog="C:\Program Files\StarTeam Visual Diff\VisDiff.exe"

	case "$1" in
    /*)
	   one=`cygpath --windows "$1"`
	   echo abs /
	   ;;
    c:*)
	   one=`cygpath --windows "$1"`
	   echo abs :
	   ;;
	*)
	   one=`cygpath --windows "$PWD/$1"`
	   echo rel
	   ;;
	esac

	case "$2" in
    /*)
  	   two=`cygpath --windows "$2"`
	   ;;
    c:*)
  	   two=`cygpath --windows "$2"`
	   ;;
	*)
	   two=`cygpath --windows "$PWD/$2"`
	   ;;
	esac

	echo arg1: $one
	echo arg2: $two
	"$prog" "$one" "$two"

	set -
}
xdiff.save(){
	prog0="/C/Program\ Files/StarTeam\ Visual\ Diff/VisDiff.exe"
	prog1="/C/Program Files/StarTeam Visual Diff/VisDiff.exe"
	prog=\""C:\Program Files\StarTeam Visual Diff\VisDiff.exe"\"
	one=\"`cygpath --windows "$1"`\"
	two=\"`cygpath --windows "$2"`\"
	echo arg1: $one
	echo arg2: $two
	set -x
	echo "$prog" "$one" "$two" > /tmp/xx.bat
	chmod +x /tmp/xx.bat
	/tmp/xx.bat
	set -
}




##################################### tp0/rossa only ###################

#msdos/cygwin

#alias xemacs=/apps/XEmacs/XEmacs-21.4.11/i586-pc-win32/xemacs.exe

alias rtunnel="ssh -R 5900:localhost:5900 l0.zaleski.ca"

#reverse tunnel for ssh
alias revsshcongobtunnel="ssh -R 2200:localhost:22 l0.zaleski.ca"

#tunnel to congob vnc. That's congob.torolab.ibm.com..

congobtunnel(){
	xtitle congobtunnel
	echo will ssh then execute /apps/RealVNC/vncviewer.exe localhost:1
	ssh -f -L 5901:127.0.0.1:5900 congob 'sleep 36000'
	sshpid=$$
	sleep 2
	/apps/RealVNC/vncviewer.exe $* localhost:1  &
	echo note that there is now a background ssh process holding open the tunnel.
	ps | grep ssh
}

sharedcongobtunnel(){
	ssh -f -L 5901:127.0.0.1:5900 congob 'sleep 36000'
	/apps/RealVNC/vncviewer.exe /shared / localhost:1 
	echo note that there is now a background ssh process holding open the tunnel.
}

#alias m0tunnel="xtitle m0tunnel; ssh -L 5942:m0:5900 l0.zaleski.ca"
m0tunnel(){
	HOST=m0
	PORT=2
	FW=l0 #depends on .ssh/config to work.
	SSHCMD="ssh -f -L 590"$PORT":$HOST:5900 $FW"
	CMD="while date ; do echo m0 590$PORT tunnel. vnclient localhost:$PORT is active..; sleep 60; done"
	xtitle $HOST"tunnel"
	echo will $SSHCMD then execute /apps/RealVNC/vncviewer.exe localhost:$PORT
	echo using $CMD to keep ssh active..
	ssh -f -L 590"$PORT":$HOST:5900 $FW $CMD
	/apps/RealVNC/vncviewer.exe localhost:$PORT
}

m0vnctunnel ()
{
	HOST=m0
	PORT=42
	FW=l0 #depends on .ssh/config to work.
    VNC="/apps/RealVNC/vncviewer.exe"
    xtitle m0vnctunnel
    echo will ssh $FW, wake up $HOST, then execute $VNC localhost:$PORT
    echo give /share option to allow vnc connection to be shared.
    echo ssh twice. Once to wake up m0. second time to open tunnel.
	echo you are being prompted for the password for l0\'s ssh private key.
    ssh -t l0 'bin/wolm0.sh'
    ssh -f -L 59$PORT:m0:5900 l0 'echo sleeping on l0..; sleep 36000'
    sleep 5
    "$VNC" $* localhost:$PORT
}

alias j9wrk='cdd ~/j9/j9build; /apps/XEmacs/XEmacs-21.4.11/i586-pc-win32/xemacs.exe -T j9 -iconname j9 -geometry 81x42-3+3 Makefile -funcall make-new-frame-on-left'

alias x="/apps/XEmacs/XEmacs-21.4.11/i586-pc-win32/winclient.exe"
alias x="gnuclient"

alias xnew='/apps/XEmacs/XEmacs-21.4.11/i586-pc-win32/winclient.exe `ls -tr|tail -1`'

#cygwin wrapper for VC7 dumpbin utility
dumpbin()
{
	/Vc7/bin/dumpbin.exe /exports `cygpath -d $*`
}

alias duplexlprtxt="enscript -DDuplex:true "

trenv(){
	j9vc7env
	. ~/tr/bin/trenv.sh
	printenv | grep TR
	echo good for building and extracting TR JIT
}

j9vc7env(){
	. ~/j9/bin/j9vc7env.sh
	. ~/j9/bin/j9dbgbuildenv.sh

	echo '** now lots of env vars are set to take .h .lib etc from .NET **'
	echo '** DEBUG BUILD **'
}

j9dbgbuildenv(){
	. ~/j9/bin/j9dbgbuildenv.sh
	echo '** now even more env vars are set to make VC  compile DBG **'
}

j9backup(){
	. ~/j9/bin/j9backup.bash
}


#end DOS
