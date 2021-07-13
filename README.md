# A workflow to run PING (Pushing Immunogenetics to the Next Generation) efficiently on NIH Biowulf
## Description
This snakemake workflow is for running the PING pipeline efficiently on NIH Biowulf.

[PING](https://github.com/wesleymarin/PING) is a R-based bioinformatic pipeline to determine killer-cell immunoglobulin-like receptor (KIR) copy number and high-resolution genotypes from short-read sequencing data.

Major steps in the workflow include:
1) Run PING extractor and gc caller
2) Optionally run PING copy number thresholding and allele caller

## User's guide
### I. Input requirements
* Edited config/config.yaml
* fastq files

### II. Editing the config.yaml
Basic parameters:
* ping: Path to the directory where the PING pipeline is downloaded
* raw: Path to fastq files stored directory
* fastq_pat: Fastq file name pattern; "fastq" or "fq"
* out_dir: Path to output directory
* shortNameDelim: Sample ID delimiter to shorten sample ID (ID will be characters before delim, ID's must be unique or else there will be an error)

Optional parameters:
* step3: "yes" or "no"; to run the copy number thresholding functionality and the following allele calling; require to fill the file generated from the previous step (output_directory/manualCopyThresholds.csv) before initiating this step

### III. To run
* Clone the repository to your working directory
```bash
git clone https://github.com/NCI-CGR/PING_BIOWULF.git
```
* Downlaod the PING pipeline to your desired directory
```bash
git clone https://github.com/wesleymarin/PING.git
```
* Edit and save config/config.yaml

Note: input "no" to the parameter {step3} to initiate the primary run of PING extractor and gc caller; after the primary run is completed, check the results and fill the file (output_directory/manualCopyThresholds.csv) with appropriate thresholds; input "yes" to the parameter {step3} to initiate the optional run of PING copy number thresholding and allele caller.
* To run on NIH Biowulf:
  ```bash
  bash sbatch.sh
  ```
* Look in log directory for logs for each rule
* The current setting of system resource should be fine for most analysis. If more resource is needed, edit and save config/cluster_config.yaml with desired numbers of cpus, memories and running time before sbatch the job.

### IV. Example output
```bash

```

