
set junkArg1\
	/home/matz/p ZaleskiM palmBack\
	/home/matz   quicken  quicken\
	/home/matz   myRCS    matzRCS\
	/home/matz   MyPilot  MyPilot\
	/home/matz   .gnome   dot.gnome\
	/home        hfe      hfemail

while shift && test ! -z "$1"
do
	echo '>' $* '<'
	cddir=$1
	shift
	bdir=$1
	shift
	tfn=$1
	echo $cddir $bdir $tfn
done
