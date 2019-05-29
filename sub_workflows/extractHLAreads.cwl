#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "bam to fastq conversion workflow"
requirements:
    - class: SubworkflowFeatureRequirement

inputs:
  bam:
    type: File
    doc: Aligned bam/sam/cram file for which to extract hla reads
  filter_bed:
    type: File
    doc: A bed file for samtools to filter against when extracting HLA reads, should contain chr6/6 and any HLA sequencing for which the original bam has been aligned to.

outputs:
  hla_bam:
    type: File
    outputSource: exractUnmappedReadPairs/bamFile

steps:
  convert2bam:
    run: ../tools/convert2bam.cwl
    in:
      file: bam
    out: [ bam_file ]
  exractUnmappedReadPairs:
    run: ../tools/filterBam.cwl
    in:
      bam: convert2bam/bam_file
      filter_flag:
        valueFrom: "-f 12"
      filter_bed: filter_bed
    out: [ bamFile ]
  exractUnmappedReadWithMappedMate:
    run: ../tools/filterBam.cwl
    in:
      bam: convert2bam/bam_file
      filter:
        valueFrom: "-f 4 -F 8"
      filter_bed: filter_bed
    out: [ bamFile ]
  exractMappedReadWithUnmappedMate:
    run: ../tools/filterBam.cwl
    in:
      bam: convert2bam/bam_file
      filter:
        valueFrom: "-f 8 -F 4"
      filter_bed: filter_bed
    exractMappedReadWithMappedMate:
      run: ../tools/filterBam.cwl
      in:
        bam: convert2bam/bam_file
        filter:
          valueFrom: "-F 12"
        filter_bed: filter_bed
    out: [ bamFile ]
