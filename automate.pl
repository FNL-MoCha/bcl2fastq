#!/usr/bin/perl
use strict;
use warnings;
# This is to automate:
#	 bcl2fastq conversion on moab [Done]
#	 change fastq file names as per required [Done]
#	 count # reads in files [Done]
# 	 copy data to biowulf and any other location it should get copied over to [Done]
# 	 send email notification [Done]
use English qw( −no_match_vars );

my $username = getpwuid $UID;

use Cwd;
my $this_file_full_path = Cwd::abs_path(__FILE__);

my $HOME=`dirname $this_file_full_path`;
chomp $HOME;
my $LOG="$HOME/log/";
my $PIPELINE="$HOME";
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
			if (-e "$OUTDIR/$MONTH/$line" or -e "$DIR/$line/bcl2fastq.done"){
				# Already processed or job running.
			}
			elsif (-M "$DIR/$line/RTAComplete.txt" <5){
				`mkdir -p $OUTDIR/$MONTH/$line`;
				if (-e "$DIR/$line/SampleSheet.csv"){
					`sbatch -J $FCID -o $LOG/$FCID.sbatch  --time=150:00:00  --export=target="$DIR/$line" $PIPELINE/submit_snakemake.sh`;
					exit;
				}
				elsif(-e "$DIR/$line/$FCID.csv"){
					`cp -rf "$DIR/$line/$FCID.csv" "$DIR/$line/SampleSheet.csv"`;
					`sbatch -J $FCID -o $LOG/$FCID.sbatch --time=150:00:00  --export=target="$DIR/$line" $PIPELINE/submit_snakemake.sh`;
				}
				else{
					`echo "I don't have permissions to read $DIR/$line/SampleSheet.csv" |mutt -s "bcl2fastq error" $username\@mail.nih.gov`;
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
			my $RUN = $_;
			chomp $RUN;
			if ($RUN =~ /(.*)_(.*)_(.*)_[A|B](.*)/){
				my $FCID=$4;
				if (-e "$DIR/$line/$RUN/RTAComplete.txt"){
					#print STDERR "$DIR/$line/$RUN/RTAComplete.txt\n";
					if (-e "$OUTDIR/$MONTH/$RUN" or -e "$DIR/$line/$RUN/bcl2fastq.done"){
						#print STDERR "Already done or in progress!!\n";
					}
					elsif (-M "$DIR/$line/$RUN/RTAComplete.txt" < 15){
						#print STDERR "This one needs to be processed\n";
						if( -e "$DIR/$line/$RUN/$FCID.csv"){
							`cp -rf "$DIR/$line/$RUN/$FCID.csv" "$DIR/$line/$RUN/SampleSheet.csv"`;
							#print STDERR "sbatch -J $FCID -o $LOG/$FCID.sbatch --time=150:00:00  --export=target=$DIR$line/$RUN $PIPELINE/submit_snakemake.sh\n";
							`sbatch -J $FCID -o $LOG/$FCID.sbatch --time=150:00:00  --export=target="$DIR$line/$RUN" $PIPELINE/submit_snakemake.sh`;
							exit;
						}
						else{
							#print STDERR "Can't read $DIR/$line/$RUN/$FCID.csv\n";
						}
					}
					else{
						#print STDERR "I should not reach here $RUN\n";
					}
				}
				else{
					#print STDERR "Run ongoing $RUN\n";
				}
			}
			else{
				#print STDERR "garbage $RUN\n";
			}
		}
		closedir $NOVA;	
	}	
}
closedir $DH;
