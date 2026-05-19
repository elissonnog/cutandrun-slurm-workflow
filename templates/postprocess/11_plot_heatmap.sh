#!/usr/bin/env bash
#SBATCH --job-name=heatmap
#SBATCH -o heatmap_%A_%a.out
#SBATCH -e heatmap_%A_%a.err
#SBATCH --time=24:00:00
#SBATCH --mem=64G
#SBATCH --ntasks=4
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config
load_module_if_set "${DEEPTOOLS_MODULE:-}"

bigwig_file="$projPath/alignment/bigwig/${sample}_raw.bw"
peak_bed="${HEATMAP_REGIONS_BED:-$projPath/peakCalling/SEACR/${sample}${HEATMAP_PEAK_SUFFIX:-_seacr_control.peaks.stringent.bed}}"
output_dir="$projPath/qc/deeptools"
matrix_file="$output_dir/${sample}_SEACR.mat.gz"
heatmap_png="$output_dir/${sample}_SEACR_heatmap.png"

require_file "$bigwig_file"
require_file "$peak_bed"
mkdir -p "$output_dir"

computeMatrix reference-point \
  -S "$bigwig_file" \
  -R "$peak_bed" \
  --skipZeros \
  -o "$matrix_file" \
  -p "${HEATMAP_THREADS:-4}" \
  -a "${HEATMAP_UPSTREAM_BP:-3000}" \
  -b "${HEATMAP_DOWNSTREAM_BP:-3000}" \
  --referencePoint "${HEATMAP_REFERENCE_POINT:-center}"

plotHeatmap \
  -m "$matrix_file" \
  -out "$heatmap_png" \
  --sortUsing sum \
  --startLabel "Peak Start" \
  --endLabel "Peak End" \
  --xAxisLabel "" \
  --regionsLabel "Peaks" \
  --samplesLabel "$sample"
