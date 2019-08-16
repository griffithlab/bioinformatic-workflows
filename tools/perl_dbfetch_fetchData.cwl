#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "query ensembl for HLA fasta records"
requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/perl-cpanm:5.28.2
  - class: ResourceRequirement
    ramMin: 8000

baseCommand: ["perl", "/usr/local/bin/dbfetch.pl", "fetchData"]

arguments:
  - valueFrom: "fasta"
    position: 2
  - valueFrom: "raw"
    position: 3

inputs:
  imgtIDHLA:
    type: string
    inputBinding:
      position: 1
      prefix: "imgthlagen:"
      separate: false

outputs:
  hlaReference:
    type: stdout

stdout: imgtHLA.fa
