#!/usr/bin/env bash
#SBATCH --job-name=samtools
#SBATCH -o sam_%A_%a.out
#SBATCH -e sam_%A_%a.err
#SBATCH --time=40:00:00
#SBATCH --mem=200G
#SBATCH --ntasks=8
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config
load_module_if_set "${SAMTOOLS_MODULE:-}"

# Create output directory for fragment lengths
mkdir -p "$projPath/alignment/sam/fragmentLen"

## Extract the 9th column from the alignment sam file which is the fragment length
samtools view -F 0x04 "$projPath/alignment/sam/${sample}_bowtie2.sam" | \
awk -F'\t' 'function abs(x){return ((x < 0.0) ? -x : x)} {print abs($9)}' | \
sort | uniq -c | awk -v OFS="\t" '{print $2, $1/2}' > "$projPath/alignment/sam/fragmentLen/${sample}_fragmentLen.txt"
