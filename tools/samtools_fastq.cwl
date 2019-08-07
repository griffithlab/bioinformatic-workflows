#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "samtools", "fastq" ]

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/samtools:1.9
  - class: ResourceRequirement
    ramMin: 8000
    coresMin: 8

arguments:
  - valueFrom: "8"
    position: 1
    prefix: "-@"

inputs:
  sam_file:
    type: File
    inputBinding:
      position: 3
  filter_flag:
    type: string?
    inputBinding:
      position: 2

outputs:
  fastqFile:
    type: stdout

stdout: filtered.fastq
