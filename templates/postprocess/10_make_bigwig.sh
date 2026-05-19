#!/usr/bin/env bash
#SBATCH --job-name=bigwig
#SBATCH -o bigwig_%A_%a.out
#SBATCH -e bigwig_%A_%a.err
#SBATCH --time=24:00:00
#SBATCH --mem=64G
#SBATCH --ntasks=4
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config
load_module_if_set "${SAMTOOLS_MODULE:-}"
load_module_if_set "${DEEPTOOLS_MODULE:-}"

input_bam="$projPath/alignment/bam/${sample}_bowtie2.mapped.bam"
sorted_bam="$projPath/alignment/bam/${sample}.sorted.bam"
output_bw="$projPath/alignment/bigwig/${sample}_raw.bw"

require_file "$input_bam"
mkdir -p "$projPath/alignment/bigwig"

samtools sort -@ "${BIGWIG_SORT_THREADS:-4}" -o "$sorted_bam" "$input_bam"
samtools index "$sorted_bam"

cmd=(
  bamCoverage
  -b "$sorted_bam"
  -o "$output_bw"
  --numberOfProcessors "${BIGWIG_THREADS:-4}"
)

if [[ -n "${BAMCOVERAGE_BIN_SIZE:-}" ]]; then
  cmd+=(--binSize "$BAMCOVERAGE_BIN_SIZE")
fi

"${cmd[@]}"
