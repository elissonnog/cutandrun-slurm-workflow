#!/usr/bin/env bash
#SBATCH --job-name=formatConv2
#SBATCH -o conv2_%A_%a.out
#SBATCH -e conv2_%A_%a.err
#SBATCH --partition=long
#SBATCH --time=40:00:00
#SBATCH --mem=200G
#SBATCH --ntasks=8
#__CUTANDRUN_GENERATED_CONFIG__

set -euo pipefail

source "$(dirname "$0")/common.sh"
load_cutandrun_config

## We use the mid point of each fragment to infer which 500bp 
#bins does this fragment belong to.
binLen="${BIN_LENGTH:-500}"
awk -v w="$binLen" '{print $1, int(($2 + $3)/(2*w))*w + w/2}' "$projPath/alignment/bed/${sample}_bowtie2.fragments.bed" | \
sort -k1,1V -k2,2n | uniq -c | awk -v OFS="\t" '{print $2, $3, $1}' |  \
sort -k1,1V -k2,2n  > "$projPath/alignment/bed/${sample}_bowtie2.fragmentsCount.bin$binLen.bed"


#This command processes a BED file of fragment data to count the number of fragments falling into each bin of size binLen. 
#It outputs a new BED-like file where each line represents a bin with its chromosome, the center position of the bin, and the count of fragments in that bin.
