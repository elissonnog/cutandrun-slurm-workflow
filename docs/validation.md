# Validation Notes

Validation was performed on a temporary staging copy of this repo.

## Passed

- `perl -c scripts/generate_experiment.pl`
- `perl -c scripts/submit_chain.pl`
- `bash -n templates/slurm/common.sh`
- `bash -n templates/slurm/1_fastqc.sh`
- `bash -n templates/slurm/2_bowtie.sh`
- `bash -n templates/slurm/3_bowtie_coli.sh`
- `bash -n templates/slurm/4_picard.sh`
- `bash -n templates/slurm/5_samtools.sh`
- `bash -n templates/slurm/6_conv.sh`
- `bash -n templates/slurm/7_conv2.sh`
- `bash -n templates/slurm/8_spike.sh`
- `bash -n templates/slurm/9_seacr.sh`
- `bash -n nextflow/run_nfcore_cutandrun.sh`

## Smoke Test

A demo experiment was generated from the example sample list and then removed after validation:

- output dir: `tests/generated_demo_v2`
- project dir: temporary demo output directory
- sample file: `config/samples.txt.example`

Checks performed:

- generated Slurm scripts were created for steps 1-9
- generated `common.sh`, `pipeline.env`, `control_map.tsv`, and `submit_chain.pl` were present
- all generated shell scripts passed `bash -n`
- `perl submit_chain.pl --dry-run` produced the expected dependency chain

## Not Executed

The workflow was not run end-to-end because that would require:

- real FASTQ inputs
- real reference indexes and chromosome sizes
- a Slurm environment
- installed runtime tools such as `fastqc`, `bowtie2`, `samtools`, `bedtools`, `picard`, `nextflow`, and `SEACR`

So this validation covers syntax, code generation, and job-chain rendering, not biological correctness on data.
