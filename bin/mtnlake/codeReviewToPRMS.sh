
file=$1

FILE=/tmp/prms

IFS=':'

cat $file | (
	read junk
	while read junk
	do
	     set $junk
	     echo '========='
	     module="$1" ;        echo MODULE=$module
	     description="$2";	echo 'DESCRIPTION=' $description
	     assignedDate="$3";   echo 'ASS DATE=' $assignedDate
	     assigned="$4";       echo 'ASSIGNED=' $assigned
	     priority="$5";       echo 'PRIORITY=' $priority
	     resolution="$6";     echo 'RESOLUTION=' $resolution
	     resolutionDate="$7"; echo 'RES DATE ' $resolutionDate

cat > $FILE <<!EOF
SEND-PR: -*- send-pr -*-
SEND-PR: this is the template we use to submit code review tables..
SEND-PR: 
SEND-PR: manual if you are not sure how to fill out a problem report.
SEND-PR:
SEND-PR: Choose from the following categories:
SEND-PR:
SEND-PR: DB      HTML    INF     REQ     Testing UI      doc     
SEND-PR: pending test    
SEND-PR:
To: bugs@mtnlake.com
Subject: Code Review of rosco Transaction code
From: matz
Reply-To: matz
Cc: 
X-send-pr-version: 3.104


>Submitter-Id:	mtnlake
>Originator:	Mathew Zaleski
>Organization:
mtnlake imperial team
>Confidential:	no
>Synopsis:	code review issue
>Severity:	non-critical
>Priority:	$priority
>Category:	INF
>Class:		sw-bug
>Release:	Imperial Site Launch
>Environment:
	code review issue

>Description:
Code review results from Wednesday Nov 12 of Transaction infrastructure
Assigned to $assigned on $assignedDate against module $module

	$description
>How-To-Repeat:
	code review only
>Fix:
	not known

!EOF

	cat $FILE
	echo s | send-pr -f $FILE

	done
)
