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
  pseudoalignment:
    type: File
    outputSource: index_bam/bam_index

steps:
  kallisto_index:
    run: build_kallisto_index.cwl
    in:
      reference_file: reference
    out: [ kallisto_index ]
  convert2bam:
    run: convert2bam.cwl
    in:
      file: bam
    out: [ bam_file ]
  namesortbam:
    run: name_sort_bam.cwl
    in:
      bam_file: convert2bam/bam_file
    out: [ sorted_bam ]
  sam2fastq:
    run: sam2fastq.cwl
    in:
      bam_file: namesortbam/bam_file
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
  sort_bam:
    run: sort_bam.cwl
    in:
      bam_file: kallisto_quant/bam_file
    out: [ sorted_bam ]
  index_bam:
    run: bam_index.cwl
    in:
      bam_file: sort_bam/sorted_bam
    out: [ bam_index ]
