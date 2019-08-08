#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "samtools", "view" ]

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/samtools:1.9
  - class: ResourceRequirement
    ramMin: 8000
    coresMin: 8

arguments:
  - valueFrom: "1"
    position: 1
    prefix: "-@"
  - valueFrom: "-b"
    position: 2

inputs:
  bam_file:
    type: File
    secondaryFiles: [.bai]
    inputBinding:
      position: 5
  filter_flag:
    type: string
    inputBinding:
      position: 3
  filter_bed:
    type: File?
    inputBinding:
      prefix: -L
      position: 4

outputs:
  bamFile:
    type: stdout

stdout: filter.bam
