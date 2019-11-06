# bcl2fastq pipeline on moab
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
## Email report on run to interested parties
- This is the final rule, globus transfer individual files are concatenated to one and a globus transfer is requested. It also parses the html output from bcl2fastq to create a report at FC level, lane level and sample level. This report is emaild to user and #run_stats channel on Slack.

# Running This pipeline:
- Manual Run:
	`perl /projects/lihc_hiseq/active/bcl2fastq.v2/automate.pl`
- Auto Run:
	Run /projects/lihc_hiseq/active/bcl2fastq.v2/automate.pl as cronjob at a frequency you are confertable with. 


### Rulegraph for TSO500 SampleSheet
![alt tag](TSO500_rulegraph.png)

### Rulegraph for WES SampleSheet
![alt tag](WES_rulegraph.png)
