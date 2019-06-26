#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/picard:2.20.2
  - class: ResourceRequirement
    ramMin: 24000

baseCommand: [ "java", "-Xmx24g", "-jar", "/usr/bin/picard/picard.jar", "SortSam"]

arguments:
  - valueFrom: "sorted.bam"
    position: 1
    prefix: "OUTPUT="

inputs:
  input:
    type: File
    inputBinding:
      position: 2
      prefix: "INPUT="
  sort_order:
    type: string
    inputBinding:
      position: 3
      prefix: "SORT_ORDER="

outputs:
  sorted_bam:
    type: File
    outputBinding:
      glob: "sorted.bam"
