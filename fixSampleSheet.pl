#!/usr/bin/perl -sw
use List::Util qw(first);
my $filename = $ARGV[0];
open(my $fh, $filename) or die "Could not open file '$filename' $!";
$/ = "[Data]";
my $head1 = <$fh>;  
$/="\n";

my $head2 = <$fh>;  
if(defined $ARGV[1] and $ARGV[1] =~ /^10X$/){
	#Nothing to do
}
else{
	print "$head1"."$head2";
}

my ($type, $lane, $id, $name, $I7_Index_ID, $index,$I5_Index_ID , $index2, $project, $desc, $note);


while (my $row = <$fh>) {
	chomp $row;
	my @a=split(",", $row);
	if($row =~ /Sample_ID/){
		#Lane,Sample_ID,Sample_Name,Sample_Plate,Sample_Well,I7_Index_ID,index,I5_Index_ID,index2,Sample_Project,Description,Notes
		#Lane,Sample_ID,Sample_Name,Sample_Plate,Sample_Well,I7_Index_ID,index,                   Sample_Project,Description,Notes
		$lane           = first { $a[$_] eq 'Lane' } 0..$#a;
		$id             = first { $a[$_] eq 'Sample_ID' } 0..$#a;
		$name    	= first { $a[$_] eq 'Sample_Name' } 0..$#a;
		$I7_Index_ID    = first { $a[$_] eq 'I7_Index_ID' } 0..$#a;
		$index          = first { $a[$_] eq 'index' } 0..$#a;
		$I5_Index_ID    = first { $a[$_] eq 'I5_Index_ID' } 0..$#a;
		$index2         = first { $a[$_] eq 'index2' } 0..$#a;
		$project        = first { $a[$_] eq 'Sample_Project' } 0..$#a;
		$desc           = first { $a[$_] eq 'Description' } 0..$#a;
		$note           = first { $a[$_] eq 'Notes' } 0..$#a;
		if(defined $ARGV[1] and $ARGV[1] =~ /^10X$/){
			print "Lane,Sample,Index\n";
			next;
		}
		if ($row =~/I5_Index_ID/){
			$type="dual";
			print "Lane,Sample_ID,Sample_Name,I7_Index_ID,index,I5_Index_ID,index2,Sample_Project,Description,Notes\n";
		}
		else{
			$type="single";
			print "Lane,Sample_ID,Sample_Name,I7_Index_ID,index,Sample_Project,Description,Notes\n";
		}
	}
	else{
		if(defined $ARGV[1] and $ARGV[1] =~ /^10X$/){
			print "$a[$lane],$a[$id],$a[$index]\n";
			next;
		}
		if ($row =~ /TST500/){
			print "$a[$lane],$a[$id],$a[$id],$a[$I7_Index_ID],$a[$index],$a[$I5_Index_ID],$a[$index2],$a[$project],$a[$desc],$a[$note]\n";
		}
		elsif ($type =~ /dual/){
			if($row !~ /[A-Za-z0-9_-]/){
				print "$row\n";
				exit;
			}
			if($row =~ /control/i or $a[$id] =~ /UHR/ or $a[$id] =~ /HBR/ or $a[$id] =~ /CEPH/ or $a[$id] =~ /HAP/){
				print "$a[$lane],$a[$id],$a[$name],$a[$I7_Index_ID],$a[$index],$a[$I5_Index_ID],$a[$index2],$a[$project],$a[$desc],$a[$note]\n";
				next;
			}
			if ($a[$id] =~ /([HDR|PAD|RND|PDA|PDC].*)_([R|r]ep[A|B|C|D])/){
				print "$a[$lane],$1,$1,$a[$I7_Index_ID],$a[$index],$a[$I5_Index_ID],$a[$index2],$a[$project],$a[$desc],$a[$note]\n";
			}
			else{
				print "$a[$lane],$a[$id],$a[$name],$a[$I7_Index_ID],$a[$index],$a[$I5_Index_ID],$a[$index2],$a[$project],$a[$desc],$a[$note]\n";
			}
		}
		else{
			if($row !~ /[A-Za-z0-9_-]/){
				print "$row\n";
				exit;
			}
			if($row =~ /control/i or $a[$id] =~ /UHR/ or $a[$id] =~ /HBR/ or $a[$id] =~ /CEPH/ or $a[$id] =~ /HAP/){
				print "$a[$lane],$a[$id],$a[$name],$a[$I7_Index_ID],$a[$index],$a[$project],$a[$desc],$a[$note]\n";
				next;
			}
			if ($a[$id] =~ /([HDR|PAD|RND|PDA|PDC].*)_([R|r]ep[A|B|C|D])/){
				print "$a[$lane],$1,$1,$a[$I7_Index_ID],$a[$index],$a[$project],$a[$desc],$a[$note]\n";
			}
			else{
				print "$a[$lane],$a[$id],$a[$name],$a[$I7_Index_ID],$a[$index],$a[$project],$a[$desc],$a[$note]\n";
			}
		}
	}
}
