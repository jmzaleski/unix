
cd /Volumes/ufs0
#rsync --progress --extended-attributes --archive --hard-links --delete --one-file-system --progress skule notbackedup backedup batch.syslab.sandbox:/fromM1Ufs
rsync --progress --extended-attributes --archive --hard-links --delete --one-file-system --progress skule batch.syslab.sandbox:/fromM1Ufs
