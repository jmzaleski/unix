#!/bin/sh -e

#copy this script to a new machine.
#run the script, should create a bunch of new dirs
cd 

#run this script after checking out dots 

mkdir git
cd git
echo about to execute: git clone https://matz@bitbucket.org/matz/dots.git

read -p "hit enter to execute: git clone https://matz@bitbucket.org/matz/dots.git ???" junk
git clone https://matz@bitbucket.org/matz/dots.git
ls -l dots/.ssh 
echo might want to copy some of the .ssh stuff to ~/.ssh 

read -p "hit enter to execute: git clone https://github.com/jmzaleski/unix.git" junk
git clone https://github.com/jmzaleski/unix.git
ln -s $PWD/unix/dots $HOME/dots

echo

read -p "continue to link files in ~/dots ?" junk

dotfiles=""

ln -s $PWD/unix/dots $HOME/dots

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
		if test -f $dest
		then
			echo skip $dest
		elif ln -s dots/$i $dest
		then
			ls -l $dest
		else
			echo failed to create symlink $dest
		fi
	        set -
	fi
done

if test ! -z "$exist"
then
	echo fix up the following . files -- this script is too chicken to clobber
	ls -ltr $exist
fi


