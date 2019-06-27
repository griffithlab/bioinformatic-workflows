#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/fgbio:0.8.1
  - class: ResourceRequirement
    ramMin: 24000

baseCommand: [ "java", "-Xmx22g", "-jar", "/usr/local/bin/fgbio.jar", "FastqToBam"]

arguments:
  - valueFrom: "demuxUMI.bam"
    position: 1
    prefix: "--output"

inputs:
  input:
    type: File[]
    inputBinding:
      position: 2
      prefix: "--input"
  read_structures:
    type: string[]
    inputBinding:
      position: 3
      prefix: "--read-structures"
  sample:
    type: string
    inputBinding:
      position: 4
      prefix: "--sample"
  library:
    type: string
    inputBinding:
      position: 4
      prefix: "--library"
  sequencing_center:
    type: string
    inputBinding:
      position: 4
      prefix: "--sequencing-center"

outputs:
  UMIunmappedBam:
    type: File
    outputBinding:
      glob: "demuxUMI.bam"
