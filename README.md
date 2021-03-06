# bcl2fastq pipeline on batch or aka FoRCE (Frederick Research Computing Environment)

![schema](rulegraphs/bcl2fastq.png)

## Demultiplexing
- Runs illumina bcl2fastq with different settings depending on SampleSheet:
	- Run with TSO500 specific arguments when SampleSheet is from TSO500 experiments
	- Run with 10X cellranger mkfastq wrapper when SampleSheet is 10X Single Cell 
	- Run with default parameters in all other cases
		When Different types of Asssay are sequenced on the same Flowcell, ideal to have only one assay samples in SampleSheet and let this pipeline ran for 1 assay, then rename the output folder and Change the SampleSheet for other assay samples and manually launch this pipeline.
## Rename default fastq file names
- For the samples ran with defaule parameters, the fastq files are renamed to carray FCID.
## Find Deliverable Name
- This rule creates globus transfer command input for individual samples and based on the lookup table "Master.txt" the globus transfer files can carry the same name as provided in SampleSheet or the one found in lookup table. for example the control samples name does not get changed but a PDMR deliverable sample name get changed from PDA ID to deliverable sample ID
## 10X Pipeline
- When SampleSheet is for 10X samples cellranger count is ran on all the samples.
## TSO500 Pipeline
- When SampleSheet is for TSO500, following is done:
	- zipmo pipeline from Illumina
	- Convert GVCF 2 VCF
	- Create a .gt (genotype) file for genotyping purposes
	- Create a simple fusion report
	- Create a simple CNV report from the VCF file
	- Create a final QC report and send email to #run_stats channel on Slack.
	- Still to add: Annotation and variant filtering from the VCF file (MOMA)	
- This is a plug and play part of the pipeline and can be removed/suppressed easily by commenting `include: SOURCE +"/tso500.rules"` line in bcl2fastq.snakemake
## Email report on run to interested parties
- This is the final rule, globus transfer individual files are concatenated to one and a globus transfer is requested. It also parses the html output from bcl2fastq to create a report at FC level, lane level and sample level. This report is emaild to user and #run_stats channel on Slack.
	- If SampleSheet is for shallowseq samples, the fastq files get transferred to biowulf and this job waits for the transfer to finish. Once the transfer is finished successfully the ShallowSeq pipeline is launched on biowulf:
		`ssh -q biowulf.nih.gov "cd /data/MoCha/ShallowSeq/; sh launchShallowSeq.sh {FCID}"`
	- If SampleSheet is 10X, do nothing but report generation and email.
	- If SampleSheet is TSO500, do nothing but report generation and email.
	- If SampleSheet is Other Assays (WES/RNASEQ), transfer data to biowulf and generare report/email.
# Running This pipeline:
- Manual Run:
	`perl /projects/lihc_hiseq/active/bcl2fastq.v2/automate.pl`
- Auto Run:
	Run /projects/lihc_hiseq/active/bcl2fastq.v2/automate.pl as cronjob at a frequency you are comfortable with. 


### Rulegraph for TSO500 SampleSheet
![alt tag](rulegraphs/TSO500_rulegraph.png)

### Rulegraph for WES SampleSheet
![alt tag](rulegraphs/WES_rulegraph.png)

### Rulegraph for 10X SampleSheet
![alt tag](rulegraphs/10X_rulegraph.png)

------------------------------------------------------------------------

In case where bcl2fastq is done but downstream rule(s) failed, you would need to skip the automatic part of the pipeline and just run snakemake part to do so:	

Something along the following code can be ran on head node and then submitted to cluster	
```
#!/bin/bash
# When trying on head node you need to set RUN=RUNID
#RUN=$1
#Load Module 
module load snakemake
# This is the folder on BW_transfers where data is already existing for this RUNID
#NOW=2019_October
# Initialize other variable needed for the snakemake pipeline
NOW=$(date +"%Y_%B")
export MONTH="$NOW"
export INPUT="/projects/lihc_hiseq/static/NovaSeq/"
export OUTPUT="/projects/lihc_hiseq/scratch/BW_transfers/"
#export TARGET="/projects/lihc_hiseq/static/$RUN/bcl2fastq.done"
export TARGET="/projects/lihc_hiseq/static/NovaSeq/$RUN/bcl2fastq.done"
export SOURCE="/projects/lihc_hiseq/active/bcl2fastq.v2/"
export USER="$USER"
log=$HOME/log
mkdir -l $log
time=`date +"%Y%m%d_%H%M%S"`

# Do a dryrun (Remove the comment from next line)

#snakemake -r -p --snakefile $SOURCE/bcl2fastq.snakemake -n

snakemake -r -p --snakefile $SOURCE/bcl2fastq.snakemake\
        --nolock  --ri -k -p -r -j 3000\
        --restart-times 2\
        --latency-wait 30\
        --jobscript $SOURCE/bin/jobscript.sh\
        --jobname {params.rulename}.{jobid}\
        --cluster "sbatch -o $log/{params.rulename}.%j  {params.batch}"\
        --stats $log/${time}.stats >& $log/${time}.log
```
This script can be submitted to cluster using following command, depending what SampleSheet is in play:
- If running on 10X SampleSheet, you may want to increse the wall time
```
sbatch --export=RUN=<RUNID> --partition=norm   --time=24:00:00 <script.sh>
```

