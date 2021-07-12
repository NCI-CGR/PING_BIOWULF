## vim: ft=python
import sys
import os

shell.prefix("set -eo pipefail; ")
configfile:"config/config.yaml"
localrules: all

run = os.getcwd() + "/"
ping = config["ping"]
raw = config["raw"]
fastq_pat = config["fastq_pat"]
out_dir = config["out_dir"]

if config["step3"]=="yes":
   rule all:
       input:
             out_dir + "/ping12.html",
             out_dir + "/ping3.html"
else:
   rule all:
       input:
             out_dir + "/ping12.html"

rule ping_12:
    input:
          directory(raw)
    output:
          out_dir + "/ping12.Rdata",
          out_dir + "/ping12.html"
    shell:
          """
          export TMPDIR=/lscratch/$SLURM_JOB_ID
          ln -s -f {ping} script/
          Rscript -e 'rmarkdown::render("script/ping12.Rmd",params=list(fastq_dir="{raw}",fastq_pat="{fastq_pat}",out_dir="{out_dir}"),output_file="{output}")' 2>log/ping12.err
          """

rule ping_3:
    input:
          rules.ping_12.output[1],
          rules.ping_12.output[0]
    output:
          out_dir + "/ping3.html"
    shell:
          """
          export TMPDIR=/lscratch/$SLURM_JOB_ID
          Rscript -e 'rmarkdown::render("script/ping3.Rmd",params=list(data="{input[1]}"),output_file="{output}")' 2>log/ping3.err 
          """ 
