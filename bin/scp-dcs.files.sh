#!/bin/bash

# scp the args up to http://www.cs.utoronto.ca/~matz/files/
URL="http://www.cs.utoronto.ca/~matz/files/"

#this is probably delicate. ssh to remotely mounted public_html directory
SSH_CONFIG_HOST=qew
REM_DIR=/cs/htuser/matz/public_html/files
SSH_CONFIG_HOST_DEST=$SSH_CONFIG_HOST:$REM_DIR


#append arguments to a bash array. this because files with blanks in them are a pain to parse
arr=()
while [[ $# -gt 0 ]]
do
	arg="$1"
	shift
	arr+=("$arg")
done

# echo just echo '$arr' $arr
# echo size '${#arr[@]}' ${#arr[@]}	
# echo '${arr[0]}' ${arr[0]}
# echo '${arr[1]}' ${arr[1]}
# for t in "${arr[@]}"; do
#   echo '$t' $t
# done

# upload file to remote, chmod it, ls -l for good measure
for t in "${arr[@]}"; do
	echo '$t' $t
	set -x
	scp "$t" $SSH_CONFIG_HOST_DEST/
	ssh $SSH_CONFIG_HOST chmod o+r "'$REM_DIR/$t'"
	ssh $SSH_CONFIG_HOST ls -l "$REM_DIR/"\"$t\"
	set -x
done

echo ask collaborators to open browser to:
echo $URL
read -p 'copy paste/this url to email or something.. hit enter to visit URL' junk

open $URL &

read -p "if collaboarator is done, hit enter to remove files from files, o/w interrupt now to leave." junk

for t in "${arr[@]}"; do
	echo '$t' $t
	ssh $SSH_CONFIG_HOST rm -i "'$REM_DIR/$t'"
done

