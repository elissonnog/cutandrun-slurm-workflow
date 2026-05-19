# Reference Validation Notes

This note summarizes what the staged CUT&RUN workflow appears to preserve from the original local source and what is still missing for a strong reproducibility claim.

## Local Reference Signal

The original local CUT&RUN README states that:

- the first CTCF runs used the Henikoff protocol
- the histone runs also used that protocol lineage
- later analyses also used `nf-core/cutandrun`

Source basis:

- the original local CUT&RUN automation README from the source tree

## What The Staged Workflow Preserves

The staged templates preserve the command-level scientific logic of the original numbered workflow closely:

- primary genome alignment
- spike-in alignment
- duplicate marking and removal outputs
- fragment-length counting
- SAM/BAM/BED conversion
- bin counting
- spike-in-scaled bedgraph generation
- SEACR peak calling against matched controls

In particular, the staged versions keep the same core defaults found in the original scripts:

- Bowtie2 primary alignment mode remains `--end-to-end --very-sensitive`
- spike-in alignment keeps `--no-overlap --no-dovetail`
- fragment filtering keeps the `<1000 bp` cutoff
- binned counting keeps `binLen = 500`
- spike-in normalization keeps the `10000 / seqDepth` scale factor logic
- SEACR is still run in `non stringent` mode

## What Prevents A Strong Reproducibility Claim

The staged workflow does **not** yet freeze the original experiment-defining inputs:

- sample manifest
- treatment-to-control mapping
- genome and spike-in Bowtie2 index paths
- chromosome sizes file
- exact SEACR script path/version
- exact module or software versions used on the original cluster

Because of that, the staged repo currently preserves workflow logic, but not a full reproducible run state.

## Important Caveat

The original pipeline computes duplicate-marked and duplicate-removed SAM files, but downstream peak-calling steps still operate on the original mapped SAM-derived path. So the workflow should **not** currently be described as a deduplicated peak-calling pipeline.

## Bottom Line

Current evidence supports this statement:

> The staged workflow is a faithful cleanup of the original local CUT&RUN 1-9 pipeline logic.

Current evidence does **not** yet support this stronger statement:

> The staged repository alone is sufficient to reproduce the original Henikoff/SEACR-style analysis exactly.

That stronger claim will require pinned configs, pinned reference assets, pinned runtime versions, and one canonical example run provenance.
