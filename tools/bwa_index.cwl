bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/bwa:0.7.17
  - class: ResourceRequirement
    ramMin: 24000
    coresMin: 12
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.reference)

baseCommand: [ "bwa", "index"]

inputs:
  reference:
    type: File
    inputBinding:
      position: 1
      valueFrom: "$(runtime.outdir)/$(inputs.reference.basename)"

outputs:
  referenceIndex:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
    outputBinding:
      glob: $(inputs.reference.basename)
