#!/usr/bin/perl

#scanner that folds junky GDF assembler sources into single statement per line

open(GDFSRC, "/tmp/cuods.txt");

for ( $recNum = 0; read(GDFSRC,$record,80); $recNum++ ) 
{
	($label, $line, $continuation, $statmentNumber) =
		unpack("A8 A64 A1 A8", $record);
	print $line;
}

