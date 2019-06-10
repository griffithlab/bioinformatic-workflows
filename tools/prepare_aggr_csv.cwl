#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "Prepare csv file for cellranger aggr."
baseCommand: ["/bin/bash","/gscuser/matthewmosior/Software/cellranger_cwl/prepare_aggr_csv/prepare_aggr_csv.sh"]
requirements:
    - class: InlineJavascriptRequirement
    - class: ResourceRequirement
      ramMin: 32000
      coresMin: 12

inputs:
    out_dir:
        type: Directory[]
        inputBinding:
            position: 1
    molecule_h5:
        type: File[]
        inputBinding:
            position: 2
outputs:
    aggr_csv_file:
        type: File
        outputBinding:
            glob: "$(inputs.out_dir)_aggr.csv"
