#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/picard:2.20.2
  - class: ResourceRequirement
    ramMin: 24000
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.input)

baseCommand: [ "java", "-Xmx22g", "-jar", "/usr/bin/picard/picard.jar", "CreateSequenceDictionary"]

arguments:
  - valueFrom: "sorted.bam"
    position: 1
    prefix: "OUTPUT=reference.dict"

inputs:
  input:
    type: File
    inputBinding:
      position: 2
      valueFrom: "$(runtime.outdir)/$(inputs.bam_file.basename)"
      prefix: "INPUT="

outputs:
  sorted_bam:
    type: File
    outputBinding:
      glob: "sorted.bam"
