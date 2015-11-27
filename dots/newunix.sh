#!/bin/sh

#copy this script to a new machine.
#move aside .ssh
#run the script, should create a bunch of new dirs
#may be circulat deps on stuff on ~/ct/bin

### cd home ####
cd 

#run this script after checking out dots 

#CVSROOT=:ext:l0.zaleski.ca:~/CVS
#export CVSROOT=:ext:zaleski@dci.doncaster.on.ca:/var/virtuals/zaleski/zaleski/CVS
#export CVS_RSH=ssh
#echo cvs -d $CVSROOT checkout dots

#SVNCMD="svn co http://zaleski.dreamhosters.com/personal/trunk/dots    --username matz"
#SVNCMD_BIN="svn co http://zaleski.dreamhosters.com/personal/trunk/bin --username matz"

#echo you first must check out personal files from matz svn on dreamhosters..
#echo will execute:
#echo $SVNCMD
#echo $SVNCMD_BIN
#echo

# cvs -d $CVSROOT checkout dots

#read -p "hit return to continue" junk

#eval $SVNCMD
#eval $SVNCMD_BIN


echo about to execute: git clone https://matz@bitbucket.org/matz/dots.git

read -p "hit enter to execute: git clone https://matz@bitbucket.org/matz/dots.git ???" junk
git clone https://matz@bitbucket.org/matz/dots.git

echo 
read -p "continue to link files in ~/dots ?" junk

dotfiles=""

### cd dots ######

cd dots

for i in .[a-zA-Z]*
do
	dotfiles="$dotfiles $i"
done

if test -z "$dotfiles"
then
    echo no files in dot??
    exit 2
fi

### cd home ####
cd

exist=""

for i in $dotfiles
do
        dest=~/$i
	if test -f $dest
	then
		ls -ld $dest
		echo $dest exists. decide if you want to link by hand and if so:
		echo mv $dest $dest.orig
		echo ln -s dots/$i $dest
		exist="$exist $i"
	else
	        set -x 
	        ln -s dots/$i $dest
	        set -
	fi
done

if test ! -z "$exist"
then
	echo fix up the following . files -- this script is too chicken to clobber
	ls -ltr $exist
fi


