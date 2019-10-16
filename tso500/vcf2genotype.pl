#!/usr/bin/perl
use strict;
use warnings;

# Author Rajesh Patidar rajbtpatidar@gmail.com


my $file = $ARGV[0];
if(!$file){
	print STDERR "Give a vcf file\n";
	die;
}

unless (open(FH, "$file")){
	print STDERR "Can not open the give file $file\n";
	die;
}
while(<FH>){
	chomp;
	$_ =~ s/chr//g;
	my @local = split("\t", $_);
	if ($_ =~ /#/){ #Print column Header
		next;
	}
	if($local[6] =~ /PASS/ and length($local[3]) eq 1 and length($local[4]) eq 1 and $local[3] =~ /[ATCG]/ and $local[4] =~ /[ATCG]/){
		my @info=split(":", $local[9]);
		my ($ref, $alt)=split(",", $info[2]);
		if ($info[4]>0.65){
			print "$local[0]\t$local[1]\t$local[4]$local[4]\n";
		}
		elsif($alt>3 and $info[4] <0.65 and $info[4] >0.1){
			print "$local[0]\t$local[1]\t$local[3]$local[4]\n";
		}
	}
}
close FH;
