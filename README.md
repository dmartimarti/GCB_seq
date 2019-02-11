# GCB_seq
Scripts for the genome assembly and analysis of GCB species

The workflow is: 

- quality assessment and reports of the sequences with FastQC
- quality filter and trimm sequences with trimmomatic, and a list of Illumina adapters (also included in the repo)
- SPAdes genome assembly
- Unicycler genome assembly 
- to evaluate the quality of the assembly and compare, we use Quast
