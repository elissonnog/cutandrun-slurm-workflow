# Slurm Dry-run Example

This example shows the minimal files needed to initialize and dry-run a Slurm experiment bundle.

Generate a demo experiment:

```bash
bin/cutandrun-init \
  --project-dir /path/to/project \
  --sample-file examples/slurm-dry-run/samples.txt \
  --experiment demo_run \
  --include-postprocess
```

Then replace `demo_run/control_map.tsv` with `examples/slurm-dry-run/control_map.tsv.example` or edit it in place, update `demo_run/pipeline.env`, and run:

```bash
bin/cutandrun-submit --experiment-dir demo_run --dry-run
```
