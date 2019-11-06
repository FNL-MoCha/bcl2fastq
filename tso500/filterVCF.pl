#!/usr/bin/perl -sw
use List::Util qw(first);
use 5.010;
local $SIG{__WARN__} = sub {
	my $message =shift;
	die $message;
};
open(FH, $ARGV[0]); #VCF File

while(<FH>){
	chomp;
	if($_ =~ /^#/){
		if($_ =~ /(.*)\.raw\.PairRealigned\.Clean\.bam/){
			print "$1\n";
			next;
		}
		print "$_\n";
		next;
	}
	my @line=split("\t",$_);
	if($line[6] =~ /^PASS$/ and $line[4] !~ /\./){
		print "$_\n";
	}
}
close FH;
