#PBS -l walltime=1:0:0
#PBS -l select=1:ncpus=8:mem=15gb

# Load modules for any applications

module load trimmomatic/0.36

INFILE1=GCB1_S2_L001_R1_001.fastq
INFILE2=GCB1_S2_L001_R2_001.fastq
SEQS=TruSeq3-PE.fa
OUTFILE1=GCB1_forward_paired.fastq
OUTFILE2=GCB1_forward_unpaired.fastq
OUTFILE3=GCB1_reverse_paired.fastq
OUTFILE4=GCB1_reverse_unpaired.fastq

cp $HOME/GCB_seq/Sequencing/sequences/raw/GCB1/raw/$INFILE1 $TMPDIR
cp $HOME/GCB_seq/Sequencing/sequences/raw/GCB1/raw/$INFILE2 $TMPDIR
cp $HOME/GCB_seq/Sequencing/sequences/raw/GCB1/raw/$SEQS $TMPDIR

trimmomatic PE -threads 8 \
	$INFILE1 $INFILE2 $OUTFILE1 $OUTFILE2 $OUTFILE3 $OUTFILE4 \
	ILLUMINACLIP:$SEQS:4:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36

cp $OUTFILE1 $OUTFILE2 $OUTFILE3 $OUTFILE4 $HOME/GCB_seq/Sequencing/sequences/filtered