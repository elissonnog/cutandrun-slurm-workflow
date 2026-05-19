# Slurm Workflow Templates

This directory contains the core numbered CUT&RUN workflow steps that are rendered into experiment-specific job scripts by `scripts/generate_experiment.pl`.

Core processing steps:

1. `01_fastqc.sh` - raw FASTQ quality control
2. `02_align_primary.sh` - primary genome alignment
3. `03_align_spikein.sh` - spike-in alignment
4. `04_mark_duplicates.sh` - duplicate marking and duplicate-removed outputs
5. `05_fragment_lengths.sh` - fragment length summary
6. `06_make_fragments_bed.sh` - SAM/BAM/BED conversion and fragment filtering
7. `07_bin_fragments.sh` - 500 bp fragment bin counting
8. `08_spikein_normalize.sh` - spike-in normalization to bedGraph
9. `09_call_peaks_seacr.sh` - SEACR peak calling against mapped controls

Shared helper:

- `common.sh` - configuration loading, control-map lookup, and file guards

Optional deepTools-derived post-processing templates live in `templates/postprocess/`.
