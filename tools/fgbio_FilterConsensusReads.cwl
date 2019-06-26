#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/fgbio:0.8.1
  - class: ResourceRequirement
    ramMin: 24000

baseCommand: [ "java", "-Xmx22g", "-jar", "/usr/local/bin/fgbio.jar", "FilterConsensusReads"]

arguments:
  - valueFrom: "filteredConsensus.bam"
    position: 1
    prefix: "--output"

inputs:
  input:
    type: File
    inputBinding:
      position: 2
      prefix: "--input"
  ref:
    type: File
    inputBinding:
      position: 3
      prefix: "--ref"
  min_reads:
    type: string
    inputBinding:
      position: 4
      prefix: "--min-reads"
  max_base_error_rate:
    type: string
    inputBinding:
      position: 5
      prefix: "--max-base-error-rate"
  max_read_error_rate:
    type: string
    inputBinding:
      position: 6
      prefix: "--max-read-error-rate"
  min_base_quality:
    type: string
    inputBinding:
      position: 7
      prefix: "--min-base-quality"

outputs:
  filteredConsensusBam:
    type: File
    outputBinding:
      glob: "filteredConsensus.bam"
