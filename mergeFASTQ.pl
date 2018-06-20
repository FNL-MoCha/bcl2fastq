#!/usr/bin/perl -sw
use List::Util qw(first);
my $sampleSheet=$ARGV[0];
my $sample=$ARGV[1];





open(FH, $sampleSheet);
my $splits=0;
my $search="$sample";
my $type="";
my $project="Testing";
while(<FH>){
	chomp;
	if ($_ =~ /Data/){
		my ($ID, $NAME , $Project, $Notes);
		while(<FH>){
			chomp;
			my @format=split(",", $_);
			if ($_ =~ /Sample_ID/){
				#Lane,Sample_ID,Sample_Name,Sample_Plate,Sample_Well,I7_Index_ID,index,Sample_Project,Description,Notes
				$ID =     first{ $format[$_] eq 'Sample_ID' } 0..$#format;
				$NAME=    first{ $format[$_] eq 'Sample_Name' } 0..$#format;
				$Project= first{ $format[$_] eq 'Sample_Project' } 0..$#format;
				if ($_ =~ /Notes/){
					$Notes=   first{ $format[$_] eq 'Notes' } 0..$#format;
				}
				elsif($_ =~ /Description/){
					$Notes=   first{ $format[$_] eq 'Description' } 0..$#format;
				}
				next;
			}
			if ($sample eq $format[$ID] or $sample eq $format[$NAME]){
				$splits =$splits+1;
				if ($sample =~ /CEPH/ or $sample =~ /HAPMAP/ or $sample =~ /UHR/ or $sample =~ /HBR/){
					$type="";
					$project="Testing";
					$search =$sample;	
					next;
				}
				if ($format[$Project] =~ /^PDX$/i or $format[$Project] =~ /ETCTN/i){
					$project ='PDX';
					if($format[$Notes] =~ /rnaseq/i){
						$type="RNASEQ";
					}
					else{
						$type="WES";
					}
					next;
				}
				if ($format[$ID] eq $format[$NAME]){
					$search=$sample;
				}
				elsif($format[$ID] ne $format[$NAME]){
					$search=$format[$NAME];
				}
			}
		}
	}
}
print "$splits\t$search\t$type\t$project\n";
close FH;
