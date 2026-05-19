# CUT&RUN Slurm Workflow

This repository is a cleaned staging copy of a local CUT&RUN workflow. It currently focuses on making the original Slurm-based analysis logic easier to review, clean up, and publish safely.

## Current Scope

Included now:

- portable Slurm templates for the core 1-9 workflow steps
- a generator for experiment-specific job scripts
- a submission helper for chained Slurm jobs
- example config files
- a generic `nf-core/cutandrun` wrapper
- validation notes for the staged code

Not included yet:

- raw data
- sample metadata
- study-specific identifiers
- a finished R package
- a finished publication-ready downstream analysis layer

## Repository Layout

- `templates/slurm/`: staged templates for steps 1-9
- `scripts/generate_experiment.pl`: generates experiment directories from the templates
- `scripts/submit_chain.pl`: submits the generated jobs with Slurm dependencies
- `config/`: example config files
- `nextflow/`: wrapper for `nf-core/cutandrun`
- `docs/validation.md`: syntax and smoke-test notes
- `docs/reference_validation.md`: reference-grounded reproducibility notes
- `docs/package_publication_plan.md`: grounded plan for turning the downstream Rmd into a reusable scientific codebase

## What Has Been Validated

- the staged shell templates parse successfully
- the Perl generator and submission helper parse successfully
- a generated demo experiment can be rendered and dry-run for dependency order
- the staged templates preserve the scientific logic of the original local 1-9 workflow closely

Important limitation:

The staged repo does **not** yet support a strong claim that it fully reproduces the original Henikoff/SEACR-style run, because the decisive experiment-specific inputs are still not pinned in the source set. See `docs/reference_validation.md`.

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

The current package and publication plan is summarized in `docs/package_publication_plan.md`.
