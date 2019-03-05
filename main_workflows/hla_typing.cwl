#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "hla typing workflow"

inputs:
  bam:
    type: File
    doc: Bam file to make HLA predictions from

outputs:
  optitype_graph_out:
    type: File
    outputSource: optitype/optitype_graph
  optitype_prediction_out:
    type: File
    outputSource: optitype/optitype_prediction

steps:
  convert2bam:
    run: ../tools/convert2bam.cwl
    in:
      file: bam
    out: [ bam_file ]
  namesortbam:
    run: ../tools/name_sort_bam.cwl
    in:
      bam_file: convert2bam/bam_file
    out: [ sorted_bam ]
  sam2fastq:
    run: ../tools/sam2fastq.cwl
    in:
      bam_file: namesortbam/sorted_bam
    out: [ fastq1, fastq2 ]
  optitype:
    run: ../tools/optitype.cwl
    in:
      fastq1: sam2fastq/fastq1
      fastq2: sam2fastq/fastq2
    out: [ optitype_prediction, optitype_graph ]
