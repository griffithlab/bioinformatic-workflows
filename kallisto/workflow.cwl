#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "kallisto workflow"

inputs:
  bam:
    type: File
    doc: bam file to grab reads from for kallisto alignment and quantification
  reference:
    type: File
    doc: reference fasta from which a kallisto index will be built
  firststrand:
    type: boolean?
  secondstrand:
    type: boolean?

outputs:
  kallisto_transcript_expression:
    type: File
    outputSource: kallisto_quant/expression_transcript_table
  kallisto_expression_transcript_h5:
    type: File
    outputSource: kallisto_quant/expression_transcript_h5
  kallisto_fusions:
    type: File
    outputSource: kallisto_quant/fusions
  kallisto_pseudoalignment:
    type: File
    outputSource: kallisto_quant/bam_file

steps:
  kallisto_index:
    run: build_kallisto_index.cwl
    in:
      reference_file: reference
    out: [ kallisto_index ]
  sam2fastq:
    run: sam2fastq.cwl
    in:
      bam_file: bam
    out: [ fastq1, fastq2 ]
  kallisto_quant:
    run: kallisto_quant.cwl
    in:
      kallisto_index: kallisto_index/kallisto_index
      fastq1: sam2fastq/fastq1
      fastq2: sam2fastq/fastq2
      firststrand: firststrand
      secondstrand: secondstrand
    out: [expression_transcript_table, expression_transcript_h5, fusions, bam_file]
    
