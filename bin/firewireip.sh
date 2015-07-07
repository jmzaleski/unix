#!/bin/sh 

#see .ssh/config file
case `hostname` in
	*portable*)
		DEST_en0=deskside
	;;
	*deskside*)
		DEST_en0=laptop
		;;
	*)
		echo 'where are we??'
		exit 2
		;;
esac

DEST=$DEST_en0

#when in a hurry use firewire
DEST=`ssh $DEST_en0 ifconfig fw0 | grep "inet[^6]" | cut -d " " -f 2`
echo $DEST

