#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "samtools", "sort" ]

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
  - valueFrom: "18G"
    position: 2
    prefix: "-m"

inputs:
  bam_file:
    type: File
    inputBinding:
      position: 3

outputs:
  sorted_bam:
    type: stdout

stdout: pseudoalignments.sorted.bam
