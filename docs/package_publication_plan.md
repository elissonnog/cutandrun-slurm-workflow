# Downstream Package And Publication Plan

This note summarizes what the current CUT&RUN source set supports for a reusable package and for publication, based on direct inspection of the staged workflow, the original local automation scripts, and the downstream R Markdown analysis.

## Current Assessment

What is already supported by the code:

- the staged Slurm workflow is a faithful cleanup of the original numbered 1-9 CUT&RUN processing logic
- the workflow is scientifically useful as a reusable lab pipeline after the experiment-specific inputs are pinned
- `cutandrun_downstream.Rmd` contains real reusable analysis functions, especially for:
  - coordinate-based count extraction
  - network characterization
  - cluster and network enrichment

What is **not** yet supported:

- a claim that the staged repo alone exactly reproduces the original reference run
- a claim that the downstream Rmd is already a package
- a strong standalone software-paper claim

## Why The Rmd Is Not A Package Yet

The downstream notebook has real package potential, but it is still an analysis document rather than a library.

Main blockers identified in the current file:

- hard-coded absolute paths and local files
- global objects passed implicitly across chunks
- plotting, export, and compute logic mixed together
- a large dependency surface
- human-specific assumptions and mixed reference assumptions
- interactive calls such as `View()` and runtime-install patterns

Reusable function groups already present in the notebook include:

- `subset_norm_counts()`
- `characterize_global_network()`
- `characterize_nodes()`
- `characterize_clusters()`
- `perform_cluster_enrichment()`
- `perform_network_enrichment()`
- `perform_enrichr_network_enrichment()`
- `perform_wikipathways_analysis()`

These are the best candidates for extraction into `R/` files first.

## Best Scientific Framing

The strongest near-term framing is:

- a companion computational resource for a biology paper

This framing is stronger than:

- a standalone methods paper
- a general-purpose software platform claim

Why this framing fits best:

- the workflow is useful and real, but much of its value is in applying CUT&RUN processing and downstream interpretation to a specific biological question
- the current Nextflow layer is partly a wrapper around `nf-core/cutandrun`, so the novelty is not mainly in inventing a new aligner or peak caller
- the downstream Rmd is strongest as a structured interpretation layer for CUT&RUN results, especially if narrowed to one coherent analytic theme

## Recommended Publication Route

Most realistic order of operations:

1. publish a clean GitHub repository for the processing workflow
2. refactor the downstream Rmd into a narrow research package on GitHub
3. use both as the computational companion to a biological manuscript or preprint

Possible later route:

- a Bioconductor-style package submission after the package has stable inputs, tests, examples, and public documentation

Less realistic right now:

- CRAN-first release
- a software-only preprint without a strong biological application or public benchmark

## Minimum Evidence Needed Before Preprint

Before a serious preprint or companion methods section, the codebase should include:

1. one canonical example that reproduces at least one figure, table, or key analysis output from public or shareable data
2. pinned reference assets and runtime versions for the processing workflow
3. a stable sample manifest and treatment-control mapping format
4. extracted package functions with explicit inputs and outputs
5. tests for the core analysis helpers
6. one second dataset or reanalysis showing the approach is not locked to a single internal project

## Practical Development Plan

### Phase 1: Finish The GitHub Workflow Repo

Goal:

- make the processing layer public-facing and reproducible enough for outside readers

Tasks:

- pin the exact genome, spike-in, chromosome-size, and SEACR reference assets
- document the exact control-map format
- capture the runtime versions or module versions that match the original runs
- keep the current caveat that duplicate removal is generated but not used for peak calling unless the pipeline logic is changed
- add one small public example or dry-run walkthrough

Exit criteria:

- an outside user can understand the workflow inputs, job order, and required references without reading local lab notes

### Phase 2: Extract A Narrow Analysis Package

Goal:

- convert the strongest reusable parts of `cutandrun_downstream.Rmd` into a small research package

Recommended scope for version 0.1:

- network characterization of CUT&RUN-derived feature sets
- cluster-wise and network-wise enrichment helpers
- utilities that join peak-level results to normalized count matrices

Tasks:

- move reusable functions into standalone `R/` scripts
- replace global state with explicit function arguments
- separate compute functions from plots and file export
- build a small toy dataset
- add unit tests for the extracted functions
- rebuild the Rmd as a vignette or worked example instead of the source of truth

Exit criteria:

- the package can be installed locally and its main functions run from a clean R session on example data

### Phase 3: Prepare The Publication Layer

Goal:

- make the repository scientifically convincing as a companion resource

Tasks:

- define the biological question the package answers better than a generic notebook
- show one end-to-end example from processed counts to interpretable network or enrichment results
- test the same analysis logic on a second dataset
- decide whether the preprint centers on the biology, with the software as infrastructure, or on the reproducible workflow itself

Exit criteria:

- the GitHub repo and manuscript figures tell the same story and can be traced to the same code paths

## Bottom Line

This project has real scientific value, but its strongest path is not "publish the current Rmd as-is." The best route is:

- clean CUT&RUN workflow repo first
- narrow GitHub research package second
- preprint or manuscript companion resource third

That path is realistic and publishable if the reproducibility layer is pinned and the downstream Rmd is reduced to a clear, reusable analytic core.
