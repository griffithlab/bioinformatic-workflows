#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "bam to fastq conversion workflow"
requirements:
    - class: SubworkflowFeatureRequirement

inputs:
  bam:
    type: File
    doc: Aligned coordinate sorted bam/sam/cram file for which to extract hla reads
  filter_bed:
    type: File
    doc: A bed file for samtools to filter against when extracting HLA reads, should contain chr6/6 and any HLA sequencing for which the original bam has been aligned to.

outputs:
  hlaBam:
    type: File
    outputSource: mergeBams/mergedBam
    secondaryFiles: [.bai]
  unmappedBam:
    type: File
    outputSource:  extractUnmappedReadPairs/bamFile
  1matemapped:
    type: File
    outputSource:  extractUnmappedReadWithMappedMate/bamFile
  2matemapped:
    type: File
    outputSource:  extractMappedReadWithUnmappedMate/bamFile
  bothmapped:
    type: File
    outputSource:  extractMappedReadWithMappedMate/bamFile

steps:
  convert2bam:
    run: ../tools/convert2bam.cwl
    in:
      file: bam
    out: [ bam_file ]
  index_bam:
    run: ../tools/bam_index.cwl
    in:
      bam_file: convert2bam/bam_file
    out: [ bam_index ]
  extractUnmappedReadPairs:
    run: ../tools/filterBam.cwl
    in:
      bam_file: index_bam/bam_index
      filter_flag:
        valueFrom: "-f 12"
    out: [ bamFile ]
  extractUnmappedReadWithMappedMate:
    run: ../tools/filterBam.cwl
    in:
      bam_file: index_bam/bam_index
      filter_flag:
        valueFrom: "-f 4 -F 8"
      filter_bed: filter_bed
    out: [ bamFile ]
  extractMappedReadWithUnmappedMate:
    run: ../tools/filterBam.cwl
    in:
      bam_file: index_bam/bam_index
      filter_flag:
        valueFrom: "-f 8 -F 4"
      filter_bed: filter_bed
    out: [ bamFile ]
  extractMappedReadWithMappedMate:
    run: ../tools/filterBam.cwl
    in:
      bam_file: index_bam/bam_index
      filter_flag:
        valueFrom: "-F 12"
      filter_bed: filter_bed
    out: [ bamFile ]
  mergeBams:
    run: ../tools/mergeBams.cwl
    in:
      bamFiles: [extractUnmappedReadPairs/bamFile,
                 extractUnmappedReadWithMappedMate/bamFile,
                 extractMappedReadWithUnmappedMate/bamFile,
                 extractMappedReadWithMappedMate/bamFile]
    out: [ mergedBam ]
  index_bam:
    run: ../tools/bam_index.cwl
    in:
      bam_file: mergeBams/mergedBam
    out: [ bam_index ]
