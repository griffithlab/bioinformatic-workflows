#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/bwa:0.7.17
  - class: ResourceRequirement
    ramMin: 8000
    coresMin: 12

baseCommand: [ "bwa", "mem"]

arguments:
  - valueFrom: "100000000"
    position: 1
    prefix: "-K"
  - valueFrom: "12"
    position: 2
    prefix: "-t"
  - valueFrom: "-Y"
    position: 3
  - valueFrom: "alignment.sam"
    position: 4
    prefix: "-o"

inputs:
  reference:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
    inputBinding:
      position: 5
  fastq:
    type: File[]
    inputBinding:
      position: 6

outputs:
  sam_alignment:
    type: File
    outputBinding:
      glob: "alignment.sam"
