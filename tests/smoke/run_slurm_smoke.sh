#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
tmp_project="$(mktemp -d /tmp/cutandrun_project_XXXXXX)"
tmp_output="$(mktemp -d /tmp/cutandrun_demo_XXXXXX)"

bash -n "$repo_root/bin/cutandrun-init"
bash -n "$repo_root/bin/cutandrun-submit"
perl -c "$repo_root/scripts/generate_experiment.pl"
perl -c "$repo_root/scripts/submit_chain.pl"

for file in "$repo_root"/templates/slurm/common.sh "$repo_root"/templates/slurm/*.sh "$repo_root"/templates/postprocess/*.sh "$repo_root"/nextflow/*.sh; do
  bash -n "$file"
done

"$repo_root/bin/cutandrun-init" \
  --project-dir "$tmp_project" \
  --sample-file "$repo_root/examples/slurm-dry-run/samples.txt" \
  --experiment demo_run \
  --output-dir "$tmp_output" \
  --include-postprocess

cp "$repo_root/examples/slurm-dry-run/control_map.tsv.example" "$tmp_output/control_map.tsv"

for file in "$tmp_output"/*.sh; do
  bash -n "$file"
done

"$repo_root/bin/cutandrun-submit" --experiment-dir "$tmp_output" --dry-run
