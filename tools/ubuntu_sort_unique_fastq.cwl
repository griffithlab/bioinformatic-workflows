#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "unique fastq readnames"
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: ubuntu:18.04

baseCommand: cat

inputs:
  readnames1:
    type: File
    streamable: true
    inputBinding:
      position: -2
  readnames1:
    type: File
    streamable: true
    inputBinding:
      position: -1

arguments:
  - valueFrom: "|"
    shellQuote: False
  - "sort"
  - valueFrom: "|"
    shellQuote: False
  - "unique"

outputs:
  uniqueReadname:
    type: stdout

stdout: uniqueReadNames.txt
