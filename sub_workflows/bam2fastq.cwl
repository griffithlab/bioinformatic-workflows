#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "bam to fastq conversion workflow"
requirements:
    - class: SubworkflowFeatureRequirement

inputs:
  bam:
    type: File
    doc: bam file to convert to fastq, also takes sam/cram

outputs:
  fastq1:
    type: File
    outputSource: sam2fastq/fastq1
  fastq2:
    type: File
    outputSource: sam2fastq/fastq2

steps:
  convert2bam:
    run: ../tools/convert2bam.cwl
    in:
      file: bam
    out: [ bam_file ]
  namesortbam:
    run: ../tools/samtools_sort.cwl
    in:
      bam_file: convert2bam/bam_file
    out: [ sorted_bam ]
  sam2fastq:
    run: ../tools/sam2fastq.cwl
    in:
      bam_file: namesortbam/sorted_bam
    out: [ fastq1, fastq2 ]
