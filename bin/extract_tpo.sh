# -*-shell-script-*-

# not a useful tool -- more or less my documentation of the steps
# i followed to extract tpo for ppc linux

#name the directory in which to extract the source tree

if test -z "$1"
then
	DEST=/tmp/matzbld
else
	DEST=$1
fi


echo DEST = $DEST

if test ! -d $DEST
then
	echo no dir $DEST. hit return to create..
	read junk
	mkdir -p $DEST
fi

ls -ld $DEST

cd $DEST

/bin/pwd

set -x
# cellroot_new is just my guess.. it's the only dir which has changed in months.
# this fetches out the tools we need to fetch a source tree.
#
cvs -d /gsa/yktgsa/projects/c/cell_comp/cellroot_new co bin tools

# fiddles with the source tree a bit
#
env GSA_HOME=$DIR bash -x ./tools/getCompiler -noinit -nopoly -create dev090303

mkdir dev0903xx
cd dev0903xx

/bin/pwd
echo extract sources into `/bin/pwd`. Almost 200M will take several minutes..
echo hit return to continue..
read junk

# fetches tpo sources, makes linktree, etc
#
bash -x ../tools/getCVS -tpoLevel -native

echo "now: cd native && make tpoLevelnative"

# so TPO sources are out. now we check out 
# the xlof patches for TPO

#extract the XLOF patches to TPO 
cvs -d /gsa/yktgsa/projects/x/xlof/cvs_repos/repository co -d libipa xloffiles/tpo_src 

