#!/usr/bin/env bash
#SBATCH --job-name=fastQC
#SBATCH -o fastq_%A_%a.out
#SBATCH -e fastq_%A_%a.err
#SBATCH --partition long
#SBATCH --ntasks 8
#SBATCH --time 24:00:00
#SBATCH --mem=96G
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config
load_module_if_set "${FASTQC_MODULE:-}"

mkdir -p "$projPath/fastq_output"

fastqc --outdir "$projPath/fastq_output" -f fastq "$FASTQ_DIR/${sample}${READ1_SUFFIX}"
fastqc --outdir "$projPath/fastq_output" -f fastq "$FASTQ_DIR/${sample}${READ2_SUFFIX}"
