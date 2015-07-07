#!/bin/sh

#despite the name of this script, it's really meant as the
#backup user data to tape progam for this system.
#takes pains to leave the tape at the end of the archive (despite rewinding
#and rereading twice, once to verify and the second time to list).
#thus more than one backup can be made to the same tape.

#todo: 
#figure out how to make errmsg send a message to stderr
#

if test -z "$*" 
then
	DIRS="/home/matz /home/hfe /home/samez /home/jacobez /root /var/spool/mail"
else
	DIRS=$*
fi

STEM_DIR="/backups/tarverify"
LOGFILE=$STEM_DIR/logfile
ERRFILE=$STEM_DIR/logfile

stem=$STEM_DIR/`date +%h%d_%H%M`

CKSUM_FILE=$stem"tar.cksum"
VERIFY_CKSUM_FILE=$stem"verify.cksum"
TAR_LIST_FILE=$stem"tarlist.txt"
TELL_FILE=$stem"mttell.txt"
END_FILE=$stem"end.txt"
ERR_LOG=$stem"errlog"

#
#send a message to stdout and also to the logfile
#
msg(){
	echo $* 
	echo $* >> $LOGFILE
}


errmsg(){
	echo '*************************'
	echo '* ' $* 
	echo '*************************'
	echo $* >> $ERRFILE
}

for i in $DIRS
do
	if test  -d $i
	then
		msg $i
	else
		errmsg $i not a directory though listed in DIRS.
		exit 2
	fi
done

if test -f $CKSUM_FILE -o -f $VERIFY_CKSUM_FILE -o -f $TAR_LIST_FILE 
then
	ls -l $stem*
	errmsg file exists. Clean up and then rerun
	exit 2
fi

msg '======================================================'
msg backup $DIRS to /dev/nst0 chsum to $CKSUM_FILE 
msg verified to $VERIFY_CKSUM_FILE
msg listed to $TAR_LIST_FILE 
msg '======================================================'

### testtouch $CKSUM_FILE $VERIFY_CKSUM_FILE  $TAR_LIST_FILE 
### exit

msg `date` tarverify.sh backup started


if mt -f /dev/nst0 tell > /dev/null
then
	initialTell=`mt -f /dev/nst0 tell`
	echo $initialTell > $TELL_FILE
	msg starting backup: \'$initialTell\'
else
	errmsg 'mt -f /dev/nst0 tell' returns non-zero. 
	errmsg 'something is wrong with tape system'
	exit 2
fi
	

#
################# cd / ###################################
#
cd /

date > $END_FILE

#
#from grant:
#####if  tar -czf - $DIRS | pad | gtee /dev/nst0 | cksum > $CKSUM_FILE 2> errlog
#but all this seemed to be artifacts of not reading with dd ibs=10240
##try?##if  tar -czf - $DIRS 2>> $ERRFILE | tee /dev/nst0 | cksum > $CKSUM_FILE 
#

msg about to exec tar -czf - $DIRS $END_FILE \| tee /dev/nst0 \| cksum 

if  tar -czf - $DIRS $END_FILE | tee /dev/nst0 | cksum > $CKSUM_FILE 2> $ERR_LOG
then
	msg tar completed with no errors. 
	msg '(tar warning about absolute file names is okay)'
	msg tar rc = $?
	msg tar archive ends `mt -f /dev/nst0 tell` of tape
	msg cksum of archive: `cat $CKSUM_FILE`
	msg `date +%T` tarverify.sh tar write complete
else
	errmsg 'error ***** tar -cvf returned rc=' $? ' **********'
	exit 2
fi	

#echo doing bsfm 2.. skip backwards to beginning of previous tape file
#echo I thought bsf should do until I started fiddling around.
#looks like if this is back to block 0 then an i/o error occurs
#perhaps we could get away with only one bsfm when intialTell is 0

msg rewind tape to where tar was started..
mt -f /dev/nst0 bsfm 2

tell=`mt -f /dev/nst0 tell`
msg mt bsfm2 '(tape rewind)' ends $tell

if test "$tell" != "$initialTell"
then
	errmsg rewind error. Initial position $initialTell. This rewind reaches $tell
	exit 2
else
	msg rewind positions tape $tell which  matches intial tape position of $initialTell
fi

msg now read tape again with ibs=10240 and recompute cksum..
if dd if=/dev/nst0 ibs=10240 | cksum > $VERIFY_CKSUM_FILE
then
	msg dd read tape with no error code on exit. Next compare checksum of this read with write.
	msg `cat $VERIFY_CKSUM_FILE`
else
	errmsg 'error ****** dd rc= '$?
	exit 2
fi

if diff $CKSUM_FILE $VERIFY_CKSUM_FILE
then
	msg cksum of this read matches cksum calculated written stream.
	msg '================================================================'
	msg '= tarverify.sh backup written and read back and cksums match   ='
	msg '================================================================'
else
	msg `date +%T` tarverify.sh verify failed. exit 1.
	errmsg '*****' cksums do not match. error in write or read
	exit 1
fi

msg `date +%T` tarverify.sh verify ended

msg rewind tape again to list the tape..
mt -f /dev/nst0 bsfm 2

tell=`mt -f /dev/nst0 tell`
msg mt bsfm2 '(rewind)' positions tape: `msg $tell`

if test "$tell" != "$initialTell"
then
	errmsg rewind error. Initial position $initialTell. This rewind $tell
	exit 2
else
	msg rewind repositions tape $tell which  matches intial tape position $initialTell
fi

msg list '(tar tv)' the backup to $TAR_LIST_FILE

#
#problem here is that tape write is blocked whereas zip is done in a pipe before tar blocks 
#the data. Hence, the good compressed data ends part way through the last block 
#in the tape archive. When restoring zip sees junk on the end and ignores it (but warns)
#if we could teach dd to quit part way through the block we would be okay.

#dd if=/dev/nst0 ibs=10240 | tar -tvzf - > $TAR_LIST_FILE
#dd if=/dev/nst0 ibs=10240 | zcat -d | tar -tvf - > $TAR_LIST_FILE
#no better -- returns 0 but complains that
#decompression OK, trailing garbage ignored
#how about: (perhaps we could dig NN out of chksum results?)
#dd if=/dev/nst0 ibs=10240 | dd bs=bytes count=NN | zcat -d | tar -tvf - > $TAR_LIST_FILE
#nope. even that fails.


if tar -tvzf /dev/nst0 > $TAR_LIST_FILE
then
	msg end of tar archive again at tape position `mt -f /dev/nst0 tell`
	msg do not worry about the message from gzip. It concerns the tail of the last block
else
	msg tar t returns failure
	exit 2
fi

msg `date +%T` tarverify.sh list ended

tail -5 $TAR_LIST_FILE

msg if the last line of the tar list shows $END_FILE then probably all is well.
