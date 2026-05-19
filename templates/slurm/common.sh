#!/usr/bin/env bash

load_cutandrun_config() {
  local script_dir env_file
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  env_file="${CUTANDRUN_CONFIG:-$script_dir/pipeline.env}"

  if [[ ! -f "$env_file" ]]; then
    printf 'Missing config file: %s\n' "$env_file" >&2
    exit 1
  fi

  # shellcheck disable=SC1090
  source "$env_file"

  FASTQ_DIR="${FASTQ_DIR:-$projPath/../fastq}"
  READ1_SUFFIX="${READ1_SUFFIX:-_L000_R1_001.fastq.gz}"
  READ2_SUFFIX="${READ2_SUFFIX:-_L000_R2_001.fastq.gz}"
  CONTROL_MAP_FILE="${CONTROL_MAP_FILE:-$script_dir/control_map.tsv}"
}

load_module_if_set() {
  local module_name="${1:-}"
  if [[ -z "$module_name" ]]; then
    return 0
  fi

  if command -v module >/dev/null 2>&1; then
    module load "$module_name"
  else
    printf 'Skipping module load because environment modules are unavailable: %s\n' "$module_name" >&2
  fi
}

require_var() {
  local var_name="$1"
  if [[ -z "${!var_name:-}" ]]; then
    printf 'Required variable %s is not set\n' "$var_name" >&2
    exit 1
  fi
}

lookup_control() {
  local sample_name="$1"
  local control_map_file="$2"
  local control_name

  if [[ ! -f "$control_map_file" ]]; then
    printf 'Missing control map: %s\n' "$control_map_file" >&2
    exit 1
  fi

  control_name="$(
    awk -F'\t' -v sample="$sample_name" '
      BEGIN { OFS = FS }
      NR == 1 && $1 == "sample" && $2 == "control" { next }
      $1 == sample { print $2; exit }
    ' "$control_map_file"
  )"

  if [[ -z "$control_name" ]]; then
    printf 'No control mapping found for sample %s in %s\n' "$sample_name" "$control_map_file" >&2
    exit 1
  fi

  printf '%s\n' "$control_name"
}
