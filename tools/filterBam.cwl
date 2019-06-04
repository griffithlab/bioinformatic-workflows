#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "samtools", "view" ]

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/samtools:1.9
  - class: ResourceRequirement
    ramMin: 20000
    coresMin: 8

arguments:
  - valueFrom: "8"
    position: 1
    prefix: "--threads"
  - valueFrom: "2G"
    position: 2
    prefix: "-m"
  - valueFrom: "-b"
    position: 3

inputs:
  bam_file:
    type: File
    secondaryFiles: [^.bai]
    inputBinding:
      position: 6
  filter_flag:
    type: string
    inputBinding:
      position: 4
  filter_bed:
    type: File
    inputBinding:
      position: 5

outputs:
  bamFile:
    type: stdout

stdout: filter.bam
