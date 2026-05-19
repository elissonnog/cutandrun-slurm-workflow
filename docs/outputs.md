# Outputs

The Slurm workflow writes outputs under the analysis directory specified with `--project-dir`.

Key output locations:

- `fastq_output/` - FastQC reports
- `alignment/sam/` - primary and spike-in SAM files
- `alignment/bam/` - mapped BAM files
- `alignment/bed/` - fragment BED and binned fragment count files
- `alignment/bedgraph/` - spike-in-normalized bedGraphs
- `alignment/bigwig/` - optional bigWig files from step 10
- `alignment/rmDuplicate/` - duplicate-marked and duplicate-removed SAM outputs
- `peakCalling/SEACR/` - SEACR peak calls
- `qc/deeptools/` - optional deepTools matrix and heatmap outputs
