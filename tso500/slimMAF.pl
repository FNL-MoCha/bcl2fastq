#!/usr/bin/perl
use strict;
use warnings;

open(IN, "$ARGV[0]") or die "cannot open file $ARGV[0]:$!\n";
my $comment =<IN>;
my $title = <IN>;
chomp $title;
my @title = split(/\t/,$title);
print "$comment";
print "Hugo_Symbol\tEntrez_Gene_Id\tChromosome\tStart_Position\tEnd_Position\tStrand\tVariant_Classification\tVariant_Type\tReference_Allele\tTumor_Seq_Allele1\tTumor_Seq_Allele2\tTumor_Sample_Barcode\tMatched_Norm_Sample_Barcode\tTranscript_ID\tRefSeq\tHGVSc\tHGVSp\tHGVSp_Short\tExisting_variation\tExon_Number\tConsequence\tt_depth\tt_ref_count\tt_alt_count\ti_TumorVAF\tn_depth\tn_ref_count\tn_alt_count\tSIFT\tPolyPhen\tExAC_AF\tgnomAD_AF\tgnomAD_AFR_AF\tgnomAD_AMR_AF\tgnomAD_ASJ_AF\tgnomAD_EAS_AF\tgnomAD_FIN_AF\tgnomAD_NFE_AF\tgnomAD_OTH_AF\tgnomAD_SAS_AF\n";
my ($HUGO,$Gene,$Chr,$Start,$End,$Str,$Class,$Type,$Ref,$Alt1,$Alt2,$T_name,$N_name,$HGVSc,$HGVSp,$HGVSp_Short,$ENS,$T_depth,$T_ref,$T_alt,$N_depth,$N_ref,$N_alt,$Exist,$RefSeq,$SIFT,$PPH2,$ExAC,$gnomAD,$VAF,$gnomAD_AFR,$gnomAD_AMR,$gnomAD_ASJ,$gnomAD_EAS,$gnomAD_FIN,$gnomAD_NFE,$gnomAD_OTH,$gnomAD_SAS, $exon, $conseq);
for(0..$#title){
	$HUGO		= $_ if $title[$_] eq "Hugo_Symbol";
	$Gene		= $_ if $title[$_] eq "Entrez_Gene_Id";
	$Chr		= $_ if $title[$_] eq "Chromosome";
	$Start		= $_ if $title[$_] eq "Start_Position";
	$End		= $_ if $title[$_] eq "End_Position";
	$Str		= $_ if $title[$_] eq "Strand";
	$Class		= $_ if $title[$_] eq "Variant_Classification";
	$Type		= $_ if $title[$_] eq "Variant_Type";
	$Ref		= $_ if $title[$_] eq "Reference_Allele";
	$Alt1		= $_ if $title[$_] eq "Tumor_Seq_Allele1";
	$Alt2		= $_ if $title[$_] eq "Tumor_Seq_Allele2";
	$T_name		= $_ if $title[$_] eq "Tumor_Sample_Barcode";
	$N_name		= $_ if $title[$_] eq "Matched_Norm_Sample_Barcode";
	$HGVSc		= $_ if $title[$_] eq "HGVSc";
	$HGVSp		= $_ if $title[$_] eq "HGVSp";
	$HGVSp_Short	= $_ if $title[$_] eq "HGVSp_Short";
	$ENS		= $_ if $title[$_] eq "Transcript_ID";
	$T_depth	= $_ if $title[$_] eq "t_depth";
	$T_ref		= $_ if $title[$_] eq "t_ref_count";
	$T_alt		= $_ if $title[$_] eq "t_alt_count";
	$N_depth	= $_ if $title[$_] eq "n_depth";
	$N_ref		= $_ if $title[$_] eq "n_ref_count";
	$N_alt		= $_ if $title[$_] eq "n_alt_count";
	$Exist		= $_ if $title[$_] eq "Existing_variation";
	$RefSeq		= $_ if $title[$_] eq "RefSeq";
	$SIFT		= $_ if $title[$_] eq "SIFT";
	$PPH2		= $_ if $title[$_] eq "PolyPhen";
	$ExAC		= $_ if $title[$_] eq "ExAC_AF";
	$gnomAD		= $_ if $title[$_] eq "gnomAD_AF";
	$exon		= $_ if $title[$_] eq "Exon_Number";
	$conseq		= $_ if $title[$_] eq "Consequence";
	$gnomAD_AFR	= $_ if $title[$_] eq "gnomAD_AFR_AF";
	$gnomAD_AMR	= $_ if $title[$_] eq "gnomAD_AMR_AF";
	$gnomAD_ASJ	= $_ if $title[$_] eq "gnomAD_ASJ_AF";
	$gnomAD_EAS	= $_ if $title[$_] eq "gnomAD_EAS_AF";
	$gnomAD_FIN	= $_ if $title[$_] eq "gnomAD_FIN_AF";
	$gnomAD_NFE	= $_ if $title[$_] eq "gnomAD_NFE_AF";
	$gnomAD_OTH	= $_ if $title[$_] eq "gnomAD_OTH_AF";
	$gnomAD_SAS	= $_ if $title[$_] eq "gnomAD_SAS_AF";
	$VAF		= $_ if $title[$_] eq "i_TumorVAF";
}
while(<IN>){
	chomp;
	my @line = split("\t", $_);
	my $out;
	for my $idx($HUGO,$Gene,$Chr,$Start,$End,$Str,$Class,$Type,$Ref,$Alt1,$Alt2,$T_name,$N_name,$ENS,$RefSeq,$HGVSc,$HGVSp,$HGVSp_Short,$Exist,$exon,$conseq,$T_depth,$T_ref,$T_alt,$VAF,$N_depth,$N_ref,$N_alt,$SIFT,$PPH2,$ExAC,$gnomAD,$gnomAD_AFR,$gnomAD_AMR,$gnomAD_ASJ,$gnomAD_EAS,$gnomAD_FIN,$gnomAD_NFE,$gnomAD_OTH,$gnomAD_SAS){
		if (defined $line[$idx]){
			$out .="$line[$idx]\t";
		}
		else{
			$out .="\t";
		}
	}
	#$out = s/\t$//g;
	print "$out\n";
}
close IN;
