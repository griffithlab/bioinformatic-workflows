#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "hla typing workflow"
requirements:
  - class: SubworkflowFeatureRequirement

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
  bam2fastq:
    run: ../sub_workflows/bam2fastq.cwl
    in:
      bam: bam
    out: [fastq1, fastq2]
  optitype:
    run: ../tools/optitype.cwl
    in:
      fastq1: bam2fastq/fastq1
      fastq2: bam2fastq/fastq2
    out: [ optitype_prediction, optitype_graph ]
