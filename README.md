# A workflow to run PING (Pushing Immunogenetics to the Next Generation) efficiently on NIH Biowulf
## Description
This snakemake workflow is for running the PING pipeline efficiently on NIH Biowulf.

[PING](https://github.com/wesleymarin/PING) is a R-based bioinformatic pipeline to determine killer-cell immunoglobulin-like receptor (KIR) copy number and high-resolution genotypes from short-read sequencing data.

Major steps in the workflow include:
1) Run PING extractor and gc caller
2) Run PING copy number thresholding and allele caller

## User's guide
### I. Input requirements
* Edited config/config.yaml
* fastq files

### II. Editing the config.yaml
Basic parameters:
* ping: Path to the directory where the PING pipeline is downloaded
* raw: Path to the directory where fastq files are stored
* fastq_pat: Fastq file name pattern; "fastq" or "fq"
* out_dir: Path to the output directory
* shortNameDelim: Sample ID delimiter to shorten sample ID (ID will be characters before delim, ID's must be unique or else there will be an error)

Optional parameters:
* step3: "yes" or "no"(default); to run the copy number thresholding functionality and the following allele calling; require filling the file generated from the previous step "{output_directory}/manualCopyThresholds.csv" before initiating this step; see (V. PING copy number thresholds determination) for how to determine the threshold values.
* filter: "" (default null); to filter out low reads-count samples in step3 to avoid sample failure; ONLY needed when receiveing error message : "Error in general.count_sam_header(samPath) : This sam file does not exist" when running step3; usually samples with reads count below 100 for 3DL3 as shown in the file "{output_directory}/locusCountFrame.csv" are considered as "low"; input format: "- {sampleID_1}\n- {sampleID_2}\n- {sampleID_3}\n".

### III. To run
* Clone the repository to your working directory
```bash
cd {your_working_directory}
git clone https://github.com/NCI-CGR/PING_BIOWULF.git
```
* Downlaod the PING pipeline to your desired directory
```bash
cd {your_desired_directory}
git clone https://github.com/wesleymarin/PING.git
```
* Edit and save config/config.yaml

Note: input "no" to the parameter "step3" and initiate the primary run of PING extractor and gc caller; after the primary run is completed, check the results and fill the file "{output_directory}/manualCopyThresholds.csv" with appropriate thresholds; input "yes" to the parameter "step3" and initiate the run of PING copy number thresholding and allele caller.
* To run on NIH Biowulf:
  ```bash
  bash sbatch.sh
  ```
* Look in log directory for logs for each rule; the R concole output information is recorded in Rmarkdown html files: {output_directory}/ping12.html, {output_directory}/ping3.html
* The current setting of system resource should be fine for most analysis. If more resource is needed, edit and save config/cluster_config.yaml with desired numbers of cpus, memories and running time before sbatch the job.

### IV. Example output
```bash
output
├── alignmentFiles  * Aligned SNP tables
│   ├── {sampleID}/iterAlign/
│   └── ...
├── alleleFiles
│   ├── filterFiles
│   ├── KIR2DL1_alleleSNPs.csv
│   ├── KIR2DL2_alleleSNPs.csv
│   ├── KIR2DL3_alleleSNPs.csv
│   ├── KIR2DL4_alleleSNPs.csv
│   ├── KIR2DL5_alleleSNPs.csv
│   ├── KIR2DP1_alleleSNPs.csv
│   ├── KIR2DS1_alleleSNPs.csv
│   ├── KIR2DS2_alleleSNPs.csv
│   ├── KIR2DS3_alleleSNPs.csv
│   ├── KIR2DS4_alleleSNPs.csv
│   ├── KIR2DS5_alleleSNPs.csv
│   ├── KIR3DL1_alleleSNPs.csv
│   ├── KIR3DL2_alleleSNPs.csv
│   ├── KIR3DL3_alleleSNPs.csv
│   ├── KIR3DP1_alleleSNPs.csv
│   └── KIR3DS1_alleleSNPs.csv
├── allele_setup_files
│   ├── {sampleID}.bam
│   ├── {sampleID}.fasta
│   ├── {sampleID}.refInfo.txt
│   └── ...
├── copyPlots  * Copy number graphs
│   ├── KIR2DL1_copy_number_plot_files
│   ├── KIR2DL1_copy_number_plot.html
│   ├── KIR2DL2_copy_number_plot_files
│   ├── KIR2DL2_copy_number_plot.html
│   ├── KIR2DL3_copy_number_plot_files
│   ├── KIR2DL3_copy_number_plot.html
│   ├── KIR2DL4_copy_number_plot_files
│   ├── KIR2DL4_copy_number_plot.html
│   ├── KIR2DL5_copy_number_plot_files
│   ├── KIR2DL5_copy_number_plot.html
│   ├── KIR2DP1_copy_number_plot_files
│   ├── KIR2DP1_copy_number_plot.html
│   ├── KIR2DS1_copy_number_plot_files
│   ├── KIR2DS1_copy_number_plot.html
│   ├── KIR2DS2_copy_number_plot_files
│   ├── KIR2DS2_copy_number_plot.html
│   ├── KIR2DS3_copy_number_plot_files
│   ├── KIR2DS3_copy_number_plot.html
│   ├── KIR2DS4_copy_number_plot_files
│   ├── KIR2DS4_copy_number_plot.html
│   ├── KIR2DS5_copy_number_plot_files
│   ├── KIR2DS5_copy_number_plot.html
│   ├── KIR3DL1_copy_number_plot_files
│   ├── KIR3DL1_copy_number_plot.html
│   ├── KIR3DL2_copy_number_plot_files
│   ├── KIR3DL2_copy_number_plot.html
│   ├── KIR3DP1_copy_number_plot_files
│   ├── KIR3DP1_copy_number_plot.html
│   ├── KIR3DS1_copy_number_plot_files
│   └── KIR3DS1_copy_number_plot.html
├── extractedFastq
│   ├── {sampleID}_KIR_1.fastq.gz
│   ├── {sampleID}_KIR_2.fastq.gz
│   └── ...
├── filterAlleleCalls.csv
├── filterNewAlleles.csv
├── finalAlleleCalls.csv. * Genotype output 
├── gc_bam_files
│   ├── {sampleID}.bam
│   └── ...
├── iterAlleleCalls.csv
├── iterNewAlleles.csv
├── kffCountFrame.csv
├── kffNormFrame.csv
├── kffPresenceFrame.csv
├── locusCountFrame.csv
├── locusRatioFrame.csv
├── manualCopyNumberFrame.csv  * Copy number output
├── manualCopyThresholds.csv  * Copy number thresholds table
├── ping12.html
├── ping12.Rdata
├── ping3.html
├── ping3.Rdata
└── snp_output
    ├── copy_KIR2DL1_{sampleID}_DP.csv
    ├── copy_KIR2DL1_{sampleID}_SNP.csv
    └── ...

```

### V. PING copy number thresholds determination
Open the example thresholds file provided by the PING "PING/Resources/gc_resources/manualCopyThresholds_example.csv" as a reference. Check copy number graphs in the directory "{output_directory}/copyPlots/" one by one. For each plot, use the relevant example threshold vaules as the default copy number cutoff points (y axis) for that gene. Check if all sample clusters well fit into the copy number regions separated by the default thresholds. If yes, record the threshold value to the relevant copy number region in the table "{output_directory}/manualCopyThresholds.csv"; if not, adjust the threshold value and then record it. Use the median value of copy number 1 cluster shown on the left side histogram plot as a guide to help with the threshold determination. Leave NAs to regions not shown in the graph.

#### Reference
Norman et al., Defining KIR and HLA Class I Genotypes at Highest Resolution via High-Throughput Sequencing, The American Journal of Human Genetics (2016), http://dx.doi.org/10.1016/j.ajhg.2016.06.023
