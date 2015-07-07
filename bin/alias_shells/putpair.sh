#! tiny tool to help put down include file/implementation pair of files

comp=$1

file=$2

srcdir=$PROJECT/$SUBPROJECT/StudioPaint/$comp
if test ! -d $srcdir -or ! -f $srcdir/$file.c
then
		echo $0 cannot open $srcdir/$file.c
		exit 42
fi

incdir=$PROJECT/$SUBPROJECT/include/$comp
if test ! -d $incdir -or ! -f $incdir/$file.h
then
		echo $0 cannot open $incdir/$file.h
		exit 42
fi


MSG=/tmp/$comp.$file.$$

echo "edit your message for $incdir/$file.h and $srcdir/$file.c here" >> $MSG
##diff $file.c $srcdir/$file.c >> $MSG


if cmp $file.c $srcdir/$file.c
then
		if cmp $file.h $incdir/$file.h
		then
				echo '*** NO CHANGES MADE ???? ****' >> $MSG
		else
				gdiff -s 1000,500 $file.h $incdir/$file.h &
		fi
else
		gdiff -s 1000,500 $file.c $srcdir/$file.c &
fi

xterm -geometry 100x20+50+50 \#-0+600 -name small@$HOST -e umacs $MSG &

echo '*** waiting for the gdiff and umacs to finish ***'

wait

echo '*do you still want to put that stuff back? [yY*]\\n'

read junk
case $junk in
[yY]*)
		if cmp $file.h $incdir/$file.h
		then
				echo $0 -- $incdir/$file.h not changed
		else
		 		cat $MSG | lput -linclude/$comp $file.h
		fi
		if cmp $file.c $srcdir/$file.c
		then
		 		echo $0: $srcdir/$file.c not changed
		else
				cat $MSG | lput -lStudioPaint/$comp $file.c
		fi
		;;
*)
		;;
esac

rm -i $MSG

