#!/usr/bin/env nextflow

// path for input reads
params.reads = "$baseDir/*_{1,2}.fastq.gz"

workflow {
	// passing assembly_results channel to both MLST and BUSCO channel for parallel processing.
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)
    reads_ch.view { tuple -> println("Reads: $tuple") }
    assembly_results = RunSkesa(reads_ch) 
    mlst_results = RunMLST(assembly_results)
    busco_results = RunQuast(assembly_results)}

// Skesa assembly
process RunSkesa {
    input:
    tuple val(sample), path(reads)
    output:
    tuple val(sample), path("${sample}.assembly.fasta")
    script:
    """
    skesa --reads ${reads[0]} ${reads[1]} --contigs_out contigs.fasta
	mv contigs.fasta ${sample}.assembly.fasta
    """}

// Process to run MLST on the assembled genome
process RunMLST {
    input:
    tuple val(sample), path(assembly)

    output:
    path("${assembly.baseName}.mlst.txt")

    """
    mlst ${assembly} > ${assembly.baseName}.mlst.txt
    """}

// Process to run Quast on the assembled genome
process RunQuast {
    input:
    tuple val(sample), path(assembly)
    output:
    path("quast_results") 

    script:
    """
	mkdir quast_results
    quast.py ${assembly} -o quast_results
    """}


