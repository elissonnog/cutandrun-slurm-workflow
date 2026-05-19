# Quick Start

This repository supports two execution modes:

1. a Slurm-template workflow derived from the original local CUT&RUN 1-9 scripts
2. a generic wrapper around `nf-core/cutandrun`

## Option 1: Slurm Workflow

Generate an experiment directory:

```bash
bin/cutandrun-init \
  --project-dir /path/to/project \
  --sample-file examples/slurm-dry-run/samples.txt \
  --experiment demo_run
```

Optional: include deepTools-derived post-processing:

```bash
bin/cutandrun-init \
  --project-dir /path/to/project \
  --sample-file examples/slurm-dry-run/samples.txt \
  --experiment demo_run \
  --include-postprocess
```

Then edit:

- `demo_run/pipeline.env`
- `demo_run/control_map.tsv`

Dry-run the submission chain:

```bash
bin/cutandrun-submit --experiment-dir demo_run --dry-run
```

Submit the workflow:

```bash
bin/cutandrun-submit --experiment-dir demo_run
```

## Option 2: nf-core/cutandrun

Copy and edit:

- `config/nextflow.env.example`
- `examples/nextflow/samplesheet.csv`

Run directly:

```bash
bash nextflow/run_nfcore_cutandrun.sh config/nextflow.env
```

Or submit through Slurm:

```bash
bash nextflow/submit_nfcore_cutandrun.sh config/nextflow.env
```
