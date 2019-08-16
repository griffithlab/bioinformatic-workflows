#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "cat HLA and actual reference together"
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:18.04
  - class: ResourceRequirement
    ramMin: 8000

baseCommand: cat

inputs:
  HLARef:
    type: File
    inputBinding:
      position: 1
  speciesRef:
    type: File
    inputBinding:
      position: 2

outputs:
  hlaReference:
    type: stdout

stdout: hla_ref.fa
