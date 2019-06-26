#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/picard:2.20.2
  - class: ResourceRequirement
    ramMin: 24000

baseCommand: [ "java", "-Xmx24g", "-jar", "/usr/bin/picard/picard.jar", "MergeBamAlignment"]

arguments:
  - valueFrom: "alignmentMerge.bam"
    position: 1
    prefix: "OUTPUT="

inputs:
  aligned:
    type: File
    inputBinding:
      position: 2
      prefix: "ALIGNED="
  unmapped:
    type: File
    inputBinding:
      position: 3
      prefix: "UNMAPPED="
  reference_sequence:
    type: File
    secondaryFiles: [ ^.dict ]
    inputBinding:
      position: 4
      prefix: "REFERENCE_SEQUENCE="
  sort_order:
    type: string
    inputBinding:
      position: 5
      prefix: "SORT_ORDER="

outputs:
  mergedBamAlignment:
    type: File
    outputBinding:
      glob: "alignmentMerge.bam"
