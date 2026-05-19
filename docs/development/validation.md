# Validation Notes

Validation was performed on a temporary staging copy of this repo.

## Passed

- `bash -n bin/cutandrun-init`
- `bash -n bin/cutandrun-submit`
- `perl -c scripts/generate_experiment.pl`
- `perl -c scripts/submit_chain.pl`
- `bash -n templates/slurm/common.sh`
- `bash -n templates/slurm/*.sh`
- `bash -n templates/postprocess/*.sh`
- `bash -n nextflow/*.sh`

## Smoke Test

The tracked smoke-test entrypoint is:

- `tests/smoke/run_slurm_smoke.sh`

It checks:

- repo entrypoint syntax
- template syntax
- generated experiment syntax
- dry-run submission ordering

## Not Executed

The workflow was not run end-to-end because that would require:

- real FASTQ inputs
- real reference indexes and chromosome sizes
- a Slurm environment
- installed runtime tools such as `fastqc`, `bowtie2`, `samtools`, `bedtools`, `picard`, `nextflow`, `SEACR`, and optional `deepTools`
