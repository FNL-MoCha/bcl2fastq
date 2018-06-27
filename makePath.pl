#!/usr/bin/perl -sw
use Term::ANSIColor;
## ~/bcl2fastq.v2/makePath.pl SampleSheet 2018_June

`mkdir -p QC`;
`mkdir -p RNASEQ`;
`mkdir -p WES`;
my %Models;
open(FH, $ARGV[0]);
my $month=$ARGV[1];

`rm -rf biowulf2grid.txt`;
`rm -rf grid2pdmint.txt`;
open(B2G, ">biowulf2grid.txt");
open(B2INT, ">biowulf2pdmint.txt");
print "\n\n";
while(<FH>){
	chomp;
	my @line=split("~", $_);
	if (`grep $_ ~/bcl2fastq.v2/failed.txt`){
		print color('red');
		print "$_ is in failed list; skip this one\n";
		print color('reset');
		next;
	}
	else{
		my $version=`grep -P "$_\t" ~/bcl2fastq.v2/version.txt|cut -f2`;
		chomp $version;
		if($version !~/^v\d\.\d\.\d+\.\d+\.\d+$/){
			print "$_\t\t`$version` is not acceptable format\n";
			exit;
		}
		if ($line[0] =~ /germline/){
			my $pat=$line[0];
			$pat=~ s/_germline//g;
			print B2INT "processedDATA/$pat/20170910/$_/calls/$_.merged.vcf $pat~$version~germlineWES.vcf\n";
			print B2INT "DATA/$_/$_"."_R1.fastq.gz $pat~$version~germlineWES.R1.FASTQ.gz\n";
			print B2INT "DATA/$_/$_"."_R2.fastq.gz $pat~$version~germlineWES.R2.FASTQ.gz\n";
		}
		elsif ($line[3] =~ /RNASEQ/){
			$Models{$line[0]} ="1";
			print B2INT "processedDATA/$line[0]/20170910/$_/RSEM/$_.genes.results $line[0]~$line[1]~$line[2]~$version~RNASeq.RSEM.genes.results\n";
			print B2INT "processedDATA/$line[0]/20170910/$_/RSEM/$_.isoforms.results $line[0]~$line[1]~$line[2]~$version~RNASeq.RSEM.isoforms.results\n";
			print B2INT "DATA/$_/$_"."_R1.fastq.gz". " $line[0]~$line[1]~$line[2]~$version~RNASEQ.R1.FASTQ.gz\n";
			print B2INT "DATA/$_/$_"."_R1.fastq.gz". " $line[0]~$line[1]~$line[2]~$version~RNASEQ.R2.FASTQ.gz\n";
		}
		elsif($line[3] =~ /WES/){
			$Models{$line[0]} ="2";
			print B2INT "processedDATA/$line[0]/20170910/$_/calls/$_.merged.vcf $line[0]~$line[1]~$line[2]~$version~WES.vcf\n";
			print B2INT "DATA/$_/$_"."_R1.fastq.gz". " $line[0]~$line[1]~$line[2]~$version~WES.R1.FASTQ.gz\n";
			print B2INT "DATA/$_/$_"."_R1.fastq.gz". " $line[0]~$line[1]~$line[2]~$version~WES.R2.FASTQ.gz\n";
			print B2G   "processedDATA/$line[0]/20170910/$_/calls/$_.genemed.vcf $month/Upload/WES/$line[0]~$line[1]~$line[2].genemed.vcf\n";
		}
		else{
			print color('bold red');
			print "$_\t Something wrong with Name format\n";
			print color('reset');
			exit;
		}
	}

}
print color('bold red');
print "\n\n\nBiowulf ==> MOAB \n\n\n";
print "globus transfer -s checksum  --batch --label $month 6ca64a24-7484-11e8-93ba-0a6d4e044368: d39c8f50-7483-11e8-93ba-0a6d4e044368: <biowulf2grid.txt\n";

print "\n\n\nBiowulf ==> PDM_INT\n\n\n";
print "globus transfer -s checksum  --batch --label $month 6ca64a24-7484-11e8-93ba-0a6d4e044368: 0f93687c-7640-11e8-93d3-0a6d4e044368: <biowulf2pdmint.txt";
print "\n\n\n";
print color('reset');
close B2INT;
close FH;


for my $model(keys %Models){
	if ($Models{$model} == 1){
		#print B2G "processedDATA/$model/20170910/qc/$model.genotyping.txt $month/Upload/QC/$model.genotyping.txt\n";
		#print B2G "processedDATA/$model/20170910/qc/$model.circos.png     $month/Upload/QC/$model.circos.png\n";
		#print B2G "processedDATA/$model/20170910/qc/$model.maggie.pdf     $month/Upload/QC/$model.maggie.pdf\n";
		#print "$model\n";
	}
	elsif($Models{$model} == 2){
		print B2G "processedDATA/$model/20170910/qc/$model.ancestry.txt   $month/Upload/QC/$model.ancestry.txt\n";
		print B2G "processedDATA/$model/20170910/qc/$model.genotyping.txt $month/Upload/QC/$model.genotyping.txt\n";
		print B2G "processedDATA/$model/20170910/qc/$model.circos.png     $month/Upload/QC/$model.circos.png\n";
		#print B2G "processedDATA/$model/20170910/qc/$model.maggie.pdf    $month/Upload/QC/$model.maggie.pdf\n";
	}
}
close B2G;
