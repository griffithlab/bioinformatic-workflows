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
  hla_reference:
    type: File
    doc: HLA reference to use for pre-filtering reads

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
  optitypePreFilterR1:
    run: ../sub_workflows/optitypePreFilter.cwl
    in:
      fastq: bam2fastq/fastq1
      reference: hla_reference
    out: [ CandidateHLAFastq ]
  optitypePreFilterR2:
    run: ../sub_workflows/optitypePreFilter.cwl
    in:
      fastq: bam2fastq/fastq2
      reference: hla_reference
    out: [ CandidateHLAFastq ]
  optitype:
    run: ../tools/optitype.cwl
    in:
      fastq1: optitypePreFilterR1/CandidateHLAFastq
      fastq2: optitypePreFilterR2/CandidateHLAFastq
    out: [ optitype_prediction, optitype_graph ]
