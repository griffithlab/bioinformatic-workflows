#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "samtools", "faidx"]

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/samtools:1.9
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.reference)
  - class: ResourceRequirement
    ramMin: 4000

inputs:
  reference:
    type: File
    inputBinding:
      valueFrom: "$(runtime.outdir)/$(inputs.reference.basename)"
      position: 1

outputs:
  referenceIndex:
    type: File
    secondaryFiles: [.fai]
    outputBinding:
      glob: $(inputs.reference.basename)
