#!/bin/bash
#PBS -S /bin/bash
source /etc/profile.d/modules.sh
time=`date +"%Y%m%d_%H%M%S"`
module load snakemake
NOW=$(date +"%Y_%B")
input=`dirname $target`
export TARGET="$target/bcl2fastq.done"
export INPUT="$input/"
export SOURCE="/users/n2000747426/patidarr/bcl2fastq.v2/"
export OUTPUT="/projects/lihc_hiseq/scratch/BW_transfers/"
export MONTH="$NOW"
log="/users/n2000747426/patidarr/log/"
mkdir -p $log
snakemake -r -p --snakefile $SOURCE/bcl2fastq.snakemake\
	--nolock  --ri -k -p -T -r -j 3000\
	--jobname {params.rulename}.{jobid}\
	--cluster "qsub -W umask=022 -V -o $log -e $log {params.batch}"\
	--stats $log/${time}.stats >& $log/${time}.log
####################################




: <<'END'
RUN=''
module load snakemake
NOW=$(date +"%Y_%B")
export MONTH="$NOW"
export INPUT="/projects/lihc_hiseq/static/"
export OUTPUT="/projects/lihc_hiseq/scratch/BW_transfers/"
export TARGET="/projects/lihc_hiseq/static/$RUN/bcl2fastq.done"
export SOURCE="/users/n2000747426/patidarr/bcl2fastq.v2/"
snakemake -r -p --snakefile $SOURCE/bcl2fastq.snakemake --dryrun

RUN=''
module load snakemake
NOW=$(date +"%Y_%B")
export MONTH="$NOW"
export INPUT="/projects/lihc_hiseq/static/NovaSeq/"
export OUTPUT="/projects/lihc_hiseq/scratch/BW_transfers/"
export TARGET="/projects/lihc_hiseq/static/NovaSeq/$RUN/bcl2fastq.done"
export SOURCE="/users/n2000747426/patidarr/bcl2fastq.v2/"
snakemake -r -p --snakefile $SOURCE/bcl2fastq.snakemake --dryrun


END

#qsub -N CB9CLANXX -o ~/log/ -e ~/log/ -v target=/projects/lihc_hiseq/static/170824_D00748_0099_BCB9CLANXX ~/bcl2fastq.v2/submit_snakemake.sh
#qsub -N CCKGTANXX -o ~/log/ -e ~/log/ -v target=/projects/lihc_hiseq/static/180703_D00717_0102_ACCKGTANXX ~/bcl2fastq.v2/submit_snakemake.sh
#qsub -N CCKPVANXX -o ~/log/ -e ~/log/ -v target=/projects/lihc_hiseq/static/180703_D00717_0103_BCCKPVANXX ~/bcl2fastq.v2/submit_snakemake.sh
