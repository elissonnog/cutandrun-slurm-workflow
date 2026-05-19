#!/usr/bin/env bash
#SBATCH --job-name=picard
#SBATCH -o pica_%A_%a.out
#SBATCH -e pica_%A_%a.err
#SBATCH --time=40:00:00
#SBATCH --mem=200G
#SBATCH --ntasks=8
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config
load_module_if_set "${PICARD_MODULE:-}"
require_var PICARD_JAR

picard_tmp_dir="./tmp"
mkdir -p "$picard_tmp_dir" "$projPath/alignment/rmDuplicate/picard_summary"

picard() {
  java -Xms8g -Xmx16g -Djava.io.tmpdir="$picard_tmp_dir" -jar "$PICARD_JAR" "$@"
}

picard SortSam \
  I="$projPath/alignment/sam/${sample}_bowtie2.sam" \
  O="$projPath/alignment/sam/${sample}_bowtie2.sorted.sam" \
  SORT_ORDER=coordinate

picard MarkDuplicates \
  I="$projPath/alignment/sam/${sample}_bowtie2.sorted.sam" \
  O="$projPath/alignment/rmDuplicate/${sample}_bowtie2.sorted.dupMarked.sam" \
  METRICS_FILE="$projPath/alignment/rmDuplicate/picard_summary/${sample}_picard.dupMark.txt"

picard MarkDuplicates \
  I="$projPath/alignment/sam/${sample}_bowtie2.sorted.sam" \
  O="$projPath/alignment/rmDuplicate/${sample}_bowtie2.sorted.rmDup.sam" \
  REMOVE_DUPLICATES=true \
  METRICS_FILE="$projPath/alignment/rmDuplicate/picard_summary/${sample}_picard.rmDup.txt"
