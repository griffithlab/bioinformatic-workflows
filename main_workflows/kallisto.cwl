#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "kallisto workflow"
requirements:
  - class: SubworkflowFeatureRequirement

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
  pseudoalignment:
    type: File
    outputSource: index_bam/bam_index

steps:
  kallisto_index:
    run: ../tools/build_kallisto_index.cwl
    in:
      reference_file: reference
    out: [ kallisto_index ]
  bam2fastq:
    run: ../sub_workflows/bam2fastq.cwl
    in:
      bam: bam
    out: [fastq1, fastq2]
  kallisto_quant:
    run: ../tools/kallisto_quant.cwl
    in:
      kallisto_index: kallisto_index/kallisto_index
      fastq1: bam2fastq/fastq1
      fastq2: bam2fastq/fastq2
      firststrand: firststrand
      secondstrand: secondstrand
    out: [expression_transcript_table, expression_transcript_h5, fusions, bam_file]
  sort_bam:
    run: ../tools/sort_bam.cwl
    in:
      bam_file: kallisto_quant/bam_file
    out: [ sorted_bam ]
  index_bam:
    run: ../tools/bam_index.cwl
    in:
      bam_file: sort_bam/sorted_bam
    out: [ bam_index ]
