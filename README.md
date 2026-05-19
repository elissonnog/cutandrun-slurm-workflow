# CUT&RUN Slurm Workflow

This repository packages a cleaned CUT&RUN/CUT&Tag-style processing workflow for Slurm users, with spike-in normalization, SEACR peak calling, optional deepTools post-processing, and a secondary `nf-core/cutandrun` wrapper for users who prefer a workflow-engine path.

The code originated from a local CUT&RUN analysis tree and has been refactored into a more generic, GitHub-appropriate bioinformatics repository.

## Highlights

- core numbered Slurm workflow for alignment, fragment processing, spike-in normalization, and SEACR peak calling
- experiment generator for rendering array-compatible job scripts from templates
- automatic chained submission helper that discovers numbered steps
- optional deepTools-derived post-processing for bigWig generation and SEACR heatmaps
- generic Nextflow wrappers for `nf-core/cutandrun` as a secondary execution path
- reproducibility templates for references and software versions

## Choose Your Workflow

- Primary path: the numbered Slurm workflow built from `bin/cutandrun-init` and `bin/cutandrun-submit`
- Secondary path: the `nf-core/cutandrun` wrapper in `nextflow/`

## Current Scope

Included now:

- portable Slurm templates for the core 01-09 workflow steps
- optional post-processing templates derived from the original heatmap helpers
- a generator for experiment-specific job scripts
- a submission helper for chained Slurm jobs
- example config files
- generic `nf-core/cutandrun` run and Slurm-submit wrappers
- tracked smoke-test assets and development notes

Not included yet:

- raw data
- sample metadata
- study-specific identifiers
- a finished R package extracted from the downstream R Markdown
- a finished publication-ready downstream analysis layer

## Workflow Summary

Core processing:

1. FASTQ QC with `FastQC`
2. genome alignment with `Bowtie2`
3. spike-in alignment with `Bowtie2`
4. duplicate marking/removal with `Picard`
5. fragment-length summary with `SAMtools`
6. SAM/BAM/BED conversion with `SAMtools` and `BEDTools`
7. fragment bin counting
8. spike-in normalization to bedGraph
9. peak calling with `SEACR`

Optional post-processing:

10. bigWig generation with `bamCoverage`
11. SEACR heatmap generation with `computeMatrix` and `plotHeatmap`

## Main Entry Points

- Slurm generator: `bin/cutandrun-init`
- Slurm submitter: `bin/cutandrun-submit`
- Core templates: `templates/slurm/`
- Optional post-processing templates: `templates/postprocess/`
- Nextflow direct runner: `nextflow/run_nfcore_cutandrun.sh`
- Nextflow Slurm wrapper: `nextflow/submit_nfcore_cutandrun.sh`

## Quick Start

See:

- `docs/quickstart.md`
- `docs/inputs.md`
- `docs/outputs.md`
- `docs/reproducibility.md`

Minimal Slurm workflow:

```bash
bin/cutandrun-init \
  --project-dir /path/to/project \
  --sample-file examples/slurm-dry-run/samples.txt \
  --experiment demo_run
```

Then dry-run the submission chain:

```bash
bin/cutandrun-submit --experiment-dir demo_run --dry-run
```

## Repository Layout

- `bin/`: user-facing command entrypoints
- `templates/slurm/`: staged templates for steps 01-09
- `templates/postprocess/`: optional bigWig and heatmap templates adapted from the original local helpers
- `scripts/`: implementation scripts used by the `bin/` wrappers
- `config/`: example config files
- `nextflow/`: wrappers for `nf-core/cutandrun`
- `examples/`: minimal dry-run examples for Slurm and Nextflow
- `tests/smoke/`: tracked smoke-test assets
- `docs/reproducibility.md`: checklist for pinning references and software versions
- `docs/development/`: validation and publication-planning notes

## What Has Been Validated

- the staged shell templates parse successfully
- the optional post-processing templates parse successfully
- the Slurm entrypoints and implementation scripts parse successfully
- the Nextflow wrappers parse successfully
- a generated demo experiment can be rendered and dry-run for dependency order, including optional post-processing steps
- the staged templates preserve the scientific logic of the original local 1-9 workflow closely

Important limitation:

The staged repo does **not** yet support a strong claim that it fully reproduces the original Henikoff/SEACR-style run, because the decisive experiment-specific inputs are still not pinned in the source set. See `docs/development/reference_validation.md`.

## Reference Basis

The local source README identifies the original lineage as:

- Henikoff-style CUT&RUN protocol runs for CTCF and histone marks
- later `nf-core/cutandrun` runs for some merged and split analyses

External method references that align with this workflow:

- [Improved CUT&RUN chromatin profiling tools](https://elifesciences.org/articles/46314)
- [nf-core/cutandrun](https://github.com/nf-core/cutandrun)
- [Bioconductor package submission guide](https://contributions.bioconductor.org/bioconductor-package-submissions.html)
- [JOSS review criteria](https://joss.readthedocs.io/en/latest/review_criteria.html)

## Status

This is not a finished public software release yet. The main next steps are:

1. pin the exact reference assets, sample/control mappings, and runtime versions needed for reproducibility
2. decide whether the downstream Rmd should become:
   - a companion analysis notebook
   - a narrower GitHub research package
   - or a longer-term Bioconductor-style package
3. choose a publishable framing, which currently looks strongest as a companion computational resource for a biology paper rather than a standalone methods paper

The current package and publication plan is summarized in `docs/development/publication-roadmap.md`.
