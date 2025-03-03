# Workflow_Ex_2
This simple nextflow workflow accepts 2 paired end files and performs assembly with SKESA and then parallel genotyping with MLST and Quality Ananlysis with QUAST.

This script can be used as - ```nextflow run Workflow2.nf --reads <path/of/directory>/*.gz```

## Setup
You should have a environment setup that can run nextflow and docker.
The nextflow.config file should be present in the same directory as it contains the docker biocontainer paths.
