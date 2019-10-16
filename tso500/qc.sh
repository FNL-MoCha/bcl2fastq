#!/bin/bash
path=$1
sample=$2
#zipmocom-0.8.2.10/Analysis/9861_cfTNA
MTC=`grep "MEDIAN_TARGET_COVERAGE" $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.0f", $1}'`
CSC=`grep "CONTAMINATION_SCORE"    $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.3f", $1}'`
CPV=`grep "CONTAMINATION_P_VALUE"  $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.3f", $1}'`
MFS=`grep "MEAN_FAMILY_SIZE"       $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.2f", $1}'`
PDF=`grep "PCT_DUPLEX_FAMILIES"    $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.2f", $1}'`
TPR=`grep "TOTAL_PF_READS"         $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.0f", $1}'`
PRE=`grep "PCT_READ_ENRICHMENT"    $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.2f", $1}'`
NAF=`grep "NOISEAF"                $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.6f", $1}'`
MAD=`grep "GENE_SCALED_MAD"        $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.3f", $1}'`
MIS=`grep "MEDIAN_INSERT_SIZE"     $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.0f", $1}'`
UNI=`grep "PCT_20%MTC"             $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.2f", $1}'`
X50=`grep "PCT_TARGET_500X"        $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.2f", $1}'`
X70=`grep "PCT_TARGET_700X"        $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.2f", $1}'`
X10=`grep "PCT_TARGET_1000X"       $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.2f", $1}'`
X15=`grep "PCT_TARGET_1500X"       $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.2f", $1}'`
MEC=`grep "MEDIAN_EXON_COVERAGE"   $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4|awk '{printf "%.0f", $1}'`
TMB=`grep "Total TMB"              $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |head -1 |cut -f4|awk '{printf "%.2f", $1}'`
MAF=`grep "Max Somatic AF"         $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4`
MSI=`grep "Usable MSI Sites"	   $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4`
MSP=`grep "Percent Unstable Sites" $path/$sample/zipmocom_0.8.2.10_Analysis/DNA/aggregatestats/IntegrateReport.tsv |cut -f4`
#echo -e "Sample\tMTC\tContScore\tContLevel\tMeanFamilyDepth\tPctDuplexFamilies\tPFReads\tReadEnrich\tnoiseAF\tMAD\tMedianInsertSize\tUniformity20%\tPCT_500X\tPCT_700X\tPCT_1000X\tPCT_1500X\tMedianExonCoverage\tTMB\tMaxSomaticAF\tMSI_UsableSites\tMSI_UnstableSitesPct"
echo -e "$sample\t$MTC\t$CSC\t$CPV\t$MFS\t$PDF\t$TPR\t$PRE\t$NAF\t$MAD\t$MIS\t$UNI\t$X50\t$X70\t$X10\t$X15\t$MEC\t$TMB\t$MAF\t$MSI\t$MSP"
