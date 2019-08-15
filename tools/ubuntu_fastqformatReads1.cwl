#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "format reads from a fastq file for input to picard FilterSamReads"
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: ubuntu:18.04

baseCommand: cat

inputs:
  fastq:
    type: File
    streamable: true
    inputBinding:
      position: -1

arguments:
  - valueFrom: "|"
    shellQuote: False
  - "awk"
  - "{if(NR%4==1) print $0}"
  - valueFrom: "|"
    shellQuote: False
  - "sed"
  - "s/^@//"
  - valueFrom: "|"
    shellQuote: False
  - "sed"
  - "s/\/\(1\|2\)$//"

outputs:
  readnames:
    type: stdout

stdout: readnames.txt
