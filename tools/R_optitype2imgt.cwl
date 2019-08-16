#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "convert optitype HLA calls to imgt ids"
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: zlskidmore/r-bioc-cran:3.6.0
  - class: ResourceRequirement
    ramMin: 8000

baseCommand: ["RScript", "/opt/scripts/R/optitype2imgt.R"]

arguments:
  - valueFrom: ">"
    shellQuote: False
  - "imgtID.txt"

inputs:
  optitypeCall:
    type: File
    inputBinding:
      position: -2
  imgtAlleleList:
    type: File
    inputBinding:
      position: -1

outputs:
  hlaIMGTID:
    type: string
    outputBinding:
      glob: imgtID.txt
      loadContents: true
      outputEval: $(self[0].contents)
