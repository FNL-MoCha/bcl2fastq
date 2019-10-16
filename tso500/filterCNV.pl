#!/usr/bin/perl -sw
use File::Basename;
open(FH, $ARGV[0]); #Gene list file
print "Sample\tGene\tStatus\tFoldChange\n";
while(<FH>){
	chomp;
	if($_ =~/#/){
		#print "$_\n";
		next;
	}
	my @line=split("\t", $_);
	#chr5    38942402        .       G       <DUP>   157     PASS    SVTYPE=CNV;END=39074481;ANT=RICTOR      FC      1.201
	#chr11   69583094        .       A       <DUP>   77      PASS    SVTYPE=CNV;END=69594022;ANT=FGF4        FC      1.267
	#chr12   69202254        .       C       <DUP>   8       PASS    SVTYPE=CNV;END=69238168;ANT=MDM2        FC      1.197
	#chr13   113951746       .       C       <DUP>   157     PASS    SVTYPE=CNV;END=113977608;ANT=LAMP1      FC      1.222
	#chr19   30300898        .       A       <DUP>   22      PASS    SVTYPE=CNV;END=30314953;ANT=CCNE1       FC      1.198
	#chr19   45908588        .       A       <DUP>   157     PASS    SVTYPE=CNV;END=45927472;ANT=ERCC1       FC      1.237
	if($line[4] =~ /DUP/ or $line[4] =~ /DEL/){
		my $gene;
		if($line[7] =~ /ANT=(.*)/){
			$gene =$1;
		}
		$line[4] =~ s/<|>//g;
		print "$ARGV[1]\t$gene\t$line[4]\t$line[9]\n";
	}
}
close FH
