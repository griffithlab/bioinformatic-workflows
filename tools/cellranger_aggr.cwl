#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "Run Cellranger Aggregate (aggr)."

baseCommand: ["/opt/cellranger-3.0.1/cellranger","aggr"]
arguments: ["--id=test_AGGR","--localcores=$(runtime.cores)", "--localmem=$(runtime.ram/1000)","--normalize=mapped"]

requirements: 
    - class: InlineJavascriptRequirement
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
    aggr_out_dir:
        type: Directory
        outputBinding:
            glob: "/gscuser/matthewmosior/Software/cellranger_cwl/cellranger_aggr/test_AGGR" 
