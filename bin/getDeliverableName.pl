#!/usr/bin/perl -sw
use List::Util qw(first);
my $name=getSample();
if($name eq 1){
	print "$ARGV[1]\n";
}
else{
	print "$name\n";
}
##Patient       Type    MoChaID Project Enrichment      Source  Sample  MatchedGermline MatchedRNASEQ   FCID    Assay_version

sub getSample{
	open(IN, "$ARGV[0]") or die "cannot open file $ARGV[0]:$!\n";
	my $title = <IN>;
	my @title = split(/\t/,$title);
	my ($mochaID,$Type, $sampleID,$version);
	$mochaID     = first { $title[$_] eq 'MoChaID' } 0..$#title;
	$sampleID    = first { $title[$_] eq 'Sample' } 0..$#title;
	$Type        = first { $title[$_] eq 'Type' } 0..$#title;
	$version     = first { $title[$_] eq 'Assay_version' } 0..$#title;
	while(<IN>){
		chomp;
		my @line = split("\t", $_);
		if ($ARGV[1] eq $line[$mochaID] and $line[$Type] =~ /$ARGV[2]/){
			return ("$line[$sampleID]");
			next;
		}
	}
	close IN;
}
