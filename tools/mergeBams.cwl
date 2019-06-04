#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

label: "Samtools: merge"

baseCommand: ["samtools", "merge"]

requirements:
  - class: ResourceRequirement
    ramMin: 8000
    coresMin: 4
  - class: DockerRequirement
    dockerPull: "zlskidmore/samtools:1.9"

arguments:
  - valueFrom: "merged.bam"
    position: 1

inputs:
  bamFiles:
    type: File[]
    inputBinding:
      position: 2

outputs:
  mergedBam:
    type: File
    outputBinding:
      glob: "merged.bam"
