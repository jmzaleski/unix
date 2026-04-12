#!/bin/sh -e

#copy this script to a new machine.
#run the script, should create a bunch of new dirs

cd 


if test ! -d git;
then
    echo no git directory
    exit
fi

echo used to fetch private files from bitbucket.. bad idea due to private keys
echo something like:  git clone https://matz@bitbucket.org/matz/dots.git

#mv dots/.ssh ~/.ssh

#echo fetch regular files from github.. won't work until .ssh keys are installed.

#read -p "hit enter to execute: git clone git@github.com:jmzaleski/unix.git" junk
echo something like: git clone git@github.com:jmzaleski/unix.git


/bin/pwd
read -p "continue to link files in ~/git/unix/dots to home ?" junk

ln -s git/unix/dots .
ln -s git/unix/bin .



read -p "continue to link . files in ~/dots to home ?" junk

dotfiles=""

### cd dots ######

cd $HOME/dots

for i in .[a-zA-Z]*
do
	dotfiles="$dotfiles $i"
done


if test -z "$dotfiles"
then
    echo no files in dot??
    exit 2
fi

echo will examine $dotfiles and link to home

### cd home ####
cd

exist=""

set -x 
for i in $dotfiles
do
        dest=~/$i
	if test -f $dest  || test -d $dest
	then
		ls -ld $dest
		echo $dest exists. decide if you want to link by hand and if so:
		echo mv $dest $dest.orig
		echo ln -s dots/$i $dest
		exist="$exist $i"
	elif test -L $dest
        then
	        echo symlink $dest already exists
		exist="$exist $i"
                ls -l $dest
        else
	        #set -x 
		if test -f $dest
		then
			echo skip $dest
		elif ln -s dots/$i $dest
		then
			ls -l $dest
		else
			echo failed to create symlink $dest
		fi
	        #set -
	fi
done

if test ! -z "$exist"
then
	echo fix up the following . files -- this script is too chicken to clobber
	ls -ldtr $exist
fi

