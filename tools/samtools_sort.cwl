#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "samtools", "sort" ]

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/samtools:1.9
  - class: ResourceRequirement
    ramMin: 28000
    coresMin: 8

arguments:
  - valueFrom: "1"
    position: 1
    prefix: "-@"
  - valueFrom: "24G"
    position: 2
    prefix: "-m"
  - valueFrom: "-n"
    position: 3

inputs:
  bam_file:
    type: File
    inputBinding:
      position: 4

outputs:
  sorted_bam:
    type: stdout

stdout: name.sorted.bam
