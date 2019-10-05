#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "Cellranger count and aggr subworkflow."

requirements:
  - class: ScatterFeatureRequirement        

inputs:
    fastq_directory:
        type: Directory[]
    chemistry:
        type: string?
    reference:
        type: Directory
    sample_name:
        type: string[]
  
steps:
  count:
    run: /gscuser/matthewmosior/Software/cellranger_cwl/cellranger_count/tool/cellranger_count.cwl
    scatter: [fastq_directory, sample_name]
    scatterMethod: dotproduct
    in:
      chemistry: chemistry
      fastq_directory: fastq_directory
      reference: reference
      sample_name: sample_name
    out: [out_dir, molecule_info_file]
  prepare_aggr_csv:
    run: /gscuser/matthewmosior/Software/cellranger_cwl/prepare_aggr_csv/tool/prepare_aggr_csv.cwl
    in:
      out_dir: count/out_dir
      molecule_h5: count/molecule_info_file
    out:
      [aggr_csv_file]
  aggr:
    run: /gscuser/matthewmosior/Software/cellranger_cwl/cellranger_aggr/tool/cellranger_aggr.cwl
    in:
      csv_file: prepare_aggr_csv/aggr_csv_file
    out:
      [aggr_out_dir]

outputs:
  count_out_dir:
    type: Directory[]
    outputSource: count/out_dir
  count_molecule_file:
    type: File[]
    outputSource: count/molecule_info_file
  aggr_out_dir:
    type: Directory
    outputSource: aggr/aggr_out_dir
