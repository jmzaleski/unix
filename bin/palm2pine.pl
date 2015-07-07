#!/usr/bin/perl

use Text::ParseWords;

#scanner that folds palm contact records into pine address book.

### while( <STDIN> ){	$record = $_;	print 'record=', $record; }; exit;

#nb, the palm pilot prints out DOS files so there is a CR as well as a LF. 
#  ** That's why we chop twice below!
#
#  read the data and convert to pine addressbook format.
#
while( <STDIN> )
{
	$record = $_;
#	print "<record=<$record>\n";
	chop $record;
	chop $record;
#	print "<chopped record=<$record>\n";
	@words = &parse_line(",", 0, $record ); #comman delimited..
	$name = $words[0] . " " . $words[1] . " ";
	$email = $words[2];
	$nick = "oops";
	if ( $email ){
#		print "name=<$name> email=<$email>\n";
		@emailAddress = &parse_line("@",0, $email );
		$user = $emailAddress[0];
		$host = $emailAddress[1];
		if ( ! $host ){
#			print "no host for email address ", $email, "\n";
		} else {
#			print "nick=", $user, " name=", $name, " email=", $email, "\n";
			print "$user\t$name\t$email\n";
		}
	}
}

