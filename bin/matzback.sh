#!/bin/sh

day=`date +%a`
dir="/home/matz.$day"
logfile=$dir/logfile

src=~matz

echo $dir
echo $src

cmd="tar -cvzf $dir/matz.$day.tarz ."

if test -d $dir
then
		echo "$0: backup destination of $src will be $dir"
else
		echo "$0: $dir does not exist. exit without backup" 2>&1
		exit 2
fi

if cd $src
then
	echo $0: cd  `/bin/pwd` successful. Ready to run "$cmd"
else
	exit "cannot cd to $src. exit without backup" 2>&1
	exit 3
fi

#if cp -ax .  $dir
#if tar -cvzf $dir/matz.tarz .


echo backup starts `date` > $logfile

if $cmd >> $logfile
then
   		/bin/pwd
		echo backup ends `date` >> $logfile
		echo $0: "$cmd" ' returns 0. backup successful'
		ls -l $dir
		echo "return code 0 from $cmd" >> $logfile
		exit 0
else
		echo backup ends `date` >> $logfile
		echo $0: "$cmd" ' returns non zero. backup failed' 2>&1
		echo "return code non-zero from $cmd" >> $logfile
		exit 4
fi

