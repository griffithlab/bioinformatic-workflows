#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "hla typing workflow"

inputs:
  bam:
    type: File
    doc: Bam file to make HLA predictions from
  reference:
    type: File
    doc: Reference FASTA, must be HG38 and contain only chr1-22,X,Y

outputs:
  xhla:
    type: File
    outputSource: xhla/out_xhla

steps:
  xhla:
    run: xhla.cwl
    in:
      reference_file: reference
      bam_file: bam
    out: [ out_xhla ]
