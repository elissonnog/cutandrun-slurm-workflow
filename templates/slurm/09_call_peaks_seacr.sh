#!/usr/bin/env bash
#SBATCH --job-name=seacr
#SBATCH --output=SEACR_%A_%a.out
#SBATCH --error=SEACR_%A_%a.err
#SBATCH --time=20:00:00
#SBATCH --mem=200G
#SBATCH --ntasks=40
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config
load_module_if_set "${R_MODULE:-}"
load_module_if_set "${BEDTOOLS_MODULE:-}"
require_var SEACR_SCRIPT

mkdir -p "$projPath/peakCalling/SEACR"

if ! control="$(lookup_control "$sample" "${CONTROL_MAP_FILE:-}" 2>/dev/null)"; then
  if sample_is_control "$sample" "${CONTROL_MAP_FILE:-}"; then
    printf 'Skipping SEACR for control-only sample %s\n' "$sample"
    exit 0
  fi
  printf 'No control mapping found for non-control sample %s\n' "$sample" >&2
  exit 1
fi

printf 'Running SEACR for sample %s with control %s\n' "$sample" "$control"

bash "$SEACR_SCRIPT" \
  "$projPath/alignment/bedgraph/${sample}_bowtie2.fragments.normalized.bedgraph" \
  "$projPath/alignment/bedgraph/${control}_bowtie2.fragments.normalized.bedgraph" \
  non stringent \
  "$projPath/peakCalling/SEACR/${sample}_seacr_control.peaks"

bash "$SEACR_SCRIPT" \
  "$projPath/alignment/bedgraph/${sample}_bowtie2.fragments.normalized.bedgraph" \
  0.01 \
  non stringent \
  "$projPath/peakCalling/SEACR/${sample}_seacr_top0.01.peaks"
