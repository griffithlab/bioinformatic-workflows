#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "Unaligned Bam to bwa-mem aligned and merged bam"
requirements:
    - class: SubworkflowFeatureRequirement
    - class: MultipleInputFeatureRequirement
    - class: StepInputExpressionRequirement

inputs:
  bwaIndex:
    type: File
    secondaryFiles: [ .amb, .ann, .bwt, .pac, .sa ]
    doc: BWA reference index for which to align reads
  bam:
    type: File
    doc: Unaligned bam file for which to align
  reference:
    type: File
    secondaryFiles: [ ^.dict ]
    doc: Reference fasta to use for merging in picard::MergeBamAlignment, should be associated with a picard sequence dictionary

outputs:
  MergedAlignedBam:
    type: File
    outputSource: indexAlignedBam/bam_index

steps:
  unalignedBAMToFastq:
    run: ../tools/picard_SamToFastq.cwl
    in:
      bam_file: bam
    out: [ fastq1, fastq2 ]
  align:
    run: ../tools/bwa_mem.cwl
    in:
      reference: bwaIndex
      fastq1: unalignedBAMToFastq/fastq1
      fastq2: unalignedBAMToFastq/fastq2
    out: [ sam_alignment ]
  convertSamToBam:
    run: ../tools/samtools_view_convert2bam.cwl
    in:
      file: align/sam_alignment
    out: [ bam_file ]
  namesortAlignedBam:
    run: ../tools/picard_SortSam.cwl
    in:
      input: convertSamToBam/bam_file
      sort_order:
        valueFrom: 'queryname'
    out: [ sorted_bam ]
  namesortUnalignedBam:
    run: ../tools/picard_SortSam.cwl
    in:
      input: bam
      sort_order:
        valueFrom: 'queryname'
    out: [ sorted_bam ]
  mergeUnalignedAndAligned:
    run: ../tools/picard_MergeBamAlignment.cwl
    in:
      aligned: namesortAlignedBam/sorted_bam
      unmapped: namesortUnalignedBam/sorted_bam
      reference_sequence: reference
      sort_order:
        valueFrom: 'coordinate'
    out: [ mergedBamAlignment ]
  indexAlignedBam:
    run: ../tools/samtools_index_bam.cwl
    in:
      bam_file: mergeUnalignedAndAligned/mergedBamAlignment
    out: [ bam_index ]
