#!/bin/bash
#this script supports my process for working with J9 drops.
#The issue is that I take a drop, work for a month at a time, then need to merge
#repeatedly until it is checked in.

#so I use CVS mostly because it helps keep track of what I have changed and
#because it helps a lot with the work of the merge.

#1. all quiet. I'm up to date
#2. get a new drop
#3. import drop into new local CVS archive on this machine (branch 1.1 ver 1.1.1.1)
#4. do stuff.
#5. commit changes to local CVS (these are head revisions of changed files.)
#6. get another giant zip file from iguana
#7. unzip and clean it (probably not necessary now that I have a DOS aware .cvsignore in place)
#8. import into cvs under TRJIT vendor tag
#9. cvs co out into new build tree. (1.1.1.x)
#10.cvs merge my committed changes with latest import.
#11.manually (with ediff's help) resolve conflicts CVS has discovered.
#12.commit the merged tree into CVS.
#13.send zip file of changed files to Derek to put into CMVC

#One issue is that always are things that Derek doesn't want to accept, or I feel are not ready
#so #1 is naive. Usually after a new drop is a totally manual merge.
#conflicts come from two main sources.
#a) when  a file I have changed conflicts with a change made by someone else.
#   these are easy to deal with as code I have written is involved.

#The somewhat surprising other source of conflicts concerns when one uses
#the repo for multiple imports. This happens typically because I want to give Derek
#my stuff merged into the latest version of the sources yet it may take him a few days to
#get to reviewing my changes. I want to save him to last bit of merging!
#so in step #10 I commit my conflict resolutions and wind up in step #2 immediately.
#CVS cannot tell that some of the committed deltas were in fact straight from the imported branch.
#For instance, consider the repo just after I have committed the merged repo.

#    |
#	 |
#	 |
#	 + 1.2
#	 |
#	 |	  Dz2
#	 + 1.1
#	 |
#	 |    Dz
#	 |          Dm              Dm2
#	 +----|--------------|--------------|---
#	 	  1.1.1	    	 1.1.1.1        1.1.1.2

#okay, so after step 12 there is a 1.1. and a 1.1.1.1
#when I import again, 1.1.1.2 results.
#now, when I merge the 1.1.1.2 into 1.1 we get conflicts that have nothing to do with me.

#for instance, consider the sccid line in the file maintained by CMVC.
#if someone has changed the file between import 1.1.1.1 and 1.1.1.2 the sccid line will
#have changed. CVS will probably successfully merge Dm2 into 1.1 but will report
#a conflict for the line containing the sccsid. These are annoying but easy. Obviously
#more challenging are real deltas that are not my doing that come up for the same reason.

#these are always correctly resolved by taking the delta offered by the import.
#naturally, the 3way ediff used by PCL cvs mode does this. So, if a conflict isn't the result
#of my own change I should take the import, (the "B" buffer). When it does involve my change
#I have to carefully merge by hand. This is the only case that requires thought.

#Hence, it really helps if I autograph changes.


#DBG=true
DBG=false
J9=~/j9

cont(){
	echo $*
	echo -n hit return to continue..
	read junk
}

if test -z "$CVSROOT"
then
	echo error: there is no CVSROOT environment variable.
	exit 2
fi

if test ! -d $CVSROOT
then
	echo warning, there is no directory $CVSROOT
fi

cont  CVSROOT \= \"$CVSROOT\". Is this where you want the import to go?

if test -z "$1"
then
	echo usage: $0 R22zipfile
	exit 1
fi

if type nmake; then echo nmake in path; else  echo nmake not in path is bad; exit 1; fi
if type cvs; then echo cvs in path; else  echo cvs not in path is bad; exit 1; fi

dropzip="$1"

if test ! -f $dropzip
then
	echo cannot open drop zip file $1
	exit 2
fi

vertag=`basename $dropzip .zip`
absDropZip=$J9/j9drops/$vertag.zip

#$vertag cannot contain any funny chars. unfortunately . is a funny char.
vertag2=`echo $vertag | sed 's/\./_/g'`
codir=$J9/j9build.$vertag2.co
#newDropDir=$J9/j9build.$vertag.unzip
newDropDir=/tmp/j9build.$vertag.unzip
winfn=\"`cygpath --windows "$J9/j9build/makefile"`\"
baseCodir=`dirname $codir`

echo raw version tag vertag = $vertag
echo absDropZip=$absDropZip

echo will import into CVS under version tag vertag2
echo vertag2 = $vertag2

echo codir = $codir
echo newDropDir = $newDropDir
echo winfn = $winfn
echo baseCodir = $baseCodir

if test -d $codir; then	echo $codir already exists; exit 2; fi
if test -d $newDropDir; then	echo $newDropDir already exists; exit 2; fi

echo unzip $absDropZip into directory $newDropDir '(should rm asap..)'
echo make clean the drop to get rid of dll and other stuff we do not want in CVS
echo cvs import into repo $CVSROOT under version tag $vertag2 with message $vertag
echo the new drop will go into branch 1.1.1.1
echo co  $codir then merge branch and main trunk.
echo does not disturb contents $J9/j9build directory

cont before doing anything. vars above look okay?

if test ! -d $baseCodir
then
	echo oops, baseCodir has gone wrong. No dir $baseCodir
	exit 1
fi

if test ! -f $absDropZip
then
	echo something strange. We keep drops in $J9/j9drops, no?
	exit 3
fi

echo import TR jit sources in:
ls -l $absDropZip

if test -d $newDropDir
then
	echo $newDropDir exists. are you trying to clobber an existing drop?
	exit 35
fi

if $DBG; then cont before mkdir; fi

if mkdir $newDropDir
then
	echo mkdir $newDropDir exits okay
else
	echo oh oh failed to create $newDropDir
	exit 4
fi

builtin cd $newDropDir

if test -f makefile
then
	echo  "are you clobbering an existing dir by mistake?"
	exit 5
fi

if $DBG; then cont before unzip $absDropZip; fi

#this drops zillions of files into current working dir
if unzip $absDropZip
then
	echo unzip exits okay
else
	echo unzip exits failure
	exit 6
fi

#clean out the mess in here. zip includes OBJ's and  DLL's and other stuff lying around.

/bin/pwd
if $DBG; then cont before nmake  clean; fi

if nmake -f "$winfn" clean
then
	echo make clean exits okay
else
	echo make exits failure
	exit 7
fi

if $DBG; then cont before diff; fi

#diff files in the directories for reference..
#echo diff $newDropDir..
#-I skips the revision number and date CVS variables
#diff -I '\* \$Revision.*$\|\* \$Date: 2005-01-11 15:54:16 $' -r --brief $J9/j9build $newDropDir > $J9/diff.$vertag

/bin/pwd
if $DBG; then cont before cvs import; fi

#cvs import may print messages like:
#
#34 conflicts created by this import.
#Use the following command to help the merge:
#        cvs checkout -jTRJIT:yesterday -jTRJIT j9build

#cvs import the new files.
if cvs import -m "imported $vertag" j9build TRJIT $vertag2
then
	echo cvs import exits okay
else
	echo cvs import exits failure
	exit 8
fi

#now the newly imported changes can  be merged into the co tree..
#
#first check out the head revision of each file PRE import
#(then we will merge in the imported stuff)
#Otherwise cvs co -j  did NOT rm files that had been deleted in the last import.
#http://mail.gnu.org/archive/html/info-cvs/2001-09/msg00775.html
#see also ~/j9/doc/msg00775.html
#

#crummy assumption that newDropDir is right beside codir
#perhaps need to

if cd $baseCodir
then
	/bin/pwd
else
	echo cd $baseCodir exits failure
	exit 13
fi

if mkdir $codir
then
	echo mkdir $codir okay
else
	echo mkdir $codir exits failure.
	exit 14
fi


if cd $codir
then
	/bin/pwd
else
	echo failed to cd $codir
	exit 11
fi

if $DBG; then cont before cvs co ; fi

#co the head. We will merge next. co -jxxx seems NOT to rm deleted files.
if cvs co j9build
then
	echo cvs co exits okay.
else
	echo cvs co has failed.
	exit 12
fi


if $DBG; then cont before cvs update -j$vertag2 ; fi

#now merge revisions made in the import into this co
if cvs update -j$vertag2 j9build
then
	echo cvs update -j$vertag2 exits okay
else
	echo cvs update -j$vertag2 has failed
	exit 13
fi

#print conflicts..

echo conflicts created by update follow:
cvs -q -f -n update -d -P | grep ^C

#now have to resolve conflicts..
#basically there are a few styles of conflicts we'd like to identify.
#how can we do this automatically?
#if a file has changed a lot I want to ignore the CVS merge and ediff
#my changes back into the new version.

echo use pcl-cvs dE to doctor up the conflicts.
echo probably should swipe and execute: /bin/rm -rf $newDropDir now.

