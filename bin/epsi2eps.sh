
#this is a bogus convertion just to keep lyx happy. I don't know how to 
#actually do it.

#first arg is input
#second arg is output

i=$1
o=$2

LOG=/tmp/matzconvert.log

log(){
	echo $* >> $LOG
}

log $0 on `date`
log "convert $i to $o"

if test ! -f $i
then
	log oops file named by first arg, $i, does not exist. exit 2.
	exit 2
fi

if cmp $1 $2
then
	log files same. done
	exit 0
fi

if cp $i $o
then
	log cp succeeded
	exit 0
else
	log cp failed exit 1
	exit 1
fi
