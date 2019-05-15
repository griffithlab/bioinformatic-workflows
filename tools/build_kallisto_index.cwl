#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/kallisto:0.45.1
  - class: ResourceRequirement
    ramMin: 4000

baseCommand: [ "kallisto", "index" ]

arguments:
- valueFrom: kallisto.idx
  position: 2
  prefix: --index

inputs:
  reference_file:
    type: File
    inputBinding:
      position: 2

outputs:
  kallisto_index:
    type: File
    outputBinding:
      glob: kallisto.idx
