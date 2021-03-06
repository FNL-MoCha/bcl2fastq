#!/bin/bash
#PBS -S /bin/bash
#target="/projects/lihc_hiseq/static/181219_D00748_0162_ACD1M1ANXX"
set -eo pipefail
#source /etc/profile.d/modules.sh
time=`date +"%Y%m%d_%H%M%S"`
module load snakemake/5.5.4
NOW=$(date +"%Y_%B")
input=`dirname $target`
FCID=`basename $target`
export TARGET="$target/bcl2fastq.done"
export INPUT="$input/"
export SOURCE="$SOURCE"
export OUTPUT="/projects/lihc_hiseq/scratch/BW_transfers/"
export MONTH="$NOW"
export USER="$USER"
log="$HOME/log/"
mkdir -p $log

echo "$0#$SOURCE#"
mkdir -p ${OUTPUT}/${MONTH}/${FCID}

cp ${INPUT}/${FCID}/SampleSheet.csv ${OUTPUT}/${MONTH}/${FCID}/SampleSheet.csv
dos2unix ${OUTPUT}/${MONTH}/${FCID}/SampleSheet.csv
if  grep -q -i 10X ${INPUT}/${FCID}/SampleSheet.csv
then
	$SOURCE/bin/fixSampleSheet.pl ${OUTPUT}/${MONTH}/${FCID}/SampleSheet.csv 10X >${OUTPUT}/${MONTH}/${FCID}/SampleSheet.fixed.csv
else
	$SOURCE/bin/fixSampleSheet.pl ${OUTPUT}/${MONTH}/${FCID}/SampleSheet.csv >${OUTPUT}/${MONTH}/${FCID}/SampleSheet.fixed.csv
	mv -f ${OUTPUT}/${MONTH}/${FCID}/SampleSheet.fixed.csv ${OUTPUT}/${MONTH}/${FCID}/SampleSheet.csv
fi

snakemake -r -p --snakefile $SOURCE/bcl2fastq.snakemake\
	--nolock  --ri -k -p -r -j 3000\
	--jobscript $SOURCE/bin/jobscript.sh\
	--latency-wait 30\
	--jobname {params.rulename}.{jobid}\
	--cluster "sbatch -o $log/{params.rulename}.%j  {params.batch}"\
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
export SOURCE="$HOME/bcl2fastq.v2/"
export USER="$USER"
mkdir -p ${OUTPUT}/${MONTH}/${RUN}/
cp ${INPUT}/${RUN}/SampleSheet.csv ${OUTPUT}/${MONTH}/${RUN}/SampleSheet.csv
dos2unix ${OUTPUT}/${MONTH}/${RUN}/SampleSheet.csv
${SOURCE}/bin/fixSampleSheet.pl ${OUTPUT}/${MONTH}/${RUN}/SampleSheet.csv >${OUTPUT}/${MONTH}/${RUN}/SampleSheet.fixed.csv
mv -f ${OUTPUT}/${MONTH}/${RUN}/SampleSheet.fixed.csv ${OUTPUT}/${MONTH}/${RUN}/SampleSheet.csv
snakemake -r -p --snakefile $SOURCE/bcl2fastq.snakemake --dryrun
sbatch -J ${RUN} -o ~/log/${FCID}.bcl2fastq.sbatch --export=target=/projects/lihc_hiseq/static/${RUN} ~/bcl2fastq.v2/bin/submit_snakemake.sh


RUN=''
module load snakemake
NOW=$(date +"%Y_%B")
export MONTH="$NOW"
export INPUT="/projects/lihc_hiseq/static/NovaSeq/"
export OUTPUT="/projects/lihc_hiseq/scratch/BW_transfers/"
export TARGET="/projects/lihc_hiseq/static/NovaSeq/$RUN/bcl2fastq.done"
export SOURCE="$HOME/bcl2fastq.v2/"
export USER="$USER"
mkdir -p ${OUTPUT}/${MONTH}/${RUN}/
cp ${INPUT}//${RUN}/SampleSheet.csv ${OUTPUT}/${MONTH}/${RUN}/SampleSheet.csv
dos2unix ${OUTPUT}/${MONTH}/${RUN}/SampleSheet.csv
${SOURCE}/bin/fixSampleSheet.pl ${OUTPUT}/${MONTH}/${RUN}/SampleSheet.csv >${OUTPUT}/${MONTH}/${RUN}/SampleSheet.fixed.csv
snakemake -r -p --snakefile $SOURCE/bcl2fastq.snakemake --dryrun

sbatch -J ${RUN} -o ~/log/${FCID}.bcl2fastq.sbatch --export=target=/projects/lihc_hiseq/static/NovaSeq/${RUN} ~/bcl2fastq.v2/bin/submit_snakemake.sh


END
