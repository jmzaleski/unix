

#stupid. use: 

#don't traverse mount points
du -d 4 -k -x /

#the other disk
du -d 4 -k /Volumes/hdisk1_ufs


# TMPFILE=/tmp/dirs
# cd /
# find / -type d -maxdepth 3 -print | grep -v '^/$' > $TMPFILE

# for i in `cat $TMPFILE`
# do
#   du -sk "$i"
# done
