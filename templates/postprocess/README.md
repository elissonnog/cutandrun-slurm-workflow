# Optional Post-processing Templates

These templates are optional and are not required for the core 1-9 CUT&RUN workflow.

Included scripts:

10. `10_make_bigwig.sh` - sorts mapped BAM files and generates per-sample bigWig tracks with `bamCoverage`
11. `11_plot_heatmap.sh` - runs `computeMatrix` and `plotHeatmap` on SEACR-derived peak regions

To generate these steps together with the core pipeline, run:

```bash
bin/cutandrun-init \
  --project-dir /path/to/project \
  --sample-file examples/slurm-dry-run/samples.txt \
  --experiment demo \
  --include-postprocess
```

These scripts were adapted from the original local `10_heat.sh` and `11_heat2.sh` helpers, but converted to per-sample, array-compatible templates with configurable inputs.
