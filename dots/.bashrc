# -*-shell-script-*-

READLINK="readlink"
#READLINK="env PYTHONPATH='' $HOME/bin/readlink.py"

MATZ_ANDROID_DIR=`$READLINK ~/src`

#android builds need real java
#

java6(){
	export JAVA_HOME=$MATZ_ANDROID_DIR/jdk1.6.0_45
	PATH="$JAVA_HOME/bin":"$PATH"
}

java7(){
	export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
	PATH="$JAVA_HOME/bin":"$PATH"
}

java8(){
	export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home/
	PATH="$JAVA_HOME/bin":"$PATH"
}

#maven requires java8. see what else breaks..
java8

#kk build requires java6, "l" build java7
#java7

export ARCH=i386
export CLASSPATH=1

#android SDK too
export ANDROID_SDK=$MATZ_ANDROID_DIR/adt-bundle-linux-x86_64-20131030/sdk
export ANDROID_SDK_HOME=$ANDROID_SDK

#PATH="$ANDROID_SDK/tools":"$PATH"

#android NDK too
export ANDROID_NDK=$MATZ_ANDROID_DIR/android-ndk-r9c
export ANDROID_NDK_HOME=$ANDROID_NDK

#PATH="$ANDROID_NDK":"$PATH"

alias 2path='PATH="$ANDROID_SDK/tools":"$ANDROID_NDK":"$PATH"'
set ignoreeof=1

#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890

case "$HOME" in
*matz)
		;;
*zaleski)
		;;
*mathewza*)
		;;
*)
		echo warning if HOME variable is not matz\'s home path won\'t be right.
		;;
esac

#test -r /sw/bin/init.sh && . /sw/bin/init.sh

############ standard UNIX things #####################

#sometimes we want core dumps..
#ulimit -c unlimited
HOMEBREW_DIR=/opt/homebrew

MANPATH=$MANPATH:"$HOMEBREW_DIR/bin"/man:/usr/local/share/info
INFOPATH=:.::/usr/local/info:$INFOPATH:"$HOMEBREW_DIR"/share/info:/usr/local/share/info/:/usr/share/info:

#from some linux gazette. Should take an argument instead of assuming PWD
xtitle()
{
	case "$TERM" in #(
	xterm*|cygwin|vt100*)
         if test -z "$*"
         then
              title="$HOSTNAME:$PWD"
#              title="$PWD"
         else
              title=$HOSTNAME:$*
#              title="$*"
         fi
         #first char is a ESC, octal 33, decimal 27, 0x1b. Last char is control g 0x7
		 if true
		 then
			 echo -n -e "\e"     #escape
			 echo -n  "]2;"      #plain ] 2 semicolon.. 
			 echo -n  "$title"   #string you want in window title
			 echo -n -e "\a"     #bell.. 
			 #echo -n -e "]2;$title"
		 fi 
		 ;;
    *);;
    esac
}

# Change th 'cd' command to use xtitle()
# from some linux gazette. Should handle multi arg case also.
# complications with dirs that contain blanks. 
# if no "" then don't work. if "" then no args turn into empty string

cd()
{
	args="$*"
	if test -z "$args"
	then
		builtin cd
	else
		builtin cd "$args"
	fi
	#xtitle #busted google android build!
}

notlinks()
{
  test "$PWD" != "$HOME/links"
  rc=$?
  return $rc
}

cddlink(){
	if notlinks
	then
		d=$PWD
		cd ~/links
		ln -si $d .
		ls -l `basename $d`
	fi
}

#follow link
cdd()
{
	# cdd with no arg canonicalizes pwd
	if test -z "$*"
	then
		builtin cd "`/bin/pwd -P`"
		/bin/pwd
		return
	fi
	local p="$*"
	# if the arg does not name a directory, or is not a link to one, then look in ~/links
	if test ! -d "$p"
	then
		p=~/links/"$p" #look in links
	fi
	#set -x
	local d=`$READLINK "$p"` #arg exists. just go there
	#set -
	if test -d "$d"
	then
		builtin pushd "$d" > /dev/null 2>&1
	else
		echo cdd: cannot find dir $* or $p
		#could look in each directory here for $d. for $ldir in *; do if test -d $ldir/$d...
	fi
	echo $PWD
	xtitle $PWD
}

ltop(){
	l $*
	}

_UseGetOpt-ltop ()   #  By convention, the function name
{                 #+ starts with an underscore.
  local cur
  # Pointer to current completion word.
  # By convention, it's named "cur" but this isn't strictly necessary.

  COMPREPLY=()   # return result..Array variable storing the possible completions.
  cur=${COMP_WORDS[COMP_CWORD]} 

  case $cur in
    /*|\.*|\~* ) #absolute or relative or ~/ path names 
		 COMPREPLY=( $( compgen -d $cur ) )
		 ;;
	*)
		  #could really go to town here and look in a list of
		  #directories, just like CDPATH. 
		  #for now, just look in . and ~/links.

		  # most obvious. is $cur* a single file in . ? wanna go there.
		  
		  link_file_names=""
          # dirs hash table keeping track of canonical dir names
		  # (so we can detect dups between . and ~/links )
		  #
		  declare -A dirs 

		  #first look in . and append any files that start with cur
		  for i in "./$cur"*
		  do
			  if test ! -d "$i"
			  then
				  #echo; echo skip $i; echo
				  continue
			  fi
			  #echo; echo i: \>"$i"\< #debug; echo
			  canon=`$READLINK "$i"`
			  if test ! -z "${dirs[$canon]}"; then
				  continue # if already in hash, ignore
			  fi
			  # have a hit in .
			  dirs["$canon"]=$i
			  link_file_names="$link_file_names $i/"
		  done

		  #if pwd is not in the links directory.. look there.
		  #append any files that start with cur
		  if notlinks
		  then
			  for i in $(gettop)/"$cur"*
			  do
				  if test ! -d "$i"
				  then
					  #echo; echo skip $i; echo
					  continue
				  fi
				  canon=`$READLINK "$i"`
				  if test ! -z "${dirs[$canon]}"; then
					  continue
				  fi
				  # have a hit in ~/links
				  link_file_names="$link_file_names $i/"
				  dirs["$canon"]=$i
			  done
		  fi
		  COMPREPLY=( $link_file_names )
		  ;;
  esac
  compopt -o nospace #no trailing space. (thanks to stackoverflow)
}

#complete -F _UseGetOpt-ltop ltop


# http://tldp.org/LDP/abs/html/tabexpansion.html
# fancy business to do arg completion in bash for cdd command above
# Generate the completion matches and load them into $COMPREPLY array.
#
_UseGetOpt-cdd ()   #  By convention, the function name
{                 #+ starts with an underscore.
  local cur
  # Pointer to current completion word.
  # By convention, it's named "cur" but this isn't strictly necessary.

  COMPREPLY=()   # return result..Array variable storing the possible completions.
  cur=${COMP_WORDS[COMP_CWORD]} 

#  echo cur: \>$cur\< #debug
#  echo eh "$cur"*  #debug
  
  # is the relative path enough without any searching?
  # expand="$cur*"
  # echo
  # ls -l $expand
  # echo
  # if test -d $expand
  # then
  # 	  $READLINK  $expand
  # 	  COMREPLY=(`$READLINK  $expand`)
  # 	  return
  # fi

  case $cur in
    /*|\.*|\~* ) #absolute or relative or ~/ path names 
		 COMPREPLY=( $( compgen -d $cur ) )
		 ;;
	*)
		  #could really go to town here and look in a list of
		  #directories, just like CDPATH. 
		  #for now, just look in . and ~/links.

		  # most obvious. is $cur* a single file in . ? wanna go there.
		  
		  link_file_names=""
          # dirs hash table keeping track of canonical dir names
		  # (so we can detect dups between . and ~/links )
		  #
		  declare -A dirs 

		  #first look in . and append any files that start with cur
		  for i in "./$cur"*
		  do
			  if test ! -d "$i"
			  then
				  #echo; echo skip $i; echo
				  continue
			  fi
			  #echo; echo i: \>"$i"\< #debug; echo
			  canon=`$READLINK  "$i"`
			  if test ! -z "${dirs[$canon]}"; then
				  continue # if already in hash, ignore
			  fi
			  # have a hit in .
			  dirs["$canon"]=$i
			  link_file_names="$link_file_names $i/"
		  done

		  #if pwd is not in the links directory.. look there.
		  #append any files that start with cur
		  if notlinks
		  then
			  for i in ~/links/"$cur"*
			  do
				  if test ! -d "$i"
				  then
					  #echo; echo skip $i; echo
					  continue
				  fi
				  canon=`$READLINK  "$i"`
				  if test ! -z "${dirs[$canon]}"; then
					  continue
				  fi
				  # have a hit in ~/links
				  link_file_names="$link_file_names $i/"
				  dirs["$canon"]=$i
			  done
		  fi
		  COMPREPLY=( $link_file_names )
		  ;;
  esac
  compopt -o nospace #no trailing space. (thanks to stackoverflow)
}

#this is the magic that connects cdd completion function with cdd command
#complete -F _UseGetOpt-cdd cdd

pushd()
{
	builtin pushd $*
	#xtitle $PWD  #busted google android build!
}
popd()
{
	builtin popd $*
	#xtitle $PWD  #busted google android build!
}

#set a var that puts $ vs # in the prompt to remind me when I'm su'd
#can set # in root's .bashrc.

case `id -u` in
0)
    PROMPT_DOLLAR_OR_HASH=' # '
    ;;
*)
    PROMPT_DOLLAR_OR_HASH='$ '
    ;;
esac

# note that this env var will not survive sudo or su (have to sudo bash -l or su - or su -l)
# but TERM does, dammit, so we have a problem..
export PROMPT_DOLLAR_OR_HASH

case "$TERM" in
xterm*|vt100*|cygwin*)
	PS1="$HOSTNAME""${PROMPT_DOLLAR_OR_HASH-\\$#\\$# }"
	#xtitle  #busted google android build!
	;;
*)
#	PS1=$HOSTNAME' \\$\\$\\$\\$\\$\\$\\$\\$\\$ $PWD \\\$\\$\\$\\$\\$\\$\\$\\$\\$\\$
#$ '
	PS1=$HOSTNAME' $PWD \$ '
;;
esac

# NB CDPATH like this can bust google android make.
CDPATH=\
.:\
$HOME:

#lots of completion tidbits. notably completion along CDPATH
#see also ~/.inputrc
#complains that is read only variable?
if test -z $BASH_COMPLETION
then
 BASH_COMPLETION=~/dots/bash_completion
fi
#source $BASH_COMPLETION

#this assumes matz conventional place to checkout random git archives.. ie ~/git
if test -f ~/git/git/contrib/completion/git-completion.bash
then
 source ~/git/git/contrib/completion/git-completion.bash
fi

# mercurial needs PYTHONPATH set
#
export PYTHONPATH=\
:$HOME/lib/python:\
/usr/local/lib/python3.7/site-packages:\
$PYTHONPATH



#nb on os/x also have environment.plist
PATH=$PATH:\
$HOME/bin:\
"$HOMEBREW_DIR"/bin:\
/sbin:\
/usr/sbin:\
/usr/X11/bin:\
$HOME/build/apache-maven-3.3.3/bin:

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home/

#MANPATH=$MANPATH:\
#/usr/local/man:\
#/usr/X11R6/man:\
#/Developer/Documentation/ManPages

EDITOR="emacs"
PGPPATH=~matz/pgp

export CVS_RSH=ssh

#see .ssh host that maps www to the zaleski.ca cvs repo machine
export CVSHOST=www
#export CVSHOST=eon

#export CVSROOTDIR=/e/matz/CVS
#export CVSROOTDIR=\~/ct/CVS
export CVSROOTDIR=\~/CVS

export CVSROOT=:ext:$CVSHOST:$CVSROOTDIR

export RSYNC_RSH=ssh

#under cygwin or some terminals.. under X should go in .xinitrc

if test -z "$SSH_AGENT_PID"
then
	if test -f /c/temp/ssha.bash
	then
		printenv | grep SSH
		. /c/temp/ssha.bash
		printenv | grep SSH
	fi
fi


#for jpilot
#export PILOTPORT=/dev/tty.KeyUSA19191.1
#export PILOTRATE=57600

#at home HP2200 is network connected.
#osx/ cooked up this name (mac laptops)
#export PRINTER=_192.168.0.7
#lw-ba4239 across from karen's office

export PRINTER=lw-ba4239


if test -z "$HOST"
then
	HOST=$HOSTNAME
fi

export HOME MAIL CDPATH PATH MANPATH TERM \
       PS1 PS2 SHELL 	\
	   EDITOR 			\
	   TMPDIR			\
	   PGPPATH

#initializes nmon program
export NMON=dVtc

#
#otherwise programs like RCS insist on del being the erase key
#
#stty intr ^C
#stty erase ^H

#magic env variable that tells bash and ksh to read this file
#sort of like a .cshrc
BASH_ENV=~/dots/.kenv
export BASH_ENV

#magic bash history controls from http://www.catanmat.net
#

case $SHELL in
/bin/bash)
shopt -s histappend
export HISTSIZE=500 
export HISTFILESIZE=5000
export HISTFILE=~/.bash_history
export HISTIGNORE=l:ll:ls:pwd:h:history
#append history (one command) to file, clear, read history
#oh boy, this may run afoul of new stuff in osx/ /etc/bashrc
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
;;
esac

#make the default perms of files writable by group.
#umask 0002

case $SHELL in
*DOSBASH.EXE)
    . ~/dots/.kenv
	;;
*/zsh)
	. $HOME/.kenv
	;;
*/ksh)
	. $HOME/.kenv
	;;
*/bash)
	. "$HOME"/.kenv
	;;
*/sh)
	. $HOME/.kenv
	;;
esac

#echo hello from .bashrc

#export GITHUB_ACCESS_TOKEN=“YOUR OTKEN"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
