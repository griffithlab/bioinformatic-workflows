#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "python", "/usr/local/bin/OptiType-1.3.2/OptiTypePipeline.py" ]

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/optitype:1.3.2
  - class: ResourceRequirement
    ramMin: 40000
    tmpdirMin: 40000
    coresMin: 8

arguments:
  - valueFrom: "optitype"
    position: 4
    prefix: "--outdir"
  - valueFrom: "--dna"
    position: 3
  - valueFrom: "optitype_dna"
    position: 5
    prefix: "--prefix"

inputs:
  fastq1:
    type: File
    inputBinding:
      position: 1
      prefix: "--input"
  fastq2:
    type: File
    inputBinding:
      position: 2

outputs:
  optitype_prediction:
    type: File
    outputBinding:
      glob: "optitype/optitype_dna_result.tsv"
  optitype_graph:
    type: File
    outputBinding:
      glob: "optitype/optitype_dna_coverage_plot.pdf"
