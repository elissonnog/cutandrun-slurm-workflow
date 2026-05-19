#!/usr/bin/env bash
#SBATCH --job-name=bowtie
#SBATCH -o outbow_%A_%a.out
#SBATCH -e outbow_%A_%a.err
#SBATCH --time=40:00:00
#SBATCH --mem=200G
#SBATCH --ntasks=4 # Set this to match the -p parameter in bowtie2
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config
load_module_if_set "${BOWTIE2_MODULE:-}"
require_var BOWTIE2_GENOME_PREFIX

mkdir -p "$projPath/alignment/sam/bowtie2_summary"

bowtie2 --end-to-end --very-sensitive \
--no-mixed --no-discordant --phred33 -I 10 \
-x "$BOWTIE2_GENOME_PREFIX" \
-X 700 -p "${BOWTIE2_THREADS:-4}" -1 "$FASTQ_DIR/${sample}${READ1_SUFFIX}" \
-2 "$FASTQ_DIR/${sample}${READ2_SUFFIX}" \
-S "$projPath/alignment/sam/${sample}_bowtie2.sam" \
&> "$projPath/alignment/sam/bowtie2_summary/${sample}_bowtie2.txt"

#take the sam file and write a summary
