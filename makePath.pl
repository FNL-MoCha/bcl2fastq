#!/usr/bin/perl -sw
use Term::ANSIColor;
## ~/bcl2fastq.v2/makePath.pl SampleSheet 2018_June

my %Models;
open(FH, $ARGV[0]);
my $month=$ARGV[1];

#open(B2G, ">biowulf2grid.txt");
#open(B2INT, ">biowulf2pdmint.txt");
print "\n\n";
while(<FH>){
	chomp;
	my @line=split("\t", $_);
	if (`grep $line[0] ~/bcl2fastq.v2/failed.txt`){
		print color('red');
		print "$_ is in failed list; skip this one\n";
		print color('reset');
		next;
	}
	else{
		print "$_\n";
	}
}
#print color('bold red');
#print "\n\n\nBiowulf ==> MOAB \n\n\n";
#print "globus transfer -s checksum  --batch --label $month 6ca64a24-7484-11e8-93ba-0a6d4e044368: d39c8f50-7483-11e8-93ba-0a6d4e044368: <biowulf2grid.txt\n";

#print "\n\n\nBiowulf ==> PDM_INT\n\n\n";
#print "globus transfer -s checksum  --batch --label $month 6ca64a24-7484-11e8-93ba-0a6d4e044368: 0f93687c-7640-11e8-93d3-0a6d4e044368: <biowulf2pdmint.txt";
#print "\n\n\n";
#print color('reset');
#close B2INT;
#close FH;
