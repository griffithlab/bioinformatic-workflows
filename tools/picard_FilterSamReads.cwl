#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/picard:2.20.2
  - class: ResourceRequirement
    ramMin: 24000

baseCommand: [ "java", "-Xmx22g", "-jar", "/usr/bin/picard/picard.jar", "FilterSamReads"]

arguments:
  - valueFrom: "FilterSamReads.bam"
    position: 2
    prefix: OUTPUT=
  - valueFrom: "LENIENT"
    position: 5
    prefix: "VALIDATION_STRINGENCY="

inputs:
  INPUT:
    type: File
    inputBinding:
      position: 1
      prefix: I=
  READ_LIST_FILE:
    type: File?
    inputBinding:
      position: 3
      prefix: READ_LIST_FILE=
  FILTER:
    type: string?
    inputBinding:
      position: 4
      prefix: FILTER=

outputs:
  readnameFilteredBam:
    type: File
    outputBinding:
      glob: FilterSamReads.bam
