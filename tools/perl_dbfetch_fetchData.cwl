perl /usr/local/bin/dbfetch.pl fetchData imgthlagen:HLA00071,HLA00001,HLA00213,HLA00381,HLA00455,HLA00430 fasta raw > hla.fa

#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "query ensembl for HLA fasta records"
requirements:
  - class: DockerRequirement
    dockerPull: zlskidmore/perl-cpanm:5.28.2

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

outputs:
  hlaReference:
    type: stdout

stdout: imgtHLA.fa
