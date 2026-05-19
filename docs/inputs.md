# Inputs

## Slurm Workflow Inputs

Required files:

- `samples.txt`: one sample ID per line
- `control_map.tsv`: two-column tab-delimited map of treatment sample to matched control sample
- paired FASTQ files named as `${sample}${READ1_SUFFIX}` and `${sample}${READ2_SUFFIX}`
- genome Bowtie2 index prefix
- spike-in Bowtie2 index prefix
- chromosome sizes file
- SEACR executable
- Picard JAR

Important behavior:

- control samples should also appear in the sample manifest so that steps 1-8 generate their alignments and bedgraphs
- SEACR only runs for rows present in `control_map.tsv`; samples that only appear as controls are skipped automatically at step 9
- default FASTQ suffixes are configured in `config/pipeline.env.example`

## Nextflow Wrapper Inputs

Required files:

- `config/nextflow.env`
- `samplesheet.csv` following the `nf-core/cutandrun` schema

See:

- `config/nfcore_samplesheet.csv.example`
- `examples/nextflow/samplesheet.csv`
