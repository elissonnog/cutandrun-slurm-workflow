#!/usr/bin/env bash
#SBATCH --job-name=bowtie2
#SBATCH -o bowtie2_%A_%a.out
#SBATCH -e bowtie2_%A_%a.err
#SBATCH --partition=long
#SBATCH --time=40:00:00
#SBATCH --mem=200G
#SBATCH --ntasks=4 # Set this to match the -p parameter in bowtie2
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config
load_module_if_set "${BOWTIE2_MODULE:-}"
load_module_if_set "${SAMTOOLS_MODULE:-}"
require_var BOWTIE2_SPIKEIN_PREFIX

## bowtie2-build path/to/Ecoli/fasta/Ecoli.fa /path/to/bowtie2Index/Ecoli
bowtie2 --end-to-end --very-sensitive \
--no-overlap --no-dovetail \
--no-mixed --no-discordant --phred33 \
-I 10 -X 700 -p "${SPIKEIN_THREADS:-4}" -x "$BOWTIE2_SPIKEIN_PREFIX" \
-1 "$FASTQ_DIR/${sample}${READ1_SUFFIX}" \
-2 "$FASTQ_DIR/${sample}${READ2_SUFFIX}" \
-S "$projPath/alignment/sam/${sample}_bowtie2_spikeIn.sam" \
&> "$projPath/alignment/sam/bowtie2_summary/${sample}_bowtie2_spikeIn.txt"


# Calculate sequencing depth - done when spike in is done

#last run
#seqDepthDouble=$(samtools view -F 0x04 -c $projPath/alignment/sam/${sample}_bowtie2.sam)
#seqDepth=$((seqDepthDouble / 2)) #calculate n reads


#original from paper
#seqDepthDouble=`samtools view -F 0x04 $projPath/alignment/sam/${sample}_bowtie2_spikeIn.sam | wc -l`
#seqDepth=$((seqDepthDouble/2))


#seqDepthDouble=`samtools view -F 0x04 seqDepth=$((seqDepthDouble/2))
#echo $seqDepth >$projPath/alignment/sam/bowtie2_summary/${sample}_bowtie2_spikeIn.seqDepth

