#!/bin/sh

cat <<!
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html> <head>
<title>mtnlake email  list</title>
</head>
<body>
<h1>email list</h1>
<P>
click on the username to send mail from netscape
<P>
!

#err, group 14 are the mtnlakers proper..

grep -v ^[SP] /etc/passwd | \
awk -F : '
$4==14 || $4==20 {
print "<A HREF=mailto:" $1 "@mtnlake.com>" $1 "</A> " $5 "\n<P>\n"
}'
