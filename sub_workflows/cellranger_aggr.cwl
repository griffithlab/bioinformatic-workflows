#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "Cellranger aggr"
#requirements:
#    - class: SubworkflowFeatureRequirement

baseCommand: ["/opt/cellranger-3.0.1/cellranger","aggr"]
arguments: ["--id=$(inputs.sample_name)_AGGR","--csv=$(inputs.csv_file)","--localcores=$(runtime.cores)","--localmem=$(runtime.ram/1000)","--normalize=mapped"]

requirements:
  - class: DockerRequirement
  dockerPull: "registry.gsc.wustl.edu/mgi/cellranger:3.0.1"
  - class: ResourceRequirement
  ramMin: 64000
  coresMin: 8

inputs:
  csv_file:
    type: File
    inputBinding:
      prefix: --csv=
      position: 1
      separate: false
    doc: "CSV file containing samples to be aggregated."
outputs:
  out_dir:
    type: Directory
    outputBinding:
      glob: "$(inputs.sample_name)_AGGR/outs/"
