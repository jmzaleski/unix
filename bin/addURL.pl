#!/usr/bin/perl

#add a user to the first group file 

#how does one to ~ again?
$fileToEdit="/home/mtnlake/matz/public_html/home.html";

if ($#ARGV != 1 ) {		# Check arg count
    print(STDERR "Usage: $0 linkText URL\n");
    exit 2 ;
}

$linkText= $ARGV[0];
$urlToAdd= $ARGV[1];

print "add $linkText as link to $urlToAdd to file $fileToEdit\n";

#futz around the arg list so <> edits the file we want it to.
@ARGV = ( $fileToEdit );

open(ARGV,"<$ARGV");
#open(FILE,"<$fileToEdit");

#this will cause the old version of the file to be saved to .bak
$^I = ".bak";

#go through the file until you find the end of the list and then
#spit out the new userid's to be added.

#this has a bad bug - -namely it spits random binary BS onto
#stdout as well as edits the file.

# should we exit non zero if the user already exists?

$line="";
while(<>)
{
	$line=$_;
	chop( $line );
	if ( $line =~ /--here--/ )
	{
	    print "<DT><A HREF=\"$urlToAdd\"> $linkText </A></DT>\n" ;
	}
	print $line;
	print "\n";
}



