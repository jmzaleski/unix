#!/usr/bin/perl

##special hack to detect te's that are biased by less than $HOT
$HOT=42;

#to test set this to 1 and then grep differ | wc -l
#and make sure count matches lines.

$D=0;

#print "argv=$#ARGV\n";

if ($#ARGV != 0 ) {		# Check arg count
    print(STDERR "Usage: $0 jootch jlog file\n");
    exit 2 ;
}

$jlogFile= $ARGV[0];

open(FILE,"$jlogFile");

$same=0;  #te's that have the same profile number as following op
$differ=0;#te's that have a different profile number, hence were taken
$allops=0;#counts all bytecodes in all traces.
$cool=0;
$score=0;

$line="";

while(<FILE>)
{
	$line=$_;
	if ( $line =~ /^\s*\(\s*[0-9]+\/\s*[-0-9]+\):/  ){
	  $allops++;
	}
	
	if ($D){ print "line=$line\n";}
	#conditional trace exit ops all start with te_
	if ( $line =~ /^\s*\(\s*[0-9]+\/\s*[-0-9]+\):\s+(\d+)\s+te_/  ){
	  $profile = $1;
	  if ($D){ print "have te_ line: line=$line\n";}
	  #get following line
	  $line2 = <FILE>;
	  if ($D){ print "line2=$line2\n";}
	  if ( $line2 =~ /^\s*\(\s*[0-9]+\/\s*[-0-9]+\):\s+(\d+)\s+\w+/  ){
		$profile2 = $1;
		if ($D){ print "profile2=$profile2\n";}
	  }
	  else {
  		die "didn't find second profile";
  	  }
	  #so, if the profile number for following line is lower it means the
	  #te was taken at some point.
	  if ( $profile != $profile2 ){
		if ($D){ print "te_ profile profile=$profile differs from following profile2=$profile2\n";}
		if ( $profile < $profile2 ){
		  die "huh, how could profile2 be higher?";
		}
		$delta = ( $profile - $profile2 );
		$differ++;
		#how biased is the te?
		if ( $delta < $HOT ){
		  if($D){ print "found TE less than $HOT\n"; }
		  $score += $delta;
		  $cool++;
		} else {
		  if($D){ print "found TE more than $HOT\n"; }
		  $score += $HOT;
		}
	  }else{
		if ($D){ print "profile2=$profile2 same\n";}
		$same++;
		}
	}
}

print "not taken=$same\n";
print "taken    =$differ\n";

$totalte=($same + $differ);

printf  "$jlogFile: percent taken = %6.2f %% of $totalte te's\n", 100.0 * ($differ/($totalte) );
printf  "$jlogFile: percent taken = %6.2f %% of $allops total bytecode\n", 100.0 * ($differ/$allops);
printf  "$jlogFile: proportion of te ops in tracecache %6.2f%%\n", 100.0 * ( $totalte/ $allops) ;
printf  "$jlogFile: proportion of cool te's of all te's %6.2f%%\n", 100.0 * ( $cool/ $totalte) ;

#wait, shouldn't this be exactly the number of non-linked trace exits??

print  "$jlogFile: score=$score\n";

#print  "$jlogFile: percent taken = $taken % of $totalte te's\n";
#print  "$jlogFile: percent taken = $takenAll % of $allops total bytecode\n";






