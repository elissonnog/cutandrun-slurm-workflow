# Reproducibility Checklist

This repository preserves the local workflow logic, but reproducibility still depends on pinning the exact assets used for a given run.

For each run, record:

1. genome Bowtie2 index prefix
2. spike-in Bowtie2 index prefix
3. chromosome sizes file
4. SEACR script path and version
5. exact tool or module versions
6. sample list used for the run
7. treatment-to-control map used for SEACR

Helpful templates:

- `config/reference_manifest.tsv.example`
- `config/software_versions.tsv.example`

Recommended practice:

- keep a filled-in copy of both templates with each analysis release
- archive the exact `pipeline.env` and `control_map.tsv` used for the run
- keep the generated experiment directory or an exported manifest of the rendered scripts
