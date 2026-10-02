# CUT&RUN workflow for Slurm

A paired-end CUT&RUN/CUT&Tag workflow for HPC systems using Slurm. The workflow
runs FASTQ QC, primary and spike-in alignment, duplicate reporting, fragment
processing, spike-in normalization, and SEACR peak calling. Optional steps
generate bigWig tracks and heatmaps with deepTools.

## Requirements

- Bash, Perl, and Slurm
- FastQC, Bowtie2, SAMtools, BEDTools, Picard, and SEACR available on `PATH`
  or through the modules configured in `pipeline.env`
- paired FASTQ files
- primary-genome and spike-in Bowtie2 indexes
- chromosome sizes, the SEACR script, and a Picard JAR
- optional: deepTools for bigWig and heatmap generation

The sample manifest contains one sample ID per line. `control_map.tsv` maps
each treatment sample to its matched control; control samples must also be in
the sample manifest.

## Run the Slurm workflow

Generate an experiment directory:

```bash
bin/cutandrun-init \
  --project-dir /path/to/analysis \
  --sample-file examples/slurm-dry-run/samples.txt \
  --experiment cutandrun_run
```

Edit `cutandrun_run/pipeline.env` and
`cutandrun_run/control_map.tsv`, then inspect the submission plan:

```bash
bin/cutandrun-submit --experiment-dir cutandrun_run --dry-run
```

Submit the dependency chain:

```bash
bin/cutandrun-submit --experiment-dir cutandrun_run
```

To include bigWig and heatmap jobs when the experiment is generated:

```bash
bin/cutandrun-init \
  --project-dir /path/to/analysis \
  --sample-file examples/slurm-dry-run/samples.txt \
  --experiment cutandrun_run \
  --include-postprocess
```

The main outputs are written below `--project-dir`:

- `fastq_output/` for FastQC reports
- `alignment/bam/`, `alignment/bed/`, and `alignment/bedgraph/`
- `peakCalling/SEACR/` for peak calls
- optional `alignment/bigwig/` and `qc/deeptools/`

Detailed input and output conventions are in
[docs/inputs.md](docs/inputs.md) and [docs/outputs.md](docs/outputs.md).

## Optional nf-core/cutandrun wrapper

```bash
cp config/nextflow.env.example config/nextflow.env
# Edit config/nextflow.env and the nf-core samplesheet first.
bash nextflow/run_nfcore_cutandrun.sh config/nextflow.env
```

The custom Slurm path and the nf-core wrapper are separate execution options.
The templates generate duplicate-marked and duplicate-removed files, but the
current fragment and peak-calling path uses the original mapped alignment.
Reference compatibility and study-specific parameters must be confirmed before
an end-to-end run.

## Contribution

Developed during my postdoctoral research at Van Andel Institute.

## References

- Meers MP, Tenenbaum D, Henikoff S. [Improved CUT&RUN chromatin profiling tools](https://elifesciences.org/articles/46314)
- [nf-core/cutandrun](https://github.com/nf-core/cutandrun)
