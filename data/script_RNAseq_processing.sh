#!/bin/bash

###################################################
# sample1_R1.fastq contains about 20 millions reads 
# => Keep only 100000 reads from initial fatsq files
###################################################
mkdir data

head -n 400000 files/fastq_files/sample1_R1.fastq > data/mini_R1.fastq

head -n 400000 files/fastq_files/sample1_R2.fastq > data/mini_R2.fastq

###################################################
# fastQC analysis
###################################################
module load FastQC
mkdir reports

fastqc data/mini_R1.fastq -o reports
fastqc data/mini_R2.fastq -o reports

###################################################
# Cleaning reads
###################################################
module load Trimmomatic
mkdir processed_data
mkdir processed_data/trimmo

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar \
PE \
-threads 1 \
data/mini_R1.fastq \
data/mini_R2.fastq \
processed_data/trimmo/mini_clean_R1.fastq \
processed_data/trimmo/mini_unpaired_R1.fastq \
processed_data/trimmo/mini_clean_R2.fastq \
processed_data/trimmo/mini_unpaired_R2.fast \
ILLUMINACLIP:files/adapters/TruSeq3-PE.fa:2:30:10 \
SLIDINGWINDOW:10:20

###################################################
# Alignment
###################################################
module load HISAT2

mkdir processed_data/sam

hisat2 \
-p 1 \
-x files/INDEX/genome_snp_tran \
-1 processed_data/trimmo/mini_clean_R1.fastq \
-2 processed_data/trimmo/mini_clean_R2.fastq \
-S processed_data/sam/mini.sam

###################################################
# Convert sam to bam and index
###################################################

module load SAMtools
mkdir processed_data/bam

samtools view -Sb processed_data/sam/mini.sam | samtools sort > processed_data/bam/mini.bam

samtools index processed_data/bam/mini.bam

###################################################
# Counting
###################################################
module load Subread
mkdir processed_data/counts

featureCounts \
-a files/GTF/Homo_sapiens.GRCh38.94.gtf.gz \
-t exon \
-g gene_id \
-p \
--countReadPairs \
-s 0 \
-T 1 \
-o processed_data/counts/mini_counts \
processed_data/bam/mini.bam 