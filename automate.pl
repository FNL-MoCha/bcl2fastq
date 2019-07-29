#!/usr/bin/perl
use strict;
use warnings;
# This is to automate:
#	 bcl2fastq conversion on moab [Done]
#	 change fastq file names as per required [Done]
#	 count # reads in files [Done]
# 	 copy data to biowulf and any other location it should get copied over to [Done]
# 	 send email notification [Done]
my $HOME="/home/patidarr";
my $LOG="$HOME/log/";
my $PIPELINE="$HOME/bcl2fastq.v2/";
my $DIR = "/projects/lihc_hiseq/static/";
my $OUTDIR = "/projects/lihc_hiseq/scratch/BW_transfers/";
my $MONTH=`echo \$(date +"%Y_%B")`;
chomp $MONTH;
my $DH;
unless(opendir($DH, $DIR)){
	print STDERR "can not open directory $DIR\n";
	exit;
}
while(readdir $DH){
	my $line = $_;
	chomp $line;
	if ($line =~ /(.*)_(.*)_(.*)_[A|B](.*)/){
		my $FCID=$4;
		if (-e "$DIR/$line/RTAComplete.txt"){
			#print "qsub -N $FCID -o $LOG -e $LOG -v target=$DIR/$line $PIPELINE/submit_snakemake.sh\n";
			if (-e "$OUTDIR/$MONTH/$line" or -e "$DIR/$line/bcl2fastq.done"){
				# Already processed or job running.
				# Finished in last month
			}
			#elsif (-d "$DIR/180703_D00717_0102_ACCKGTANXX"){
			elsif (-M "$DIR/$line/RTAComplete.txt" <25){
				`mkdir -p $OUTDIR/$MONTH/$line`;
				if (-e "$DIR/$line/SampleSheet.csv"){
					`/usr/local/bin/qsub -N $FCID -o $LOG -e $LOG -v target="$DIR/$line" $PIPELINE/submit_snakemake.sh`;
					#print "/usr/local/bin/qsub -N $FCID -o $LOG -e $LOG -v target=$DIR/$line $PIPELINE/submit_snakemake.sh\n";
					exit;
				}
				elsif(-e "$DIR/$line/$FCID.csv"){
					`cp -rf "$DIR/$line/$FCID.csv" "$DIR/$line/SampleSheet.csv"`;
					`/usr/local/bin/qsub -N $FCID -o $LOG -e $LOG -v target="$DIR/$line" $PIPELINE/submit_snakemake.sh`;
					#print "/usr/local/bin/qsub -N $FCID -o $LOG -e $LOG -v target=\"$DIR/$line\" $PIPELINE/submit_snakemake.sh\n";
				}
				else{
					`echo "I don't have permissions to read $DIR/$line/SampleSheet.csv" |mutt -s "bcl2fastq error" patidarr\@mail.nih.gov`;
				}
			}
			else{
#				print "Very old run. $DIR/$line/SampleSheet.tsv\n";
			}
		}
		else{
			#print "This is not a complete run??     $DIR/$line\n";
		}
	}
	if($line =~ /NovaSeq/){
		opendir(my $NOVA, "$DIR/$line");
		while(readdir $NOVA){
			my $nova = $_;
			chomp $nova;
			if ($nova =~ /(.*)_(.*)_(.*)_[A|B](.*)/){
				my $FCID=$4;
				if (-e "$DIR/$line/$nova/CopyComplete.txt"){
					if (-e "$OUTDIR/$MONTH/$nova" or -e "$DIR/$line/$nova/bcl2fastq.done"){
						# Already done or in progress!!
					}
					elsif (-M "$DIR/$line/$nova/CopyComplete.txt" <5){
						if ( -e  "$DIR/$line/$nova/SampleSheet.csv"){
							#print "`/usr/local/bin/qsub -N $FCID -o $LOG -e $LOG -v target=\"$DIR$line/$nova\" $PIPELINE/submit_snakemake.sh`\n";
							`/usr/local/bin/qsub -N $FCID -o $LOG -e $LOG -v target="$DIR$line/$nova" $PIPELINE/submit_snakemake.sh`;
							exit;
						}
						elsif( -e "$DIR/$line/$nova/$FCID.csv"){
							`cp -rf "$DIR/$line/$nova/$FCID.csv" "$DIR/$line/$nova/SampleSheet.csv"`;
							#print "/usr/local/bin/qsub -N $FCID -o $LOG -e $LOG -v target=\"$DIR$line/$nova\" $PIPELINE/submit_snakemake.sh\n";
							`/usr/local/bin/qsub -N $FCID -o $LOG -e $LOG -v target="$DIR$line/$nova" $PIPELINE/submit_snakemake.sh`;
							exit;
						}
						else{
							#`echo "Can't read $DIR/$line/$nova/SampleSheet.csv" |mutt -s "bcl2fastq error" patidarr\@mail.nih.gov`;
						}
					}
				}
				elsif(-e "$DIR/$line/$nova/RTAComplete.txt"){
					if (-e "$OUTDIR/$MONTH/$nova" or -e "$DIR/$line/$nova/bcl2fastq.done"){
                                                # Already done or in progress!!
                                        }
					elsif (-M "$DIR/$line/$nova/RTAComplete.txt" <5){
						if( -e "$DIR/$line/$nova/$FCID.csv"){
							`cp -rf "$DIR/$line/$nova/$FCID.csv" "$DIR/$line/$nova/SampleSheet.csv"`;
							`/usr/local/bin/qsub -N $FCID -o $LOG -e $LOG -v target="$DIR$line/$nova" $PIPELINE/submit_snakemake.sh`;
							exit;
						}
					}
					else{
						#print "$nova\t Should not reach here\n";
					}
				}
			}
		}
		closedir $NOVA;	
	}	
}
closedir $DH;
