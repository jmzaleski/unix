#!/usr/bin/perl

#wrap a c File with a bunch of stuff so that it can be inserted
#into a lyx document.
#should we want to start using the include facility instead we probably should
#not include the header stuff.


$HDR="/home/matz/bin/lyxHdr/home.html";

#print "argv=$#ARGV\n";

if ($#ARGV != 0 ) {		# Check arg count
    print(STDERR "Usage: $0 Java source file\n");
    exit 2 ;
}

$srcFile= $ARGV[0];

system( "cat \$HOME/lyx1.1.lyx" );

#expand converts the blanks to spaces..

open(FILE,"expand $srcFile |");

#this will cause the old version of the file to be saved to .bak
#$^I = ".bak";

print "\\layout LyX-Code\n";
print "converted from: $srcFile on ";
#cannot remember..
system("date");
print "\n";

$line="";
while(<FILE>)
{
	$line=$_;
	print "\\layout LyX-Code\n";
	print $line;
	print "\n";
}

print "\\the_end\n";



