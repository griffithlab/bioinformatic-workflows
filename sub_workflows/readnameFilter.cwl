#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "filter reads from a bam file"
requirements:
    - class: SubworkflowFeatureRequirement

inputs:
  bam:
    type: File
    doc: bam file to be filtered
  fastq1:
    type: File
    doc: fastq 1 to grab reads names for filtering
  fastq2:
    type: File
    doc: fastq 2 to grab read names for filtering

outputs:
  readnameFilteredBam:
    type: File
    outputSource: filterBamByReadname/readnameFilteredBam

steps:
  extractReadName_fq1:
    run: ../tools/ubuntu_fastqformatReads1.cwl
    in:
      fastq: fastq1
    out: [ readnames ]
  extractReadName_fq2:
    run: ../tools/ubuntu_fastqformatReads1.cwl
    in:
      fastq: fastq2
    out: [ readnames ]
  uniqueFastqReadname:
    run: ../tools/ubuntu_sort_unique_fastq.cwl
    in:
      readnames1: extractReadName_fq1/readnames
      readnames2: extractReadName_fq2/readnames
    out: [ uniqueReadname ]
  filterBamByReadname:
    run: ../tools/picard_FilterSamReads.cwl
    in:
      INPUT: bam
      READ_LIST_FILE: uniqueFastqReadname/uniqueReadname
      FILTER:
        valueFrom: "includeReadList"
    out: [ readnameFilteredBam ]
