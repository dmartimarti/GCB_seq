#### Bash script for genome assembly

# analysis directory
cd /Users/dmarti14/Documents/MRC_Postdoc/GCB_seq/old_sequencing/analysis


# trimmomatic filtering
# remember to copy and paste the Illumina adapter file in the same folder
trimmomatic PE -threads 8 GCB1_S2_L001_R1_001.fastq GCB1_S2_L001_R2_001.fastq \
	GCB1_forward_paired.fastq GCB1_forward_unpaired.fastq GCB1_reverse_paired.fastq GCB1_reverse_unpaired.fastq \
	ILLUMINACLIP:TruSeq3-PE.fa:4:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36

trimmomatic PE -threads 8 AbS_S3_L001_R1_001.fastq AbS_S3_L001_R2_001.fastq \
	AbS_forward_paired.fastq AbS_forward_unpaired.fastq AbS_reverse_paired.fastq AbS_reverse_unpaired.fastq \
	ILLUMINACLIP:TruSeq3-PE.fa:4:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36

trimmomatic PE -threads 8 AbW_S1_L001_R1_001.fastq AbW_S1_L001_R2_001.fastq \
	AbW_forward_paired.fastq AbW_forward_unpaired.fastq AbW_reverse_paired.fastq AbW_reverse_unpaired.fastq \
	ILLUMINACLIP:TruSeq3-PE.fa:4:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36


# using SPAdes for genome assembly

python3 /Users/dmarti14/Documents/software/SPAdes-3.13.0-Darwin/bin/spades.py \
	-k 21,33,55,77 -t 8 -m 10 --careful -1 GCB1_S2_L001_R1_001.fastq -2 GCB1_S2_L001_R2_001.fastq -o spades_assembly

python3 /Users/dmarti14/Documents/software/SPAdes-3.13.0-Darwin/bin/spades.py \
	-k 21,33,55,77 -t 8 -m 10 --careful --only-assembler -1 AbS_forward_paired.fastq -2 AbS_reverse_paired.fastq \
	-s AbS_forward_unpaired.fastq -s AbS_reverse_unpaired.fastq -o spades_output

python3 /Users/dmarti14/Documents/software/SPAdes-3.13.0-Darwin/bin/spades.py \
	-k 21,33,55,77 -t 8 -m 10 --careful --only-assembler -1 AbW_forward_paired.fastq -2 AbW_reverse_paired.fastq \
	-s AbW_forward_unpaired.fastq -s AbW_reverse_unpaired.fastq -o spades_output


# using Unicycler for genome assembly
python3 /Users/dmarti14/Documents/software/Unicycler/unicycler-runner.py  \
	-1 GCB1_forward_paired.fastq -2 GCB1_reverse_paired.fastq -s GCB1_forward_unpaired.fastq -s GCB1_reverse_unpaired.fastq \
	-o unicycler_output --no_correct --mode normal --verbosity 1 --keep 2 -t 6 


# summary statistics about genome assembly
python3 /Users/dmarti14/Documents/software/quast-5.0.2/quast.py scaffolds.fasta --gene-finding --threads 8 --split-scaffolds --k-mer-stats --rna-finding -o SPAdes


python3 /Users/dmarti14/Documents/software/quast-5.0.2/quast.py assembly.fasta --gene-finding --threads 8 --split-scaffolds --k-mer-stats --rna-finding -o unicycler_quast




# wget to download blast databases into $HOME/blastdb

wget -r ftp://ftp.ncbi.nlm.nih.gov/blast/db/16SMicrobial.tar.gz
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.*tar.gz


blastn -query assembly.fasta -out results.out -db /Users/dmarti14/blastdb/nt -num_threads 8



