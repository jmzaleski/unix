

#probably can be more selective, but no time to fiddle right now
#Mail has an import facility that is probably much faster than downloading a GIG 
#	--exclude Library/Mail/IMAP-*/ 

EXCLUDES='
	--exclude Library/Caches/ 
	--exclude Library/Logs/ 
	--exclude Library/Fonts/ 
	--exclude Library/Mail/ 
'

cd $HOME
if test ! -d Library
then
	echo where are you? No Library directory??
	/bin/pwd -P
	exit 2
fi

if ssh lm1 test -d Library
then
	echo will rsync 'vvvvvvvvvvvvvv'
	ssh lm1 ls -ld Library/*
	echo will rsync '^^^^^^^^^^^^^'
else
	echo no remote dir Library ?
	exit 2
fi

CMD="rsync -a --progress --delete $EXCLUDES lm1:Library ."
echo will execute: $CMD
echo -n hit enter to continue:

read junk
$CMD
