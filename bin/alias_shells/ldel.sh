#!/bin/sh
#
# run some ALIAS repo tools on the StudioPaint src area
# - currently uses fond to search through the source area; once
#   source area gets big we should create some sort of database of
#   filenames in source tree
#


trap "rm -f ${OCCURENCES} ; exit 2" 0 1 2 3 15

cmd_opts=
args=
new_file="no"

for i in $*
do
		echo $i
		case $i in
		-n)
				cmd_opts=$cmd_opts" -n"
				new_file="yes"
				;;
		-*)
				cmd_opts=$cmd_opts" "$i
				;;
		*)
				args=$args" $i"
				;;
		esac
done

#by the link tell what to do..
invoked_as=`basename $0`
if [ $invoked_as = "lget.sh" ]; then
    cmd=lget
elif [ $invoked_as = "lput.sh" ]; then
    cmd=lput
elif [ $invoked_as = "ldel.sh" ]; then
    cmd=ldel
elif [ $invoked_as = "spcncl" ]; then
    cmd=lcncl
elif [ $invoked_as = "spdiff" ]; then
	cmd=ldiff
elif [ $invoked_as = "spgdiff" ]; then
	cmd=lgdiff
else
    echo "Unknown invocation name" 1>&2
    exit 1
fi


cmd_file()
{
    the_project=
    the_dir=$1
    if [ -n "$PROJECT" ]
	then
		the_dir=`expr "$the_dir" : "$PROJECT/\(.*\)"`
		if [ -n "$the_dir" ]
		then
		 		the_project=$PROJECT
		else
		 		the_dir=$1
		fi
    fi

    the_file=`basename $the_dir`
    the_dir=`dirname $the_dir`
    the_library=`basename $the_dir`
    the_dir=`dirname $the_dir`
    if [ -n "$the_project" ]
	then
		the_subproj=$the_dir
    else
		the_subproj=`basename $the_dir`
		the_project=`dirname $the_dir`
    fi
	
    echo $cmd $cmd_opts -p$the_project -s$the_subproj -l$the_library $the_file
    $cmd $cmd_opts -p$the_project -s$the_subproj -l$the_library $the_file
}

for file in $args
do
	if test -l `basename $file`
	then
		echo $0: $file is a symbolic link. Forget it eh. 1>&2

	elif test -f $file
	then
		cmd_file $file

	else
		echo $0: cannot find file $file 1>&2
		case $new_file in
		yes*)
				echo $0: will try to create new repo file $file 1>&2
				cmd_file $file
				;;
		no*)
				echo $0: if you want to create a new file use -n 1>&2
				;;
		esac
	fi
done

exit 0

