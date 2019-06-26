#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/fgbio:0.8.1
  - class: ResourceRequirement
    ramMin: 24000

baseCommand: [ "java", "-Xmx22g", "-jar", "/usr/local/bin/fgbio.jar", "CallMolecularConsensusReads"]

arguments:
  - valueFrom: "consensus.bam"
    position: 1
    prefix: "--output"

inputs:
  input:
    type: File
    inputBinding:
      position: 2
      prefix: "--input"
  min_reads:
    type: string
    inputBinding:
      position: 3
      prefix: "--strategy"

outputs:
  consensusBam:
    type: File
    outputBinding:
      glob: "consensus.bam"
