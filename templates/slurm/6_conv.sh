#!/usr/bin/env bash
#SBATCH --job-name=formatConv
#SBATCH -o conv_%A_%a.out
#SBATCH -e conv_%A_%a.err
#SBATCH --partition=long
#SBATCH --time=40:00:00
#SBATCH --mem=200G
#SBATCH --ntasks=8
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config
load_module_if_set "${SAMTOOLS_MODULE:-}"
load_module_if_set "${BEDTOOLS_MODULE:-}"

# Create output directory for fragment lengths
mkdir -p "$projPath/alignment/bam"

# Convert SAM to BAM
samtools view -bS -F 0x04 "$projPath/alignment/sam/${sample}_bowtie2.sam" > "$projPath/alignment/bam/${sample}_bowtie2.mapped.bam"

# Convert BAM to BEDPE
mkdir -p "$projPath/alignment/bed"
bedtools bamtobed -i "$projPath/alignment/bam/${sample}_bowtie2.mapped.bam" -bedpe > "$projPath/alignment/bed/${sample}_bowtie2.bed"

# Filter BEDPE file for same chromosome and fragment length less than 1000bp
awk -v max_len="${MAX_FRAGMENT_LENGTH:-1000}" '$1==$4 && $6-$2 < max_len {print $0}' "$projPath/alignment/bed/${sample}_bowtie2.bed" > "$projPath/alignment/bed/${sample}_bowtie2.clean.bed"

# Extract fragment related columns and sort
cut -f 1,2,6 "$projPath/alignment/bed/${sample}_bowtie2.clean.bed" | sort -k1,1 -k2,2n -k3,3n > "$projPath/alignment/bed/${sample}_bowtie2.fragments.bed"
