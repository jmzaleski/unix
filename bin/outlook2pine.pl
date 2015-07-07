#!/usr/bin/perl

#seemed like a good idea at the time.. but microsoft export periodically misses closing double quotes..

use Text::ParseWords;

#scanner that folds giant outlook contact records into pine address book.

####while( <STDIN> ){	$record = $_;	print 'record=', $record; }; exit;

#check that the input is what we expect -- the first line gives the field names.
#this kludge for custom export of just names and email..

@fieldNames = (
			   "First Name",
			   "Middle Name",
			   "Last Name",
			   "E-mail Address"
			   );
@fieldOffset = ( 2, 1, 0, 3);

$record = <STDIN>;
chop $record; #cr \r
chop $record; #lf \n
@words = &parse_line(",", 0, $record );

$i = 0;
foreach( @fieldNames )
{
	$offset = $fieldOffset[$i];
#	print "verify that field at offset $offset has header $fieldNames[$i]\n";
	if ( $words[$offset] ne $fieldNames[$i] ){
		print "Is stdin an outlook contact list?? field $offset should be <$fieldNames[$i]> instead of <$words[$offset]>\n";
		exit;
	}
	$i++;
}

#
# now read the data and convert to pine addressbook format.
#
while( <STDIN> )
{
	$record = $_;
	chop $record; ##take newline out of last record (email address) ### won't happen when email not last field!
	@words = &parse_line(",", 0, $record );
	$name = $words[0] . " " . $words[1] . " " . $words[2]; #last name first (like in palm pilot)
	$email = $words[3];
	$nick = "oops";
	$n = index $record, "@";
	if ( $email eq "" && $n >= 0 )
	{
		print "gak\n";
		print "name=<$name>\n";
		print "record=<$record>\n";
		print "email=<$email>\n";
		$i=0; foreach( @words ){ print "words[$i]=<$words[$i]>\n"; $i++; }
		die "oops, something wrong in parse";
	}
	if ( $email ){
		@emailAddress = &parse_line("@",0, $email );
		$user = $emailAddress[0];
		$host = $emailAddress[1];
		if ( ! $host ){
			print "no host for email address ", $email, "\n";
		} else {
#			print "nick=", $user, " name=", $name, " email=", $email, "\n";
			print "$user\t$name\t$email\n";
		}
	}
}

#now pipe this | tr \\t : | sort -f -t : +2 
