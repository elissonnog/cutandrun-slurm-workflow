# Nextflow Helpers

This directory provides a lightweight wrapper around `nf-core/cutandrun` for users who want a more standard workflow-engine execution path in parallel with the Slurm-template pipeline.

Files:

- `run_nfcore_cutandrun.sh` - runs `nf-core/cutandrun` from a configuration env file
- `submit_nfcore_cutandrun.sh` - submits the wrapper to Slurm when `sbatch` is available, or runs directly otherwise
- `nextflow.config` - optional cluster tuning layer consumed by the wrapper

Start from `config/nextflow.env.example` and `examples/nextflow/samplesheet.csv`.
