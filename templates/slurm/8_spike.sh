#!/usr/bin/env bash
#SBATCH --job-name=spikein
#SBATCH -o spike_%A_%a.out
#SBATCH -e spike_%A_%a.err
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
require_var CHROM_SIZES

seq_depth_double="$(samtools view -F 0x04 "$projPath/alignment/sam/${sample}_bowtie2_spikeIn.sam" | wc -l | tr -d ' ')"
seq_depth=$(( seq_depth_double / 2 ))

mkdir -p "$projPath/alignment/sam/bowtie2_summary"
printf '%s\n' "$seq_depth" > "$projPath/alignment/sam/bowtie2_summary/${sample}_bowtie2_spikeIn.seqDepth"

if [[ "$seq_depth" -le 1 ]]; then
  printf 'Skipping bedgraph normalization for %s because spike-in depth is %s\n' "$sample" "$seq_depth" >&2
  exit 0
fi

mkdir -p "$projPath/alignment/bedgraph"

scale_factor="$(awk -v num="${SPIKEIN_SCALE_NUMERATOR:-10000}" -v depth="$seq_depth" 'BEGIN { printf "%.10f", num / depth }')"

bedtools genomecov \
  -bg \
  -scale "$scale_factor" \
  -i "$projPath/alignment/bed/${sample}_bowtie2.fragments.bed" \
  -g "$CHROM_SIZES" \
  > "$projPath/alignment/bedgraph/${sample}_bowtie2.fragments.normalized.bedgraph"
