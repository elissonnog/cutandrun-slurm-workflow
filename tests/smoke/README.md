# Smoke Tests

These checks validate script syntax, experiment rendering, and Slurm dependency
ordering without submitting jobs.

Main script:

- `run_slurm_smoke.sh` - syntax-checks the repo entrypoints, generates a demo experiment, and dry-runs the Slurm submission chain
