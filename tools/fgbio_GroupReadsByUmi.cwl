#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/fgbio:0.8.1
  - class: ResourceRequirement
    ramMin: 24000

baseCommand: [ "java", "-Xmx22g", "-jar", "/usr/local/bin/fgbio.jar", "GroupReadsByUmi"]

arguments:
  - valueFrom: "groupByUmi.bam"
    position: 1
    prefix: "--output"

inputs:
  input:
    type: File
    inputBinding:
      position: 2
      prefix: "--input"
  strategy:
    type: string
    inputBinding:
      position: 3
      prefix: "--strategy"
  edits:
    type: string
    inputBinding:
      position: 4
      prefix: "--edits"

outputs:
  groupedByUmi:
    type: File
    outputBinding:
      glob: "groupByUmi.bam"
