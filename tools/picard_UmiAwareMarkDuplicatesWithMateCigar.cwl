#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/picard:2.20.2
  - class: ResourceRequirement
    ramMin: 24000

baseCommand: [ "java", "-Xmx22g", "-jar", "/usr/bin/picard/picard.jar", "UmiAwareMarkDuplicatesWithMateCigar"]

arguments:
  - valueFrom: "umiAwareMrkDup.bam"
    position: 1
    prefix: "OUTPUT="
  - valueFrom: "duplicateMetrics.txt"
    position: 2
    prefix: "METRICS_FILE="
  - valueFrom: "umi_metrics.txt"
    position: 3
    prefix: "UMI_METRICS="

inputs:
  input:
    type: File
    inputBinding:
      position: 4
      prefix: "INPUT="
  assume_sort_order:
    type: string
    inputBinding:
      position: 5
      prefix: "ASSUME_SORT_ORDER="
  remove_sequencing_duplicates:
    type: string
    inputBinding:
      position: 6
      prefix: "REMOVE_SEQUENCING_DUPLICATES="

outputs:
  umiAwareMrkDupBam:
    type: File
    outputBinding:
      glob: "umiAwareMrkDup.bam"
  umiMrkDupMetrics:
    type: File
    outputBinding:
      glob: "umi_metrics.txt"
  mrkDupMetrics:
    type: File
    outputBinding:
      glob: "duplicateMetrics.txt"
