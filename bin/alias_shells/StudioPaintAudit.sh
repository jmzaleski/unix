
#runs from crontab as software.

. ./.profile

lreal auditInfo -u \
		-h/nfs/redback/usr/StudioPaint/Admin/auditInfo.Hist \
		-a/nfs/redback/usr/Stud\ioPaint/AUDIT \
		-M \
		-p/nfs/redback/usr/StudioPaint \
		-r
